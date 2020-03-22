#!/bin/bash

# Start minikube
minikube start --vm-driver=virtualbox
minikube addons enable ingress

CLUSTER_IP="$(minikube ip)"
sed -i "" "s/CLUSTER_IP/$CLUSTER_IP/g" ftps/srcs/vsftpd.conf
# Set Docker links to Minikube Docker

eval $(minikube docker-env) ; docker build ./nginx/ --tag angi ; docker build ./ftps/ --tag ftps; docker build ./mysql --tag mysql
sed -i "" "s/$CLUSTER_IP/CLUSTER_IP/g" ftps/srcs/vsftpd.conf

kubectl apply -f jinx.yaml

kubectl patch deployment nginx-ingress-controller --patch "$(cat nginx-ingress-controller-patch.yaml)" -n kube-system
kubectl patch configmap tcp-services -n kube-system --patch "$(cat tcp-services-patch.yml)"
