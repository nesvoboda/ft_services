#!/bin/ash
sed -i "s/CLUSTER_IP/$CLUSTER_IP/g" /etc/telegraf.conf
sed -i "s/CLUSTER_IP/$CLUSTER_IP/g" /usr/share/webapps/wordpress/wp-config.php
sed -i "s/WPUSR_PASSWORD/$WPUSR_PASSWORD/g" /usr/share/webapps/wordpress/wp-config.php
export TELEGRAF_CONFIG_PATH="/etc/telegraf.conf"; telegraf & lighttpd -f /etc/lighttpd/lighttpd.conf && tail -f /dev/null