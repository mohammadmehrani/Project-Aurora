# Project Aurora — Azure Infrastructure Automation

[![CI/CD Pipeline](https://github.com/mohammadmehrani/Project-Aurora/actions/workflows/main.yml/badge.svg)](https://github.com/mohammadmehrani/Project-Aurora/actions/workflows/main.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Terraform](https://img.shields.io/badge/Terraform-≥_1.6-844FBA.svg)](https://www.terraform.io)
[![Azure](https://img.shields.io/badge/Azure-Infrastructure-0078D4.svg)](https://azure.microsoft.com)

Production-grade Infrastructure-as-Code for deploying a resilient, auto-scaling, fully-monitored web infrastructure on Microsoft Azure.

---

## Architecture

```
Azure Front Door (CDN + WAF)
       │
       ▼
Azure Application Gateway (SSL/TLS, WAF v2)
       │
       ▼
Azure Load Balancer (Standard, HA)
       │
       ▼
┌─────────────────────────────────┐
│  VM Scale Set  (Ubuntu 24.04)  │
│  Auto-scale: 1–10 instances    │
│  Premium SSD, health probes    │
└─────────────────────────────────┘
       │
       ├── Azure Monitor (Metrics, Logs, Alerts)
       ├── Azure Key Vault (Secrets, SSH keys)
       ├── Azure Bastion (Secure admin access)
       ├── Azure Backup (Daily retention)
       └── Log Analytics + App Insights
```

## Key Features

| Feature | Implementation |
|---|---|
| **Infrastructure as Code** | Terraform (HCL) with modular, reusable components |
| **Configuration Management** | Ansible — Nginx deployment, security hardening |
| **CI/CD** | GitHub Actions — security scan, plan, multi-env deploy |
| **Auto-scaling** | CPU-based scale-out (>75%) and scale-in (<30%), 1–10 instances |
| **High Availability** | Load Balancer, health probes, fault domains |
| **Security** | SSH key auth, Key Vault, NSG with least-privilege, WAF-ready |
| **Monitoring** | Azure Monitor, Application Insights, Log Analytics, metric alerts |
| **Backup & DR** | Recovery Services Vault, daily backup with monthly/yearly retention |
| **Secure Access** | Azure Bastion — no public VM endpoints |
| **Encryption** | Infrastructure double encryption, TLS 1.2+, HTTPS-only |
| **Multi-environment** | Dev → Staging → Production with manual approval gates |

## Tech Stack

| Technology | Purpose | Version |
|---|---|---|
| **Terraform** | Cloud provisioning | ≥ 1.6 |
| **Ansible** | Config management | Latest |
| **Azure** | Cloud provider | — |
| **Ubuntu** | VM OS | 24.04 LTS (Noble Numbat) |
| **Nginx** | Web server | Latest stable |
| **GitHub Actions** | CI/CD | — |

## Quick Start

### Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) ≥ 1.6
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- Azure subscription with [Owner](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#owner) or [Contributor](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#contributor) access

### 1. Authenticate to Azure

```bash
az login
az account set --subscription "<SUBSCRIPTION_ID>"
```

### 2. Create Terraform State Backend

```bash
az group create --name Project-Aurora-tfstate --location "UK South"
az storage account create --name projectauroratfstate --resource-group Project-Aurora-tfstate --sku Standard_LRS --allow-blob-public-access false
az storage container create --name tfstate --account-name projectauroratfstate
```

### 3. Deploy

```bash
# Initialize
make init

# Preview changes
make plan ENVIRONMENT=dev

# Apply
make apply ENVIRONMENT=dev
```

Or step by step:

```bash
cd terraform
terraform init
TF_VAR_environment=dev TF_VAR_branch_name=$(git rev-parse --abbrev-ref HEAD) terraform plan
TF_VAR_environment=dev TF_VAR_branch_name=$(git rev-parse --abbrev-ref HEAD) terraform apply
```

### 4. Access

After deployment, the Load Balancer public IP is shown as output:

```bash
make output
# Or: cd terraform && terraform output
```

Visit `http://<LOAD_BALANCER_IP>` in your browser.

## Project Structure

```
├── .github/workflows/        # CI/CD pipeline (security scan, plan, apply)
├── ansible/
│   ├── setup.sh              # VM bootstrap script
│   ├── playbooks/
│   │   ├── install-nginx.yml # Main playbook
│   │   └── roles/nginx-setup/
│   │       ├── tasks/        # Role tasks
│   │       ├── handlers/     # Service management
│   │       └── templates/    # Jinja2 templates
├── terraform/
│   ├── main.tf               # Root configuration
│   ├── providers.tf          # Provider + backend config
│   ├── variables.tf          # Input variables
│   ├── outputs.tf            # Output values
│   ├── locals.tf             # Local values + tags
│   └── modules/
│       ├── resource_group/   # Azure Resource Group
│       ├── vnet_and_subnet/  # VNet + subnets
│       ├── nsg/              # Network Security Group
│       ├── storage_account/  # Encrypted storage
│       ├── key_vault/        # Secrets management
│       ├── lb_and_pip/       # Load Balancer + Public IP
│       ├── vmss/             # VM Scale Set (auto-scaling)
│       ├── vmss_extension/   # VM extensions (Ansible, Azure Monitor)
│       ├── bastion/          # Azure Bastion host
│       ├── monitoring/       # Log Analytics, App Insights, Alerts
│       └── backup/           # Recovery Services Vault
├── Makefile                  # Developer automation
├── .pre-commit-config.yaml   # Pre-commit hooks
├── .tflint.hcl               # TFLint config
└── README.md
```

## Environments

| Environment | Branch Trigger | Approval Required | Purpose |
|---|---|---|---|
| **dev** | `dev`, `main`, `feature/*` | No | Development & testing |
| **staging** | `main` | No | Pre-production validation |
| **production** | `main` (tag) | **Manual** | Production workloads |

## Security

- **Zero hardcoded secrets** — All passwords generated at runtime or stored in Key Vault
- **SSH key authentication** — Disabled password auth on all VMs
- **Network isolation** — No public IPs on VMs; Bastion-only access
- **Encryption at rest** — Infrastructure double encryption on storage
- **Encryption in transit** — TLS 1.2+ enforced, HTTPS-only
- **Security scanning** — Checkov + Trivy on every commit
- **RBAC** — Key Vault uses Azure RBAC; least-privilege NSG rules

## Monitoring & Alerts

| Alert | Condition | Action |
|---|---|---|
| High CPU | > 80% for 5 minutes | Email notification |
| Low CPU | < 20% for 5 minutes | Email notification (idle detection) |
| Unhealthy Hosts | Any VM unhealthy | Email notification |
| Auto-scale events | Scale-in/out actions | Logged to Log Analytics |

## Cost Optimization

| Feature | Savings |
|---|---|
| **Auto-scaling** | Scale to 1 instance at low traffic |
| **Premium SSD** | Only for OS disk (64 GB) |
| **Reserved instances** | Recommended for 1+ year commitment |
| **Dev/Test** | Use smaller SKUs (`Standard_B2s`) in dev |
| **Azure Hybrid Benefit** | Use existing Windows Server licenses |

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on the contribution workflow.

## License

Distributed under the [MIT License](LICENSE).

## Acknowledgments

Built with ❤️ using Terraform, Ansible, and Azure. Inspired by production infrastructure patterns at scale.
