#!/bin/bash

mkdir -p /mnt/k3s-data
mkdir -p /mnt/data/{n8n,ollama}
chmod -R 777 /mnt/data

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--data-dir /mnt/k3s-data" sh -

curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-4
chmod 700 get_helm.sh
./get_helm.sh

HOST_IP=$(hostname -I | awk '{print $1}')

echo "
$HOST_IP n8n.uaiso.lan \
ollama.uaiso.lan \
xmpp.uaiso.lan \
xmpp-adm.uaiso.lan \
rabbitmq.uaiso.lan \
grafana.uaiso.lan \
auth.uaiso.lan \
ks.uaiso.lan \
mcp-inspector.uaiso.lan \
mcp-inspector-proxy.uaiso.lan \
onedev.uaiso.lan \
open-webui.uaiso.lan \
zabbix.uaiso.lan" >> /etc/hosts

sed -i "s/127\.0\.0\.1/$HOST_IP/g" ./infra/_setup/k3s/coredns-custom.yaml
kubectl apply -f ./infra/_setup/k3s/coredns-custom.yaml

kubectl apply -f ./infra/postgresql/pgvector.yaml
kubectl rollout status statefulset/postgres -n postgresql
kubectl apply -f ./infra/uaiso.yaml

cp /etc/rancher/k3s/k3s.yaml /root/.kube/config

wget https://github.com/derailed/k9s/releases/download/v0.32.5/k9s_linux_amd64.deb
dpkg -i k9s_linux_amd64.deb
