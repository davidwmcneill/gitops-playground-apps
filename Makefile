SHELL := /bin/bash

export K3D_LOCAL_PORT = 8080
export K3D_LOCAL_DOMAIN = localhost
export K3D_LOCAL_URL = http://$(K3D_LOCAL_DOMAIN):$(K3D_LOCAL_PORT)

rollouts_dashboard:
	kubectl port-forward -n argo service/argo-rollouts-dashboard 31000:3100 &
	open http://localhost:31000/rollouts

linkerd-dashboard:
	linkerd viz dashboard &

linkerd-demo-vote:
	kubectl -n emojivoto port-forward svc/web-svc 31015:80 &
	open http://localhost:31015

githook:
	curl -X POST -H "Content-Type: application/json" -d '{"message":"build something"}' $(K3D_LOCAL_URL)/demo-build-webhook


traffic:
	k6 run k6-tests/hugo-smoke.js
	# while true; do curl -I "$(K3D_LOCAL_URL)/gitops-hugo"; sleep 0.5; done

traffic-bg:
	k6 run k6-tests/hugo-bg-smoke.js
	# while true; do curl -I "$(K3D_LOCAL_URL)/gitops-hugo-bg"; sleep 0.4; done

traffic-bg-preview:
	k6 run k6-tests/hugo-bg-smoke-preview.js
	# while true; do curl -I "$(K3D_LOCAL_URL)/gitops-hugo-bg-preview"; sleep 0.4; done

bad_traffic:
	while true; do curl -I "$(K3D_LOCAL_URL)/gitops-hugo/bad.html"; sleep 0.2; done


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
	open $(K3D_LOCAL_URL)/prometheus/graph

url_grafana:
	open $(K3D_LOCAL_URL)/grafana/login

url_argocd:
	open $(K3D_LOCAL_URL)/argocd

url_hugo:
	open $(K3D_LOCAL_URL)/gitops-hugo

# kubectl extention for argo-rollouts - https://argoproj.github.io/argo-rollouts/installation/#brew
watch_rollout:
	kubectl argo rollouts -n app-frontend get rollout gitops-hugo --watch
