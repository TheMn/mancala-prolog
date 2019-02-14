/*
Guilan University Artificial Intelligence Project
Lecturer:	Dr. Mir roshandel
T.A:		Ali Tourani
December 2018
*/

/* include Files */
:- include('More/Facts.pl').
:- include('More/Rules.pl').
:- include('More/Minimax.pl').

/* Main Function */
player_SN([Own, OwnStore, Opp, OppStore], themn) :-
  [Own, OwnStore, Opp, OppStore],
  !.
