# Helm Charts

[![CircleCI](https://circleci.com/gh/hydrz/helm-charts/tree/master.svg?style=svg)](https://circleci.com/gh/hydrz/helm-charts/tree/master)

## Add Repo

```
helm repo add hydrz https://hydrz.github.io/helm-charts/
helm repo update
```

## Others

### cert-manager

```
helm repo add jetstack https://charts.jetstack.io
helm repo update

kubectl apply --validate=false -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.11/deploy/manifests/00-crds.yaml
kubectl create namespace cert-manager

helm delete cert-manager --purge
helm install --name cert-manager --namespace cert-manager --version v0.11.0 jetstack/cert-manager \
 --set prometheus.enabled=false \
 --set image.repository=quay.azk8s.cn/jetstack/cert-manager-controller \
 --set webhook.image.repository=quay.azk8s.cn/jetstack/cert-manager-webhook \
 --set cainjector.image.repository=quay.azk8s.cn/jetstack/cert-manager-cainjector \
 --set ingressShim.defaultIssuerName=letsencrypt-prod \
 --set ingressShim.defaultIssuerKind=ClusterIssuer
```

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

### gogs

```
helm delete gogs --purge
helm install --name git --namespace ops-dev incubator/gogs \
    --set serviceType=ClusterIP \
    --set service.ingress.enabled=true \
    --set "service.ingress.hosts[0]"=git.hydrz.cn \
    --set "service.ingress.tls[0].secretName"=gogs-tls \
    --set "service.ingress.tls[0].hosts[0]"=git.hydrz.cn \
    --set service.sshDomain=git.hydrz.cn \
    --set service.gogs.serverDomain=git.hydrz.cn \
    --set service.gogs.serverRootUrl=http://git.hydrz.cn/ \
    --set service.gogs.serverLandingPage=explore \
    --set service.gogs.securitySecretKey=css0929 \
    --set persistence.size=10Gi
```

### nexus

```
helm delete nexus --purge
helm install --name nexus --namespace ops-dev stable/sonatype-nexus \
    --set nexus.service.type=ClusterIP \
    --set nexus.imageName=quay.azk8s.cn/travelaudience/docker-nexus \
    --set ingress.enabled=true \
    --set nexusProxy.env.nexusHttpHost=nexus.hydrz.cn \
    --set nexusProxy.imageName=quay.azk8s.cn/travelaudience/docker-nexus-proxy
```

### spring-cloud-data-flow

```
helm delete dataflow --purge
helm install --name dataflow --namespace spring-cloud stable/spring-cloud-data-flow \
  --set server.service.type=ClusterIP \
  --set skipper.service.type=ClusterIP \
  --set kafka.enabled=true,rabbitmq.enabled=false \
  --set kafka.external.enabled=true \
  --set kafka.external.type=ClusterIP \
  --set kafka.external.firstListenerPort=9092 \
  --set kafka.zookeeper.service.type=ClusterIP \
  --set kafka.zookeeper.image.repository=gcr.azk8s.cn/google_samples/k8szk
```
