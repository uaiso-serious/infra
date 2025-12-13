This project contains k3s (lightweight Kubernetes) deployment manifests for my home lab setup.

# Integration between XMPP, n8n, and AI (Ollama)

This project not only provisions services in the K3s cluster but also demonstrates how they can work together to create a complete experience:

```
   XMPP Client -> Openfire -> AI via Ollama -> XMPP Client
```

You can use any XMPP client (such as Pidgin, Gajim Dino, web-xmpp) to connect to the Openfire server.

A n8n workflow acts as a bridge, receiving messages from the user and sending them to the LLM running on Ollama, then returning the response directly in the chat.

The architecture looks like this:
```
   User (XMPP Client) -> Openfire -> n8n -> Ollama -> n8n -> Openfire -> User (XMPP Client)
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

K3s namespace k3s-ia-lab deployments/statefulsets:
- n8n
- ollama
- openfire
- rabbitmq
- postgresql with pgvector extension
- keycloak
- open-webui

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
sudo mkdir -p /mnt/data/n8n
sudo chmod -R 777 /mnt/data
```

edit coredns-custom.yaml with your k3s ipv4 address
```text
*          IN A      <your-k3s-ipv4>
```

deploy the custom coredns config to resolve k3s-ia-lab.lan domains:
```bash
kubectl apply -f coredns-custom.yaml
```

deploy the k3s manifests:
```bash
kubectl apply -f k3s-ia-lab.yaml
```

/etc/hosts file entrie to access the ingress routes from your local network:
```
<your-k3s-ipv4> n8n.k3s-ia-lab.lan xmpp.k3s-ia-lab.lan xmpp-adm.k3s-ia-lab.lan rabbitmq.k3s-ia-lab.lan open-webui.k3s-ia-lab.lan auth.k3s-ia-lab.lan onedev.k3s-ia-lab.lan mcp-inspector.k3s-ia-lab.lan mcp-inspector-proxy.k3s-ia-lab.lan
```

follow the readmes for each service for initial setup:

postgres with pgvector extension: [postgres README.md](postgresql/README.md)
- dns host: postgres-lb.k3s-ia-lab.svc.cluster.local (k8s internal)
- ip <your-k3s-ipv4>
- port: 5432
- user: postgres
- password: mysecurepassword
- volume mount /mnt/data/postgres

openfire (almost ready) [openfire README.md](openfire/README.md):
- ip: xmpp.k3s-ia-lab.lan
- url xmpp: http://xmpp.k3s-ia-lab.lan/
- url adm: http://xmpp-adm.k3s-ia-lab.lan/
- ports: 5222 tcp/xmpp
- user: admin
- password: admin

ollama [ollama README.md](ollama/README.md):
- url: http://ollama-service.k3s-ia-lab.svc.cluster.local:11434 (k8s internal)
- no apikey
- volume mount /mnt/data/ollama

rabbitmq:
- dns: rabbitmq-lb.k3s-ia-lab.svc.cluster.local (k8s internal)
- port: 5672 tcp/ampq
- url management: http://rabbitmq.k3s-ia-lab.lan
- user: user
- password: password
- vhost: /

n8n: [n8n README.md](n8n/README.md)
- url: http://n8n.k3s-ia-lab.lan/
- volume mount /mnt/data/n8n

keycloak (needs create keycloak pgsql db, initial setup):
- url: http://auth.k3s-ia-lab.lan/
- user: admin
- password: admin

open-webui (needs keycloak with k3s-ia-lab realm, user added to realm, create openwebui pgsql db, needs first setup):
- url http://open-webui.k3s-ia-lab.lan/
- volume mount /mnt/data/open-webui

mcp inspector:
- url http://mcp-inspector.k3s-ia-lab.lan

[onedev README.md](onedev/README.md)

---

notes...

Don't expose this setup to the internet, it's for home lab use only. There's no security configured, no tls activated.

The openfire image is a custom build with pre-configured settings for easier setup.

---

TODO:

- grafana
- kubeshark
- split docs per service
- supabase
- flowise
- chatwoot
- evolution api
- dify
- typebot
- migrate bare metal to run inside proxmox vm with pci-e passthrough of nvidia gpu.
- custom ubuntu container with dev, ops, network tools, ia-console tools.
- ssh-mcp-server (allow LLM to access the custom ubuntu container via ssh)
- playright test runner container
- playright mcp server (allow LLM to execute the playright test runner)
