# gitops-playground-apps
Application stack for used with K3d setup [gitops-playground](https://github.com/davidwmcneill/gitops-playground)

---
# Use case
Experimenting and learning new projects/technology locally, but retaining a way to easily destroy and recreate in the future.
Only the base applications are configured to auto-sync, so as to give the user the option to select which applications they want to run by synchronizing in the ArgoCD interface.
The idea could be that a developer wants to work locally on a subset of microservices and doesn't have a requirement to run an entire application stack.

---
# Requirements
- [Step](https://smallstep.com/cli/) (Optional. Only if using Linkerd)
---
# Environments
The template works on a branching strategy whereby each environment can be developed and merged upstream, with main/master being the production environment.
`env2` is used as a placeholder for this, but primarily for the playground aspect `local` is used.

---
# The application stack
Applications are deployed using an ArgoCD application spec that is templated as a helm deployment following the [app of apps pattern](https://argoproj.github.io/argo-cd/operator-manual/cluster-bootstrapping/#app-of-apps-pattern)

### Base
- Ingress-Nginx
- Prometheus-stack
### Optional 
- Argo-events
- Argo-rollouts
- Argo-workflows
- Argo-image-updater

---
## Argo Events Build webhook
Simple webhook to mock a git triggered build (in the event that there is no public facing endpoint for github to interact with)

```
curl -X POST -H "Content-Type: application/json" -d '{"message":"build something"}' http://localhost:8080/demo-build-webhook
```

Generate some simple traffic for simulating canary deployment (Using argo-rollouts)
```
k6 run k6-tests/hugo-smoke.js
```
---
# Managing secrets
I was originally using [Seal-secrets](https://github.com/bitnami-labs/sealed-secrets) for this project in keeping with the GitOps mandate.
But due to the disposable nature of the cluster (which then creates a new encryption key) it's become a bit tedious having to commit the change back into git each time the cluster is recreated.\
For now the secret is create with a script outside of git. I'll look to revisit this in the future.

# Reference

[K3d](https://k3d.io/v5.4.1/) - K3s docker wrapper
[Seal-secrets](https://github.com/bitnami-labs/sealed-secrets)
[Helm](https://helm.sh/) - Kubernetes package manager
[Argocd](https://argo-cd.readthedocs.io/en/stable/) - Gitops operator
[Argo-Rollouts](https://argoproj.github.io/argo-rollouts/) - Advanced deployment
[Argo-Workflows](https://argoproj.github.io/workflows/) - Workflow engine 
[Argo-Events](https://argoproj.github.io/argo-events/) - Event driven workflow automation
[K6](https://k6.io/) - Loadtesting tool
[Tilt](https://tilt.dev/) - Dev build tool for k8s
[Linkerd](https://linkerd.io/) - Service mesh


