#!/bin/sh


if [ ! -d "/run/mysqld" ]; then
	echo "[DB config] Granting MariaDB daemon run permissions..."
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi

# if [ -d "/var/lib/mysql/mysql" ]
# then
# 	echo "[DB config] MariaDB already configured."
# else
# 	echo "[DB config] Installing MySQL Data Directory..."
# 	chown -R mysql:mysql /var/lib/mysql
# 	mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql --rpm > /dev/null
# 	echo "[DB config] MySQL Data Directory done."

# 	echo "[DB config] Configuring MySQL..."
# 	TMP=/tmp/.tmpfile

# Check if the database directory exists
if [ ! -d /var/lib/mysql/$DB_NAME ]; then
    mariadb-install-db --datadir=/var/lib/mysql --user=mysql
    # Create directory for pidfile of running process
    mkdir -p /run/openrc && touch /run/openrc/softlevel
    chown -R mysql:mysql /run/mysqld /var/lib/mysql
    chmod -R 777 /var/lib/mysql /run/mysqld
    # Start MariaDB in safe mode in the background
    # /usr/bin/mysqld_safe --datadir='/var/lib/mysql' --user=mysql &
    # sleep 1
	# echo "Waiting for MariaDB service to start..."
    # until mysqladmin ping -h localhost >/dev/null 2>&1; do
    #     sleep 1
    # done
    rc-service mariadb start

    echo "Initializing database..."

    # Initialize the database and create users

    mysqladmin -u root password "$MYSQL_ROOT_PASSWORD"

    mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS $DB_NAME CHARACTER SET utf8;"
    mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"
    mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"
    mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"
    mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
    mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "DELETE FROM mysql.user WHERE User='';"
    mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "DROP DATABASE IF EXISTS test;"
    mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
    mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"


    # echo "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');" >> ${TMP}
    # echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';" >> ${TMP}

    # Shutdown MariaDB
    rc-service mariadb stop
    # mysqladmin -uroot --password=$MYSQL_ROOT_PASSWORD shutdown
fi

echo "Starting MariaDB..."

# Start MariaDB
exec /usr/bin/mysqld_safe --datadir='/var/lib/mysql'



# echo "Starting entrypoint.sh script..."

# if [ ! -d "/run/mysqld" ]; then
# 	echo "[DB config] Granting MariaDB daemon run permissions..."
# 	mkdir -p /run/mysqld
# 	chown -R mysql:mysql /run/mysqld
# fi

# if [ -d "/var/lib/mysql/mysql" ]
# then
# 	echo "[DB config] MariaDB already configured."
# else
# 	echo "[DB config] Installing MySQL Data Directory..."
# 	chown -R mysql:mysql /var/lib/mysql
# 	mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql --rpm > /dev/null
# 	echo "[DB config] MySQL Data Directory done."

# 	echo "[DB config] Configuring MySQL..."
# 	TMP=/tmp/.tmpfile

# 	echo "USE mysql;" > ${TMP}
#     echo "FLUSH PRIVILEGES;" >> ${TMP}
#     echo "DELETE FROM mysql.user WHERE User='';" >> ${TMP}
#     echo "DROP DATABASE IF EXISTS test;" >> ${TMP}
#     echo "DELETE FROM mysql.db WHERE Db='test';" >> ${TMP}
#     echo "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');" >> ${TMP}
#     echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';" >> ${TMP}
#     echo "CREATE DATABASE ${DB_NAME};" >> ${TMP}
#     echo "CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';" >> ${TMP}
#     echo "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';" >> ${TMP}
#     echo "FLUSH PRIVILEGES;" >> ${TMP}

# 	# Alpine does not come with service or rc-service,
# 	# so we cannot use: service mysql start
# 	# We might be able to install with: apk add openrc
# 	# But we can also manually start and configure the mysql daemon:
# 	/usr/bin/mysqld --user=mysql --bootstrap < ${TMP}
# 	rm -f ${TMP}
# 	echo "[DB config] MySQL configuration done."
# fi

# # echo "[DB config] Allowing remote connections to MariaDB"
# # sed -i "s|skip-networking|# skip-networking|g" /etc/my.cnf.d/mariadb-server.cnf
# # sed -i "s|.*bind-address\s*=.*|bind-address=0.0.0.0|g" /etc/my.cnf.d/mariadb-server.cnf

# echo "[DB config] Starting MariaDB daemon on port 3306."
# exec /usr/bin/mysqld --user=mysql --console









