%%%-------------------------------------------------------------------
%% @doc day19 public API
%% @end
%%%-------------------------------------------------------------------

-module(day19_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    day19_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
