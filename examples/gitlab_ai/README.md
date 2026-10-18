# Gitlab with Ai agent

This document describes a simple example of integrating Claude code with Gitlab.

## Requirements

Hardware/network/so requirements

- Minimum 16GB RAM
- Minimum 4 CPU cores
- Minimum 30GB disk (ubuntu + k3s + container images)
- Internet access to download container images and LLM model
- Ubuntu 24.04 LTS

## Quick start

Script automation instructions (vm or baremetal)

run the following commands as root inside the machine or vm to deploy the working setup:

```bash
git clone https://github.com/uaiso-serious/infra.git
./infra/_setup/k3s/k3s.sh
./infra/_setup/helm.sh
./infra/examples/gitlab_ai/gitlab_ai.sh
```

Create free ollama account, generate API key

[https://ollama.com/settings/keys](https://ollama.com/settings/keys)

Create the secret with your API key

```bash
kubectl -n gitlab create secret generic claudete-secrets --from-literal=ANTHROPIC_AUTH_TOKEN=zzz1234
```

Open [http://gitlab.uaiso.lan](https://ollama.com/settings/keys) login as root/yourpassword

Go to new issue link [http://gitlab.uaiso.lan/root/demo/-/work_items/new?type=Issue&initialCreationContext=list-route](http://gitlab.uaiso.lan/root/demo/-/work_items/new?type=Issue&initialCreationContext=list-route) 

Or you can browse to root/demo Gitlab project, work items, and create the issue.

Title: 
```
Hello World
```

Description: 
```
crie um arquivo hello.txt contendo a palavra paranguaricutirimirruaro, faça commit, push, e abra merge request 
```
