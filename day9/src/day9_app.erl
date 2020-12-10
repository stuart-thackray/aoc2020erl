%%%-------------------------------------------------------------------
%% @doc day9 public API
%% @end
%%%-------------------------------------------------------------------

-module(day9_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    day9_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
