-module(yokogao_server).

-behaviour(gen_server).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-export([start_link/0]).
-export([new_task/2]).

-record(state, { 
    }).

%% ===================================================================
%% Pbulic
%% ===================================================================

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

new_task(Timeout, File) ->
    gen_server:cast(?MODULE, {stop_in, Timeout, File}).

%% ===================================================================
%% gen_server
%% ===================================================================

init([]) ->
    {ok, #state{}}.

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast({stop_in, Timeout, File}, State) ->
    timer:send_after(Timeout, {stop_trace, File}),
    {noreply, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info({stop_trace, File}, State) ->
    fprof:trace(stop),
    fprof:profile(file, File),
    fprof:analyse(dest, fprof_result_file(File)),
    error_logger:info_msg("trace stopped"),
    {noreply, State};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ===================================================================
%% Private
%% ===================================================================

fprof_result_file(File) ->
    filename:basename(File, ".trace") ++ ".analysis".
