create mcp-inspector
```bash
kubectl apply -f mcp-inspector.yaml
```

/etc/hosts file entrie to access keycloak ingress route from your local network:
```
<your-k3s-ipv4> mcp-inspector.k3s-ia-lab.lan mcp-inspector-proxy.k3s-ia-lab.lan
```

mcp inspector:
- url http://mcp-inspector.k3s-ia-lab.lan
