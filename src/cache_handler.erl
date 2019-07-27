-module(cache_handler).

-export([init/2]).
-include("../include/settings.hrl").

% обработчик POST-запросов
init(#{method := <<"POST">>} = Req0, Opts) ->
  % считываем тело запроса в Body
  {ok, Body, _Req} = cowboy_req:read_body(Req0),
  % парсим запрос из JSON в map Query для разбора
  Query = jsx:decode(Body, [return_maps]),
  % разбор вариантов запроса по спецификации
  Res = case maps:get(<<"action">>, Query) of
    % создание записи
    <<"insert">> -> ?SERVER:insert(
      ?TName,
      maps:get(<<"key">>, Query),
      maps:get(<<"value">>, Query),
      maps:get(<<"life">>, Query)
    ), <<"{\"result\":\"ok\"}">>;

    % возврат актуальных записей
    <<"lookup">> ->
      jsx:encode(?SERVER:lookup(?TName, maps:get(<<"key">>, Query)));

    % возврат записей, созданных в заданный промежуток времени
    <<"lookup_by_date">> ->
      jsx:encode(?SERVER:lookup_by_date(
        ?TName,
        string_to_date(maps:get(<<"date_from">>, Query)),
        string_to_date(maps:get(<<"date_to">>, Query))
      ))
  end,
  Req = cowboy_req:reply(200, #{
    <<"content-type">> => <<"text/plain">>
  }, <<Res/binary, "\n">>, Req0),
  {ok, Req, Opts};

init(Req0, Opts) -> % ответ на любые запросы, кроме POST
  Req = cowboy_req:reply(200, #{
    <<"content-type">> => <<"text/plain">>
  }, <<"Not POST query">>, Req0),
  {ok, Req, Opts}.

% преобразовывает строку вида <<"2015/1/1 00:00:00">> в тип calendar Date()
string_to_date(String) ->
  [YMD, HMinSec] = re:split(String, " "),
  {
    list_to_tuple([ binary_to_integer(X) || X  <- re:split(YMD, "/") ]), % Y/M/D
    list_to_tuple([ binary_to_integer(X) || X  <- re:split(HMinSec, ":")]) % H:Min:Sec
  }.