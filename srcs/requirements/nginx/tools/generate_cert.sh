#!/bin/bash


set -e

mkdir -p /etc/nginx/ssl

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $CERTS_KEY -out $CERTS_CERT -subj "/C=MO/L=KH/O=1337/CN=jischoi.1337.ma"


echo "
server {
    listen 443 ssl;
    listen [::]:443 ssl;

    #server_name www.$DOMAIN_NAME $DOMAIN_NAME;

    ssl_certificate $CERTS_CERT;
    ssl_certificate_key $CERTS_KEY;" > /etc/nginx/sites-available/default


echo '
    ssl_protocols TLSv1.3;

    index index.php;
    root /var/www/html;

    location ~ [^/]\.php(/|$) { 
            try_files $uri =404;
            fastcgi_pass wordpress:9000;
            include fastcgi_params;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        }
} ' >>  /etc/nginx/sites-available/default


nginx -g "daemon off;"