require('dotenv').config();
const fs = require("fs");
const axios = require('axios');
const ethers = require('ethers');
// const { ethers } = require('hardhat');
const contractAbiFile = require("../artifacts/contracts/DependentOracle.sol/DependentOracle.json")

//intialize Web3 with the Url of our environment as a variable.
const provider = new ethers.providers.JsonRpcProvider(process.env.RPC)

//get contract address and abi file path from env vars.
const contractAddress = process.env.CONTRACT_ADDRESS;
// const contractAbi = JSON.parse(fs.readFileSync(process.env.ABI)).abi;

//initialize contract variable.
var contract =  new ethers.Contract(contractAddress, contractAbiFile.abi, provider);

//simple function for calling API.


async function callAPI(){
  try {
    const data = await contract.requestMultiplePrices();
      return data;
  } catch (err) {
      return "ERROR";
  }
}


async function updateDataByInput(data, jobId) {
  await contract.updateData(data, jobId);
}

async function listenForEvents() {
  while(true){
      //initialize a contract listener.
      contract.on("RequestMultipleFulfilled", async () => {
          //use lat and lon to call API.
          var data = await callAPI();
          if(data != "ERROR"){
              //send data to contract.
              const data = await contract.requestMultiplePrices();
          }
      });
  }
}

listenForEvents();

