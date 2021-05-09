# Alternatives to Http Module add on

1. Install [Create an ingress controller in Azure Kubernetes Service (AKS)](https://docs.microsoft.com/en-us/azure/aks/ingress-basic)

2. Apply the following ingress

```yml
# POI
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: tripsinsights-poi-ingress
  namespace: default
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
    nginx.ingress.kubernetes.io/rewrite-target: /api/poi/$2
spec:
  rules:
  - http:
      paths:
      - backend:
          serviceName: tripsinsights-poi
          servicePort: 80
        path: /api/poi(/|$)(.*)
---
# trips
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: tripsinsights-trips-ingress
  namespace: default
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
    nginx.ingress.kubernetes.io/rewrite-target: /api/trips/$2
spec:
  rules:
  - http:
      paths:
      - backend:
          serviceName: tripsinsights-trips
          servicePort: 80
        path: /api/trips(/|$)(.*)
---
# tripsviwier
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: tripsinsights-tripviewer-ingress
  namespace: default
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
    nginx.ingress.kubernetes.io/use-regex: "true"
    nginx.ingress.kubernetes.io/rewrite-target: /$1
spec:
  rules:
  - http:
      paths:
      - backend:
          serviceName: tripsinsights-tripviewer
          servicePort: 80
        path: /(.*)
---
# user-java
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: tripsinsights-user-java-ingress
  namespace: default
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
    nginx.ingress.kubernetes.io/rewrite-target: /api/user-java/$2
spec:
  rules:
  - http:
      paths:
      - backend:
          serviceName: tripsinsights-user-java
          servicePort: 80
        path: /api/user-java(/|$)(.*)
---
# userprofile
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: tripsinsights-userprofile-ingress
  namespace: default
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
    nginx.ingress.kubernetes.io/rewrite-target: /api/user/$2
spec:
  rules:
  - http:
      paths:
      - backend:
          serviceName: tripsinsights-userprofile
          servicePort: 80
        path: /api/user(/|$)(.*)
```