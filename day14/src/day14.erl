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
		Input = read_input(), 
	MapRes = run2(Input, #{}),
	lists:sum([Y || {X, Y} <- maps:to_list(MapRes),
				   is_integer(X)]).

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
	[MemIndStr,Str] = string:tokens(E, "me[] = "),
	MemInd = list_to_integer(MemIndStr), 
	Value = list_to_integer(Str),
	Bin = binary:encode_unsigned(Value),
	Mask = maps:get(mask, Map),
	Applied = apply_mask(Mask, pad(Bin)),
	NewValue = binary:decode_unsigned(<<0:4, Applied/bits>>),
	run(Tail,
		Map#{ MemInd => NewValue}).

run2([], Map) ->
	Map;
run2([E = [$m,$a,$s|_]|Tail], Map) ->
	[RemoveStart] = string:tokens(E, "mask = "),
	run2(Tail, 
		Map#{mask => RemoveStart});
run2([E|Tail], Map) ->
	[MemIndStr,Str] = string:tokens(E, "me[] = "),
	MemInd = list_to_integer(MemIndStr), 
	Value = list_to_integer(Str),
	MemIndBin = binary:encode_unsigned(MemInd),
	Mask = maps:get(mask, Map),
	Applied = lists:flatten(apply_mem_mask(Mask, pad(MemIndBin), <<>>)),
	NewMap = apply_values_to_ind(Applied, Map, Value),
 	run2(Tail, NewMap).
%% 	NewValue = binary:decode_unsigned(<<0:4, Applied/bits>>),
%% 	run2(Tail,
%% 		Map#{ MemInd => NewValue}).
apply_values_to_ind([],Map, Value) ->
	Map;
apply_values_to_ind([E|Tail], Map, Value) ->
	apply_values_to_ind(Tail, 
						Map#{ E => Value}, 
						Value).


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

apply_mem_mask([], _, Mem ) ->
	binary:decode_unsigned(<<0:4,Mem/bits>>);
apply_mem_mask([?X|Tail], <<_:1, Rest/bits>>, Mem) ->
	[ apply_mem_mask(Tail, Rest, << Mem/bits, 1:1>> ),
	  apply_mem_mask(Tail, Rest, << Mem/bits, 0:1>>)];
%% 	
%% 	[<<Mem/bits, 1:1, apply_mem_mask , 
%% 	 [0:1, Bin/bits ]];
apply_mem_mask([?SET|Tail], <<_:1, Rest/bits>>, Mem ) ->
	 apply_mem_mask(Tail, Rest, <<Mem/bits, 1:1>>);

apply_mem_mask([?UNSET|Tail], <<E:1, Rest/bits>>, Mem) ->
	apply_mem_mask(Tail, Rest, <<Mem/bits, E:1>>).

pad(Bin) ->
	Len = size(Bin),
	Additional=(4-Len)*8,
	<<0:4, 0:Additional, Bin/binary>>.

read_input() ->
    {ok, Bin} = file:read_file("priv/input.txt"), 
    List = binary_to_list(Bin), 
    string:tokens(List, "\n").