/*
Facts of the Game
*/

/* Non-zero list means */
non_zero(Hs) :- Hs \== [0,0,0,0,0,0].

/* Zero list means */
zero([0,0,0,0,0,0]).

/* Set game difficulty */
settings(treeDepth, 3).

/* Set number of stones */
settings(stones, 6).

/* Set duration time */
settings(pauseDuration, 2).
:- dynamic settings/2.

/* Change player */
next_player(player1, player2).
next_player(player2, player1).