sed -i "s/CLUSTER_IP/$CLUSTER_IP/g" /etc/telegraf.conf

sed -i "s/REPLACE_WITH_MINIKUBE_IP/$CLUSTER_IP/g" /www/index.html
sed -i "s/REPLACE_WITH_UFTP_PASSWORD/$FTP_PASSWORD/g" /www/index.html
sed -i "s/REPLACE_WITH_PMA_PASSWORD/$PMA_PASSWORD/g" /www/index.html
sed -i "s/REPLACE_WITH_SSH_PASSWORD/$SSH_PASSWORD/g" /www/index.html

sed -i "s/REPLACE_WITH_SSH_PASSWORD/$SSH_PASSWORD/g" /pswd.sh

/pswd.sh

export TELEGRAF_CONFIG_PATH="/etc/telegraf.conf"; telegraf & /usr/sbin/sshd && nginx && tail -f /dev/null