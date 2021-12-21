#!/usr/bin/env bash
set -e

echo $BASH_VERSION

# ensure kubeseal is installed
if [[ ! $(command -v kubeseal) ]]; then
    >&2 echo "kubeseal is required"
    exit 1
fi

# step certificate create identity.linkerd.cluster.local ca.crt ca.key \
#     --profile root-ca \
#     --no-password \
#     --insecure

# kubectl create secret tls linkerd-trust-anchor \
#     --dry-run=client \
#     --cert=ca.crt \
#     --key=ca.key \
#     --namespace=linkerd -o yaml | kubeseal --namespace=kube-system --controller-name sealed-secrets -o yaml > ./helm/cluster/linkerd/templates/trust-anchor.yaml

kubectl create namespace linkerd --dry-run=client -o yaml | kubectl apply -f -

# creating directly in the cluster
# TODO: create via sealed secret
step certificate create root.linkerd.cluster.local ca.crt ca.key \
  --profile root-ca --no-password --insecure &&
  kubectl create secret tls \
    linkerd-trust-anchor \
    --cert=ca.crt \
    --key=ca.key \
    --namespace=linkerd

rm ca.crt ca.key
