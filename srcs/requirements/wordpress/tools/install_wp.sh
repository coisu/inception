#!/bin/sh

echo "[WP config] Configuring WordPress..."

echo "[WP config] Waiting for MariaDB..."
sleep 20
until mysql --host=$WORDPRESS_DB_HOST --user=$MYSQL_USER --password=$MYSQL_PASSWORD -e --silent'\c'; do
    echo "mariadb is unavailable - sleeping"
    sleep 1
done
echo "mariadb is up - start next wordpress bootstrap"

WP=/var/www/html/wordpress

if [ -f ${WP}/wp-config.php ]
then
	echo "[WP config] WordPress already configured."
else
	echo "[WP config] Setting up WordPress..."
	# echo "[WP config] Updating WP-CLI..."
	# wp-cli.phar cli update --yes --allow-root
	# echo "[WP config] Downloading WordPress..."
	# wp-cli.phar core download 
	# echo "[WP config] Creating wp-config.php..."
	# wp-cli.phar config create --dbname=${DB_NAME} --dbuser=${MYSQL_USER} --dbpass=${MYSQL_PASSWORD} --dbhost=${WORDPRESS_DB_HOST}
	
    wp core download
    wp config create --dbname=$WORDPRESS_DB_HOST --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --dbhost=$WORDPRESS_DB_HOST --dbcharset="utf8" --dbcollate="utf8_general_ci" --allow-root
    echo "[i] wordpress installing..."
    wp core install --url=$WORDPRESS_URL/wordpress --title=$WORDPRESS_TITLE --admin_user=$WORDPRESS_ADMIN_USER --admin_password=$WORDPRESS_ADMIN_PASSWORD --admin_email=$WORDPRESS_ADMIN_EMAIL --allow-root --skip-email
    wp user create $WORDPRESS_USER $WORDPRESS_EMAIL --role=author --user_pass=$WORDPRESS_PASSWORD --porcelain --allow-root
    wp theme install generatepress --activate
    wp widget add meta sidebar-1 1

    # echo "[WP config] Updating SMTP setting..."
    # wp-cli.phar option update smtp_host "$WORDPRESS_DB_HOST"
    # wp-cli.phar option update smtp_port "587"
    # wp-cli.phar option update smtp_user "$WORDPRESS_ADMIN_EMAIL"
    # wp-cli.phar option update smtp_pass "$WORDPRESS_ADMIN_PASSWORD"
    # wp-cli.phar option update smtp_encryption "tls"
    
    # echo "[WP config] Installing WordPress core..."
	# wp-cli.phar core install --url=${WORDPRESS_URL} --title=${WORDPRESS_TITLE} --admin_user=${WORDPRESS_ADMIN_USER} --admin_password=${WORDPRESS_ADMIN_PASSWORD} --admin_email=${WORDPRESS_ADMIN_EMAIL} --skip-email
	# echo "[WP config] Creating WordPress default user..."
	# wp-cli.phar user create $WORDPRESS_USER ${WORDPRESS_EMAIL} --user_pass=${WORDPRESS_PASSWORD} --role=author --display_name=${WORDPRESS_USER} --porcelain --path=$WP
	# echo "[WP config] Installing WordPress theme..."
	# wp-cli.phar theme install bravada --activate 
	# wp-cli.phar theme status bravada 
fi

echo "[WP config] Starting WordPress fastCGI on port 9000."
exec /usr/sbin/php-fpm8 -F -R


# #!/bin/sh

# # Wait for MariaDB to start
# wait_for_mariadb() {
#     echo "Waiting for MariaDB to start..."
#     until mysqladmin ping -h"$WORDPRESS_DB_HOST" --silent; do
#         sleep 2
#     done
#     echo "MariaDB is up and running."
# }

# # WordPress configuration
# generate_config() {
#     echo "Creating wp configuration..."
#     su -s /bin/sh -c "wp config create --dbname=${DB_NAME} --dbuser=${MYSQL_USER} --dbpass=${MYSQL_PASSWORD} --dbhost=${WORDPRESS_DB_HOST}:3306 --path=${WP}" nobody
# }

# install_wordpress () {
#     echo "Installing Wordpress..."
#     chmod -R 777 /var/www/html
#     su -s /bin/sh -c "wp core download --locale=en_US --allow-root" nobody
    
#     if [ ! -e /var/www/html/wp-config.php ]; then
#         generate_config
#     fi

#     su -s /bin/sh -c "wp core install --url=$WORDPRESS_URL --title=$WORDPRESS_TITLE --admin_user=$WORDPRESS_ADMIN_USER --admin_password=$WORDPRESS_ADMIN_PASSWORD --admin_email=$WORDPRESS_ADMIN_EMAIL --path=$WP" nobody
    
#     chmod -R 777 /var/www/html
#     chown -R nobody:nogroup /var/www/html

#     # # download Wordpress
#     # curl -O https://wordpress.org/latest.tar.gz
#     # tar -xzf latest.tar.gz
#     # mv wordpress/* $WP
#     # rm -rf wordpress latest.tar.gz
#     echo "Creating second user"
#     su -s /bin/sh -c "wp user create ${WORDPRESS_USER} ${WORDPRESS_EMAIL} --user_pass=${WORDPRESS_PASSWORD} --role=author --path=${WP}" nobody

# }



# # Install wp-cli.phar
# install_wp_cli() {
#     echo "Installing wp-cli.phar..."
#     curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
#     chmod +x wp-cli.phar
#     mv wp-cli.phar /usr/local/bin/wp
# }

# main() {

#     if [ ! -f /usr/local/bin/wp ]; then
#         install_wp_cli
#     fi
#     if [ ! -d $WP/wp-content ]; then
#         install_wordpress
#     fi
#     chmod -R 777 /var/www/
#     chown -R nobody:nogroup /var/www/html
#     wait_for_mariadb
#     echo "MariaDB is up and running."
#     echo "Starting FPM"
#     php-fpm8 -F
# }

# main



# install_wordpress() {
#     if ! [[ -f /var/www/html/wp ]]; then
#         # Download and install wp-cli
#         curl -o /var/www/html/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
#         chmod +x /var/www/html/wp
#     fi

#     if ! [[ -f /usr/local/bin/wp ]]; then
#         chmod +x /var/www/html/wp
#         cp /var/www/html/wp /usr/local/bin/wp
#     fi

#     if ! [[ -f /var/www/html/wp-config.php ]]; then
#         # download the latest version of WordPress core website files
#         wp core download --locale=en_US --allow-root

#         # Create the wp-config.php file
#         wp config create --dbname=$DB_NAME --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --dbhost=$WORDPRESS_DB_HOST --allow-root

#         # REDIS CASHE CONFIG FOR WORDPRESS
#         wp config set WP_CACHE $WP_CACHE
#         wp config set WP_REDIS_HOST $WP_REDIS_HOST
#         wp config set WP_REDIS_PORT $WP_REDIS_PORT

#         # Install WordPress Core files
#         wp core install --url=$WORDPRESS_URL --title="$WORDPRESS_TITLE" --admin_user=$WORDPRESS_ADMIN_USER --admin_password=$WORDPRESS_ADMIN_PASSWORD --admin_email=$WORDPRESS_ADMIN_EMAIL  --skip-email

#         chmod -R 777 /var/www/
#         chown -R nobody:nogroup /var/www/html

#         wp user create $WORDPRESS_USER $WORDPRESS_EMAIL --user_pass=$WORDPRESS_PASSWORD --role=author 

#         # Install the Redis Object Cache plugin for WordPress
#         wp plugin install redis-cache --activate 
#         wp plugin update redis-cache 
#         wp redis enable 
#     fi
# }

# start_php_fpm() {
#     # Set the ownership of /var/www/html to nobody:nogroup
#     chmod -R 777 /var/www/
#     chown -R nobody:nogroup /var/www/html

#     # Run php-fpm8 in foreground
#     php-fpm8 --nodaemonize
# }

# main() {
#     set -x
#     cd ${WP}
#     wait_for_mariadb
#     echo "MariaDB is up and running."
#     install_wordpress
#     start_php_fpm
# }

# main











# #!/bin/sh

# if [ ! -e /var/www/html/wp-config.php ]; then

# 	# wordpress install
# 	sleep 3
# 	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
# 	chmod +x wp-cli.phar
# 	mv wp-cli.phar /usr/local/bin/wp
# 	mkdir -p /var/www/html
# 	chown -R wordpress:wordpress /var/www/html

# 	wp core download --locale=en_GB --path='/var/www/html'
# 	until wp config create --allow-root --dbname=$DB_NAME --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --dbhost=mariadb:3306 --path='/var/www/html' ; do
# 		echo "Waiting for MariaDB to start..."
# 		sleep 2
# 		done
# 	wp core install --allow-root --url=$DOMAIN_NAME --title='WordPress for Inception' --admin_user=$WORDPRESS_ADMIN_USER\
# 	--admin_password=$WORDPRESS_ADMIN_PASSWORD --admin_email=$WORDPRESS_ADMIN_EMAIL --path='/var/www/html'
# 	wp user create --allow-root $WORDPRESS_USER $WORDPRESS_EMAIL --user_pass=$WORDPRESS_PASSWORD --role=author --path='/var/www/html'
# fi

# php-fpm8 -F