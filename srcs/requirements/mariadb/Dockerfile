# ベースイメージを指定
FROM debian:bullseye

# 必要なパッケージをインストール
RUN apt-get update && apt-get install -y mariadb-server

# mysqld用ディレクトリを作成し、権限をmysqlに
RUN mkdir -p /run/mysqld && chown mysql:mysql /run/mysqld

# 設定ファイルをコピー
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/


COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

