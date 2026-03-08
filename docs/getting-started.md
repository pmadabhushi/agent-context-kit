# Getting Started with AI Agents

This guide is for anyone new to GenAI agents. It explains what agents are, why they
matter, and how to use this repo to build your own.

## What is an AI Agent?

An AI agent is an LLM (like ChatGPT, Claude, or Gemini) that has been given:

1. **Context** — knowledge about your specific system, team, and conventions
2. **Tools** — the ability to run commands, read files, call APIs
3. **Instructions** — a defined methodology, safety rules, and output format

Without these, an LLM is a general-purpose chatbot. With them, it becomes a
specialized team member that knows your architecture, follows your runbooks,
and produces structured output.

## The Problem This Solves

Every time you start a new chat with an AI assistant, it knows nothing about:
- Your service architecture
- Your team's deployment process
- Which tools you use for monitoring
- Your safety rules around production changes
- How to format an incident report the way your team expects

You end up re-explaining all of this every session. That's fine for quick questions,
but for real operational work — investigating incidents, deploying services, triaging
vulnerabilities — the agent needs your team's tribal knowledge upfront.

## The Solution: Configuration Files

Instead of explaining context every time, you encode it into files that the agent
reads automatically when it starts:

```
Your repo/
├── AGENTS.md          ← Agent reads this first (team config, conventions, safety rules)
├── persona.md         ← How the agent should think and behave
├── skills/            ← Step-by-step runbooks for specific tasks
└── design/            ← Architecture docs the agent uses as reference
```

Think of it as **onboarding material for AI agents** — the same way you'd onboard
a new team member, except the agent reads it in seconds.

## The Four Building Blocks

### 1. AGENTS.md — Team Configuration
This is the agent's "day one" briefing. It contains:
- What service you work on
- Build commands and branch strategy
- Deployment rules and safety gates
- Which skills and personas are available

The agent reads this first, every session.

### 2. Persona — How the Agent Thinks
A persona defines the agent's mindset and methodology:
- **DevOps persona**: "Think like on-call. Gather data before acting. Never modify prod without confirmation."
- **Coding persona**: "Read before you write. Minimal diffs. Flag shared interface changes."
- **Security persona**: "Think like a threat actor first. Never dismiss a finding without evidence."

The persona also defines the output format, so every report looks consistent.

### 3. Skills — Step-by-Step Runbooks
Skills are loaded on demand when the agent needs to perform a specific task:
- `deploy_service.md` — Full deployment workflow with safety gates
- `incident_triage.md` — How to investigate an outage systematically
- `vuln_triage.md` — How to assess and prioritize a security finding

Each skill has prerequisites, numbered steps, an output format, and escalation rules.

### 4. Design Docs — System Knowledge
These give the agent deep understanding of your architecture:
- Service designs (infrastructure, APIs, dependencies, failure modes)
- Architecture docs (code structure, data models, patterns)
- Security docs (threat models, policies, controls)

## How It Works in Practice

### Example: Investigating an Incident

Without agent configuration:
```
You: "We're seeing 5xx errors on the order service"
Agent: "Can you tell me about your architecture? What monitoring tools do you use?
        What's your normal error rate? Where are your logs?"
```

With agent configuration:
```
You: "We're seeing 5xx errors on the order service"
Agent: "Loading skill: incident_triage.

        I'll start by checking the current system state.
        [Runs: check_error_rate --service OrderService]

        Error rate is 4.2% (normal: <0.5%). This is a SEV2.

        Checking recent deployments...
        [Runs: list_deployments --service OrderService --last 24h]

        Version 2.3.1 was deployed 45 minutes ago.

        Checking logs around deployment time...
        [Runs: search_logs --service OrderService --timerange ...]

        Found: NullPointerException in PaymentClient.java:142

        Investigation Summary
        ---------------------
        Service:     OrderService
        Severity:    SEV2
        Root Cause:  NPE in PaymentClient after v2.3.1 deployment
        Recommendation: Rollback to v2.3.0
        ..."
```

The agent already knows the architecture, the tools, the investigation methodology,
and the output format. It just works.

## Quick Start: 3 Ways to Use This Repo

### Option 1: Use the Templates (Recommended for Teams)
1. Pick a domain: `templates/coding/`, `templates/devops/`, or `templates/security/`
2. Copy the folder into your service repo
3. Replace all `[placeholder]` values with your team's actual info
4. Point your AI tool (Kiro, Cursor, Copilot, etc.) at `AGENTS.md`

### Option 2: Run the Agent (Try It Now)
```bash
cd agent
pip install -r requirements.txt
python main.py
```
Pick a persona and start chatting. The agent loads all the templates as context.
Supports AWS Bedrock, OpenAI, Anthropic, and more.

### Option 3: Read the Filled Examples
- `examples/quickstart/` — Simplest possible config (Todo App, 4 files)
- `examples/devops-filled/` — Simple DevOps example for a web service (OrderService)
- `examples/greenfield-energy/` — Full three-persona example for an IoT energy platform with fleet operations, platform development, and OT security

## What AI Tools Support This?

Any AI coding assistant that can read files from your repo:

| Tool | How to Use |
|------|-----------|
| Kiro | Reads `AGENTS.md` automatically; use steering files for personas |
| Cursor | Add `AGENTS.md` to your `.cursorrules` or reference in chat |
| GitHub Copilot | Reference files with `#file:AGENTS.md` in chat |
| Amazon Q Developer | Reads repo context; point to `AGENTS.md` in prompts |
| Claude (API) | Include file contents in system prompt |
| ChatGPT | Paste file contents or use file upload |
| Custom agents | Use the `agent/` directory in this repo as a starting point |

## FAQ

**Q: Do I need all four file types?**
Start with just `AGENTS.md`. Add a persona when you want consistent behavior.
Add skills when you have repeatable procedures. Add design docs when you want
the agent to understand your architecture deeply.

**Q: How big should AGENTS.md be?**
1-3 pages. It should cover the essentials: what service, how to build, how to deploy,
safety rules. Don't put everything here — that's what skills and design docs are for.

**Q: Can I use this with my own LLM?**
Yes. The templates are just markdown files. Any LLM that accepts a system prompt
can use them. The `agent/` code supports Bedrock, OpenAI, Anthropic, and LiteLLM
(which covers dozens of providers).

**Q: What if my team uses a different structure?**
The file names and folder structure are conventions, not requirements. The important
thing is the content pattern: team config → persona → skills → design docs.
Adapt the structure to fit your workflow.

## Next Steps

- Start with the quickstart: `examples/quickstart/` (4 files, 5 minutes)
- Browse the templates in `templates/coding/`, `templates/devops/`, or `templates/security/`
- Read the simple example in `examples/devops-filled/`
- Read the full three-persona example in `examples/greenfield-energy/`
- See the cheat sheet: `docs/cheatsheet.md`
- Set up your AI tool: `docs/tool-guides/`
- Try the agent: `cd agent && pip install -r requirements.txt && python main.py`
- Read the master reference: `docs/master-template.md`
