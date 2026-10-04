
#!/usr/bin/env bash
#
# KijaniKiosk Production Server Foundation
#
# Usage:
#   bash scripts/provision.sh --check
#   sudo bash scripts/provision.sh --audit
#   sudo bash scripts/provision.sh --apply
#
set -Eeuo pipefail
IFS=$'\n\t'
umask 027

SCRIPT_NAME="kk-provision"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname -- "$SCRIPT_DIR")"

log() {
    printf '[%s] [%s] %s\n' \
        "$(date --iso-8601=seconds)" "$SCRIPT_NAME" "$*" >&2
}

die() {
    log "ERROR: $*"
    exit 1
}

require_root() {
    [[ "$EUID" -eq 0 ]] || die "Run this mode with sudo."
}

check_files() {
    log "Checking required project files..."

    local file
    for file in \
        scripts/provision.sh \
        systemd/kk-api.service \
        systemd/kk-payments.service \
        systemd/kk-logs.service \
        logrotate/kk-services \
        journald/10-kijanikiosk.conf \
        docs/security-decisions.md \
        docs/verification.md
    do
        [[ -f "$PROJECT_DIR/$file" ]] ||
            die "Required file is missing: $file"
        log "Found: $file"
    done

    log "Checking Bash syntax..."
    bash -n "$PROJECT_DIR/scripts/provision.sh"

    if command -v systemd-analyze >/dev/null 2>&1; then
        log "Checking systemd unit definitions..."

        local unit
        for unit in "$PROJECT_DIR"/systemd/*.service; do
            if systemd-analyze verify --man=no "$unit" 2>&1; then
                log "Unit check passed: $(basename "$unit")"
            else
                log "Unit template has unresolved deployment requirements: $(basename "$unit")"
                log "Review ExecStart paths and dependencies before deployment."
            fi
        done
    else
        log "systemd-analyze unavailable; unit validation skipped."
    fi

    log "Configuration preflight completed."
}

audit_host() {
    require_root
    log "Phase 1/8: Read-only host audit"

    log "Hostname: $(hostname)"
    log "Operating system:"
    cat /etc/os-release

    log "Kernel: $(uname -r)"
    log "Root filesystem:"
    df -h /

    log "Memory:"
    free -h

    log "Listening sockets:"
    ss -tulpn || true

    log "Firewall status:"
    if command -v ufw >/dev/null 2>&1; then
        ufw status verbose || true
    else
        log "UFW is not installed."
    fi

    log "Relevant service states:"
    local service
    for service in kk-api kk-payments kk-logs; do
        systemctl status "${service}.service" --no-pager || true
    done
}

main() {
    case "${1:---check}" in
        --check)
            check_files
            ;;
        --audit)
            require_root
            audit_host
            ;;
        --apply)
            die "Apply mode remains disabled pending target and configuration verification."
            ;;
        *)
            die "Usage: $0 [--check|--audit|--apply]"
            ;;
    esac
}

main "$@"
