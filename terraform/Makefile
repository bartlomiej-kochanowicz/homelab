.PHONY: init plan apply destroy output validate format

# Variables
TFVARS_FILE := modules/cloudflare/variables.tfvars

init: ## Initialize Terraform (download providers and modules)
	@echo "🔧 Initializing Terraform..."
	terraform init

init-upgrade: ## Initialize and upgrade providers
	@echo "🔧 Initializing Terraform with provider upgrade..."
	terraform init -upgrade

plan: ## Show planned changes
	@echo "📋 Planning Terraform changes..."
	terraform plan -var-file=$(TFVARS_FILE)

apply: ## Apply Terraform configuration
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
