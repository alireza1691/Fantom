// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@chainlink/contracts/src/v0.8/ConfirmedOwner.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * Request testnet LINK and ETH here: https://faucets.chain.link/
 * Find information on LINK Token Contracts and get the latest ETH and LINK faucets here: https://docs.chain.link/docs/link-token-contracts/
 */

/**
 * THIS IS AN EXAMPLE CONTRACT WHICH USES HARDCODED VALUES FOR CLARITY.
 * THIS EXAMPLE USES UN-AUDITED CODE.
 * DO NOT USE THIS CODE IN PRODUCTION.
 */

contract APIConsumer is ChainlinkClient, ConfirmedOwner {
    using Chainlink for Chainlink.Request;

    uint256 public dataTypeIndex;
    bytes32 private jobId;
    uint256 private fee;
    uint private typeCounter;

    event RequestData(bytes32 indexed requestId, uint256 volume, string data);

    /**
     * @notice Initialize the link token and target oracle
     *
     * Sepolia Testnet details:
     * Link Token: 0x779877A7B0D9E8603169DdbD7836e478b4624789
     * Oracle: 0x6090149792dAAeE9D1D568c9f9a6F6B46AA29eFD (Chainlink DevRel)
     * jobId: ca98366cc7314957b8c012c72f05aeeb
     *
     */
    constructor(address _chainLinkTokenAddress, address _chainlinkOracleAddress, bytes32 _jobId) ConfirmedOwner(msg.sender) {
        setChainlinkToken(_chainLinkTokenAddress);
        setChainlinkOracle(_chainlinkOracleAddress);
        // jobId = "ca98366cc7314957b8c012c72f05aeeb";
        jobId = _jobId;
        fee = (1 * LINK_DIVISIBILITY) / 10; // 0,1 * 10**18 (Varies by network and job)
    }

    mapping (uint => string) private dataTypeURL;
    mapping (uint => string) private dataTypePath;

    function addNewDataType (string memory _URL, string memory _path) external {
        dataTypeURL[typeCounter] = _URL;
        dataTypePath[typeCounter] = _path;
    }
    /**
     * Create a Chainlink request to retrieve API response, find the target
     * data, then multiply by 1000000000000000000 (to remove decimal places from data).
     */
    function requestData(uint typeIndex) public returns (bytes32 requestId) {
        Chainlink.Request memory req = buildChainlinkRequest(
            jobId,
            address(this),
            this.fulfill.selector
        );

        // Set the URL to perform the GET request on
        req.add(
            "get",
            dataTypeURL[typeIndex]
        );

    
        req.add("path", dataTypePath[typeIndex]); // Chainlink nodes 1.0.0 and later support this format

        // int256 timesAmount = 10 ** 18;
        // req.addInt("times", timesAmount);

        // Sends the request
        return sendChainlinkRequest(req, fee);
    }

    /**
     * Receive the response in the form of uint256
     */
    function fulfill(
        bytes32 _requestId,
        uint256 _index,
        string memory _data
    ) public recordChainlinkFulfillment(_requestId) {
        emit RequestData(_requestId, _index, _data);
        dataTypeIndex = _index;
    }

    /**
     * Allow withdraw of Link tokens from the contract
     */
    function withdrawLink() public onlyOwner {
        LinkTokenInterface link = LinkTokenInterface(chainlinkTokenAddress());
        require(
            link.transfer(msg.sender, link.balanceOf(address(this))),
            "Unable to transfer"
        );
    }
}
