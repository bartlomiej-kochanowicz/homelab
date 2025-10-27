.PHONY: init plan apply destroy output validate clean format check-vars

# Variables
TFVARS_FILE := modules/cloudflare/variables.tfvars
TFVARS_EXAMPLE := modules/cloudflare/variables.tfvars.example

init: ## Initialize Terraform (download providers and modules)
	@echo "🔧 Initializing Terraform..."
	terraform init

init-upgrade: check-vars ## Initialize and upgrade providers
	@echo "🔧 Initializing Terraform with provider upgrade..."
	terraform init -upgrade

plan: check-vars ## Show planned changes
	@echo "📋 Planning Terraform changes..."
	terraform plan -var-file=$(TFVARS_FILE)

apply: check-vars ## Apply Terraform configuration
	@echo "🚀 Applying Terraform configuration..."
	terraform apply -var-file=$(TFVARS_FILE)

destroy: ## Destroy all Terraform resources
	@echo "💣 Destroying Terraform resources..."
	@echo "⚠️  This will delete the tunnel, DNS records, and Access policies!"
	terraform destroy -var-file=$(TFVARS_FILE)

output: ## Show all outputs
	@echo "📤 Terraform outputs:"
	@terraform output

validate: ## Validate Terraform configuration
	@echo "✅ Validating Terraform configuration..."
	terraform validate

format: ## Format Terraform files
	@echo "🎨 Formatting Terraform files..."
	terraform fmt -recursive

format-check: ## Check if files are formatted
	@echo "🔍 Checking Terraform formatting..."
	terraform fmt -check -recursive

clean: ## Clean Terraform files (.terraform, state backups)
	@echo "🧹 Cleaning Terraform files..."
	rm -rf .terraform
	rm -rf .terraform.lock.hcl
	rm -f terraform.tfstate.backup
	rm -f .terraform.tfstate.lock.info
	@echo "✅ Cleaned (kept state file for safety)"

clean-all: ## Clean everything including state (dangerous!)
	@echo "⚠️  This will delete ALL Terraform state!"
	@read -p "Are you sure? Type 'yes' to continue: " confirm; \
	if [ "$$confirm" = "yes" ]; then \
		rm -rf .terraform .terraform.lock.hcl *.tfstate *.tfstate.backup .terraform.tfstate.lock.info; \
		echo "✅ All Terraform files cleaned"; \
	else \
		echo "❌ Cancelled"; \
	fi

show: ## Show current state
	@echo "📊 Current Terraform state:"
	terraform show

state-list: ## List all resources in state
	@echo "📝 Resources in Terraform state:"
	terraform state list

refresh: check-vars ## Refresh Terraform state
	@echo "🔄 Refreshing Terraform state..."
	terraform refresh -var-file=$(TFVARS_FILE)

graph: ## Generate dependency graph (requires graphviz)
	@echo "📊 Generating dependency graph..."
	terraform graph | dot -Tpng > graph.png
	@echo "✅ Graph saved to graph.png"

console: check-vars ## Open Terraform console
	@echo "🖥️  Opening Terraform console (type 'exit' to quit)..."
	terraform console -var-file=$(TFVARS_FILE)

setup: ## Initial setup - copy example and prompt for edit
	@if [ -f $(TFVARS_FILE) ]; then \
		echo "⚠️  $(TFVARS_FILE) already exists!"; \
		echo "Remove it first if you want to start fresh."; \
	else \
		cp $(TFVARS_EXAMPLE) $(TFVARS_FILE); \
		echo "✅ Created $(TFVARS_FILE) from example"; \
		echo ""; \
		echo "📝 Please edit $(TFVARS_FILE) with your credentials:"; \
		echo "  - Cloudflare API Token"; \
		echo "  - Account ID"; \
		echo "  - Zone ID"; \
		echo "  - Domain"; \
		echo "  - Allowed emails"; \
		echo ""; \
		echo "Then run: make init"; \
	fi

# Hidden target for CI/CD
.SILENT: check-vars tunnel-token tunnel-id argocd-url
