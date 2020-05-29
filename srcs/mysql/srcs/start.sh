cat << EOF > /init.sql
USE mysql;
FLUSH PRIVILEGES ;
GRANT ALL ON *.* TO 'root'@'%' identified by '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION ;
GRANT ALL ON *.* TO 'root'@'localhost' identified by '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION ;
SET PASSWORD FOR 'root'@'localhost'=PASSWORD('${MYSQL_ROOT_PASSWORD}') ;
CREATE DATABASE IF NOT EXISTS wpdb;
CREATE DATABASE IF NOT EXISTS phpmyadmin;
CREATE USER 'wpusr'@'%' IDENTIFIED BY '$WPUSR_PASSWORD';
GRANT ALL ON wpdb.* to 'wpusr'@'%';
CREATE USER 'pmausr'@'%' IDENTIFIED BY '$PMA_PASSWORD';
GRANT ALL ON phpmyadmin.* to 'pmausr'@'%';
GRANT ALL ON *.* TO 'pmausr'@'%';
DROP DATABASE IF EXISTS test ;
FLUSH PRIVILEGES ;

EOF

sed -i "s/MYSQL_ROOT_PASSWORD/$MYSQL_ROOT_PASSWORD/g" /init.sh
sed -i "s/CLUSTER_IP/$CLUSTER_IP/g" /wpdb.sql
sed -i "s/CLUSTER_IP/$CLUSTER_IP/g" /etc/telegraf.conf

mysql_install_db --user=mysql --ldata=/testvolume;\
/usr/bin/mysqld --user=mysql --bootstrap --verbose=0 --skip-name-resolve --datadir=/testvolume --skip-networking=0 < ./init.sql;\
/init.sh &\
/usr/bin/mysqld --user=mysql --skip-name-resolve --skip-networking=0 --datadir=/testvolume