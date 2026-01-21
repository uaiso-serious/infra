```bash
echo $(kubectl get secret --namespace code code-code-server -o jsonpath="{.data.password}" | base64 --decode)
```
