#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: $0 <CLIENT_KEY_NAME> <HOST>"
    exit
fi

: ${NAMESPACE:="openvpn"}
: ${HELM_RELEASE="openvpn"}

HOST=$2

POD_NAME=$(kubectl get pods -n "$NAMESPACE" -l "app=openvpn,release=$HELM_RELEASE" -o jsonpath='{.items[0].metadata.name}')
kubectl -n "$NAMESPACE" exec -it "$POD_NAME" /etc/openvpn/setup/newClientCert.sh "$KEY_NAME" "$HOST"
kubectl -n "$NAMESPACE" exec -it "$POD_NAME" cat "/etc/openvpn/certs/pki/$KEY_NAME.ovpn" >"$KEY_NAME.ovpn"
