# TL;DR

- This is a home lab k3s deployment for AI experimentation.
- Local first, privacy first, off-grid first (good to practice compliance stuff).
- There's a simple hello world example.
- N8n is a huge plus, you can create complex workflows. Like telling your bot to trigger your mindstorm legobot using a
  raspberry pi to unplug the energy source of this skynet lab in case of emergency.

---

# UaiSo - Serious? (Why so serious?)

Unchained Artificial Intelligence Stack/Sandbox Ops/Open -- Why so serious about AI?

This project contains k3s (lightweight Kubernetes) deployment manifests for a home lab setup.

Easy to deploy, low hardware requirements, with tools to debug.

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

# Quick start hello world instructions (vm or baremetal):

[docker setup](_setup/docker/README.md) also available.

run the following commands as root inside the machine or vm to deploy the working setup:

```bash
git clone https://github.com/uaiso-serious/infra.git
./infra/_setup/k3s/k3s.sh
```

Takes about 10 minutes to download container images and LLM models depending on your internet speed. You can use k9s
command to check the pod status.

Configure your browser to use a http proxy to access the ingress routes, point it to &lt;your-k3s-ipv4&gt; port 3128.

Easy proxy stuff with [FoxyProxy for Chrome](https://chromewebstore.google.com/search/foxyproxy)
or [FoxyProxy for Firefox](https://addons.mozilla.org/en-US/firefox/addon/foxyproxy-standard/)

Open http://xmpp.uaiso.lan/ login as admin/admin

Say hi to severino bot.

Congratulations, you have the [HELLO_WORLD.md](HELLO_WORLD.md) running.

---

# Notes

If you want to expose this setup to the internet, **don't forget to enable tls, and change the default passwords**.

Or just use ssh tunnels/vpn to access it remotely in a secure way.

It's possible to use another chat integration instead of xmpp/openfire, like discord, slack, telegram, whatsapp, etc.
Just change the n8n workflow to use the desired chat node.

Check [k3s readme](_setup/k3s/README.md) for more detailed DNS configuration instructions for DNS ninjas.

---

# My personal home lab bare metal specs:

- Intel(R) Core(TM) i7-3770 CPU @ 3.40GHz
- 16 GB RAM DDR3 (Using about 3.2GB)
- NVIDIA GeForce RTX 3050 8GB VRAM (Pcie 4.0 x16)
- SSD 256GB
- Pcie 2.0 x16
- Ubuntu Server 24.04 LTS
- k3s v1.33.6+k3s1 (b5847677)
