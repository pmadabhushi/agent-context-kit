# Using Agent Context Kit with GitHub Copilot

GitHub Copilot Chat supports file references and custom instructions. Here's
how to use your agent configuration with it.

## Basic Setup

1. Copy a template folder (e.g., `templates/security/`) into your project root
2. Fill in the `[placeholder]` values in `AGENTS.md`
3. Reference files in Copilot Chat using `#file:`

## Referencing Files in Chat

Pull in your agent config at the start of a conversation:

```
#file:AGENTS.md #file:persona.md

Help me investigate the elevated error rate on the order service.
```

For specific skills:
```
#file:skills/incident_triage.md We're seeing 5xx errors on the API.
```

For design context:
```
#file:design/services/SERVICE_TEMPLATE.md What are the dependencies?
```

## Using Custom Instructions

GitHub Copilot supports custom instructions via `.github/copilot-instructions.md`.
This file loads automatically in every Copilot Chat session — it's the closest
equivalent to Kiro's automatic `AGENTS.md` loading.

```markdown
# Copilot Instructions

## Project Context
Always read AGENTS.md for project conventions before answering questions.
Follow the persona defined in persona.md for tone and methodology.

## Task Procedures
When performing tasks that match a skill in skills/, follow those steps exactly.
Available skills:
- skills/deploy_service.md — Full deployment workflow
- skills/rollback_service.md — Rollback procedure
- skills/incident_triage.md — Incident investigation
- skills/health_check.md — System health check

## Safety Rules
- Never modify prod configuration without explicit confirmation.
- Never deploy to prod without a passing staging validation.
- If error rate exceeds 2% post-deployment, initiate rollback immediately.

## Architecture
Reference design docs in design/ when answering architecture questions.
```

Putting safety rules directly in `copilot-instructions.md` ensures they're
always in context, even if the user forgets to reference `AGENTS.md`.

## Using Copilot Chat Participants

In VS Code, you can use workspace-aware participants:

```
@workspace #file:AGENTS.md What's the deployment process?
```

The `@workspace` participant gives Copilot broader project context alongside
your specific file references. This is useful for questions that span multiple
files — Copilot will search your workspace and combine what it finds with
your explicit file references.

For terminal-related tasks:

```
@terminal #file:skills/health_check.md Run the health check
```

## Using Copilot Chat Agents (VS Code)

Copilot's slash commands pair well with skills:

```
/explain #file:design/services/order-service.md
```

This asks Copilot to explain the service architecture using your design doc
as the primary source.

## Worked Example: Security Review with Copilot

Here's what a real session looks like with a properly configured project:

```
You: #file:AGENTS.md #file:persona.md #file:skills/access_review.md
     Run a quarterly access review for the OrderService

Copilot: Based on the access review skill, I'll walk through this systematically.

         Step 1 — Pulling current IAM configuration:
         > aws iam list-role-policies --role-name orderservice-prod-role

         Attached policies:
         - OrderServiceDynamoDB (read/write)
         - OrderServiceSQS (send/receive)
         - OrderServiceS3Full ← flagged: full S3 access

         Step 2 — Checking last-used dates:
         > aws iam get-role --role-name orderservice-prod-role
         Last used: 2025-03-07 (active)

         > aws iam list-access-keys --user-name orderservice-deploy
         Key AKIA...X3Q — last used 90+ days ago ← flagged: stale key

         Step 3 — Cross-referencing with design doc:
         Per design/services/order-service.md, OrderService only needs
         S3 read access for invoice PDFs. Full S3 access is over-provisioned.

         Access Review Summary
         ---------------------
         Service:        OrderService
         Policies:       3 attached, 1 over-provisioned
         Stale Keys:     1 (AKIA...X3Q, unused 90+ days)
         Recommendations:
         1. Replace OrderServiceS3Full with read-only S3 policy
         2. Rotate or deactivate stale access key AKIA...X3Q
         3. Add S3 bucket-level restriction to invoice bucket only
```

Notice how Copilot followed the skill steps, flagged issues based on the
conventions in AGENTS.md, and produced output matching the persona format.

## Worked Example: Multi-File Architecture Question

```
You: #file:AGENTS.md #file:design/services/order-service.md
     We want to add a caching layer. What should we consider?

Copilot: Based on the service design doc, here are the key considerations:

         Current Architecture (from design doc):
         - DynamoDB for persistence, SQS for async events
         - P99 latency target: 200ms
         - Current P99: 145ms (25% headroom)

         Cache Placement Options:
         1. Application-level (in-memory) — fastest, but lost on restart
         2. ElastiCache Redis — shared across instances, survives deploys
         3. DynamoDB DAX — transparent, but only helps DynamoDB reads

         Recommendation: ElastiCache Redis
         - Order lookups are read-heavy (per design doc traffic patterns)
         - Cache invalidation aligns with existing SQS event flow
         - Failure mode: cache miss falls through to DynamoDB (graceful)

         This aligns with the safety rules in AGENTS.md — no single point
         of failure, and the cache is additive rather than required.
```

## Tips

- `#file:` is your main tool — use it to pull in exactly the context you need
- Custom instructions (`.github/copilot-instructions.md`) load automatically
  every session — put safety rules and skill indexes there
- Start conversations with `#file:AGENTS.md` for consistent context
- Copilot works best when you reference specific files rather than entire directories
- Use `@workspace` when you need Copilot to search across your project
- Put your most critical safety rules in `copilot-instructions.md` so they're
  always active, even when users forget to reference AGENTS.md
- For multi-step operational tasks, reference the specific skill file to get
  structured, step-by-step responses
