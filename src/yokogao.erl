-module(yokogao).

-export([start/0]).
-export([stop/0]).

-export([start_trace/0]).
-export([start_trace/1]).
-export([trace_for/0]).
-export([trace_for/2]).
-export([stop_trace/1]).
-export([trace_fun/2]).

-define(TIMEOUT, 1000).

%% ===================================================================
%% Pbulic
%% ===================================================================

start() ->
    application:start(?MODULE).

stop() ->
    application:stop(?MODULE).

trace_fun(Fun, Args) ->
    File = fun_file(Fun),
    fprof:apply(Fun, Args, [{file, File}]),
    fprof:profile(file, File),
    fprof:analyse({dest, result_file(File)}),
    file:delete(File).

start_trace() ->
    start_trace(trace_file("fprof")).

start_trace(Name) ->
    File = file(Name),
    fprof:trace([start, {procs,processes()}, {file, File}]),
    {ok, File}.

trace_for() ->
    trace_for(?TIMEOUT, "fprof").

trace_for(Time, Name) ->
    {ok, File1} = start_trace(Name),
    timer:apply_after(Time, ?MODULE, stop_trace, [File1]),
    ok.

stop_trace(File) ->
    fprof:trace(stop),
    fprof:profile(file, File),
    fprof:analyse({dest, result_file(File)}),
    file:delete(File).

%% ===================================================================
%% Private
%% ===================================================================

get_env(Key, Default) ->
    case application:get_env(yokogao, Key) of
        {ok, Value} ->
            Value;
        undefined ->
            Default
    end.

file(Name) ->
    LogDir = get_env(log_dir, "log"),
    File = filename:join(LogDir, trace_file(Name)),
    ok = filelib:ensure_dir(File),
    File.

result_file(File) ->
    Dir = filename:dirname(File),
    filename:join(Dir, filename:basename(File, ".trace") ++ ".analysis").

i2l(V) ->
    integer_to_list(V).

a2l(V) ->
    atom_to_list(V).

trace_file(Name) ->
    {{_, M, D},{H, Min, S}} = calendar:local_time(),
    lists:flatten([Name,"_",i2l(M),"_",i2l(D),"_",
            i2l(H),"_",i2l(Min),"_",i2l(S),".trace"]).

fun_file(Fun) ->
    case erlang:fun_info(Fun, module) of
        {module, erl_eval} ->
            {name, FunName} = erlang:fun_info(Fun, name),
            "-expr/5-" ++ Name = a2l(FunName),
            file("erl_eval_" ++ Name);
        {module, Mod} ->
            {name, Name} = erlang:fun_info(Fun, name),
            file(a2l(Mod) ++ "_" ++ a2l(Name))
    end.
