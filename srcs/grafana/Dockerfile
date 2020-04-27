FROM alpine:latest

RUN apk add grafana --repository http://uk.alpinelinux.org/alpine/edge/testing

COPY srcs/grafana.ini /etc/grafana.ini

RUN apk add telegraf --repository http://nl.alpinelinux.org/alpine/edge/testing
COPY srcs/telegraf.conf /etc/telegraf.conf
# RUN sed -i "s/CLUSTER_IP/$CLUSTER_IP/g" /etc/telegraf.conf

RUN mkdir /provisioning
COPY srcs/provisioning /usr/share/grafana/conf/provisioning
# RUN sed -i "s/CLUSTER_IP/$CLUSTER_IP/g" /usr/share/grafana/conf/provisioning/datasources/all.yaml
RUN mkdir dashboards
COPY srcs/dashboards /dashboards/

# CMD tail -f /dev/null
COPY /srcs/start.sh /start.sh
CMD /start.sh

EXPOSE 3000