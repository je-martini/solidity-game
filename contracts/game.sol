// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "hardhat/console.sol";

contract game_name {

    struct game {
        address player1;
        address player2;
        address winner;
        uint[4][4] moves;
    }

    game[] games;

    // constructor

    // modifiars

    // functions

    function start_game(address p1, address p2) public return(uint){

    }

    function make_moves(uint id_game, uint horizontal, uint vertical) public {
        // validations

        // game_status

        // save_move

        // it is a winner, it is the game over

    }
}
