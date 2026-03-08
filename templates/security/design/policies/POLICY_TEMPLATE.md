# Security Policy: [PolicyName]

This document defines the [PolicyName] policy, including requirements, enforcement mechanisms, exceptions, and compliance mapping.

> **Related**: For threat context, see `design/threat_models/`. For technical controls implementing this policy, see `design/controls/`.

## Overview

[One-paragraph description of the policy, what it governs, why it exists, and what happens if it's violated.]

## Policy Metadata

| Field | Value |
|-------|-------|
| **Policy ID** | [e.g., SEC-POL-001] |
| **Applies to** | [e.g., All production services, All team members, Specific service] |
| **Classification** | [Mandatory / Recommended / Advisory] |
| **Compliance requirement** | [e.g., SOC2 CC6.1, PCI-DSS Req 8, HIPAA §164.312] |
| **Effective date** | [date] |
| **Last reviewed** | [date] |
| **Next review due** | [date] |
| **Review cadence** | [e.g., Quarterly, Annually] |
| **Policy owner** | [team or person] |
| **Approved by** | [name / role] |

## Policy Statement

[Clear, concise statement of what is required, prohibited, or expected. This should be unambiguous and actionable.]

## Scope

### In Scope
- [e.g., All production AWS accounts]
- [e.g., All services handling customer data classified as Confidential or above]
- [e.g., All team members with production access]
- [e.g., All CI/CD pipelines deploying to production]

### Out of Scope
- [e.g., Development/sandbox accounts (covered by separate policy)]
- [e.g., Third-party SaaS tools (covered by vendor security review)]

## Requirements

### [Requirement Group 1: e.g., Access Control]

| # | Requirement | Enforcement | Evidence | Compliance Mapping |
|---|-------------|-------------|----------|-------------------|
| 1.1 | [All production access must use MFA] | [IAM policy: `aws:MultiFactorAuthPresent`] | [IAM policy audit report] | [SOC2 CC6.1] |
| 1.2 | [No long-lived access keys for human users] | [IAM Access Analyzer alert] | [Access key age report] | [SOC2 CC6.1] |
| 1.3 | [Service roles must use least-privilege policies] | [IAM Access Analyzer, manual review] | [Policy review checklist] | [SOC2 CC6.3] |
| 1.4 | [Access reviews must be completed quarterly] | [Manual process, ticketed] | [Access review ticket] | [SOC2 CC6.2] |

### [Requirement Group 2: e.g., Data Protection]

| # | Requirement | Enforcement | Evidence | Compliance Mapping |
|---|-------------|-------------|----------|-------------------|
| 2.1 | [All data at rest must be encrypted with KMS] | [AWS Config rule, CDK construct] | [Config compliance report] | [PCI-DSS Req 3.4] |
| 2.2 | [All data in transit must use TLS 1.2+] | [ALB/NLB TLS policy, API Gateway config] | [TLS scan report] | [PCI-DSS Req 4.1] |
| 2.3 | [PII must not appear in logs] | [Log scrubbing library, CI scan] | [Log audit sample] | [HIPAA §164.312] |
| 2.4 | [Customer data must not leave approved regions] | [S3 bucket policy, IAM conditions] | [Config compliance report] | [Data residency] |

### [Requirement Group 3: e.g., Secrets Management]

| # | Requirement | Enforcement | Evidence | Compliance Mapping |
|---|-------------|-------------|----------|-------------------|
| 3.1 | [All secrets must be stored in Secrets Manager or SSM SecureString] | [Pre-commit hook, CI secrets scan] | [Scan report] | [SOC2 CC6.1] |
| 3.2 | [Secrets must be rotated every [N] days] | [Secrets Manager auto-rotation] | [Rotation audit log] | [PCI-DSS Req 8.2.4] |
| 3.3 | [Exposed secrets must be rotated within [N] hours] | [Incident response process] | [Incident ticket] | [SOC2 CC7.3] |

### [Requirement Group 4: e.g., Logging & Audit]

| # | Requirement | Enforcement | Evidence | Compliance Mapping |
|---|-------------|-------------|----------|-------------------|
| 4.1 | [CloudTrail must be enabled in all accounts] | [AWS Organizations SCP] | [CloudTrail status report] | [SOC2 CC7.2] |
| 4.2 | [Audit logs must be retained for [N] years] | [S3 lifecycle policy, CloudWatch retention] | [Retention config audit] | [SOC2 CC7.2] |
| 4.3 | [All production changes must be logged with actor identity] | [CloudTrail, application audit log] | [Log sample review] | [SOC2 CC8.1] |

## Implementation Guide

### For Service Teams

1. [Step 1: e.g., Review your IAM policies against the least-privilege checklist]
2. [Step 2: e.g., Enable KMS encryption on all data stores using the approved CDK construct]
3. [Step 3: e.g., Integrate the secrets scanning pre-commit hook]
4. [Step 4: e.g., Configure log retention per the retention matrix]
5. [Step 5: e.g., Schedule quarterly access review using the review template]

### For New Services

- [ ] [Complete threat model before launch (`design/threat_models/`)]
- [ ] [Pass security review checklist]
- [ ] [Enable all required controls (`design/controls/`)]
- [ ] [Configure monitoring and alerting per this policy]
- [ ] [Document exceptions if any]

## Enforcement

### Automated Enforcement

| Mechanism | What It Checks | Action on Violation | Bypass |
|-----------|---------------|-------------------|--------|
| [AWS Config rule] | [Encryption at rest enabled] | [Alert + auto-remediate] | [Exception required] |
| [CI pipeline gate] | [No secrets in code] | [Block merge] | [No bypass] |
| [IAM SCP] | [Deny actions without MFA] | [Deny API call] | [Break-glass role] |
| [Pre-commit hook] | [No PII in logs, no hardcoded secrets] | [Block commit] | [Override with justification] |

### Manual Enforcement

| Process | Frequency | Owner | Evidence |
|---------|-----------|-------|----------|
| [Access review] | [Quarterly] | [Security team] | [Review ticket with findings] |
| [Policy review] | [Annually] | [Policy owner] | [Updated policy document] |
| [Penetration test] | [Annually] | [Security team] | [Pentest report] |

### Violation Response

| Severity | Example | Response | Timeline |
|----------|---------|----------|----------|
| Critical | [Secrets exposed in public repo] | [Immediate rotation, incident declared, post-mortem] | [< 1 hour] |
| High | [Production access without MFA] | [Access revoked, remediation ticket] | [< 24 hours] |
| Medium | [Missing encryption on non-prod data store] | [Remediation ticket, tracked to completion] | [< 7 days] |
| Low | [Log retention below policy minimum] | [Remediation ticket] | [< 30 days] |

## Exceptions

### Active Exceptions

| # | Exception | Justification | Approved By | Approval Date | Expiry | Review |
|---|-----------|--------------|------------|---------------|--------|--------|
| [1] | [Description] | [Why this exception is needed] | [Name/Role] | [date] | [date] | [Quarterly] |

### Exception Request Process

1. [Submit exception request via [ticketing system] with justification]
2. [Security team reviews within [N] business days]
3. [If approved: documented here with expiry date and review cadence]
4. [If denied: alternative approach recommended]
5. [All exceptions reviewed at expiry — must be re-approved or remediated]

### Exception Criteria

Exceptions may be granted when:
- [Technical limitation prevents compliance (with compensating control)]
- [Business-critical timeline requires temporary exception (with remediation plan)]
- [Risk is formally accepted by [role] with documented rationale]

Exceptions will NOT be granted for:
- [Disabling security controls without compensating control]
- [Indefinite exceptions without review cadence]
- [Exceptions that would violate regulatory requirements]

## Compliance Mapping

| Requirement | SOC2 | PCI-DSS | HIPAA | ISO 27001 | FedRAMP |
|-------------|-------|---------|-------|-----------|---------|
| [1.1 MFA required] | CC6.1 | Req 8.3 | §164.312(d) | A.9.4.2 | AC-7 |
| [2.1 Encryption at rest] | CC6.7 | Req 3.4 | §164.312(a)(2)(iv) | A.10.1.1 | SC-28 |
| [3.1 Secrets in Secrets Manager] | CC6.1 | Req 8.2 | §164.312(a)(1) | A.9.2.4 | IA-5 |
| [4.1 CloudTrail enabled] | CC7.2 | Req 10.1 | §164.312(b) | A.12.4.1 | AU-2 |

## Metrics & Reporting

| Metric | Target | Current | Trend | Dashboard |
|--------|--------|---------|-------|-----------|
| [% accounts with MFA enforced] | [100%] | [X%] | [↑/↓/→] | [link] |
| [% data stores encrypted] | [100%] | [X%] | [↑/↓/→] | [link] |
| [Mean time to rotate exposed secret] | [< 1 hour] | [X hours] | [↑/↓/→] | [link] |
| [Access review completion rate] | [100%] | [X%] | [↑/↓/→] | [link] |
| [Open policy violations] | [0 critical/high] | [X] | [↑/↓/→] | [link] |

## Related Documents

- Threat models: `design/threat_models/`
- Security controls: `design/controls/`
- Incident response playbook: [Link]
- Access review template: [Link]
- Security review checklist: [Link]
- Compliance evidence repository: [Link]
- [Related policy 1]: [Link]
- [Related policy 2]: [Link]
