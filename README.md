This project contains k3s (lightweight Kubernetes) deployment manifests for my home lab setup.

# Integration between XMPP, n8n, and AI (Ollama)

This project not only provisions services in the K3s cluster but also demonstrates how they can work together to create a complete experience:

```
   XMPP Client -> Openfire -> AI via Ollama -> XMPP Client
```

You can use any XMPP client (such as Pidgin, Gajim Dino, web-xmpp) to connect to the Openfire server.

A n8n workflow acts as a bridge, receiving messages from the user and sending them to the LLM running on Ollama, then returning the response directly in the chat.

Example n8n Workflow
The repository already includes a versioned n8n workflow that shows how to integrate XMPP events and Ollama API calls, enabling advanced automation (e.g., processing messages, enriching responses, or triggering other actions).

# Example Flow:

[severino-xmpp.json](n8n/severino-xmpp.json)
```
   User (XMPP Client) -> Openfire -> Bot -> Ollama -> User (XMPP Client)
```

When it's running, is possible to "talk" with Ollama using jabber/xmpp client using n8n workflows.

You can use local models running on Ollama or different LLM cloud services like [OpenAI](https://openai.com/), [Antropic](https://www.anthropic.com/), Deepseek, Google Gemini, Aws bedrock, Groq, or any available n8n nodes.

---

home lab bare metal specs:
- Intel(R) Core(TM) i7-3770 CPU @ 3.40GHz
- 16 GB RAM DDR3 (Using about 5GB for k3s)
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

create the persistent volume folder:
```bash
sudo mkdir -p /mnt/data
sudo chmod 777 /mnt/data
```

add to your /etc/hosts file (server and client) the following entries:
```
<your-k3s-ipv4> n8n.k3s-ia-lab.lan xmpp.k3s-ia-lab.lan xmpp-adm.k3s-ia-lab.lan rabbitmq.k3s-ia-lab.lan open-webui.k3s-ia-lab.lan auth.k3s-ia-lab.lan
```

edit hostAliases inside [k3s-ia-lab.yaml](k3s-ia-lab.yaml) with <your-k3s-ipv4>

deploy the k3s manifests:
```bash
kubectl apply -f k3s-ia-lab.yaml
```

rabbitmq:
- dns: rabbitmq-lb.k3s-ia-lab.svc.cluster.local (k8s internal)
- port: 5672 tcp/ampq
- url management: http://rabbitmq.k3s-ia-lab.lan
- user: user
- password: password
- vhost: /

openfire (pre-configured):
- ip: xmpp.k3s-ia-lab.lan
- url xmpp: http://xmpp.k3s-ia-lab.lan/
- url adm: http://xmpp-adm.k3s-ia-lab.lan/
- ports: 5222 tcp/xmpp
- user: admin
- password: admin

n8n (needs first setup):
- url: http://n8n.k3s-ia-lab.lan/
- volume mount /mnt/data/n8n

ollama:
- url: http://ollama-service.k3s-ia-lab.svc.cluster.local:11434 (k8s internal)
- no apikey
- volume mount /mnt/data/ollama

postgres:
 - dns host: postgresql-lb.k3s-ia-lab.svc.cluster.local (k8s internal)
 - ip <your-k3s-ipv4>
 - port: 5432
 - user: postgres
 - password: mysecurepassword
 - volume mount /mnt/data/postgres

keycloak (needs create keycloak pgsql db, setup with port forwarding):
- url: http://auth.k3s-ia-lab.lan/

open-webui (needs keycloak, create openwebui pgsql db, needs first setup):
- url http://open-webui.k3s-ia-lab.lan/
- volume mount /mnt/data/open-webui

---

notes...

Don't expose this setup to the internet, it's for home lab use only. There's no security configured, no tls activated.

The openfire image is a custom build with pre-configured settings for easier setup.

---

Wanted services to add in the future:
- onedev
- keycloak
- custom ubuntu container with dev, ops, network tools, ia-console tools.
- ssh-mcp-server (allow LLM to access the custom ubuntu container via ssh)
- playright test runner container
- playright mcp server (allow LLM to execute the playright test runner)
- pgsql vector db for embeddings storage
