#!/bin/bash

# 在服务器上运行
kubectl -n kubesphere-system create secret generic kubesphere-ca \
    --from-file=ca.crt=/etc/kubernetes/pki/ca.crt \
    --from-file=ca.key=/etc/kubernetes/pki/ca.key

jwt() {
    secret=$1

    # Static header fields.
    header='{
	"alg": "HS256",
	"typ": "JWT"
}'

    # Use jq to set the dynamic `iat` and `exp`
    # fields on the header using the current time.
    # `iat` is set to now, and `exp` is now + 1 second.
    # header=$(
    # 	echo "${header}" | jq --arg time_str "$(date +%s)" \
    # 	'
    # 	($time_str | tonumber) as $time_num
    # 	| .iat=$time_num
    # 	| .exp=($time_num + 1)
    # 	'
    # )
    # openpitrix {"sub": "system","role": "global_admin","iat": 1516239022,"exp": 1816239022}
    # ks-account {"email": "admin@kubesphere.io","exp": 1816239022,"username": "admin"}
    payload=$2

    base64_encode() {
        declare input=${1:-$(</dev/stdin)}
        # Use `tr` to URL encode the output from base64.
        printf '%s' "${input}" | base64 | tr -d '\n' | tr -d '=' | tr '/+' '_-'
    }

    json() {
        declare input=${1:-$(</dev/stdin)}
        printf '%s' "${input}" | jq -c .
    }

    hmacsha256_sign() {
        declare input=${1:-$(</dev/stdin)}
        printf '%s' "${input}" | openssl sha256 -hmac "${secret}" -binary | base64 | tr -d '\n' | tr -d '=' | tr '/+' '_-'
    }

    header_base64=$(echo "${header}" | json | base64_encode)
    payload_base64=$(echo "${payload}" | json | base64_encode)

    header_payload=$(echo "${header_base64}.${payload_base64}")
    signature=$(echo "${header_payload}" | hmacsha256_sign)

    echo "${header_payload}.${signature}" | base64_encode
}

# 创建 namespace
if [ -z "$(kubectl get ns | grep 'kubesphere-system')" ]; then
    kubectl create ns kubesphere-system
fi

if [ -z "$(kubectl get ns | grep 'kubesphere-controls-system')" ]; then
    kubectl create ns kubesphere-controls-system
fi

if [ -z "$(kubectl get ns | grep 'kubesphere-monitoring-system')" ]; then
    kubectl create ns kubesphere-monitoring-system
fi

# 预配置
PWD=$(dirname $(readlink -f "$0"))
randomkey=$(dd if=/dev/urandom bs=128 count=1 2>/dev/null | base64 | tr -d "=+/" | dd bs=100 count=1 2>/dev/null | tr -d '\n')
ks_secret_str=$(jwt ${randomkey} '{"email": "admin@kubesphere.io","exp": 1816239022,"username": "admin"}')
sed -i "s/\${JWT_SECRET}/$(echo ${ks_secret_str})/g" $PWD/prepare/ks-account-init.yaml
sed -i "s/\${JWT_SECRET}/$(echo ${ks_secret_str})/g" $PWD/prepare/ks-apigateway-init.yaml
cat $PWD/prepare/ks-account-init.yaml | sed "s/\${JWT_SECRET}/$(echo ${ks_secret_str})/g"
kubectl apply -f $PWD/prepare/
sed -i "s/$(echo ${ks_secret_str})/\${JWT_SECRET}/g" $PWD/prepare/ks-account-init.yaml
sed -i "s/$(echo ${ks_secret_str})/\${JWT_SECRET}/g" $PWD/prepare/ks-apigateway-init.yaml

# 安装 ks-crds
kubectl apply -f $PWD/ks-crds/

# 安装 etcd mysql redis minio
kubectl -n kubesphere-system create secret generic mysql-pass --from-file=password.txt
kubectl apply -f $PWD/common/

# 安装 ks-core
kubectl apply -f $PWD/ks-core/

# 安装 mysql
# helm upgrade ks-mysql --namespace kubesphere-system --install hydrz/mysql-ha \
#     --set fullnameOverride=mysql

# 安装 redis
# helm upgrade ks-redis --namespace kubesphere-system --install hydrz/redis-ha \
# --set fullnameOverride=redis

# 安装 minio
# helm upgrade ks-minio --namespace kubesphere-system --install hydrz/minio-ha \
# --set fullnameOverride=minio
