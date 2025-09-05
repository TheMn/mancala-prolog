%!  <module> Mancala Game Player
%
%   This is the main file for the Mancala game player. It includes the
%   necessary files and defines the main predicate to start the game.
%
%   @author Guilan University AI Project
%   @version 1.0
%   @date December 2018

:- include('More/Facts.pl').
:- include('More/Rules.pl').
:- include('More/Minimax.pl').

%!  player_SN(+GameState:list, -Move:list) is det.
%
%   This is the main predicate for the player. It takes the current game
%   state and returns the best move for the current player as determined
%   by the minimax algorithm.
%
%   @param GameState A list representing the current game state. It has
%          the form `[Own, OwnStore, Opp, OppStore]`, where `Own` is a
%          list of the player's holes, `OwnStore` is the player's store,
%          `Opp` is a list of the opponent's holes, and `OppStore` is
%          the opponent's store.
%   @param Move The chosen move, which is a list of integers representing
%          the sequence of moves to make.
player_SN([Own, OwnStore, Opp, OppStore], Move) :-
    board_struct(Board, board(Own, OwnStore, Opp, 0)),
    choose_move(Board, player1, Move).
