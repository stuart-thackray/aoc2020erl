%%%-------------------------------------------------------------------
%% @doc day11 public API
%% @end
%%%-------------------------------------------------------------------

-module(day11_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    day11_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
