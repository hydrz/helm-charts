# EMQX

## Installing

```
helm upgrade --install emqx --namespace iot hydrz/emqx \
    --set persistence.enabled=true \
    --set ingress.enabled=true \
    --set "ingress.annotations[].kubernetes.io/tls-acme"=true \
    --set ingress.hosts=emqx.hydrz.cn \
    --set "ingress.tls[].secretName"=emqx-tls \
    --set "ingress.tls[].hosts"=emqx.hydrz.cn
```
