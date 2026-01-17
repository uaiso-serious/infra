# Welcome to UaiSo Serious/Infra

GitHub repo [uaiso-serious/infra](https://github.com/uaiso-serious/infra).

## UaiSo - Serious? (Why so serious?)

Unchained Artificial Intelligence Stack/Sandbox Ops/Open -- Why so serious about AI?

This project is a kubernetes "distro", with deployment manifests.

Lot's of AI tools for experimentation.

Local first, privacy first, off-grid first (good to practice compliance stuff).

There's a simple hello world example.

## Know your gear

### Hardware considerations

#### CPU

Check if your CPU supports AVX2 instructions. Many community projects requires it, and they don't want to support old
hardware. Microsoft did that with Windows 11, community projects are doing it too, so I guess we have to accept the
eletronic junk that we are massive creating, like we did changing i386 to i686 and amd64. Now we have some kind of
undocumented "amd64_avx2" and "amd64_avx512" builds laying around.

#### VCPU

If you're using virtual machines, make sure to enable CPU passthrough or set the VM to use host CPU features. This will
allow the VM to utilize the full capabilities of the host CPU, including AVX2 instructions.

#### GPU

Today the easiest way to get good performance for AI workloads is using NVIDIA GPUs, due to the great support from
CUDA/CUDAToolkit. AMD GPUs are getting better support with ROCm, but it's still not as widely adopted as NVIDIA's
ecosystem. Intel is also entering the GPU market with their Arc series, but support for AI workloads is still in its
infancy.

#### RAM

AI workloads can be memory intensive, especially when dealing with large models or diffusion models. Make sure to have
enough RAM to handle your specific use case. Check your model size + context size + batch size + other overheads and
your avalilable RAM.

#### (CPU + RAM) vs (GPU + VRAM)

For many AI tasks, paralell processing on a GPU can significantly outperform CPU-based processing. GPU has more cores
that can handle multiple operations simultaneously, making them ideal for the matrix and vector computations common in
AI workloads. The VRAM on a GPU is also optimized for high throughput compared to regular system RAM, which can lead to
faster data access times. GPU cores have floating point units that are specifically designed for the types of
calculations used in AI, such as matrix multiplications and convolutions. This specialized hardware can lead to
significant performance improvements over general-purpose CPU cores.

In a noob friendly way: your LLM or diffusion model can fit your CPU + RAM, but it will be slow. If it fits in GPU +
VRAM, it will be much faster.

#### Ai hardware

There are specialized AI accelerators like Google's TPU, Coral Edge TPU, Rapberry AI HAT (Hailo AI chip), and other 
companies are developing their own AI chips. These can offer significant performance improvements for specific AI tasks 
like vision, text to speech, audio processing.

One promising option is [https://tenstorrent.com/](https://tenstorrent.com/). I hope one day tenstorrent hardware and
filosofy beats NVIDIA's empire.

#### Monitoring

Talking about NVIDIA GPUs, don't forget to monitor your GPU usage, temperature, and memory consumption. Tools like
`nvidia-smi` can help you keep an eye on your GPU's performance and ensure it's running optimally. Zabbix with Grafana
dashboards is also a good option for monitoring with charts and historical data like power consumption, so you can
understand how expensive and not eco friendly is using AI for everything, like saying hi or thanks to a LLM bot,
or generating cute kitty photos with diffusion models.

### Cloud Hardware

When trying cloud hardware, you will feel the pain of paying for expensive GPU instances. Cloud providers charge a
premium for GPU resources, and the costs can add up quickly, especially for long-running AI workloads. Additionally,
cloud instances may have limitations on GPU availability, leading to potential delays in provisioning resources when
needed.

## Why Kubernetes?

Kubernetes can add some complexity to your setup, but it also brings a lot of benefits that can be worth the effort.

The manifests in this project are designed to be simple and easy to deploy, minimizing the complexity typically
associated with docker, docker-compose, local builds, or endless readmes to follow for each tool available on the
community projects.

A huge plus, is understanding how kubernetes works, and learning the concepts behind it, like pods, services,
deployments, configmaps, secrets, ingress, persistent volumes, storage classes, etc. This knowledge can be valuable for
managing modern applications and infrastructure, increasing your skills and adding nice stuff to your personal toolbox.

One day this project will be kubernetes agnostic, today it's using k3s for simplicity. The goal is to be able to deploy
in any kubernetes cluster, like microk8s, k0s, [https://talos.dev](https://talos.dev), kind, minikube, full blown
kubernetes clusters, or cloud-like services.

## Virtualization

Pick one virtualization platform, so you can create and destroy your environment easily. Some good options are:

- Proxmox VE
- Xenserver
- VirtualBox
- Hyper-V

If you have a bare metal computer laying around you can install Xenserver or Proxmox. I personally like Proxmox VE,
because it's open source, has a web interface, supports LXC containers and KVM virtual machines, and has a nice
community. Also it's possible to use pci-e passthrough for GPUs, which is a must have for AI workloads.

Windows users can use Hyper-V, which is built into Windows 10/11 Pro and Enterprise editions.

Linux users can use VirtualBox or KVM/QEMU.

### Without virtualization

If you don't want to use virtualization, you can install k3s directly on your host operating system. I'm not sure if
gpu passthrough will work with windows host inside wsl, or running Docker desktop or Rancher desktop, but on linux
it should work fine.

## TL;DR Let me try it!

Get a vm or baremetal machine with Ubuntu 24.04 LTS installed, and run:

```bash
git clone https://github.com/uaiso-serious/infra.git
./infra/_setup/k3s/k3s.sh
```

That will install k3s and deploy hello-world manifest.

Takes about 10 minutes to download container images and LLM models depending on your internet speed. You can use k9s
command to check the pod status.

Configure your browser to use a http proxy to access the ingress routes, point it to &lt;your-k3s-ipv4&gt; port 3128.

Easy proxy stuff with [FoxyProxy for Chrome](https://chromewebstore.google.com/search/foxyproxy)
or [FoxyProxy for Firefox](https://addons.mozilla.org/en-US/firefox/addon/foxyproxy-standard/)

Open [http://xmpp.uaiso.lan](http://xmpp.uaiso.lan) login as admin/admin

Say hi to severino bot.

## Tools

### anythingllm

Why anythingllm? It's a nice webui LLM RAG lab.

[https://github.com/Mintplex-Labs/anything-llm](https://github.com/Mintplex-Labs/anything-llm)

- http ingress: [http://anythingllm.uaiso.lan](http://anythingllm.uaiso.lan)

---

### grafana

Why grafana? Not AI related, but good-looking for monitoring the hardware burning when using AI.

[https://github.com/grafana/grafana](https://github.com/grafana/grafana)

- http ingress: [http://grafana.uaiso.lan](http://grafana.uaiso.lan)
- user: admin
- password: admin

---

### keycloak

Why keycloak? Not AI related, but some AI tools can be protected with SSO using keycloak.

[https://github.com/keycloak/keycloak](https://github.com/keycloak/keycloak)

- http ingress: http://auth.uaiso.lan/
- user: admin
- password: admin

---

### kubeshark

Why kubeshark? Not AI related, but you can see how the LLM is talking to the outside world using MCP.

[https://github.com/kubeshark/kubeshark](https://github.com/kubeshark/kubeshark)

- http ingress: [http://ks.uaiso.lan](http://ks.uaiso.lan)

---

### mcp-inspector

Why mcp-inspector? It's a nice tool to inspect the Model Context Protocol (MCP) like using postman for REST APIs.

[https://github.com/modelcontextprotocol/inspector](https://github.com/modelcontextprotocol/inspector)

- http ingress: [http://mcp-inspector.uaiso.lan](http://mcp-inspector.uaiso.lan)

---

### n8n

Why n8n? Easy to create AI workflows and agents.

[https://github.com/n8n-io/n8n](https://github.com/n8n-io/n8n)

- http ingress: [http://n8n.uaiso.lan](http://n8n.uaiso.lan)

---

### ollama

Why ollama? Easy to use Local LLMs.

[https://github.com/ollama/ollama](https://github.com/ollama/ollama)

- http ingress: [http://ollama.uaiso.lan](http://ollama.uaiso.lan)

---

### onedev

Why onedev? A nice self-hosted git server with CI/CD with MCP server.

[https://github.com/theonedev/onedev](https://github.com/theonedev/onedev)

- http ingress: [http://onedev.uaiso.lan](http://onedev.uaiso.lan)

---

### open-webui

Why open-webui? A nice webui for local LLMs with ollama.

[https://github.com/open-webui/open-webui](https://github.com/open-webui/open-webui)

- http ingress: [http://open-webui.uaiso.lan](http://open-webui.uaiso.lan)

---

### openfire

Why openfire? Not AI related. A chat server that you can use to chat with LLM bots.

[https://github.com/igniterealtime/Openfire](https://github.com/igniterealtime/Openfire)

- http ingress: [http://xmpp.uaiso.lan](http://xmpp.uaiso.lan)
- http ingress admin: [http://xmpp-adm.uaiso.lan/](http://xmpp-adm.uaiso.lan/)
- user: admin
- password: admin

---

### postgresql (with pgvector)

Why postgresql? Many tools needs a database backend, and postgresql is a nice option with pgvector extension for vector
search.

[https://github.com/postgres/postgres](https://github.com/postgres/postgres)

---

### rabbitmq

Why rabbitmq? Not AI related, n8n xmpp plugin to integrate openfire with LLM chatbots requires rabbitmq.

[https://github.com/rabbitmq](https://github.com/rabbitmq)

http ingress: [http://rabbitmq.uaiso.lan](http://rabbitmq.uaiso.lan)

---

### zabbix

Why zabbix? Not AI related, gather hardware metrics like GPU usage, temperature, power consumption, used by grafana.

http ingress: [http://zabbix.uaiso.lan](http://zabbix.uaiso.lan)
