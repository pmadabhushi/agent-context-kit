# AI Agent Templates

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
├── personas/              ← How the agent thinks and behaves
│   └── ops_engineer.md
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
ai-agent-templates/
├── coding/           # Dev agent: code reviews, testing, changelogs
├── devops/           # Ops agent: deployments, incidents, scaling, logs
├── security/         # Security agent: vuln triage, incidents, access review
├── examples/         # Filled-out example (OrderService) — see what "done" looks like
├── agent/            # Working multi-persona agent (Python, Strands SDK)
└── docs/             # Getting started guide, master reference, contribution guide
```

## Quick Start

### New to AI agents? Start here:
Read [`docs/getting-started.md`](docs/getting-started.md) — explains what agents are,
why configuration matters, and how to use this repo.

### Want to see a completed example?
Browse [`examples/devops-filled/`](examples/devops-filled/) — a fully filled-out
DevOps configuration for a fictional OrderService.

### Ready to use the templates?
1. Copy a domain folder (`coding/`, `devops/`, or `security/`) into your repo
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
| `personas/*.md` | AI agent | Mindset, methodology, safety guardrails, output format |
| `skills/*.md` | AI agent | Step-by-step runbooks loaded on demand for specific tasks |
| `design/**/*.md` | AI agent | Architecture, API specs, patterns, threat models, policies |
| `README.md` | Humans | Project overview, setup instructions |

## Compatible Tools

These templates work with any AI tool that can read files from your repo:

| Tool | How |
|------|-----|
| Kiro | Reads `AGENTS.md` automatically |
| Cursor | Add to `.cursorrules` or reference in chat |
| GitHub Copilot | Reference with `#file:AGENTS.md` |
| Amazon Q Developer | Include in repo context |
| Claude / ChatGPT | Paste contents or upload files |
| Custom agents | Use the `agent/` directory as a starting point |

## File Inventory

| File | Domain | Type |
|---|---|---|
| `coding/AGENTS.md` | Coding | AI config |
| `coding/personas/dev_agent.md` | Coding | Persona |
| `coding/skills/raise_cr.md` | Coding | Skill |
| `coding/skills/run_tests.md` | Coding | Skill |
| `coding/skills/generate_changelog.md` | Coding | Skill |
| `coding/design/architecture/` | Coding | Design template |
| `coding/design/apis/` | Coding | Design template |
| `coding/design/patterns/` | Coding | Design template |
| `devops/AGENTS.md` | DevOps | AI config |
| `devops/personas/ops_engineer.md` | DevOps | Persona |
| `devops/skills/deploy_service.md` | DevOps | Skill |
| `devops/skills/rollback_service.md` | DevOps | Skill |
| `devops/skills/incident_triage.md` | DevOps | Skill |
| `devops/skills/scale_service.md` | DevOps | Skill |
| `devops/skills/log_analysis.md` | DevOps | Skill |
| `devops/skills/infrastructure_management.md` | DevOps | Skill |
| `devops/skills/health_check.md` | DevOps | Skill |
| `devops/design/services/` | DevOps | Design template |
| `devops/design/features/` | DevOps | Design template |
| `devops/design/workflows/` | DevOps | Design template |
| `security/AGENTS.md` | Security | AI config |
| `security/personas/security_analyst.md` | Security | Persona |
| `security/skills/vuln_triage.md` | Security | Skill |
| `security/skills/incident_response.md` | Security | Skill |
| `security/skills/secrets_rotation.md` | Security | Skill |
| `security/skills/access_review.md` | Security | Skill |
| `security/design/threat_models/` | Security | Design template |
| `security/design/policies/` | Security | Design template |
| `security/design/controls/` | Security | Design template |

## Learn More

- [Getting Started Guide](docs/getting-started.md) — What are agents? Why does this matter?
- [Filled Example](examples/devops-filled/) — See what a completed configuration looks like
- [Master Template Reference](docs/master-template.md) — Full reference with all sections explained
- [Contributing Guide](docs/CONTRIBUTING.md) — How to add domains, skills, and personas
- [Agent README](agent/README.md) — Running the multi-persona agent
- [AGENTS.md Guide](https://agents.md/) — The open standard for agent configuration
