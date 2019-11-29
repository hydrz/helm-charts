## Deploy Pulsar

#### Install Pulsar Chart

```
helm upgrade --install --name=pulsar --namespace pulsar hydrz/pulsar \
--set namespace=pulsar \
--set proxy.service.type=ClusterIP
```
