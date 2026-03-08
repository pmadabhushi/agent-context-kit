# Changelog

All notable changes to this project will be documented in this file.

## [1.2.0] - 2026-03-08

### Added
- 1-hour beginner tutorial (`docs/tutorial.md`) — hands-on, step-by-step guide
  to building your first agent config from scratch
- Config validation script (`agent/validate_config.py`) — structural checks
  plus optional LLM-based testing of the 3 tutorial verification tests
- Evaluation harness (`agent/eval_harness.py`) with 10 test scenarios including
  3 adversarial safety tests, baseline comparison, rich terminal output
- Test scenarios (`agent/eval/scenarios.json`) across all three domains

### Enhanced
- Expert docs: advanced-patterns.md (cross-domain worked example, token budget
  analysis), evaluation.md (references real eval harness), customization.md
  (complete MCP server implementation, data-engineering domain walkthrough)
- All four tool guides now have worked examples and deeper integration guidance:
  kiro.md, cursor.md, copilot.md, amazon-q.md

## [1.1.0] - 2026-03-08

### Added
- Quickstart example (`examples/quickstart/`) — 4-file Todo App config
- Cheat sheet (`docs/cheatsheet.md`) — one-page reference card
- Tool setup guides (`docs/tool-guides/`) for Kiro, Cursor, Copilot, Amazon Q
- Advanced patterns guide (`docs/advanced-patterns.md`) — multi-agent
  orchestration, context window management, prompt engineering, versioning
- Evaluation guide (`docs/evaluation.md`) — metrics, before/after framework
- Customization guide (`docs/customization.md`) — new domains, MCP, CI/CD
- Adoption guide (`docs/adoption-guide.md`) — workshop agenda, progressive
  rollout, common objections, measuring success
- Fleshed out devops-filled example: order-service design doc, rollback and
  health check skills
- Documentation indexes: `docs/README.md`, `examples/README.md`
- File inventory (`docs/file-inventory.md`)
- 🟢🟡🔴 beginner/intermediate/expert progression labels throughout

### Changed
- Streamlined README as focused landing page with "Choose Your Path" sections
- Replaced fictional Mainspring Energy with Greenfield Energy in examples

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
