# AGENTS.md — DevOps Agent (OrderService)

> This file is read automatically by AI DevOps agents at session start.

## Service Overview

- **Service:** OrderService
- **Infrastructure:** ECS Fargate on AWS, behind an ALB
- **Environments:** `dev` → `staging` → `prod`
- **Pipeline tool:** GitHub Actions
- **Infrastructure design doc:** `design/services/order-service.md`

## Deployment Conventions

- Always validate staging before promoting to prod
- Use `./scripts/deploy.sh` for all deployments — never deploy manually via AWS console
- Check pipeline badge status before promoting: all CI checks must be green
- Deployment promotion order: `dev` → `staging` → `prod`
- All prod deployments require a Jira ticket linked in the PR

## Environment Promotion Rules

| From | To | Required Gate |
|---|---|---|
| dev | staging | Unit + integration tests pass |
| staging | prod | Manual approval + smoke tests pass + CI green |
| prod | rollback | Error rate > 2% OR explicit on-call decision |

## Rollback Procedure

1. Identify the last known good version: `./scripts/deploy.sh --list-versions`
2. Initiate rollback: `./scripts/deploy.sh --rollback --env prod`
3. Monitor error rate for 10 minutes post-rollback
4. Post rollback summary to `#ops-orderservice` Slack channel

> For detailed steps, load skill: `skills/rollback_service.md`

## Monitoring & Alerting

- Primary dashboard: https://grafana.internal/d/orderservice
- Error rate threshold for escalation: 2%
- Latency threshold for escalation: 500ms at P99
- On-call rotation: https://pagerduty.com/schedules/orderservice

## Safety Rules

- **Never** modify prod configuration without explicit confirmation from the user
- **Never** deploy to prod without a passing staging validation
- **Prefer read-only operations** when investigating — do not make changes unless instructed
- If error rate exceeds 2% post-deployment, initiate rollback immediately
- All prod actions must be logged to the `#ops-audit` Slack channel

## Skills Available

| Skill | File | When to Load |
|---|---|---|
| Deploy Service | `skills/deploy_service.md` | When asked to deploy or promote a service |
| Rollback Service | `skills/rollback_service.md` | When asked to rollback or revert a deployment |
| Incident Triage | `skills/incident_triage.md` | When investigating elevated errors, latency, or alerts |
| Health Check | `skills/health_check.md` | When asked for system status or pre-deployment readiness |

## Personas Available

| Persona | File | When to Load |
|---|---|---|
| Ops Engineer | `personas/ops_engineer.md` | Default persona for all DevOps tasks |

## References

- Architecture doc: `design/services/order-service.md`
- Deployment runbook: https://wiki.internal/orderservice/deploy
- Incident response playbook: https://wiki.internal/orderservice/incidents
- On-call schedule: https://pagerduty.com/schedules/orderservice
- Grafana dashboard: https://grafana.internal/d/orderservice
