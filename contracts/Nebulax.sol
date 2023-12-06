// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// a simple defi yielding protocol

contract Nebulax is Ownable(msg.sender) {
    IERC20 public token;         // The token users will provide as liquidity
    IERC20 public rewardToken;   // The token used for rewards

    uint256 public totalStaked;
    uint256 public rewardRate = 1;
    mapping(address => uint256) public stakedBalances;
    mapping(address => uint256) public rewards;
    mapping(address => uint256) public lastUpdateTime;

    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event RewardClaimed(address indexed user, uint256 amount);

    uint256 public initialRewardRate = 1;  // Initial reward rate per token per second
    uint256 public maxRewardRate = 10;     // Maximum reward rate per token per second
    uint256 public rewardMultiplier = 1;   // Initial multiplier
    uint256 public maxTotalStakedForMultiplier = 100 ether;  

    constructor(address _token, address _rewardToken) {
        token = IERC20(_token);
        rewardToken = IERC20(_rewardToken);
    }

    function stake(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        require(token.transferFrom(msg.sender, address(this), amount), "Transfer failed");

        updateReward(msg.sender);
        stakedBalances[msg.sender] += amount;
        totalStaked += amount;

        // Adjust reward rate based on total staked
        if (totalStaked >= maxTotalStakedForMultiplier) {
            rewardMultiplier = maxRewardRate;
        } else {
            rewardMultiplier = initialRewardRate + (totalStaked * (maxRewardRate - initialRewardRate) / maxTotalStakedForMultiplier);
        }

        emit Staked(msg.sender, amount);
    }
     function withdraw(uint256 amount) external {
        require(stakedBalances[msg.sender] >= amount, "Insufficient staked amount");

        updateReward(msg.sender);
        stakedBalances[msg.sender] -= amount;
        totalStaked -= amount;

        require(token.transfer(msg.sender, amount), "Transfer failed");

        emit Withdrawn(msg.sender, amount);
    }

    function claimRewards() external {
        updateReward(msg.sender);
        uint256 rewardAmount = rewards[msg.sender];
        require(rewardAmount > 0, "No rewards to claim");

        rewards[msg.sender] = 0;
        require(rewardToken.transfer(msg.sender, rewardAmount), "Reward transfer failed");

        emit RewardClaimed(msg.sender, rewardAmount);
    }

     function distributeRewards() external onlyOwner {
        uint256 currentTime = block.timestamp;
        uint256 timeSinceLastUpdate = currentTime - lastUpdateTime[msg.sender];

        if (timeSinceLastUpdate > 0) {
            uint256 rewardAmount = stakedBalances[msg.sender] * rewardRate * timeSinceLastUpdate;
            rewards[msg.sender] += rewardAmount;
            lastUpdateTime[msg.sender] = currentTime;
        }
    }

    function updateReward(address account) private {
        uint256 currentTime = block.timestamp;
        uint256 timeSinceLastUpdate = currentTime - lastUpdateTime[account];

        if (timeSinceLastUpdate > 0) {
            uint256 rewardAmount = (stakedBalances[account] * rewardMultiplier * timeSinceLastUpdate) / 1e18;
            rewards[account] += rewardAmount;
            lastUpdateTime[account] = currentTime;
        }
    }
}


//0xa151660a77f223e87298de16ee5bb7447982b62f
// xdcf0cfc93266a3e41cdfddb004e9f3dce85efd9bd9 


// pragma solidity ^0.8.20;

// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";

// contract Nebulax is Ownable {
//     IERC20 public xdcToken;
//     IERC20 public rewardToken;

//     constructor(address initialOwner) Ownable(initialOwner) {
        
//     }

//     struct User {
//         uint256 depositedAmount;
//         uint256 rewardsEarned;
//         uint256 lastDepositTime;
//     }

//     mapping(address => User) public users;

//     event Deposited(address indexed user, uint256 amount);
//     event Withdrawn(address indexed user, uint256 amount);
//     event Reinvested(address indexed user, uint256 amount);

//     // No constructor here

//     function deposit(uint256 amount) external {
//         require(amount > 0, "Amount must be greater than 0");
//         require(xdcToken.transferFrom(msg.sender, address(this), amount), "Transfer failed");

//         User storage user = users[msg.sender];
//         reinvestRewards(msg.sender);

//         user.depositedAmount = user.depositedAmount + amount;
//         user.lastDepositTime = block.timestamp;

//         emit Deposited(msg.sender, amount);
//     }

//     function withdraw(uint256 amount) external {
//         require(amount > 0, "Amount must be greater than 0");
//         User storage user = users[msg.sender];
//         require(user.depositedAmount >= amount, "Insufficient deposited amount");
        
//         reinvestRewards(msg.sender);

//         user.depositedAmount = user.depositedAmount - amount;
//         require(xdcToken.transfer(msg.sender, amount), "Transfer failed");

//         emit Withdrawn(msg.sender, amount);
//     }

//     function reinvest() external {
//         User storage user = users[msg.sender];
//         require(user.rewardsEarned > 0, "No rewards to reinvest");
        
//         uint256 rewardsToReinvest = user.rewardsEarned;
//         user.rewardsEarned = 0;
//         user.depositedAmount = user.depositedAmount + rewardsToReinvest;

//         emit Reinvested(msg.sender, rewardsToReinvest);
//     }

//     function reinvestRewards(address userAddress) private {
//         User storage user = users[userAddress];
//         uint256 timeElapsed = block.timestamp - user.lastDepositTime;
        
//         if (user.depositedAmount > 0 && timeElapsed > 0) {
//             uint256 annualInterestRate = 5;
//             uint256 dailyInterestRate = (annualInterestRate * 1e18) / 365 days;
//             uint256 rewards = (user.depositedAmount * dailyInterestRate * timeElapsed) / 1e18;
            
//             rewards = rewards + user.rewardsEarned;
            
//             user.rewardsEarned = rewards;
//         }
//     }
// }

