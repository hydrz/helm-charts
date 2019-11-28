# Helm Charts

[![CircleCI](https://circleci.com/gh/hydrz/helm-charts/tree/master.svg?style=svg)](https://circleci.com/gh/hydrz/helm-charts/tree/master)

## Add Repo

```
helm repo add hydrz https://hydrz.github.io/helm-charts/
helm repo add incubator http://mirror.azure.cn/kubernetes/charts-incubator/
helm repo add bitnami https://charts.bitnami.com/bitnami/

helm repo update
```

## Others

### openvpn



### cert-manager

```
helm repo add jetstack https://charts.jetstack.io
helm repo update

kubectl apply --validate=false -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.11/deploy/manifests/00-crds.yaml
kubectl create namespace cert-manager


helm upgrade --install cert-manager --namespace cert-manager --version v0.11.0 jetstack/cert-manager \
 --set prometheus.enabled=false \
 --set image.repository=quay.azk8s.cn/jetstack/cert-manager-controller \
 --set webhook.image.repository=quay.azk8s.cn/jetstack/cert-manager-webhook \
 --set cainjector.image.repository=quay.azk8s.cn/jetstack/cert-manager-cainjector \
 --set ingressShim.defaultIssuerName=letsencrypt-prod \
 --set ingressShim.defaultIssuerKind=ClusterIssuer
```

### metallb

```
cat <<-EOF | helm upgrade --install metallb --namespace metallb stable/metallb -f -
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
helm upgrade --install git --namespace ops-dev incubator/gogs \
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
helm upgrade --install nexus --namespace ops-dev stable/sonatype-nexus \
    --set nexus.service.type=ClusterIP \
    --set nexus.imageName=quay.azk8s.cn/travelaudience/docker-nexus \
    --set ingress.enabled=true \
    --set nexusProxy.env.nexusHttpHost=nexus.hydrz.cn \
    --set nexusProxy.imageName=quay.azk8s.cn/travelaudience/docker-nexus-proxy
```

### minio

```
helm upgrade --install minio --namespace default stable/minio \
 --set accessKey=minio,secretKey=miniosecret \
 --set defaultBucket.enabled=true,defaultBucket.name=default \
 --set defaultBucket.enabled=true,defaultBucket.name=default \
 --set persistence.size=1Gi
```

### openldap

```
helm upgrade --install redis --namespace default stable/redis-ha \
 --set persistentVolume.enabled=false
```

### redis-ha

```
helm upgrade --install redis --namespace default stable/redis-ha \
 --set persistentVolume.enabled=false
```

### mysql

```
helm upgrade --install mysql --namespace default bitnami/mysql \
 --set global.imageRegistry=dockerhub.azk8s.cn \
 --set root.password=root \
 --set db.name=default \
 --set replication.enabled=true \
 --set slave.replicas=1 \
 --set master.persistence.size=10Gi,slave.persistence.size=10Gi
```

### spring-cloud-data-flow

```
helm upgrade --install mysql --namespace spring bitnami/mysql \
 --set global.imageRegistry=dockerhub.azk8s.cn \
 --set image.tag=5.7.28-debian-9-r36 \
 --set root.password=root \
 --set db.name=default \
 --set replication.enabled=true \
 --set slave.replicas=1 \
 --set master.persistence.size=10Gi,slave.persistence.size=10Gi

kubectl run mysql-client --rm -it --restart='Never' --image  dockerhub.azk8s.cn/bitnami/mysql:5.7.28-debian-9-r36 --namespace spring --command -- bash
mysql -h mysql -u root -p -e 'create database dataflow;create database skipper'


# H2 org.h2.Driver
# mysql5.7 org.mariadb.jdbc.Driver
# mysql8.0 com.mysql.jdbc.Driver
# PostgreSQL org.postgresql.Driver
# SQL Server com.microsoft.sqlserver.jdbc.SQLServerDriver
# Db2 com.ibm.db2.jcc.DB2Driver
# Oracle oracle.jdbc.OracleDriver

helm upgrade --install dataflow --namespace spring stable/spring-cloud-data-flow \
  --set server.service.type=ClusterIP \
  --set server.service.externalPort=80 \
  --set skipper.service.type=ClusterIP \
  --set kafka.enabled=true,rabbitmq.enabled=false \
  --set kafka.zookeeper.service.type=ClusterIP \
  --set kafka.zookeeper.image.repository=gcr.azk8s.cn/google_samples/k8szk \
  --set mysql.enabled=false \
  --set database.driver='org.mariadb.jdbc.Driver' \
  --set database.scheme=mysql \
  --set database.host=mysql \
  --set database.port=3306 \
  --set database.user=root \
  --set database.password=root

kubectl scale deployment --replicas 0 dataflow-data-flow-server
kubectl scale deployment --replicas 1 dataflow-data-flow-server
kubectl scale deployment --replicas 0 dataflow-data-flow-skipper
kubectl scale deployment --replicas 1 dataflow-data-flow-skipper
```
