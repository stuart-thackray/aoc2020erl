%%%-------------------------------------------------------------------
%% @doc day7 public API
%% @end
%%%-------------------------------------------------------------------

-module(day7_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    day7_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
