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
                  [start] [stop] [restart] [ps]

    description:
        set-env           - set application environment [ dev | prod ]
        check-env         - print message with current application environment name
        check-config      - check current environment docker-compose configuration files
        build             - build docker containers for application
        build-nocache     - force build docker containers for application without docker cached images
        create            - create Yupe!1.1 application in ./app directory with --no-install key, just create
        install           - docker exec -it yupedocker_php_1 composer install
        update            - composer update  --lock
        start             - start application environment
        stop              - stop application environment
        restart           - restart application environment
        ps                - list of working containers in current environment


    Для определения в каком окружении должно работать приложение выполните: ./yupe set-env [ dev | prod ]

    See ./yupe --help to read about all commands.
    
Для Быстрого старта выполните в консоле:
    
    ./init.dev.sh
    
Скрипт создает dev окружение, скачивает и запускает Yupe! на [http://localhost:7771](http://localhost:7771)

Содержимое команды ./init.dev.sh

    #!/usr/bin/env bash
    ./yupe set-env dev
    ./yupe create
    ./yupe start

После выполнения команды ./init.dev.sh будет вот такая картинка

![yupe install screen text https://docs.yupe.ru/img/yupe-install-1.png](https://docs.yupe.ru/img/yupe-install-1.png)


Помощь
------

Документация:
- [Docker](https://docs.docker.com/)
- [docker-compose](https://docs.docker.com/compose/overview/)
- [Git](https://git-scm.com/downloads)
- [Yupe](https://docs.yupe.ru/)
 
