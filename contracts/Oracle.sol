
// SPDX-License-Identifier: MIT
// pragma solidity ^0.8.0;



// // // pragma solidity ^0.8.0;
pragma solidity ^0.8.17;

// Importing the Chainlink Client contract from OpenZeppelin
import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@chainlink/contracts/src/v0.8/ConfirmedOwner.sol";
  
    
abstract contract OracleContract is ChainlinkClient, ConfirmedOwner {

    event RequestFulfilled(bytes32 indexed requestId, bytes indexed data);

    using Chainlink for Chainlink.Request;

    bytes public data;
    string public image_url;
    // The address of the oracle node
    address private oracle;
    // The job ID for the Chainlink node to execute
    bytes32 private jobId;
    // The fee to pay the oracle for executing the job
    uint256 private fee;
    // The result of the oracle job
    uint256 public result;
    
    constructor() ConfirmedOwner(msg.sender) {
        // Set up the Chainlink client with a default endpoint and a link token address
        setChainlinkToken(0xfaFedb041c0DD4fA2Dc0d87a6B0979Ee6FA7af5F);
        setChainlinkOracle(0xCC79157eb46F5624204f47AB42b3906cAA40eaB7);
        
        // Set up the job ID and fee for the oracle job
        jobId = "29fa9aa13bf1468788b7cc4a500a45b8";
        fee = 0.1 * 10 ** 18; // 0.1 LINK
    }
    
     
    function requestResult() public {
        // Create a new Chainlink request with the specified parameters
        Chainlink.Request memory req = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
        
        // Set additional parameters for the request, such as API endpoint and response format
        req.add("get", "https://api.coingecko.com/api/v3/simple/price?ids=ethereum&vs_currencies=usd");
        req.add("path", "ethereum.usd");
        
        // Send the request to the oracle node and pay the fee
        sendChainlinkRequestTo(oracle, req, fee);
    }
        function requestBytes() public {
        Chainlink.Request memory req = buildChainlinkRequest(
            jobId,
            address(this),
            this.fulfillBytes.selector
        );
        req.add(
            "get",
            "https://ipfs.io/ipfs/QmZgsvrA1o1C8BGCrx6mHTqR1Ui1XqbCrtbMVrRLHtuPVD?filename=big-api-response.json"
        );
        req.add("path", "image");
        sendChainlinkRequest(req, fee);
    }
    
    function fulfill(bytes32 _requestId, uint256 _result) public recordChainlinkFulfillment(_requestId) {
        // Store the result of the oracle job in a public variable
        result = _result;
    }

    function fulfillBytes(
        bytes32 requestId,
        bytes memory bytesData
    ) public recordChainlinkFulfillment(requestId) {
        emit RequestFulfilled(requestId, bytesData);
        data = bytesData;
        image_url = string(data);
    }

}
