FROM alpine:latest

RUN apk --no-cache add vsftpd openssl

RUN touch /etc/vsftpd.chroot_list
COPY srcs/vsftpd.conf /etc/vsftpd/vsftpd.conf
RUN mkdir /ftp && echo "42born2code" > /ftp/testfile

# Telegraf setup
RUN apk add telegraf --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing
COPY srcs/telegraf.conf /etc/telegraf.conf

RUN adduser \
    --disabled-password \
    --home "/ftp" \
    --no-create-home \
    uftp

RUN chown uftp /ftp
RUN chgrp uftp /ftp

# RUN mkdir /etc/ssl/private
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/vsftpd.key -out /etc/ssl/certs/vsftpd.crt \
    -subj "/C=FR/ST=Denial/L=-/O=-/CN=127.0.0.1"

EXPOSE 21
EXPOSE 20
EXPOSE 31100-31110
COPY srcs/start.sh /start.sh
CMD sh /start.sh
# CMD tail -f /dev/null