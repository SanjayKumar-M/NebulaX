// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Nebulax is Ownable {
    IERC20 public xdcToken;
    IERC20 public rewardToken;

    constructor(address initialOwner) Ownable(initialOwner) {
        
    }

    struct User {
        uint256 depositedAmount;
        uint256 rewardsEarned;
        uint256 lastDepositTime;
    }

    mapping(address => User) public users;

    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event Reinvested(address indexed user, uint256 amount);

    // No constructor here

    function deposit(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        require(xdcToken.transferFrom(msg.sender, address(this), amount), "Transfer failed");

        User storage user = users[msg.sender];
        reinvestRewards(msg.sender);

        user.depositedAmount = user.depositedAmount + amount;
        user.lastDepositTime = block.timestamp;

        emit Deposited(msg.sender, amount);
    }

    function withdraw(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        User storage user = users[msg.sender];
        require(user.depositedAmount >= amount, "Insufficient deposited amount");
        
        reinvestRewards(msg.sender);

        user.depositedAmount = user.depositedAmount - amount;
        require(xdcToken.transfer(msg.sender, amount), "Transfer failed");

        emit Withdrawn(msg.sender, amount);
    }

    function reinvest() external {
        User storage user = users[msg.sender];
        require(user.rewardsEarned > 0, "No rewards to reinvest");
        
        uint256 rewardsToReinvest = user.rewardsEarned;
        user.rewardsEarned = 0;
        user.depositedAmount = user.depositedAmount + rewardsToReinvest;

        emit Reinvested(msg.sender, rewardsToReinvest);
    }

    function reinvestRewards(address userAddress) private {
        User storage user = users[userAddress];
        uint256 timeElapsed = block.timestamp - user.lastDepositTime;
        
        if (user.depositedAmount > 0 && timeElapsed > 0) {
            uint256 annualInterestRate = 5;
            uint256 dailyInterestRate = (annualInterestRate * 1e18) / 365 days;
            uint256 rewards = (user.depositedAmount * dailyInterestRate * timeElapsed) / 1e18;
            
            rewards = rewards + user.rewardsEarned;
            
            user.rewardsEarned = rewards;
        }
    }
}
