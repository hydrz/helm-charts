#!/bin/sh
kubectl -n spring-cloud create secret generic basic-auth --from-file=basic-auth
