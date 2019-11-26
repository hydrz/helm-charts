#!/bin/bash
set -e

: ${VERSION="1.9.0"}

if [ -z "$VERSION" ] && [ $# -lt 1 ]; then
    echo "Usage: $0 <VERSION>"
    exit
fi

if [ -z "$VERSION" ]; then
    VERSION=$1
fi

: ${API_TOKEN:=""}
: ${IMAGE_REPO:=""}

URL=https://network.pivotal.io/api/v2
PRODUCT=greenplum-for-kubernetes

get_release_id() {
    local RELEASE_ID=""
    RELEASES_URL=$URL/products/$PRODUCT/releases

    releases=$(curl -sL ${RELEASES_URL})
    while read release; do
        TEMP_VERSION=$(echo "${release}" | jq -r '.version')
        if [ "$TEMP_VERSION" = "$VERSION" ]; then
            RELEASE_ID=$(echo "${release}" | jq -r '.id')
        fi
    done < <(echo "${releases}" | jq -c -r '.releases[]')

    if [ -z "${RELEASE_ID}" ]; then
        echo "Not found the version: ${VERSION}"
        exit 1
    fi

    echo $RELEASE_ID
}

get_download_url() {
    local DOWNLOAD_URL=""
    RELEASE_ID=$1
    PRODUCT_FILES_URL=$URL/products/$PRODUCT/releases/$RELEASE_ID/product_files
    products=$(curl -sL $PRODUCT_FILES_URL)
    while read product; do
        if [ $(echo "${product}" | jq -r '.aws_object_key' | grep '.tar.gz') ]; then
            DOWNLOAD_URL=$(echo "${product}" | jq -r '._links.download.href')
            break
        fi
    done < <(echo "${products}" | jq -c -r '.product_files[]')

    if [ -z "${DOWNLOAD_URL}" ]; then
        echo "Error get file download url."
        exit 1
    fi

    echo $DOWNLOAD_URL
}

accept_eula() {
    RELEASE_ID=$1
    EULA_URL=$URL/products/$PRODUCT/releases/$RELEASE_ID/eula_acceptance
    echo $(curl -X 'POST' -H "Authorization: Token ${API_TOKEN}" ${EULA_URL})
}

pipeline_script() {
    TMP_ROOT="$(mktemp -dt greenplum-XXXXXX)"
    cd $TMP_ROOT

    RELEASE_ID=$(get_release_id)
    DOWNLOAD_URL=$(get_download_url $RELEASE_ID)

    # accept_eula $RELEASE_ID

    echo ${DOWNLOAD_URL}

    wget -O "${PRODUCT}-v${VERSION}.tar.zg" --header="Authorization: Token ${API_TOKEN}" $DOWNLOAD_URL
    tar xzf ${PRODUCT}-v${VERSION}.tar.zg
    cd ./greenplum-for-kubernetes-v${VERSION}

    IMAGE_REPO=registry.cn-hangzhou.aliyuncs.com/hydrz

    docker load -i ./images/greenplum-for-kubernetes
    docker load -i ./images/greenplum-operator

    GREENPLUM_IMAGE_NAME="${IMAGE_REPO}/greenplum-for-kubernetes:$(cat ./images/greenplum-for-kubernetes-tag)"
    docker tag $(cat ./images/greenplum-for-kubernetes-id) ${GREENPLUM_IMAGE_NAME}
    docker push ${GREENPLUM_IMAGE_NAME}

    OPERATOR_IMAGE_NAME="${IMAGE_REPO}/greenplum-operator:$(cat ./images/greenplum-operator-tag)"
    docker tag $(cat ./images/greenplum-operator-id) ${OPERATOR_IMAGE_NAME}
    docker push ${OPERATOR_IMAGE_NAME}
}

pipeline_script
