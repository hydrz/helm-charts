#!/bin/bash

source $(dirname $(readlink -f "$0"))/env.sh

helm delete ${HELM_RELEASE} --purge
helm install --name ${HELM_RELEASE} --namespace ${NAMESPACE} stable/openvpn \
    --set service.type=ClusterIP \
    --set service.externalPort=1194 \
    --set service.internalPort=1194 \
    --set openvpn.redirectGateway=false \
    --set openvpn.OVPN_NETWORK=${OVPN_NETWORK},openvpn.OVPN_SUBNET=${OVPN_SUBNET} \
    --set openvpn.OVPN_K8S_POD_NETWORK=${OVPN_K8S_POD_NETWORK},openvpn.OVPN_K8S_POD_SUBNET=${OVPN_K8S_POD_NETWORK} \
    --set openvpn.OVPN_K8S_SVC_NETWORK=${OVPN_K8S_SVC_NETWORK},openvpn.OVPN_K8S_SVC_SUBNET=${OVPN_K8S_SVC_SUBNET}
