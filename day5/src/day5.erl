%% @author stuart
%% @doc @todo Add description to day5.


-module(day5).
-compile([export_all]).
%% ====================================================================
%% API functions
%% ====================================================================
-export([p1/0,
		 test/0,
		 p2/0
		]).

p1() ->    
	Input = read_input(), 
	lists:max([work_out_pos(X) || X<- Input]).

p2() ->
	Input = read_input(),
	Results = [work_out_pos(X) || X <- Input],
	Sorted = lists:sort(Results),
	Min = lists:min(Results), 
	Max = lists:max(Results),
	find_seat(Sorted, Min, Max).

find_seat([],_,_) ->
	didnt_find;
find_seat([E,T|Tail], _, _) when E+2 == T -> E+1;
find_seat([E|Tail], M, Max) ->
	find_seat(Tail, M, Max).


test() ->
	Line = "FBFBBFFRLR", 
	work_out_pos(Line).

test2() ->
	Line = "BFFFBBFRRR",
	work_out_pos(Line).
test3() ->
	Line = "FFFBBBFRRR",
	work_out_pos(Line).

test4() ->
	Line = "BBFFBBFRLL",
	work_out_pos(Line).
%% ====================================================================
%% Internal functions
%% ====================================================================

work_out_pos(Str) ->
	Row = string:substr(Str, 1,7),
	Seat = string:substr(Str, 8),
%% 	io:format("Pos: ~p ",[{work_out_pos(Row, 0, 127), 
%% 	work_out_pos(Seat, 0, 7)} ]),
	seat_id({work_out_pos(Row, 0, 127), 
	work_out_pos(Seat, 0, 7)}).

seat_id({Row, Seat}) ->
	Row *8 + Seat.

work_out_pos([E|[]], Min, Max) ->
	case E of 
		_ when E == $F;
			   E == $L ->
			Min;
		_ ->
			Max
	end;
work_out_pos([E|Tail], Min, Max) ->
	case E of 
		_ when E == $F;
			   E == $L ->
			Mov = trunc(math:ceil((Max - Min) / 2)), 
			work_out_pos(Tail, Min, Max - Mov);
		_ ->
			Mov = trunc(math:ceil((Max - Min) / 2)),
			work_out_pos(Tail, Min+Mov, Max)
	end.


read_input() ->
    {ok, Bin} = file:read_file("priv/input.txt"), 
    List = binary_to_list(Bin), 
    string:tokens(List, "\n").

