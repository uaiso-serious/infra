#!/bin/bash
kubectl create namespace argocd
kubectl -n argocd apply -f https://raw.githubusercontent.com/argoproj/argo-cd/refs/tags/v3.2.5/manifests/install.yaml
kubectl -n argocd apply -f argocd-custom.yaml
kubectl -n argocd rollout status deployment/argocd-server
kubectl -n argocd scale deployment/argocd-server --replicas 0
kubectl -n argocd rollout status deployment/argocd-server
kubectl -n argocd scale deployment/argocd-server --replicas 1
kubectl -n argocd rollout status deployment/argocd-server
kubectl apply -f argocd-basic.yaml
while true; do
  kubectl -n onedev exec onedev-0 -- bash -c "curl -s -u admin:admin http://onedev.uaiso.lan/~api/version/server" | grep 14.0.7 && break
  sleep 5
done
kubectl -n onedev exec onedev-0 -- bash -c "git clone https://github.com/uaiso-serious/infra /tmp/infra"

kubectl -n onedev exec onedev-0 -- bash -c "curl -s -u admin:admin -d@/tmp/infra/_setup/argocd/onedev-new-project.json -H 'Content-Type: application/json' http://onedev.uaiso.lan/~api/projects"
kubectl -n onedev exec onedev-0 -- bash -c "cd /tmp/infra;git remote rm origin;git remote add origin http://admin:admin@onedev.uaiso.lan/uaiso.git;git push -u origin main"
kubectl apply -f argocd-uaiso.yaml