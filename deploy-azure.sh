#!/bin/bash
# Deploys all required resources
# azure cli version 2.23
# assign names
export rg=openhacklab2-rg 
export acr=openhacklab2acr
export aks=openhacklab2aks

# create resource group
az group create --name $rg --location eastus

# create acr
az acr create --resource-group $rg --name $acr --sku Basic

# create Azure AKS cluster enabled with `CNI  (--network-plugin azure)` and `Managed Identity (--enable-managed-identity)`.
az aks create --resource-group $rg --name $aks --node-count 2 --generate-ssh-keys --attach-acr $acr --network-plugin azure --enable-managed-identity

az aks enable-addons -a monitoring --name $aks --resource-group $rg

# enable http routing
az aks enable-addons --resource-group $rg --name $aks --addons http_application_routing

# az aks get-credentials --resource-group $rs --name $aks
az aks get-credentials --admin --name $aks --resource-group $rg

