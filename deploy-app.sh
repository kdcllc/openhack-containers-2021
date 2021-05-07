#!/bin/bash

# deploys app related resources    export acr=openhacklab2acr
# make sure that kubectl context is set to the current cluster
# az aks get-credentials --admin --name $aks --resource-group $rs
# kubectl config get-contexts
# kubectl config set-context --current --namespace=[?]

az acr login --name $acr


export REGISTRY=$(az acr show --name $acr --query loginServer -o tsv)

docker-compose -f "./.azdevops/docker-compose.yaml" up -d --build 
docker-compose -f "./.azdevops/docker-compose.yaml" down    
docker-compose -f "./.azdevops/docker-compose.yaml" push

# common properties
kubectl apply -f './k8s/common/namespaces.yaml'
kubectl apply -f './k8s/common/db-secrets.yaml' -n tripsinsight-app

export azureDns=$(az aks show -g $rg -n $aks --query addonProfiles.httpApplicationRouting.config.HTTPApplicationRoutingZoneName -o tsv)
dnsName="s/azureDns/tripsinsights-tripviewer.${azureDns}/g"

# poi
image="s/acrName/${REGISTRY}\/poi:1.0/g"
cat ./k8s/poi/deployment.yaml | sed $image | kubectl apply -n tripsinsight-app -f -
kubectl apply -f './k8s/poi/service.yaml' -n tripsinsight-app
cat ./k8s/poi/ingress.yaml | sed $dnsName | kubectl apply -n tripsinsight-app -f -

# trips
image="s/acrName/${REGISTRY}\/trips:1.0/g"
cat ./k8s/trips/deployment.yaml | sed $image | kubectl apply -n tripsinsight-app -f -

kubectl apply -f './k8s/trips/service.yaml' -n tripsinsight-app
cat ./k8s/trips/ingress.yaml | sed $dnsName | kubectl apply -n tripsinsight-app -f -

# user-java
image="s/acrName/${REGISTRY}\/user-java:1.0/g"
cat ./k8s/user-java/deployment.yaml | sed $image | kubectl apply -n tripsinsight-app -f -

kubectl apply -f './k8s/user-java/service.yaml' -n tripsinsight-app
cat ./k8s/user-java/ingress.yaml | sed $dnsName | kubectl apply -n tripsinsight-app -f -


# userprofile
image="s/acrName/${REGISTRY}\/userprofile:1.0/g"
cat ./k8s/userprofile/deployment.yaml | sed $image | kubectl apply -n tripsinsight-app -f -

kubectl apply -f './k8s/userprofile/service.yaml' -n tripsinsight-app
cat ./k8s/userprofile/ingress.yaml | sed $dnsName | kubectl apply -n tripsinsight-app -f -

# tripsviewer
image="s/acrName/${REGISTRY}\/tripviewer:1.0/g"
cat ./k8s/tripsviewer/deployment.yaml | sed $image | kubectl apply -n tripsinsight-app -f -

kubectl apply -f './k8s/tripsviewer/service.yaml' -n tripsinsight-app
cat ./k8s/tripsviewer/ingress.yaml | sed $dnsName | kubectl apply -n tripsinsight-app -f -
