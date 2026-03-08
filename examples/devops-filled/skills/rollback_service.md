# SKILL: Rollback Service (OrderService)

**Skill ID:** rollback_service
**Domain:** DevOps
**Trigger:** Error rate exceeds threshold post-deployment, or explicit rollback request
**Load from:** `skills/rollback_service.md`

## Prerequisites

- [ ] You know the current (bad) version deployed
- [ ] You know the target (good) version to roll back to
- [ ] You have access to the deploy script and Grafana

## Steps

### Step 1 — Confirm Rollback Decision
- Check current error rate on Grafana: https://grafana.internal/d/orderservice
- If error rate > 2% post-deployment → rollback is warranted
- If explicit user request → proceed with confirmation

```
Rollback Confirmation
---------------------
Service:         OrderService
Current Version: [bad version]
Rollback To:     [good version]
Reason:          [error rate X% / user request / other]
Environment:     prod

Proceed with rollback? (yes/no)
```

### Step 2 — Identify Rollback Target
- List recent versions: `./scripts/deploy.sh --list-versions --last 7d`
- Identify the last known good version (the one before the bad deployment)
- If unsure, check deployment history: `git log --oneline --since="7 days ago" -- .github/workflows/deploy.yml`

### Step 3 — Execute Rollback
- Run: `./scripts/deploy.sh --rollback --version [good-version] --env prod`
- Monitor GitHub Actions for rollback progress
- If rollback deployment fails: escalate immediately

### Step 4 — Verify Recovery
- Monitor Grafana for 10 minutes post-rollback
- Check error rate: should drop below 0.5% within 5 minutes
- Check P99 latency: should return to < 200ms
- Check order success rate: should return to > 98%

### Step 5 — Post Summary
Post to `#ops-orderservice` Slack channel:

```
Rollback Complete
-----------------
Service:         OrderService
Rolled Back From:[bad version]
Rolled Back To:  [good version]
Reason:          [reason]
Error Rate:      [X]% → [Y]% (post-rollback)
P99 Latency:     [X]ms → [Y]ms (post-rollback)
Duration:        [time from detection to recovery]
Next Steps:      [investigate root cause / hotfix planned / etc.]
```

### Step 6 — Create Follow-Up Ticket
- Create a Jira ticket for root cause investigation
- Link to the deployment PR that caused the issue
- Assign to the engineer who deployed the bad version

## Escalation

Escalate immediately if:
- Rollback does not reduce error rate within 10 minutes
- Rollback deployment itself fails
- Data corruption is suspected
- Multiple services are affected
