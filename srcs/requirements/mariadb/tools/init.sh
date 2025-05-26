#!/bin/bash
set -e

cat <<EOF > /docker-entrypoint-initdb.d/init.sql
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

mysqld_safe &

until mysqladmin ping -h localhost --silent; do
  sleep 2
done

mysql -u root -p"${MYSQL_ROOT_PASSWORD}" < /docker-entrypoint-initdb.d/init.sql

wait