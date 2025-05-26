# ベースイメージを指定
FROM debian:bullseye
RUN apt-get update -y

# 必要なパッケージをインストール
RUN apt install -y php7.4 php7.4-fpm php7.4-cli php7.4-json php7.4-common php7.4-mysql php7.4-zip php7.4-gd php7.4-mbstring php7.4-curl php7.4-xml php7.4-bcmath
RUN apt install -y mariadb-client curl wget unzip

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

# /var/www/html を作成
RUN mkdir -p /var/www/html

# php-fpm用のディレクトリを作成
RUN mkdir -p /run/php


RUN service php7.4-fpm start && service php7.4-fpm stop


# WordPressをインストール
RUN wget https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz && \
    rm latest.tar.gz && \
    mv wordpress/* /var/www/html/ && \
    chown -R www-data:www-data /var/www/html/ && \
    chmod -R 755 /var/www/html/

COPY www.conf /etc/php/7.4/fpm/pool.d/www.conf
RUN mkdir -p /run/php && \
    touch /run/php/php7.4-fpm.sock && \
    chown -R www-data:www-data /run/php && \
    mkdir -p /var/log/php-fpm/ && \
    chown -R www-data:www-data /var/log/php-fpm/




COPY entrypoint.sh /docker-entrypoint-initdb.d/entrypoint.sh




# ENTRYPOINT ["/docker-entrypoint-initdb.d/entrypoint.sh"]

# PHP-FPMを起動
CMD [ "sleep", "infinity"]
