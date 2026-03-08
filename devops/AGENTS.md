# AGENTS.md — DevOps Agent

> This file is read automatically by AI DevOps agents at session start. Do not duplicate content from README.md.

## Service Overview

- **Service:** [ServiceName]
- **Infrastructure:** [Brief description, e.g., ECS on AWS, Kubernetes on GKE]
- **Environments:** `dev` → `staging` → `prod`
- **Pipeline tool:** [Tool name, e.g., Jenkins, GitHub Actions, GitLab CI, Spinnaker]
- **Infrastructure design doc:** [Link]

## Deployment Conventions

- Always validate staging before promoting to prod
- Use `[DeployTool CLI command]` for all deployments — never deploy manually via console
- Check pipeline badge status before promoting: pipeline must be Gold or Silver
- Deployment promotion order: `dev` → `staging` → `prod`
- All prod deployments require a deployment ticket: `[ticketing system link]`

## Environment Promotion Rules

| From | To | Required Gate |
|---|---|---|
| dev | staging | Automated tests pass |
| staging | prod | Manual approval + smoke tests pass + pipeline badge >= Silver |
| prod | rollback | Error rate > [threshold]% OR explicit on-call decision |

## Rollback Procedure

1. Identify the last known good version: `[command]`
2. Initiate rollback: `[rollback command]`
3. Monitor error rate for 10 minutes post-rollback
4. Post rollback summary to `[ops channel]`

> For detailed steps, load skill: `skills/rollback_service.md`

## Monitoring & Alerting

- Primary dashboard: [Link]
- Error rate threshold for escalation: [X]%
- Latency threshold for escalation: [X]ms at P99
- On-call rotation: [Link to on-call schedule]

## Safety Rules

- **Never** modify prod configuration without explicit confirmation from the user
- **Never** deploy to prod without a passing staging validation
- **Prefer read-only operations** when investigating — do not make changes unless instructed
- If error rate exceeds [threshold]% post-deployment, initiate rollback immediately
- All prod actions must be logged to `[audit log system]`

## Skills Available

| Skill | File | When to Load |
|---|---|---|
| Deploy Service | `skills/deploy_service.md` | When asked to deploy or promote a service |
| Rollback Service | `skills/rollback_service.md` | When asked to rollback or revert a deployment |
| Incident Triage | `skills/incident_triage.md` | When investigating elevated errors, latency, or alerts |
| Scale Service | `skills/scale_service.md` | When asked to scale up/down a service |
| Log Analysis | `skills/log_analysis.md` | When asked to investigate logs, debug issues, or correlate events |
| Infrastructure Management | `skills/infrastructure_management.md` | When asked to provision, update, or validate infrastructure (IaC) |
| Health Check | `skills/health_check.md` | When asked for system status, health checks, or pre-deployment readiness |

## Personas Available

| Persona | File | When to Load |
|---|---|---|
| Ops Engineer | `persona.md` | Default persona for all DevOps tasks |

## Design Documentation

Before investigating any issue, review the relevant design docs:

| Category | Location | Contents |
|---|---|---|
| Service designs | `design/services/` | Architecture, APIs, dependencies, failure modes for each service |
| Feature designs | `design/features/` | Feature architecture, data flow, edge cases, limits |
| Workflow designs | `design/workflows/` | End-to-end workflow steps, state management, retry policies |

## References

- Infrastructure design doc: [Link]
- Deployment runbook: [Link]
- Incident response playbook: [Link]
- On-call schedule: [Link]
- Pipeline dashboard: [Link]
