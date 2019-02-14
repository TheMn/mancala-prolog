/*
Minimax Algorithm
*/

/* Evaluate each leaf */
alpha_beta(0, Position, _, _, _, Value) :- 
	value(Position, Value).

/* All possible moves for succecors */
alpha_beta(D, Position, Alpha, Beta, Move, Value) :- 
        findall(M, move(Position, M), Moves),
        Alpha1 is -Beta, 
	Beta1 is -Alpha, 
        D1 is D-1,
	evaluate_and_choose(Moves, Position, D1, Alpha1, Beta1, nil, (Move, Value)).

cutoff(Move, Value, _, _, Beta, _, _, _, (Move, Value)) :- 
	Value >= Beta.
cutoff(Move, Value, D, Alpha, Beta, Moves, Position, _, BestMove) :- 
        Alpha < Value, Value < Beta, 
	evaluate_and_choose(Moves, Position, D, Value, Beta, Move, BestMove).
cutoff(_, Value, D, Alpha, Beta, Moves, Position, Move1, BestMove) :-
        Value =< Alpha, 
	evaluate_and_choose(Moves, Position, D, Alpha, Beta, Move1, BestMove).
		
evaluate_and_choose([Move|Moves], Position, D, Alpha, Beta, Move1, BestMove) :-
	move(Move, Position, _),
	alpha_beta(D, Position, Alpha, Beta, _, Value),
	Value1 is -Value,
	cutoff(Move, Value1, D, Alpha, Beta, Moves, Position, Move1, BestMove).
evaluate_and_choose([], _, _, Alpha, _, Move, (Move, Alpha)).

/* Evaluation function */
value(board(_,K,_,L),Value) :-
	Value is L-K.