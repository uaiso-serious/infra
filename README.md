# TL;DR

- This is a home lab k3s deployment for AI experimentation.
- Can be used in case of zombie apocalypse (100% private and off-grid).
- There's a simple hello world example.
- N8n is a huge plus, you can create complex workflows. Like telling your bot to trigger your mindstorm legobot using a
  raspberry pi to unplug the energy source of this skynet lab in case of emergency.

---

# UaiSo - Serious? (Why so serious?)

Unchained Artificial Intelligence Stack/Sandbox Ops/Open -- Why so serious about AI?

This project contains k3s (lightweight Kubernetes) deployment manifests for a home lab setup.

Just an AI playground with a hello world example.

Easy to deploy, low hardware requirements, with tools to debug.

---

# Integration between XMPP, n8n, and AI (Ollama)

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

You can use any XMPP client (such as Pidgin, Gajim Dino) to connect to the Openfire server.
Web-xmpp included inside openfire, no need to install xmpp client to test.

A n8n workflow acts as a bridge, receiving messages from the user and sending them to the LLM running on Ollama, then
returning the response directly in the chat.

Don't worry... n8n is not just a bridge, you can create more complex workflows, expose MCP tools to the LLM (like ssh
and playright, custom MCP servers), RAG, VectorDB, and **much more**.

## Why jabber/xmpp? This is old stuff! What's next? Using irc, or BBS with phone lines?

XMPP is an open standard protocol, and running your own XMPP server gives you full control over your data and privacy.
Don't need to rely on third-party services and their rules and rate limits.

Also, it's nice to have in case of a zombie apocalypse, your setup is 100% off-grid, no internet required.

But... I like the irc idea... maybe in the future.

---

# Hardware/network/so requirements (to see the hello world example working):

- Minimum 4GB RAM
- Minimum 2 CPU cores
- Minimum 20GB disk (ubuntu + k3s + container images + LLM models)
- Internet access to download container images and LLM models
- Ubuntu 24.04 LTS

I really recommend using a separate machine or vm for this setup, don't use your Ubuntu desktop/laptop.

---

# LLM api servers that you can use:

- Ollama local models (better with [nvidia instructions](_setup/baremetal/README.md)) 100% off-grid and private.
- Ollama cloud models (requires ollama account, **free tier available**).
- Any available n8n nodes for LLM cloud services (require api keys),
  like, [OpenAI](https://openai.com/) [Antropic](https://www.anthropic.com/), Deepseek, Google Gemini, Aws bedrock, Groq

---

# Quick start instructions:

run the following commands as root inside the machine or vm to deploy the working setup:

```bash
git clone https://github.com/uaiso-serious/infra.git
./infra/_setup/basic.sh
```

Takes about 10 minutes to download container images and LLM models depending on your internet speed. You can use k9s
command to check the pod status.

Configure your browser to use a socks5 proxy to access the ingress routes, point it to &lt;your-k3s-ipv4&gt; port 1080.

Easy proxy stuff with [FoxyProxy for Chrome](https://chromewebstore.google.com/search/foxyproxy)
or [FoxyProxy for Firefox](https://addons.mozilla.org/en-US/firefox/addon/foxyproxy-standard/)

Open http://xmpp.uaiso.lan/ login as admin/admin, say hi to severino bot.

---

# K3s namespace uaiso deployments/statefulsets details:

| service readme                 | http ingress                                      |
|--------------------------------|---------------------------------------------------|
| [ollama](ollama/README.md)     | http://ollama.uaiso.lan                           |
| [openfire](openfire/README.md) | http://xmpp.uaiso.lan/ http://xmpp-adm.uaiso.lan/ |
| [rabbitmq](rabbitmq/README.md) | http://rabbitmq.uaiso.lan                         |
| [n8n](n8n/README.md)           | http://n8n.uaiso.lan/                             |

---

# Notes

**Don't expose this setup to the internet**! It's for home lab use only. There's no security configured, no tls
activated.

The openfire image is a custom build with pre-configured settings for easier setup.

It's possible to use another chat integration instead of xmpp/openfire, like discord, slack, telegram, whatsapp, etc.
Just change the n8n workflow to use the desired chat node.

Check [k3s readme](_setup/k3s/README.md) for more detailed DNS configuration instructions for DNS ninjas.

---

# My personal home lab bare metal specs (potatoe computer with nvidia gpu):

- Intel(R) Core(TM) i7-3770 CPU @ 3.40GHz
- 16 GB RAM DDR3 (Using about 3.2GB)
- NVIDIA GeForce RTX 3050 8GB VRAM (Pcie 4.0 x16)
- SSD 256GB
- Pcie 2.0 x16
- Ubuntu Server 24.04 LTS
- k3s v1.33.6+k3s1 (b5847677)

Don't have hardware? You can try aws, but it will not work in case of mad max scenario.

There are [instructions to setup this lab inside aws](_setup/aws/README.md) g4dn instance.
