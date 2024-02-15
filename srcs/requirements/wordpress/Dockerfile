FROM alpine:3.18

RUN apk update && \
	apk add dumb-init curl mariadb-client php-fpm php-mysqli php8-phar php-mbstring ssmtp && \
	rm -rf /var/cache/apk/*

COPY ./tools/entrypoint.sh .
COPY ./conf/www.conf /etc/php8/php-fpm.d/

RUN chmod +x ./entrypoint.sh

EXPOSE 9000

ENTRYPOINT ["/usr/bin/dumb-init"]

CMD ["./entrypoint.sh"]