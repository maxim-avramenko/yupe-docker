# Yupe! CMF in Docker containers #
----------------------------------
Данный репозиторий предназначен для быстрого старта Yupe! CMF в Docker контейнерах.

Для работы с данным репозиторием необходимы:
- Docker
- docker-compose
- Git


### Возможности: ###

1) Создание экземпляра проекта Yupe!
2) Установка Yupe! для различных окружений (production/development/test)
3) Запуск экземпляра приложения Yupe! в различных окружениях (production/development/test)

Все функции разделены и могут выполняться отдельно друг от друга.

Описание
--------
Репозиторий включает в себя набор файлов различных конфигрураций для docker-compose.
Дирректория "env" содержит в себе файлы с переменными окружения (dev/prod/test).
Дирректория "source" содержит в себе файлы для инициализации конкретного окружения (dev/prod/test). 

Создание экземпляра приложения Yupe!
------------------------------------
Для создания экземпляра приложения Yupe! в корне данного репозитория необходимо:
1) либо скопировать уже имеющийся проект Yupe в дирректорию app в корне данного репозитория
2) либо выполнить следующие команды в консоле для установки с packagist.org:
    
    
    user@host:# cd ~/
    user@host:# git clone git@github.com:maxim-avramenko/yupe-docker.git
    user@host:# cd yupe-docker
    user@host:~/yupe-docker# docker-compose -f docker-compose.create-project.yml up -d
     
В результате выполнения данных команд будет создан экземпляр приложения yupe/yupe:1.0 в корневой дирректории проекта в папке "./app"
#### !Внимание: ####
Зависимости из composer.json установлены не будут! Установка зависимостей выделена в отдельную команду для возможности сборки проекта в различных окружениях (dev/prod/test).

Установка зависимостей приложения Yupe! (composer.json)
--------------------------------------
Для установки зависимостей приложения, с помощью "composer install", реализованы следующие команды:
1) Установка зависимостей для "development" окружения
 
    
    user@host:~/yupe-docker# docker-compose -f docker-compose.install.yml up -d
    
2) Установка зависимостей для "production" окружения:

    
    user@host:~/yupe-docker# docker-compose -f docker-compose.install.prod.yml up -d
    
3) Установка зависимостей для "test" окружения:

    
    user@host:~/yupe-docker# docker-compose -f docker-compose.install.test.yml up -d
    

Список окружений
----------------------------------------------
На данный момент в репозитории присутствуют файлы конфигураций для трех основных окружений:
- development [dev]
- production [prod]
- test [test]

Подобное разделение окружения требует создание трех различных конфигураций Yupe! приложения для (prod/dev/test). 

Для запуска экземпляра приложения Yupe! в определенном окружении необходимо скопировать и хранить содрежимое protected/config в трех разных дирректориях, отдельно для каждого из окружений. Это позволит полностью отделить конфигурацию от приложения и забыть про main-local.php и подобную чуш в общей папке protected/config  

Запуск приложения в [development] окружении
-------------------------------------------
Для запуска приложения в [development] окружении необходимо сначала скопировать ./app/protected/config в ./source/php/dev/app/protected/config и выполнить команду в консоле:

        user@host:~/yupe-docker# docker-compose up -d
        
Docker соберет и запустит [development] окружение, приложение будет доступно в браузере по адресам:
 - [http://localhost:7771](http://localhost:7771) - Yupe!
 - [http://localhost:7772](http://localhost:7772) - adminer
 
Запуск приложения в [production] окружении
------------------------------------------
Для запуска приложения в [production] окружении необходимо сначала скопировать ./app/protected/config в ./source/php/prod/app/protected/config и выполнить команду в консоле:

        user@host:~/yupe-docker# docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
        
Docker соберет и запустит [production] окружение, приложение будет доступно в браузере по адресам:
 - [http://localhost:7781](http://localhost:7781) - Yupe!
 - [http://localhost:7782](http://localhost:7782) - adminer
 
Запуск приложения в [test] окружении
------------------------------------------
Для запуска приложения в [test] окружении необходимо сначала скопировать ./app/protected/config в ./source/php/test/app/protected/config и выполнить команду в консоле:

        user@host:~/yupe-docker# docker-compose -f docker-compose.yml -f docker-compose.test.yml up -d
        
Docker соберет и запустит [test] окружение, приложение будет доступно в браузере по адресам:
 - [http://localhost:7791](http://localhost:7791) - Yupe!
 - [http://localhost:7792](http://localhost:7792) - adminer
 
 
Базы Данных
-----------
На данный момент во всех окружениях используется последняя версия MariaDB и одинаковые настройки для любого из имеющихся окружений

Настройки БД находятся в файле db.env в соответствующей папке окружения в дирректории "./env"

Такое разделение позволяет запускать приложение Yupe! с различными конфигурациями БД в различных окружениях.

Для того что бы запустить приложение используя имеющийся дамп базы необходимо положить его в дирректорию [./service/mariadb/db_dump/db_yupe]. В момент создания контейнера Docker самостоятельно сделает restore из дампа в базу указанную в файле настроек БД [./env/(dev|prod|test)/db.env] например. 

Все доступы к БД указаны в файлах настроек БД [./env/(dev|prod|test)/db.env]. Пример содержания файла:

        MYSQL_ROOT_PASSWORD=123
        MYSQL_USER=yupe
        MYSQL_DATABASE=db_yupe
        MYSQL_PASSWORD=123

Для того что бы база данных создавалась из дампа каждый раз при запуске определенного окружения необходимо:
1) Остановить окружение командой в консольке:
        
        user@host:~/yupe-docker# docker-compose down
        
2) удаляем контейнер если он был создан ранее

        user@host:~/yupe-docker# docker volume rm yupedocker_db_data
  
3) Запускаем dev окружение, дамп БД из дирректории [./source/mariadb/db_dum_db_yupe] будет загружен в БД yupe и доступен для бэкапа в виде docker volume под именем yupedocker_db_data
   
        user@host:~/yupe-docker# docker-compose up -d

4) Для доступа к БД из adminer необходимо указывать host не "localhost" а "db", так же как и при установке Yupe в шаге 4. Так как БД для приложения доступна в Docker по имени сервиса Docker - "db", а не 'localhost'.

5) Помните что при загрузке дампа во время старта контенеров доступ к БД у приложения появится только после того как указанный дамп будет загружен в БД, все зависит от его размера 

Как использовать XDEBUG?
-----------------------
XDEBUG не доступен в production окружении, xdebug устанавливается в момент билда образов Docker в файле [./source/php/dev/Dockerfile]

Для того что бы подэбажить приложение в PhpStorm необходимо:
1) в файле ./env/dev/php.env указать локальный ip вашей хост машины, узнать его можно выполнив команду ipconfig или ifconfig на вашей хост машине где установлен phpstorm
Поумолчанию Docker назначает адреса:
- в windows [ 10.0.75.1 ]
- в Linux [ 172.17.0.1 ]
2) В PhpStorm в настройках PHP (File->Settings->Languages&Framework->PHP->servers) создать сервер например yupe.dev и указать его адрес [localhost] и порт [7771], установить галку "Use path mapping" и указать пути до дирректорий проекта на сервере
3) В PhpStorm в настройках PHP Debug (File->Settings->Languages&Framework->PHP->Debug->DBGp proxy) указать ваш локальный IP (10.0.75.1[win] или 172.17.0.1[linux]) и порт 9000.


Пример использования данного репозитория
----------------------------------------
Для примера создадим экземпляр приложения Yupe! и запустим его в development окружении для дэбага.


    user@host:# cd ~/
    user@host:# git clone git@github.com:maxim-avramenko/yupe-docker.git
    user@host:# cd yupe-docker
    user@host:~/yupe-docker# docker-compose -f docker-compose.create-project.yml up -d
    
После выполнения последней команды необходимо убедиться что экземпляр приложения создан в дирректории [./app]

    user@host:~/yupe-docker# ls -l app/
    
Результат должен выглядеть примерно так:

    -rwxr-xr-x 1 pebo 197121    873 ноя 29 13:51 build.sh*
    -rw-r--r-- 1 pebo 197121  86836 ноя 29 13:51 CHANGELOG.md
    -rw-r--r-- 1 pebo 197121    428 ноя 29 13:51 codeception.dist.yml
    -rw-r--r-- 1 pebo 197121   4158 ноя 29 13:51 composer.json
    -rw-r--r-- 1 pebo 197121 121936 ноя 29 13:51 composer.lock
    -rw-r--r-- 1 pebo 197121    999 ноя 29 13:51 install.md
    -rw-r--r-- 1 pebo 197121   1629 ноя 29 13:51 LICENSE
    drwxr-xr-x 1 pebo 197121      0 ноя 29 13:51 protected/
    drwxr-xr-x 1 pebo 197121      0 ноя 29 13:51 public/
    drwxr-xr-x 1 pebo 197121      0 ноя 29 13:51 read.me/
    -rw-r--r-- 1 pebo 197121   7045 ноя 29 13:51 README.md
    -rw-r--r-- 1 pebo 197121   5683 ноя 29 13:51 README_EN.md
    -rw-r--r-- 1 pebo 197121    564 ноя 29 13:51 TEAM.md
    drwxr-xr-x 1 pebo 197121      0 ноя 29 13:51 tests/
    drwxr-xr-x 1 pebo 197121      0 ноя 29 13:51 themes/
    -rw-r--r-- 1 pebo 197121    880 ноя 29 13:51 UPGRADE.md
    drwxr-xr-x 1 pebo 197121      0 дек  6 13:54 vendor/

Экземпляр приложения создан. Теперь Отделяем конфигурацию приложения от приложения путем копирования дирректории ./app/protected/config в ./source/php/dev/app/protected/config (эта дирректория будет смонтирована в дирректорию проекта при запуске dev окружения)

    user@host:~/yupe-docker# cp ./app/protected/config ./source/php/dev/app/protected -R
    

Не забудьте обновить файлы .gitignore в скопированных папках config, оставьте только те файлы которые необходимы для конфигурации приложения в dev окружении.

Теперь все готово к запуску development окружения, выполняем команду в консоли:

    user@host:~/yupe-docker# docker-compose up -d
    
Docker начнет сборку development окружение и проект будет доступен в браузере по адресу [http://localhost:7771](http://localhost:7771)

Для запуска приложения в production окружении скопируйте конфигурацию приложения ./app/protected/config в папку ./source/php/prod/app/protected и только потом запускайте сборку окружения:
 
    user@host:~/yupe-docker# cp ./app/protected/config ./source/php/prod/app/protected -R
    user@host:~/yupe-docker# docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
    
Docker соберет production окружение и проект будет доступен в браузере по адресу [http://localhost:7781](http://localhost:7781)



Остановка и перезапуск окружения
--------------------------------

Для остановки приложения необходимо выполнить команду:

    user@host:~/yupe-docker# docker-compose down
    
Помощь
------
Документация
- [Docker](https://docs.docker.com/)
- [docker-compose](https://docs.docker.com/compose/overview/)
- [Yupe](https://docs.yupe.ru/)
 