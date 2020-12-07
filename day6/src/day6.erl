%% @author stuart
%% @doc @todo Add description to day6.


-module(day6).
-compile([export_all]).
%% ====================================================================
%% API functions
%% ====================================================================
-export([p1/0,
		 p2/0
		]).



p1() ->
	Input = read_input(), 
	Records = split_records(Input, <<>>),
	lists:sum([
			   day6:count_yes(
				 lists:flatten(
						   string:tokens(
										 X, "\n"
))) 
			  || 
				 X <- Records]) .

p2() -> 
		Input = read_input(), 
	Records = split_records(Input, <<>>),
	length(lists:flatten([count_agreed_yes(X ) || X <- Records])).

%% ====================================================================
%% Internal functions
%% ====================================================================
%% 
%% read_input() ->
%%     {ok, Bin} = file:read_file("priv/input.txt"), 
%%     List = binary_to_list(Bin), 
%%     string:tokens(List, "\n").

count_agreed_yes(Str) ->
	PeoplesAns = string:tokens(Str, "\n"),
	SortAns = [lists:usort(X) || X <- PeoplesAns],
	loop_union(tl(SortAns), hd(SortAns)).

loop_union([],  Mem) ->
	Mem;
loop_union([E|Tail], Mem) ->

	Union = union (Mem, E),
	loop_union(Tail, Union).


union([], _) ->
	[];
union([E|Tail], Str) ->
	case lists:member(E, Str) of
		true ->
			[E|union(Tail, Str)];
		false ->
			union(Tail, Str)
	end.
%% 
%% count_agreed_yes([],_) ->
%% 	0


count_yes(Str) -> 
	length(lists:usort(Str)).

read_input() ->
    {ok, Bin} = file:read_file("priv/input.txt"), 
    Bin.

split_records(<<>>, Mem) ->
    [binary_to_list(Mem)];
split_records(<<10,10, Rest/binary>>, Mem) ->
    [binary_to_list(Mem)| split_records(Rest, <<>>)];
split_records(<<E:1/binary, Rest/binary>>, Mem) ->
    split_records(Rest, <<Mem/binary, E:1/binary>>).
