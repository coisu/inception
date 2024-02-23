#!/bin/bash

# SMTP setting update
wp-cli.phar option update smtp_host "$WORDPRESS_DB_HOST"
wp-cli.phar option update smtp_port "587"
wp-cli.phar option update smtp_user "$WORDPRESS_ADMIN_EMAIL"
wp-cli.phar option update smtp_pass "$WORDPRESS_ADMIN_PASSWORD"
wp-cli.phar option update smtp_encryption "tls"
