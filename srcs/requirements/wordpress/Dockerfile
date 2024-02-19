FROM alpine:3.16

RUN apk update && \
	apk add --no-cache dumb-init curl mariadb-client php-fpm php-mysqli php8-phar php-mbstring ssmtp && \
	rm -rf /var/cache/apk/*

COPY ./tools/entrypoint.sh .
COPY ./conf/www.conf /etc/php8/php-fpm.d/

RUN chmod +x ./entrypoint.sh

EXPOSE 9000

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

CMD ["./entrypoint.sh"]

# mariadb-client: to use MariaDB as database, for interacting with the database server.
# php-fpm: (FastCGI Process Manager) to serve PHP scripts. WordPress is built with PHP
# php-mysqli: for WordPress, needed to interact with the MariaDB database.
# php8-phar: for managing phar files
# php-mbstring: for handling multibyte strings, often required by WordPress
# ssmtp: a simple SMTP client used to send emails from a command line.
# 		depending on whether application needs to send emails