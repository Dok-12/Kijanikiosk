# KijaniKiosk Executive Hardening Decisions

## Purpose

This document explains the main security decisions implemented for the KijaniKiosk production foundation. The goal is to reduce the impact of a compromised application while keeping the deployment repeatable through Terraform and Ansible.

The design separates the API, payments, and logging workloads onto three logical servers. Terraform creates the infrastructure and Ansible applies the operating-system configuration. This separation means infrastructure and security settings can be recreated consistently rather than configured manually.

## Security controls and risk mapping

| Control | Implementation | Risk reduced |
|---|---|---|
| Dedicated service accounts | `kk-api`, `kk-payments`, and `kk-logs` run as non-root users | Limits damage if an application is compromised |
| Systemd privilege restrictions | `NoNewPrivileges=true` on services | Prevents processes from gaining additional privileges |
| Read-only operating system | `ProtectSystem=strict` | Reduces unauthorized modification of system files |
| Home directory protection | `ProtectHome=true` | Prevents access to user home directories |
| Private temporary storage | `PrivateTmp=true` | Reduces cross-service access to temporary files |
| Payments device isolation | `PrivateDevices=true` | Prevents unnecessary hardware-device access |
| Kernel protection | `ProtectKernelTunables`, `ProtectKernelModules`, and `ProtectKernelLogs` | Reduces access to sensitive kernel interfaces |
| Capability reduction | Payments service uses an empty capability bounding set | Removes unnecessary Linux privileges |
| Process isolation | `ProtectProc=invisible` and `ProcSubset=pid` | Limits visibility into other processes |
| Namespace restrictions | `RestrictNamespaces=true` | Prevents creation of additional isolation namespaces |
| Network restriction | Payments allows only required Unix and IP address families | Reduces unnecessary networking capability |
| File permission restriction | `UMask=0077` | Prevents newly created files from being unnecessarily exposed |
| Persistent logging | Journald uses persistent storage with a 500 MB limit | Preserves operational evidence while controlling disk usage |
| Log rotation | Daily rotation, compression, and 14 retained rotations | Reduces disk exhaustion risk |
| Host firewall | UFW denies incoming traffic by default and allows SSH | Reduces unnecessary network exposure |

The payments service received the strongest hardening because payment processing is the highest-impact workload. `systemd-analyze security` was used to measure the result. The initial exposure score was 6.5 (MEDIUM). After applying additional restrictions, the score became **1.1 (OK)**, comfortably below the required 2.5 threshold.

## Infrastructure and deployment controls

Terraform provisions three independent Multipass servers using a reusable application-server module and `for_each`. Server addresses are obtained dynamically after creation rather than being permanently embedded in Ansible configuration.

The pipeline generates the Ansible inventory from Terraform outputs. It then verifies SSH connectivity before applying the configuration. This removes the need to manually maintain server IP addresses and reduces configuration drift.

Ansible implements the production foundation in seven phases: package installation, service-account creation, directory creation, systemd configuration, firewall configuration, journald configuration, and logrotate configuration. Templates and handlers are used so configuration changes can be applied consistently.

Idempotency was verified by running the complete pipeline twice. The second run reported no Terraform changes and `changed=0` for API, payments, and logs. This demonstrates that the deployment can be repeated without continuously modifying the servers.

## Logging and operational resilience

Persistent journald storage ensures that service and system events survive a restart. The 500 MB journal limit prevents uncontrolled journal growth. Application logs are rotated daily, compressed, and retained for fourteen rotations.

The design intentionally keeps logging separate from application services. The logging server has its own service account and filesystem permissions, reducing the chance that an application compromise automatically provides write access to unrelated service data.

## Known gaps and limitations

This environment is a local lab implementation using Multipass rather than a production cloud provider. It demonstrates the infrastructure-as-code and configuration-management workflow, but it does not provide production-grade availability, managed networking, centralized identity, or cloud-native monitoring.

The pipeline also uses a local MinIO S3-compatible backend for Terraform state. MinIO provides remote state storage for this exercise, but the selected lab configuration should not be treated as a production state-locking design. Concurrent Terraform executions could create state-management risks if locking is not reliably supported.

For production, Terraform state should use a backend with dependable locking and access controls. Suitable alternatives include an S3-compatible backend with reliable lock-file support, DynamoDB-based locking, Google Cloud Storage locking, or a Consul-based locking mechanism. Access credentials should also be supplied through a secure secrets mechanism rather than stored in configuration.

The service start scripts used in this lab are deliberately minimal placeholders. They prove service ownership, permissions, systemd hardening, startup behavior, and idempotency, but they are not the final application implementations.

## Executive conclusion

The Week 4 foundation establishes a repeatable security baseline. Infrastructure is provisioned through Terraform, operating-system configuration is enforced through Ansible, and the pipeline connects both layers using dynamically generated inventory.

The strongest evidence is repeatability: Terraform reports zero changes on the second run, all three Ansible hosts report `changed=0`, and the payments service remains active after hardening. The payments security score of 1.1 demonstrates that the most sensitive workload has been substantially restricted.

Before production use, the organization should replace the lab infrastructure and state backend with production-supported services, implement secure secret management, deploy the real application processes, and add monitoring and alerting. The current design should therefore be viewed as a secure and repeatable foundation rather than a complete production platform.
