# KijaniKiosk Production Server — Security Decisions

## Purpose

This document explains the security measures planned for the KijaniKiosk production server and why they matter.

## 1. Separate service accounts

The API, payments, and logging services will run under separate, dedicated accounts instead of a shared administrator account. If one service is compromised, this limits its ability to access the other services.

## 2. Restrict file access

Application files will be owned by the appropriate service account or administrator. Permissions and, where necessary, access-control lists (ACLs) will grant only the access required for each service. Secrets will not be readable by unrelated users.

## 3. Harden systemd services

Services will use systemd security controls such as `NoNewPrivileges`, `PrivateTmp`, and `ProtectSystem`. The payments service will receive additional restrictions where compatible with the application. These controls reduce the system resources and privileges available to a compromised service.

## 4. Manage logs safely

Log rotation will prevent application log files from growing without limit. Rotated logs will be compressed, and retention will be limited to 14 rotations. Access to log files will be restricted because logs can contain operational details or sensitive information.

## 5. Preserve diagnostic records

The system journal will use persistent storage so that relevant service records can remain available after a reboot. Its configured storage limit will be 500 MB to help prevent logs from consuming excessive disk space.

## 6. Restrict network access

The host firewall will follow a deny-by-default approach for incoming traffic, with only explicitly required services permitted. Monitoring access will be limited to approved sources. Before applying firewall rules, existing access requirements and the active SSH connection must be checked to avoid locking out administrators.

## 7. Verify before deployment

The existing host configuration must be audited before changes are made. The provisioning process will be designed to be idempotent: rerunning it should not create duplicate configuration or progressively change the intended state. Service health, firewall rules, permissions, journald limits, and systemd security settings will be checked after deployment.

## Risks and operational trade-offs

Stricter service restrictions can prevent an application from working if it relies on unapproved files, devices, system calls, or network behavior. Firewall changes can interrupt legitimate access. Logs can contain sensitive information, and retention limits mean older records may no longer be available.

For these reasons, configuration changes must be tested against the actual application and verified on the designated lab server before being treated as complete.
