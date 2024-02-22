#!/bin/sh

# Wait for MariaDB to start
wait_for_mariadb() {
    echo "Waiting for MariaDB to start..."
    until mysqladmin ping -h mariadb --silent; do
        echo "sleep"
        sleep 2
    done
    echo "MariaDB is up and running."
}

# WordPress installation and configuration
install_wordpress() {
    if [ ! -e /var/www/html/wp-config.php ]; then
        # Create WordPress directory and set permissions
        mkdir -p /var/www/html
        adduser -D wordpress
        chown -R wordpress:wordpress /var/www/html

        # download Wordpress
        curl -O https://wordpress.org/latest.tar.gz
        tar -xvzf latest.tar.gz
        mv wordpress/* /var/www/html/
        rmdir wordpress
        rm latest.tar.gz

        # Install wp-cli
        curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
        chmod +x wp-cli.phar
        mv wp-cli.phar /usr/local/bin/wp

        # Download and configure WordPress
        wp core download --locale=en_GB --path='/var/www/html'
        wp config create --allow-root --dbname="$DB_NAME" --dbuser="$MYSQL_USER" --dbpass="$MYSQL_PASSWORD" --dbhost=$WORDPRESS_DB_HOST:3306 --path='/var/www/html'

        # Install WordPress
        wp core install --allow-root --url="$WORDPRESS_URL" --title="$WORDPRESS_TITLE" --admin_user="$WORDPRESS_ADMIN_USER" --admin_password="$WORDPRESS_ADMIN_PASSWORD" --admin_email="$WORDPRESS_ADMIN_EMAIL" --path='/var/www/html'

        # Create WordPress user
        wp user create --allow-root "$WORDPRESS_USER" "$WORDPRESS_EMAIL" --user_pass="$WORDPRESS_PASSWORD" --role=author --path='/var/www/html'
    fi
}

start_php_fpm() {
    echo "Starting FPM"
    php-fpm8 -F
}

main() {
    wait_for_mariadb
    echo "MariaDB is up and running."
    install_wordpress
    start_php_fpm
}

main











# #!/bin/sh

# if [ ! -e /var/www/html/wp-config.php ]; then

# 	# wordpress install
# 	sleep 3
# 	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
# 	chmod +x wp-cli.phar
# 	mv wp-cli.phar /usr/local/bin/wp
# 	mkdir -p /var/www/html
# 	adduser -D wordpress
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