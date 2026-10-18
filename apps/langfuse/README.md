# Langfuse

Why Langfuse? To see what the ai agents are doing, and how they are wasting tokens with LLM providers.

[https://langfuse.com/self-hosting/deployment/kubernetes-helm](https://langfuse.com/self-hosting/deployment/kubernetes-helm)

- http ingress: [http://langfuse.uaiso.lan](http://langfuse.uaiso.lan)

```bash
helm install \
  cert-manager oci://quay.io/jetstack/charts/cert-manager \
  --version v1.20.2 \
  --namespace cert-manager \
  --create-namespace \
  --set crds.enabled=true

kubectl wait --for=condition=Established \
  crd/certificates.cert-manager.io \
  crd/issuers.cert-manager.io \
  --timeout=120s
```

```bash
helm install clickhouse-operator oci://ghcr.io/clickhouse/clickhouse-operator-helm \
  --version 0.0.8 \
  --namespace clickhouse-operator --create-namespace
  
kubectl wait --for=condition=Established \
crd/clickhouseclusters.clickhouse.com \
crd/keeperclusters.clickhouse.com \
--timeout=120s
```

```bash 
helm repo add langfuse https://langfuse.github.io/langfuse-k8s
helm repo update
```

```bash
helm upgrade --create-namespace -n langfuse --install langfuse langfuse/langfuse -n langfuse --values values.yaml --version 2.1.5
```
