
const { Provider } = require("@ethersproject/providers");
const { Contract, providers, BigNumber, ContractFactory } = require("ethers");
// const { formatEther } = require("ethers/lib/utils");
const {hre, ethers, network, getNamedAccounts} = require("hardhat");

async function main() {

  const accounts = await ethers.getSigners()
  const deployer = accounts[0]
  const user =  accounts[1]
  console.log(deployer.address,'\n',user.address);

  // Get instance of creator, then show it's address and balance

  const tokenContract = await ethers.getContract("Token")
  const tokenAddress =  tokenContract.address
    console.log("token address:",tokenAddress);
 
//   const tx = await tokenContract.deployed()
  const safeT = await ethers.getContract("SafeTreasury")
  await tokenContract.connect(deployer).approve(safeT.address, 100)
  await safeT.connect(deployer).deposit(tokenAddress, 100)
  const balanceAfterDeposit = await safeT.balance(tokenAddress, deployer.address)
  console.log(balanceAfterDeposit.toString());
  await safeT.connect(deployer).withdraw(tokenAddress, 50)
  const balanceAfterWithdraw = await safeT.balance(tokenAddress, deployer.address)
  console.log(balanceAfterWithdraw.toString());




}
// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
