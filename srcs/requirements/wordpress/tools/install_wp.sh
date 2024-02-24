#!/bin/sh

echo "[WP config] Configuring WordPress..."

echo "[WP config] Waiting for MariaDB..."
sleep 15
until mysql --host=$WORDPRESS_DB_HOST --user=$MYSQL_USER --password=$MYSQL_PASSWORD -e --silent'\c'; do
    echo "mariadb is unavailable - sleeping"
    sleep 1
done
echo "mariadb is up - start next wordpress bootstrap"

# WP=/var/www/html/wordpress

if [ -f ${WP}/wp-config.php ]
then
	echo "[WP config] WordPress already configured."
else
	echo "[WP config] Setting up WordPress..."

	echo "* Downloading wordpress..."
    wp core download
    echo "* Creating wp Config..."
    wp config create --dbname=$WORDPRESS_DB_HOST --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --dbhost=$WORDPRESS_DB_HOST --dbcharset="utf8" --dbcollate="utf8_general_ci" --allow-root
    echo "* Installing wordpress with admin user..."
    wp core install --url=$WORDPRESS_URL --title=$WORDPRESS_TITLE --admin_user=$WORDPRESS_ADMIN_USER --admin_password=$WORDPRESS_ADMIN_PASSWORD --admin_email=$WORDPRESS_ADMIN_EMAIL --allow-root --skip-email
    echo "* Creating wordpress author user..."
    wp user create $WORDPRESS_USER $WORDPRESS_EMAIL --role=author --user_pass=$WORDPRESS_PASSWORD --porcelain --allow-root
    # echo "* Applying theme..."
    # wp theme install generatepress --activate
fi

echo "[WP config] Starting WordPress on port 9000."
exec /usr/sbin/php-fpm8 -F