#!/bin/bash
printf "\e[94m   __ _                         _               \n";
printf "  / _| |                       (_)              \n";
printf " | |_| |_   ___  ___ _ ____   ___  ___ ___  ___ \n";
printf " |  _| __| / __|/ _ \ '__\ \ / / |/ __/ _ \/ __|\n";
printf " | | | |_  \__ \  __/ |   \ V /| | (_|  __/\__ \\ \n";
printf " |_|  \__| |___/\___|_|    \_/ |_|\___\___||___/\n";
printf "       ______                                   \n";
printf "      |______|                                  \n";
printf "\n";
printf "@ashishae";
printf "\n";
printf "\n";
printf "\n\n --- Starting Minikube ---\e[0m\n\n\n";

# Start minikube 
minikube start --vm-driver=virtualbox --extra-config=apiserver.service-node-port-range=3000-32767
minikube addons enable ingress



# sed -i "" "s/CLUSTER_IP/$CLUSTER_IP/g" ftps/srcs/vsftpd.conf
# sed -i "" "s/CLUSTER_IP/$CLUSTER_IP/g" wordpress/srcs/wp-config.php
# sed -i "" "s/CLUSTER_IP/$CLUSTER_IP/g" phpmyadmin/srcs/config.inc.php
# sed -i "" "s/CLUSTER_IP/$CLUSTER_IP/g" mysql/srcs/wpdb.sql

# sed -i "" "s/CLUSTER_IP/$CLUSTER_IP/g" grafana/srcs/telegraf.conf
# sed -i "" "s/CLUSTER_IP/$CLUSTER_IP/g" influxdb/srcs/telegraf.conf
# sed -i "" "s/CLUSTER_IP/$CLUSTER_IP/g" mysql/srcs/telegraf.conf
# sed -i "" "s/CLUSTER_IP/$CLUSTER_IP/g" nginx/srcs/telegraf.conf
# sed -i "" "s/CLUSTER_IP/$CLUSTER_IP/g" phpmyadmin/srcs/telegraf.conf
# sed -i "" "s/CLUSTER_IP/$CLUSTER_IP/g" wordpress/srcs/telegraf.conf
# sed -i "" "s/CLUSTER_IP/$CLUSTER_IP/g" ftps/srcs/telegraf.conf

# sed -i "" "s/CLUSTER_IP/$CLUSTER_IP/g" grafana/srcs/provisioning/datasources/all.yaml


# Set Docker links to Minikube Docker and build all images

printf "\e[94m\n\n --- Building Docker images for containers ---\e[0m\n\n\n";

eval $(minikube docker-env) ; docker build ./srcs/nginx/ --tag nginx ;\
docker build ./srcs/ftps/ --tag ftps; \
docker build ./srcs/mysql --tag mysql; \
docker build ./srcs/wordpress --tag wordpress; \
docker build ./srcs/phpmyadmin --tag phpmyadmin;\
docker build ./srcs/influxdb --tag influxdb;\
docker build ./srcs/grafana --tag grafana;\



# # sed -i "" "s/$CLUSTER_IP/CLUSTER_IP/g" ftps/srcs/vsftpd.conf
# # sed -i "" "s/$CLUSTER_IP/CLUSTER_IP/g" wordpress/srcs/wp-config.php
# # sed -i "" "s/$CLUSTER_IP/CLUSTER_IP/g" phpmyadmin/srcs/config.inc.php
# # sed -i "" "s/$CLUSTER_IP/CLUSTER_IP/g" mysql/srcs/wpdb.sql

# # sed -i "" "s/$CLUSTER_IP/CLUSTER_IP/g" grafana/srcs/telegraf.conf
# # sed -i "" "s/$CLUSTER_IP/CLUSTER_IP/g" influxdb/srcs/telegraf.conf
# # sed -i "" "s/$CLUSTER_IP/CLUSTER_IP/g" mysql/srcs/telegraf.conf
# # sed -i "" "s/$CLUSTER_IP/CLUSTER_IP/g" nginx/srcs/telegraf.conf
# # sed -i "" "s/$CLUSTER_IP/CLUSTER_IP/g" phpmyadmin/srcs/telegraf.conf
# # sed -i "" "s/$CLUSTER_IP/CLUSTER_IP/g" wordpress/srcs/telegraf.conf
# # sed -i "" "s/$CLUSTER_IP/CLUSTER_IP/g" ftps/srcs/telegraf.conf



# sed -i "" "s/$CLUSTER_IP/CLUSTER_IP/g" grafana/srcs/provisioning/datasources/all.yaml


printf "\e[94m\n\n --- Generating passwords ---\e[0m\n\n\n";

CLUSTER_IP="$(minikube ip)"
FTP_PASSWORD="$(openssl rand -hex 20)"
WPUSR_PASSWORD="$(openssl rand -hex 20)"
MYSQL_ROOT_PASSWORD="$(openssl rand -hex 20)"
PMA_PASSWORD="$(openssl rand -hex 20)"
SSH_PASSWORD="$(openssl rand -hex 20)"
printf "FTP PASSWORD IS %s\n" $FTP_PASSWORD
printf "WPUSR PASSWORD IS %s\n" $WPUSR_PASSWORD
printf "MYSQL ROOT PASSWORD IS %s\n" $MYSQL_ROOT_PASSWORD
printf "PHPMYADMIN PASSWORD IS %s\n" $PMA_PASSWORD
printf "SSH PASSWORD IS %s\n" $SSH_PASSWORD


# Pass Minikube's internal address to container environments
# by adding it to the Kubernetes YAML config

sed -i "" "s/REPLACE_WITH_MINIKUBE_IP/$CLUSTER_IP/g" srcs/ft_services.yaml

# Generate and pass passwords to container environments

sed -i "" "s/REPLACE_WITH_FTP_PASSWORD/$FTP_PASSWORD/g" srcs/ft_services.yaml
sed -i "" "s/REPLACE_WITH_WPUSR_PASSWORD/$WPUSR_PASSWORD/g" srcs/ft_services.yaml
sed -i "" "s/REPLACE_WITH_MYSQL_ROOT_PASSWORD/$MYSQL_ROOT_PASSWORD/g" srcs/ft_services.yaml
sed -i "" "s/REPLACE_WITH_PMA_PASSWORD/$PMA_PASSWORD/g" srcs/ft_services.yaml
sed -i "" "s/REPLACE_WITH_SSH_PASSWORD/$SSH_PASSWORD/g" srcs/ft_services.yaml

printf "\e[94m\n\n --- Save them somewhere. Now applying Kubernetes configuration: ---\e[0m\n\n\n";

kubectl apply -f srcs/ft_services.yaml

# Remove Minikube's IP from Kubernetes YAML config for future runs

sed -i "" "s/$CLUSTER_IP/REPLACE_WITH_MINIKUBE_IP/g" srcs/ft_services.yaml

# Remove passwords from Kubernetes YAML config for future runs

sed -i "" "s/$FTP_PASSWORD/REPLACE_WITH_FTP_PASSWORD/g" srcs/ft_services.yaml
sed -i "" "s/$WPUSR_PASSWORD/REPLACE_WITH_WPUSR_PASSWORD/g" srcs/ft_services.yaml
sed -i "" "s/$MYSQL_ROOT_PASSWORD/REPLACE_WITH_MYSQL_ROOT_PASSWORD/g" srcs/ft_services.yaml
sed -i "" "s/$PMA_PASSWORD/REPLACE_WITH_PMA_PASSWORD/g" srcs/ft_services.yaml

kubectl patch deployment nginx-ingress-controller --patch "$(cat srcs/nginx-ingress-controller-patch.yaml)" -n kube-system
kubectl patch configmap tcp-services -n kube-system --patch "$(cat srcs/tcp-services-patch.yml)"

printf "\e[94m\n\n --- You're all set! ---\e[0m\n\n\n";
printf "\n\n --- Your cluster ip is %s ---\e[0m\n\n\n" $CLUSTER_IP;


printf "\e[94m\n\n --- Almost forgot! Starting dashboard. Don't close this terminal window. ---\e[0m\n\n\n";

minikube dashboard
