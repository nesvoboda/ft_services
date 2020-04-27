FROM alpine

# Update apk repository
RUN apk update

# Install packages
RUN apk add nginx openssl openssh

RUN ssh-keygen -A

# Add user for ssh
RUN adduser \
    --disabled-password \
    --home "/www" \
    --no-create-home \
    jarvis

# Add a user for nginx
RUN adduser -D -g 'www' www

# Add necessary folders for nginx
RUN mkdir /www && chown -R www:www /var/lib/nginx && chown -R www:www /www && mkdir /run/nginx

# Allow everyone to modify web index
RUN chmod -R a+w www

# Remove default NGINX configuration
RUN rm /etc/nginx/conf.d/default.conf

# Copy the NGINX configuration
COPY srcs/default.conf /etc/nginx/conf.d
COPY srcs/index.html /www/index.html

# Telegraf setup
RUN apk add telegraf --repository http://nl.alpinelinux.org/alpine/edge/testing
COPY srcs/telegraf.conf /etc/telegraf.conf

# Creating a self-signed certificate
 RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048\
  -keyout /nginx-selfsigned.key \
  -out /nginx-selfsigned.crt \
  -subj "/C=FR/ST=Denial/L=-/O=-/CN=127.0.0.1"

# Creating a Diffie-Hellman group
 RUN openssl dhparam -dsaparam -out /etc/nginx/dhparam.pem 4096
# Attention: here -dsaparam is used in order to reduce the time needed
# to calculate DH group. More on that here:
# https://security.stackexchange.com/questions/95178/diffie-hellman-parameters-still-calculating-after-24-hours

#Copying nginx configuration for cert
COPY srcs/self-signed.conf /etc/nginx/snippets/self-signed.conf
COPY srcs/ssl-params.conf /etc/nginx/snippets/ssl-params.conf

# Expose ports
EXPOSE 80
EXPOSE 443
EXPOSE 22

COPY srcs/start.sh /start.sh
COPY srcs/pswd.sh /pswd.sh

CMD /start.sh

# CMD export TELEGRAF_CONFIG_PATH="/etc/telegraf.conf"; telegraf & /usr/sbin/sshd && nginx && tail -f /dev/null