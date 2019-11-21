# OpenEBS

## Installing/Uninstall

```
helm delete openebs --purge
helm install --name=openebs --namespace openebs hydrz/openebs
```

## Configuration

The following table lists the configurable parameters of the OpenEBS chart and their default values.

| Parameter                     | Description                                  | Default                                                  |
| ----------------------------- | -------------------------------------------- | -------------------------------------------------------- |
| `rbac.create`                 | Enable RBAC Resources                        | `true`                                                   |
| `image.pullPolicy`            | Container pull policy                        | `IfNotPresent`                                           |
| `storageClass.create`         | Create StorageClass                          | `true`                                                   |
| `storageClass.name`           | StorageClass Name                            | `openebs`                                                |
| `storageClass.isDefaultClass` | Is Default StorageClass                      | `true`                                                   |
| `storageClass.basePath`       | HostPath                                     | `/var/openebs/local/`                                    |
| `storageClass.reclaimPolicy`  | StorageClass reclaimPolicy                   | `Delete`                                                 |
| `localprovisioner.enabled`    | Enable localProvisioner                      | `true`                                                   |
| `localprovisioner.image`      | Image for localProvisioner                   | `quay-mirror.qiniu.com/openebs/provisioner-localpv`      |
| `localprovisioner.imageTag`   | Image Tag for localProvisioner               | `1.4.0`                                                  |
| `localprovisioner.replicas`   | Number of localProvisioner Replicas          | `1`                                                      |
| `localprovisioner.basePath`   | BasePath for hostPath volumes on Nodes       | `/var/openebs/local`                                     |
| `ndm.enabled`                 | Enable Node Disk Manager                     | `true`                                                   |
| `ndm.image`                   | Image for Node Disk Manager                  | `quay-mirror.qiniu.com/openebs/node-disk-manager-amd64`  |
| `ndm.imageTag`                | Image Tag for Node Disk Manager              | `v0.4.4`                                                 |
| `ndm.sparse.path`             | Directory where Sparse files are created     | `/var/openebs/sparse`                                    |
| `ndm.sparse.size`             | Size of the sparse file in bytes             | `10737418240`                                            |
| `ndm.sparse.count`            | Number of sparse files to be created         | `0`                                                      |
| `ndm.filters.excludeVendors`  | Exclude devices with specified vendor        | `CLOUDBYT,OpenEBS`                                       |
| `ndm.filters.includePaths`    | Include devices with specified path patterns | `""`                                                     |
| `ndm.filters.excludePaths`    | Exclude devices with specified path patterns | `loop,/dev/fd0,/dev/sr0,/dev/ram,/dev/dm-,/dev/md`       |
| `ndm.probes.enableSeachest`   | Enable Seachest probe for NDM                | `false`                                                  |
| `ndmOperator.enabled`         | Enable NDM Operator                          | `true`                                                   |
| `ndmOperator.image`           | Image for NDM Operator                       | `quay-mirror.qiniu.com/openebs/node-disk-operator-amd64` |
| `ndmOperator.imageTag`        | Image Tag for NDM Operator                   | `v0.4.4`                                                 |
| `analytics.enabled`           | Enable sending stats to Google Analytics     | `true`                                                   |
| `analytics.pingInterval`      | Duration(hours) between sending ping stat    | `24h`                                                    |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```shell
helm install --name openebs -f values.yaml stable/openebs
```

> **Tip**: You can use the default [values.yaml](values.yaml)
