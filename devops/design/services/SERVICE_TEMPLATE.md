# Service: [ServiceName]

## Overview

[One-paragraph description of what this service does and its role in the system.]

## Ownership

- **Team:** [TeamName]
- **On-call:** [rotation link]
- **Repo:** [repo link]

## Infrastructure

- **Compute:** [e.g., ECS/Fargate, Lambda, EC2 ASG, Kubernetes]
- **Networking:** [e.g., ALB, NLB, API Gateway, CloudFront]
- **Storage:** [e.g., DynamoDB (X tables), RDS Postgres, S3]
- **Messaging:** [e.g., SQS, SNS, Kinesis, EventBridge]
- **Region(s):** [e.g., us-east-1, us-west-2]

## API Surface

| Endpoint / Operation | Method | Description |
|---|---|---|
| [/api/resource] | [GET/POST] | [What it does] |
| [/api/resource/:id] | [PUT/DELETE] | [What it does] |

## Dependencies

| Dependency | Type | Impact if Down |
|---|---|---|
| [ServiceName] | Upstream | [e.g., Cannot process requests] |
| [DatabaseName] | Datastore | [e.g., Full outage] |
| [QueueName] | Async | [e.g., Jobs delayed but not lost] |

## Data Flow

```
[Request] → [API Gateway / ALB] → [Compute] → [Datastore]
                                       ↓
                                  [Queue / Event] → [Downstream Service]
```

## Key Metrics

| Metric | Normal Range | Alert Threshold |
|---|---|---|
| Error rate | < [X]% | > [Y]% |
| P99 latency | < [X]ms | > [Y]ms |
| Request volume | [X]-[Y] RPS | > [Z] RPS |
| CPU utilization | < [X]% | > [Y]% |

## Known Failure Modes

| Failure | Symptoms | Mitigation |
|---|---|---|
| [e.g., DB connection exhaustion] | [Timeout errors, 5xx spike] | [Scale DB connections, restart tasks] |
| [e.g., Dependency timeout] | [Elevated latency, partial failures] | [Circuit breaker, fallback cache] |

## Configuration

- **Config source:** [e.g., Parameter Store, AppConfig, environment variables]
- **Key config values:** [list critical config keys and what they control]
- **Config change process:** [how config changes are deployed and validated]
