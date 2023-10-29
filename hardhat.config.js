require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config()

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.20",
  networks:{
    xinfin: {
      url: process.env.XINFIN_NETWORK_URL,
      accounts: [process.env.PRIVATE_KEY],
    },
    
    apothem:{
      url:process.env.NETWORK_URL,
      accounts:[process.env.PRIVATE_KEY]
    },
    mumbai:{
      url:process.env.API_KEY,
      
      accounts:[process.env.PRIVATE_KEY]
    },
  }
};
