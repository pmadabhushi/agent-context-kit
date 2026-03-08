# AI Agent Templates

A complete set of configuration files for AI coding, DevOps, and security agents.
Encode your team's tribal knowledge into structured repository files so AI agents
read it automatically at session start — no more re-explaining context every session.

## Structure

```
ai-agent-templates/
├── agent/        # Working multi-persona agent (Strands SDK)
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

### Using the templates
1. Copy the relevant domain folder into your service repository
2. Replace all `[placeholder]` values with your team's actual tools, commands, and conventions
3. Point your AI agent at `AGENTS.md` as its startup configuration file

### Running the agent
```bash
cd agent
pip install -r requirements.txt
python main.py                    # Interactive — pick a persona
python main.py --persona devops   # Start as DevOps agent
python main.py --provider openai  # Use OpenAI instead of Bedrock
```

Supports AWS Bedrock (default), OpenAI, Anthropic, and LiteLLM. See `agent/README.md` for details.

## Complete File Inventory

| File | Domain | Type |
|---|---|---|
| `coding/README.md` | Coding | Human-facing doc |
| `coding/AGENTS.md` | Coding | AI config |
| `coding/skills/raise_cr/SKILL.md` | Coding | Skill |
| `coding/skills/run_tests/SKILL.md` | Coding | Skill |
| `coding/skills/generate_changelog/SKILL.md` | Coding | Skill |
| `coding/personas/dev_agent.md` | Coding | Persona |
| `coding/design/architecture/ARCHITECTURE_TEMPLATE.md` | Coding | Design doc |
| `coding/design/apis/API_TEMPLATE.md` | Coding | Design doc |
| `coding/design/patterns/PATTERN_TEMPLATE.md` | Coding | Design doc |
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
| `security/design/threat_models/THREAT_MODEL_TEMPLATE.md` | Security | Design doc |
| `security/design/policies/POLICY_TEMPLATE.md` | Security | Design doc |
| `security/design/controls/CONTROL_TEMPLATE.md` | Security | Design doc |

## Working Agent

The `agent/` directory contains a fully functional multi-persona agent built with
[Strands Agents SDK](https://github.com/strands-agents/sdk-python). It dynamically
loads personas, skills, and team config from the template files above. See
`agent/README.md` for setup and usage.

## Template Manifest

The `template.json` file at the root provides a machine-readable manifest of all domains, personas, and skills in this template set. It can be used by tooling to discover and validate the template structure.

## References

- AGENTS.md guide: https://agents.md/
- Skills best practices: [Link]
