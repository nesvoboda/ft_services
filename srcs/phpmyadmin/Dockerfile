FROM alpine:latest

# Update apk repository
RUN apk update

# Install packages
RUN apk add openrc wget lighttpd php7-common php7-iconv php7-json php7-gd \
php7-curl php7-xml php7-mysqli php7-imap php7-cgi fcgi php7-pdo php7-pdo_mysql \
php7-soap php7-xmlrpc php7-posix php7-mcrypt php7-gettext php7-ldap php7-ctype \
php7-dom php7-session php-mbstring php-xml

# Start OpenRC
RUN openrc boot

# Telegraf setup
RUN apk add telegraf --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing
COPY srcs/telegraf.conf /etc/telegraf.conf
# RUN sed -i "s/CLUSTER_IP/$CLUSTER_IP/g" /etc/telegraf.conf
# RUN sed -i "s/PMA_PASSWORD/$PMA_PASSWORD/g" /etc/telegraf.conf

# Copy lighttpd configuration
COPY srcs/lighttpd.conf /etc/lighttpd/lighttpd.conf
COPY srcs/mod_fastcgi.conf /etc/lighttpd/mod_fastcgi.conf

# Install Wordpress files
RUN mkdir -p /usr/share/webapps/phpmyadmin
RUN cd /usr/share/webapps/ && wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.tar.gz \
 && tar -xvzf ./phpMyAdmin-5.0.2-all-languages.tar.gz && rm phpMyAdmin-5.0.2-all-languages.tar.gz

RUN chown -R lighttpd /usr/share/webapps/
# COPY srcs/wp-config.php /usr/share/webapps/wordpress/wp-config.php

RUN ln -s /usr/share/webapps/phpMyAdmin-5.0.2-all-languages /var/www/localhost/htdocs

# Let lighttpd make his socket
RUN mkdir /var/run/lighttpd
RUN chown -R lighttpd:lighttpd /var/run/lighttpd

COPY srcs/config.inc.php /usr/share/webapps/phpMyAdmin-5.0.2-all-languages/config.inc.php
COPY srcs/start.sh /start.sh
# RUN sed -i "s/CLUSTER_IP/$CLUSTER_IP/g" /usr/share/webapps/phpMyAdmin-5.0.2-all-languages/config.inc.php

# CMD export TELEGRAF_CONFIG_PATH="/etc/telegraf.conf"; telegraf & lighttpd -f /etc/lighttpd/lighttpd.conf && tail -f /dev/null
CMD /start.sh

EXPOSE 80

