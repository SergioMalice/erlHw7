-module(homework7_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
	Dispatch = cowboy_router:compile([
		{'_', [
			{"/api/cache_server", cache_handler, []}
		]}
	]),
	% создаем соединение с обработчиком запросов cache_handler
	{ok, _Pid} = cowboy:start_clear(http,
		[{port, 8080}],
		#{env => #{dispatch => Dispatch}}),
	homework7_sup:start_link().

stop(_State) ->
	ok.