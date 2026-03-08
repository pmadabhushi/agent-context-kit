# SKILL: Incident Triage (OrderService)

**Skill ID:** incident_triage
**Domain:** DevOps
**Trigger:** Elevated errors, latency spikes, alerts firing, or service degradation on OrderService
**Load from:** `skills/incident_triage.md`

## Prerequisites

- [ ] You have the alert or ticket with timestamps and error details
- [ ] You have access to Grafana and CloudWatch

## Steps

### Step 1 — Assess Current State
- Check Grafana dashboard: https://grafana.internal/d/orderservice
- Note: error rate, P99 latency, request volume, CPU/memory
- Determine severity:
  - Error rate > 5% or service down → SEV1
  - Error rate 2-5% or degraded → SEV2
  - Elevated latency only → SEV3

### Step 2 — Check Recent Changes
- Recent deployments: `./scripts/deploy.sh --list-versions --last 24h`
- Recent config changes: `git log --oneline --since="24 hours ago" -- config/`
- Recent infrastructure changes: check Terraform plan history

### Step 3 — Dive Into Logs
- Search for errors: `aws logs filter-log-events --log-group /ecs/orderservice --filter-pattern "ERROR" --start-time [epoch_ms]`
- Search for specific request: `aws logs filter-log-events --log-group /ecs/orderservice --filter-pattern "[request-id]"`
- Check downstream services: PaymentService, InventoryService logs

### Step 4 — Correlate and Hypothesize
- Timeline: when did the issue start? Does it correlate with a deployment or config change?
- Scope: is it all requests or specific endpoints/customers?
- Dependencies: are downstream services healthy?

### Step 5 — Recommend Action
- **Recent deployment caused it?** → Rollback (load `rollback_service` skill)
- **Traffic spike?** → Check if autoscaling is responding
- **Dependency failure?** → Check downstream service health, escalate if needed
- **Unknown?** → Gather more data, escalate if SEV1

### Step 6 — Document Findings

```
Investigation Summary
---------------------
Investigated by: [Agent / Engineer name]
Alert:           [alert link or ticket]
Date:            [date]

Issue:           [one-line description]

Impact:
- Affected:     [scope — all users, specific region, specific endpoint]
- Duration:     [start — end or ongoing]
- Severity:     [SEV1 / SEV2 / SEV3]

System State:
- Error Rate:   [X]% (normal: <0.5%)
- P99 Latency:  [X]ms (normal: <200ms)
- CPU/Memory:   [X]% / [X]%

Root Cause:     [explanation]
Evidence:       [key log entries, metrics, or code references]
Actions Taken:  [what was done, or "none — investigation only"]
Recommendation: [next step]
Prevention:     [how to prevent recurrence]
```

## Escalation

Escalate immediately if:
- SEV1 and root cause not identified within 15 minutes
- Multiple services affected
- Data loss or security implications suspected
