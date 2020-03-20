FROM alpine:latest

# Update apk repository
RUN apk update

# Install packages
RUN apk add openrc wget lighttpd php7-common php7-iconv php7-json php7-gd \
php7-curl php7-xml php7-mysqli php7-imap php7-cgi fcgi php7-pdo php7-pdo_mysql \
php7-soap php7-xmlrpc php7-posix php7-mcrypt php7-gettext php7-ldap php7-ctype \
php7-dom

# Start OpenRC
RUN openrc boot

# Copy lighttpd configuration
COPY srcs/lighttpd.conf /etc/lighttpd/lighttpd.conf
COPY srcs/mod_fastcgi.conf /etc/lighttpd/mod_fastcgi.conf

# Install Wordpress files
RUN mkdir -p /usr/share/webapps/
RUN cd /usr/share/webapps && wget https://wordpress.org/wordpress-5.3.2.tar.gz\
 && tar -xvzf wordpress-5.3.2.tar.gz && rm wordpress-5.3.2.tar.gz

RUN chown -R lighttpd /usr/share/webapps/

RUN ln -s /usr/share/webapps/wordpress /var/www/localhost/htdocs

# Let lighttpd make his socket
RUN mkdir /var/run/lighttpd
RUN chown -R lighttpd:lighttpd /var/run/lighttpd

CMD lighttpd -f /etc/lighttpd/lighttpd.conf && tail -f /dev/null

EXPOSE 80

