%% @author stuart
%% @doc @todo Add description to day10.


-module(day10).

%% ====================================================================
%% API functions
%% ====================================================================
-export([p1/0,
		 p1_test/0,
		 p2/0
		]).

p1() ->
	Input = read_input(),
	IntList = [list_to_integer(X) || X <- Input],
	Parsed = lists:sort(IntList),
	{C1, C3} = c_1_3([0|Parsed], 0,1).

p1_test() ->
Str = "16
10
15
5
1
11
7
19
6
12
4",
	Input = string:tokens(Str, "\n"),
		IntList = [list_to_integer(X) || X <- Input],
	Parsed = lists:sort(IntList),
	{C1, C3} = c_1_3([0|Parsed], 0,1).

p2() ->
	[].

%% ====================================================================
%% Internal functions
%% ====================================================================
c_1_3(L, C1,C3) when L == [];
					 length(L) == 1 ->
	{C1, C3};
c_1_3([E,N|Tail], C1, C3) ->
	case N-E of
		1 ->
			c_1_3([N|Tail], C1+1, C3);
		3 ->
			c_1_3([N|Tail], C1, C3 +1 );
		Diff ->
			io:format("Diff:~p", [Diff]),
			c_1_3([N|Tail], C1, C3)
	end.



read_input() ->
    {ok, Bin} = file:read_file("priv/input.txt"), 
    List = binary_to_list(Bin), 
    string:tokens(List, "\n").

