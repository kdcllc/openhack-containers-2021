webDevGroupId=$(az ad group show --group web-devs --query objectId -o tsv)
apiDevGroupId=$(az ad group show --group api-devs --query objectId -o tsv)

webDevId=$(az ad user show --id webdev@OTAPRD332ops.onmicrosoft.com --query objectId -o tsv)
apiDevId=$(az ad user show --id apidev@OTAPRD332ops.onmicrosoft.com --query objectId -o tsv)

az ad group member add --group api-devs --member-id $webDevId
az ad group member add --group web-devs --member-id $apiDevId

cat ./read-only-role.yaml | sed "s/roleNamespace/web/g" | kubectl apply -n web -f -
cat ./read-only-role.yaml | sed "s/roleNamespace/api/g" | kubectl apply -n api -f -

cat ./admin-role.yaml | sed "s/roleNamespace/web/g" | kubectl apply -n web -f -
cat ./admin-role.yaml | sed "s/roleNamespace/api/g" | kubectl apply -n api -f -

cat ./api-user-admin-role-binding.yaml | sed "s/groupObjectId/${apiDevGroupId}/g" | kubectl apply -f -
cat ./api-user-viewer-role-binding.yaml | sed "s/groupObjectId/${apiDevGroupId}/g" | sed "s/roleNamespace/web/g" | kubectl apply -f -

cat ./web-user-admin-role-binding.yaml | sed "s/groupObjectId/${webDevGroupId}/g" | sed "s/roleNamespace/web/g" | kubectl apply -f -
cat ./web-user-viewer-role-binding.yaml | sed "s/groupObjectId/${webDevGroupId}/g" | sed "s/roleNamespace/api/g" | kubectl apply -f -