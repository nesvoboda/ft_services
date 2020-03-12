FROM alpine

# Update apk repository
RUN apk update

# Install packages
RUN apk add nginx openrc

# Start OpenRC
RUN openrc boot

# Add a user for nginx
RUN adduser -D -g 'www' www

# Add necessary folders for nginx
RUN mkdir /www && chown -R www:www /var/lib/nginx && chown -R www:www /www && mkdir /run/nginx

# Copy the NGINX configuration
COPY srcs/config.conf /etc/nginx/conf.d

RUN rm /etc/nginx/conf.d/default.conf

RUN echo "<h1> Dis nginx </h1>" > /www/index.html

# Expose ports
EXPOSE 80
EXPOSE 443

CMD nginx && tail -f /dev/null