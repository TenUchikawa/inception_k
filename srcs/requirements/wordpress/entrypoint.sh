
#!/bin/bash


set -e
if [ ! -f /var/www/html/wp-config.php ]; then
  until mysqladmin ping -h "$WORDPRESS_DB_HOST" --silent; do sleep 1; done
  wp core download --path=/var/www/html --allow-root
  wp config create --dbname="$WORDPRESS_DB_NAME" --dbuser="$WORDPRESS_DB_USER" --dbpass="$WORDPRESS_DB_PASS" --dbhost="$WORDPRESS_DB_HOST" --path=/var/www/html --allow-root
  wp core install --url="https://kahori.42.fr" --title="$WORDPRESS_SITE_TITLE" --admin_user="$WORDPRESS_ADMIN_USER" --admin_password="$WORDPRESS_ADMIN_PASS" --admin_email="$WORDPRESS_ADMIN_EMAIL" --skip-email --path=/var/www/html --allow-root
  wp user create "$WORDPRESS_EDITOR_USER" "$WORDPRESS_EDITOR_EMAIL" --user_pass="$WORDPRESS_EDITOR_PASS" --role=editor --path=/var/www/html --allow-root
fi

exec php-fpm7.4 -F


# sleep infinity