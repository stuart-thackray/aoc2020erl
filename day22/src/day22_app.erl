%%%-------------------------------------------------------------------
%% @doc day22 public API
%% @end
%%%-------------------------------------------------------------------

-module(day22_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    day22_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
