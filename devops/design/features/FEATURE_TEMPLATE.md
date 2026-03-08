# Feature: [FeatureName]

## Overview

[One-paragraph description of the feature, what problem it solves, and who uses it.]

## Architecture

- **Entry point:** [e.g., API endpoint, event trigger, scheduled job]
- **Services involved:** [list services that participate in this feature]
- **Data stores:** [list databases, caches, queues used]

## Data Flow

```
[Trigger] → [Service A] → [Service B] → [Datastore]
                              ↓
                         [Async Job] → [Notification]
```

## Key Design Decisions

| Decision | Rationale |
|---|---|
| [e.g., Async processing via SQS] | [e.g., Decouples ingestion from processing, handles traffic spikes] |
| [e.g., DynamoDB over RDS] | [e.g., Low-latency key-value lookups, no joins needed] |

## Edge Cases & Failure Handling

| Scenario | Behavior |
|---|---|
| [e.g., Duplicate request] | [e.g., Idempotent — returns existing result] |
| [e.g., Downstream timeout] | [e.g., Retries 3x with exponential backoff, then DLQ] |
| [e.g., Invalid input] | [e.g., Returns 400 with validation errors] |

## Limits & Quotas

| Limit | Value | Configurable? |
|---|---|---|
| [e.g., Max payload size] | [e.g., 10 MB] | [Yes / No] |
| [e.g., Requests per second] | [e.g., 1000 RPS] | [Yes — via throttle config] |

## Monitoring

- **Dashboard:** [link]
- **Key metrics:** [list feature-specific metrics to watch]
- **Alerts:** [list alerts tied to this feature]

## Related Design Docs

- [Link to original design doc]
- [Link to related RFCs or ADRs]
