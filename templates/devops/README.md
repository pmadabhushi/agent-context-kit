# [ServiceName] — Infrastructure & Operations

> **For AI agents:** Read `AGENTS.md` for deployment conventions, pipeline rules, and safety guardrails. Do not use this file as your primary instruction source.

## Overview

[ServiceName] is a [brief description of what the service does and its operational role].

- **Team:** [Team name]
- **Infrastructure:** [e.g., ECS on AWS, Kubernetes on GKE, Lambda]
- **Environments:** `dev` → `staging` → `prod`
- **On-call contact:** [alias or rotation link]
- **Security contact:** [alias or team name]

## Architecture

- **Compute:** [e.g., ECS Fargate, EC2 Auto Scaling Group, Lambda]
- **Networking:** [e.g., VPC, ALB, CloudFront]
- **Storage:** [e.g., S3, RDS, DynamoDB]
- **Messaging:** [e.g., SQS, SNS, Kinesis]
- **Infrastructure design doc:** [Link]

## Environment Map

| Environment | Purpose | Region(s) | Access |
|---|---|---|---|
| dev | Development and unit testing | [region] | [access method] |
| staging | Pre-production validation | [region] | [access method] |
| prod | Production traffic | [region(s)] | [access method — restricted] |

## Getting Started

```bash
[aws configure command or SSO login command]
[pipeline status command]
[health check command]
```

## Deployment

```bash
# Deploy to staging
[deploy command] --service [ServiceName] --version [X.Y.Z] --env staging

# Promote to prod (requires staging validation + pipeline badge >= Silver)
[deploy command] --service [ServiceName] --version [X.Y.Z] --env prod
```

> **Full deployment workflow:** See `skills/deploy_service.md`
> **Rollback procedure:** See `skills/rollback_service.md`

## Deployment Rules

- Never deploy to prod without a passing staging validation
- Pipeline badge must be Gold or Silver before promoting to prod
- All prod deployments require a deployment ticket
- Monitor error rate and P99 latency for 10 minutes post-deployment

## Pipeline

- **Pipeline dashboard:** [Link]
- **Pipeline tool:** [Tool name]
- **Badge thresholds:** Gold: [criteria] | Silver: [criteria] | Bronze: do not deploy

## Monitoring & Alerting

- **Primary dashboard:** [Link]
- **Error rate threshold (escalation):** [X]%
- **P99 latency threshold (escalation):** [X]ms
- **On-call rotation:** [Link]

## Runbooks

| Runbook | Location |
|---|---|
| Deployment | `skills/deploy_service.md` |
| Rollback | `skills/rollback_service.md` |
| Incident triage | `skills/incident_triage.md` |
| Scaling | `skills/scale_service.md` |
| Log analysis | `skills/log_analysis.md` |
| Infrastructure (IaC) | `skills/infrastructure_management.md` |
| Health check | `skills/health_check.md` |

## Design Documentation

| Category | Location | Contents |
|---|---|---|
| Service designs | `design/services/` | Architecture, APIs, dependencies, failure modes |
| Feature designs | `design/features/` | Feature architecture, data flow, edge cases |
| Workflow designs | `design/workflows/` | End-to-end workflow steps, state management |

## Contact

- **Team:** [Team name] — [team alias or Slack/Chime channel]
- **On-call:** [On-call rotation link]
- **Security issues:** Report to [security contact] — do not open a public ticket
