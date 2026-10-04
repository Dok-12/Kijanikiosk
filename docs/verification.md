# KijaniKiosk Production Server — Verification Record

## Environment

* Target server: To be recorded after confirming the designated lab VM.
* Operating system and version: Pending audit.
* Audit date: Pending.
* Provisioning script revision: Pending.

## Required verification
### Eight-phase provisioning plan

1. **Audit:** Record the operating system, resources, services, network listeners, and firewall state before making changes.
2. **Preflight:** Check required configuration files, script syntax, target OS compatibility, and deployment prerequisites.
3. **Service accounts:** Create the dedicated API, payments, and logging accounts only if they do not already exist.
4. **Filesystem security:** Create required directories and apply the planned ownership, permissions, and ACLs.
5. **Systemd services:** Install and validate the three service units, then enable and start them only after application paths are confirmed.
6. **Logging:** Install log rotation configuration and configure persistent journald with a 500 MB usage limit.
7. **Firewall:** Verify SSH and required application ports, then apply the approved firewall policy with monitoring access restricted to approved sources.
8. **Final verification:** Check service health, permissions, logging, firewall rules, payments hardening, and repeat-run behavior.

**Safety gate:** Apply mode must remain disabled until the designated lab server, its access requirements, application paths, and approved monitoring source addresses are confirmed.

| Check                     | Expected result                                                                                              | Result  |
| ------------------------- | ------------------------------------------------------------------------------------------------------------ | ------- |
| Initial audit             | Existing services, network listeners, disk, memory, and OS recorded                                          | Pending |
| Provisioning idempotency  | Two consecutive runs produce the intended state without duplicate changes                                    | Pending |
| API service               | Correct configuration and healthy service state                                                              | Pending |
| Payments service          | Correct configuration and healthy service state                                                              | Pending |
| Logs service              | Correct configuration and healthy service state                                                              | Pending |
| Log rotation              | Configuration validates and retention policy is present                                                      | Pending |
| Persistent journald       | Persistent storage configured; usage capped at 500 MB                                                        | Pending |
| File permissions and ACLs | Access restricted to required accounts                                                                       | Pending |
| Firewall                  | Required traffic allowed; other incoming traffic restricted                                                  | Pending |
| Monitoring access         | Restricted to approved source addresses                                                                      | Pending |
| Payments hardening        | `systemd-analyze security kk-payments.service` reports a score below 2.5, if compatible with the application | Pending |
| Final audit               | Services and security controls rechecked after provisioning                                                  | Pending |

## Evidence to collect

Record command output, relevant configuration, and any errors for each check. Redact passwords, tokens, private keys, and other secrets before storing evidence in this repository.

## Outstanding issues

All results remain pending until the script has been tested on the designated lab server. Do not record a check as passed without supporting evidence.
