#!/bin/bash
# azure cli version 2.23

echo $rg $aks

az aks delete --name $aks --resource-group $rg

az group delete --name "$rg"