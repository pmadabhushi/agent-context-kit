# Agent Context Kit

Give your AI assistant the context it needs to actually help — your architecture,
your runbooks, your safety rules — so it stops asking and starts doing.

## The Problem

Every time you start a new AI chat, the assistant knows nothing about your system.
You spend the first 10 minutes explaining your architecture, your tools, your
deployment process. Then the session ends and you do it all over again.

## The Solution

Encode your team's knowledge into structured files that the AI reads automatically:

```
Your repo/
├── AGENTS.md              ← Team config: tools, conventions, safety rules
├── persona.md             ← How the agent thinks and behaves
├── skills/                ← Step-by-step runbooks for specific tasks
│   ├── deploy_service.md
│   ├── incident_triage.md
│   └── ...
└── design/                ← Architecture docs the agent references
    └── services/
```

The agent reads these at session start. No more re-explaining context.

## What's in This Repo

Ready-to-use templates for three domains, a working agent, and a filled example:

```
agent-context-kit/
├── templates/        # ← Copy these into your repo
│   ├── coding/       # Dev agent: code reviews, testing, changelogs
│   ├── devops/       # Ops agent: deployments, incidents, scaling, logs
│   └── security/     # Security agent: vuln triage, incidents, access review
├── examples/         # Filled-out examples — see what "done" looks like
├── agent/            # Working multi-persona agent (Python, Strands SDK)
└── docs/             # Getting started guide, master reference, contribution guide
```

## Quick Start

### New to AI agents? Start here:
Read [`docs/getting-started.md`](docs/getting-started.md) — explains what agents are,
why configuration matters, and how to use this repo.

### Just want the simplest possible example?
See [`examples/quickstart/`](examples/quickstart/) — a 4-file Todo App config you can
copy and customize in 5 minutes.

### Want to see a completed example?
- [`examples/devops-filled/`](examples/devops-filled/) — Simple DevOps example (OrderService web app)
- [`examples/greenfield-energy/`](examples/greenfield-energy/) — Full three-persona example for an IoT energy platform (fleet of linear generators)

### Ready to use the templates?
1. Copy a domain folder from `templates/` (`coding/`, `devops/`, or `security/`) into your repo
2. Replace all `[placeholder]` values with your team's actual info
3. Point your AI tool at `AGENTS.md`

### Want to run the agent?
```bash
cd agent
pip install -r requirements.txt
python main.py                    # Pick a persona interactively
python main.py --persona devops   # Start as DevOps agent
python main.py --provider openai  # Use OpenAI instead of Bedrock
```
Supports AWS Bedrock, OpenAI, Anthropic, and LiteLLM. See [`agent/README.md`](agent/README.md).

## How Each Piece Works

| File | Audience | Purpose |
|------|----------|---------|
| `AGENTS.md` | AI agent | Team config read at session start: tools, conventions, safety rules |
| `persona.md` | AI agent | Mindset, methodology, safety guardrails, output format |
| `skills/*.md` | AI agent | Step-by-step runbooks loaded on demand for specific tasks |
| `design/**/*.md` | AI agent | Architecture, API specs, patterns, threat models, policies |
| `README.md` | Humans | Project overview, setup instructions |

## Compatible Tools

These templates work with any AI tool that can read files from your repo:

| Tool | How | Setup Guide |
|------|-----|-------------|
| Kiro | Reads `AGENTS.md` automatically | [docs/tool-guides/kiro.md](docs/tool-guides/kiro.md) |
| Cursor | Add to `.cursorrules` or reference in chat | [docs/tool-guides/cursor.md](docs/tool-guides/cursor.md) |
| GitHub Copilot | Reference with `#file:AGENTS.md` | [docs/tool-guides/copilot.md](docs/tool-guides/copilot.md) |
| Amazon Q Developer | Include in repo context | [docs/tool-guides/amazon-q.md](docs/tool-guides/amazon-q.md) |
| Claude / ChatGPT | Paste contents or upload files | — |
| Custom agents | Use the `agent/` directory as a starting point | [agent/README.md](agent/README.md) |

## File Inventory

| File | Domain | Type |
|---|---|---|
| `templates/coding/AGENTS.md` | Coding | AI config |
| `templates/coding/persona.md` | Coding | Persona |
| `templates/coding/skills/raise_cr.md` | Coding | Skill |
| `templates/coding/skills/run_tests.md` | Coding | Skill |
| `templates/coding/skills/generate_changelog.md` | Coding | Skill |
| `templates/coding/design/architecture/` | Coding | Design template |
| `templates/coding/design/apis/` | Coding | Design template |
| `templates/coding/design/patterns/` | Coding | Design template |
| `templates/devops/AGENTS.md` | DevOps | AI config |
| `templates/devops/persona.md` | DevOps | Persona |
| `templates/devops/skills/deploy_service.md` | DevOps | Skill |
| `templates/devops/skills/rollback_service.md` | DevOps | Skill |
| `templates/devops/skills/incident_triage.md` | DevOps | Skill |
| `templates/devops/skills/scale_service.md` | DevOps | Skill |
| `templates/devops/skills/log_analysis.md` | DevOps | Skill |
| `templates/devops/skills/infrastructure_management.md` | DevOps | Skill |
| `templates/devops/skills/health_check.md` | DevOps | Skill |
| `templates/devops/design/services/` | DevOps | Design template |
| `templates/devops/design/features/` | DevOps | Design template |
| `templates/devops/design/workflows/` | DevOps | Design template |
| `templates/security/AGENTS.md` | Security | AI config |
| `templates/security/persona.md` | Security | Persona |
| `templates/security/skills/vuln_triage.md` | Security | Skill |
| `templates/security/skills/incident_response.md` | Security | Skill |
| `templates/security/skills/secrets_rotation.md` | Security | Skill |
| `templates/security/skills/access_review.md` | Security | Skill |
| `templates/security/design/threat_models/` | Security | Design template |
| `templates/security/design/policies/` | Security | Design template |
| `templates/security/design/controls/` | Security | Design template |

## Learn More

- [Getting Started Guide](docs/getting-started.md) — What are agents? Why does this matter?
- [Cheat Sheet](docs/cheatsheet.md) — One-page reference card for building agent configs
- [Quickstart Example](examples/quickstart/) — Simplest possible config (Todo App, 4 files)
- [Filled Example](examples/devops-filled/) — See what a completed configuration looks like
- [Tool Setup Guides](docs/tool-guides/) — Kiro, Cursor, Copilot, Amazon Q
- [Master Template Reference](docs/master-template.md) — Full reference with all sections explained
- [Contributing Guide](docs/CONTRIBUTING.md) — How to add domains, skills, and personas
- [Agent README](agent/README.md) — Running the multi-persona agent
- [AGENTS.md Guide](https://agents.md/) — The open standard for agent configuration
