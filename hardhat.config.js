// require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-ethers");
require("dotenv").config()
// require("@nomicfoundation/hardhat-chai-matchers");
require("hardhat-deploy")



const FANTOM_RPC_URL = process.env.FANTOM_RPC_URL
const PRIVATE_KEY = process.env.PRIVATE_KEY

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.17",
  defaultNetwork: "hardhat",
  networks: {
      hardhat: {
          // // If you want to do some forking, uncomment this
          // forking: {
          //   url: MAINNET_RPC_URL
          // }
          chainId: 31337,
      },
      localhost: {
          chainId: 31337,
      },
      fantomTestnet: {
          url: FANTOM_RPC_URL,
          accounts: PRIVATE_KEY !== undefined ? [PRIVATE_KEY] : [],
          //   accounts: {
          //     mnemonic: MNEMONIC,
          //   },
          saveDeployments: true,
          chainId: 4002,
      },
    },
  namedAccounts: {
    deployer: {
        default: 0, // here this will by default take the first account as deployer
        1: 0, // similarly on mainnet it will take the first account as deployer. Note though that depending on how hardhat network are configured, the account 0 on one network can be different than on another
    },
    player: {
        default: 1,
    },
},

mocha: {
    timeout: 500000, // 500 seconds max for running tests
},
};
