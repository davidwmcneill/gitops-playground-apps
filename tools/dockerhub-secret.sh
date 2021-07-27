#!/usr/bin/env bash
set -e

echo $BASH_VERSION

# ensure kubeseal is installed
if [[ ! $(command -v kubeseal) ]]; then
    >&2 echo "kubeseal is required"
    exit 1
fi

echo 'create an api key on dockerhub for use with argo workflows'
read -p 'Docker API key: ' keyvar

# # create a standard secret ready to seal
# echo -n $keyvar | kubectl create secret generic regcred --dry-run=client --from-file=.dockerconfigjson=/dev/stdin -o yaml >dockercreds.yaml

# get the cert from the cluster
kubeseal --controller-name=sealed-secrets  --controller-namespace=kube-system  --fetch-cert >ssCert.pem

# create git safe value for helm chart
echo 'set value in argo-workflows'
echo -n $keyvar | kubeseal --cert ssCert.pem --raw --scope namespace-wide --from-file=/dev/stdin


# # use kubeseal to seal the secert so that it can be stored in git
# kubeseal --cert ssCert.pem -o yaml -n workflows <dockercreds.yaml >sealed-dockercreds.yaml

# # create secreat
# kubectl replace --force -f sealed-dockercreds.yaml

# # clean up
rm ssCert.pem