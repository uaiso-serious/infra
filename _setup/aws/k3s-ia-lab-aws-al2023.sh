#!/bin/bash

mkdir -p /mnt/k3s-data
mkdir -p /mnt/data/{n8n,ollama}
chmod -R 777 /mnt/data

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--data-dir /mnt/k3s-data" sh -

curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-4
chmod 700 get_helm.sh
./get_helm.sh

mkdir -p /home/ec2-user/.kube /root/.kube
cp /etc/rancher/k3s/k3s.yaml /home/ec2-user/.kube/config
cp /etc/rancher/k3s/k3s.yaml /root/.kube/config
chown -R ec2-user:ec2-user /home/ec2-user/.kube
chown ec2-user:ec2-user /etc/rancher/k3s/k3s.yaml

helm repo add nvidia https://helm.ngc.nvidia.com/nvidia
helm repo update

helm install --wait nvidiagpu \
-n gpu-operator --create-namespace \
--set toolkit.env[0].name=CONTAINERD_CONFIG \
--set toolkit.env[0].value=/var/lib/rancher/k3s/agent/etc/containerd/config.toml \
--set toolkit.env[1].name=CONTAINERD_SOCKET \
--set toolkit.env[1].value=/run/k3s/containerd/containerd.sock \
--set toolkit.env[2].name=CONTAINERD_RUNTIME_CLASS \
--set toolkit.env[2].value=nvidia \
--set toolkit.env[3].name=CONTAINERD_SET_AS_DEFAULT \
--set-string toolkit.env[3].value=true \
nvidia/gpu-operator
