%!  <module> Rules of the Game "mancala"
%
%   or "kalah" (as mentioned in the book The Art of Prolog)
%   This module defines the rules of the Mancala game.

%!  play(+Game:atom) is det.
%
%   This is the main predicate to start the game. It initializes the game,
%   displays the initial position, and starts the game loop.
%
%   @param Game The name of the game to play (e.g., `sowing`).
play(Game) :-
    initialize(Game, Position, Player),
    display_game(Position, Player),
    play(Position, Player, _).

%!  play(+Position:compound, +Player:atom, -Result:atom) is det.
%
%   This predicate manages the game loop. It checks if the game is over,
%   chooses a move, executes the move, and then passes the turn to the
%   next player.
%
%   @param Position The current board position.
%   @param Player The current player.
%   @param Result The result of the game (e.g., `player1`, `player2`, `draw`).
play(Position, Player, Result) :-
    game_over(Position, Player, Result),
    !,
    finish(Result).
play(Position, Player, Result) :-
    choose_move(Position, Player, Move),
    move(Move, Position, Position1),
    display_game(Position1, Player),
    next_player(Player, Player1),
    !,
    play(Position1, Player1, Result).

%!  choose_move(+Position:compound, +Player:atom, -Move:list) is det.
%
%   Chooses a move for the AI using the alpha-beta pruning algorithm.
%
%   @param Position The current board position.
%   @param Player The current player (unused).
%   @param Move The chosen move.
choose_move(Position, _, Move) :-
    settings(treeDepth, Depth),
    alpha_beta(Depth, Position, -1000, 1000, Move, _),
    format('~nSelected: ~w', [Move]).

%!  move(+Board:compound, -Move:list) is nondet.
%
%   This predicate is for the AI. It generates a move for the AI based on
%   the current board state.
%
%   @param Board The current board state.
%   @param Move The generated move.
move(Board, [Index|Others]) :-
    member(Index, [1,2,3,4,5,6]),
    stones_in_hole(Index, Board, Stones),
    extra_move(Stones, Index, Board, Others).
move(board(zero(_), _, _, _), []).

%!  move(+Move:list, +Board:compound, -FinalBoard:compound) is det.
%
%   This predicate is for the user. It executes a move given by the user.
%
%   @param Move The move to execute.
%   @param Board The current board state.
%   @param FinalBoard The board state after the move.
move([Index|Others], Board, FinalBoard) :-
    stones_in_hole(Index, Board, Stones),
    distribute_stones(Stones, Index, Board, TmpBoard),
    move(Others, TmpBoard, FinalBoard).
move([], Board, FinalBoard) :-
    swap(Board, FinalBoard).

%!  stones_in_hole(+Index:integer, +Board:compound, -Stones:integer) is semidet.
%
%   Gets the number of stones in a specific hole.
%
%   @param Index The index of the hole.
%   @param Board The current board state.
%   @param Stones The number of stones in the hole.
stones_in_hole(Index, board(BoardKhodi, _, _, _), Stones) :-
    nth1(Index, BoardKhodi, Stones),
    Stones > 0.

%!  extra_move(+Stones:integer, +Index:integer, +Board:compound, -Moves:list) is det.
%
%   Determines if an extra move is awarded. An extra move is awarded if
%   the last stone lands in the player's store.
%
%   @param Stones The number of stones in the hole.
%   @param Index The index of the hole.
%   @param Board The current board state.
%   @param Moves A list of subsequent moves if an extra turn is granted.
extra_move(Stones, Index, _, []) :-
    Stones =\= (7-Index) mod 13,
    !.
extra_move(Stones, M, Board, Ms) :-
    Stones =:= (7-M) mod 13, !,
    distribute_stones(Stones, M, Board, Board1),
    move(Board1, Ms).

%!  distribute_stones(+Stones:integer, +Hole:integer, +Board:compound, -FinalBoard:compound) is det.
%
%   Distributes the stones from a chosen hole.
%
%   @param Stones The number of stones to distribute.
%   @param Hole The hole from which to distribute the stones.
%   @param Board The current board state.
%   @param FinalBoard The board state after distributing the stones.
distribute_stones(Stones, Hole, board(Hs, K, Ys, L), board(FHs, FK, FYs, L)) :-
    board_struct(board(Hs, K, Ys, L), TmpBoard),
    bepashun(Stones, Hole, Hole, TmpBoard, TmpFinal),
    struct_board(TmpFinal, board(FHs, FK, FYs, L)).

%!  lastN(+L:list, +N:integer, -R:list) is det.
%
%   Gets the last `N` elements of a list `L`.
%
%   @param L The input list.
%   @param N The number of elements to get.
%   @param R The resulting list of the last `N` elements.
lastN(L,N,R):-
    length(L,X),
    X1 is X-N,
    lastT(L,X1,R).

%!  lastT(+L:list, +N:integer, -R:list) is det.
%
%   Helper predicate for `lastN/3`. It skips the first `N` elements of a list
%   and returns the rest.
%
%   @param L The input list.
%   @param N The number of elements to skip.
%   @param R The resulting list.
lastT(L,0,L).
lastT([_|T],X,L):-
    X2 is X-1,
    lastT(T,X2,L).

%!  take(+Src:list, +N:integer, -L:list) is det.
%
%   Takes the first `N` elements of a list `Src`.
%
%   @param Src The source list.
%   @param N The number of elements to take.
%   @param L The resulting list.
take(Src,N,L) :-
    findall(E, (nth1(I,Src,E), I =< N), L).

%!  struct_board(+Board:list, -Struct:compound) is det.
%
%   Converts a list representation of the board to a structured representation.
%
%   @param Board The list representation of the board.
%   @param Struct The structured representation of the board.
struct_board(Board, board(Hs, K, Ys, _)) :-
    take(Board, 6, Hs),
    lastN(Board, 6, TmpYs),
    reverse(TmpYs, Ys),
    nth0(6, Board, K).

%!  board_struct(+Struct:compound, -Board:list) is det.
%
%   Converts a structured representation of the board to a list representation.
%
%   @param Struct The structured representation of the board.
%   @param Board The list representation of the board.
board_struct(board(Hs, K, Ys, _), Board) :-
    conc(Hs, [K], Tmp),
    reverse(Ys, YsPrime),
    conc(Tmp, YsPrime, Board).

%!  increase_by_index(+Index:integer, +Board:list, -FinalBoard:list) is det.
%
%   Increments the number of stones in a hole at a given index.
%
%   @param Index The index of the hole to increment.
%   @param Board The current board state as a list.
%   @param FinalBoard The final board state as a list.
increase_by_index(Index, Board, FinalBoard):-
    nth1(Index, Board, Stones),
    ToSet is Stones + 1,
    replace(Board, Index, ToSet, FinalBoard).

%!  bepashun(+Stones:integer, +StartingIndex:integer, +Index:integer, +Board:list, -FinalBoard:list) is det.
%
%   Distributes stones one by one into the holes. This predicate is in Farsi
%   and means "distribute".
%
%   @param Stones The number of stones to distribute.
%   @param StartingIndex The index of the hole from which the stones were taken.
%   @param Index The current index where a stone is being placed.
%   @param Board The current board state as a list.
%   @param FinalBoard The final board state as a list.
bepashun(0, _, _, Board, Board):-!.
bepashun(Stones, StartingIndex, StartingIndex, Board, FinalBoard) :-
    I is StartingIndex + 1,
    replace(Board, StartingIndex, 0, TmpBoard),
    bepashun(Stones, StartingIndex, I, TmpBoard, FinalBoard), !.
bepashun(Stones, StartingIndex, Index, Board, FinalBoard):-
    RemainingStones is Stones - 1,
    I is ((Index) mod 13)+1,
    increase_by_index(Index, Board, TmpBoard),
    bepashun(RemainingStones, StartingIndex, I, TmpBoard, FinalBoard),!.

%!  finished(+Board:compound) is semidet.
%
%   Checks if the game has finished. The game is finished when one of the
%   players has no stones in their holes.
%
%   @param Board The current board state.
finished(board(L, _, L1, _)):-
    zero(L); zero(L1).

%!  game_over(+Board:compound, +Player:atom, -Result:atom) is semidet.
%
%   Determines the result of the game if it is over.
%
%   @param Board The current board state.
%   @param Player The current player.
%   @param Result The result of the game (`draw`, `player1`, `player2`).
game_over(board(B, AnbarMosavi, B1, AnbarMosavi), _, draw) :-
    finished(board(B, AnbarMosavi, B1, AnbarMosavi)).
game_over(board(B, AnbarAvvali, B1, AnbarDovvomi), Player, Player) :-
    finished(board(B, AnbarAvvali, B1, AnbarDovvomi)),
    AnbarAvvali > AnbarDovvomi, !.
game_over(board(B, AnbarAvvali, B1, AnbarDovvomi), Player, Opponent) :-
    finished(board(B, AnbarAvvali, B1, AnbarDovvomi)),
    AnbarDovvomi > AnbarAvvali,
    next_player(Player, Opponent).

%!  finish(+Result:atom) is det.
%
%   Prints the final result of the game.
%
%   @param Result The result of the game.
finish(draw) :-
    format('-- TIE --', []), !.
finish(PlayerName) :-
    format('The winner is ~w~n', [PlayerName]).

%!  replace(+List:list, +Index:integer, +NewElement:any, -NewList:list) is det.
%
%   Replaces an element in a list at a given index.
%
%   @param List The input list.
%   @param Index The index of the element to replace.
%   @param NewElement The new element.
%   @param NewList The resulting list.
replace([_|T], 1, X, [X|T]).
replace([H|T], I, X, [H|R]):-
    I > 0,
    NI is I-1,
    replace(T, NI, X, R), !.
replace(L, _, _, L).

%!  swap(+Board:compound, -SwappedBoard:compound) is det.
%
%   Swaps the players' sides of the board.
%
%   @param Board The current board state.
%   @param SwappedBoard The board state after swapping.
swap(board(Hs,K,Ys,L), board(Ys,L,Hs,K)).

%!  conc(?L1:list, ?L2:list, ?L3:list) is nondet.
%
%   Concatenates two lists.
%
%   @param L1 The first list.
%   @param L2 The second list.
%   @param L3 The concatenated list.
conc([], L, L).
conc([X|L1], L2, [X|L3]) :-
    conc(L1, L2, L3).

%!  display_game(+Position:compound, +Player:atom) is det.
%
%   Displays the current state of the game.
%
%   @param Position The current board position.
%   @param Player The current player.
display_game(Position, player1) :-
    show(Position, player1).
display_game(Position, player2) :-
    swap(Position, Position1), show(Position1, player2).

%!  show(+Board:compound, +PlayerName:atom) is det.
%
%   Prints the board to the console.
%
%   @param Board The current board state.
%   @param PlayerName The name of the current player.
show(board(H,K,Y,L), PlayerName) :-
    reverse(H, HR),
    format('~nTurn: ~w ~nBoard of Player2: ~w ~n(P2)~w : ~w(P1)~nBoard of Player1: ~w ~n~n-----------------', [PlayerName, HR, K, L, Y]).

%!  initialize(+Game:atom, -Board:compound, -Player:atom) is det.
%
%   Initializes the game state.
%
%   @param Game The name of the game (e.g., `sowing`).
%   @param Board The initial board state.
%   @param Player The starting player.
initialize(sowing, board([S, S, S, S, S, S], 0, [S, S, S, S, S, S], 0), player2) :-
    settings(stones, S).
