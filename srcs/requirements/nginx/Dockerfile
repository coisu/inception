FROM alpine:3.18

RUN apk update && \
	apk upgrade && \
	apk add --no-cache nginx dumb-init openssl curl && \
	rm -rf /var/cache/apk/*

RUN		mkdir -p /etc/nginx/certs
RUN		mkdir -p /var/www/html

COPY ./tools/certs/	/etc/nginx/certs/
# COPY ./conf/nginx.conf /etc/nginx/nginx.conf
COPY ./conf/server.conf /etc/nginx/http.d/default.conf

ENTRYPOINT ["/usr/bin/dumb-init"]

EXPOSE	443/tcp

CMD ["/bin/sh", "-c", "nginx -g 'daemon off;'"]
# CMD ["/bin/sh", "-c", "/generate_cert.sh && nginx -g 'daemon off;'"]
# nginx -g 'daemon off;' : start the Nginx web server in the foreground
# and prevents it from running as a daemon process in the background,
# meaning that it starts up and runs continuously without user intervention.

# on alpine based linux, typically user is 'nginx' followed by nginx installation.

# /etc/nginx/conf.d/ 
# server {
#      # server ip #
#      listen      10.114.13.11:80;
 
#      # virtual server name i.e. domain name #
#      server_name www.cyberciti.biz;
 
#      # document root #
#      root        /home/www;
 
#      # log files
#      access_log  /var/log/nginx/www.cyberciti.biz_access.log;
#      error_log   /var/log/nginx/www.cyberciti.biz_error.log;
 
#      # cache files on browser level #
#      # Directives to send expires headers and turn off 404 error logging. #
#      location ~* ^.+\.(ogg|ogv|svg|svgz|eot|otf|woff|mp4|ttf|rss|atom|jpg|jpeg|gif|png|ico|zip|tgz|gz|rar|bz2|doc|xls|exe|ppt|tar|mid|midi|wav|bmp|rtf)$ {
#         access_log off; log_not_found off; expires max;
#      }
# }