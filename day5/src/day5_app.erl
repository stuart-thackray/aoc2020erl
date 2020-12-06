%%%-------------------------------------------------------------------
%% @doc day5 public API
%% @end
%%%-------------------------------------------------------------------

-module(day5_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    day5_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
