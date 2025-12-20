# UaiSo - Serious? (Why so serious?)

Unchained Artificial Intelligence Stack/Sandbox Ops/Open -- Why so serious about AI?

Just an AI playground with a nice hello world example.

Easy to deploy, low hardware requirements, with nice tools to debug.

It's possible to integrate LLM with MCP server (like ssh and playright), RAG, VectorDB, and **much more**.

---

This project contains k3s (lightweight Kubernetes) deployment manifests for a home lab setup.

# Integration between XMPP, n8n, and AI (Ollama)

This project not only provisions services in the K3s cluster but also demonstrates how they can work together to create
a complete experience:

You can use any XMPP client (such as Pidgin, Gajim Dino) to connect to the Openfire server.
Web-xmpp included inside openfire, no need to install xmpp client to test.

A n8n workflow acts as a bridge, receiving messages from the user and sending them to the LLM running on Ollama, then
returning the response directly in the chat.

The architecture looks like this:

XMPP Client <-> Openfire <-> n8n <-> Ollama LLM Integration

![xmpp_llm.svg](xmpp_llm.svg)

<!--
@startuml
title XMPP Client <-> Openfire <-> n8n <-> Ollama LLM Integration
actor "User (XMPP Client)" as User
participant "Openfire" as Openfire
participant "n8n" as n8n
participant "Ollama" as Ollama

User -> Openfire : Send message
Openfire -> n8n : Forwards message
n8n -> Ollama : Ask LLM with message
Ollama -> n8n : Return LLM response
n8n -> Openfire : Forwards response
Openfire -> User : Delivery response
@enduml
-->

When it's running, is possible to "talk" with Ollama using jabber/xmpp client using n8n workflows.

---

# Hardware/network/so requirements:

- Minimum 4GB RAM
- Minimum 2 CPU cores
- Minimum 80GB disk space
- (Optional) NVIDIA GPU for local LLM models
- Internet access to download container images and LLM models
- Ubuntu 24.04 LTS

---

# LLM api servers that you can use:

- Ollama local models (requires [nvidia instructions](_setup/baremetal/README.md))
- Ollama cloud models (requires ollama account, **free tier available**)
- Any available n8n nodes for LLM cloud services (require api keys),
  like, [OpenAI](https://openai.com/) [Antropic](https://www.anthropic.com/), Deepseek, Google Gemini, Aws bedrock, Groq

---

# Quick start deployment instructions:

run the following commands as root to deploy the working setup:

```bash
git clone https://github.com/uaiso-serious/infra.git
./infra/_setup/basic.sh
```

---

# K3s namespace uaiso deployments/statefulsets details:

| service readme                 | http ingress                                      |
|--------------------------------|---------------------------------------------------|
| [ollama](ollama/README.md)     | http://ollama.uaiso.lan                           |
| [openfire](openfire/README.md) | http://xmpp.uaiso.lan/ http://xmpp-adm.uaiso.lan/ |
| [rabbitmq](rabbitmq/README.md) | http://rabbitmq.uaiso.lan                         |
| [n8n](n8n/README.md)           | http://n8n.uaiso.lan/                             |

---

# DNS considerations

Use ssh tunnel with dynamic port forwarding to access the services from your local network:

```bash
ssh <your-k3s-ipv4> -D 7777
```

Use socks proxy in your browser or system resolve the *.uaiso.lan dns and access the ingress routes.

Alternatively, you can edit your /etc/hosts file, just like the ./infra/_setup/basic.sh did inside the k3s host.

If you have a dns server in your home network (like pihole for example), you can add wildcard dns entry for *.uaiso.lan
pointing to your k3s host ip address.

---

# Notes

**Don't expose this setup to the internet**! It's for home lab use only. There's no security configured, no tls
activated.

The openfire image is a custom build with pre-configured settings for easier setup.

It's possible to use another chat integration instead of xmpp/openfire, like discord, slack, telegram, whatsapp, etc.
Just change the n8n workflow to use the desired chat node.

---

# My personal home lab bare metal specs (potatoe computer with nvidia gpu):

- Intel(R) Core(TM) i7-3770 CPU @ 3.40GHz
- 16 GB RAM DDR3 (Using about 3.2GB)
- NVIDIA GeForce RTX 3050 8GB VRAM (Pcie 4.0 x16)
- SSD 256GB
- Pcie 2.0 x16
- Ubuntu Server 24.04 LTS
- k3s v1.33.6+k3s1 (b5847677)

Don't have hardware? You can try aws.

There are [instructions to setup this lab inside aws](_setup/aws/README.md) g4dn instance.
