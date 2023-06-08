// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    constructor(string memory _name, string memory _symbol,address addressForMint) ERC20(_name,_symbol){
        _mint(addressForMint, 100e18);
    }
    
    function mint(uint256 amount)external {
        _mint(msg.sender, amount);
    }
}