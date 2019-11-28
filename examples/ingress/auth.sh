#!/bin/sh

htpasswd -c auth hydrz
kubectl -n spring create secret generic basic-auth --from-file=auth
