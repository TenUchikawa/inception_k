# ベースイメージを指定
FROM debian:bullseye

# 必要なパッケージをインストール
RUN apt-get update && apt-get install -y mariadb-client curl wget unzip php7.4 php7.4-fpm php7.4-cli php7.4-json php7.4-common php7.4-mysql php7.4-zip php7.4-gd php7.4-mbstring php7.4-curl php7.4-xml php7.4-bcmath

# /var/www/html を作成
RUN mkdir -p /var/www/html
RUN chown -R www-data:www-data /var/www/html

# php-fpm用のディレクトリを作成
RUN mkdir -p /run/php

# WordPressをインストール
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp


RUN mkdir /var/log/php-fpm/ && \
    chown -R www-data:www-data /var/log/php-fpm/

RUN service php7.4-fpm start && service php7.4-fpm stop

COPY www.conf /etc/php/7.4/fpm/pool.d/www.conf

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT /entrypoint.sh