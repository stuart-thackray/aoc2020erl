%% @author stuart
%% @doc @todo Add description to day2.


-module(day2).

%% ====================================================================
%% API functions
%% ====================================================================
-export([p1/0, 
		p2/0]).

-record(password, { min, 
					max, 
					char, 
					str,
					count, 
					valid
  				  }).

p1() ->
	Input = read_input(), 
	Recs = parse_input(Input),
	length([X || X=#password{min = Min, 
					 max = Max,
					 count = Count} <- Recs, 
			Count =< Max,
		  	Count >= Min]).

p2() ->
	Input = read_input(), 
	Recs = parse_input(Input),
	ParsedRecs = p2_valid(Recs),
	length([X || X =#password{valid = V} <- ParsedRecs,
				 V == valid]).



%% ====================================================================
%% Internal functions
%% ====================================================================

read_input() ->
	{ok, Bin} = file:read_file("priv/input.txt"), 
	List = binary_to_list(Bin), 
    string:tokens(List, "\n").


parse_input([]) ->
	[];
parse_input([Line|Rest]) ->
	[Min,Max,Char= [Match],Str] = string:tokens(Line, " -:"),
	[#password{min= list_to_integer(Min),
			   max = list_to_integer(Max), 
			   char = Char, 
			   str = Str,
			   count = length([X || X <- Str, 
									X == Match])}|
		 parse_input(Rest)].


p2_valid([]) ->
	[];
p2_valid([X = #password{min = Pos1,
max = Pos2, 
str = Str,
char = Char}| Rest]) ->
	Pos1Char = string:substr(Str, Pos1, 1),
	Pos2Char = string:substr(Str, Pos2, 1),
	Res=	case ((Pos1Char == Char)  and ( Char /= Pos2Char)) or 
				((Pos1Char /= Char)  and ( Char == Pos2Char)) 	 of
				true ->
					valid;
				_ ->
					invalid
			end,
	[X#password{valid = Res}|p2_valid(Rest)].



	