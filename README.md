# erlangHomework_lesson_7

Cache-сервер + cowboy, Баснин Сергей

Запуск: make run

Запросы из терминала для тестирования:

curl -H "Content-Type: application/json" -X POST -d '{"action":"insert","key":"some_key", "value":[1,2,3], "life":300}' http://localhost:8080/api/cache_server

curl -H "Content-Type: application/json" -X POST -d '{"action":"insert","key":"some_key", "value":[4,5,6], "life":30}' http://localhost:8080/api/cache_server

curl -H "Content-Type: application/json" -X POST -d '{"action":"lookup","key":"some_key"}' http://localhost:8080/api/cache_server

curl -H "Content-Type: application/json" -X POST -d '{"action":"lookup_by_date","date_from":"2019/7/27 00:00:00", "date_to":"2019/8/10 23:59:59"}' http://localhost:8080/api/cache_server
