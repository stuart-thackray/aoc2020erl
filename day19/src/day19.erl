%% @author stuart
%% @doc @todo Add description to day19.


-module(day19).
-compile([export_all]).

%% ====================================================================
%% API functions
%% ====================================================================
-export([p1/0,
		 p1_test/0, 
		 p2/0
 		]).

-define(A, a).
-define(B, b).

p1() ->
 	[Rules, Paterns] = read_input(),
	MakeRules = make(string:tokens(Rules,"\n"), #{}),
	%% Stored in Atom Table
	_  = build_possible([0], MakeRules, []),
%% 	erase().
	lists:sum([Y || Y <- [get(X) || X <- string:tokens(Paterns, "\n")],
			Y /= undefined]).

p1_test() ->
	[Rules, Paterns] = ["0: 4 1 5
1: 2 3 | 3 2
2: 4 4 | 5 5
3: 4 5 | 5 4
4: \"a\"
5: \"b\"","ababbb
bababa
abbbab
aaabbb
aaaabbb"],
MakeRules = make(string:tokens(Rules,"\n"), #{}),
	%% Stored in Atom Table
	_  = build_possible([0], MakeRules, []),
%% 			erase().
	lists:sum([Y || Y <- [get(X) || X <- string:tokens(Paterns, "\n")],
			Y /= undefined]).
p2() ->
	 	[Rules, Paterns] = read_input(),
	MakeRules = make(string:tokens(Rules,"\n"), #{}),
	%% Stored in Atom Table
NewRules = MakeRules#{
					  8 => {[42] , [42,8]},
					  11 => {[42,31] , [42,11 ,31]}
					 
					  }, 
	Max = lists:max([length(Y) || Y <- string:tokens(Paterns, "\n")]),
%% ,
	[put(X, 0) || X <- string:tokens(Paterns, "\n")],
	_  = build_possible([0], NewRules, [], Max),
	erase().
%% 	lists:sum([Y || Y <- [get(X) || X <- string:tokens(Paterns, "\n")],
%% 			Y /= undefined]).

%% ====================================================================
%% Internal functions
%% ====================================================================
%% check_valid([], N) ->
%% 	put(N, 1),
%% 	[];
%% check_valid([E|Tail], N) ->
%% 	case catch list_to_existing_atom(E) of
%% 		{'EXIT', _} ->
%% 			check_valid(Tail, N);
%% 		_ ->
%% 			check_valid(Tail, N+1)
%% 	end.
	
build_possible([],_, Mem) ->
	put(lists:reverse(Mem)		,1);
build_possible([E|Tail], Map, Mem) when is_atom(E) ->
	Str = case E of 
		?A -> $a;
		_ 	-> 
			$b
	end,
	build_possible(Tail, Map, [Str|Mem]) ;
build_possible([E|Tail], Map, Mem) when is_tuple(E) ->
	{E1, E2} = E,
	[build_possible([E1|Tail], Map, Mem),
	build_possible([E2|Tail], Map, Mem)];
build_possible([[E1,E2]|Tail], Map, Mem) ->
	build_possible([maps:get(E1, Map), 
					maps:get(E2, Map)|
					Tail], Map, Mem);
build_possible([[E1,E2,E3]|Tail], Map, Mem) ->
	build_possible([maps:get(E1, Map), 
					maps:get(E2, Map),
					maps:get(E3, Map)|
					Tail], Map, Mem);
build_possible([[E]|Tail], Map, Mem) ->
	build_possible([maps:get(E, Map)|Tail], Map, Mem);
build_possible([E|Tail], Map, Mem) ->
	build_possible([maps:get(E, Map)|Tail], Map, Mem).

build_possible([],_, Mem,_) ->
	Str = lists:reverse(lists:flatten(Mem)),
	case get(Str) of 
		undefined ->
			[];
		N ->
			put(Str, N+1)
	end;
build_possible(Loop, _,Mem,Max) when (length(Loop)+length(Mem)) > Max ->
	io:format("l", []),
	[];
build_possible([E|Tail], Map, Mem, Max) when is_atom(E) ->
	Str = case E of 
		?A -> $a;
		_ 	-> $b
	end,
	build_possible(Tail, Map, [Str|Mem], Max) ;
build_possible([E|Tail], Map, Mem, Max) when is_tuple(E) ->
	{E1, E2} = E,
	[build_possible([E1|Tail], Map, Mem, Max),
	build_possible([E2|Tail], Map, Mem, Max)];
build_possible([[E1,E2]|Tail], Map, Mem, Max) ->
	build_possible([maps:get(E1, Map), 
					maps:get(E2, Map)|
					Tail], Map, Mem, Max);
build_possible([[E1,E2,E3]|Tail], Map, Mem, Max) ->
	build_possible([maps:get(E1, Map), 
					maps:get(E2, Map),
					maps:get(E3, Map)|
					Tail], Map, Mem, Max);
build_possible([[E]|Tail], Map, Mem, Max) ->
	build_possible([maps:get(E, Map)|Tail], Map, Mem, Max);
build_possible([E|Tail], Map, Mem, Max) ->
	build_possible([maps:get(E, Map)|Tail], Map, Mem, Max).


make([],Map) ->
	Map;
make([E|Tail], Map) ->
	 [RuleN, Rules] = string:tokens(E, ":"),
	AppRules = case	 string:tokens(Rules, "|") of
		L = [V] when length(L) == 1 ->
			parse_value(V);
		[V1, V2] ->
			{parse_value(V1), 
			 parse_value(V2)
			}
	end, 
	 make(Tail, 
		  
	 Map#{list_to_integer(RuleN) => AppRules}).

parse_value(Str) ->
	case lists:member($", Str) of
		true ->
%Terminating Char
		case string:tokens(Str, " \"") of
			["a"] ->
					?A;
			_ -> ?B
		end;
	_ ->
		[list_to_integer(X) || X <- string:tokens(Str, " ")]
	end.

	
read_input() ->
    {ok, Bin} = file:read_file("priv/input.txt"), 
    BinList = binary:split(Bin, <<10,10>>, [global]), 
    [binary_to_list(X) || X <- BinList].