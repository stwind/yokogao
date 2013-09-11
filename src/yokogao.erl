-module(yokogao).

-export([start/0]).
-export([stop/0]).

-export([start_trace/0]).
-export([start_trace/1]).
-export([start_trace/2]).

-define(TIMEOUT, 1000).
-define(FPROF_FILE, "fprof.trace").

%% ===================================================================
%% Pbulic
%% ===================================================================

start() ->
    application:start(?MODULE).

stop() ->
    application:stop(?MODULE).

start_trace() ->
    start_trace([]).

start_trace(Opts) ->
    start_trace(Opts, ?TIMEOUT).

start_trace(Opts, Timeout) ->
    fprof:trace(getopts(Opts, default_opts([start]))),
    yokogao_server:new_task(Timeout, ?FPROF_FILE).

%% ===================================================================
%% Private
%% ===================================================================

getopts([{procs, Procs} | Rest], Opts) ->
    Opts1 = lists:keyreplace(procs, 1, Opts, {procs, Procs}),
    getopts(Rest, Opts1);
getopts([_ | Rest], Opts) ->
    getopts(Rest, Opts);
getopts([], Opts) ->
    Opts.

default_opts(Opts) ->
    [{procs, processes()}, {file, ?FPROF_FILE} | Opts].
