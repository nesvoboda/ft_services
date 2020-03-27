FROM alpine:latest

RUN apk add influxdb

RUN apk add telegraf --repository http://nl.alpinelinux.org/alpine/edge/testing
COPY srcs/telegraf.conf /etc/telegraf.conf

COPY srcs/influxdb.conf /etc/influxdb.conf
COPY srcs/telegraf.conf /etc/telegraf.conf
COPY srcs/boot /boot
COPY srcs/boot.sh /boot.sh

CMD export TELEGRAF_CONFIG_PATH="/etc/telegraf.conf"; telegraf & /boot.sh & influxd -config /etc/influxdb.conf

EXPOSE 8086 8088