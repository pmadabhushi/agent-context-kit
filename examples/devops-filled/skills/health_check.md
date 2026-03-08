# SKILL: Health Check (OrderService)

**Skill ID:** health_check
**Domain:** DevOps
**Trigger:** Pre-deployment readiness check, routine health check, or system status request
**Load from:** `skills/health_check.md`

## Prerequisites

- [ ] You have access to the health endpoint, Grafana, and AWS CLI
- [ ] You know the scope: quick check or full pre-deployment validation

## Steps

### Step 1 — Application Health
- Hit the health endpoint: `curl -s https://orderservice.internal/health | jq .`
- Expected response: `{"status": "healthy", "version": "X.Y.Z", "uptime": "..."}`
- If unhealthy: check ECS task status before proceeding

### Step 2 — Check Key Metrics (Grafana)
- Open dashboard: https://grafana.internal/d/orderservice
- Check the last 30 minutes:

| Metric | Expected | Warning | Critical |
|---|---|---|---|
| Error rate | < 0.5% | > 2% | > 5% |
| P99 latency | < 200ms | > 500ms | > 1000ms |
| CPU | < 60% | > 75% | > 90% |
| Memory | < 70% | > 85% | > 95% |
| Request volume | Baseline ± 30% | > 2x baseline | > 3x baseline |

### Step 3 — Check Dependencies
- PaymentService: `curl -s https://paymentservice.internal/health | jq .status`
- InventoryService: `curl -s https://inventoryservice.internal/health | jq .status`
- Database: `aws rds describe-db-instances --db-instance-identifier orderservice-prod --query 'DBInstances[0].DBInstanceStatus'`
- Redis: `aws elasticache describe-cache-clusters --cache-cluster-id orderservice-prod --query 'CacheClusters[0].CacheClusterStatus'`

### Step 4 — Check Queue Health
- SQS queue depth: `aws sqs get-queue-attributes --queue-url https://sqs.us-east-1.amazonaws.com/123456789/orderservice-queue --attribute-names ApproximateNumberOfMessages`
- DLQ depth: `aws sqs get-queue-attributes --queue-url https://sqs.us-east-1.amazonaws.com/123456789/orderservice-dlq --attribute-names ApproximateNumberOfMessages`
- DLQ should be 0. If > 0, investigate before deploying.

### Step 5 — Check Recent Alerts
- PagerDuty: https://pagerduty.com/schedules/orderservice — any open incidents?
- CloudWatch alarms: `aws cloudwatch describe-alarms --alarm-name-prefix orderservice --state-value ALARM`

### Step 6 — Summarize

```
Health Check Report
-------------------
Service:         OrderService
Date:            [date]
Version:         [current version]

Application:     Healthy / Unhealthy
Error Rate:      [X]% (threshold: <0.5%)
P99 Latency:     [X]ms (threshold: <200ms)
CPU:             [X]% (threshold: <60%)
Memory:          [X]% (threshold: <70%)

Dependencies:
  PaymentService:   Healthy / Unhealthy
  InventoryService: Healthy / Unhealthy
  Database (RDS):   Available / Degraded
  Cache (Redis):    Available / Degraded

Queue:
  Main Queue:     [X] messages
  DLQ:            [X] messages

Open Alerts:     [count] ([details if any])

Deployment Ready: Yes / No — [reason if no]
```

## Escalation

Flag as not deployment-ready if:
- Any dependency is unhealthy
- Error rate is above 2%
- DLQ has messages (unresolved processing failures)
- Open PagerDuty incidents on OrderService
