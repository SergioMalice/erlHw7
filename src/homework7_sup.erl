% наблюдатель запускает cache-сервер

-module(homework7_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).
-include("../include/settings.hrl").

start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
	Procs = [{?SERVER, {?SERVER, start_link, [?TName, [{drop_interval, ?ClearInterval}]]},
		permanent, 2000, worker, [?SERVER, ?Cleaner]}],
	{ok, {{one_for_one, 1, 5}, Procs}}.