FROM alpine:3.16

RUN apk update && \
	apk update && apk add --no-cache dumb-init mariadb-client php8 php8-fpm php8-mysqli php8-phar php8-mbstring php8-opcache php8-openssl mysql-client php8-iconv php8-mbstring php8-session php8-tokenizer php8-common php8-ctype curl tar nano &&\
	rm -rf /var/cache/apk/*

COPY ./conf/www.conf /etc/php8/php-fpm.d/
COPY ./tools/install_wp.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/install_wp.sh

EXPOSE 9000

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

WORKDIR /var/www/html/

CMD sh -c 'install_wp.sh'
# mariadb-client: to use MariaDB as database, for interacting with the database server.
# php-fpm: (FastCGI Process Manager) to serve PHP scripts. WordPress is built with PHP
# php-mysqli: for WordPress, needed to interact with the MariaDB database.
# php8-phar: for managing phar files
# php-mbstring: for handling multibyte strings, often required by WordPress
# ssmtp: a simple SMTP client used to send emails from a command line.
# 		depending on whether application needs to send emails


# FROM alpine:3.16

# RUN apk update && apk add --no-cache dumb-init php8 php8-fpm php8-mysqli php8-opcache php8-phar mysql-client php8-iconv php8-mbstring php8-session php8-tokenizer php8-common php8-ctype curl tar nano

# #/run/php directory to allow PHP-FPM to create its socket file

# RUN sed -i 's#listen = 127.0.0.1:9000#listen = 0.0.0.0:9000#' /etc/php8/php-fpm.d/www.conf \
# 	&& sed -i 's/^listen.allowed_clients = 127.0.0.1$/listen.allowed_clients = any/' /etc/php8/php-fpm.d/www.conf
# 	# && sed -i 's#listen = 127.0.0.1:9000#listen = /var/run/php-fpm.sock#' /etc/php8/php-fpm.d/www.conf \
# 	# && sed -i 's#;listen.owner = nobody#listen.owner = nobody#' /etc/php8/php-fpm.d/www.conf \
# 	# && sed -i 's#;listen.group = nogroup#listen.group = nogroup#' /etc/php8/php-fpm.d/www.conf \
# 	# && sed -i 's#;listen.mode = 0660#listen.mode = 0660#' /etc/php8/php-fpm.d/www.conf \

# COPY ./tools/wordpress_install.sh .

# RUN chmod +x ./wordpress_install.sh
# ENTRYPOINT ["/usr/bin/dumb-init", "--"]

# CMD ["./wordpress_install.sh"]
