# SKILL: Deploy Service

**Skill ID:** deploy_service
**Domain:** DevOps
**Trigger:** User asks to deploy, promote, or release a service version
**Load from:** `skills/deploy_service.md`

## Prerequisites

- [ ] You have the service name and version to deploy
- [ ] You have the target environment (staging or prod)
- [ ] A deployment ticket exists for prod deployments
- [ ] You have explicit user confirmation for any prod deployment

## Steps

### Step 1 — Validate Staging (for prod deployments)
- Check staging environment health: `[command to check staging status]`
- Confirm all automated tests are passing in staging
- If staging is unhealthy: stop and report — do not proceed to prod

### Step 2 — Check Pipeline Badge
- Retrieve current pipeline badge status: `[command]`
- Proceed only if badge is Gold or Silver
- If badge is Bronze or lower: stop, report badge status, and wait for instructions

### Step 3 — Run Pre-Deployment Smoke Tests
- Execute smoke test suite: `[smoke test command]`
- All smoke tests must pass before proceeding
- If smoke tests fail: stop and report failures

### Step 4 — Request Explicit Confirmation (prod only)

```
Deployment Summary
------------------
Service:           [ServiceName]
Version:           [X.Y.Z]
Target:            prod
Pipeline Badge:    [Gold/Silver]
Staging:           Healthy
Smoke Tests:       Passed
Deployment Ticket: [link]

Proceed with prod deployment? (yes/no)
```

### Step 5 — Execute Deployment
- Run: `[deploy command] --service [ServiceName] --version [X.Y.Z] --env [environment]`
- Monitor deployment progress in real time
- If deployment fails mid-way: initiate rollback immediately (load `rollback_service` skill)

### Step 6 — Post-Deployment Monitoring
- Monitor error rate and P99 latency for 10 minutes post-deployment
- Thresholds: error rate < [X]%, P99 latency < [X]ms
- If thresholds are breached: initiate rollback immediately (load `rollback_service` skill)

### Step 7 — Post Deployment Summary

```
Deployment Complete
-------------------
Service:      [ServiceName]
Version:      [X.Y.Z]
Env:          prod
Status:       Success / Rolled Back
Error Rate:   [X]% (10-min post-deploy)
P99 Latency:  [X]ms (10-min post-deploy)
Ticket:       [link]
```

## Escalation

Stop and escalate to on-call if:
- Staging is unhealthy before deployment
- Pipeline badge is below Silver
- Smoke tests fail and cannot be resolved
- Error rate or latency exceeds threshold post-deployment and rollback does not resolve it
