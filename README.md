# Documentation

https://uaiso-serious.github.io/infra

---

# UaiSo - Serious? (Why so serious?)

Unchained Artificial Intelligence Stack/Sandbox Ops/Open -- Why so serious about AI?

This project contains kubernetes deployment manifests for a serious AI lab setup.

Easy to deploy, low hardware requirements, with tools to debug.

---

# LLM api servers that you can use:

- Ollama local models (better with [nvidia instructions](_setup/baremetal/README.md)) 100% off-grid and private.
- Ollama cloud models (requires ollama account, **free tier available**).
- Any available n8n nodes for LLM cloud services (require api keys),
  like, [OpenAI](https://openai.com/) [Antropic](https://www.anthropic.com/), Deepseek, Google Gemini, Aws bedrock, Groq

---

# Notes

If you want to expose this setup to the internet, **don't forget to enable tls, and change the default passwords**.

Or just use ssh tunnels/vpn to access it remotely in a secure way.

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
