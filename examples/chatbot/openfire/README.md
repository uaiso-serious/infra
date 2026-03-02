openfire

- ip: &lt;your-k3s-ipv4&gt;
- url xmpp: http://xmpp.uaiso.lan/
- url adm: http://xmpp-adm.uaiso.lan/
- port: 5222 tcp/xmpp
- user: admin
- password: admin

using restApi plugin:

readiness check:

```bash
curl 'http://xmpp-adm.uaiso.lan/plugins/restapi/v1/system/readiness' -v
```

create user example mybot:

```bash
curl \
  'http://xmpp-adm.uaiso.lan/plugins/restapi/v1/users' \
  -H 'Authorization: secretkey123' \
  -H 'Content-Type: application/json' \
  -d '{"username": "mybot","password": "123"}'
```

add roster entry (friend mybot to admin):

```bash
curl \
  'http://xmpp-adm.uaiso.lan/plugins/restapi/v1/users/admin/roster' \
  -H 'accept: */*' \
  -H 'Authorization: secretkey123' \
  -H 'Content-Type: application/json' \
  -d '{"jid": "mybot@xmpp.uaiso.lan","nickname": "mybot","subscriptionType": 1}'
```

Openfire admin panel (clickops):

- url adm: http://xmpp-adm.uaiso.lan/
- user: admin
- password: admin
