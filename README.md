# gitops-playground-apps
Application stack for use with gitops-playground





## Argo Events Build webhook
Simple webhook to mock a git triggered build (in the event that there is no public facing endpoint for github to interact with)

```
curl -X POST -H "Content-Type: application/json" -d '{"message":"build something"}' http://localhost:8080/demo-build-webhook
```

Generate some simple traffic for simulating canary deployment (Using argo-rollouts)
```
for i in {1..1000} do; sleep 1 && curl "http://localhost:8080/gitops-hugo";
```