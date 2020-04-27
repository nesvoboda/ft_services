sed -i "s/CLUSTER_IP/$CLUSTER_IP/g" /etc/telegraf.conf
sed -i "s/PMA_PASSWORD/$PMA_PASSWORD/g" /etc/telegraf.conf
sed -i "s/CLUSTER_IP/$CLUSTER_IP/g" /usr/share/webapps/phpMyAdmin-5.0.2-all-languages/config.inc.php
sed -i "s/PMA_PASSWORD/$PMA_PASSWORD/g" /usr/share/webapps/phpMyAdmin-5.0.2-all-languages/config.inc.php
export TELEGRAF_CONFIG_PATH="/etc/telegraf.conf"; telegraf & lighttpd -f /etc/lighttpd/lighttpd.conf && tail -f /dev/null