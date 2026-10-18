#!/bin/bash

apt-get install -y zip

mkdir -p /mnt/k3s-data /root/.ssh /root/.kube

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--data-dir /mnt/k3s-data" sh -

cp /etc/rancher/k3s/k3s.yaml /root/.kube/config
HOST_IP=$(hostname -I | awk '{print $1}')
sed "s/127.0.0.1/${HOST_IP}/g" /root/.kube/config > /root/.kube/config_ip

while true; do
  kubectl get nodes | grep Ready && break
  sleep 5
done

kubectl -n kube-system rollout status deployment/coredns
kubectl -n kube-system scale deployment/coredns --replicas 0
sed -i "s/127\.0\.0\.1/$HOST_IP/g" ./infra/_setup/k3s/coredns-custom.yaml
kubectl apply -f ./infra/_setup/k3s/coredns-custom.yaml
kubectl -n kube-system scale deployment/coredns --replicas 1
kubectl -n kube-system rollout status deployment/coredns
