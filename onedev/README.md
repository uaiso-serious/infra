https://docs.onedev.io/installation-guide/deploy-to-k8s

```bash
kubectl exec -n postgresql postgres-0 -- bash -c "echo 'create database onedev;' | psql -U postgres"
helm repo add onedev https://code.onedev.io/onedev/~helm
helm repo update onedev
helm install onedev onedev/onedev -n onedev --create-namespace --values values.yaml
```

/etc/hosts file entrie to access keycloak ingress route from your local network:
```
<your-k3s-ipv4> onedev.k3s-ia-lab.lan
```

http://onedev.k3s-ia-lab.lan
