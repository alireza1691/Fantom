// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/// @title A smart contract that works as a treasury to keep user assets safe.
/// @author Alireza Haghshenas Github: alireza1691
/// @notice This smart contract was written as a first version to test and develop and its not recommended to deploy on mainnet chains.


contract SafeTreasury is Ownable , ReentrancyGuard{

    error SafeTreasury__NotAuthorized();
    error SafeTreasury__InsufficientBalance();
    error SafeTreasury__TransactionFailed();
    error SafeTreasury__AddressNotFound();


    // Mappings:

    // Mapping to get the address who authorized another address. We need this when an authorzied address wants to withdraw or transfer funcds of another address.
mapping (address => address) private authorizedAddressesToMainAddress;
    // Mapping to get token balance of each address (token address => user address => balance)
mapping (address => mapping(address => uint256)) private tokenAddressToOwnerToBalance;


    // External functions:

    // Depist token to contract and increase balance of the address.
    /// @dev Before calling this function, to transfer ERC20 token in smart contract we need to approve the amount that smart contract can spend token.
function deposit(address tokenAddress, uint256 amount) external {
    (bool ok) = IERC20(tokenAddress).transferFrom(msg.sender, address(this), amount);
    if (!ok) {
        revert SafeTreasury__TransactionFailed();
    }
    tokenAddressToOwnerToBalance[tokenAddress][msg.sender] += amount;
}

    // Deposit native toke of the chain and the amount is msg.value.
    // NT stands for: native token
    // Note that here we assume address of native token as address(0)
function depositNT() external payable {
    tokenAddressToOwnerToBalance[address(0)][msg.sender] += msg.value;
}


    // Withdrawal of assets if amount less than balance or equal.
function withdraw (address tokenAddress, uint256 amount) external{
    if (tokenAddressToOwnerToBalance[tokenAddress][msg.sender] < amount) {
        revert SafeTreasury__InsufficientBalance();
    }
    tokenAddressToOwnerToBalance[tokenAddress][msg.sender] -= amount;
    (bool ok) = IERC20(tokenAddress).transfer(msg.sender, amount);
    if (!ok) {
        revert SafeTreasury__TransactionFailed();
    }
}

    // Withdrawal of native token of the current chain.
    // This withdrawal is the same as the previous one but to withdraw native token we should call this function instead of the previous one.
function withdrawNT(uint256 amount) external payable nonReentrant{
    if (tokenAddressToOwnerToBalance[address(0)][msg.sender] < amount) {
        revert SafeTreasury__InsufficientBalance();
    }
    tokenAddressToOwnerToBalance[address(0)][msg.sender] -= amount;
    (bool ok,) = msg.sender.call{value: amount}("");
    if (!ok) {
            revert SafeTreasury__TransactionFailed();
        }
}

    // Withdrawal just for addresses who authorized by another address and they have access to another address assets.
    // AA stands for: authorized address
function withdrawByAA(address tokenAddress,uint256 amount) external nonReentrant {
        address mainAddress = getAuthorized(msg.sender);
        if (mainAddress == address(0)) {
            revert SafeTreasury__NotAuthorized(); 
        }
        uint256 mainAddressBalance = tokenAddressToOwnerToBalance[tokenAddress][mainAddress];
        if (mainAddressBalance < amount) {
            revert SafeTreasury__InsufficientBalance();
        }
        tokenAddressToOwnerToBalance[tokenAddress][mainAddress] -= amount;
        (bool ok) = IERC20(tokenAddress).transfer(msg.sender, amount);
        if (!ok) {
            revert SafeTreasury__TransactionFailed();
        }
}

    // Same as previous one this function will withdraw user balance but this one uses for withdraw native token of chain.
function withdrawNTByAA(uint256 amount) external nonReentrant {
        address mainAddress = getAuthorized(msg.sender);
        if (mainAddress == address(0)) {
            revert SafeTreasury__NotAuthorized(); 
        }
        uint256 mainAddressBalance = tokenAddressToOwnerToBalance[address(0)][mainAddress];
        if (mainAddressBalance < amount) {
            revert SafeTreasury__InsufficientBalance();
        }
        tokenAddressToOwnerToBalance[address(0)][mainAddress] -= amount;
        (bool ok, ) = msg.sender.call{value: (amount*995)/1000 }("");
        if (!ok) {
            revert SafeTreasury__TransactionFailed();
        }
}

    // Transfer asset from this smart contract to another address
function externalTransfer(address tokenAddress, address to, uint256 amount) external nonReentrant{
    if (tokenAddressToOwnerToBalance[tokenAddress][msg.sender] < amount) {
        revert SafeTreasury__InsufficientBalance();
    }
    tokenAddressToOwnerToBalance[tokenAddress][msg.sender] -= amount;
    bool ok = IERC20(tokenAddress).transfer(to, (amount * 995)/1000);
    if (!ok) {
        revert SafeTreasury__TransactionFailed();
    }
}

    // Transfer asset inside contract without withdrawing fund from this smart contract.
    // It decreases the balance of sender address and increases balance of receiver address.
function internallTransfer(address tokenAddress, address to, uint256 amount) external{
    tokenAddressToOwnerToBalance[tokenAddress][msg.sender] -= amount;
    tokenAddressToOwnerToBalance[tokenAddress][to] += (amount * 995)/1000;
}

    // With this function an address can authorize another address to have access its assets.
function authorize(address authorizedAddress) external {
    authorizedAddressesToMainAddress[authorizedAddress]= msg.sender;
}

    // This function will remove authorized address. 
function removeAuthorize(address authorizedAddress) external {
    if (authorizedAddressesToMainAddress[authorizedAddress] != msg.sender) {
        revert SafeTreasury__AddressNotFound();
    }
        authorizedAddressesToMainAddress[authorizedAddress] = address(0);
}

    // What else we need?
    // A function to withdraw fees by owner

    // View funcs:

    // Show token balance of an address using token address and user address.
function balance(address tokenAddress, address userAddress) public view returns (uint256) {
    return tokenAddressToOwnerToBalance[tokenAddress][userAddress];
}

    // To get an address that authorized another address.
    // If returns address(0),'from' address not authorized by any address.
function getAuthorized(address from) view public returns (address) {
    return authorizedAddressesToMainAddress[from];
}

}