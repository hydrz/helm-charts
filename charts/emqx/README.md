# EMQX

## Installing

```
helm upgrade --install emqx --namespace iot hydrz/emqx \
    --set persistence.enabled=true \
    --set ingress.enabled=true \
    --set ingress.hosts=emqx.hydrz.cn
```
