#!/bin/sh
kubectl -n spring create secret generic basic-auth --from-file=basic-auth
