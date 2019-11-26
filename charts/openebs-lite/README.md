# OpenEBS

## Installing/Uninstall

```
helm upgrade --install --name=openebs --namespace openebs-system hydrz/openebs-lite \
    --set storageClass.isDefaultClass=true \
    --set ndm.nodeSelector."node-role\.kubernetes\.io\/master"= \
    --set localprovisioner.nodeSelector."node-role\.kubernetes\.io\/master"= \
    --set ndmOperator.nodeSelector."node-role\.kubernetes\.io\/master"=
```

## Configuration

| Parameter                  | Description | Default  |
| -------------------------- | ----------- | -------- |
| `operatorImageRepository`  | Image       | ``       |
| `operatorImageTag`         | Image       | `v1.9.0` |
| `greenplumImageRepository` | Image       | ``       |
| `greenplumImageTag`        | Image       | `v1.9.0` |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.
