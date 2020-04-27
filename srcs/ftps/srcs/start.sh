
sed -i "s/CLUSTER_IP/$CLUSTER_IP/g" /etc/vsftpd/vsftpd.conf
sed -i "s/CLUSTER_IP/$CLUSTER_IP/g" /etc/telegraf.conf
passwd uftp -d $FTP_PASSWORD
export TELEGRAF_CONFIG_PATH="/etc/telegraf.conf"; telegraf & vsftpd /etc/vsftpd/vsftpd.conf