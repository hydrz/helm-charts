# EMQX

## Installing

```
helm upgrade --install emqx --namespace iot hydrz/emqx \
    --set persistence.enabled=true
```

## EMQX-EE

私有仓库

```
helm upgrade --install emqx --namespace iot hydrz/emqx \
    --set image=registry.cn-hangzhou.aliyuncs.com/hydrz/emqx:3.4.4  \
    --set imagePullPolicy=Always \
    --set imagePullSecrets=reg-aliyun-hydrz \
    --set persistence.enabled=true
```
