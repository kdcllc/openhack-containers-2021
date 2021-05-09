export rgKv=openhacklab4-kv-rg
export kv=openhacklab4kv
export lc=westus
export spName=openhacklab4kv-sp
export sub=OTA-PRD-332

az group create --name $rgKv -l $lc

az keyvault create --name $kv --resource-group $rgKv --location $lc

az ad sp create-for-rbac --skip-assignment --name $spName
spPass=$(az ad sp credential reset --name $spName --credential-description "APClientSecret" --query password -o tsv)
echo $spPass

clientId=$(az ad sp show --id http://${spName} --query appId -o tsv)

tenantId=$(az account show --subscription $sub --query id --output tsv)

# Assign Reader Role to the service principal for your keyvault
az role assignment create --role Reader --assignee $clientId --scope /subscriptions/$tenantId/resourcegroups/$rgKv/providers/Microsoft.KeyVault/vaults/$kv

az keyvault set-policy -n $kv --key-permissions get --spn $clientId
az keyvault set-policy -n $kv --secret-permissions get --spn $clientId
az keyvault set-policy -n $kv --certificate-permissions get --spn $clientId

kubectl delete secret secrets-store-creds
kubectl delete secret secrets-store-creds -n api
kubectl delete secret secrets-store-creds -n web

kubectl create secret generic secrets-store-creds --from-literal clientid=$clientId --from-literal clientsecret=$spPass -n api
kubectl create secret generic secrets-store-creds --from-literal clientid=$clientId --from-literal clientsecret=$spPass -n web
kubectl create secret generic secrets-store-creds --from-literal clientid=$clientId --from-literal clientsecret=$spPass