%%%-------------------------------------------------------------------
%% @doc day4 public API
%% @end
%%%-------------------------------------------------------------------

-module(day4_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    day4_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
