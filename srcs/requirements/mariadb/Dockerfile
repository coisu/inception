FROM alpine:3.18

RUN apk update && \
    apk upgrade && \
    apk add -y --no-cache mariadb mariadb-client dumb-init && \
    rm -rf /var/cache/apk/*

COPY ./conf/mariadb.cnf /etc/my.cnf.d
COPY ./tools/entrypoint.sh .

RUN chmod +x ./entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["/usr/bin/dumb-init"]

CMD ["./entrypoint.sh"]
