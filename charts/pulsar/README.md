## Deploy Pulsar

#### Install Pulsar Chart

```
helm upgrade --install pulsar --namespace pulsar hydrz/pulsar \
--set zookeeper.replicaCount=2,bookkeeper.replicaCount=2
```
