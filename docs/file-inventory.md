# File Inventory

Complete list of every template file in the repo.

## Templates

### Coding

| File | Type |
|---|---|
| `templates/coding/AGENTS.md` | AI config |
| `templates/coding/persona.md` | Persona |
| `templates/coding/README.md` | Human readme |
| `templates/coding/skills/raise_cr.md` | Skill |
| `templates/coding/skills/run_tests.md` | Skill |
| `templates/coding/skills/generate_changelog.md` | Skill |
| `templates/coding/design/architecture/ARCHITECTURE_TEMPLATE.md` | Design template |
| `templates/coding/design/apis/API_TEMPLATE.md` | Design template |
| `templates/coding/design/patterns/PATTERN_TEMPLATE.md` | Design template |

### DevOps

| File | Type |
|---|---|
| `templates/devops/AGENTS.md` | AI config |
| `templates/devops/persona.md` | Persona |
| `templates/devops/README.md` | Human readme |
| `templates/devops/skills/deploy_service.md` | Skill |
| `templates/devops/skills/rollback_service.md` | Skill |
| `templates/devops/skills/incident_triage.md` | Skill |
| `templates/devops/skills/scale_service.md` | Skill |
| `templates/devops/skills/log_analysis.md` | Skill |
| `templates/devops/skills/infrastructure_management.md` | Skill |
| `templates/devops/skills/health_check.md` | Skill |
| `templates/devops/design/services/SERVICE_TEMPLATE.md` | Design template |
| `templates/devops/design/features/FEATURE_TEMPLATE.md` | Design template |
| `templates/devops/design/workflows/WORKFLOW_TEMPLATE.md` | Design template |

### Security

| File | Type |
|---|---|
| `templates/security/AGENTS.md` | AI config |
| `templates/security/persona.md` | Persona |
| `templates/security/README.md` | Human readme |
| `templates/security/skills/vuln_triage.md` | Skill |
| `templates/security/skills/incident_response.md` | Skill |
| `templates/security/skills/secrets_rotation.md` | Skill |
| `templates/security/skills/access_review.md` | Skill |
| `templates/security/design/threat_models/THREAT_MODEL_TEMPLATE.md` | Design template |
| `templates/security/design/policies/POLICY_TEMPLATE.md` | Design template |
| `templates/security/design/controls/CONTROL_TEMPLATE.md` | Design template |

## Examples

| Path | Description |
|---|---|
| `examples/quickstart/` | Simplest possible config (Todo App, 4 files) |
| `examples/devops-filled/` | Filled-out DevOps example (OrderService) |
| `examples/greenfield-energy/` | Full three-persona example (IoT energy platform) |

## Agent

| File | Description |
|---|---|
| `agent/main.py` | CLI entry point, persona picker, chat loop |
| `agent/config.py` | Loads template.json, builds system prompts |
| `agent/tools.py` | Agent tools (shell, file, skill, design doc search) |
| `agent/eval_harness.py` | Evaluation harness — measure agent effectiveness |
| `agent/eval/scenarios.json` | Test scenarios (10 scenarios, 3 safety tests) |
| `agent/requirements.txt` | Python dependencies |
| `agent/README.md` | Agent documentation |

## Root Files

| File | Description |
|---|---|
| `template.json` | Machine-readable manifest of all domains, skills, and paths |
| `README.md` | Repo landing page |
| `LICENSE` | MIT License |
| `CHANGELOG.md` | Version history |
