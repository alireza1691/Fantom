
const { ethers } = require('ethers');
const oracleABI = require('./oracleABI.json');

const provider = new ethers.providers.JsonRpcProvider(process.env.INFURA_ENDPOINT);
const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);

const oracleAddress = '0x1234567890123456789012345678901234567890'; // Replace with actual oracle contract address
const oracleContract = new ethers.Contract(oracleAddress, oracleABI, wallet);

async function getWeatherData() {
  const temperature = await oracleContract.getWeatherTemperature();
  const humidity = await oracleContract.getWeatherHumidity();
  const windSpeed = await oracleContract.getWeatherWindSpeed();
  return { temperature, humidity, windSpeed };
}

async function getTrafficData() {
  const trafficVolume = await oracleContract.getTrafficVolume();
  const accidentCount = await oracleContract.getTrafficAccidentCount();
  return { trafficVolume, accidentCount };
}

async function getSportsScores() {
  const basketballScore = await oracleContract.getSportsBasketballScore();
  const footballScore = await oracleContract.getSportsFootballScore();
  const baseballScore = await oracleContract.getSportsBaseballScore();
  return { basketballScore, footballScore, baseballScore };
}
