# ArgoCD

Why argocd? Not AI related, useful for deploying and managing applications on Kubernetes, including the AI apps.

[https://github.com/argoproj/argo-cd](https://github.com/argoproj/argo-cd)

[https://github.com/argoproj/argocd-example-apps](https://github.com/argoproj/argocd-example-apps)

[ArgoCD example](../../examples/argocd)

```bash
kubectl create namespace argocd
kubectl -n argocd apply -f https://raw.githubusercontent.com/argoproj/argo-cd/refs/tags/v3.2.5/manifests/install.yaml
```

```bash
kubectl -n argocd apply -f argocd.yaml 
```
