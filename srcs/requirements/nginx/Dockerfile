FROM alpine:3.18

RUN apk update && \
	apk upgrade && \
	apk add --no-cache nginx dumb-init openssl && \
	# mkdir /etc/nginx/tls && \
	# openssl req -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=FR/ST=France/L=Paris/O=42Paris/OU=Bess/CN=jischoi.42.fr" -out /etc/nginx/tls/jischoi.42.fr.crt -keyout /etc/nginx/tls/jischoi.42.fr.key && \
	# rm -rf /var/cache/apk/*

COPY ./conf/server.conf /etc/nginx/http.d/default.conf
COPY ./tools/generate_cert.sh /usr/local/bin/generate_cert.sh

RUN chmod +x /usr/local/bin/generate_cert.sh

ENTRYPOINT ["/usr/bin/dumb-init"]

CMD sh -c "/usr/local/bin/generate_cert.sh && nginx -g 'daemon off;'"
# nginx -g 'daemon off;' : start the Nginx web server in the foreground
# and prevents it from running as a daemon process in the background,
# meaning that it starts up and runs continuously without user intervention.