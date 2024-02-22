#!/bin/sh
echo "Starting entrypoint.sh script..."

# Check if the database directory exists
if [ ! -d /var/lib/mysql/$DB_NAME ]; then
    mariadb-install-db --datadir=/var/lib/mysql --user=mysql
    # Create directory for pidfile of running process
    mkdir -p /run/openrc && touch /run/openrc/softlevel
    mkdir -p /run/mysqld
    chown -R mysql:mysql /run/mysqld /var/lib/mysql
    # Start MariaDB in safe mode in the background
    # /usr/bin/mysqld_safe --datadir='/var/lib/mysql' --user=mysql &
    # sleep 1
	# echo "Waiting for MariaDB service to start..."
    # until mysqladmin ping -h localhost >/dev/null 2>&1; do
    #     sleep 1
    # done
    rc-service mariadb start

    echo "Initializing database..."

#     # Initialize the database and create users

#     mysql -h localhost -u root -p "$MYSQL_ROOT_PASSWORD" <<EOF
# ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
# DROP DATABASE IF EXISTS test;
# DROP USER ''@'localhost';
# DROP USER ''@'$(hostname)';
# CREATE DATABASE IF NOT EXISTS '$DB_NAME';
# CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
# GRANT ALL ON '$DB_NAME'.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
# FLUSH PRIVILEGES;
# EOF
# instead of GRANT ALL PRIVILEGES ON '$DB_NAME'.* TO '$MYSQL_USER'@'%';


    # mysql -h localhost -u root -p "$MYSQL_ROOT_PASSWORD" <<EOF
mysql -u root -e "CREATE DATABASE IF NOT EXISTS $DB_NAME CHARACTER SET utf8;"
mysql -u root -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"
mysql -u root -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$MYSQL_USER'@'%';"
mysql -u root -e "FLUSH PRIVILEGES;"
mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';"
mysql -u root -e "DELETE FROM mysql.user WHERE User='';"
mysql -u root -e "DROP DATABASE IF EXISTS test;"
mysql -u root -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
mysql -u root -e "FLUSH PRIVILEGES;"
# EOF

    # Shutdown MariaDB
    rc-service mariadb stop
    # mysqladmin -uroot --password=$MYSQL_ROOT_PASSWORD shutdown
fi

echo "Starting MariaDB..."

# Start MariaDB
exec /usr/bin/mysqld_safe --datadir='/var/lib/mysql'


