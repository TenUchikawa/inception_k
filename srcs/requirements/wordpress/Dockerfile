# ベースイメージを指定
FROM debian:bullseye

# 必要なパッケージをインストール
RUN apt-get update && apt-get install -y php php-fpm php-mysql wget

# /var/www/html を作成
RUN mkdir -p /var/www/html

# php-fpm用のディレクトリを作成
RUN mkdir -p /run/php

# WordPressをインストール
RUN wget https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz && \
    rm latest.tar.gz && \
    mv wordpress /var/www/html/ && \
    chown -R www-data:www-data /var/www/html/ && \
    chmod -R 755 /var/www/html/

# PHP-FPMを起動
CMD ["php-fpm7.4", "-F"]
