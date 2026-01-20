rabbitmq:
- dns: rabbitmq-lb.rabbitmq.svc.cluster.local (k8s internal)
- port: 5672 tcp/ampq
- url management: http://rabbitmq.uaiso.lan
- user: user
- password: password
- vhost: /

```bash
kubectl apply -f rabbitmq.yaml
```
