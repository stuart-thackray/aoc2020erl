%%%-------------------------------------------------------------------
%% @doc day15 public API
%% @end
%%%-------------------------------------------------------------------

-module(day15_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    day15_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
