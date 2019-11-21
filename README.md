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
