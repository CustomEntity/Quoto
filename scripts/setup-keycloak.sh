#!/bin/bash

KEYCLOAK_URL="http://localhost:8080/"
REALM="master"
USERNAME="master"
PASSWORD="master"
CLIENT_ID="admin-cli"

echo "Setting up Keycloak..."

export KCADM_CONFIG=/tmp/kcadm.config

/opt/bitnami/scripts/keycloak/run.sh &

until $(curl --output /dev/null --silent --head --fail $KEYCLOAK_URL); do
    printf '.'
    sleep 5
done

echo "Keycloak is ready! Setting up..."

kcadm.sh create realms -s realm=quoto -s enabled=true --server $KEYCLOAK_URL --realm $REALM --user $USERNAME --password $PASSWORD --client $CLIENT_ID

kcadm.sh create clients -r quoto -s clientId=newclient -s 'redirectUris=["*"]' --server $KEYCLOAK_URL --realm $REALM --user $USERNAME --password $PASSWORD --client $CLIENT_ID

kcadm.sh create users -r quoto -s username=quoto_admin -s enabled=true --server $KEYCLOAK_URL --realm $REALM --user $USERNAME --password $PASSWORD --client $CLIENT_ID

kcadm.sh set-password -r quoto --username quoto_admin --new-password newpassword --server $KEYCLOAK_URL --realm $REALM --user $USERNAME --password $PASSWORD --client $CLIENT_ID

tail -f /dev/null