KUBECONFIG ?= ~/.kube/config
NAMESPACE := argocd
RELEASE := argocd
CHART := argo-cd
REPO := https://argoproj.github.io/argo-helm
VERSION := 8.6.3

.PHONY: all install-ansible install-deps bootstrap clean force-clean help setup-from-scratch

all: bootstrap

setup-from-scratch: install-ansible install-deps bootstrap
	@echo "✅ Complete setup finished!"

help:
	@echo "🚀 ArgoCD Bootstrap with Ansible"
	@echo ""
	@echo "Available targets:"
	@echo "  setup-from-scratch - Install everything and bootstrap (fresh start)"
	@echo "  bootstrap          - Run full ArgoCD bootstrap"
	@echo "  clean              - Clean up ArgoCD installation (with confirmation)"
	@echo "  force-clean        - Force clean ArgoCD (no confirmation)"
	@echo "  install-ansible    - Install Ansible via pip3"
	@echo "  install-deps       - Install Ansible collections"
	@echo "  help               - Show this help"
	@echo ""
	@echo "🚀 For first time setup: make setup-from-scratch"

install-ansible:
	@echo "📦 Installing Ansible and dependencies..."
	pip3 install ansible kubernetes

install-deps:
	@echo "📦 Installing Ansible collections..."
	ansible-galaxy collection install -r requirements.yml --force

bootstrap: install-deps
	@echo "🚀 Bootstrapping ArgoCD with Ansible..."
	ansible-playbook bootstrap.yaml -v

clean:
	@echo "🧹 Cleaning up ArgoCD installation..."
	@echo "⚠️  This will delete ALL ArgoCD resources!"
	@read -p "Type 'yes' to continue: " confirm && [ "$$confirm" = "yes" ]
	@echo "🗑️  Removing Applications..."
	kubectl delete applications --all -n $(NAMESPACE) || true
	kubectl delete applications --all -n default || true
	@echo "🗑️  Removing ApplicationSets..."
	kubectl delete applicationsets --all -n $(NAMESPACE) || true
	@echo "🗑️  Removing ArgoCD Helm release..."
	helm uninstall $(RELEASE) -n $(NAMESPACE) || true
	@echo "🗑️  Removing ArgoCD CRDs..."
	kubectl delete crd applications.argoproj.io appprojects.argoproj.io applicationsets.argoproj.io || true
	@echo "🗑️  Removing ConfigMaps and Secrets..."
	kubectl delete configmap argocd-cm -n $(NAMESPACE) || true
	kubectl delete secret argocd-initial-admin-secret -n $(NAMESPACE) || true
	@echo "🗑️  Removing namespace..."
	kubectl delete namespace $(NAMESPACE) || true
	@echo "✅ Cleanup completed!"

force-clean:
	@echo "💥 FORCE cleaning ArgoCD (no confirmation)..."
	kubectl delete applications --all -n $(NAMESPACE) || true
	kubectl delete applications --all -n default || true
	kubectl delete applicationsets --all -n $(NAMESPACE) || true
	helm uninstall $(RELEASE) -n $(NAMESPACE) || true
	kubectl delete crd applications.argoproj.io appprojects.argoproj.io applicationsets.argoproj.io || true
	kubectl delete configmap argocd-cm -n $(NAMESPACE) || true
	kubectl delete secret argocd-initial-admin-secret -n $(NAMESPACE) || true
	kubectl delete namespace $(NAMESPACE) || true
	@echo "✅ Force cleanup completed!"