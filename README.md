# hydreigon

Send notes that will self-destruct after being read.


Что можно:
 - писать сообщения

Технологии:
 - Ruby & Hanami
 - Sequel, Postgres & Redis
 - Bootstrap

Уязвимости:
 - Инекция в заголовках запроса (`user-agent` и т.д.) выхлоп можно посмотреть тут `/66d9b558f41b30033e4d62bf47d52885e31627e4/payloads`
 - Опечатка в коде (`client_pasword` -> `client_password`), из-за которой для шифрования используется стандартный пароль, всегда
 - Отказ в обслуживании: на каждый запрос делается подключение к БД, а затем `insert`, коннект же, не закрывается


## ISIB

Создать базу, накатить миграции, иначе не стартанет

```sh
$ docker-compose run web hanami db create
$ docker-compose run web hanami db migrate
```

Запуск, в папке с проектом
```sh
$ docker-compose up
```

## Setup

How to run tests:

```
% bundle exec rake
```

How to run the development console:

```
% bundle exec hanami console
```

How to run the development server:

```
% bundle exec hanami server
```

How to prepare (create and migrate) DB for `development` and `test` environments:

```
% bundle exec hanami db prepare

% HANAMI_ENV=test bundle exec hanami db prepare
```

Explore Hanami [guides](https://guides.hanamirb.org/), [API docs](http://docs.hanamirb.org/1.3.2/), or jump in [chat](http://chat.hanamirb.org) for help. Enjoy!

docker
```
HANAMI_ENV=production bundle exec hanami db create
HANAMI_ENV=production bundle exec hanami db migrate
```
