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
your-repo/
├── AGENTS.md      ← Team config: tools, conventions, safety rules
├── persona.md     ← How the agent thinks and behaves
├── skills/        ← Step-by-step runbooks for specific tasks
└── design/        ← Architecture docs the agent references
```

The agent reads these at session start. No more re-explaining context.

## What's in This Repo

```
agent-context-kit/
├── templates/     # Ready-to-use templates — copy into your repo
│   ├── coding/    #   Dev agent: code reviews, testing, changelogs
│   ├── devops/    #   Ops agent: deployments, incidents, scaling, logs
│   └── security/  #   Security agent: vuln triage, incidents, access review
├── examples/      # Filled-out examples at three complexity levels
├── agent/         # Working multi-persona agent (Python, Strands SDK)
└── docs/          # Guides for beginners through experts
```

## Choose Your Path

### I'm new to AI agents
1. Read [Getting Started](docs/getting-started.md) to understand the concepts
2. Look at the [Quickstart Example](examples/quickstart/) — 4 files, 5 minutes
3. Copy a template and fill in your team's info

### I want to use this with my team
1. Pick a domain: [`templates/coding/`](templates/coding/), [`templates/devops/`](templates/devops/), or [`templates/security/`](templates/security/)
2. Copy the folder into your repo
3. Replace all `[placeholder]` values with your actual tools, commands, and conventions
4. Point your AI tool at `AGENTS.md` — see [Tool Setup Guides](docs/tool-guides/)

### I want to go deep
1. Read [Advanced Patterns](docs/advanced-patterns.md) — multi-agent orchestration, context management
2. Read [Evaluation Guide](docs/evaluation.md) — measure and improve agent effectiveness
3. Read [Customization Guide](docs/customization.md) — new domains, MCP integration, CI/CD

## How Each Piece Works

| File | Purpose |
|------|---------|
| `AGENTS.md` | Team config read at session start: tools, conventions, safety rules |
| `persona.md` | Mindset, methodology, safety guardrails, output format |
| `skills/*.md` | Step-by-step runbooks loaded on demand for specific tasks |
| `design/**/*.md` | Architecture, API specs, patterns, threat models, policies |

## Try the Agent

```bash
cd agent
pip install -r requirements.txt
python main.py                    # Pick a persona interactively
python main.py --persona devops   # Start as DevOps agent
python main.py --provider openai  # Use OpenAI instead of Bedrock
```

Supports AWS Bedrock, OpenAI, Anthropic, and LiteLLM. See [agent/README.md](agent/README.md).

## Compatible Tools

| Tool | How | Setup Guide |
|------|-----|-------------|
| Kiro | Reads `AGENTS.md` automatically | [Setup](docs/tool-guides/kiro.md) |
| Cursor | Add to `.cursorrules` or reference in chat | [Setup](docs/tool-guides/cursor.md) |
| GitHub Copilot | Reference with `#file:AGENTS.md` | [Setup](docs/tool-guides/copilot.md) |
| Amazon Q Developer | Include in repo context | [Setup](docs/tool-guides/amazon-q.md) |
| Claude / ChatGPT | Paste contents or upload files | — |
| Custom agents | Use the `agent/` directory | [Setup](agent/README.md) |

## Documentation

| Guide | Audience | Description |
|-------|----------|-------------|
| [Getting Started](docs/getting-started.md) | Beginner | What are agents, why this matters, how to start |
| [Cheat Sheet](docs/cheatsheet.md) | Beginner | One-page reference card with copy-paste templates |
| [Tool Setup Guides](docs/tool-guides/) | All | Kiro, Cursor, Copilot, Amazon Q configuration |
| [Advanced Patterns](docs/advanced-patterns.md) | Expert | Multi-agent orchestration, context management, prompt engineering |
| [Evaluation Guide](docs/evaluation.md) | Expert | Metrics, eval harness, measuring agent effectiveness |
| [Customization Guide](docs/customization.md) | Expert | New domains, custom tools, MCP, CI/CD integration |
| [Master Template Reference](docs/master-template.md) | Reference | Full reference with all sections explained |
| [Contributing](docs/CONTRIBUTING.md) | Contributors | How to add domains, skills, personas |
| [File Inventory](docs/file-inventory.md) | Reference | Complete list of every file in the repo |

## License

MIT — see [LICENSE](LICENSE).
