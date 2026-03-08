# Using Agent Context Kit with Cursor

Cursor uses `.cursorrules` and file references to load context. Here's how to
wire up your agent configuration.

## Basic Setup

1. Copy a template folder (e.g., `templates/devops/`) into your project root
2. Fill in the `[placeholder]` values in `AGENTS.md`
3. Create a `.cursorrules` file that references your agent config

## Option 1: .cursorrules (Always Loaded)

Create `.cursorrules` in your project root:

```
You are an AI assistant for the OrderService project.

## Context Files
- Read AGENTS.md for project conventions, build commands, and safety rules.
- Read persona.md for your role, mindset, and output format.
- When performing operational tasks, check the skills/ directory for step-by-step
  procedures before proceeding.
- When answering architecture questions, reference the design/ directory.

## Safety Rules (from AGENTS.md)
- Never modify prod configuration without explicit confirmation.
- Never deploy to prod without a passing staging validation.
- If error rate exceeds 2% post-deployment, initiate rollback immediately.

## Available Skills
- skills/deploy_service.md — Full deployment workflow
- skills/rollback_service.md — Rollback procedure
- skills/incident_triage.md — Incident investigation
- skills/health_check.md — System health check

When a task matches a skill, load and follow its steps exactly.
```

Putting the safety rules directly in `.cursorrules` ensures they're always in
context, even if Cursor doesn't load the full AGENTS.md.

## Option 2: Reference Files in Chat

Use Cursor's `@` syntax to pull in specific files:

```
@AGENTS.md @persona.md Deploy the service to staging
```

For skills:
```
@skills/deploy_service.md Walk me through deploying to prod
```

For design context:
```
@design/services/order-service.md What are the failure modes?
```

## Option 3: Cursor Composer with Full Context

Cursor's Composer mode is ideal for multi-step tasks. Load all relevant context:

```
@AGENTS.md @persona.md @skills/incident_triage.md

We're seeing elevated 5xx errors on OrderService. Error rate is at 3%.
Walk me through the investigation.
```

Composer will follow the skill steps, use the commands from AGENTS.md, and
produce output in the format defined in your persona.

## Worked Example: Incident Investigation in Cursor

```
You: @AGENTS.md @skills/incident_triage.md
     We're seeing 5xx errors on OrderService, error rate is 3%

Cursor: Based on the incident triage skill, I'll investigate systematically.

        Step 1 — Assessing current state:
        Error rate is 3%, which is above the 2% threshold → this is a SEV2.

        Step 2 — Checking recent changes:
        > ./scripts/deploy.sh --list-versions --last 24h
        v2.4.0 deployed 2 hours ago
        v2.3.9 deployed 3 days ago

        Step 3 — Checking logs:
        > aws logs filter-log-events --log-group /ecs/orderservice
          --filter-pattern "ERROR" --start-time [2 hours ago]

        Found: ConnectionTimeoutException in PaymentClient.java:89
        Pattern: all errors are on the /api/v1/orders POST endpoint

        Investigation Summary
        ---------------------
        Issue:       ConnectionTimeout to PaymentService after v2.4.0 deploy
        Severity:    SEV2
        Root Cause:  v2.4.0 changed PaymentClient timeout from 10s to 2s
        Recommendation: Rollback to v2.3.9
```

## Tips

- `.cursorrules` is the closest equivalent to automatic `AGENTS.md` loading
- Put your most critical safety rules directly in `.cursorrules` for guaranteed inclusion
- Use `@file` references for skills and design docs when you need them
- Keep your `.cursorrules` focused — point to files rather than duplicating all content
- Cursor's Composer mode works best for multi-step tasks that follow a skill
- For large projects, reference only the relevant skill rather than all files at once
