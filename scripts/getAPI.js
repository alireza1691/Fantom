const axios =  require('axios');
const apiKey = "YOUR_API_KEY";
const city = "New York";
const requests = require('request')
const {hre, ethers, network, getNamedAccounts} = require("hardhat");
const { getContractFactory } = require('@nomicfoundation/hardhat-ethers/types');
const { Contract } = require('hardhat/internal/hardhat-network/stack-traces/model');
const contractJsonFile = require("../artifacts/contracts/OracleContract.sol/OracleContract.json")



//   https://api.openweathermap.org/data/3.0/onecall?lat=33.44&lon=-94.04&exclude=daily&appid=b473a13b2903a006348cf4a893f56b5f

// fetch(`https://weatherapi-com.p.rapidapi.com/current.json?q=33.44%2C-94.04`)
//   .then(response => response.json())
//   .then(data => {
//     console.log(data);
//     // Do something with the data
//   })
//   .catch(error => console.error(error));


// url = "https://weatherapi-com.p.rapidapi.com/current.json?q=33.44%2C-94.04"
// headers = {
//     "API-Key": "X-RapidAPI-Key",
//     "Content-Type": "c5317ac92emshf99b62d5c91a47ep10cf15jsnea9079ea4a43",
//     "API-Key": "X-RapidAPI-Host",
//     "Content-Type": "weatherapi-com.p.rapidapi.com"
// }
// data = {
//     "param1": "location",
//     "param2": "current"
// }

// response = requests.post(url, headers=headers, json=data)
// print(response.json())

// const accounts = await ethers.getSigners()
// const deployer = accounts[0]
// const user =  accounts[1]
const provider = new ethers.providers.JsonRpcProvider(process.env.RPC)
const contractAddress = process.env.ORC_CTRC_ADD

async function getResp(){

    // As an example we trying get weather data from API
    axios({
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

        // const oracleInst = new ethers.Contract(contractAddress, contractJsonFile.abi, provider)
        // const data = await oracleInst.requestResult()
        // console.log(data);
}

getResp();
