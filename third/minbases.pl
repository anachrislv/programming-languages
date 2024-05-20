% Define the main predicate to find the minimum b for a given n
find_minimum_b(N, B) :-
    find_b(N, 2, B).

% Find the appropriate base b starting from BInit
find_b(N, BInit, B) :-
    (BInit > N - 1 ->
        B = -1
    ;
        find_k(N, BInit, 2, B)
    ).

% Recursively check for the value of k starting from KInit
find_k(N, B, KInit, ResultB) :-
    X is (B ** KInit - 1) // (B - 1),
    (B ** (KInit - 1) > N ->
        BNext is B + 1,
        find_b(N, BNext, ResultB)
    ;
        (N mod X =:= 0, N // X =< B - 1 ->
            ResultB = B
        ;
            KNext is KInit + 1,
            find_k(N, B, KNext, ResultB)
        )
    ).

% Main predicate to find minimum bases for a list of numbers
minbases(Numbers, Bases) :-
    findall(B, (member(N, Numbers), find_minimum_b(N, B)), Bases).