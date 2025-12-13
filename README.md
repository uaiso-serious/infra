This project contains k3s (lightweight Kubernetes) deployment manifests for my home lab setup.

# Integration between XMPP, n8n, and AI (Ollama)

This project not only provisions services in the K3s cluster but also demonstrates how they can work together to create a complete experience:

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

create postgresql with pgvector extension
```bash
kubectl apply -f  postgresql/postgresql.yaml
```

Create n8n databases
```bash
kubectl exec -n postgresql postgres-0 -- bash -c "echo 'create database n8n;' | psql -U postgres"
```

deploy the k3s-ia-lab manifests:
```bash
kubectl apply -f k3s-ia-lab.yaml
```

K3s namespace k3s-ia-lab deployments/statefulsets:

| service  readme                | http ingress                                                |
|--------------------------------|-------------------------------------------------------------|
| [n8n](n8n/README.md)           | http://n8n.k3s-ia-lab.lan/                                  |
| [ollama](ollama/README.md)     | http://ollama.k3s-ia-lab.lan                                |
| [openfire](openfire/README.md) | http://xmpp.k3s-ia-lab.lan/ http://xmpp-adm.k3s-ia-lab.lan/ |
| [rabbitmq](rabbitmq/README.md) | http://rabbitmq.k3s-ia-lab.lan                              |

/etc/hosts file entrie to access the ingress routes from your local network:
```
<your-k3s-ipv4> n8n.k3s-ia-lab.lan ollama.k3s-ia-lab.lan xmpp.k3s-ia-lab.lan xmpp-adm.k3s-ia-lab.lan rabbitmq.k3s-ia-lab.lan
```
---

notes...

Don't expose this setup to the internet, it's for home lab use only. There's no security configured, no tls activated.

The openfire image is a custom build with pre-configured settings for easier setup.

---

TODO:

- kubeshark
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
