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

## Setting Up Your Environment

This section walks you through everything you need to use the templates, run the
tutorial validator, or run the full agent. Skip what you already have.

### 1. Shell / Terminal

You need a terminal with a standard shell:

| OS | What to use |
|----|-------------|
| macOS | Terminal.app or iTerm2 (zsh is the default shell) |
| Linux | Any terminal (bash or zsh) |
| Windows | Git Bash, WSL2 (recommended), or PowerShell |

If you're on Windows, WSL2 gives you the smoothest experience — the agent and
scripts assume a Unix-like shell.

### 2. Git

You need Git to clone the repo and (optionally) version-control your own configs.

```bash
# Check if you have it
git --version
```

#### Install Git

```bash
# macOS — if Git isn't installed, this will prompt you to install Xcode Command Line Tools
xcode-select --install

# Linux (Debian/Ubuntu)
sudo apt install git

# Windows (WSL2)
sudo apt install git
```

#### Configure Git (first time only)

Git needs your name and email before you can commit. These show up in your
commit history — they don't need to match a GitHub account.

```bash
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

#### (Optional) Connect to GitHub

If you want to push your own agent configs to a GitHub repo, you need
authentication. The easiest way on macOS:

```bash
# Install the GitHub CLI
brew install gh

# Authenticate (opens a browser)
gh auth login
```

Alternatively, set up an [SSH key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
or a [personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens).

You don't need GitHub access to use the templates or run the agent — only if
you want to push your own configs.

### 3. Python 3.10+

The agent, MCP server, and eval harness require Python 3.10 or newer (the
`strands-agents` and `fastmcp` packages don't support 3.9). The tutorial
validator's structural checks work on 3.9+, but for the full experience you
want 3.10+.

macOS ships with Python 3.9, so you'll need to install a newer version.

```bash
# Check your current version
python3 --version
# If it says 3.10 or higher, you're good — skip to step 4.
```

#### macOS

You need [Homebrew](https://brew.sh) first (the macOS package manager). If you
don't have it:

```bash
# Install Homebrew (one-time setup)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Then install Python:

```bash
brew install python
# This installs the latest Python (3.12+) and adds python3 to your PATH.

# Verify
python3 --version
```

#### Linux (Debian/Ubuntu)

```bash
sudo apt update
sudo apt install python3 python3-pip python3-venv
```

Most modern distros ship with 3.10+. If yours doesn't, use
[pyenv](https://github.com/pyenv/pyenv) or the
[deadsnakes PPA](https://launchpad.net/~deadsnakes/+archive/ubuntu/ppa).

#### Windows

Use [WSL2](https://learn.microsoft.com/en-us/windows/wsl/install) (recommended)
and follow the Linux instructions above. Or install Python from
[python.org](https://www.python.org/downloads/) (3.10+).

### 4. Clone the Repo and Install Dependencies

The fastest way — run the setup script:

```bash
git clone https://github.com/pmadabhushi/agent-context-kit.git
cd agent-context-kit
./setup.sh
```

The script checks your OS, installs missing prerequisites (Homebrew, Python,
Git config), creates a virtual environment, installs dependencies, and runs a
smoke test. It's safe to run multiple times. Use `./setup.sh --check` to see
what's installed without changing anything.

If you prefer to do it manually:

```bash
git clone https://github.com/pmadabhushi/agent-context-kit.git
cd agent-context-kit

# Create a virtual environment (keeps dependencies isolated)
python3 -m venv .venv
source .venv/bin/activate    # macOS/Linux
# .venv\Scripts\activate     # Windows (PowerShell)

# Upgrade pip (avoids dependency resolution issues)
pip install --upgrade pip

# Install dependencies
cd agent
pip install -r requirements.txt
```

This installs:
- `strands-agents` — the agent SDK (for running the full agent)
- `fastmcp` — the MCP server framework
- `rich` — terminal formatting

If you see errors about Python version, make sure you created the venv with
Python 3.10+ (run `python3 --version` inside the venv to check).

### 5. LLM Access (Pick One)

The agent and eval harness need access to an LLM. You only need one provider.

#### Option A: AWS Bedrock (default)

No API key needed — uses your AWS credentials. You need an AWS account with
Bedrock model access enabled for Claude.

```bash
# Install the AWS CLI if you don't have it
# macOS
brew install awscli

# Linux
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip && sudo ./aws/install

# Configure credentials
aws configure
# Enter: AWS Access Key ID, Secret Access Key, Region (e.g., us-east-1)

# Verify access
aws bedrock list-foundation-models --query "modelSummaries[?contains(modelId, 'claude')]" --output table
```

If you see Claude models listed, you're good. If you get a permissions error,
you need to [enable model access](https://docs.aws.amazon.com/bedrock/latest/userguide/model-access.html)
in the Bedrock console.

```bash
# Run the agent with Bedrock (default)
python main.py --persona devops
```

#### Option B: OpenAI

```bash
# Get an API key from https://platform.openai.com/api-keys
export OPENAI_API_KEY="sk-..."

# Run the agent with OpenAI
python main.py --persona devops --provider openai
```

#### Option C: Anthropic

```bash
# Get an API key from https://console.anthropic.com/
export ANTHROPIC_API_KEY="sk-ant-..."

# Run the agent with Anthropic
python main.py --persona devops --provider anthropic
```

#### Option D: LiteLLM (any provider)

LiteLLM supports 100+ providers (Azure, Google, Ollama, local models, etc.).

```bash
pip install litellm

# Set the env vars for your provider (example: Azure OpenAI)
export AZURE_API_KEY="..."
export AZURE_API_BASE="https://your-resource.openai.azure.com/"

# Run the agent
python main.py --persona devops --provider litellm --model azure/gpt-4o
```

See [LiteLLM docs](https://docs.litellm.ai/docs/providers) for provider-specific setup.

### 6. Verify Everything Works

Quick smoke test to confirm your setup. After step 4 you should already be in
the `agent-context-kit/agent` directory with the venv activated.

```bash
# 1. Structural validation (no LLM needed, works even on Python 3.9)
python validate_config.py --path ../examples/quickstart
# Should show: ALL 17 CHECKS PASSED

# 2. Run the agent (needs LLM access from step 5)
python main.py --persona devops
# Type: "What skills do you have?"
# Type: /quit

# 3. (Optional) Run the MCP server
python mcp_server.py
# Should start without errors (Ctrl+C to stop)
```

If step 1 passes, your Python environment is good. If step 2 works, your LLM
access is configured. You're ready to go.

### What You Need for Each Activity

| Activity | Python | LLM Access | AI Tool |
|----------|--------|------------|---------|
| Use templates in your repo | No | No | Yes (any) |
| Follow the 1-hour tutorial | No | No | Yes (any) |
| Run the tutorial validator (structural) | 3.9+ | No | No |
| Run the tutorial validator (full) | 3.10+ | Yes | No |
| Run the full agent | 3.10+ | Yes | No |
| Run the eval harness | 3.10+ | Yes | No |
| Use the MCP server | 3.10+ | No | Yes (MCP-compatible) |

## Next Steps

- Follow the [1-Hour Tutorial](tutorial.md) — build your first config hands-on
- Start with the quickstart: `examples/quickstart/` (4 files, 5 minutes)
- Browse the templates in `templates/coding/`, `templates/devops/`, or `templates/security/`
- Read the simple example in `examples/devops-filled/`
- Read the full three-persona example in `examples/greenfield-energy/`
- See the cheat sheet: `docs/cheatsheet.md`
- Set up your AI tool: `docs/tool-guides/`
- Try the agent: `cd agent && pip install -r requirements.txt && python main.py`
- Read the master reference: `docs/master-template.md`
