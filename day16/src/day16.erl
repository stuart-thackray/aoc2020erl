%% @author stuart
%% @doc @todo Add description to day16.


-module(day16).

%% ====================================================================
%% API functions
% ====================================================================
-export([p1/0,
		 p2/0
		]).


p1() ->
	Input = read_input(),
%% ,
	Rules = parse_rules(Input),
	Tickets = parse_tickets(Input), 
	Results = run_rules(Tickets, Rules),
	%% Onlhy one not mathching 
	lists:sum([X || {X, L} <- Results, 
			L == []]).
%% 	[].

p2() ->
		Input = read_input(),
%% ,
	Rules = parse_rules(Input),
			Tickets = parse_tickets(Input), 

		io:format("Rules~p~n", [Rules]),
		YT = parse_yt(Input),
%% 		io:format("YT~p~n", [YT]),
		
			Results = run_rules(Tickets, Rules),
  	Valid = [X || {X, L} <- Results, 
			L /= []],
		p2_run(Valid, Rules).
%% 		io:format("Invalid:~p~n", [Invalid]),
%% 		Valid.
%% 	p2_run(YT-- Invalid, Rules).
%% 	[].

%% ====================================================================
%% Internal functions
%% ====================================================================

p2_run([], _) ->
	[];
p2_run(_, []) ->
	[];
p2_run([Num|Tail], Rules) ->
	io:format("Num:~p~n", [Num]),
	case run_rules([Num], Rules) of
		[{_, []}] ->
			p2_run(Tail, Rules);
		[{_, L}] ->
			io:format("L~p~n", [L]),
			[
			 { 
			  hd(L), Num}|
				p2_run(Tail, lists:keydelete(hd(L), 1, 
											 lists:keydelete(hd(L), 1, Rules))
					  )]
	end.
		
	
	
	
parse_rules([Rules|_]) ->
	[{A, to_lh(B)} || {A,B} <- pr(string:tokens(Rules, "\n"))]. 
parse_tickets([_,_,Tickets]) ->
	Remove = string:tokens(Tickets, "nearby tickets:\n,"),
	[list_to_integer(L) || L <- Remove].

parse_yt([_,Tickets|_]) ->
	Remove = string:tokens(Tickets, "your ticket:\n,"),
	[list_to_integer(L) || L <- Remove].

to_lh(Str) ->
	[L, H] = string:tokens(Str, "-"), 
	{list_to_integer(L), list_to_integer(H)}.
pr([]) ->
	[];
pr([E|Tail]) ->
	[Name,Rest] = string:tokens(E, ":"),
	[R1, R2] = string:tokens(Rest, "or "), 
	
	[{Name, R1}, {Name, R2}|
	pr(Tail)].

run_rules([],_) ->
	[];
run_rules([E|Tails], Rules) ->
	[{E, 
	  	[ Name || {Name, {L, H}} <- Rules,
				  E>= L, 
				  E =< H]}|
		 run_rules(Tails, Rules)].  

read_input() ->
    {ok, Bin} = file:read_file("priv/input.txt"), 
    BinList = binary:split(Bin, <<10,10>>, [global]), 
    [binary_to_list(X) || X <- BinList].