FROM alpine:3.18

RUN apk update && \
	apk upgrade && \
	apk add nginx dumb-init openssl && \
	mkdir /etc/nginx/tls && \
	openssl req -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=FR/ST=France/L=Paris/O=42Paris/OU=Bess/CN=jischoi.42.fr" -out /etc/nginx/tls/jischoi.42.fr.crt -keyout /etc/nginx/tls/jischoi.42.fr.key && \
	rm -rf /var/cache/apk/*

COPY ./conf/server.conf /etc/nginx/http.d/default.conf

ENTRYPOINT ["/usr/bin/dumb-init"]

CMD ["nginx", "-g", "daemon off;"]