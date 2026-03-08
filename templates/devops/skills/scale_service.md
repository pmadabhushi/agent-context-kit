# SKILL: Scale Service

**Skill ID:** scale_service
**Domain:** DevOps
**Trigger:** User asks to scale up or down a service; traffic spike detected; capacity alarm firing; or post-incident recovery requires capacity adjustment
**Load from:** `skills/scale_service.md`

## Prerequisites

- [ ] You have the service name and target environment
- [ ] You have the scaling direction: scale up / scale down / auto-scaling adjustment
- [ ] You have the trigger: manual request / traffic spike / alarm / post-incident
- [ ] You have explicit user confirmation for any prod scaling action

## Steps

### Step 1 — Assess Current Capacity
- Check current instance/replica count: `[capacity check command]`
- Check current CPU, memory, and request volume vs. capacity
- Check auto-scaling policy (if configured): `[auto-scaling config command]`

### Step 2 — Determine Target Capacity
- For **scale up**: identify target count based on current load; confirm it does not exceed max capacity limit
- For **scale down**: confirm traffic has returned to normal; confirm target is above minimum required for availability
- For **auto-scaling adjustment**: identify the policy parameter to update and confirm new values with the user

### Step 3 — Request Explicit Confirmation (prod only)

```
Scaling Summary
---------------
Service:          [ServiceName]
Environment:      [prod/staging]
Direction:        [Scale Up / Scale Down / Auto-Scaling Adjustment]
Current Capacity: [X instances/replicas]
Target Capacity:  [Y instances/replicas]
Trigger:          [reason]
Current CPU:      [X]%
Current RPS:      [X]

Proceed with scaling? (yes/no)
```

### Step 4 — Execute Scaling Action
- Run: `[scale command] --service [ServiceName] --count [Y] --env [environment]`
- Confirm new instances/replicas are healthy: `[health check command]`

### Step 5 — Post-Scaling Monitoring
- Monitor error rate, P99 latency, CPU, and memory for 10 minutes post-scaling
- Confirm the scaling action resolved the triggering condition

### Step 6 — Post Scaling Summary

```
Scaling Complete
----------------
Service:          [ServiceName]
Action:           [Scale Up / Scale Down]
Capacity:         [X] → [Y] instances/replicas
Trigger:          [reason]
Error Rate:       [X]% (post-scaling)
P99 Latency:      [X]ms (post-scaling)
CPU Utilization:  [X]% (post-scaling)
Status:           Stable / Still Degraded
```

## Escalation

Stop and escalate to on-call if:
- The service cannot scale due to hitting a hard capacity limit
- New instances/replicas fail health checks after scaling
- Error rate or latency does not improve after scaling up
- Scaling down causes error rate or latency to degrade
