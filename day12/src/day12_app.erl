%%%-------------------------------------------------------------------
%% @doc day12 public API
%% @end
%%%-------------------------------------------------------------------

-module(day12_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    day12_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
