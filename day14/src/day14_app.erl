%%%-------------------------------------------------------------------
%% @doc day14 public API
%% @end
%%%-------------------------------------------------------------------

-module(day14_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    day14_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
