%% @author stuart
%% @doc @todo Add description to day14.


-module(day14).

-compile([export_all]).
%% ====================================================================
%% API functions
%% ====================================================================
-export([p1/0,
		 p2/0
		]).

-define(SET, $1).
-define(UNSET, $0).
-define(X, $X).

p1() ->
	Input = read_input(), 
	MapRes = run(Input, #{}),
	lists:sum([Y || {X, Y} <- maps:to_list(MapRes),
				   is_integer(X)]).

p2() ->
	[].

%% ====================================================================
%% Internal functions
%% ====================================================================
run([], Map) ->
	Map;
run([E = [$m,$a,$s|_]|Tail], Map) ->
	[RemoveStart] = string:tokens(E, "mask = "),
	run(Tail, 
		Map#{mask => RemoveStart});
run([E|Tail], Map) ->
	%% TODO Code:
	[MemIndStr,Str] = string:tokens(E, "me[] = "),
	MemInd = list_to_integer(MemIndStr), 
	Value = list_to_integer(Str),
	Bin = binary:encode_unsigned(Value),
	Mask = maps:get(mask, Map),
	Applied = apply_mask(Mask, pad(Bin)),
	NewValue = binary:decode_unsigned(<<0:4, Applied/bits>>),
	run(Tail,
		Map#{ MemInd => NewValue}).


apply_mask([], _) ->
	<<>>;
apply_mask([?X|Tail], <<B:1, Rest/bits>>) ->
	Bin = apply_mask(Tail, Rest),
	<<B:1, Bin/bits>>;
apply_mask([?SET|Tail], <<_:1, Rest/bits>>) ->
	Bin = apply_mask(Tail, Rest),
	<<1:1, Bin/bits>>;
apply_mask([?UNSET|Tail], <<_:1, Rest/bits>>) ->
	Bin = apply_mask(Tail, Rest),
	<<0:1, Bin/bits>>.

pad(Bin) ->
	Len = size(Bin),
	Additional=(4-Len)*8,
	<<0:4, 0:Additional, Bin/binary>>.

read_input() ->
    {ok, Bin} = file:read_file("priv/input.txt"), 
    List = binary_to_list(Bin), 
    string:tokens(List, "\n").