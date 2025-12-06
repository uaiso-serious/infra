Create databases
```bash
kubectl exec -it postgres-0 -- bash -c "echo 'create database openwebui;' | psql -U postgres"
kubectl exec -it postgres-0 -- bash -c "echo 'create database keycloak;' | psql -U postgres"
```
