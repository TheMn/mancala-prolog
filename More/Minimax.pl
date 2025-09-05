%!  <module> Minimax Algorithm
%
%   This module implements the minimax algorithm with alpha-beta pruning
%   to determine the best move for the AI player.

%!  alpha_beta(+D:integer, +Position:compound, +Alpha:number, +Beta:number, -Move:list, -Value:number) is det.
%
%   This is the main predicate for the alpha-beta pruning algorithm.
%
%   @param D The current depth of the search tree.
%   @param Position The current board position.
%   @param Alpha The alpha value (the best value for the maximizer).
%   @param Beta The beta value (the best value for the minimizer).
%   @param Move The best move found.
%   @param Value The value of the best move.
alpha_beta(0, Position, _, _, _, Value) :-
    value(Position, Value).
alpha_beta(D, Position, Alpha, Beta, Move, Value) :-
    findall(M, move(Position, M), Moves),
    Alpha1 is -Beta,
    Beta1 is -Alpha,
    D1 is D-1,
    evaluate_and_choose(Moves, Position, D1, Alpha1, Beta1, nil, (Move, Value)).

%!  cutoff(+Move:list, +Value:number, +D:integer, +Alpha:number, +Beta:number, +Moves:list, +Position:compound, +Move1:list, -BestMove:tuple) is det.
%
%   This predicate decides whether to prune the search tree (cutoff) or
%   continue exploring moves. It is a helper for `evaluate_and_choose/7`.
%
%   @param Move The current move being evaluated.
%   @param Value The value of the current move.
%   @param D The current depth of the search tree.
%   @param Alpha The alpha value.
%   @param Beta The beta value.
%   @param Moves The list of remaining moves to evaluate.
%   @param Position The current board position.
%   @param Move1 The best move found so far.
%   @param BestMove A tuple containing the best move and its value.
cutoff(Move, Value, _, _, Beta, _, _, _, (Move, Value)) :-
    Value >= Beta.
cutoff(Move, Value, D, Alpha, Beta, Moves, Position, _, BestMove) :-
    Alpha < Value, Value < Beta,
    evaluate_and_choose(Moves, Position, D, Value, Beta, Move, BestMove).
cutoff(_, Value, D, Alpha, Beta, Moves, Position, Move1, BestMove) :-
    Value =< Alpha,
    evaluate_and_choose(Moves, Position, D, Alpha, Beta, Move1, BestMove).

%!  evaluate_and_choose(+Moves:list, +Position:compound, +D:integer, +Alpha:number, +Beta:number, +Move1:list, -BestMove:tuple) is det.
%
%   Recursively evaluates a list of possible moves and uses alpha-beta
%   pruning to find the best move.
%
%   @param Moves The list of moves to evaluate.
%   @param Position The current board position.
%   @param D The current depth of the search tree.
%   @param Alpha The alpha value.
%   @param Beta The beta value.
%   @param Move1 The best move found so far.
%   @param BestMove A tuple containing the best move and its value.
evaluate_and_choose([Move|Moves], Position, D, Alpha, Beta, Move1, BestMove) :-
    move(Move, Position, _),
    alpha_beta(D, Position, Alpha, Beta, _, Value),
    Value1 is -Value,
    cutoff(Move, Value1, D, Alpha, Beta, Moves, Position, Move1, BestMove).
evaluate_and_choose([], _, _, Alpha, _, Move, (Move, Alpha)).

%!  value(+Board:compound, -Value:integer) is det.
%
%   The evaluation function for the minimax algorithm. It calculates the
%   value of a board position as the difference between the number of
%   stones in the player's store and the opponent's store.
%
%   @param Board The board position to evaluate.
%   @param Value The calculated value of the board position.
value(board(_,K,_,L),Value) :-
    Value is L-K.
