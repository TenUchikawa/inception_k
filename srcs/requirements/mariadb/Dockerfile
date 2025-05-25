# ベースイメージを指定
FROM debian:bullseye

# 必要なパッケージをインストール
RUN apt-get update && apt-get install -y mariadb-server

# 設定ファイルをコピー
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/

# データベースの初期化スクリプトをコピー
COPY ./tools/init.sql /docker-entrypoint-initdb.d/

# ポート3306でMariaDBを起動
EXPOSE 3306

# MariaDBを起動
CMD ["mysqld"]
