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

### 🟢 Beginner — I'm new to AI agents
1. Read [Getting Started](docs/getting-started.md) to understand the concepts
2. Run `./setup.sh` to set up your environment (or [do it manually](docs/getting-started.md#setting-up-your-environment))
3. Follow the [1-Hour Tutorial](docs/tutorial.md) — build your first config from scratch
4. Look at the [Quickstart Example](examples/quickstart/) — 4 files, 5 minutes
5. Read the [Cheat Sheet](docs/cheatsheet.md) for a one-page reference
6. Copy a template and fill in your team's info

### 🟡 Intermediate — I want to use this with my team
1. Read the [Adoption Guide](docs/adoption-guide.md) — workshop agenda, progressive rollout, getting buy-in
2. See a realistic config: [`examples/devops-filled/`](examples/devops-filled/) (OrderService with design doc, 4 skills)
3. Pick a domain: [`templates/coding/`](templates/coding/), [`templates/devops/`](templates/devops/), or [`templates/security/`](templates/security/)
4. Copy the folder into your repo and replace all `[placeholder]` values
5. Wire up your AI tool — see [Tool Setup Guides](docs/tool-guides/) for Kiro, Cursor, Copilot, Amazon Q

### 🔴 Expert — I want to go deep
1. Study the full multi-persona example: [`examples/greenfield-energy/`](examples/greenfield-energy/)
2. Run the working agent: [`agent/`](agent/) — Python CLI with Strands SDK, multi-provider support
3. Read [Advanced Patterns](docs/advanced-patterns.md) — multi-agent orchestration, context management
4. Read [Evaluation Guide](docs/evaluation.md) — measure and improve agent effectiveness
5. Read [Customization Guide](docs/customization.md) — new domains, custom tools, MCP, CI/CD

## How Each Piece Works

| File | Purpose |
|------|---------|
| `AGENTS.md` | Team config read at session start: tools, conventions, safety rules |
| `persona.md` | Mindset, methodology, safety guardrails, output format |
| `skills/*.md` | Step-by-step runbooks loaded on demand for specific tasks |
| `design/**/*.md` | Architecture, API specs, patterns, threat models, policies |

## Try the Agent (Expert)

The `agent/` directory contains a working multi-persona agent built with the
[Strands Agents SDK](https://github.com/strands-agents/sdk-python). It loads
all templates as context and supports multiple LLM providers. This is for
developers who want to build or extend agent applications programmatically.

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
| MCP-compatible tools | Connect via MCP server | [Setup](agent/README.md#mcp-server) |
| Custom agents | Use the `agent/` directory | [Setup](agent/README.md) |

## Documentation

| Guide | Level | Description |
|-------|-------|-------------|
| [Getting Started](docs/getting-started.md) | 🟢 Beginner | What are agents, why this matters, how to start |
| [1-Hour Tutorial](docs/tutorial.md) | 🟢 Beginner | Hands-on: build your first agent config from scratch |
| [Cheat Sheet](docs/cheatsheet.md) | 🟢 Beginner | One-page reference card with copy-paste templates |
| [Adoption Guide](docs/adoption-guide.md) | 🟡 Intermediate | Rolling out to your team: workshop, progressive rollout, objections |
| [Tool Setup Guides](docs/tool-guides/) | 🟡 Intermediate | Kiro, Cursor, Copilot, Amazon Q configuration with worked examples |
| [Advanced Patterns](docs/advanced-patterns.md) | 🔴 Expert | Multi-agent orchestration, context management, prompt engineering |
| [Evaluation Guide](docs/evaluation.md) | 🔴 Expert | Metrics, eval harness, measuring agent effectiveness |
| [Customization Guide](docs/customization.md) | 🔴 Expert | New domains, custom tools, MCP, CI/CD integration |
| [Master Template Reference](docs/master-template.md) | Reference | Full reference with all sections explained |
| [Contributing](docs/CONTRIBUTING.md) | Reference | How to add domains, skills, personas |
| [File Inventory](docs/file-inventory.md) | Reference | Complete list of every file in the repo |

## License

MIT — see [LICENSE](LICENSE).
