# AI Agent Templates

A complete set of configuration files for AI coding, DevOps, and security agents.
Encode your team's tribal knowledge into structured repository files so AI agents
read it automatically at session start — no more re-explaining context every session.

## Structure

```
ai-agent-templates/
├── coding/       # Coding agent: AGENTS.md, skills, persona
├── devops/       # DevOps agent: AGENTS.md, skills, persona
└── security/     # Security agent: AGENTS.md, skills, persona
```

Each domain contains:
- `README.md` — Human-facing project overview
- `AGENTS.md` — AI agent configuration (read at session start)
- `skills/` — Step-by-step runbooks loaded on demand
- `personas/` — Agent mindset, methodology, and safety rules

## Quick Start

1. Copy the relevant domain folder into your service repository
2. Replace all `[placeholder]` values with your team's actual tools, commands, and conventions
3. Point your AI agent at `AGENTS.md` as its startup configuration file

## Complete File Inventory

| File | Domain | Type |
|---|---|---|
| `coding/README.md` | Coding | Human-facing doc |
| `coding/AGENTS.md` | Coding | AI config |
| `coding/skills/raise_cr/SKILL.md` | Coding | Skill |
| `coding/skills/run_tests/SKILL.md` | Coding | Skill |
| `coding/skills/generate_changelog/SKILL.md` | Coding | Skill |
| `coding/personas/dev_agent.md` | Coding | Persona |
| `devops/README.md` | DevOps | Human-facing doc |
| `devops/AGENTS.md` | DevOps | AI config |
| `devops/skills/deploy_service/SKILL.md` | DevOps | Skill |
| `devops/skills/rollback_service/SKILL.md` | DevOps | Skill |
| `devops/skills/incident_triage/SKILL.md` | DevOps | Skill |
| `devops/skills/scale_service/SKILL.md` | DevOps | Skill |
| `devops/skills/log_analysis/SKILL.md` | DevOps | Skill |
| `devops/skills/infrastructure_management/SKILL.md` | DevOps | Skill |
| `devops/skills/health_check/SKILL.md` | DevOps | Skill |
| `devops/design/services/SERVICE_TEMPLATE.md` | DevOps | Design doc |
| `devops/design/features/FEATURE_TEMPLATE.md` | DevOps | Design doc |
| `devops/design/workflows/WORKFLOW_TEMPLATE.md` | DevOps | Design doc |
| `devops/personas/ops_engineer.md` | DevOps | Persona |
| `security/README.md` | Security | Human-facing doc |
| `security/AGENTS.md` | Security | AI config |
| `security/skills/vuln_triage/SKILL.md` | Security | Skill |
| `security/skills/incident_response/SKILL.md` | Security | Skill |
| `security/skills/secrets_rotation/SKILL.md` | Security | Skill |
| `security/skills/access_review/SKILL.md` | Security | Skill |
| `security/personas/security_analyst.md` | Security | Persona |

## Template Manifest

The `template.json` file at the root provides a machine-readable manifest of all domains, personas, and skills in this template set. It can be used by tooling to discover and validate the template structure.

## References

- AGENTS.md guide: https://agents.md/
- Skills best practices: [Link]
