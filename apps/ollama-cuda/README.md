# Ollama Cuda

Why ollama? Easy to use Local LLMs.

[https://github.com/ollama/ollama](https://github.com/ollama/ollama)

- http ingress: [http://ollama.uaiso.lan](http://ollama.uaiso.lan)

---

ollama:

- url: http://ollama-service.ollama.svc.cluster.local:11434 (k8s internal)
- http ingress: [http://ollama.uaiso.lan](http://ollama.uaiso.lan)
- no apikey

---

requirements:

- Ollama gpu list: [https://docs.ollama.com/gpu](https://docs.ollama.com/gpu)
- [nvidia instructions](../_setup/baremetal/README.md)

Deploy ollama with cuda support:
```bash
kubectl apply -f ollama-cuda.yaml
```

Choose your model by size to fit your gpu vram:

[https://uaiso-serious.github.io/ollama-helper/](https://uaiso-serious.github.io/ollama-helper/)

Example: pull the llama3.2 3b model:

```bash
kubectl -n ollama exec ollama-0 -- bash -c "ollama pull llama3.2:3b"
```
