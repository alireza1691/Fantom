require('dotenv').config();
const fs = require("fs");
const axios = require('axios');
const ethers = require('ethers');
// const { ethers } = require('hardhat');
const contractAbiFile = require("../artifacts/contracts/MarketDataGetter.sol/MarketDataGetter.json")

//intialize Provider.
const provider = new ethers.providers.JsonRpcProvider(process.env.RPC)

//get contract address and abi file path from env vars.
const contractAddress = process.env.CONTRACT_ADDRESS;

//initialize contract variable.
var contract =  new ethers.Contract(contractAddress, contractAbiFile.abi, provider);
//simple function for calling API with lat and long, returning temp from JSON(see included doc link in article).


async function callAPI(){
  try {
    const bool = await contract.doSomething()
    return bool
  } catch (err) {
      return "ERROR";
  }
}

async function updateDataByInput(data, jobId) {
  await contract.updateData(data, jobId);
}

async function listenForEvents() {
  while(true){
      //initialize a contract listener for emmisions of the "NewJob" event, see ethers.js for docs.
      contract.on("NewData", async () => {
          //use lat and lon to call API.
          var data = await callAPI();
          if(data != "ERROR"){
              console.log("Do another thing");
          }
      });
  }
}

listenForEvents();

