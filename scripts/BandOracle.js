require('dotenv').config();
const fs = require("fs");
const axios = require('axios');
const ethers = require('ethers');
// const { ethers } = require('hardhat');
const contractAbiFile = require("../artifacts/contracts/WeatherOracle.sol/WeatherOracle.json")


import {Obi, Message, Coin, Client } from '@bandprotocol/bandchain.js'

const grpcUrl = '<GRPC_WEB>' // ex.https://laozi-testnet6.bandchain.org/grpc-web
const client = new Client(grpcUrl)
const prepareGas = 100000
const executeGas = 200000
const oracleScriptId = 37
const askCount = 4
const minCount = 3
const clientId = 'from_bandchain.js'

let feeLimit = new Coin()
feeLimit.setDenom('uband')
feeLimit.setAmount('100000')


const requestMessage = new Message.MsgRequestData(
    oracleScriptId,
    calldata,
    askCount,
    minCount,
    clientId,
    sender,
    [feeLimit],
    prepareGas,
    executeGas
  )

  console.log(requestMessage);






