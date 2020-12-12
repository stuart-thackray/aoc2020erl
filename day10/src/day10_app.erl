%%%-------------------------------------------------------------------
%% @doc day10 public API
%% @end
%%%-------------------------------------------------------------------

-module(day10_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    day10_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
