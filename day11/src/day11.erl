%% @author stuart
%% @doc @todo Add description to day11.


-module(day11).

-compile([export_all]).

-define(EMPTY, $L). 
-define(FLOOR, $.).
-define(OCCUPIED, $#).
%% ====================================================================
%% API functions
%% ====================================================================
-export([p1/0,
		 p1_test/0,
		p2/0
]).


p1() ->
		Input = read_input(), 
	Map = parse_input(Input, 0, #{}), 
	Rows = length(Input), 
	Cols = length(hd(Input)),
	io:format("Rows:~p~n", [Rows]),
	print(Rows, Cols, Map) ,

	Stabblized = chaos_stab(1,Map,{Cols,Rows}),
			print(Rows, Cols, Stabblized) ,

	length([X || {_,X} <- maps:to_list(Stabblized), 
			X == ?OCCUPIED]).

p1_test() ->
	Input = read_input_test(), 
	Map = parse_input(Input, 0, #{}), 
	Rows = length(Input), 
	Cols = length(hd(Input)),
	
print(Rows, Cols, Map) ,
%% 	MapStep1 = step({0,0}, Map, Map,{Cols,Rows}),
%% 	print(Rows,Cols, MapStep1).
	Stabblized = chaos_stab(1,Map,{Cols,Rows}),
	length([X || {_,X} <- maps:to_list(Stabblized), 
			X == ?OCCUPIED]).

chaos_stab(N,Map, Max) ->
	Stepped = step({0,0}, Map, Map,Max) ,
%% 	print(Cols,Rows, Stepped),
	case Stepped =:= Map of 
		true -> Stepped;
		_ ->
			chaos_stab(N+1, Stepped, Max) 
	end.
			
p2() ->
		Input = read_input(), 
	Map = parse_input(Input, 0, #{}), 
	Rows = length(Input), 
	Cols = length(hd(Input)),
	io:format("Rows:~p~n", [Rows]),
	print(Rows, Cols, Map) ,

	Stabblized = chaos_stab2(1,Map,{Cols,Rows}),
			print(Rows, Cols, Stabblized) ,

	length([X || {_,X} <- maps:to_list(Stabblized), 
			X == ?OCCUPIED]).

p2_test() ->
		Input = read_input_test(), 
	Map = parse_input(Input, 0, #{}), 
	Rows = length(Input), 
	Cols = length(hd(Input)),
	io:format("Rows:~p~n", [Rows]),
	print(Rows, Cols, Map) ,
		Map.
%% 
%% 	Stabblized = chaos_stab2(1,Map,{Cols,Rows}),
%% 			print(Rows, Cols, Stabblized) ,
%% 
%% 	length([X || {_,X} <- maps:to_list(Stabblized), 
%% 			X == ?OCCUPIED]).

chaos_stab2(N,Map, Max = {Cols, Rows}) ->
	Stepped = step2({0,0}, Map, Map,Max) ,
%% 	print(Cols,Rows, Stepped),
	case Stepped =:= Map of 
		true -> Stepped;
		_ ->
			chaos_stab2(N+1, Stepped, Max) 
	end.
			

%% ====================================================================
%% Internal functions
%% ====================================================================


step({_X, Y},Map, _, {_,Y}) ->
	Map;
step({X,Y}, Map,OMap, {X,MaxY}) ->
	step({0,Y+1}, Map, OMap, {X,MaxY});
step({X,Y}, Map, OMap, {MaxX, MaxY}) ->
%% 	io:format("X:~pY:~p", [X,Y]),
	case maps:get({X,Y}, OMap) of
		?FLOOR ->
			step({X+1, Y}, Map, OMap, {MaxX, MaxY});
		?OCCUPIED ->
			case length([U || U <-
				[occ({Z,K}, OMap)|| {Z,K} <- [{X-1,Y}, {X+1,Y}, {X,Y-1}, 
									   {X,Y+1},{X+1,Y+1}, {X-1, Y-1},
									   {X+1, Y-1}, {X-1, Y+1}]],
							 U == true]) 
				of
				True when True >= 4 ->
					step({X+1, Y}, Map#{ {X,Y} => ?EMPTY},
						 OMap, {MaxX, MaxY}) ;
				_ ->
					step({X+1, Y}, Map,
						 OMap, {MaxX, MaxY}) 
			end;
		?EMPTY ->
			case length([U || U <-
				[occ({Z,K}, OMap)|| {Z,K} <- [{X-1,Y}, {X+1,Y}, {X,Y-1}, 
									   {X,Y+1},{X+1,Y+1}, {X-1, Y-1},
									   {X+1, Y-1}, {X-1, Y+1}]],
							 U == true]) of
				0 ->
										step({X+1, Y}, Map#{ {X,Y} => ?OCCUPIED},
						 OMap, {MaxX, MaxY}) ;
				_ ->
									step({X+1, Y}, Map,
						 OMap, {MaxX, MaxY}) 
			end
	end.

step2({_X, Y},Map, _, {_,Y}) ->
	Map;
step2({X,Y}, Map,OMap, {X,MaxY}) ->
	step2({0,Y+1}, Map, OMap, {X,MaxY});
step2(Pos = {X,Y}, Map, OMap, {MaxX, MaxY}) ->
%% 	io:format("X:~pY:~p", [X,Y]),
	case maps:get({X,Y}, OMap) of
		?FLOOR ->
			step2({X+1, Y}, Map, OMap, {MaxX, MaxY});
		?OCCUPIED ->
			case length([U || U <-
				[occ(Pos,{Z,K}, OMap)|| {Z,K} <- [{-1,0}, {+1,0}, {0,0-1}, 
									   {0,+1},{+1,+1}, {0-1, 0-1},
									   {+1, -1}, {-1, +1}]],
							 U == true]) 
				of
				True when True >= 5 ->
					step2({X+1, Y}, Map#{ {X,Y} => ?EMPTY},
						 OMap, {MaxX, MaxY}) ;
				_ ->
					step2({X+1, Y}, Map,
						 OMap, {MaxX, MaxY}) 
			end;
		?EMPTY ->
			case length([U || U <-
				[occ(Pos, {Z,K}, OMap)|| {Z,K} <-  [{-1,0}, {+1,0}, {0,-1}, 
									   {0,+1},{+1,+1}, {0-1, 0-1},
									   {+1, -1}, {-1, +1}]],
							 U == true]) of
				0 ->
										step2({X+1, Y}, Map#{ {X,Y} => ?OCCUPIED},
						 OMap, {MaxX, MaxY}) ;
				_ ->
									step2({X+1, Y}, Map,
						 OMap, {MaxX, MaxY}) 
			end
	end.

occ({X,Y}, Map) ->
	case catch maps:get({X,Y}, Map) of
		?OCCUPIED ->
			true;
		_ ->
			false
	end.

occ({X,Y}, Diff = {ZX,ZY}, Map) ->
	case catch maps:get({X+ZX,Y+ZY}, Map) of
		{'EXIT', _} ->
			false;
		?EMPTY -> 
			false;
		?OCCUPIED ->
			true;
		?FLOOR ->
			occ({X+ZX, Y+ZY}, Diff, Map)
	end.



parse_input([], _, Map) ->
	Map; 
parse_input([E|Tail], Y, Map) ->
	parse_input(Tail, Y+1, 
				maps:merge(Map,maps:from_list(parse_row(E,0, Y)))
			   ).

parse_row([],_,_)->
	[];
parse_row([E|Tail], X, Y) ->
	[{{X,Y},E}|
		 parse_row(Tail, X+1, Y)
	].

print(Rows, Col, Map) ->
	print(0,0, Map, Rows, Col).

print(_X,Y, _, Y,_) ->
	io:format("~n", []);
print(X, Y,Map,MaxY,X) ->
	io:format("~n", []),
	print(0, Y+1, Map, MaxY,X);
print(X, Y, Map, MaxY,MaxX) ->
	io:format("~s", [[maps:get({X,Y}, Map)]]),
	print(X+1,Y,Map, MaxY, MaxX).

read_input() ->
    {ok, Bin} = file:read_file("priv/input.txt"), 
    List = binary_to_list(Bin), 
    string:tokens(List, "\n").

read_input_test() ->
    {ok, Bin} = file:read_file("priv/input_test.txt"), 
    List = binary_to_list(Bin), 
    string:tokens(List, "\n").