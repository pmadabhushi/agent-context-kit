# Using Agent Context Kit with Kiro

Kiro reads `AGENTS.md` automatically from your workspace root. This guide shows
how to get the most out of it.

## Basic Setup

1. Copy a template folder (e.g., `templates/coding/`) into your project root
2. Fill in the `[placeholder]` values in `AGENTS.md`
3. Open the project in Kiro — it reads `AGENTS.md` on startup

That's it. Kiro will use your team config, safety rules, and conventions
automatically in every conversation.

## Using Steering Files for Personas

Kiro supports steering files that provide additional context. You can use them
to load your persona:

1. Create `.kiro/steering/persona.md` in your project
2. Copy the contents of your `persona.md` into it
3. Kiro will include this context in every interaction

For conditional loading (only when certain files are open):

```yaml
---
inclusion: fileMatch
fileMatchPattern: "*.py"
---
# Your Python-specific persona content here
```

For manual loading (only when you explicitly include it via `#` in chat):

```yaml
---
inclusion: manual
---
# Your persona content here — loaded when you type #persona in chat
```

## Using Skills

Reference skills directly in chat:

```
#File:skills/deploy_service.md deploy the service to staging
```

Or add a steering file that tells Kiro about available skills:

```yaml
# .kiro/steering/skills-index.md
---
inclusion: auto
---
When performing tasks, check these skills for step-by-step procedures:
- skills/deploy_service.md — deployment workflow
- skills/incident_triage.md — incident investigation
- skills/rollback_service.md — rollback procedure
- skills/health_check.md — system health check

Follow the skill's steps exactly when a task matches.
```

## Using Design Docs

Reference design docs when asking architecture questions:

```
#File:design/services/order-service.md What are the failure modes for this service?
```

## Worked Example: Deploying with Kiro

Here's what a real session looks like with a properly configured project:

```
You: deploy OrderService v2.4.0 to staging

Kiro: (reads AGENTS.md, sees deploy conventions and safety rules)
      (reads skills/deploy_service.md for the procedure)

      I'll follow the deployment procedure for OrderService.

      Step 1 — Checking staging health...
      > curl -s https://staging.orderservice.internal/health | jq .
      {"status": "healthy", "version": "2.3.9"}

      Staging is healthy. Running smoke tests...
      > ./scripts/smoke-test.sh --env staging
      All 12 smoke tests passed.

      Deploying v2.4.0 to staging...
      > ./scripts/deploy.sh --service orderservice --version v2.4.0 --env staging
      Deployment initiated. Monitoring...

      Deployment Summary
      ------------------
      Service:      OrderService
      Version:      v2.4.0
      Env:          staging
      Status:       Success
      Error Rate:   0.1%
      P99 Latency:  145ms
```

Notice how Kiro followed the skill steps, used the actual commands from AGENTS.md,
and produced the output format defined in the persona — all without you explaining
any of that in the chat.

## Using Kiro Specs with Design Templates

Kiro's specs feature pairs naturally with the design doc templates. When planning
a new feature:

1. Start a spec in Kiro
2. Reference the relevant design template: `#File:design/services/SERVICE_TEMPLATE.md`
3. Kiro will use the template structure to help you fill in architecture, APIs,
   dependencies, and failure modes
4. The completed spec becomes a design doc you can add to your `design/` folder

## Tips

- Keep `AGENTS.md` at the project root — Kiro finds it automatically
- Use steering files for context you want in every conversation
- Use `#File:` for context you need only sometimes (skills, design docs)
- Kiro's specs feature pairs well with design doc templates for planning new features
- Hooks can automate skill loading — e.g., auto-run health check before deployments
