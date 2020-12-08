%% @author stuart
%% @doc @todo Add description to day8.


-module(day8).
-compile([export_all]).

%% ====================================================================
%% API functions
%% ====================================================================
-export([p1/0,
		 p1_test/0,
		 p2/0,
		 p2_test/0
		]).
p1_test() ->
	[].
	
p1() ->
	Input = read_input(), 
	Map = intcode:parse_to_map(Input),
	intcode:p1_run(Map).
%% 	[].

p2() ->
	process_flag(trap_exit, true),
	Input = read_input(), 
	Steps = intcode:parse_to_tuple_list(Input),
	MaxSteps = length(Steps),
	Uni = [maps:from_list(
				[{id,0},{max, MaxSteps}|Steps])|
					 
					 
					 
					 [Y || Y <- [generate_possible(N, 
					   Steps, 
					   MaxSteps
					  )
					  || N <- lists:seq(0, MaxSteps)],
		 Y /= not_new]],
	[intcode:p2_run(U) || U <- Uni],
	recieve_loop().

p2_test() ->
		process_flag(trap_exit, true),

	Str = "nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6",
	Input = string:tokens(Str, "\n"),
	Steps = intcode:parse_to_tuple_list(Input),
	MaxSteps = length(Steps),
	Uni = [maps:from_list(
				[{id,0},{max, MaxSteps}|Steps])|
					 
					 
					 
					 [Y || Y <- [generate_possible(N, 
					   Steps, 
					   MaxSteps
					  )
					  || N <- lists:seq(0, MaxSteps)],
		 Y /= not_new]],
	[intcode:p2_run(U) || U <- Uni],
	recieve_loop().

p2_test2() ->
		process_flag(trap_exit, true),

	Str = "nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6",
	Input = string:tokens(Str, "\n"),
	Steps = intcode:parse_to_tuple_list(Input),
	MaxSteps = length(Steps),
	Uni = [maps:from_list(
				[{id,0},{max, MaxSteps}|Steps])|
					 
					 
					 
					 [Y || Y <- [generate_possible(N, 
					   Steps, 
					   MaxSteps
					  )
					  || N <- lists:seq(0, MaxSteps)],
		 Y /= not_new]].
%% ,
%% 	[intcode:p2_run(U) || U <- Uni],
%% 	recieve_loop().


recieve_loop() ->
	receive 
		{'EXIT',_,{finished, N}} ->
			N

	after 1200000 ->
		%% Kill off any children
		a-1
	end.

%% ====================================================================
%% Internal functions
%% ====================================================================


read_input() ->
    {ok, Bin} = file:read_file("priv/input.txt"), 
    List = binary_to_list(Bin), 
    string:tokens(List, "\n").


generate_possible(N, Steps, MaxSteps) ->
	case lists:keysearch(N, 1, Steps) of
		{value, {_, {Atom,V}}} when Atom == jmp;
Atom == nop->
			maps:from_list(
				[{id,N},{max, MaxSteps}|lists:keyreplace(N, 1, Steps, {N, {if Atom == jmp -> nop;
														 Atom == nop -> jmp
													  end, V}})]);
		_Other ->
%% 			io:format("Other:~p~n", [_Other]),
			not_new
	end.


	