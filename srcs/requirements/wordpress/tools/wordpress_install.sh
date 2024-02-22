#!/bin/sh

set -e

if ! [[ -f /var/www/html/wp ]]; then
# Download and install wp-cli
curl -o /var/www/html/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x /var/www/html/wp

fi

if ! [[ -f /usr/local/bin/wp ]]; then

chmod +x /var/www/html/wp
cp /var/www/html/wp /usr/local/bin/wp

fi

if ! [[ -f /var/www/html/wp-config.php ]]; then

# download the latest version of WordPress core website files, or a specific version if you specify the version number.
wp core download --locale=en_US --allow-root

# Create the wp-config.php file ||||  --skip-email
wp config create --dbname=$MYSQL_DATABASE --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --dbhost=$WORDPRESS_DB_HOST --allow-root

# Install WordPress Core files
# command is used in WordPress to install the core WordPress files and create the necessary database tables.
wp core install --url=$WORDPRESS_URL --title="$WORDPRESS_TITLE" --admin_user=$WORDPRESS_ADMIN_USER --admin_password=$WORDPRESS_ADMIN_PASSWORD --admin_email=$WORDPRESS_ADMIN_EMAIL  --skip-email

chmod -R 777 /var/www/
chown -R nobody:nogroup /var/www/html

wp user create $WORDPRESS_USER $WORDPRESS_EMAIL --user_pass=$WORDPRESS_PASSWORD --role=author 

# Install the Redis Object Cache plugin for WordPress
wp plugin install redis-cache --activate 

wp plugin update redis-cache 

# redis-cli monitor, real-time output of Redis serving cached queries
wp redis enable 

fi

#set the ownership of /var/www/html to nobody:nobody to allow the Nginx worker processes to read and write to the files.
# for ftp server to be able to download and upload  (read and download) to the wordpress dir
# nobody user has less privilegies

chmod -R 777 /var/www/
chown -R nobody:nogroup /var/www/html

#run in foreground, -F, to run in background php-fpm8
echo "Starting FPM"
php-fpm8 -F