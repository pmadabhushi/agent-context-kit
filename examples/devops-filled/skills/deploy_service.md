# SKILL: Deploy Service (OrderService)

**Skill ID:** deploy_service
**Domain:** DevOps
**Trigger:** User asks to deploy, promote, or release OrderService
**Load from:** `skills/deploy_service.md`

## Prerequisites

- [ ] You have the version to deploy (e.g., v2.3.1)
- [ ] You have the target environment (staging or prod)
- [ ] For prod: a Jira ticket is linked in the PR
- [ ] For prod: you have explicit user confirmation

## Steps

### Step 1 — Validate Staging
- Check staging health: `curl -s https://staging.orderservice.internal/health | jq .`
- Confirm all CI checks are green on the PR
- If staging is unhealthy: **stop and report** — do not proceed to prod

### Step 2 — Run Smoke Tests
- Execute smoke tests: `./scripts/smoke-test.sh --env staging`
- All smoke tests must pass before proceeding
- If smoke tests fail: **stop and report failures**

### Step 3 — Request Confirmation (prod only)

```
Deployment Summary
------------------
Service:           OrderService
Version:           [version]
Target:            prod
CI Status:         Green
Staging:           Healthy
Smoke Tests:       Passed
Jira Ticket:       [ticket link]

Proceed with prod deployment? (yes/no)
```

### Step 4 — Execute Deployment
- Run: `./scripts/deploy.sh --service orderservice --version [version] --env prod`
- Monitor deployment progress in GitHub Actions
- If deployment fails: initiate rollback immediately

### Step 5 — Post-Deployment Monitoring
- Monitor Grafana dashboard for 10 minutes: https://grafana.internal/d/orderservice
- Thresholds: error rate < 2%, P99 latency < 500ms
- If thresholds are breached: initiate rollback immediately

### Step 6 — Post Summary
Post to `#ops-orderservice` Slack channel:

```
Deployment Complete
-------------------
Service:      OrderService
Version:      [version]
Env:          prod
Status:       Success / Rolled Back
Error Rate:   [X]% (10-min post-deploy)
P99 Latency:  [X]ms (10-min post-deploy)
Jira:         [ticket link]
```

## Escalation

Stop and escalate to on-call if:
- Staging is unhealthy before deployment
- CI checks are not green
- Error rate or latency exceeds threshold post-deployment and rollback does not resolve it
