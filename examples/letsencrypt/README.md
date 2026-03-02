# Let's encrypt

https://dev.to/ileriayo/adding-free-ssltls-on-kubernetes-using-certmanager-and-letsencrypt-a1l

https://notthebe.ee/blog/easy-ssl-in-homelab-dns01/

https://letsencrypt.org/docs/challenge-types/

```bash
wget https://github.com/cert-manager/cert-manager/releases/download/v1.19.2/cert-manager.yaml
kubectl apply -f cert-manager.yaml
```

change youremail@example.com inside clusterissuer.yaml then deploy

```bash
kubectl apply -f clusterissuer.yaml
```

change example.com inside letsencrypt.yaml then deploy

```bash
kubectl apply -f letsencrypt.yaml
```
