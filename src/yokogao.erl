-module(yokogao).

-export([start/0]).
-export([stop/0]).

-export([start_trace/0]).
-export([start_trace/1]).
-export([stop_trace/0]).

-define(TIMEOUT, 1000).

%% ===================================================================
%% Pbulic
%% ===================================================================

start() ->
    application:start(?MODULE).

stop() ->
    application:stop(?MODULE).

start_trace() ->
    fprof:trace([start, {procs,processes()}]),
    ok.

start_trace(Time) ->
    start_trace(),
    timer:apply_after(Time, ?MODULE, stop_trace, []),
    ok.

stop_trace() ->
    fprof:trace(stop),
    fprof:profile(),
    fprof:analyse({dest, []}).

%% ===================================================================
%% Private
%% ===================================================================
