%% @author stuart
%% @doc @todo Add description to intcode.


-module(intcode).

%% ====================================================================
%% API functions
%% ====================================================================
-export([p1_run/1,
		 parse_to_map/1,
		 parse_to_tuple_list/1,
		 init_loop/1,
		 run_loop/1,
		 p2_run/1
		]).


parse_to_map(Input) ->
	parse_to_map(Input, #{}, 0).
parse_to_tuple_list(Input) ->
	parse_to_tuple_list(Input, [], 0).


p2_run(Map) ->
	spawn_link(?MODULE, init_loop, 
			   [Map#{
										 pos => 0,
						 
						  visited => []
					}
			   ]
			  ).
									
%% ====================================================================
%% Internal functions
%% ====================================================================


p1_run(Input) ->
	put(acc,0),
		detect_dup(Input#{pos => 0,
						 
						  visited => []
						 }).

detect_dup(Map) ->
	Pos = maps:get(pos, Map),
	Visited = maps:get(visited, Map),
	case run_command(maps:get(Pos, Map), Map) of
		{next_pos, NPos} ->
			case lists:member(NPos, Visited ) of
				false ->
					detect_dup(Map#{pos => NPos,
									visited => [Pos|Visited]
								   });
				true ->
						get(acc)
			end
	end.

run_command({nop, _}, Map) ->
	{next_pos, maps:get(pos, Map)+1};
run_command({jmp, N} ,Map) ->
	 {next_pos, maps:get(pos, Map)+N};
run_command({acc, N}, Map) ->
	put(acc, get(acc) + N), 
		{next_pos, maps:get(pos, Map)+1}.


parse_to_map([], Map, _N) ->
	Map;
parse_to_map([E|Tail], Map, N) ->
	[Cmd, NumStr] = string:tokens(E, " "), 
	{Num,_} = string:to_integer(NumStr), 
	parse_to_map(Tail, 
	Map#{	
	N => {to_atom(Cmd), Num}},
N+1).


to_atom(Str) ->
	case catch list_to_existing_atom(Str) of 
		Atom when is_atom(Atom) -> Atom;
		_ -> list_to_atom(Str)
	end.

parse_to_tuple_list([], Mem, _N) ->
	lists:reverse(Mem);
parse_to_tuple_list([E|Tail], Mem, N) ->
	[Cmd, NumStr] = string:tokens(E, " "), 
	{Num,_} = string:to_integer(NumStr), 
	parse_to_tuple_list(Tail, 
	[{N,{to_atom(Cmd), Num}}|Mem],
N+1).


init_loop(Map) ->
	put(acc, 0),
	run_loop(Map).

run_loop(Map) ->
	Pos = maps:get(pos, Map),
	Visited = maps:get(visited, Map),
	Max = maps:get(max, Map),
	case run_command(maps:get(Pos, Map), Map) of
		{next_pos, NPos} when NPos == Max ->
			exit({finished,get(acc)});
		{next_pos, NPos}   ->
			case lists:member(NPos, Visited ) of
				false ->
					run_loop(Map#{pos => NPos
								 ,
									visited => [Pos|Visited]
								   });
				_ ->
					exit({loop, maps:get(id, Map), Pos,NPos})
			end

	end.


