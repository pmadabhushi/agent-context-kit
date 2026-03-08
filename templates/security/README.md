# [ServiceName] — Security Overview

> **For AI agents:** Read `AGENTS.md` for approved tooling, secrets management rules, compliance constraints, and safety guardrails. Do not use this file as your primary instruction source.

## Overview

[ServiceName] is a [brief description of what the service does] with the following security posture:

- **Team:** [Team name]
- **Data classification:** [e.g., Confidential / Internal / Public]
- **Compliance frameworks in scope:** [e.g., SOC2 Type II, PCI-DSS, ISO 27001, HIPAA, FedRAMP]
- **Security contact:** [alias or team name]
- **Vulnerability reporting:** [Link or process — do not open public tickets for security issues]

## Security Architecture

- **Authentication:** [e.g., AWS IAM, OAuth 2.0, SAML]
- **Authorization:** [e.g., RBAC, ABAC, IAM policies]
- **Encryption at rest:** [e.g., AES-256 via AWS KMS]
- **Encryption in transit:** [e.g., TLS 1.2+ required for all external APIs]
- **Secrets management:** [e.g., AWS Secrets Manager, HashiCorp Vault]
- **Threat model:** [Link]

## Compliance Scope

| Framework | Status | Audit Date | Evidence Location |
|---|---|---|---|
| [SOC2 Type II] | [In scope / Certified] | [date] | [link] |
| [PCI-DSS] | [In scope / Certified] | [date] | [link] |
| [ISO 27001] | [In scope / Certified] | [date] | [link] |
| [FedRAMP] | [In scope / Authorized] | [date] | [link] |

## Approved Security Tooling

| Purpose | Approved Tool | Documentation |
|---|---|---|
| SAST (Static Analysis) | [ApprovedScanner] | [Link] |
| Dependency scanning | [DependencyTool] | [Link] |
| Secrets detection | [SecretsScanner] | [Link] |
| Container scanning | [ContainerScanner] | [Link] |

**Only use approved tools.**

## Vulnerability Management

### Severity & SLA

| CVSS Score | Severity | SLA |
|---|---|---|
| 9.0 – 10.0 | Critical | 24 hours |
| 7.0 – 8.9 | High | 7 days |
| 4.0 – 6.9 | Medium | 30 days |
| 0.1 – 3.9 | Low | 90 days |

### Reporting a Vulnerability

1. Do **not** open a public ticket or GitHub issue for security vulnerabilities
2. Report to: [security contact alias or secure reporting channel]
3. Include: affected component, CVSS score (if known), reproduction steps, potential impact

> **Full triage workflow:** See `skills/vuln_triage.md`

## Secrets Management

- All secrets must be stored in [SecretsManager] — never in code, config files, or logs
- Rotate secrets on this schedule: [rotation schedule, e.g., every 90 days]
- If a secret is suspected to be exposed: contact [security contact] immediately
- Secrets rotation runbook: `skills/secrets_rotation.md`

## Access Management

- Access follows the principle of least privilege
- Access reviews are conducted: [frequency, e.g., quarterly]
- Access review runbook: `skills/access_review.md`

## Security Runbooks

| Runbook | Location |
|---|---|
| Vulnerability triage | `skills/vuln_triage.md` |
| Incident response | `skills/incident_response.md` |
| Secrets rotation | `skills/secrets_rotation.md` |
| Access review | `skills/access_review.md` |

## Contact

- **Team:** [Team name] — [team alias or Slack/Chime channel]
- **Security issues:** [security contact] — **do not open public tickets**
- **Compliance questions:** [compliance team contact]
