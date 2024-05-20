:- dynamic(node/2).

% Entry point
moves(FileName, Moves) :-
    read_input(FileName, N, Matrix),
    assert_initial_node(N, Matrix),
    nth0(0, Matrix, Row),
    nth0(0, Row, CurrentValue),
    X is N - 1,
    bfs([[node((0, 0), CurrentValue)]], N, Matrix, node((X, X), _), [], Path),
    (Path = [] -> false ; path_to_moves(Path, Moves)).

% Read the input file
read_input(FileName, N, Matrix) :-
    open(FileName, read, Stream),
    read_line_to_codes(Stream, NLine),
    atom_codes(AtomN, NLine),
    atom_number(AtomN, N),
    read_matrix(Stream, N, Matrix),
    close(Stream).

read_matrix(_, 0, []).
read_matrix(Stream, N, [Row | Matrix]) :-
    N > 0,
    read_line_to_codes(Stream, Line),
    atom_codes(AtomLine, Line),
    atomic_list_concat(Atoms, ' ', AtomLine),
    maplist(atom_number, Atoms, Row),
    Next is N - 1,
    read_matrix(Stream, Next, Matrix).

% Initialize the root node
assert_initial_node(_, Matrix) :-
    nth0(0, Matrix, [Value | _]),
    assert(node((0, 0), Value)).

% Breadth-first search

bfs([], _, _, _, _, _) :- !.

bfs([CurrentPath | RestPaths], N, Matrix, Goal, Visited, Path) :-
    CurrentPath = [node((I, J), _) | _],
    append(Visited, [(I,J)], NewVisited),
    (
        (I is N-1, J is N-1) ->
            Path = CurrentPath
        ;
            nth0(I, Matrix, Row),
            nth0(J, Row, Value),
            find_neighbors((I, J), N, Neighbors),
            keep_possible(Neighbors, Value, Matrix, NewVisited, PossibleNeighbors),
            expand_paths(CurrentPath, PossibleNeighbors, NewPaths),
            append(RestPaths, NewPaths, UpdatedPaths),
            bfs(UpdatedPaths, N, Matrix, Goal, NewVisited, Path)
    ).


expand_paths(_, [], []).
expand_paths(Path, [Neighbor | Neighbors], [[Neighbor | Path] | Expanded]) :-
    expand_paths(Path, Neighbors, Expanded).

% Find neighbors within the grid
find_neighbors((I, J), N, Neighbors) :-
    neighbor_position(NeighborPositions),
    findall((NewI, NewJ), (
        member((DI, DJ), NeighborPositions),
        NewI is I + DI,
        NewJ is J + DJ,
        NewI >= 0, NewI < N,
        NewJ >= 0, NewJ < N
    ), Neighbors).

% Neighbor positions (8 directions)
neighbor_position([(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)]).

% Keep possible neighbors with values less than the current node
keep_possible([], _, _, _, []).
keep_possible([(I, J) | Neighbors], Value, Matrix, Visited, [node((I, J), NeighborValue) | Result]) :-
    nth0(I, Matrix, Row),
    nth0(J, Row, NeighborValue),
    NeighborValue < Value,
    \+ member((I, J), Visited),
    keep_possible(Neighbors, Value, Matrix, Visited, Result).
keep_possible([_ | Neighbors], Value, Matrix, Visited, Result) :-
    keep_possible(Neighbors, Value, Matrix, Visited, Result).

% Convert path to moves
path_to_moves(Path, Moves) :-
    reverse(Path, ReversedPath),
    revpath_to_moves(ReversedPath, Moves).

% Translate moves to direction symbols
revpath_to_moves([_], []).
revpath_to_moves([node((I1, J1), _), node((I2, J2), _) | T], [Direction | Rest]) :-
    direction_symbol(I1, J1, I2, J2, Direction),
    revpath_to_moves([node((I2, J2), _) | T], Rest).

% Map coordinates to direction symbols
direction_symbol(I1, J1, I2, J2, Symbol) :-
    DX is I2 - I1,
    DY is J2 - J1,
    direction(DX, DY, Symbol).

% Direction predicates
direction(1, 1, se).
direction(0, 1, e).
direction(1, 0, s).
direction(-1, -1, nw).
direction(0, -1, w).
direction(-1, 0, n).
direction(-1, 1, ne).
direction(1, -1, sw).