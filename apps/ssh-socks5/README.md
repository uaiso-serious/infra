# Ssh-socks5

Why ssh-socks5? Not AI related, useful for tunneling for debug and dns workaround.

Script changes the system's `/etc/hosts` file to add the necessary DNS entries for the services deployed in the K3s
cluster.

Creates a namespace called ssh-socks5 with a deployment that runs a ssh tunnel with dynamic port forwarding on
port 1080. For that, it uses the ssh key generated during the basic.sh execution, placing the public key inside
/root/.ssh/authorized_keys.

```bash
HOST_IP=$(hostname -I | awk '{print $1}')

echo "
$HOST_IP n8n.uaiso.lan \
ollama.uaiso.lan \
xmpp.uaiso.lan \
xmpp-adm.uaiso.lan \
rabbitmq.uaiso.lan \
grafana.uaiso.lan \
auth.uaiso.lan \
ks.uaiso.lan \
mcp-inspector.uaiso.lan \
mcp-inspector-proxy.uaiso.lan \
onedev.uaiso.lan \
open-webui.uaiso.lan \
zabbix.uaiso.lan" >> /etc/hosts

echo "y" | ssh-keygen -t ed25519 -C "openssh docker image public ed25519 uaiso-key" -f /root/.ssh/uaiso-key -q -N ""
cat /root/.ssh/uaiso-key.pub >> /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys
kubectl create ns ssh-socks5
kubectl create secret generic ssh-key-secret --from-file=ed25519=/root/.ssh/uaiso-key --namespace=ssh-socks5

sed -i "s/127\.0\.0\.1/$HOST_IP/g" ssh-socks5.yaml
kubectl apply -f ssh-socks5.yaml
```