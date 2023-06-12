const { ethers, network } = require("hardhat")
const { developmentChains, VERIFICATION_BLOCK_CONFIRMATIONS } = require("../helper-hardhat-config")

 
module.exports = async () => {

    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()
    const waitBlockConfirmations = developmentChains.includes(network.name)
        ? 1
        : VERIFICATION_BLOCK_CONFIRMATIONS

    log("----------------------------------------------------")

    const OracleContract = await deploy("OracleContract", {
        from: deployer,
        args: [],
        log: true,
        waitConfirmations: waitBlockConfirmations,
    
    })

    console.log(OracleContract);
}

module.exports.tags = ["all", "Oracle"]