%% @author stuart
%% @doc @todo Add description to day13.


-module(day13).

%% ====================================================================
%% API functions
%% ====================================================================
-export([p1/0,
		 p2/0
		]).


p1() ->
	[StartStr, BusesStr] = read_input(),
	Start = list_to_integer(StartStr), 
	put(start, Start), 
	ModList = [list_to_integer(X) || X <- string:tokens(BusesStr, ",x")],
	res(Start, ModList).

p2() ->
	[StartStr, BusesStr] = read_input(),
	ModList = [list_to_integer(X) || X <- string:tokens(BusesStr, ",x")],
%% 	BusesStr.
%% 
	find_num(1, ModList).

find_num(N, Buses= [Bus1, Bus2, Bus3, Bus4, Bus5, Bus6, Bus7, Bus8, Bus9]) ->
	case ((N rem Bus1) == 0) and
			 ((N+8 rem Bus2 )== 0) and
			 ((N+19 rem Bus3) == 0) and 
			 ((N+32 rem Bus4) == 0 ) and
			(( N+33 rem Bus5 )== 0) and
			 			(( N+48 rem Bus6 )== 0) and
			(( N+50 rem Bus7 )== 0) and
					(( N+56 rem Bus8 )== 0) and
					(( N+73 rem Bus9 )== 0) 

		of 
true ->
	N;
		_ ->
find_num (N, Buses)
end.
	

res(N, ModList) ->
	case [Y || Y <- ModList,
			  ( N rem Y) == 0 ] of 
		[] -> 
res(N +1, ModList);
		[E|Tail] ->
			(N - get(start)) * E
	end.


	


%% ====================================================================
%% Internal functions
%% ====================================================================





read_input() ->
    {ok, Bin} = file:read_file("priv/input.txt"), 
    List = binary_to_list(Bin), 
    string:tokens(List, "\n").
			