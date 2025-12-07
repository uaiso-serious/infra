https://docs.onedev.io/installation-guide/deploy-to-k8s

```bash
kubectl exec -n k3s-ia-lab postgres-0 -- bash -c "echo 'create database onedev;' | psql -U postgres"
helm repo add onedev https://code.onedev.io/onedev/~helm
helm repo update onedev
helm install onedev onedev/onedev -n onedev --create-namespace --values values.yaml
```

http://onedev.k3s-ia-lab.lan
