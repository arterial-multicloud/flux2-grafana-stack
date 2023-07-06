# grafana

## workload identity doesnt work today

It doesn't seem like workload identity works today. 
Everything looks good (token exists in AZURE_FEDERATED_TOKEN_FILE) but wont connect

```yaml
grafana_namespace="grafana"
grafana_service_account_name="grafana"

---
resource "azurerm_user_assigned_identity" "grafana_workload_identity" {
  location            = data.azurerm_resource_group.env_rg.location
  resource_group_name = data.azurerm_resource_group.env_rg.name
  name                = "grafana-workload-identity"
}

resource "azurerm_role_assignment" "grafana_workload_identity_sub_reader" {
  scope                = data.azurerm_subscription.subscription.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.grafana_workload_identity.principal_id
}

resource "azurerm_role_assignment" "grafana_workload_identity_sub_am_reader" {
  scope                = data.azurerm_subscription.subscription.id
  role_definition_name = "Monitoring Reader"
  principal_id         = azurerm_user_assigned_identity.grafana_workload_identity.principal_id
}

data "azurerm_subscription" "subscription" {
    subscription_id = data.azurerm_client_config.current.subscription_id
}

---
values.yaml:

serviceAccount: 
      labels: 
        azure.workload.identity/client-id: CLIENT_ID

    podLabels:
      # aadpodidbinding: sops-decryptor
      azure.workload.identity/use: "true"

---
$ k get sa -n grafana grafana -o yaml | egrep '  name|azure'
    azure.workload.identity/client-id: CLIENT_ID
  name: grafana
  namespace: grafana
$ k exec -it  -n grafana  grafana-647485494f-598zr  -- sh -c "env | grep AZURE"
AZURE_AUTHORITY_HOST=https://login.microsoftonline.com/
AZURE_CLIENT_ID=
AZURE_FEDERATED_TOKEN_FILE=/var/run/secrets/azure/tokens/azure-identity-token
AZURE_TENANT_ID=mytenantid

```
