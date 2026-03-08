# SKILL: Infrastructure Management (IaC)

**Skill ID:** infrastructure_management
**Domain:** DevOps
**Trigger:** User asks to provision, update, validate, or destroy infrastructure resources; IaC drift detected; infrastructure change review requested
**Load from:** `skills/infrastructure_management.md`

## Prerequisites

- [ ] You have the target environment (dev / staging / prod)
- [ ] You have the IaC tool and configuration path (e.g., Terraform, CloudFormation, CDK)
- [ ] You have explicit user confirmation for any prod infrastructure change
- [ ] A change ticket exists for prod changes

## Steps

### Step 1 — Validate Current State
- Run plan/diff to see what will change: `[iac plan command, e.g., terraform plan]`
- Review the output for unexpected resource additions, modifications, or deletions
- If destroying resources: flag explicitly and require confirmation

### Step 2 — Check for Drift
- Compare live infrastructure state against IaC definitions: `[drift detection command]`
- If drift is detected: document it and ask the user whether to reconcile or ignore

### Step 3 — Review Change Scope

```
Infrastructure Change Summary
-----------------------------
Tool:              [Terraform / CloudFormation / CDK]
Environment:       [dev / staging / prod]
Resources Added:   [count]
Resources Modified:[count]
Resources Deleted: [count]
Estimated Cost:    [if available]

Key Changes:
- [resource type] — [action: create / update / delete]
- [resource type] — [action]

Proceed with apply? (yes/no)
```

### Step 4 — Apply Changes
- Run: `[iac apply command, e.g., terraform apply]`
- Monitor apply progress; if errors occur, capture the error output and stop
- Do NOT retry failed applies automatically — report and wait for instructions

### Step 5 — Post-Apply Validation
- Verify new/modified resources are healthy: `[health check or describe command]`
- Run smoke tests against affected services if applicable
- Confirm no unintended side effects on dependent services

### Step 6 — Post Change Summary

```
Infrastructure Change Complete
------------------------------
Tool:           [Terraform / CloudFormation / CDK]
Environment:    [env]
Resources:      [X added, Y modified, Z deleted]
Status:         Success / Partial Failure
Drift:          [None / Detected — details]
Ticket:         [link]
```

## Escalation

Stop and escalate if:
- Plan shows unexpected resource deletions in prod
- Apply fails with errors that cannot be resolved
- Drift is detected in prod and the source is unknown
- Cost estimate exceeds expected thresholds
