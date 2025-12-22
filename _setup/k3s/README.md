# DNS considerations

the traefik ingress is configured to route *.uaiso.lan domains to the services deployed in the k3s cluster.

---

# Ssh tunnel with dynamic port forwarding

the [basic.sh](../basic.sh) script changes the system's `/etc/hosts` file to add the necessary DNS entries for the
services deployed in the K3s cluster.

Also, creates a namespace called ssh-socks5 with a deployment that runs a ssh tunnel with dynamic port forwarding on
port 1080. For that, it uses the ssh key generated during the basic.sh execution, placing the public key inside
/root/.ssh/authorized_keys.

If you don't like the idea, you can remove the line from /etc/hosts, delete the ssh-socks5 namespace and remove the ssh
key from authorized_keys.

---

# Options without the embeddded ssh tunnel strategy

## Option 1: You have control over your home network dns server

- your router allows you to add custom dns entries (like dd-wrt, openwrt, etc)
- you have a pihole or similar dns server in your home network
- you have a local dns server (bind, unbound, etc)

## Option 2: You are admin of your computer

- you can put one entrie to your computer's hosts file (/etc/hosts in linux/macos, C:\Windows\System32\drivers\etc\hosts
  in windows)

```text
<your-k3s-ipv4> n8n.uaiso.lan ollama.uaiso.lan xmpp.uaiso.lan xmpp-adm.uaiso.lan rabbitmq.uaiso.lan grafana.uaiso.lan auth.uaiso.lan ks.uaiso.lan mcp-inspector.uaiso.lan mcp-inspector-proxy.uaiso.lan onedev.uaiso.lan open-webui.uaiso.lan zabbix.uaiso.lan
```

## Option 3: Create your own ssh tunnel with dynamic port forwarding

```bash
ssh -D 1080 -N youruser@<your-k3s-ipv4>
```

Then configure your browser to use a socks5 proxy on localhost:1080

## Option 4: Use a VPN that allows custom dns entries

- create a vpn service like openvpn, wireguard, tinc, etc
- configure the vpn server to push custom dns entries for *.uaiso.lan to the clients
- connect your computer to the vpn

## Option 5: Use a proxy service that allows custom dns entries

- create a proxy service like sshuttle, squid, etc
- configure the proxy server to resolve custom dns entries for *.uaiso.lan
- configure your computer to use the proxy server

---

Probably there are more workarounds, feel free to try, it's your lab playground. You can become a DNS ninja!
