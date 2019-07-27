% заголовочный файл настроек приложения

-author("sergeyb").

-record(cache, {key, value, life, added}).

-define(Cleaner, cleaner). % макрос модуля процесса очистки

-define(SERVER, cache_server). % макрос модуля кеш-сервера

-define(TName, table). % имя оперируемой таблицы

-define(ClearInterval, 15). % интервал актуализации данных