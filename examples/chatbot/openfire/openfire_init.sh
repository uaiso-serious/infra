#!/bin/bash

ofproperty () {
  key=$1
  value=$2
  curl -s \
    'http://localhost:9090/plugins/restapi/v1/system/properties' \
    -H 'accept: */*' \
    -H 'Authorization: secretkey123' \
    -H 'Content-Type: application/json' \
    -d "{\"key\": \"${key}\", \"value\": \"${value}\"}"
}
ofproperty 'xmppweb.config.transports.websocket' 'ws://xmpp.uaiso.lan/ws/'
ofproperty 'plugin.subscription.level' 'all'
ofproperty 'plugin.subscription.type' 'accept'
ofproperty 'sasl.mechs.00001' 'PLAIN'
ofproperty 'xmpp.client.tls.policy' 'disabled'
curl -s \
  'http://localhost:9090/plugins/restapi/v1/users' \
  -H 'Authorization: secretkey123' \
  -H 'Content-Type: application/json' \
  -d '{"username": "severino","password": "123"}'
curl -s \
  'http://localhost:9090/plugins/restapi/v1/users/admin/roster' \
  -H 'accept: */*' \
  -H 'Authorization: secretkey123' \
  -H 'Content-Type: application/json' \
  -d '{"jid": "severino@xmpp.uaiso.lan","nickname": "severino","subscriptionType": 1}'
