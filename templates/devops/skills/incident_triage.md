# SKILL: Incident Triage

**Skill ID:** incident_triage
**Domain:** DevOps
**Trigger:** User reports elevated errors, latency spikes, alerts firing, or service degradation
**Load from:** `skills/incident_triage.md`

## Prerequisites

- [ ] You have the service name and affected environment
- [ ] You have the alert or symptom description
- [ ] You have access to monitoring dashboards and logs

## Steps

### Step 1 — Declare Scope
- Identify affected service(s), environment, and region(s)
- Determine customer impact: internal only / external customers / SLA breach
- If customer-impacting: immediately notify on-call lead and open an incident ticket

### Step 2 — Gather System State (Read-Only)
- Current error rate, P99/P50 latency
- Recent deployments (last 24 hours): `[deployment history command]`
- Recent config changes: `[config change log command]`
- Active alarms: `[alarm dashboard link or command]`
- Dependency health: `[dependency health check command]`

### Step 3 — Identify the Trigger
- **Recent deployment?** → Check if error rate spiked immediately after deploy → load `rollback_service` skill if confirmed
- **Dependency failure?** → Check upstream/downstream service health
- **Traffic spike?** → Check request volume vs. capacity
- **Config change?** → Check recent config modifications
- **Infrastructure issue?** → Check host health, disk, memory, CPU

### Step 4 — Narrow Root Cause
- Pull error logs for the affected time window: `[log query command]`
- Identify the most frequent error type and stack trace
- Document your hypothesis: "Most likely cause: [X] because [evidence]"

### Step 5 — Assess Severity

| Severity | Criteria |
|---|---|
| SEV1 | Complete service outage OR customer data loss OR SLA breach |
| SEV2 | Significant degradation, >X% error rate, customer-impacting |
| SEV3 | Partial degradation, elevated errors, no immediate customer impact |
| SEV4 | Minor issue, no customer impact, can be addressed in normal workflow |

### Step 6 — Recommend Remediation
- **Rollback** → if a recent deployment is the confirmed trigger (load `rollback_service` skill)
- **Scale up** → if traffic spike is the trigger (load `scale_service` skill)
- **Config revert** → if a config change is the trigger
- **Dependency escalation** → if a downstream service is the cause
- **Further investigation** → if root cause is still unclear

### Step 7 — Produce Incident Summary

```
Incident Investigation Summary
-------------------------------
Service:            [ServiceName]
Environment:        [prod/staging]
Region:             [region]
Reported At:        [timestamp]

Symptoms:
- Error Rate:       [X]% (normal: [Y]%)
- P99 Latency:      [X]ms (normal: [Y]ms)

Timeline:
- [HH:MM] — [event, e.g., deployment, config change]
- [HH:MM] — [alert fired]
- [HH:MM] — [investigation started]

Root Cause Hypothesis: [description with supporting evidence]
Severity:           [SEV1 / SEV2 / SEV3 / SEV4]
Customer Impact:    [Yes / No — description]
Recommended Action: [Rollback / Scale / Config Revert / Escalate / Investigate Further]
Ticket:             [link or "not yet created"]
```

## Escalation

Escalate to on-call lead immediately if:
- Severity is SEV1 or SEV2
- Customer data loss or corruption is suspected
- Root cause cannot be identified within [X] minutes
- The incident spans multiple services or regions
