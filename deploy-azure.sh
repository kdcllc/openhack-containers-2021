#!/bin/bash
# Deploys all required resources
# azure cli version 2.23
# assign names
export rg=openhacklab3-rg 
export acr=openhacklab3acr
export aks=openhacklab3aks
export sub=OTA-PRD-332
# create resource group
az group create --name $rg --location westus

# create acr
az acr create --resource-group $rg --name $acr --sku Basic --location westus

# adminGroupId=$(az ad group create --display-name aks-admins --mail-nickname aks-admins --query objectId -o tsv)
export tenantId=$(az account show --subscription OTA-PRD-332 --query tenantId --output tsv)
export adminGroupId=$(az ad group show --group aks-admins --query objectId -o tsv)

# create subnet manually
export subNetId=$(az network vnet subnet list --resource-group teamResources --vnet-name vnet --query "[1].id" --output tsv)

# create Azure AKS cluster enabled with `CNI  (--network-plugin azure)` and `Managed Identity (--enable-managed-identity)`.
az aks create --resource-group $rg --name $aks --node-count 2 --generate-ssh-keys --attach-acr $acr --network-plugin azure --enable-managed-identity --vnet-subnet-id $subNetId --docker-bridge-address 172.17.0.1/16 --dns-service-ip 10.2.3.10 --service-cidr 10.2.3.0/24 --enable-aad --aad-admin-group-object-ids $adminGroupId --aad-tenant-id $tenantId --location westus

az aks enable-addons -a monitoring --name $aks --resource-group $rg

# enable http routing
az aks enable-addons --resource-group $rg --name $aks --addons http_application_routing

# az aks get-credentials --resource-group $rs --name $aks
az aks get-credentials --admin --name $aks --resource-group $rg --overwrite-existing

