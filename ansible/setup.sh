#!/bin/bash
set -euo pipefail

# ============================================================
# Project Aurora - VM Bootstrap Script
# Securely provisions Nginx with monitoring and security hardening
# ============================================================

BRANCH_NAME="${BRANCH_NAME:-main}"
ENVIRONMENT="${ENVIRONMENT:-dev}"
LOG_FILE="/var/log/aurora-bootstrap.log"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

log "Starting Project Aurora bootstrap for environment: $ENVIRONMENT"

# --- Update system packages ---
log "Updating system packages..."
sudo apt-get update -qq
sudo apt-get upgrade -y -qq

# --- Install dependencies ---
log "Installing essential packages..."
sudo apt-get install -y -qq \
  ansible \
  unzip \
  curl \
  wget \
  gnupg \
  ca-certificates \
  lsb-release \
  ubuntu-advantage-tools

# --- Apply security hardening ---
log "Applying security hardening..."

# Disable root SSH login
sudo sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sudo systemctl restart sshd

# Set up automatic security updates
sudo tee /etc/apt/apt.conf.d/20auto-upgrades > /dev/null << 'EOF'
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "1";
EOF

# --- Configure Azure Monitor Agent logging ---
log "Configuring Azure Monitor..."
sudo mkdir -p /etc/azure
sudo tee /etc/azure/environment > /dev/null << 'EOF'
environment=azure
EOF

# --- Fetch and run Ansible playbook ---
log "Fetching Ansible playbooks from branch: $BRANCH_NAME..."
DOWNLOAD_URL="https://github.com/mohammadmehrani/Project-Aurora/archive/refs/heads/${BRANCH_NAME}.zip"

wget -q "$DOWNLOAD_URL" -O /tmp/project-aurora.zip
unzip -q /tmp/project-aurora.zip -d /tmp
sudo find /tmp -maxdepth 1 -type d -name 'Project-Aurora*' -exec mv {} /tmp/Project-Aurora \;

log "Running Ansible playbook..."
cd /tmp/Project-Aurora/ansible
ansible-playbook ./playbooks/install-nginx.yml --extra-vars "environment=${ENVIRONMENT}" 2>&1 | tee -a "$LOG_FILE"

# --- Setup custom health check endpoint ---
log "Setting up health check endpoint..."
sudo mkdir -p /var/www/html
sudo tee /var/www/html/health > /dev/null << 'EOF'
{"status":"healthy","service":"nginx","timestamp":"__TIMESTAMP__"}
EOF
sudo sed -i "s/__TIMESTAMP__/$(date -u +%Y-%m-%dT%H:%M:%SZ)/" /var/www/html/health

# --- Configure Nginx for health checks ---
sudo tee /etc/nginx/sites-available/health > /dev/null << 'EOF'
server {
    listen 80;
    server_name _;

    location /health {
        alias /var/www/html/health;
        default_type application/json;
        add_header Cache-Control no-store;
    }

    location / {
        root /var/www/html;
        index index.html;
        add_header X-VM-Hostname "$hostname" always;
        add_header X-Environment "$ENVIRONMENT" always;
    }
}
EOF

# Replace variables in nginx config
sudo sed -i "s/\$hostname/$(hostname)/" /etc/nginx/sites-available/health
sudo sed -i "s/\$ENVIRONMENT/$ENVIRONMENT/" /etc/nginx/sites-available/health

# Enable the site
sudo rm -f /etc/nginx/sites-enabled/default
sudo ln -sf /etc/nginx/sites-available/health /etc/nginx/sites-enabled/

# --- Finalize ---
log "Reloading Nginx..."
sudo systemctl reload nginx

log "Project Aurora bootstrap completed successfully!"
log "Hostname: $(hostname)"
log "Environment: $ENVIRONMENT"
