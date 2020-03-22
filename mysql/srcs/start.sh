MYSQL_ROOT_PASSWORD=`1234`
MYSQL_PASSWORD=`1234`
echo "root: ${MYSQL_ROOT_PASSWORD}"
echo "wpusr: ${MYSQL_PASSWORD}"

cat << EOF > /init.sql
USE mysql;
FLUSH PRIVILEGES ;
GRANT ALL ON *.* TO 'root'@'%' identified by '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION ;
GRANT ALL ON *.* TO 'root'@'localhost' identified by '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION ;
SET PASSWORD FOR 'root'@'localhost'=PASSWORD('${MYSQL_ROOT_PASSWORD}') ;
CREATE DATABASE IF NOT EXISTS wpdb;
GRANT ALL ON wpdb.* to 'wpusr'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
DROP DATABASE IF EXISTS test ;
FLUSH PRIVILEGES ;

EOF

/usr/bin/mysqld --user=mysql --bootstrap --verbose=0 --skip-name-resolve --skip-networking=0 < ./init.sql ; /usr/bin/mysqld --user=mysql --verbose=0 --skip-name-resolve --skip-networking=0 < ./init.sql