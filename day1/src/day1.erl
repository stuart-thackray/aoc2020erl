-module(day1). 

-export([run/0,
         run_p2/0
        ]).



run() ->
    {ok, Bin} = file:read_file("input/input.txt"), 
    Input = parse_data(Bin), 
    put(input, Input), 
    run_input(Input, Input) .



run_p2() ->

    {ok, Bin} = file:read_file("input/input.txt"), 
    Input = parse_data(Bin), 
    put(input, Input), 
    run_input_p2(Input, Input, Input) 



    .


run_input([], _) ->
    invalid;
run_input([_E|Tail], []) ->
    run_input(Tail, get(input));
run_input(Search = [E|_], [A|Rest]) ->
    case E+A of
        2020 ->
            E*A;
        _ ->
            run_input(Search, Rest)
    end.

run_input_p2([], _,_) ->
    invalid;
run_input_p2([_E|Tail], [],Third) ->
    run_input_p2(Tail, get(input),Third);
run_input_p2(First, [_|Tail],[]) ->
    run_input_p2(First, Tail, get(input));
run_input_p2(Search = [E|_], Second = [A|Rest],[B|BRest]) ->
    case E+A+B of
        2020 ->
            E*A*B;
        _ ->
            run_input_p2(Search, Second,BRest)
    end.

parse_data(Bin) ->
    List = binary_to_list(Bin), 
    PList = string:tokens(List, "\n"),
    [list_to_integer(X) || X <- PList].
