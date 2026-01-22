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
