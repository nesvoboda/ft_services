FROM alpine:latest

# Update apk repository
RUN apk update

# Install packages
RUN apk add mariadb mariadb-client mariadb-server-utils pwgen

# Telegraf setup
RUN apk add telegraf --repository http://nl.alpinelinux.org/alpine/edge/testing
COPY srcs/telegraf.conf /etc/telegraf.conf

RUN mkdir -p /run/mysqld && chown mysql /run/mysqld
RUN touch /run/mysqld/mysqld.sock && chown mysql /run/mysqld/mysqld.sock

# RUN mysql_install_db --user=mysql --ldata=/var/lib/mysql
RUN mysql_install_db --user=mysql --ldata=/var/lib/mysql

#COPY srcs/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf

# CMD /usr/bin/mysqld --user=mysql --console --skip-name-resolve --skip-networking=0; tail -f /dev/null
COPY ./srcs/start.sh /start.sh
RUN chmod +x /start.sh
CMD export TELEGRAF_CONFIG_PATH="/etc/telegraf.conf"; telegraf & ./start.sh ; 
# CMD su mysql ; mysqld

EXPOSE 3306