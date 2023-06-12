// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract IndependentOracle {

    // Fantom oracle testnet address : 	0xCC79157eb46F5624204f47AB42b3906cAA40eaB7

    //mapping from jobId => completion status for smart contract interactions to check;
    //default false for all + non-existent
    mapping(uint => bool) public jobStatus;

    //mapping jobId => temp result. Defaultfor no result is 0.
    //A true jobStatus with a 0 job value implies the result is actually 0
    mapping(uint => bytes) public jobResults;

    //current jobId available
    uint jobId;

    //event to trigger Oracle API
    event NewJob(bytes data, uint jobId);

    constructor(uint initialId){
        jobId = initialId;
    } 

    function getData(bytes memory data) public {
        //emit event to API with data and JobId
        emit NewJob(data, jobId);
        //increment jobId for next job/function call
        jobId++;
    }

    function updateData(bytes memory data)public {
        //when update weather is called by node.js upon API results, data is updated
        jobResults[jobId] = data;
        jobStatus[jobId] = true;

        //Users can now check status and result via automatic view function
        //for public vars like these mappings
    }


}