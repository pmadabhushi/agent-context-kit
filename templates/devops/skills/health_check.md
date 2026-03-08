# SKILL: Health Check / Status Report

**Skill ID:** health_check
**Domain:** DevOps
**Trigger:** User asks for current system status, health check, environment overview, or pre-deployment readiness check
**Load from:** `skills/health_check.md`

## Prerequisites

- [ ] You have the service name (or "all services" for a full report)
- [ ] You have the target environment (dev / staging / prod / all)

## Steps

### Step 1 — Gather Service Health
- Check service endpoint health: `[health check command or URL]`
- Check instance/replica status: `[instance status command]`
- Check recent restart or crash events: `[event log command]`

### Step 2 — Gather Key Metrics
- Current error rate: `[metrics query command]`
- Current P99 and P50 latency: `[metrics query command]`
- Current CPU and memory utilization: `[metrics query command]`
- Current request volume (RPS): `[metrics query command]`

### Step 3 — Check Pipeline and Deployment State
- Current deployed version: `[version check command]`
- Last deployment time: `[deployment history command]`
- Pipeline badge status: `[pipeline status command]`
- Any pending deployments or promotions

### Step 4 — Check Dependencies
- Upstream service health: `[dependency check command]`
- Downstream service health: `[dependency check command]`
- Database / cache / queue health: `[dependency check command]`

### Step 5 — Check Active Alerts
- List active alarms: `[alarm list command]`
- List recently resolved alarms (last 24h): `[alarm history command]`

### Step 6 — Produce Status Report

```
System Health Report
--------------------
Service:          [ServiceName]
Environment:      [env]
Timestamp:        [now]
Overall Status:   [Healthy / Degraded / Incident]

Metrics:
- Error Rate:     [X]% (threshold: [Y]%)
- P99 Latency:    [X]ms (threshold: [Y]ms)
- CPU:            [X]%
- Memory:         [X]%
- RPS:            [X]

Deployment:
- Current Version:[X.Y.Z]
- Last Deployed:  [timestamp]
- Pipeline Badge: [Gold / Silver / Bronze]

Dependencies:
- [Dependency 1]: [Healthy / Degraded]
- [Dependency 2]: [Healthy / Degraded]

Active Alerts:    [count] ([list if any])
Recent Alerts:    [count in last 24h]

Recommendation:   [All clear / Investigate X / Action needed]
```

## Escalation

Escalate if:
- Any prod service reports unhealthy status
- Error rate or latency exceeds thresholds
- Critical dependencies are degraded
- Multiple active alerts are firing simultaneously
