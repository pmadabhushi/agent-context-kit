# Example: OrderService (DevOps)

This is a filled-out example showing what the DevOps templates look like when
completed for a real service. Compare these files with the templates in `templates/devops/`
to understand what to fill in.

## What's Here

| File | Template Source | What Changed |
|------|----------------|-------------|
| `AGENTS.md` | `templates/devops/AGENTS.md` | All `[placeholder]` values replaced with OrderService specifics |
| `persona.md` | `templates/devops/persona.md` | Real team name, tools, commands, investigation workflow, abbreviations |
| `skills/deploy_service.md` | `templates/devops/skills/deploy_service.md` | Real deploy script, Grafana URLs, Slack channels, smoke tests |
| `skills/rollback_service.md` | `templates/devops/skills/rollback_service.md` | Real rollback commands, monitoring thresholds, follow-up process |
| `skills/incident_triage.md` | `templates/devops/skills/incident_triage.md` | Real log commands, dashboard URLs, severity definitions |
| `skills/health_check.md` | `templates/devops/skills/health_check.md` | Real health endpoints, dependency checks, queue monitoring |
| `design/services/order-service.md` | `templates/devops/design/services/SERVICE_TEMPLATE.md` | Full architecture, API endpoints, data model, failure modes, scaling |

## Key Differences from Templates

1. No `[placeholder]` values — everything is filled in with concrete tools, URLs, and commands
2. Real commands — `./scripts/deploy.sh`, `aws logs filter-log-events`, `curl` health checks
3. Real URLs — Grafana dashboards, PagerDuty schedules, wiki links
4. Team-specific context — team name, service names, Slack channels, Jira references
5. Concrete thresholds — error rate > 2%, P99 < 500ms, CPU target 60%
6. Architecture details — data model, dependency map, failure modes with mitigations

## How to Use This Example

1. Read through each file to see the pattern
2. Go back to the templates in `templates/devops/`
3. Copy the templates into your own repo
4. Replace the `[placeholder]` values with your team's info, using this example as a reference
5. Start with AGENTS.md and persona.md, then add skills one at a time
