ollama:

- url: http://ollama-service.ollama.svc.cluster.local:11434 (k8s internal)
- http ingress: http://ollama.uaiso.lan
- no apikey
---

Tool to look models by size:

https://uaiso-serious.github.io/ollama-helper/

---

# Don't have Nvidia GPU?

The cpu version will be very slow for inference, and the yaml ram resource is limited to 1Gi to avoid ram leak
and crashes.

Alternatively, you can try ollama cloud https://docs.ollama.com/cloud.

Create account, follow the instructions.

Enter pod and login:

```bash
kubectl -n ollama exec -it ollama-0 -- bash 
```

Call login command:

```text
ollama signin
```

follow the instructions to login ollama cloud.

try small model, bigger models will eat tokens/quota very fast:

```bash
ollama pull ministral-3:3b-cloud
```

available cloud models:

https://ollama.com/search?c=cloud

---

# If you have Nvidia GPU

requirements:

- Ollama gpu list: https://docs.ollama.com/gpu
- [nvidia instructions](../_setup/baremetal/README.md)

Deploy ollama with gpu support:
```bash
kubectl apply -f ollama-with-gpu.yaml
```

Choose your model by size to fit your gpu vram:

https://uaiso-serious.github.io/ollama-helper/

Example: pull the llama3.2 3b model:

```bash
kubectl -n ollama exec ollama-0 -- bash -c "ollama pull llama3.2:3b"
```
