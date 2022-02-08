#!/usr/bin/env bash
set -e

echo $BASH_VERSION

# ensure kubeseal is installed
# if [[ ! $(command -v kubeseal) ]]; then
#     >&2 echo "kubeseal is required"
#     exit 1
# fi



# kubectl create secret tls linkerd-trust-anchor \
#     --dry-run=client \
#     --cert=ca.crt \
#     --key=ca.key \
#     --namespace=linkerd -o yaml | kubeseal --namespace=kube-system --controller-name sealed-secrets -o yaml > ./helm/cluster/linkerd/templates/trust-anchor.yaml

kubectl create namespace linkerd --dry-run=client -o yaml | kubectl apply -f -

# Generate root certificate: https://linkerd.io/2.11/tasks/generate-certificates/#trust-anchor-certificate
# step certificate create root.linkerd.cluster.local ca.crt ca.key \
# --profile root-ca --no-password --insecure

# creating directly in the cluster - for use with cert-manager: https://linkerd.io/2.11/tasks/automatically-rotating-control-plane-tls-credentials/#save-the-signing-key-pair-as-a-secret
# TODO: create via sealed secret
step certificate create root.linkerd.cluster.local ca.crt ca.key \
  --profile root-ca --no-password --insecure &&
  kubectl create secret tls \
    linkerd-trust-anchor \
    --cert=ca.crt \
    --key=ca.key \
    --namespace=linkerd

# note in the Linkerd template we create the cert-manager resource reference

