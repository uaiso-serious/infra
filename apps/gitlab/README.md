# Gitlab

Why Gitlab? Bunch of AI features to explore.

[https://docs.gitlab.com/charts/](https://docs.gitlab.com/charts/)

- http ingress: [http://gitlab.uaiso.lan/](https://docs.gitlab.com/charts/)
- user: root
- password: yourpassword

---

## Installation

edit values.yaml:

```
global.hosts.externalIp: <your-ip>
```

create namespace, secrets, pgsql, valkey

```bash
kubectl create ns gitlab
kubectl -n gitlab create secret generic postgresql --from-literal=password=mysecurepassword
kubectl -n gitlab create secret generic s3cmd-config --from-file=base/s3cfg
kubectl -n gitlab create secret generic gitlab-initial-root-passwd --from-literal=password=yourpassword
kubectl -n gitlab apply -f base/pgsql18.yaml
kubectl -n gitlab apply -f base/valkey.yaml
```

run helm chart

```bash
helm upgrade --install gitlab gitlab/gitlab \
  -n gitlab --create-namespace \
  --values values.yaml \
  --version 10.4.1
```
