#!/bin/bash

# Create and edit a copy of this file in eg ~/.secrets/filaname
#
# run:
#     . ~/.secrets/filaname

set -a

TMPDIR=~/.secrets

RG=your_rg

KVNAME_IDMZ=your_internal_kv
KVNAME_EDMZ=your_external_kv

LOKI_SA_NAME=your_storage_account
TEMPO_SA_NAME=your_storage_account
MIMIR_SA_NAME=your_storage_account
PHLARE_SA_NAME=your_storage_account

GF_AUTH_AZUREAD_AUTH_URL=https://login.microsoftonline.com/YOUR_TENANT_ID/oauth2/v2.0/authorize
GF_AUTH_AZUREAD_TOKEN_URL=https://login.microsoftonline.com/YOUR_TENANT_ID/oauth2/v2.0/token

GF_AUTH_AZUREAD_CLIENT_ID=your_azuread_client_id
GF_AUTH_AZUREAD_CLIENT_SECRET=your_azuread_client_secret

SECRET_LOKI_SA_ACCESS_KEY=$(az storage account keys list -n $LOKI_SA_NAME -g $RG --query [0].value -o tsv)
SECRET_TEMPO_SA_ACCESS_KEY=$(az storage account keys list -n $TEMPO_SA_NAME -g $RG --query [0].value -o tsv)
SECRET_MIMIR_SA_ACCESS_KEY=$(az storage account keys list -n $MIMIR_SA_NAME -g $RG --query [0].value -o tsv)
SECRET_PHLARE_SA_ACCESS_KEY=$(az storage account keys list -n $PHLARE_SA_NAME -g $RG --query [0].value -o tsv)
SECRET_GRAFANA_ADMIN_PASSWORD=your_grafana_admin_account_password
