## Deploy Pulsar

#### Install Pulsar Chart

```
helm upgrade --install pulsar --namespace pulsar hydrz/pulsar \
--set namespace=pulsar \
--set proxy.service.type=ClusterIP
```
