# Kubernetes Templates/Examples

## Documentation/Resources:

<https://kubernetes.io/docs/home>

<https://microk8s.io/docs>

### kubectl commands:

> kubectl get all

> kubectl get pods|services -A

> kubectl apply -f CONFIGURATION.yaml

> kubectl delete -f CONFIGURATION.yaml

> kubectl expose pod NAME

###

TLS key/cert for Ingress:
```
kubectl create secret tls {{ NAME }} --key=PATH/TO/KEY --cert=PATH/TO/CERT
```

Verify Ingress config:
```
kubectl describe ing {{ INGRESS-NAME }}
