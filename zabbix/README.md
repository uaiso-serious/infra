create zabbix
```bash
kubectl apply -f zabbix.yaml
```

/etc/hosts file entrie to access keycloak ingress route from your local network:
```
<your-k3s-ipv4> zabbix.k3s-ia-lab.lan
```

http://zabbix.k3s-ia-lab.lan

https://www.zabbix.com/download?zabbix=7.4&os_distribution=ubuntu&os_version=24.04&components=agent_2&db=&ws=

```bash
wget https://repo.zabbix.com/zabbix/7.4/release/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.4+ubuntu24.04_all.deb
dpkg -i zabbix-release_latest_7.4+ubuntu24.04_all.deb
apt update
apt install zabbix-agent2
apt install zabbix-agent2-plugin-nvidia-gpu
```

edit config /etc/zabbix/zabbix_agent2.conf
```text
Server=0.0.0.0/0
 ```

start agent
```bash
systemctl restart zabbix-agent2
systemctl enable zabbix-agent2
```
