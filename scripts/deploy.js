require('dotenv').config();
const fs = require("fs");
const axios = require('axios');
const ethers = require('ethers');
// const { ethers } = require('hardhat');
const contractAbiFile = require("../artifacts/contracts/WeatherOracle.sol/WeatherOracle.json")

//intialize Web3 with the Url of our environment as a variable.
const provider = new ethers.providers.JsonRpcProvider(process.env.RPC)

//get contract address and abi file path from env vars.
const contractAddress = process.env.CONTRACT_ADDRESS;
// const contractAbi = JSON.parse(fs.readFileSync(process.env.ABI)).abi;

//initialize contract variable.
var contract =  new ethers.Contract(contractAddress, contractAbiFile.abi, provider);
console.log(contract);
//simple function for calling API with lat and long, returning temp from JSON(see included doc link in article).


async function callAPI(){
  try {
      // const res = await axios.get(`https://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${long}&appid=${process.env.API_KEY}`);
      const res = axios({
        method: 'get',
        url: 'https://weatherapi-com.p.rapidapi.com/current.json?q=33.44%2C-94.04',
        // responseType: 'stream',
        headers:{
            "X-RapidAPI-Key": "c5317ac92emshf99b62d5c91a47ep10cf15jsnea9079ea4a43",
            "X-RapidAPI-Host": "weatherapi-com.p.rapidapi.com",
                }
      }).then(function (response) {
          console.log(response.data);
        });
      return res.data.main.temp;
  } catch (err) {
      return "ERROR";
  }
}

async function listenForEvents() {
  while(true){
      //initialize a contract listener for emmisions of the "NewJob" event, see ethers.js for docs.
      contract.on("NewJob", async (lat, lon, jobId) => {
          //use lat and lon to call API.
          var temp = await callAPI(lat, lon);
          if(temp != "ERROR"){
              //send data to updateWeather function on blockchain if temp is received.
              await contract.updateWeather(temp, jobId);
          }
      });
  }
}

listenForEvents();

// //While loop until program is canceled to continue to receive events.
// while(true){
//     //initialize a contract listener for emmisions of the "NewJob" event, see web3.js for docs.
//     contract.on("NewJob", async (lat, lon, jobId) => {
//         //use lat and lon to call API.
//         var temp = await callAPI(lat, lon);
//         if(temp != "ERROR"){
//             //send data to updateWeather function on blockchain if temp is received.
//             await contract.methods.updateWeather(temp, jobId).send();
//         }
//     })
// }