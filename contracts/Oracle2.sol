
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TransactionHandler {
    mapping(address => uint) public balances;
    address[] public allAddresses;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        if (!addressExists(msg.sender)) {
            allAddresses.push(msg.sender);
        }
    }

    function withdraw(uint amount) public {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }

    function transfer(address recipient, uint amount) public {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        balances[recipient] += amount;
        if (!addressExists(recipient)) {
            allAddresses.push(recipient);
        }
    }

    function getAddressCount() public view returns (uint) {
        return allAddresses.length;
    }

    function addressExists(address addr) private view returns (bool) {
        for (uint i = 0; i < allAddresses.length; i++) {
            if (allAddresses[i] == addr) {
                return true;
            }
        }
        return false;
    }
}
