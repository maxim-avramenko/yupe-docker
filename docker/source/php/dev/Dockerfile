FROM php:7.0-fpm

ARG USER
ARG TIME_ZONE=Europe/Moscow

ENV TZ=${TIME_ZONE}
ENV USER=${USER}

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN set -ex \
    && yes | adduser --disabled-password --uid 1000 ${USER}

#RUN usermod -aG sudo www-data

COPY ./config/php.ini /usr/local/etc/php/
COPY ./config/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

RUN apt-get update && apt-get install -y --no-install-recommends \
        apt-utils \
        autoconf \
        curl \
        g++ \
        gcc \
        git \
        libc-dev \
        libicu-dev \
        libxml2-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libzip-dev \
        libmemcached11 \
        libmemcachedutil2 \
        libmemcached-dev \
        libz-dev \
        make \
        memcached \
        pkg-config \
        tzdata \
        unzip \
        wget \
        zlib1g-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-configure intl \
    && docker-php-ext-install -j$(nproc) \
        gd \
        iconv \
        mcrypt \
        fileinfo \
        json \
        mbstring \
        mysqli \
        opcache \
        pdo \
        pdo_mysql \
        zip \
        intl \
        dom \
        session \
        xml \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

RUN yes | pecl install xdebug \
    && docker-php-ext-enable xdebug

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && chown ${USER}:${USER} /usr/local/bin/composer

RUN mkdir /var/www/.composer \
    && chown -R ${USER}:${USER} /var/www \
    && chmod 755 -R /var/www

USER ${USER}

WORKDIR /var/www

CMD ["php-fpm"]


#bcmath bz2 calendar ctype curl dba dom enchant exif fileinfo filter ftp gd gettext gmp hash iconv imap interbase intl json ldap mbstring mcrypt mysqli oci8 odbc opcache pcntl pdo pdo_dblib pdo_firebird pdo_mysql pdo_oci pdo_odbc pdo_pgsql pdo_sqlite pgsql phar posix pspell readline recode reflection session shmop simplexml snmp soap sockets spl standard sysvmsg sysvsem sysvshm tidy tokenizer wddx xml xmlreader xmlrpc xmlwriter xsl zip
