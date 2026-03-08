# Workflow: [WorkflowName]

## Overview

[One-paragraph description of the end-to-end workflow, when it runs, and what it produces.]

## Trigger

- **How it starts:** [e.g., API call, scheduled cron, event from SNS/SQS, manual trigger]
- **Input:** [what data/parameters are required to start the workflow]

## Steps

| Step | Service / Component | Action | On Failure |
|---|---|---|---|
| 1 | [e.g., API Gateway] | [Receive request, validate input] | [Return 400] |
| 2 | [e.g., Lambda / ECS task] | [Process data, transform] | [Retry 3x, then DLQ] |
| 3 | [e.g., Step Functions] | [Orchestrate sub-tasks] | [Catch and route to error handler] |
| 4 | [e.g., S3 / DynamoDB] | [Store results] | [Retry, alert on persistent failure] |
| 5 | [e.g., SNS / SES] | [Send notification] | [Log and continue] |

## Flow Diagram

```
[Trigger]
    ↓
[Step 1: Validate]
    ↓
[Step 2: Process] ──failure──→ [DLQ / Retry]
    ↓
[Step 3: Orchestrate]
    ├── [Sub-task A]
    ├── [Sub-task B]
    └── [Sub-task C]
    ↓
[Step 4: Store Results]
    ↓
[Step 5: Notify]
    ↓
[Complete]
```

## State Management

- **Orchestrator:** [e.g., Step Functions, Airflow, custom state machine]
- **State store:** [e.g., DynamoDB status table, Step Functions execution history]
- **Idempotency:** [How duplicate executions are handled]

## Timeout & Retry Policy

| Component | Timeout | Retries | Backoff |
|---|---|---|---|
| [Step 2 — Processing] | [30s] | [3] | [Exponential] |
| [Step 3 — Orchestration] | [5m] | [1] | [None — fail fast] |
| [Overall workflow] | [15m] | [0] | [N/A — manual retry] |

## Monitoring

- **Dashboard:** [link]
- **Key metrics:** [execution count, success rate, duration P50/P99]
- **Alerts:** [failed executions, stuck workflows, timeout breaches]

## Troubleshooting

| Symptom | Likely Cause | Investigation Steps |
|---|---|---|
| [Workflow stuck] | [Step Functions timeout or dependency hang] | [Check execution history, check dependency health] |
| [Partial completion] | [One sub-task failed] | [Check DLQ, check sub-task logs] |
| [Duplicate outputs] | [Retry without idempotency] | [Check idempotency key, review state store] |
