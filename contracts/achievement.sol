// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract achievement is ERC721("Token Achievement","ta"), Ownable {

    uint last_index; 

    function achievement_minter(address to_send) public onlyOwner returns(uint){
        uint index = last_index;
        last_index ++;
        _safeMint( to_send, index);
        return index;
    }
}