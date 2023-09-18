// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract marketplace is Ownable {

    mapping(uint => uint) values;
    mapping(uint => address) postor;

    IERC721 achievement;
    IERC20 coin_one;

    constructor(address coin_one_contract, address achievement_contract){
        achievement = IERC721(achievement_contract);
        coin_one = IERC20 (coin_one_contract);
    }

    function publish(uint token_id, uint value) public {
        require(values[token_id] == 0);
        require(value > 0);

        require(achievement.getApproved(token_id) == address(this));

        values[token_id] = value;
    
        postor[token_id] = msg.sender;
    }

    function finish_transaction(uint token_id) public onlyOwner {
        require(values[token_id] > 0);
        require(coin_one.allowance(postor[token_id], address(this)) > values[token_id]);
        require(achievement.getApproved(token_id) == address(this));
        
        coin_one.transferFrom(postor[token_id], achievement.ownerOf(token_id), values[token_id]);
        achievement.safeTransferFrom(achievement.ownerOf(token_id), postor[token_id], token_id);
        values[token_id] = 0;

    }

    function offers(uint token_id, uint quantity) public{
        require(values[token_id] > 0);
        require(quantity > values[token_id]);
        require(coin_one.allowance(msg.sender, address(this)) > quantity);

        postor[token_id] = msg.sender;
        values[token_id] = quantity;
    }

    // function buy(uint token_id) public {
    //     require(values[token_id] != 0);
    //     require(coin_one.allowance(msg.sender, address(this)) >= values[token_id]);
    //     require(achievement.getApproved(token_id) == address(this));

    //     coin_one.transferFrom(msg.sender, achievement.ownerOf(token_id), values[token_id]);
    //     achievement.safeTransferFrom(achievement.ownerOf(token_id), msg.sender, token_id);
    //     values[token_id] = 0;
    // }
}