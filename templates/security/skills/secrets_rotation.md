# SKILL: Secrets Rotation

**Skill ID:** secrets_rotation
**Domain:** Security
**Trigger:** User asks to rotate secrets; a secret is suspected or confirmed to be exposed; a credential is expiring; or post-incident remediation requires credential rotation
**Load from:** `skills/secrets_rotation.md`

## Prerequisites

- [ ] You have identified the secret(s) to be rotated (type, name, affected service)
- [ ] You know the trigger: routine rotation / suspected exposure / confirmed exposure / expiry
- [ ] You have access to `[SecretsManager]`
- [ ] You have identified all services that consume the secret

## Steps

### Step 1 — Identify the Secret and Scope
- Identify the secret type: API key / database credential / IAM access key / OAuth token / TLS certificate
- Identify all services and systems that consume this secret
- Assess rotation risk: will rotation cause downtime? Is zero-downtime rotation supported?
- If confirmed exposure: **treat as a security incident — notify security contact before proceeding**

### Step 2 — Generate New Secret
- Generate a new secret using the approved method for the secret type
- Store the new secret in `[SecretsManager]` immediately
- **Never log, print, or store the new secret value in plaintext**

### Step 3 — Update Consuming Services
For each service that consumes the secret:
1. Update the service configuration to reference the new secret version
2. Validate the service can successfully authenticate with the new secret
3. If validation fails: **do not revoke the old secret yet** — investigate and resolve first

### Step 4 — Validate All Consumers
- Confirm all consuming services are successfully using the new secret
- Run a health check on each affected service
- Monitor error rates for [X] minutes after each service update
- Only proceed to revocation after all consumers are validated

### Step 5 — Revoke the Old Secret
- After all consumers are validated: revoke / delete the old secret
- **Do not revoke the old secret until all consumers are confirmed on the new version**

### Step 6 — Audit and Document
- Log the rotation event to `[audit log system]`
- Update the secret rotation schedule with the new rotation date

## Output Format

```
Secrets Rotation Summary
------------------------
Secret Name/ID:       [name or masked ID]
Secret Type:          [type]
Rotation Trigger:     [Routine / Suspected Exposure / Confirmed Exposure / Expiry]
Affected Services:    [list]
New Secret Stored:    Yes — in [SecretsManager]
Consumers Updated:    [list with validation status]
Old Secret Revoked:   Yes / No (reason if not)
Audit Trail:          Logged to [system]
Incident Ticket:      [link or "N/A — routine rotation"]
```

## Escalation

Stop and escalate to security contact immediately if:
- The secret was confirmed to be exposed externally
- Any consuming service fails to validate with the new secret and the issue cannot be resolved
- The old secret cannot be revoked due to a system dependency
- The secret is used by a Critical-classified asset and rotation causes unexpected downtime
- You are unable to identify all consumers of the secret
