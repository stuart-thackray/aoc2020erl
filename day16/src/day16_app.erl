%%%-------------------------------------------------------------------
%% @doc day16 public API
%% @end
%%%-------------------------------------------------------------------

-module(day16_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    day16_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
