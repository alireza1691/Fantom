require('dotenv').config();
const fs = require("fs");
const axios = require('axios');
const ethers = require('ethers');
// const { ethers } = require('hardhat');
const contractAbiFile = require("../artifacts/contracts/IndependentOracle.sol/IndependentOracle.json")

//intialize Web3 with the Url of our environment as a variable.
const provider = new ethers.providers.JsonRpcProvider(process.env.RPC)

//get contract address and abi file path from env vars.
const contractAddress = process.env.CONTRACT_ADDRESS;
const API_URL = process.env.API_URL
const X_RAPID_API_KEY = process.env.X_RAPID_API_KEY
const X_RAPID_API_HOST = process.env.X_RAPID_API_HOST
// const contractAbi = JSON.parse(fs.readFileSync(process.env.ABI)).abi;

//initialize contract variable.
var contract =  new ethers.Contract(contractAddress, contractAbiFile.abi, provider);
//simple function for calling API with lat and long, returning temp from JSON(see included doc link in article).


async function callAPI(){
  try {
      
      axios({
        method: 'get',
        url: API_URL,
        // responseType: 'stream',
        headers:{
            "X-RapidAPI-Key": X_RAPID_API_KEY,
            "X-RapidAPI-Host": X_RAPID_API_HOST,
                }
      }).then(function (response) {
          console.log( "Data:",response.data);
        });
      return response.data;
        // If we want to call API using just a URL and we have not any headers, we can replace this line instead of defining method,url and headers:
        // const res = await axios.get(`enter URL here`);
  } catch (err) {
      return "ERROR";
  }
}

callAPI()

async function updateDataByInput(data, jobId) {
  await contract.updateData(data, jobId);
}

async function listenForEvents() {
  while(true){
      //initialize a contract listener for emmisions of the "NewJob" event, see ethers.js for docs.
      contract.on("NewJob", async () => {
          //use lat and lon to call API.
          var data = await callAPI();
          if(data != "ERROR"){
              //send data to function on blockchain if data is received.
              await contract.updateData(data);
          }
      });
  }
}

listenForEvents();

