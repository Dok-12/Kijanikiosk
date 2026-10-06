#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

log() {
    printf '[pipeline] %s\n' "$1"
}

log "Starting Terraform"
terraform -chdir=terraform init -reconfigure
terraform -chdir=terraform apply -auto-approve

log "Reading dynamically assigned server IPs"
API_IP="$(terraform -chdir=terraform output -raw api_ip)"
PAYMENTS_IP="$(terraform -chdir=terraform output -raw payments_ip)"
LOGS_IP="$(terraform -chdir=terraform output -raw logs_ip)"

log "API server: ${API_IP}"
log "Payments server: ${PAYMENTS_IP}"
log "Logs server: ${LOGS_IP}"

log "Generating dynamic Ansible inventory"

cat > ansible/inventory.ini <<INVENTORY
[api_servers]
api ansible_host=${API_IP}

[payments_servers]
payments ansible_host=${PAYMENTS_IP}

[logs_servers]
logs ansible_host=${LOGS_IP}

[kijanikiosk:children]
api_servers
payments_servers
logs_servers

[kijanikiosk:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=${HOME}/.ssh/kijanikiosk_ed25519
ansible_python_interpreter=/usr/bin/python3
INVENTORY

log "Checking SSH/Ansible connectivity"
ansible -i ansible/inventory.ini kijanikiosk -m ping

log "Applying Ansible configuration"
ansible-playbook -i ansible/inventory.ini ansible/kijanikiosk.yml

log "Pipeline completed successfully"
