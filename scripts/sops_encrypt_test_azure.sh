#!/bin/bash

# copy and edit ./scripts/sops_env.sh somewhere private
# and use to set your environment

if [ ! -d ./scripts ]; then
    echo please run from the root of the repository
    exit 1
fi

if [ ! -f ./.sops.yaml ]; then
    echo please run from the root of the repository
    exit 1
fi

if [ -z $SECRET_LOKI_SA_ACCESS_KEY ]; then
   echo please set SECRET_LOKI_SA_ACCESS_KEY as an environment variable
   exit 2
fi

if [ -z $SECRET_TEMPO_SA_ACCESS_KEY ]; then
   echo please set SECRET_TEMPO_SA_ACCESS_KEY as an environment variable
   exit 3
fi

KV_IDMZ_URL=$(az keyvault key show --name sops-key --vault-name $KVNAME_IDMZ --query key.kid -o tsv)
if [ -z $KV_IDMZ_URL ]; then 
   echo please set KVNAME_IDMZ as an environment variable
fi

KV_EDMZ_URL=$(az keyvault key show --name sops-key --vault-name $KVNAME_EDMZ --query key.kid -o tsv)
if [ -z $KV_EDMZ_URL ]; then 
   echo please set KVNAME_EDMZ as an environment variable
fi

echo kv_idmz=${KV_IDMZ_URL}
echo kv_edmz=${KV_EDMZ_URL}

#########################################
# Function definition
#########################################
generateEncryptedSecretFile2Values() {

    echo "processing $NAME:"

    if [ -z $SECRET_NAME ]; then
        SECRET_NAME=${NAME}
    fi
    
    VALUES_FILE=${TMPDIR}/${NAME}-values.yaml
    ENCRYPTED_FILE=${TMPDIR}/${NAME}-values.enc.yaml

    kubectl create secret generic ${VALUE} \
        -n $NAMESPACE \
        --from-literal $SECRET1 \
        --from-literal $SECRET2 \
        -o yaml \
        --dry-run=client > ${VALUES_FILE}

    sops --encrypt --azure-kv ${KV} ${VALUES_FILE} > ${ENCRYPTED_FILE}

    cp ${ENCRYPTED_FILE} ${SECRET_PATH}/${SECRET_NAME}-secret.yaml

    # must unset for next invocation
    unset SECRET_NAME
    
    # rm ${VALUES_FILE} ${ENCRYPTED_FILE}
}

################################################
# Loki azure storage account access key
################################################
NAME=loki
NAMESPACE=loki
SECRET_PATH=./apps-loki/test-azure-loki/loki
KV=${KV_IDMZ_URL}
VALUE=loki-az-sa-access-key
SECRET1="sa-account-name=${LOKI_SA_NAME}"
SECRET2="sa-access-key=${SECRET_LOKI_SA_ACCESS_KEY}"
generateEncryptedSecretFile2Values

################################################
# Tempo azure storage account access key
################################################
NAME=tempo
NAMESPACE=tempo
SECRET_PATH=./apps-tempo/test-azure-apps/tempo
KV=${KV_IDMZ_URL}
VALUE=tempo-az-sa-access-key
SECRET1="sa-account-name=${TEMPO_SA_NAME}"
SECRET2="sa-access-key=${SECRET_TEMPO_SA_ACCESS_KEY}"
generateEncryptedSecretFile2Values

################################################
# Mimir azure storage account access key
################################################
CLUSTER=test-azure-apps
NAME=mimir
NAMESPACE=mimir
SECRET_PATH=./apps-${NAME}/${CLUSTER}/${NAME}
KV=${KV_IDMZ_URL}
VALUE=mimir-az-sa-access-key
SECRET1="sa-account-name=${MIMIR_SA_NAME}"
SECRET2="sa-access-key=${SECRET_MIMIR_SA_ACCESS_KEY}"
generateEncryptedSecretFile2Values

################################################
# Phlare
################################################
echo NOTE: Phlare is expected to fail as it is disabled:
echo NOTE: Phlare project is being replaced shortly
CLUSTER=test-azure-apps
NAME=phlare
NAMESPACE=phlare
SECRET_PATH=./apps/${CLUSTER}/${NAME}
KV=${KV_IDMZ_URL}
VALUE=phlare-az-sa-access-key
SECRET1="sa-account-name=${PHLARE_SA_NAME}"
SECRET2="sa-access-key=${SECRET_PHLARE_SA_ACCESS_KEY}"
generateEncryptedSecretFile2Values

################################################
echo Grafana apps
################################################
CLUSTER=test-azure-apps
NAME=grafana
SECRET_PATH=./apps-grafana/${CLUSTER}/${NAME}
KV=${KV_IDMZ_URL}
NAMESPACE=grafana
VALUE=grafana-admin-details
SECRET1="adminUser=admin"
SECRET2="adminPassword=${SECRET_GRAFANA_ADMIN_PASSWORD}"
generateEncryptedSecretFile2Values

CLUSTER=test-azure-apps
NAME=grafana
SECRET_PATH=./apps-grafana/${CLUSTER}/${NAME}
KV=${KV_IDMZ_URL}
NAMESPACE=grafana
VALUE=grafana-auth-env
SECRET_NAME=grafana-auth-env
SECRET1="GF_AUTH_AZUREAD_CLIENT_ID=${GF_AUTH_AZUREAD_CLIENT_ID}"
SECRET2="GF_AUTH_AZUREAD_CLIENT_SECRET=${GF_AUTH_AZUREAD_CLIENT_SECRET}"
generateEncryptedSecretFile2Values

################################################
echo Grafana ext
################################################
CLUSTER=test-azure-ext
NAME=grafana
SECRET_PATH=./apps-grafana/${CLUSTER}/${NAME}
KV=${KV_EDMZ_URL}
NAMESPACE=grafana
VALUE=grafana-admin-details
SECRET1="adminUser=admin"
SECRET2="adminPassword=${SECRET_GRAFANA_ADMIN_PASSWORD}"
generateEncryptedSecretFile2Values

CLUSTER=test-azure-ext
NAME=grafana
SECRET_PATH=./apps-grafana/${CLUSTER}/${NAME}
KV=${KV_EDMZ_URL}
NAMESPACE=grafana
VALUE=grafana-auth-env
SECRET_NAME=grafana-auth-env
SECRET1="GF_AUTH_AZUREAD_CLIENT_ID=${GF_AUTH_AZUREAD_CLIENT_ID}"
SECRET2="GF_AUTH_AZUREAD_CLIENT_SECRET=${GF_AUTH_AZUREAD_CLIENT_SECRET}"
generateEncryptedSecretFile2Values
