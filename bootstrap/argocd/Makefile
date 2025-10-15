KUBECONFIG ?= ~/.kube/config
NAMESPACE := argocd
RELEASE := argocd
CHART := argo-cd
REPO := https://argoproj.github.io/argo-helm
VERSION := 8.6.3

.PHONY: all bootstrap clean status login port-forward

all: bootstrap

bootstrap: helm manifests
	@echo "✅ Bootstrap finished! make login + make port-forward"

helm:
	@echo "📦 Helm repo + ArgoCD install..."
	helm repo add argo $(REPO) || true
	helm repo update
	helm upgrade --install $(RELEASE) argo/$(CHART) \
	  --namespace $(NAMESPACE) --create-namespace \
	  --version $(VERSION) --wait --timeout=300s

manifests:
	@echo "🔗 ConfigMap + Application..."
	kubectl apply -k manifests/

status:
	kubectl get pods -n argocd

login:
	@echo "🔑 Admin password:"
	kubectl -n argocd get secret argocd-initial-admin-secret \
		-o jsonpath="{.data.password}" | base64 -d && echo
	@echo "🌐 make port-forward for localhost:8080"

port-forward:
	kubectl port-forward svc/argocd-server -n argocd 8080:443

clean:
	helm uninstall $(RELEASE) -n $(NAMESPACE) || true
	kubectl delete crd applications.argoproj.io appprojects.argoproj.io \
   applicationsets.argoproj.io || true
	kubectl delete -k manifests/ || true
	kubectl delete ns $(NAMESPACE) || true