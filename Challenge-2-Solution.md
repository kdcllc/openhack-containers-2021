# Challenge #2  Solution

1. Create resource group && Azure ACR

```bash
    rg=openhacker3-rg /
    acr=openhacker3acr /
    aks=openhacker3aks

    az group create --name $rg --location eastus

    az acr create --resource-group $rg /
                  --name $acr --sku Basic
```

2. Create AKS Cluster

Azure AKS cluster enabled with `CNI  (--network-plugin azure)` and `Managed Identity (--enable-managed-identity)`.

```bash
    az aks create /
        -g $rg /
        --name $aks /
        --node-count 2 /
        --generate-ssh-keys /
        --attach-acr $acr /
        --network-plugin azure /
        --enable-managed-identity
```

3. Enable Azure Log monitoring and create Log Analytics instance.

```bash
    az aks enable-addons -a monitoring -n $aks -g $rg
```

4. Get access Credentials to the cluster

```bash
    az aks get-credentials -g $rs -n $aks
```

Note: you can run `./deploy-azure.sh` with names changed for the resources.

5. Deploy resources

- Deploy images to the `ACR`

```bash
    # env variables in order for them to be used in other process must be exported
    export acr=openhacklab2acr
    export az acr login --name $acr

    
    export REGISTRY=$(az acr show --name $acr --query loginServer -o tsv)

    docker-compose -f "./.azdevops/docker-compose.yaml" up -d --build 
    docker-compose -f "./.azdevops/docker-compose.yaml" down    
    docker-compose -f "./.azdevops/docker-compose.yaml" push
```

https://kubernetes.io/docs/reference/kubectl/cheatsheet/

```bash
    kubectl config get-contexts
    kubectl config current-context
    kubectl config set current-context MY-CONTEXT
    kubectl config set-context --current --namespace=tripsinsight-app

    kubectl config set current-context  docker-desktop
    kubectl config delete-context openhacklab2aks-admin
```

Create `db-secrets.yaml` with database connection.

```bash
    # create a namespace
    kubectl apply -f './k8s/common/namespaces.yaml'
    # create apps secrets
    kubectl apply -f './k8s/common/db-secrets.yaml' -n tripsinsight-app

    # poi
    kubectl apply -f './k8s/poi/deployment.yaml' -n tripsinsight-app
    kubectl apply -f './k8s/poi/service.yaml' -n tripsinsight-app
    kubectl apply -f './k8s/poi/ingress.yaml' -n tripsinsight-app

    # trips
    kubectl apply -f './k8s/trips/deployment.yaml' -n tripsinsight-app
    kubectl apply -f './k8s/trips/service.yaml' -n tripsinsight-app
    kubectl apply -f './k8s/trips/ingress.yaml' -n tripsinsight-app
    
    # user-java
    kubectl apply -f './k8s/user-java/deployment.yaml' -n tripsinsight-app
    kubectl apply -f './k8s/user-java/service.yaml' -n tripsinsight-app
    kubectl apply -f './k8s/user-java/ingress.yaml' -n tripsinsight-app

    # userprofile
    kubectl apply -f './k8s/userprofile/deployment.yaml' -n tripsinsight-app
    kubectl apply -f './k8s/userprofile/service.yaml' -n tripsinsight-app
    kubectl apply -f './k8s/userprofile/ingress.yaml' -n tripsinsight-app

    # tripsviewer
    kubectl apply -f './k8s/tripsviewer/deployment.yaml' -n tripsinsight-app
    kubectl apply -f './k8s/tripsviewer/service.yaml' -n tripsinsight-app
    kubectl apply -f './k8s/tripsviewer/ingress.yaml' -n tripsinsight-app
```

## Http Routing Addon

https://docs.microsoft.com/en-us/azure/aks/http-application-routing

```bash
    export azureDns=$(az aks show -g $rg -n $aks --query addonProfiles.httpApplicationRouting.config.HTTPApplicationRoutingZoneName -o tsv)
```

Execute curl commands in the pod
```bash
    kubectl get pod shell-demo
    kubectl exec --stdin --tty shell-demo -- /bin/bash

    # execute just the command
    kubectl exec shell-demo -- ls /
```

## Testing

https://github.com/Azure-Samples/openhack-containers/tree/master/src/poi#testing

```bash

    curl -i -X GET 'http://localhost:8080/api/poi'

    curl -i -X GET 'http://tripsinsights-poi/api/poi'

```

https://github.com/Azure-Samples/openhack-containers/tree/master/src/trips#testing

```bash
    curl -i -X GET 'http://localhost:8080/api/trips' 

    curl -i -X GET 'http://tripsinsights-trip/api/trips' 
s
```

https://github.com/Azure-Samples/openhack-containers/tree/master/src/user-java#testing

```bash
    curl -i -X GET 'http://localhost:8080/api/user-java/healthcheck'
    curl -i -X GET 'http://tripsinsights-user-java/api/user-java/healthcheck'
```

https://github.com/Azure-Samples/openhack-containers/tree/master/src/userprofile#testing

```bash
    curl -i -X GET 'http://localhost:8080/api/user' 
    curl -i -X GET 'http://localhost:8080/api/user/healthcheck' 

    curl -i -X GET 'http://tripsinsights-userprofile/api/user' 
    curl -i -X GET 'http://tripsinsights-userprofile/api/user/healthcheck' 
```