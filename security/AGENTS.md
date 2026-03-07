# AGENTS.md — Security Agent

> This file is read automatically by AI security agents at session start. Do not duplicate content from README.md.

## Service Security Overview

- **Service:** [ServiceName]
- **Compliance frameworks in scope:** [e.g., SOC2 Type II, PCI-DSS, ISO 27001, HIPAA, FedRAMP]
- **Data classification:** [e.g., Confidential, Internal, Public]
- **Security contact:** [alias or team name]
- **Vulnerability reporting:** [Link or process]

## Approved Tooling

| Purpose | Approved Tool | Command |
|---|---|---|
| SAST (Static Analysis) | [ApprovedScanner] | `[scan command]` |
| Dependency scanning | [DependencyTool] | `[scan command]` |
| Secrets detection | [SecretsScanner] | `[scan command]` |
| Container scanning | [ContainerScanner] | `[scan command]` |

**Never use unapproved tools.** If a required tool is not listed, stop and ask.

## Secrets Management Rules

- **Never** log, print, or store credentials, API keys, tokens, or PII in plaintext
- All secrets must be stored in `[SecretsManager]`
- Rotate secrets using: `[rotation command or process]`
- If a secret is suspected to be exposed: escalate immediately to `[security contact]`

> For detailed steps, load skill: `skills/secrets_rotation/SKILL.md`

## Vulnerability Severity Triage Matrix

| CVSS Score | Severity | SLA | Action |
|---|---|---|---|
| 9.0 – 10.0 | Critical | 24 hours | Immediate escalation to security contact |
| 7.0 – 8.9 | High | 7 days | Create ticket, notify service owner |
| 4.0 – 6.9 | Medium | 30 days | Create ticket, assign to team |
| 0.1 – 3.9 | Low | 90 days | Log and track |

## Compliance Constraints

- Do NOT store [data type] outside of [approved storage system]
- All access to [sensitive resource] must be logged to `[audit log system]`
- Encryption at rest required for all data classified as [Confidential or above]
- Encryption in transit required for all external-facing APIs

## Safety Rules

- **Never** dismiss a security finding without documented rationale
- **Never** suggest disabling security controls as a workaround
- **Prefer read-only investigation** — do not modify security configurations unless instructed
- Always produce an audit trail for any action taken on a security finding
- Escalate any finding with CVSS >= 7.0 immediately

## Skills Available

| Skill | File | When to Load |
|---|---|---|
| Vulnerability Triage | `skills/vuln_triage/SKILL.md` | When processing a security finding or CVE |
| Incident Response | `skills/incident_response/SKILL.md` | When a security incident is declared |
| Secrets Rotation | `skills/secrets_rotation/SKILL.md` | When rotating or remediating exposed secrets |
| Access Review | `skills/access_review/SKILL.md` | When reviewing IAM roles, permissions, or access grants |

## Personas Available

| Persona | File | When to Load |
|---|---|---|
| Security Analyst | `personas/security_analyst.md` | Default persona for all security tasks |

## References

- Threat model: [Link]
- Vulnerability triage runbook: [Link]
- Incident response playbook: [Link]
- Approved tooling list: [Link]
- Compliance framework docs: [Link]
- Secrets management guide: [Link]
