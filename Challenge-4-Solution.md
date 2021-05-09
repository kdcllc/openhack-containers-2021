# Challenge #4  Solution

1. Create AKS Cluster with `CNI  (--network-plugin azure)` and `Managed Identity (--enable-managed-identity)` enabled

Change environment variables at the top of the bash file and run `./deploy-azure.sh`.
_note: script assumes vnet and subnet is created in order for the aks cluster join._

The default IP range was changed upon creation of the cluster.

```bash
    --dns-service-ip 10.2.3.10 --service-cidr 10.2.3.0/24
```

The limitation of adding cluster to an existing subnet instead of doing `vnet peering` is that `vnet`and cluster must resign in the same region.

2. Create Key Vault and Assign Security run `./keyvault-setup.sh` script

 - Creates Service Principle to be used to access Azure Vault
 - Azure Vault is created in its own resource group
 - Service Principle clientId and clientSecret is stored Kubernetes secrets.
 

3. Install CSI Driver with Helm

```bash
    helm install csi csi-secrets-store-provider-azure/csi-secrets-store-provider-azure--namespace kube-system
    # uninstall script
    helm uninstall csi-secrets-store secrets-store-csi-driver/secrets-store-csi-driver --namespace kube-system
    # check if it was successful
    kubectl --namespace=kube-system get pods -l "app=secrets-store-csi-driver"
```

4. Install secret provider in the namespaces

```bash
    kubectl apply -f ./k8s/common/secret-provider.yaml -n web
    kubectl apply -f ./k8s/common/secret-provider.yaml -n api
```

5. Redeploy the application run `./deploy-app.sh`

## References

- https://docs.microsoft.com/en-us/azure/key-vault/general/key-vault-integrate-kubernetes#deploy-an-azure-kubernetes-service-aks-cluster-by-using-the-azure-cli

