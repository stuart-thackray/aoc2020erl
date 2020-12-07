%% @author stuart
%% @doc @todo Add description to day7.


-module(day7).

%% ====================================================================
%% API functions
%% ====================================================================
-export([p1/0,
		 p2/0
		]).

p1() ->
	Input = read_input(), 
	PuzzleInput = parse_input(Input),
%% 		StartPoint = find_records("shiny gold", lists:flatten(PuzzleInput)).
%% 	
 	search_end_points( ["shiny gold"], PuzzleInput,  []).


parse_input(Input) ->
	P1 = [remove_punctuation(X) || X <-Input],
%% 	P2 = [remove_bags(X) || X <- P1]. 
	[parse_to_tuple_list(X) || X <- P1].

p2() ->
	[].


search_end_points([], _,  EndPoints) ->

	lists:concat(EndPoints);
search_end_points(Points, Puzzle, EndPoints) ->
%% 	io:format("Points:~p EndPoints:~p~n", [Points, EndPoints]),
%% 	receive after 1000 -> void end, 
	Records = lists:concat([find_records(Y, Puzzle) || Y <- Points]),
	io:format("~nRecords:~p", [Records]),
	NewEP = [S|| S<- Records, 
					 is_tuple(S)], 
	SearchPoints = [T || T<- Records, 
						 is_list(T)],
	search_end_points(
	  lists:usort(SearchPoints), 
	  Puzzle, 
	  [[{U, other}|| U <- SearchPoints], NewEP,EndPoints]
				  
					 ). 
	

%% ====================================================================
%% Internal functions
%% ====================================================================
find_records(Search, PuzzleInput) ->
	[Y|| Y <-
			 [search(Search, X) || X <- PuzzleInput],
		Y /= []].

search(_, {_,[]}) ->
	[];
search(_Str,  {Key, [no_other]}) ->
	{Key, no_other};
search(Str,  {Key, [{_,Str}|_Tail]} )->
	Key;
search(Str, {Key, [_|Tail]}) ->
	search (Str, {Key, Tail}).

read_input() ->
    {ok, Bin} = file:read_file("priv/input.txt"), 
    List = binary_to_list(Bin), 
    string:tokens(List, "\n").

remove_punctuation(Str) ->
	[X || X <- Str, 
			X /= $. ,
			X /= $,].


remove_bags([]) ->
	[];
remove_bags([$b,$a,$g,$s|Rest]) ->
	remove_bags(Rest);
remove_bags([E|Tail]) ->
	[E|remove_bags(Tail)].
%% 
%% 	lists:flatten(string:tokens(Str, "bags")).

parse_to_tuple_list(Str) ->
	[StrBag, StrComBags] = string:split(Str, "contain "),
	BagsSplit1 = string:split(StrComBags, "bag", all),
	%%Remove empty splits
	BagsSplit2 = [Y || Y <- BagsSplit1, 
					   Y /= [],
					   Y /= "s"],	
	
	{string:strip(remove_bags(StrBag), both, $  ),
	 [split_to_tuple(N) || N <- BagsSplit2]}.

split_to_tuple([$ |Tail]) ->
	split_to_tuple(Tail);
split_to_tuple([$s|Tail]) ->
	split_to_tuple(Tail);
split_to_tuple([$n,$o,$ ,$o,$t,$h|_]) ->
	no_other;
split_to_tuple(Str) ->
%% 	io:format("Str:~p~n", [Str]),
	{N, Res} = string:to_integer(Str), 
	{N, string:strip(Res, both, $ )}.
	  
	  
	  
	  
	