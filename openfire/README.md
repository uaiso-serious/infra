openfire
- ip: xmpp.k3s-ia-lab.lan
- url xmpp: http://xmpp.k3s-ia-lab.lan/
- url adm: http://xmpp-adm.k3s-ia-lab.lan/
- ports: 5222 tcp/xmpp
- user: admin
- password: admin

Needs to create xmpp users, and add friends to test messaging:

using restApi plugin:

create user severino (used later in n8n xmpp node):
```bash
curl -X 'POST' \
  'http://xmpp-adm.k3s-ia-lab.lan/plugins/restapi/v1/users' \
  -H 'Authorization: secretkey123' \
  -H 'Content-Type: application/json' \
  -d '{
  "username": "severino",
  "password": "123"
}'
```

add roster entry (friend severino to admin):
```bash
curl -X 'POST' \
  'http://xmpp-adm.k3s-ia-lab.lan/plugins/restapi/v1/users/admin/roster' \
  -H 'accept: */*' \
  -H 'Authorization: secretkey123' \
  -H 'Content-Type: application/json' \
  -d '{
  "jid": "severino@xmpp.k3s-ia-lab.lan",
  "nickname": "severino",
  "subscriptionType": 1
}'
```

Openfire admin panel (clickops):
- url adm: http://xmpp-adm.k3s-ia-lab.lan/
- user: admin
- password: admin
