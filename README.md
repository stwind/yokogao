Yokogao
=======

Erlang application profiling toolkit.

## Usage

### Config

```erlang
{yokogao, [
	{log_dir, "log"}
]}
```

### Tracing

#### Tracing Function

```erlang
yokogao:trace_fun(fun erlang:memory/0, []).
```

#### Tracing for a period

Trace for one second.

```erlang
yokogao:trace_for(1000).
```

#### Custom tracing period

```erlang
{ok, File} = yokogao:start_trace("my_trace"),
%% do something
ok = yokogao:stop_trace(File).
```

### Analyzing

You should find the `.analysis` files in the `log_dir` (default to `log`) folder, e.g. `fprof_9_12_10_49_4.analysis`.

Then you can convert it to callgrind output:
```bash
make grind FILE=fprof_9_12_10_49_4
```
this will produce a `fprof_9_12_10_49_4.cgrind` file, which can be interpreted by `kcachegrind` (`qcachegrind` in OSX case).

Now you can do to inspect the results
```bash
qcachegrind log/fprof_9_12_10_49_4.cgrind
```