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
if [[ $OSTYPE == "linux-gnu" ]];
then
    minikube start --vm-driver=docker --extra-config=apiserver.service-node-port-range=3000-32767 --extra-config=kubeadm.ignore-preflight-errors=NumCPU --force --cpus 1
else
    minikube start --vm-driver=virtualbox --extra-config=apiserver.service-node-port-range=3000-32767
fi
minikube addons enable ingress

printf "\e[94m\n\n --- Building Docker images for containers ---\e[0m\n\n\n";

# Set Docker links to Minikube Docker and build all images
eval $(minikube docker-env);
docker build ./srcs/nginx/ --tag nginx ;\
docker build ./srcs/ftps/ --tag ftps; \
docker build ./srcs/mysql --tag mysql; \
docker build ./srcs/wordpress --tag wordpress; \
docker build ./srcs/phpmyadmin --tag phpmyadmin;\
docker build ./srcs/influxdb --tag influxdb;\
docker build ./srcs/grafana --tag grafana;\


printf "\e[94m\n\n --- Generating passwords ---\e[0m\n\n\n";

# Generate and print passwords for our services
if [[ $OSTYPE == "linux-gnu" ]];
then
    CLUSTER_IP="$(kubectl get node -o=custom-columns='DATA:status.addresses[0].address' | sed -n 2p)"
else
    CLUSTER_IP="$(minikube ip)"
fi


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


# Pass passwords (and minikube's IP) to container environments

# Due to COVID-19 this script may be run both on Mac and Linux so we have to
# check before using sed's BSD or Linux syntax

if [[ $OSTYPE == "linux-gnu" ]];
then
    sed -i "s/REPLACE_WITH_MINIKUBE_IP/$CLUSTER_IP/g" srcs/ft_services.yaml
    sed -i "s/REPLACE_WITH_FTP_PASSWORD/$FTP_PASSWORD/g" srcs/ft_services.yaml
    sed -i "s/REPLACE_WITH_WPUSR_PASSWORD/$WPUSR_PASSWORD/g" srcs/ft_services.yaml
    sed -i "s/REPLACE_WITH_MYSQL_ROOT_PASSWORD/$MYSQL_ROOT_PASSWORD/g" srcs/ft_services.yaml
    sed -i "s/REPLACE_WITH_PMA_PASSWORD/$PMA_PASSWORD/g" srcs/ft_services.yaml
    sed -i "s/REPLACE_WITH_SSH_PASSWORD/$SSH_PASSWORD/g" srcs/ft_services.yaml
else
    sed -i "" "s/REPLACE_WITH_MINIKUBE_IP/$CLUSTER_IP/g" srcs/ft_services.yaml
    sed -i "" "s/REPLACE_WITH_FTP_PASSWORD/$FTP_PASSWORD/g" srcs/ft_services.yaml
    sed -i "" "s/REPLACE_WITH_WPUSR_PASSWORD/$WPUSR_PASSWORD/g" srcs/ft_services.yaml
    sed -i "" "s/REPLACE_WITH_MYSQL_ROOT_PASSWORD/$MYSQL_ROOT_PASSWORD/g" srcs/ft_services.yaml
    sed -i "" "s/REPLACE_WITH_PMA_PASSWORD/$PMA_PASSWORD/g" srcs/ft_services.yaml
    sed -i "" "s/REPLACE_WITH_SSH_PASSWORD/$SSH_PASSWORD/g" srcs/ft_services.yaml
fi

printf "\e[94m\n\n --- Save them somewhere. Now applying Kubernetes configuration: ---\e[0m\n\n\n";

kubectl apply -f srcs/ft_services.yaml

# Remove context from Kubernetes YAML config for future runs

if [[ $OSTYPE == "linux-gnu" ]];
then
    sed -i "s/$CLUSTER_IP/REPLACE_WITH_MINIKUBE_IP/g" srcs/ft_services.yaml
    sed -i "s/$FTP_PASSWORD/REPLACE_WITH_FTP_PASSWORD/g" srcs/ft_services.yaml
    sed -i "s/$WPUSR_PASSWORD/REPLACE_WITH_WPUSR_PASSWORD/g" srcs/ft_services.yaml
    sed -i "s/$MYSQL_ROOT_PASSWORD/REPLACE_WITH_MYSQL_ROOT_PASSWORD/g" srcs/ft_services.yaml
    sed -i "s/$PMA_PASSWORD/REPLACE_WITH_PMA_PASSWORD/g" srcs/ft_services.yaml
else
    sed -i "" "s/$CLUSTER_IP/REPLACE_WITH_MINIKUBE_IP/g" srcs/ft_services.yaml
    sed -i "" "s/$FTP_PASSWORD/REPLACE_WITH_FTP_PASSWORD/g" srcs/ft_services.yaml
    sed -i "" "s/$WPUSR_PASSWORD/REPLACE_WITH_WPUSR_PASSWORD/g" srcs/ft_services.yaml
    sed -i "" "s/$MYSQL_ROOT_PASSWORD/REPLACE_WITH_MYSQL_ROOT_PASSWORD/g" srcs/ft_services.yaml
    sed -i "" "s/$PMA_PASSWORD/REPLACE_WITH_PMA_PASSWORD/g" srcs/ft_services.yaml
fi

# Patch NGINX Ingress controller configmaps in order to enable FTPS
# (a non-HTTP TCP service) discovery and routing

kubectl patch deployment nginx-ingress-controller --patch "$(cat srcs/nginx-ingress-controller-patch.yaml)" -n kube-system
kubectl patch configmap tcp-services -n kube-system --patch "$(cat srcs/tcp-services-patch.yml)"

printf "\e[94m\n\n --- You're all set! ---\e[0m\n\n\n";
printf "\n\n --- Your cluster ip is %s ---\e[0m\n\n\n" $CLUSTER_IP;

printf "\e[94m\n\n --- Almost forgot! Starting dashboard. Don't close this terminal window. ---\e[0m\n\n\n";

minikube dashboard
