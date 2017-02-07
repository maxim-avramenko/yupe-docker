#!/usr/bin/env bash
#==================================================================================
# имя файла скрипта на всякий случай
SCRIPT="$0"
# описание работы скрипнта --help
showHelp() {
    echo "Supported commands:"
    echo "===================================================================================================="
    echo "set-env           - set application environment [dev | prod | test]"
    echo "check-env         - print message with current application environment name"
    echo "check-config      - check current environment configuration .yml file"
    echo "up                - start application environment"
    echo "ps                - list of working containers in current environment"
    echo "down              - stop application environment"
    echo "restart           - restart application environment"
    echo "build             - build docker containers for application"
    echo "build-nocache     - force build docker containers for application without docker cached images"
    echo "create            - create Yupe! application in ./app directory with --no-install key, just create"
    echo "install           - composer install --prefer-dist, + --no-dev key on prod environment"
    echo "update            - composer update  --prefer-dist, + --no-dev key on prod environment"
    echo "db-backup         - s3cli backup database to Amazon S3"
    echo "db-restore        - s3cli restore database form Amazon S3"
    echo "===================================================================================================="
    echo "Для определения в каком окружении должно работать приложение выполните: './app.sh set-env [ dev | prod | test ]'"
    echo "===================================================================================================="

}
CONTAINER_NAME=
COMPOSER_PACKAGE_NAME="yupe/yupe"
COMPOSER_PACKAGE_BRANCH="1.1"
APP_DIR=./app
COMPOSER_CREATE_APP_PATH=
COMPOSER_APP_PATH=
COMPOSER_DEV=
# Текущее окружение
CURRENT_ENV=
#printf 123456 | md5sum | awk '{print $1}'
#echo $APP_$(printf 123456 | md5sum | awk '{print $1}')

# Определяем где запущен скрипт [Linux | Windows | MacOS]
PLATFORM='unknown'
UNAMESTR=`uname`
if [[ "$UNAMESTR" == 'Linux' ]]; then
   PLATFORM='linux'
elif [[ "$UNAMESTR" == 'MINGW64_NT-10.0' ]]; then
    PLATFORM='windows'
elif [[ "$UNAMESTR" == 'Darwin' ]]; then
   PLATFORM='mac'
fi

case "$PLATFORM" in
windows)
    COMPOSER_CREATE_APP_PATH="/$PWD"
    COMPOSER_APP_PATH="/$PWD/app"
    ;;
*)
    echo ""
    COMPOSER_CREATE_APP_PATH="$PWD"
    COMPOSER_APP_PATH="$PWD/app"
    ;;
esac

# Задаем Новое окружение [ dev | prod | test ]
NEW_ENV=
if [ ! -z $2 ]; then
    NEW_ENV="$2"
fi

# имя функции для запуска
FUNCTION=
if [ ! -z $1 ]; then
    FUNCTION="$1"
fi

# переопределяем окржение заданное по умолчанию если передали второй скрипт
#if [ ! -z $2 ]; then
#    APP_ENV="$2"
#fi
# проверка наличия приложения в папке app
check-dir(){
    if [ ! -d "$APP_DIR" ]; then
        # Control will enter here if $DIRECTORY doesn't exist.
        echo "Please, install your application to ./app folder."
        echo "To create app run command: ./app.sh create"
        echo "To install/update app dependency run command: ./app.sh [ install | update ]"
        exit 1
    fi
}
# проверка наличие файла со значением переменной окружения
check-env(){
    if [ ! -f ./docker/env/app_env ]; then
        echo "missing ./docker/env/app_env file, please create application environment file, use command './app.sh set-env [ dev | prod | test ]'"
        exit 1
    else
        environment
    fi
}
# отображаем на экране в каком окружении работает приложение
environment(){
    CURRENT_ENV=`cat ./docker/env/app_env`
    echo "Current application environment: $CURRENT_ENV"
    case "$CURRENT_ENV" in
    prod)
        COMPOSER_DEV=" --no-dev"
        ;;
    esac
}
# изменяем окружение в котором будет работать приложение
set-env(){
    echo "Updating application environment..."
    case "$NEW_ENV" in
    dev|prod|test)
        if [ -f ./docker/env/app_env ]; then
            CURRENT_ENV=`cat ./docker/env/app_env`
            docker-compose -f common.yml -f $CURRENT_ENV.yml down
        fi
        echo "Setting up new application environment to: $NEW_ENV"
        cp ./docker/env/$NEW_ENV/app_env ./docker/env/app_env
        echo "Success"
        check-env
        ;;
    *) #если введено с клавиатуры то, что в case не описывается, выполнять следующее:
        echo "Ошибка: Вторым параметром команды укажите в каком окружении необходимо запускать приложение dev, prod или test"
        exit 1;
    esac
}

build-nocache(){
    check-dir
    echo "Building docker images for $CURRENT_ENV environment without cache."
    docker-compose -f common.yml -f $CURRENT_ENV.yml build --no-cache
}

build(){
    check-dir
    echo "Building docker images for $CURRENT_ENV environment with cache."
    docker-compose -f common.yml -f $CURRENT_ENV.yml build
}
ps(){
    echo "Container status in $CURRENT_ENV environment:"
    docker-compose -f common.yml -f $CURRENT_ENV.yml ps
}

up(){
    check-dir
    echo "Start Yupe! in $CURRENT_ENV environment"
    docker-compose -f common.yml -f $CURRENT_ENV.yml up -d
    ps
    echo 'Please, see logs above to find out environment container status.'
}
down(){
    check-dir
    echo "Stop Yupe! in $CURRENT_ENV environment"
    docker-compose -f common.yml -f $CURRENT_ENV.yml down
    ps
    echo 'Please, see logs above to find out environment container status.'
}
restart(){
    check-dir
    echo "Restart Yupe! in $CURRENT_ENV environment"
    docker-compose -f common.yml -f $CURRENT_ENV.yml down
    docker-compose -f common.yml -f $CURRENT_ENV.yml up -d
    ps
    echo 'Please, see logs above to find out environment container status.'
}

check-config(){
    echo "Config status in $CURRENT_ENV environment:"
    docker-compose -f common.yml -f $CURRENT_ENV.yml config
}



create(){
    if [ ! -d "$APP_DIR" ]; then
        chmod a+rw ./docker/source/php/dev/app/ -R
        chmod a+rw ./docker/source/php/prod/app/ -R
        chmod a+rw ./docker/source/php/test/app/ -R
        echo "Running: docker run --rm --interactive --tty --volume "$COMPOSER_CREATE_APP_PATH/app:/app:rw" composer create-project yupe/yupe:1.1 yupe --no-install"
        docker run --rm --interactive --tty --volume "$COMPOSER_CREATE_APP_PATH/app:/app:rw" --name "yupe-composer" composer create-project yupe/yupe:1.1 yupe --no-install --no-interaction
        chmod a+rw ./app/yupe/public/assets ./app/yupe/public/uploads ./app/yupe/protected/runtime
        chmod a+rw ./app/yupe/protected/config/modules ./app/yupe/protected/config/modulesBack
        install
        cp ./app/yupe/protected/config/ ./docker/source/php/dev/app/protected/ -R
        cp ./app/yupe/protected/config/ ./docker/source/php/prod/app/protected/ -R
        cp ./app/yupe/protected/config/ ./docker/source/php/test/app/protected/ -R
        rm ./docker/source/php/dev/app/protected/config/.gitignore
        rm ./docker/source/php/prod/app/protected/config/.gitignore
        rm ./docker/source/php/test/app/protected/config/.gitignore
        rm ./docker/source/php/dev/app/protected/config/modules/.gitignore
        rm ./docker/source/php/prod/app/protected/config/modules/.gitignore
        rm ./docker/source/php/test/app/protected/config/modules/.gitignore

    else
        echo "Error: Can not create application $COMPOSER_PACKAGE_NAME:$COMPOSER_PACKAGE_BRANCH in app dirrectory, it's already in app directory, app dirrectory is not empty. Please, remove app directory to create new app."
    fi
}

install(){
    if [ -d "$APP_DIR" ]; then
        echo "Running: composer install"
        docker run --rm --interactive --tty --volume "$COMPOSER_APP_PATH/yupe:/app:rw" --name "yupe-composer" composer install --no-interaction --prefer-dist"$COMPOSER_DEV"
    else
        create
    fi
}

update(){
    if [ -d "$APP_DIR" ]; then
        echo "Running: composer update"
        docker run --rm --interactive --tty --volume "$COMPOSER_APP_PATH/yupe:/app:rw" --name "yupe-composer"  composer update --no-interaction --prefer-dist --no-dev
    else
        echo "Error: can't update, no app folder. Please, create app, run: ./app.sh create"
    fi
}
db-backup(){
    echo "Staring backup DB to Amazon S3 cloud"
    docker run --rm --env-file ./docker/env/s3.env --env-file ./docker/env/db-backup.env --volumes-from yupedocker_db_1 --name dockup tutum/dockup:latest
}
db-restore(){
    echo "Staring backup DB to Amazon S3 cloud"
    docker run --rm --env-file ./docker/env/s3.env --env-file ./docker/env/db-restore.env --volumes-from yupedocker_db_1 --name dockup tutum/dockup:latest
}
self-destroy(){
    echo "Yupe self destroy program activated. Good By all Files and Data! Hello New World!"
    check-env
    down
    rm ./app -rf
    rm ./docker/source/php/dev/app/protected/config -rf
    rm ./docker/source/php/prod/app/protected/config -rf
    rm ./docker/source/php/test/app/protected/config -rf
    rm ./docker/env/app_env -f
    rm ./docker/env/dev/XDEBUG_CONFIG.env -f
    rm ./docker/env/test/XDEBUG_CONFIG.env -f
    echo "There is no Yupe in this project."
}
init-xdebug(){
    if [ ! -f ./docker/env/dev/XDEBUG_CONFIG.env ]; then
        touch ./docker/env/dev/XDEBUG_CONFIG.env
        case "$PLATFORM" in
        windows)

            echo "XDEBUG_CONFIG=remote_host=10.0.75.1" >> ./docker/env/dev/XDEBUG_CONFIG.env
            ;;
        *)
            echo "XDEBUG_CONFIG=remote_host=172.17.0.1" >> ./docker/env/dev/XDEBUG_CONFIG.env
            ;;
        esac
    fi

    if [ ! -f ./docker/env/test/XDEBUG_CONFIG.env ]; then
        touch ./docker/env/test/XDEBUG_CONFIG.env
        case "$PLATFORM" in
        windows)

            echo "XDEBUG_CONFIG=remote_host=10.0.75.1" >> ./docker/env/test/XDEBUG_CONFIG.env
            ;;
        *)
            echo "XDEBUG_CONFIG=remote_host=172.17.0.1" >> ./docker/env/test/XDEBUG_CONFIG.env
            ;;
        esac
    fi


}
#echo "/$PWD"
#exit 0
case "$1" in
-h|--help)
    showHelp
    ;;
check-env|environment)
    check-env
    ;;
set-env)
    set-env
    ;;
self-destroy)
    self-destroy
    ;;
*)
    if [ ! -z $(type -t $FUNCTION | grep function) ]; then
        init-xdebug
        check-env
        $1
    else
        showHelp
    fi
esac
