// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Coin_one is ERC20("Token Coin","tc"), Ownable {


    function minter(address to_send, uint quatity) public onlyOwner{
        _mint( to_send, quatity);
    }
}