# Yupe! CMF in Docker containers #
----------------------------------
Репозиторий предназначен для быстрого старта Yupe! CMF в Docker контейнерах.

Добавьте в /etc/hosts для dev окружения. Для prod добавьте ваше доменное имя.
    
    sudo nano /etc/hosts
    
    127.0.0.1   yupe.loc

Быстрый старт Yupe! CMF в dev окружении:

    git clone https://github.com/maxim-avramenko/yupe-docker.git && \
    cd yupe-docker && \
    chmod +x yupe && \
    ./yupe set-env dev && \
    ./yupe init

Для заупска bash скрипта управления Yupe приложением в Docker контейнерах необходимо дать файлу "yupe" права на исполнение:

        chmod +x yupe

Для остановки окружения:

    ./yupe stop
    
Для старта приложения:
    
    ./yupe start

Для работы с репозиторием необходимы:
- [Docker](https://docs.docker.com/engine/installation/)
- [docker-compose](https://docs.docker.com/compose/install/)
- [Git](https://git-scm.com/downloads) (см. установку на windows ниже)


Репозиторий представляет из себя набор конфигурационных файлов docker-compose для запуска Yupe! в различных окружениях:
 - dev
 - prod

### Возможности ./yupe: ###

    usage:
    
    Init application with one command:
        ./yupe set-env dev && ./yupe init && ./yupe start
    
    description:
    Environment commands:
        set-env           - set application environment [ dev | prod ]
        check-env         - print message with current application environment name
        check-config      - check current environment docker-compose configuration files
        build             - build docker containers for application
        build-nocache     - force build docker containers for application without docker cached images
    
    Yupe 1.3:
        create            - create Yupe!1.1 application in ./app directory with --no-install key, just create
        start             - start application environment
        stop              - stop application environment
        ps                - list of working containers in current environment
        restart           - restart application environment
        update            - composer update  --lock
        migrate           - php yii migrate --interactive=0
    
    Fixing application chown and chmod:
        fix-chown         - change owner to current user (only on Linux and Mac OS) Windows dont need this
        fix-chmod         - change a+rw assets, upload, runtime, config e.t.c.
        fix               - fix-chown and fix-chmod
    
    
    Для определения в каком окружении должно работать приложение выполните: ./yupe set-env [ dev | prod ]



Для определения в каком окружении должно работать приложение выполните: ./yupe set-env [ dev | prod ]

See ./yupe --help to read about all commands.
    
Для Быстрого старта выполните в консоле:
    
    ./yupe set-env dev && ./yupe init && ./yupe start
    
Скрипт создает dev окружение, скачивает, устанавливает и запускает Yupe!
1.3 для dev [http://localhost:7771](http://localhost:7771), для prod
[http://localhost:7781](http://localhost:7781) или
[http://yupe.loc](http://yupe.loc)


После выполнения команды ./yupe set-env dev && ./yupe init будет вот такая картинка

![yupe install screen text https://docs.yupe.ru/img/yupe-install-1.png](https://docs.yupe.ru/img/yupe-install-1.png)


Помощь
------
Установка [Git](https://git-scm.com/downloads) на Windows требует определенной настройки что бы работал ./yupe bash скрипт в Windows среде:

- отмечаем все галочки на первом шаге установки компонентов (Select components)
- Use Git from Windows Command prompt
- Use OpenSSH
- Use the OpenSSL library
- Checkout as-is, commit Unix-style endings (ВАЖНО! Без этого Windows стянет bash скрипт и изменит перенос строк файлов проекта, при сборке контейнеров выдаст ошибку о том что файлы имеют Windows перенос строк)
- Настройка доменов происходит в файлах dev.yml и prod.yml, так же возможно изменить порты по которым будет отвечать проект
- Установить adminer.php можно с помощью команды ./yupe install-adminer (будет доступен по ссылке http://yupe.loc/adminer.php)


Настройка подключения к БД (указываем при установке приложения)
---
- host: db
- db_user: yupe
- db_pass: 123
- db_name: db_yupe
- root_password: 123

xDebug
------
Для использования xDebug необходимо настроить PhpStorm:

![yupe xdebug screen text https://raw.githubusercontent.com/maxim-avramenko/yupe-docker/master/docker/img/server.png](https://raw.githubusercontent.com/maxim-avramenko/yupe-docker/master/docker/img/server.png)

Документация:
------------
- [Docker](https://docs.docker.com/)
- [docker-compose](https://docs.docker.com/compose/overview/)
- [Git](https://git-scm.com/downloads)
- [Yupe](https://docs.yupe.ru/)
 
