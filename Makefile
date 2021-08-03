SHELL := /bin/bash

export K3D_LOCAL_PORT = 8080
export K3D_LOCAL_DOMAIN = localhost
export K3D_LOCAL_URL = http://$(K3D_LOCAL_DOMAIN):$(K3D_LOCAL_PORT)

githook:
	curl -X POST -H "Content-Type: application/json" -d '{"message":"build something"}' $(K3D_LOCAL_URL)/demo-build-webhook

traffic:
	while true; do curl "$(K3D_LOCAL_URL)/gitops-hugo"; sleep 1; done

dockerhub-secret:
	./tools/dockerhub-secret.sh
linkerd-secret:
	./tools/linkerd-secret.sh
# linkerd-cert:
# 	step certificate create root.linkerd.cluster.local ca.crt ca.key --profile root-ca --no-password --insecure
# 	step certificate create identity.linkerd.cluster.local issuer.crt issuer.key --profile intermediate-ca --not-after 8760h --no-password --insecure --ca ca.crt --ca-key ca.key
url_argo:
	open $(K3D_LOCAL_URL)/argo

url_prometheus:
	open $(K3D_LOCAL_URL)/prometheus

url_grafana:
	open $(K3D_LOCAL_URL)/grafana/login

url_argocd:
	open $(K3D_LOCAL_URL)/argocd

url_hugo:
	open $(K3D_LOCAL_URL)/gitops-hugo