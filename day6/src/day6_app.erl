%%%-------------------------------------------------------------------
%% @doc day6 public API
%% @end
%%%-------------------------------------------------------------------

-module(day6_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    day6_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
