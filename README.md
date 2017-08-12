# Yupe! CMF in Docker containers #
----------------------------------
Репозиторий предназначен для быстрого старта Yupe! CMF в Docker контейнерах.

Для работы с репозиторием необходимы:
- [Docker](https://docs.docker.com/engine/installation/)
- [docker-compose](https://docs.docker.com/compose/install/)
- [Git](https://git-scm.com/downloads)


Репозиторий представляет из себя набор конфигурационных файлов docker-compose для запуска Yupe! в различных окружениях:
 - dev
 - prod
 - test

### Возможности ./app.sh: ###

    Supported commands:
    ====================================================================================================
    set-env           - set application environment [dev | prod | test]
    check-env         - print message with current application environment name
    check-config      - check current environment configuration .yml file
    up                - start application environment
    ps                - list of working containers in current environment
    down              - stop application environment
    restart           - restart application environment
    build             - build docker containers for application
    build-nocache     - force build docker containers for application without docker cached images
    create            - create Yupe! application in ./app directory with --no-install key, just create
    install           - composer install --prefer-dist, + --no-dev key on prod environment
    update            - composer update  --prefer-dist, + --no-dev key on prod environment
    db-backup         - s3cli backup database to Amazon S3
    db-restore        - s3cli restore database form Amazon S3
    ====================================================================================================
    Для определения в каком окружении должно работать приложение выполните: './app.sh set-env [ dev | prod | test ]'
    ====================================================================================================
    
Для Быстрого старта выполните в консоле:
    
    ./init.dev.sh
    
Скрипт создает dev окружение, скачивает и запускает Yupe! на [http://localhost:7771](http://localhost:7771)

Содержимое команды ./init.dev.sh

    #!/usr/bin/env bash
    ./app.sh set-env dev
    ./app.sh create
    ./app.sh up

После выполнения данной команды будет вот такая картинка
![yupe install screen text https://docs.yupe.ru/img/yupe-install-1.png](https://docs.yupe.ru/img/yupe-install-1.png)

Помощь
------
Документация
- [Docker](https://docs.docker.com/)
- [docker-compose](https://docs.docker.com/compose/overview/)
- [Git](https://git-scm.com/downloads)
- [Yupe](https://docs.yupe.ru/)
 
