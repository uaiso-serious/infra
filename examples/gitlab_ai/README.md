
```bash
git clone https://github.com/uaiso-serious/infra.git
./infra/_setup/k3s/k3s.sh
./infra/_setup/helm.sh
./infra/examples/gitlab_ai/gitlab_ai.sh
```

```bash
./install.sh
```

```bash
kubectl -n gitlab create secret generic claudete-secrets --from-literal=ANTHROPIC_AUTH_TOKEN=zzz1234
```

crie um arquivo hello.txt contendo a palavra paranguaricutirimirruaro, faça commit, push, e abra merge request
