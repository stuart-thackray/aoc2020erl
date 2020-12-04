%%%-------------------------------------------------------------------
%% @doc day2 public API
%% @end
%%%-------------------------------------------------------------------

-module(day2_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    day2_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
