# DNS considerations

the traefik ingress is configured to route *.uaiso.lan domains to the services deployed in the k3s cluster.

---

## Squid

Option 1: Use Squid Proxy

[squid](apps/squid.md)

---

## DNS server

Option 2: You have control over your home network

- your router allows you to add custom dns entries (like dd-wrt, openwrt, etc)
- you have a pihole or similar dns server in your home network
- you have a local dns server (bind, unbound, etc)

---

## SO Admin

Option 3: You are admin of your computer

- you can put one entrie to your computer's hosts file (/etc/hosts in linux/macos, C:\Windows\System32\drivers\etc\hosts
  in windows)

example:

```text
<your-k3s-ipv4> n8n.uaiso.lan ollama.uaiso.lan xmpp.uaiso.lan xmpp-adm.uaiso.lan rabbitmq.uaiso.lan grafana.uaiso.lan auth.uaiso.lan ks.uaiso.lan mcp-inspector.uaiso.lan mcp-inspector-proxy.uaiso.lan onedev.uaiso.lan open-webui.uaiso.lan zabbix.uaiso.lan
```

---

## SSH tunnel

Option 4: Create your own ssh tunnel with dynamic port forwarding

edit /etc/hosts file, example:

```text
<your-k3s-ipv4> n8n.uaiso.lan ollama.uaiso.lan xmpp.uaiso.lan xmpp-adm.uaiso.lan rabbitmq.uaiso.lan grafana.uaiso.lan auth.uaiso.lan ks.uaiso.lan mcp-inspector.uaiso.lan mcp-inspector-proxy.uaiso.lan onedev.uaiso.lan open-webui.uaiso.lan zabbix.uaiso.lan
```

ssh tunnel:

```bash
ssh -D 1080 -N youruser@<your-k3s-ipv4>
```

Then configure your browser to use a socks5 proxy on localhost:1080

---

## VPN

Option 5: Use a VPN that allows custom dns entries

- create a vpn service like openvpn, wireguard, tinc, etc
- configure the vpn server to push custom dns entries for *.uaiso.lan to the clients
- connect your computer to the vpn

---

## SOCKS5 Proxy

Option 6: SOCKS5 Proxy deployment with SSH Dynamic Port Forwarding

[ssh-socks5](apps/ssh-socks5.md)

---

## Other workarounds

Probably there are more workarounds, feel free to try, it's your lab playground. You can become a DNS ninja!
