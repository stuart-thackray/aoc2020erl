%% @author stuart
%% @doc @todo Add description to day3.


-module(day3).

%%  X ------------------ >
%%  Y
%%  |
%%  |
%%  |
%%  +
-define(OPEN, 0).
-define(TREE, 1).

-define(MOVE_X, 3).
-define(MOVE_Y, 1).

%% ====================================================================
%% API functions
%% ====================================================================
-export([p1/0,
		 p2/0
		]).

p1() ->
	Input = read_input(), 
	MaxX = length(hd(Input)),
	Map = parse_input(Input, #{max_x => MaxX }, 0,0),
	count_trees({0+?MOVE_X,0+?MOVE_Y}, Map, MaxX, 0).

p2() ->
	Input = read_input(), 
	MaxX = length(hd(Input)),
	Map = parse_input(Input, #{max_x => MaxX }, 0,0),
	count_trees_mov({0,0}, Map, MaxX, 0,{1,1})*
	count_trees_mov({0,0}, Map, MaxX, 0,{3,1})*
		count_trees_mov({0,0}, Map, MaxX, 0,{5,1})		*
		count_trees_mov({0,0}, Map, MaxX, 0,{7,1})	*
		count_trees_mov({0,0}, Map, MaxX, 0,{1,2}).




count_trees( {X,Y}, Map, MaxX,Cnt) when X>= MaxX ->
	count_trees({X-MaxX, Y}, Map, MaxX, Cnt);
count_trees({X, Y}, Map, MaxX, Cnt) ->
	case maps:get(max_y, Map) of
		Y -> Cnt;
		_ ->
			count_trees({X+?MOVE_X, Y+?MOVE_Y},
						Map, 
						MaxX,
						Cnt + maps:get({X,Y}, Map)
					   )
	end.


count_trees_mov( {X,Y}, Map, MaxX,Cnt,Mov) when X>= MaxX ->
	count_trees_mov({X-MaxX, Y}, Map, MaxX, Cnt,Mov);
count_trees_mov({X, Y}, Map, MaxX, Cnt, Mov = {MvX, MvY}) ->
	case maps:get(max_y, Map) of
		MaxY when Y >= MaxY -> Cnt;
		_ ->
		count_trees_mov({X+MvX, Y+MvY},
						Map, 
						MaxX,
						Cnt + maps:get({X,Y}, Map),
							Mov
					   )
	end.


%% ====================================================================
%% Internal functions
%% ====================================================================
parse_input([], Map, _,Y) ->
	Map#{max_y => Y};
parse_input([Line|Rest], Map, X, Y) ->
	NewMap = parse_line(Line, Map, X, Y),
	parse_input(Rest, NewMap, 0, Y+1).

parse_line([], Map, _,_) ->
	Map;
parse_line([E|Tail],Map, X, Y) ->
	Type = case E of 
		$. ->
			?OPEN;
		_ ->
			?TREE
			end,
	parse_line(Tail, 
			   Map#{{X,Y} => Type}, 
					X+1,
					Y).
			
			   
									

read_input() ->
	{ok, Bin} = file:read_file("priv/input.txt"), 
	List = binary_to_list(Bin), 
    string:tokens(List, "\n").

