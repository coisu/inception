FROM alpine:3.18

RUN apk update && \
    apk upgrade && \
    apk add -y --no-cache mariadb mariadb-client dumb-init openrc && openrc && \
    rm -rf /var/cache/apk/*

COPY ./conf/mariadb.cnf /etc/my.cnf
COPY ./tools/init.sh /init.sh

RUN chmod +x /init.sh

EXPOSE 3306

ENTRYPOINT ["/usr/bin/dumb-init"]
CMD ["/init.sh"]
