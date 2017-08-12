# Yupe! CMF in Docker containers #
----------------------------------
Репозиторий предназначен для быстрого старта Yupe! CMF в Docker контейнерах.

Для заупска bash скрипта управления Yupe приложением в Docker контейнерах необходимо дать файлу "yupe" права на исполнение:

        chmod +x yupe


Для работы с репозиторием необходимы:
- [Docker](https://docs.docker.com/engine/installation/)
- [docker-compose](https://docs.docker.com/compose/install/)
- [Git](https://git-scm.com/downloads)


Репозиторий представляет из себя набор конфигурационных файлов docker-compose для запуска Yupe! в различных окружениях:
 - dev
 - prod
 - test

### Возможности ./yupe: ###

    $ ./yupe
    usage: ./yupe [set-env] [check-env] [check-config]
                  [build] [build-nocache] [create] [install] [update]
                  [start] [stop] [ps] [restart] [db-backup] [db-restore]

    description:
          set-env           - set application environment [dev | prod | test]
          check-env         - print message with current application environment name
          check-config      - check current environment configuration .yml file
          build             - build docker containers for application
          build-nocache     - force build docker containers for application without docker cached images
          create            - create Yupe! application in ./app directory with --no-install key, just create
          install           - composer install --prefer-dist, + --no-dev key on prod environment
          update            - composer update  --prefer-dist, + --no-dev key on prod environment
          start             - start application environment
          stop              - stop application environment
          restart           - restart application environment
          ps                - list of working containers in current environment
          db-backup         - s3cli backup database to Amazon S3
          db-restore        - s3cli restore database form Amazon S3


    Для определения в каком окружении должно работать приложение выполните: './yupe set-env [ dev | prod | test ]'

    See ./yupe --help to read about all commands.
    
Для Быстрого старта выполните в консоле:
    
    ./init.dev.sh
    
Скрипт создает dev окружение, скачивает и запускает Yupe! на [http://localhost:7771](http://localhost:7771)

Содержимое команды ./init.dev.sh

    #!/usr/bin/env bash
    ./yupe set-env dev
    ./yupe create
    ./yupe up

После выполнения команды ./init.dev.sh будет вот такая картинка

![yupe install screen text https://docs.yupe.ru/img/yupe-install-1.png](https://docs.yupe.ru/img/yupe-install-1.png)


Помощь
------

Документация:
- [Docker](https://docs.docker.com/)
- [docker-compose](https://docs.docker.com/compose/overview/)
- [Git](https://git-scm.com/downloads)
- [Yupe](https://docs.yupe.ru/)
 
