#!/usr/bin/env bash
set -e

echo $BASH_VERSION
<<<<<<< HEAD
CREDS_FILE=~/.dockerhub-api

# ensure kubeseal is installed
# if [[ ! $(command -v kubeseal) ]]; then
#     >&2 echo "kubeseal is required"
#     exit 1
# fi

kubectl create namespace workflows --dry-run=client -o yaml | kubectl apply -f -


if [ -f "$CREDS_FILE" ]; then
    echo "Found dockerhub creds file"
	while IFS=":" read uservar keyvar
	do 
		echo "Setting secret for dockerhub user: $uservar"
		CREDS=$(echo -n $uservar:$keyvar | base64)
	done < $CREDS_FILE 
else
	printf 'Create an api key on dockerhub for use with argo workflows \nThis can be stored in a file: ~/.dockerhub-api \nOr entered on the prompt \n'
	read -p 'Docker API key: ' keyvar
	read -p 'Username: ' uservar
	CREDS=$(echo -n $uservar:$keyvar | base64)
fi

DOCKERAUTH=$(cat <<EOF
    {
    	"auths": {
	    	"https://index.docker.io/v1/": {
	    		"auth": "$CREDS"
=======

# ensure kubeseal is installed
if [[ ! $(command -v kubeseal) ]]; then
    >&2 echo "kubeseal is required"
    exit 1
fi

echo 'create an api key on dockerhub for use with argo workflows'
read -p 'Docker API key: ' keyvar
read -p 'Username: ' uservar

creds=$(echo -n $uservar:$keyvar | base64)

dockerauth=$(cat <<EOF
    {
    	"auths": {
	    	"https://index.docker.io/v1/": {
	    		"auth": "$creds"
>>>>>>> a1f22a61199882496dcdbd7f42b8bd84d049257d
    		}
    	}
    }
EOF
)

# # create a standard secret ready to seal
<<<<<<< HEAD
echo -n $DOCKERAUTH | kubectl create -n workflows secret generic regcred --from-file=.dockerconfigjson=/dev/stdin



# # create a standard secret ready to seal
# echo -n $CREDS | kubectl create secret generic regcred --dry-run=client --from-file=.dockerconfigjson=/dev/stdin -o yaml >dockercreds.yaml



# get the cert from the cluster
# kubeseal --controller-name=sealed-secrets  --controller-namespace=kube-system  --fetch-cert >ssCert.pem

# create git safe value for helm chart
# echo 'set in argo-workflows env values:'
# echo -n $DOCKERAUTH | kubeseal --cert ssCert.pem --raw --namespace workflows --name regcred --scope strict --from-file=/dev/stdin
=======
# echo -n $keyvar | kubectl create secret generic regcred --dry-run=client --from-file=.dockerconfigjson=/dev/stdin -o yaml >dockercreds.yaml

# get the cert from the cluster
kubeseal --controller-name=sealed-secrets  --controller-namespace=kube-system  --fetch-cert >ssCert.pem

# create git safe value for helm chart
echo 'set in argo-workflows env values:'
echo -n $dockerauth | kubeseal --cert ssCert.pem --raw --namespace workflows --name regcred --scope strict --from-file=/dev/stdin
>>>>>>> a1f22a61199882496dcdbd7f42b8bd84d049257d

# TODO: inject this directly into the values file?

# # use kubeseal to seal the secert so that it can be stored in git
# kubeseal --cert ssCert.pem -o yaml -n workflows <dockercreds.yaml >sealed-dockercreds.yaml

# # create secreat
# kubectl replace --force -f sealed-dockercreds.yaml

# # clean up
<<<<<<< HEAD
# rm ssCert.pem
=======
rm ssCert.pem
>>>>>>> a1f22a61199882496dcdbd7f42b8bd84d049257d
