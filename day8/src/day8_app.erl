%%%-------------------------------------------------------------------
%% @doc day8 public API
%% @end
%%%-------------------------------------------------------------------

-module(day8_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    day8_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
