%% @author stuart
%% @doc @todo Add description to day9.


-module(day9).

%% ====================================================================
%% API functions
%% ====================================================================
-export([p1/0,
		 p1_test/0,
		 p2/0
]).

-define(INVALID_NUM_P1, 32321523). 
-define(INVALID_NUM_P1_STR, "32321523"). 


p1() ->
	Input = read_input(), 
	Map = maps:from_list(
			parse_to_tuple_list(Input, 1)
						),
	find_invalid(Map, 26,25).

p1_test() ->
	Str = "35
20
15
25
47
40
62
55
65
95
102
117
150
182
127
219
299
277
309
576",
	Input = string:tokens(Str, "\n"), 
	Map = maps:from_list(
			parse_to_tuple_list(Input, 1)
						),
	find_invalid(Map, 6,5).

p2() ->
	Input = read_input(), 
	RemovedNumList =[ X || X <- Input, 
					 X /= ?INVALID_NUM_P1_STR],
	Map = maps:from_list(
			parse_to_tuple_list(RemovedNumList, 1)
						),
	MaxLen = length(RemovedNumList),
	find_contiguous(2, Map, MaxLen)	.

find_contiguous(Pos, Map, MaxLen) ->
	SList = [maps:get(N, Map) || N <- lists:seq(1, Pos)], 
	case find_c(SList ) of 
		{yes,List} -> lists:max(List) + lists:min(List) ;
		_ -> find_contiguous(Pos+1, Map, MaxLen)
	end.

find_c([]) ->
	no;
find_c(All = [_E|Tail]) ->
	case lists:sum(All) of
		?INVALID_NUM_P1 ->
			{yes,All};
		_ ->
			find_c(Tail)
	end.


%% ====================================================================
%% Internal functions
%% ====================================================================

find_invalid(Map, Pos,NumberToGet) ->
	ToMatch = maps:get(Pos+1, Map ),
	CompareTo = [maps:get(U,Map)  || U <- lists:seq(Pos-NumberToGet, Pos)],
	case is_valid( CompareTo, CompareTo,  ToMatch) of
		valid ->
			find_invalid(Map, Pos+1, NumberToGet);
		_ -> 
			{invalid, ToMatch}
	end.


is_valid([], _,_) ->
	invalid;
is_valid([E|Tail], All, CompareTo) ->
	RemovedItself = All -- [E],
	case [X || X <- RemovedItself, 
		  	  (CompareTo - E - X) == 0 ] of
		[] ->
			%Invaid
			is_valid(Tail, All, CompareTo);
		_ ->
			valid
	end.






read_input() ->
    {ok, Bin} = file:read_file("priv/input.txt"), 
    List = binary_to_list(Bin), 
    string:tokens(List, "\n").


parse_to_tuple_list([], _ ) ->
	[];
parse_to_tuple_list([E|Tail], N) ->
	[{N, list_to_integer(E)}|
		parse_to_tuple_list(Tail, N+1)].	