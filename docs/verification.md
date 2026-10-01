# KijaniKiosk Production Server — Verification Record

## Environment

* Target server: To be recorded after confirming the designated lab VM.
* Operating system and version: Pending audit.
* Audit date: Pending.
* Provisioning script revision: Pending.

## Required verification

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
