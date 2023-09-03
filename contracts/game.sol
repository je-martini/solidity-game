// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "hardhat/console.sol";
import "./achievement.sol";
import "./coin_one.sol";

contract game_name {

    struct Game {
        address player1;
        address player2;
        address winner;
        string winner_name;
        uint[4][4] moves;
        uint number_moves;
        address last_move;
        bool has_winner;
    }

    Game[] public games;

    mapping(address => uint) winners;
    Achievement achievement;
    Coin_one coin_one;

    constructor(address contract_achievement, address contract_coin){
        achievement = Achievement(contract_achievement);
        coin_one = Coin_one(contract_coin);
    }

    function start_game(address player2, uint horizontal, uint vertical) public returns(uint){
        
        require(msg.sender != player2, "you can't playe by your self");

        uint id_game = games.length;
        
        Game memory game;
        game.player1 = msg.sender;
        game.player2 = player2;
        game.has_winner = false;
        game.last_move = msg.sender;
        game.moves[horizontal][vertical] = 1;
        game.number_moves = game.number_moves + 1;


        games.push(game);

        return id_game;
        
    }

    function make_moves(uint id_game, uint horizontal, uint vertical) public {
            require(games[id_game].has_winner == false, games[id_game].winner_name);

            require(games[id_game].number_moves < 10, "the Board it's full Game Over");
            
            require(games[id_game].player1 == msg.sender || games[id_game].player2 == msg.sender, 
            'you arent a player');

            require(msg.sender != games[id_game].last_move, "you cannot make a move twice");
            
            require(horizontal < 4  && horizontal >0 && vertical >0 && vertical < 4, "invalid move");

            require(games[id_game].moves[horizontal][vertical]  == 0, "that position it's been already taken");


            uint move = 1;
            if(msg.sender == games[id_game].player2){
                move = 2;
            }

            games[id_game].moves[horizontal][vertical] = move;
            games[id_game].number_moves = games[id_game].number_moves + 1;

            if(games[id_game].number_moves > 4){
                it_is_winner(id_game) ;
            }            

            games[id_game].last_move = msg.sender;
    }     

    function it_is_winner(uint id_game) private {
        uint player_position = 1;
        
        if(msg.sender == games[id_game].player2){
            player_position = 2;
        }
        
            
                if(
                    games[id_game].moves[1][1] == player_position && 
                    games[id_game].moves[1][2] == player_position &&
                    games[id_game].moves[1][3] == player_position
                    ||
                    games[id_game].moves[2][1] == player_position && 
                    games[id_game].moves[2][2] == player_position &&
                    games[id_game].moves[2][3] == player_position
                    ||
                    games[id_game].moves[3][1] == player_position && 
                    games[id_game].moves[3][2] == player_position &&
                    games[id_game].moves[3][3] == player_position
                    ||
                    games[id_game].moves[1][1] == player_position && 
                    games[id_game].moves[2][2] == player_position &&
                    games[id_game].moves[3][3] == player_position 
                    ||
                    games[id_game].moves[3][1] == player_position && 
                    games[id_game].moves[2][2] == player_position &&
                    games[id_game].moves[1][3] == player_position
                    
                    ){
                        
                        games[id_game].has_winner = true;
                        games[id_game].winner = msg.sender;
                        games[id_game].winner_name = "player1 is the winner";

                        if(msg.sender == games[id_game].player2){
                            games[id_game].winner_name = "player2 is the winner";
                        }
                        
                        winners[games[id_game].winner]++;
                        coin_one.minter( games[id_game].winner ,1);

                        if(games[id_game].number_moves < 8){
                            achievement.achievement_minter(games[id_game].winner);
                            coin_one.minter( games[id_game].winner ,1);
                        }

                        if(winners[games[id_game].winner] == 5){
                            achievement.achievement_minter(games[id_game].winner);
                            coin_one.minter( games[id_game].winner ,2);

                        }
                        

                }   
                
                // if(
                //     games[id_game].moves[1][1] == player2_position && 
                //     games[id_game].moves[1][2] == player2_position &&
                //     games[id_game].moves[1][3] == player2_position
                //     ||
                //     games[id_game].moves[2][1] == player2_position && 
                //     games[id_game].moves[2][2] == player2_position &&
                //     games[id_game].moves[2][3] == player2_position
                //     ||
                //     games[id_game].moves[3][1] == player2_position && 
                //     games[id_game].moves[3][2] == player2_position &&
                //     games[id_game].moves[3][3] == player2_position
                //     ||
                //     games[id_game].moves[1][1] == player2_position && 
                //     games[id_game].moves[2][2] == player2_position &&
                //     games[id_game].moves[3][3] == player2_position 
                //     ||
                //     games[id_game].moves[3][1] == player2_position && 
                //     games[id_game].moves[2][2] == player2_position &&
                //     games[id_game].moves[1][3] == player2_position
                    
                    
                //     ){
                //         // is_game_over = true;
                //         games[id_game].has_winner = true;
                //         games[id_game].winner = msg.sender;
                //         games[id_game].winner_name = "player2 is the winner";
                //         winners[games[id_game].winner]++;

                //         if(winners[games[id_game].winner] == 5){
                //             Achievement.achievement_minter(games[id_game].winner);
                //         }
                //         if(games[id_game].number_moves < 8){
                //             Achievement.achievement_minter(games[id_game].winner);
                //         }
                // } 
    }

}

        


