# Helm Charts

[![CircleCI](https://circleci.com/gh/hydrz/helm-charts/tree/master.svg?style=svg)](https://circleci.com/gh/hydrz/helm-charts/tree/master)

## Add Repo

```
helm repo add hydrz https://hydrz.github.io/helm-charts/
helm repo update
```

## Others

### metallb

```
helm delete metallb --purge
cat <<-EOF | helm install --name metallb --namespace metallb stable/metallb -f -
configInline:
  address-pools:
  - name: default
    protocol: layer2
    addresses:
    - 172.16.240.0/24
EOF
```

### spring-cloud-data-flow

```
helm delete dataflow --purge
helm install --name dataflow --namespace dataflow stable/spring-cloud-data-flow \
  --set skipper.service.type=LoadBalancer \
  --set rabbitmq.enabled=false \
  --set kafka.enabled=true \
  --set kafka.external.enabled=true \
  --set kafka.external.type=LoadBalancer \
  --set kafka.external.firstListenerPort=9092 \
  --set kafka.zookeeper.service.type=LoadBalancer \
  --set kafka.zookeeper.image.repository=gcr.azk8s.cn/google_samples/k8szk
```
