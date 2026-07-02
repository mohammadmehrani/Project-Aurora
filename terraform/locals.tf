locals {
  common_tags = {
    Project     = "Project Aurora"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Repository  = var.github_repository != null ? "https://github.com/${var.github_repository}" : "unknown"
    CostCenter  = var.cost_center
    Contact     = var.contact_email
  }

  ssh_key_algorithm = var.ssh_key_algorithm
}

resource "tls_private_key" "main" {
  algorithm = local.ssh_key_algorithm
  rsa_bits  = 4096
}
