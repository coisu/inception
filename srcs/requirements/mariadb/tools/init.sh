#!/bin/sh

# Wait for MySQL/MariaDB service to start
echo "Waiting for MariaDB service to start..."
until mysqladmin ping -h localhost >/dev/null 2>&1; do
    sleep 1
done
echo "MariaDB service started"

# Create database and users
echo "Creating database and users..."
mysql -h localhost -u root -p"${MYSQL_ROOT_PASSWORD}" <<EOF
CREATE DATABASE IF NOT EXISTS ${DB_NAME};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL ON ${DB_NAME}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

echo "Initialization complete"