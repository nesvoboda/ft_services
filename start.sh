#!/bin/bash

# Start minikube 
minikube start --vm-driver=virtualbox --extra-config=apiserver.service-node-port-range=3000-32767
minikube addons enable ingress

CLUSTER_IP="$(minikube ip)"
sed -i "" "s/CLUSTER_IP/$CLUSTER_IP/g" ftps/srcs/vsftpd.conf
sed -i "" "s/CLUSTER_IP/$CLUSTER_IP/g" wordpress/srcs/wp-config.php
sed -i "" "s/CLUSTER_IP/$CLUSTER_IP/g" phpmyadmin/srcs/config.inc.php

sed -i "" "s/CLUSTER_IP/$CLUSTER_IP/g" grafana/srcs/telegraf.conf
sed -i "" "s/CLUSTER_IP/$CLUSTER_IP/g" influxdb/srcs/telegraf.conf
sed -i "" "s/CLUSTER_IP/$CLUSTER_IP/g" mysql/srcs/telegraf.conf
sed -i "" "s/CLUSTER_IP/$CLUSTER_IP/g" nginx/srcs/telegraf.conf
sed -i "" "s/CLUSTER_IP/$CLUSTER_IP/g" phpmyadmin/srcs/telegraf.conf
sed -i "" "s/CLUSTER_IP/$CLUSTER_IP/g" wordpress/srcs/telegraf.conf
sed -i "" "s/CLUSTER_IP/$CLUSTER_IP/g" ftps/srcs/telegraf.conf

sed -i "" "s/CLUSTER_IP/$CLUSTER_IP/g" grafana/srcs/provisioning/datasources/all.yaml


# Set Docker links to Minikube Docker and build all images

eval $(minikube docker-env) ; docker build ./nginx/ --tag angi ;\
docker build ./ftps/ --tag ftps; \
docker build ./mysql --tag mysql; \
docker build ./wordpress --tag wordpress; \
docker build ./phpmyadmin --tag phpmyadmin;\
docker build ./influxdb --tag influxdb;\
docker build ./grafana --tag grafana;\

sed -i "" "s/$CLUSTER_IP/CLUSTER_IP/g" ftps/srcs/vsftpd.conf
sed -i "" "s/$CLUSTER_IP/CLUSTER_IP/g" wordpress/srcs/wp-config.php
sed -i "" "s/$CLUSTER_IP/CLUSTER_IP/g" phpmyadmin/srcs/config.inc.php

sed -i "" "s/$CLUSTER_IP/CLUSTER_IP/g" grafana/srcs/telegraf.conf
sed -i "" "s/$CLUSTER_IP/CLUSTER_IP/g" influxdb/srcs/telegraf.conf
sed -i "" "s/$CLUSTER_IP/CLUSTER_IP/g" mysql/srcs/telegraf.conf
sed -i "" "s/$CLUSTER_IP/CLUSTER_IP/g" nginx/srcs/telegraf.conf
sed -i "" "s/$CLUSTER_IP/CLUSTER_IP/g" phpmyadmin/srcs/telegraf.conf
sed -i "" "s/$CLUSTER_IP/CLUSTER_IP/g" wordpress/srcs/telegraf.conf
sed -i "" "s/$CLUSTER_IP/CLUSTER_IP/g" ftps/srcs/telegraf.conf



sed -i "" "s/$CLUSTER_IP/CLUSTER_IP/g" grafana/srcs/provisioning/datasources/all.yaml


kubectl apply -f jinx.yaml

kubectl patch deployment nginx-ingress-controller --patch "$(cat nginx-ingress-controller-patch.yaml)" -n kube-system
kubectl patch configmap tcp-services -n kube-system --patch "$(cat tcp-services-patch.yml)"
