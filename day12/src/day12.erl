%% @author stuart
%% @doc @todo Add description to day12.


-module(day12).

-compile([export_all]).

%% ====================================================================
%% API functions
%% ====================================================================
-export([p1/0, 
 		p1_test/0,
		p2/0
		]).


-record(state, {
				pos = {0,0}, 
				direction = 90,
				ppid 
			   }).

p1() ->
	[].

p1_test() ->
	Str = "F10
N3
F7
R90
F11", 
	Input = string:tokens(Str, "\n"),
	Craft = start(),
	
	[ Craft ! {msg, E}|| E <- Input],
	?MODULE ! {get_pos, self()}.

p2() ->
	[].



%% ====================================================================
%% Internal functions
%% ====================================================================

%% Suspect part2 will have this as a seperate process. 
start() ->
	spawn_link(?MODULE, init, [self()]). 

init(PPid) ->
	process_flag(trap_exit, true),
	register(?MODULE, self()),
	run(#state{ppid = PPid}).

run(State) ->
		receive 
			{'EXIT', PPid,_} ->
				exit(normal);
			stop ->
				stop;
			{get_pos, From} ->
				From ! State#state.pos, 
				run(State);
			Msg ->
			NewState = process_msg(Msg, State), 
			run(NewState)
		end.


process_msg({msg, [Cmd|Tail]}, State = #state{pos = Pos, 
											  direction = Dir
											 }
) ->
	{N, _} = string:to_integer(Tail),
	{NewPos, NewDir} = case Cmd of 
		_ when Cmd == $L;
			   Cmd == $R ->
			case Cmd of
				$L ->
					{Pos, deg(Dir-N)};
				$R ->
					{Pos, deg(Dir+N)}
			end;
		_ ->
			DirMovement = case Cmd of 
				$F ->
					Dir;
				$N ->
					0;
							  $S ->
								  180;
							  $E ->
								  90;
							  $W ->
								  180+90
						  end,
			move(Dir, DirMovement, N, Pos)
					   end.
			
		  
move (Dir, DirMov, N, {X,Y}) when DirMov > 270, N < 90 ->
	{X+(N div math:tan(diff_deg(Dir, DirMov))), Y+N};
move (Dir, DirMov, N, {X,Y}) when DirMov > 270, N < 90 ->
	{X+(N div math:tan(diff_deg(Dir, DirMov))), Y-N};

move (Dir, DirMov, N, {X,Y}) when DirMov == 270 ->
	{X-N, Y-(N div math:tan(diff_deg(Dir, DirMov)))};
					
move (Dir, DirMov, N, {X,Y}) when DirMov == 90 ->
	{X+N, Y-(N div math:tan(diff_deg(Dir, DirMov)))}.


diff_deg(Dir, DirMov) ->
	case Dir - DirMov of
		N when N < 0 ->
			360-N;
		Any ->
			Any
	end.

deg(Deg) when Deg < 0 ->
	360 + Deg;
deg(Any) ->
	Any.




















read_input() ->
    {ok, Bin} = file:read_file("priv/input.txt"), 
    List = binary_to_list(Bin), 
    string:tokens(List, "\n").
			