FROM alpine:latest

RUN apk add influxdb

RUN apk add telegraf --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing
COPY srcs/telegraf.conf /etc/telegraf.conf
RUN sed -i "s/CLUSTER_IP/$CLUSTER_IP/g" /etc/telegraf.conf

COPY srcs/influxdb.conf /etc/influxdb.conf
COPY srcs/telegraf.conf /etc/telegraf.conf
COPY srcs/boot /boot
COPY srcs/boot.sh /boot.sh
COPY srcs/start.sh /start.sh

CMD /start.sh

EXPOSE 8086 8088