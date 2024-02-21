FROM alpine:3.18

RUN apk update && \
	apk upgrade && \
	apk add --no-cache nginx dumb-init openssl && \
	rm -rf /var/cache/apk/*

RUN	mkdir -p /etc/nginx/certs

COPY ./tools/certs/	/etc/nginx/certs/

COPY ./conf/server.conf /etc/nginx/http.d/default.conf

ENTRYPOINT ["/usr/bin/dumb-init"]

CMD ["/bin/sh", "-c", "nginx -g 'daemon off;'"]
# CMD ["/bin/sh", "-c", "/generate_cert.sh && nginx -g 'daemon off;'"]
# nginx -g 'daemon off;' : start the Nginx web server in the foreground
# and prevents it from running as a daemon process in the background,
# meaning that it starts up and runs continuously without user intervention.
