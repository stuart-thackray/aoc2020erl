%% @author stuart
%% @doc @todo Add description to day15.


-module(day15).

%% ====================================================================
%% API functions
%% ====================================================================
-export([p1/0,
         p1_test/0,
         p2/0
        ]).

p1() ->
    Input = [2,20,0,4,1,17],
    run(length(Input)+1, lists:reverse(Input), 2020+1).
p1_test() ->
    Input = [3,1,2],
    run(length(Input)+1, lists:reverse(Input), 2020+1).

p2() ->    
	Input = [2,20,0,4,1,17],
    run(length(Input)+1, lists:reverse(Input), 30000000+1).



%% ====================================================================
%% Internal functions
%% ====================================================================


run(End, Mem, End) ->
    hd(Mem);
run(N,  Mem = [E|Tail], End) ->
    Spoken = case lists:member(E, Tail) of 
                 false ->
                     0;
                 _ ->
                     find_last(1,E, Tail)
             end,
%% 	io:format("Turn:~p: Spoken:~p~n", [N, Spoken]), 


    run(N+1,  [Spoken|Mem], End).



find_last(N, E, [E|Tail]) ->
    N;
find_last(N, E, [_|Tail]) ->
    find_last(N+1, E, Tail). 

