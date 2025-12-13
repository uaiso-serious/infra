n8n:
- url: http://n8n.k3s-ia-lab.lan/
- volume mount /mnt/data/n8n

# Import initial setup and restart n8n pod:
```bash
kubectl -n k3s-ia-lab exec n8n-0 -- ash -c "git clone https://github.com/k3s-ia-lab/infra.git /tmp/infra"
kubectl -n k3s-ia-lab exec n8n-0 -- ash -c "n8n import:entities --truncateTables --inputDir=/tmp/infra/n8n/entities --keyFile=/tmp/infra/n8n/keyfile.txt"
kubectl -n k3s-ia-lab exec n8n-0 -- ash -c "cd .n8n/nodes;npm i n8n-nodes-xmpp@1.0.121"
kubectl -n k3s-ia-lab exec n8n-0 -- ash -c "n8n import:credentials --separate --input=/tmp/infra/n8n/credentials"
kubectl -n k3s-ia-lab exec n8n-0 -- ash -c "n8n import:workflow --separate --input=/tmp/infra/n8n/workflows"
kubectl -n k3s-ia-lab delete pod n8n-0
```

---

http://n8n.k3s-ia-lab.lan/

- email: admin@k3s-ia-lab.lan
- password: Admin123
