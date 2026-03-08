# Changelog

All notable changes to this project will be documented in this file.

## [1.0.0] - 2025-03-08

### Added
- Three domain templates: coding, devops, security (under `templates/`)
- Working multi-persona agent (`agent/`) built with Strands Agents SDK
  - Supports AWS Bedrock, OpenAI, Anthropic, and LiteLLM providers
  - CLI with persona picker, `/switch`, `/skills`, `/design`, `/context` commands
  - Auto-loads all design docs and skills into system prompt
  - Keyword-based skill auto-triggering
- Design document templates per domain:
  - Coding: architecture, APIs, patterns
  - DevOps: services, features, workflows
  - Security: threat models, policies, controls
- Two filled examples:
  - `examples/devops-filled/` — OrderService (simple web app)
  - `examples/greenfield-energy/` — Full three-persona IoT energy platform
- Documentation:
  - `docs/getting-started.md` — Beginner-friendly onboarding guide
  - `docs/master-template.md` — Full reference with all sections explained
  - `docs/CONTRIBUTING.md` — How to add domains, skills, personas, design templates
- `template.json` — Machine-readable manifest of all domains, skills, and paths
- GitHub Actions CI workflow for validation

### Changed
- Renamed repo from `ai-agent-templates` to `agent-context-kit`
- Moved domain folders under `templates/` for clearer repo organization
- Flattened `personas/` subdirectories to single `persona.md` per domain
- Flattened `skills/skill-name/SKILL.md` to `skills/skill-name.md`
