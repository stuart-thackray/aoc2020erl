%%%-------------------------------------------------------------------
%% @doc day17 public API
%% @end
%%%-------------------------------------------------------------------

-module(day17_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    day17_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
