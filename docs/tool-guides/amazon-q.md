# Using Agent Context Kit with Amazon Q Developer

Amazon Q Developer reads your workspace context and can reference files directly.
Here's how to use your agent configuration with it.

## Basic Setup

1. Copy a template folder (e.g., `templates/devops/`) into your project root
2. Fill in the `[placeholder]` values in `AGENTS.md`
3. Open the project in your IDE with Amazon Q Developer installed

Amazon Q reads your workspace files as context. Having `AGENTS.md` at the root
means it's available for reference in every conversation.

## Referencing Files in Chat

Point Amazon Q at your config files:

```
Look at AGENTS.md for our project conventions. Help me deploy the service.
```

For skills:
```
Read skills/incident_triage.md and help me investigate the elevated error rate.
```

For design context:
```
Based on design/services/SERVICE_TEMPLATE.md, what are the failure modes?
```

## Using @workspace for Broad Context

Amazon Q supports `@workspace` to search across your entire project:

```
@workspace What deployment conventions does this project follow?
```

Amazon Q will find and read your `AGENTS.md`, `persona.md`, and relevant skill
files to answer the question. This is useful when you're not sure which file
contains the information you need.

## Using with Amazon Q Developer Agent (/dev)

The `/dev` agent generates and modifies code across multiple files. Pair it
with your agent config for convention-aware code generation:

```
/dev Read AGENTS.md for conventions. Add a health check endpoint following
our API patterns in design/apis/.
```

For more complex tasks, reference multiple files:

```
/dev Based on AGENTS.md conventions and design/services/order-service.md,
add a circuit breaker to the PaymentService client. Follow the error handling
patterns in the design doc.
```

The `/dev` agent will read your files, follow the conventions, and generate
code that matches your project's patterns.

## Using with Amazon Q Transform (/transform)

When modernizing code, your design docs provide critical context:

```
/transform Upgrade this service to Java 17. Reference design/services/
order-service.md for the dependency map — make sure all downstream
services are compatible.
```

## Worked Example: Incident Investigation with Amazon Q

Here's what a real session looks like with a properly configured project:

```
You: Read AGENTS.md and skills/incident_triage.md.
     We're seeing elevated 5xx errors on OrderService. Error rate is 3%.

Amazon Q: I've read your project conventions and the incident triage skill.
          I'll follow the triage procedure step by step.

          Step 1 — Severity Assessment:
          Error rate is 3%, which exceeds the 2% threshold in AGENTS.md.
          This is a SEV2 incident.

          Step 2 — Recent Changes:
          Based on your deployment conventions, checking recent deploys:
          > aws ecs describe-services --cluster prod --services orderservice
          Current task definition: orderservice:v2.4.0 (deployed 2h ago)
          Previous: orderservice:v2.3.9

          Step 3 — Log Analysis:
          > aws logs filter-log-events \
              --log-group /ecs/orderservice \
              --filter-pattern "ERROR" \
              --start-time $(date -d '2 hours ago' +%s)000

          Pattern found: ConnectionTimeoutException in PaymentClient
          All errors on POST /api/v1/orders — the payment integration path

          Step 4 — Root Cause:
          Comparing v2.4.0 and v2.3.9 configs:
          - PaymentClient timeout changed from 10s → 2s in v2.4.0
          - PaymentService P99 latency is 3.2s — exceeds new timeout

          Investigation Summary
          ---------------------
          Incident:    SEV2 — Elevated 5xx on OrderService
          Root Cause:  v2.4.0 reduced PaymentClient timeout below
                       PaymentService P99 latency
          Impact:      ~15% of order submissions failing
          Recommendation: Rollback to v2.3.9 per rollback_service.md

          Shall I walk through the rollback procedure from
          skills/rollback_service.md?
```

Notice how Amazon Q followed the skill steps, used the safety thresholds from
AGENTS.md, and offered to continue with the next relevant skill.

## Worked Example: Code Generation with /dev

```
You: /dev Read AGENTS.md and design/apis/API_TEMPLATE.md.
     Add a GET /api/v1/orders/{id}/status endpoint to OrderService.

Amazon Q (/dev): I've read your conventions. Based on the API template,
                 I'll generate the endpoint following your patterns.

                 Creating files:
                 - src/routes/orderStatus.ts (route handler)
                 - src/services/orderStatusService.ts (business logic)
                 - tests/orderStatus.test.ts (unit tests)

                 Following conventions from AGENTS.md:
                 ✓ Input validation on path parameter
                 ✓ Standard error response format
                 ✓ Health check integration
                 ✓ CloudWatch metrics emission
                 ✓ Request tracing headers

                 The endpoint returns:
                 {
                   "orderId": "ord-123",
                   "status": "processing",
                   "lastUpdated": "2025-03-08T10:30:00Z",
                   "estimatedCompletion": "2025-03-08T11:00:00Z"
                 }
```

## Customizing Amazon Q with Project Rules

Amazon Q respects project-level configuration. Create a `.amazonq/rules.md`
file to provide always-on context (similar to `.cursorrules` or Kiro's
steering files):

```markdown
# Project Rules for Amazon Q

## Context
- Read AGENTS.md for all project conventions and safety rules.
- Follow persona.md for response tone and methodology.

## Available Procedures
When a task matches one of these skills, follow its steps exactly:
- skills/deploy_service.md — Deployment workflow
- skills/rollback_service.md — Rollback procedure
- skills/incident_triage.md — Incident investigation
- skills/health_check.md — System health check

## Safety
- Never modify prod without explicit confirmation.
- If error rate exceeds 2% post-deployment, initiate rollback.
```

## Tips

- Keep `AGENTS.md` at the project root for easy discovery
- Reference specific files when you need targeted context
- Amazon Q's workspace indexing means your design docs are searchable
- Use `/dev` for code generation tasks that should follow your conventions
- Use `@workspace` when you're not sure which file has the answer
- For multi-step operational tasks, reference the specific skill file to get
  structured, step-by-step responses
- Pair `/dev` with design doc references for convention-aware code generation
- Create `.amazonq/rules.md` for always-on project context
