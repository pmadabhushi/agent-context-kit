# AGENTS.md — Security (Mainspring Energy)

> This file is read automatically by AI security agents at session start.

## Security Overview

- **Platform:** FleetOS — fleet management and telemetry for deployed linear generators
- **Data classification:** Customer site data (Confidential), Telemetry (Internal), Public specs (Public)
- **Compliance frameworks:** SOC2 Type II, NERC CIP (for utility customers), state emissions reporting
- **Security contact:** security@mainspring.io
- **Vulnerability reporting:** security@mainspring.io — do not open public issues

## Threat Landscape

Mainspring operates at the intersection of IT and OT (Operational Technology):
- **IT side:** Cloud platform (AWS), APIs, customer portal, CI/CD pipeline
- **OT side:** Edge gateways at customer sites, MQTT communication to field units, firmware updates
- **Key risk:** A compromised edge gateway or dispatch command could affect physical power generation equipment

## Approved Tooling

| Purpose | Approved Tool | Command |
|---|---|---|
| SAST | Semgrep | `semgrep scan --config auto` |
| Dependency scanning | Snyk | `snyk test` |
| Container scanning | Trivy | `trivy image [image-name]` |
| Secrets detection | Gitleaks | `gitleaks detect --source .` |
| OT network scanning | Nmap (authorized scans only) | Requires security team approval |

## Secrets Management

- All secrets stored in AWS Secrets Manager
- Edge gateway credentials rotated every 90 days via automated pipeline
- MQTT TLS certificates renewed annually
- If a secret is suspected exposed: notify security@mainspring.io immediately

## Vulnerability Severity Matrix

| CVSS Score | Severity | SLA | Action |
|---|---|---|---|
| 9.0–10.0 | Critical | 24 hours | Immediate escalation, isolate affected systems |
| 7.0–8.9 | High | 7 days | Create ticket, notify service owner |
| 4.0–6.9 | Medium | 30 days | Create ticket, assign to team |
| 0.1–3.9 | Low | 90 days | Log and track |

**OT-specific rule:** Any vulnerability affecting edge gateways or dispatch commands is automatically elevated one severity level due to physical safety implications.

## Safety Rules

- **Never** dismiss a security finding without documented rationale
- **Never** suggest disabling security controls as a workaround
- **Never** test against production edge gateways without explicit approval
- **OT boundary:** Treat the edge gateway network as a separate security zone — no direct cloud-to-unit access
- Escalate any finding affecting dispatch commands or firmware update pipeline immediately

## Skills Available

| Skill | File | When to Load |
|---|---|---|
| Vulnerability Triage | `skills/vuln_triage.md` | When processing a security finding |
| OT Security Review | `skills/ot_security_review.md` | When reviewing edge/OT security |
| Access Review | `skills/access_review.md` | When reviewing platform or fleet access |

## Persona

| Persona | File | When to Load |
|---|---|---|
| Security Analyst | `persona.md` | Default persona for all security tasks |

## References

- Threat model: https://wiki.internal.mainspring.io/security/threat-model
- NERC CIP compliance guide: https://wiki.internal.mainspring.io/security/nerc-cip
- Incident response playbook: https://wiki.internal.mainspring.io/security/ir-playbook
- OT security architecture: https://wiki.internal.mainspring.io/security/ot-architecture
