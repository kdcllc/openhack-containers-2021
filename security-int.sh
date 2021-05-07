#

hacker=hacker3dd9@OTAPRD332ops.onmicrosoft.com
hackerId=$(az ad user show --id $hacker -o tsv --query objectId)
az ad group member add --group aks-admins --member-id $hackerId

# export adminGroupId=$(az ad group show --group aks-admins --query objectId -o tsv)
# export aksId=$(az aks show --resource-group $rg --name $aks --query id -o tsv)

webDevGroupId=$(az ad group create --display-name web-devs --mail-nickname web-devs --query objectId -o tsv)
apiDevGroupId=$(az ad group create --display-name api-devs --mail-nickname api-devs --query objectId -o tsv)

webDevId=$(az ad user show --id webdev@OTAPRD332ops.onmicrosoft.com --query objectId -o tsv)
apiDevId=$(az ad user show --id apidev@OTAPRD332ops.onmicrosoft.com --query objectId -o tsv)

az role assignment create \
  --assignee $webDevId \
  --role "Azure Kubernetes Service Cluster User Role" \
  --scope $aksId

az role assignment create \
  --assignee $apiDevId \
  --role "Azure Kubernetes Service Cluster User Role" \
  --scope $aksId

az role assignment create \
  --assignee $adminGroupId \
  --role "Azure Kubernetes Service RBAC Cluster Admin" \
  --scope $aksId

