// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";


contract marketplace {

    mapping(uint => uint) values;
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
    }

    function buy(uint token_id) public {
        require(values[token_id] != 0);
        require(coin_one.allowance(msg.sender, address(this)) >= values[token_id]);
        require(achievement.getApproved(token_id) == address(this));

        coin_one.transferFrom(msg.sender, achievement.ownerOf(token_id), values[token_id]);
        achievement.safeTransferFrom(achievement.ownerOf(token_id), msg.sender, token_id);
        values[token_id] = 0;
    }
}