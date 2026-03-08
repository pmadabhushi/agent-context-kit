# SKILL: Log Analysis

**Skill ID:** log_analysis
**Domain:** DevOps
**Trigger:** User asks to investigate logs, debug an issue using logs, or correlate events across services
**Load from:** `skills/log_analysis.md`

## Prerequisites

- [ ] You have the service name and environment
- [ ] You have the time window to investigate
- [ ] You have access to the logging platform (e.g., CloudWatch, Datadog, Splunk, ELK)

## Steps

### Step 1 — Define Search Scope
- Identify service(s), environment, and region
- Define time window: start and end timestamps
- Identify keywords, error codes, or request IDs to filter on

### Step 2 — Query Logs
- Run log query: `[log query command, e.g., aws logs filter-log-events ...]`
- Filter by log level (ERROR, WARN) first to reduce noise
- If a request ID or trace ID is available, use it to correlate across services

### Step 3 — Identify Patterns
- Group errors by type and frequency
- Identify the first occurrence of the issue (onset time)
- Check if errors correlate with a deployment, config change, or dependency failure
- Look for cascading failures across services

### Step 4 — Extract Key Evidence
- Pull the most relevant log lines (limit to 10-20 representative entries)
- Capture stack traces for the top error types
- Note any anomalies: sudden volume spikes, new error types, timeout patterns

### Step 5 — Produce Analysis Summary

```
Log Analysis Summary
--------------------
Service:        [ServiceName]
Environment:    [env]
Time Window:    [start] — [end]
Log Source:     [CloudWatch / Datadog / Splunk / ELK]

Top Errors:
1. [ErrorType] — [count] occurrences — first seen [timestamp]
2. [ErrorType] — [count] occurrences — first seen [timestamp]

Correlation:
- [Correlated event, e.g., "Errors began 2 min after deploy v1.2.3"]

Key Log Lines:
- [timestamp] [level] [message excerpt]
- [timestamp] [level] [message excerpt]

Root Cause Hypothesis: [description]
Recommended Action:    [next step]
```

## Escalation

Stop and escalate if:
- Logs indicate data corruption or data loss
- Logs contain evidence of unauthorized access
- Root cause cannot be determined from available logs
- Log volume is too high to analyze manually — recommend automated alerting
