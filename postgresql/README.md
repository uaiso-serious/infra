Create databases
```bash
kubectl exec -n k3s-ia-lab postgres-0 -- bash -c "echo 'create database openwebui;' | psql -U postgres"
kubectl exec -n k3s-ia-lab postgres-0 -- bash -c "echo 'create database openwebuipgvector;' | psql -U postgres"
kubectl exec -n k3s-ia-lab postgres-0 -- bash -c "echo 'create database keycloak;' | psql -U postgres"
kubectl exec -n k3s-ia-lab postgres-0 -- bash -c "echo 'create database n8n;' | psql -U postgres"
```
