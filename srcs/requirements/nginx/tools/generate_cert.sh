#!/bin/bash

set -e

mkdir -p $CERTS_DIR

openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout $CERTS_KEY -out $CERTS_CERT -subj "/C=FR/ST=France/L=Paris/O=42Paris/OU=Bess/CN=jischoi.42.fr"


echo "
server {
    listen 443 ssl;
    listen [::]:443 ssl;

    ssl_certificate $CERTS_CERT;
    ssl_certificate_key $CERTS_KEY;

    ssl_protocols TLSv1.3;

    index index.php;
    root /var/www/html;

    location ~ [^/]\.php(/|$) { 
            try_files $uri =404;
            fastcgi_pass wordpress:9000;
            include fastcgi_params;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        }
} " >  /etc/nginx/http.d/default.conf
