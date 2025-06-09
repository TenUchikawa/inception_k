#!/bin/bash
set -e

###-------------------------------------------------
### 1. init.sql を動的に生成（環境変数を展開）
###-------------------------------------------------
cat <<EOF > /init.sql
-- 🔧 データベース初期化開始
SELECT 'Initializing database...' AS message;

-- 🔐 rootパスワード再設定
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

-- 📦 データベース作成
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE}
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

-- 👤 ユーザー作成 & 権限付与
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;

-- ✅ データベース初期化完了
SELECT 'Database initialized.' AS message;
EOF

echo "[INFO] init.sql が生成されました。"

###-------------------------------------------------
### 2. MariaDB の起動
###-------------------------------------------------
echo "[INFO] MariaDB を起動します..."
mysqld_safe &

###-------------------------------------------------
### 3. 起動待機ループ（MariaDBが応答するまで）
###-------------------------------------------------
echo "[INFO] MariaDB の起動を待っています..."
until mysqladmin ping -h localhost --silent; do
  echo " - MariaDB is not ready yet..."
  sleep 2
done

###-------------------------------------------------
### 4. init.sql を実行
###-------------------------------------------------
echo "[INFO] 初期化スクリプトを実行中..."
mysql -u root -p"${MYSQL_ROOT_PASSWORD}" < /init.sql

###-------------------------------------------------
### 5. フォアグラウンドで MariaDB を維持
###-------------------------------------------------
echo "[INFO] 初期化完了。MariaDB をフォアグラウンドで実行中..."
wait