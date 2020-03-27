FROM alpine:latest

RUN apk add grafana --repository http://uk.alpinelinux.org/alpine/edge/testing

COPY srcs/grafana.ini /etc/grafana.ini

RUN apk add telegraf --repository http://nl.alpinelinux.org/alpine/edge/testing
COPY srcs/telegraf.conf /etc/telegraf.conf

RUN mkdir /provisioning
COPY srcs/provisioning /usr/share/grafana/conf/provisioning

RUN mkdir dashboards
COPY srcs/dashboards /dashboards/

# CMD tail -f /dev/null
CMD export TELEGRAF_CONFIG_PATH="/etc/telegraf.conf"; telegraf & cd /usr/share/grafana ; /usr/sbin/grafana-server web --config /etc/grafana.ini

EXPOSE 3000