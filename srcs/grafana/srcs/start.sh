sed -i "s/CLUSTER_IP/$CLUSTER_IP/g" /etc/telegraf.conf
sed -i "s/CLUSTER_IP/$CLUSTER_IP/g" /usr/share/grafana/conf/provisioning/datasources/all.yaml

export TELEGRAF_CONFIG_PATH="/etc/telegraf.conf"; telegraf & cd /usr/share/grafana ; /usr/sbin/grafana-server web --config /etc/grafana.ini