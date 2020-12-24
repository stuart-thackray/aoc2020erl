%% @author stuart
%% @doc @todo Add description to day22.


-module(day22).

%% ====================================================================
%% API functions
%% ====================================================================
-export([p1/0,
         p2/0
        ]).


p1() ->
    [P1,P2] = read_input(),
    P1Card = [ list_to_integer(X) || X <- tl(string:tokens(P1, "\n"))],
    P2Card = [ list_to_integer(Y) || Y <- tl(string:tokens(P2, "\n"))],
    EndPack = run_game(P1Card, P2Card),
    lists:sum(lists:flatten(score_game(lists:reverse(EndPack), 1))) .


p2() ->
    [P1,P2] = read_input(),
    P1Card = [ list_to_integer(X) || X <- tl(string:tokens(P1, "\n"))],
    P2Card = [ list_to_integer(Y) || Y <- tl(string:tokens(P2, "\n"))],
    EndPack = run_game_p2(P1Card, P2Card),
	lists:sum(lists:flatten(score_game(lists:reverse(EndPack), 1))) .



run_game_p2([], End) ->
    End;
run_game_p2(End, []) ->
    End;
run_game_p2(P1 = [E|Tail], P2 = [S|Rest]) ->
    %% 	io:format("Tail:~p~n  	Rest:~p~n~n", [Tail, Rest]),
    %% 	receive after 3000 -> void end, 
    case {get({p1, P1}), get({p2,P2})} of
        {undefined, undefined} ->
            case (length(P1) == E) and (length(P2) == S) of 
                true ->
                    case sub_game(Tail, Rest) of 
                        p1 ->
                            put({p1,P1}, 1),
                            put({p2, P2}, 1),
                            run_game_p2(lists:flatten([Tail, E, S]), Rest);
                        p2 ->
                            put({p1,P1}, 1),
                            put({p2, P2}, 1),
                            run_game_p2(Tail, lists:flatten([Rest, S, E]))
                    end;
                _ ->
                    case E > S of
                        true ->
                            put({p1,P1}, 1),
                            put({p2, P2}, 1),
                            run_game_p2(lists:flatten([Tail, E, S]), Rest);
                        _ ->
                            put({p1,P1}, 1),
                            put({p2, P2}, 1),
                            run_game_p2(Tail, lists:flatten([Rest, S, E]))
                    end
            end;
        _ ->
            P1
    end.

sub_game([], End) ->
    p2;
sub_game(End, []) ->
    p1;
sub_game(P1 = [E|Tail], P2 = [S|Rest]) ->
    %% 	io:format("Tail:~p~n  	Rest:~p~n~n", [Tail, Rest]),
    %% 	receive after 3000 -> void end, 
    case {get({p1, P1}), get({p2,P2})} of
        {undefined, undefined} ->
            case (length(P1) == E) and (length(P2) == S) of 
                true ->
                    case sub_game(Tail, Rest) of 
                        p1 ->

                            sub_game(lists:flatten([Tail, E, S]), Rest);
                        p2 ->

                            sub_game(Tail, lists:flatten([Rest, S, E]))
                    end;
                _ ->
                    case E > S of
                        true ->

                            sub_game(lists:flatten([Tail, E, S]), Rest);
                        _ ->

                            sub_game(Tail, lists:flatten([Rest, S, E]))
                    end
            end;
        _ ->
            p1
    end.
run_game([], End) ->
    End;
run_game(End, []) ->
    End;
run_game([E|Tail], [S|Rest]) ->
    %% 	io:format("Tail:~p~n  	Rest:~p~n~n", [Tail, Rest]),
    %% 	receive after 3000 -> void end, 
    case E > S of
        true ->
            run_game(lists:flatten([Tail, E, S]), Rest);
        _ ->
            run_game(Tail, lists:flatten([Rest, S, E]))
    end.

score_game([], _) ->
    0;
score_game([E|Tail], N) ->
    [E*N,
     score_game(Tail, N+1)].
%% ====================================================================
%% Internal functions
%% ====================================================================


read_input() ->
    {ok, Bin} = file:read_file("priv/input.txt"), 
    BinList = binary:split(Bin, <<10,10>>, [global]), 
    [binary_to_list(X) || X <- BinList].
