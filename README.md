This project contains k3s (lightweight Kubernetes) deployment manifests for my home lab setup.

When it's running, is possible to "talk" with Ollama using jabber/xmpp client using n8n workflows.

home lab bare metal specs:
- Intel(R) Core(TM) i7-3770 CPU @ 3.40GHz
- 16 GB RAM DDR3
- NVIDIA GeForce RTX 3050 8GB (Pcie 4.0 x16)
- SSD 256GB
- Pcie 2.0 x16
- Ubuntu Server 24.04 LTS
- k3s v1.33.6+k3s1 (b5847677)

K3s namespace k3s-ia-lab deployments
- n8n
- ollama
- openfire
- rabbitmq

install Ubuntu 24.04 NVIDIA drivers:
https://projectable.me/ubuntu-24-04-nvidia-drivers-ollama/

Install k3s
https://docs.k3s.io/installation

Install NVIDIA GPU Operator on k3s
https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/25.3.3/getting-started.html

```bash
helm repo add nvidia https://helm.ngc.nvidia.com/nvidia
```

```bash
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
```

```bash
kubectl apply -f k3s-ia-lab.yaml
```

create the persistent volume folders:
```bash
sudo mkdir -p /mnt/data/n8n /mnt/data/ollama
sudo chmod -r 777 /mnt/data
```

rabbitmq:
- dns: rabbitmq-lb.k3s-ia-lab.svc.cluster.local
- port: 5672 tcp/ampq, 15672 tcp/http
- user: user
- password: password
- vhost: /

openfire (pre-configured):
- ip: home-lab-ip (change inside k3s-ia-lab.yaml OPENFIRE_FQDN)
- ports: 5222 tcp/xmpp, 9090 tcp/http, 7070 tcp/http
- user: admin
- password: admin

n8n (needs first setup):
- ip: home-lab-ip
- ports: 5678 tcp/http
- volume mount /mnt/data/n8n

ollama:
- url: http://ollama-service.k3s-ia-lab.svc.cluster.local:11434
- no apikey
- volume mount /mnt/data/ollama
