#!/bin/bash

# common properties
kubectl delete -f './k8s/common/namespaces.yaml'
kubectl delete -f './k8s/common/db-secrets.yaml' -n tripsinsight-app

# poi
kubectl delete -f './k8s/poi/deployment.yaml' -n tripsinsight-app
kubectl delete -f './k8s/poi/service.yaml' -n tripsinsight-app
kubectl delete -f './k8s/poi/ingress.yaml ' -n tripsinsight-app

# trips
kubectl delete -f './k8s/trips/deployment.yaml' -n tripsinsight-app
kubectl delete -f './k8s/trips/service.yaml' -n tripsinsight-app
kubectl delete -f './k8s/trips/ingress.yaml ' -n tripsinsight-app

# user-java
kubectl delete -f './k8s/user-java/deployment.yaml' -n tripsinsight-app
kubectl delete -f './k8s/user-java/service.yaml' -n tripsinsight-app
kubectl delete -f './k8s/user-java/ingress.yaml ' -n tripsinsight-app


# userprofile
kubectl delete -f './k8s/userprofile/deployment.yaml' -n tripsinsight-app
kubectl delete -f './k8s/userprofile/service.yaml' -n tripsinsight-app
kubectl delete -f './k8s/userprofile/ingress.yaml ' -n tripsinsight-app

# tripsviewer
kubectl delete -f './k8s/tripsviewer/deployment.yaml' -n tripsinsight-app
kubectl delete -f './k8s/tripsviewer/service.yaml' -n tripsinsight-app
kubectl delete -f './k8s/tripsviewer/ingress.yaml ' -n tripsinsight-app
