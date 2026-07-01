# ============================================================================
# Project Aurora - Development Makefile
# ============================================================================

SHELL := /bin/bash
TERRAFORM_DIR := terraform
ENVIRONMENT ?= dev
BRANCH_NAME := $(shell git rev-parse --abbrev-ref HEAD)

.PHONY: help init plan apply destroy fmt validate clean security-check test

help: ## Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
	awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

# ============================================================================
# Terraform Commands
# ============================================================================

init: ## Initialize Terraform with backend
	@cd $(TERRAFORM_DIR) && terraform init

init-local: ## Initialize Terraform without backend (local state)
	@cd $(TERRAFORM_DIR) && terraform init -backend=false

plan: ## Run terraform plan with environment variables
	@cd $(TERRAFORM_DIR) && \
		TF_VAR_environment=$(ENVIRONMENT) \
		TF_VAR_branch_name=$(BRANCH_NAME) \
		terraform plan

apply: ## Run terraform apply with environment variables
	@cd $(TERRAFORM_DIR) && \
		TF_VAR_environment=$(ENVIRONMENT) \
		TF_VAR_branch_name=$(BRANCH_NAME) \
		terraform apply

destroy: ## Destroy all resources for the current environment
	@cd $(TERRAFORM_DIR) && \
		TF_VAR_environment=$(ENVIRONMENT) \
		TF_VAR_branch_name=$(BRANCH_NAME) \
		terraform destroy

fmt: ## Format all Terraform files
	@cd $(TERRAFORM_DIR) && terraform fmt -recursive

validate: ## Validate Terraform configuration
	@cd $(TERRAFORM_DIR) && terraform validate

# ============================================================================
# Security & Quality
# ============================================================================

security-check: ## Run security scanners
	@echo "Running Checkov..."
	@cd $(TERRAFORM_DIR) && checkov -d . --framework terraform --quiet || true
	@echo "Running tfsec..."
	@cd $(TERRAFORM_DIR) && tfsec . --no-colour || true

lint: fmt validate ## Run all linters

# ============================================================================
# Testing
# ============================================================================

test: ## Run infrastructure tests (requires terratest)
	@echo "Running infrastructure tests..."
	@cd tests && go test -v -timeout 30m

# ============================================================================
# Utilities
# ============================================================================

clean: ## Clean up Terraform files
	@find $(TERRAFORM_DIR) -type d -name '.terraform' -exec rm -rf {} + 2>/dev/null || true
	@find $(TERRAFORM_DIR) -type f -name 'terraform.tfstate*' -delete 2>/dev/null || true
	@find $(TERRAFORM_DIR) -type f -name '*.backup' -delete 2>/dev/null || true

graph: ## Generate Terraform dependency graph
	@cd $(TERRAFORM_DIR) && terraform graph | dot -Tpng > ../docs/architecture/terraform-graph.png
	@echo "Graph generated at docs/architecture/terraform-graph.png"

output: ## Show Terraform outputs
	@cd $(TERRAFORM_DIR) && terraform output

console: ## Open Terraform console
	@cd $(TERRAFORM_DIR) && terraform console

docs: ## Generate documentation
	@cd $(TERRAFORM_DIR) && terraform-docs markdown . > ../docs/terraform.md
	@echo "Documentation generated at docs/terraform.md"
