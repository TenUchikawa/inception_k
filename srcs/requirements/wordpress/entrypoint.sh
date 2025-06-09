#!/bin/bash
set -e

###-------------------------------------------------
### WordPress 初期設定チェック
###-------------------------------------------------

if [ ! -f /var/www/html/wp-config.php ]; then
  echo "[INFO] MariaDB の準備を待機中..."
  until mysqladmin ping -h "${WORDPRESS_DB_HOST}" --silent; do
    sleep 1
  done

  echo "[INFO] wp-config.php が存在しません。初期セットアップを開始します。"
  cd /var/www/html

  ###-------------------------------------------------
  ### WordPress ダウンロード
  ###-------------------------------------------------
  echo "[INFO] WordPress をダウンロードします..."
  wp core download \
    --path=/var/www/html \
    --locale=ja \
    --allow-root

  ###-------------------------------------------------
  ### wp-config.php 作成
  ###-------------------------------------------------
  echo "[INFO] WordPress の設定を作成します..."
  wp config create \
    --dbname="${MYSQL_DATABASE}" \
    --dbuser="${MYSQL_USER}" \
    --dbpass="${MYSQL_PASSWORD}" \
    --dbhost="${WORDPRESS_DB_HOST}" \
    --dbcharset="utf8mb4" \
    --dbcollate="utf8mb4_unicode_ci" \
    --path="/var/www/html" \
    --allow-root

  ###-------------------------------------------------
  ### WordPress インストール
  ###-------------------------------------------------
  wp core install \
    --url="https://kahori.42.fr" \
    --title="${WORDPRESS_SITE_TITLE}" \
    --admin_user="${WORDPRESS_ADMIN_USER}" \
    --admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
    --admin_email="${WORDPRESS_ADMIN_EMAIL}" \
    --skip-email \
    --allow-root

  ###-------------------------------------------------
  ### サイト基本設定
  ###-------------------------------------------------
  wp option update blogdescription "${WORDPRESS_SITE_DESCRIPTION}" --allow-root
  wp option update timezone_string "Asia/Tokyo" --allow-root

  ###-------------------------------------------------
  ### エディター権限ユーザー作成
  ###-------------------------------------------------
  wp user create \
    "${WORDPRESS_EDITOR_USER}" \
    "${WORDPRESS_EDITOR_EMAIL}" \
    --user_pass="${WORDPRESS_EDITOR_PASSWORD}" \
    --role=editor \
    --allow-root

  echo "[INFO] WordPress の初期設定が完了しました。"
fi

###-------------------------------------------------
### PHP-FPM 起動
###-------------------------------------------------
exec php-fpm7.4 -F
