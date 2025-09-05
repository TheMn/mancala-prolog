%!  <module> Facts of the Game
%
%   This module defines the basic facts and settings of the Mancala game.

%!  non_zero(+Hs:list) is semidet.
%
%   Succeeds if the list of holes `Hs` is not all zeros.
%
%   @param Hs The list of holes to check.
non_zero(Hs) :- Hs \== [0,0,0,0,0,0].

%!  zero(+Hs:list) is semidet.
%
%   Succeeds if the list of holes `Hs` is all zeros.
%
%   @param Hs The list of holes to check.
zero([0,0,0,0,0,0]).

%!  settings(-Name:atom, -Value:integer) is multi.
%
%   Defines the game settings.
%
%   @param Name The name of the setting (e.g., `treeDepth`, `stones`).
%   @param Value The value of the setting.
settings(treeDepth, 3).
settings(stones, 6).
settings(pauseDuration, 2).
:- dynamic settings/2.

%!  next_player(?Player1:atom, ?Player2:atom) is multi.
%
%   Defines the turn order of the players.
%
%   @param Player1 The current player.
%   @param Player2 The next player.
next_player(player1, player2).
next_player(player2, player1).
