Connection details postgresql:
- dns host: postgresql.postgresql.svc.cluster.local (k8s internal)
- ip &lt;your-k3s-ipv4&gt;
- port: 5432
- user: postgres
- password: mysecurepassword

---

yaml option with pgvector extension:

```bash
kubectl apply -f pgvector.yaml
kubectl rollout status statefulset/postgres -n postgresql
```

---
helmchart option (without pgvector extension):
https://github.com/bitnami/charts/blob/main/bitnami/postgresql/README.md

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm upgrade --install postgresql bitnami/postgresql \
  --namespace postgresql \
  --create-namespace \
  --wait \
  --version 18.1.14 \
  --values values.yaml
```
