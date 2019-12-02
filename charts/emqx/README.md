# EMQX

## Installing

```
helm upgrade --install emqx --namespace iot hydrz/emqx \
    --set persistence.enabled=true
```

## EMQX-EE

私有仓库

```
helm upgrade --install --devel emqx --namespace iot hydrz/emqx \
    --set image=registry.cn-hangzhou.aliyuncs.com/hydrz/emqx:3.4.4  \
    --set imagePullPolicy=IfNotPresent \
    --set imagePullSecrets=reg-aliyun-hydrz \
    --set persistence.enabled=true \
    --set replicas=2 \
    --set emqxAddressType=hostname
```
