# SKILL: Rollback Service

**Skill ID:** rollback_service
**Domain:** DevOps
**Trigger:** User asks to rollback or revert a deployment; or error rate/latency thresholds are breached post-deployment
**Load from:** `skills/rollback_service.md`

## Prerequisites

- [ ] You have the service name and current (bad) version
- [ ] You have identified the last known good version
- [ ] You have explicit user confirmation OR thresholds have been automatically breached
- [ ] A rollback ticket exists or will be created

## Steps

### Step 1 — Identify the Last Known Good Version
- Query deployment history: `[command to list recent deployments]`
- Confirm the rollback target version with the user before proceeding

### Step 2 — Assess Current System State
- Check current error rate and P99 latency
- Document current state before rollback begins

### Step 3 — Request Explicit Confirmation

```
Rollback Summary
----------------
Service:              [ServiceName]
Current Version:      [X.Y.Z] (bad)
Rollback Target:      [X.Y.Z] (last known good)
Current Error Rate:   [X]%
Current P99 Latency:  [X]ms
Trigger:              [Manual / Auto — threshold breach]

Proceed with rollback? (yes/no)
```

### Step 4 — Execute Rollback
- Run: `[rollback command] --service [ServiceName] --version [X.Y.Z]`
- If rollback itself fails: stop immediately and escalate to on-call

### Step 5 — Post-Rollback Monitoring
- Monitor error rate and P99 latency for 10 minutes post-rollback
- If thresholds are still breached: escalate to on-call immediately

### Step 6 — Create Rollback Ticket
- Title: `Rollback — [ServiceName] — [bad version] → [good version] — [date]`
- Include: trigger reason, versions involved, error rate before/after, timeline

### Step 7 — Post Rollback Summary

```
Rollback Complete
-----------------
Service:        [ServiceName]
Rolled Back:    [X.Y.Z] → [X.Y.Z]
Trigger:        [reason]
Error Rate:     [X]% → [X]% (post-rollback)
P99 Latency:    [X]ms → [X]ms (post-rollback)
Status:         Stable / Still Degraded
Ticket:         [link]
```

## Escalation

Stop and escalate to on-call immediately if:
- The rollback command itself fails
- Error rate or latency remains above threshold after rollback
- The last known good version cannot be identified
- Data integrity concerns are identified (e.g., schema migrations that cannot be reversed)
