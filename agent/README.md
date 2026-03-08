# Multi-Persona AI Agent

A working AI agent that impersonates DevOps, Coding, or Security personas using the `agent-context-kit` knowledge base.

Built with [Strands Agents SDK](https://github.com/strands-agents/sdk-python) (open-source).

## What Gets Loaded

When you select a persona, the agent builds its full context from your template files:

| Context Layer | Source | How It's Used |
|---------------|--------|---------------|
| Persona | `persona.md` | Mindset, methodology, safety rules, output format |
| Team Config | `AGENTS.md` | Build commands, branch strategy, environment info |
| Design Docs | `design/**/*.md` | Architecture, APIs, patterns, threat models, policies, controls |
| Skills | `skills/*.md` | Step-by-step procedures for operational tasks |
| Skill Triggers | Built-in keyword map | Auto-loads the right skill based on what you ask |

All of this is injected into the system prompt at startup. The agent doesn't just know about your skills — it has the full instructions loaded and ready.

### Design Context by Domain

| Domain | Design Categories |
|--------|-------------------|
| coding | architecture, apis, patterns |
| devops | services, features, workflows |
| security | threat_models, policies, controls |

### Skill Auto-Loading

The agent detects task intent from your message and auto-loads the matching skill:

| You say... | Agent loads... |
|------------|---------------|
| "deploy the service" | `deploy_service` skill |
| "we have an incident" | `incident_triage` skill |
| "check the logs" | `log_analysis` skill |
| "rotate the API key" | `secrets_rotation` skill |
| "review IAM permissions" | `access_review` skill |
| "run the tests" | `run_tests` skill |

## Supported LLM Providers

| Provider | Flag | Default Model | Auth |
|----------|------|---------------|------|
| AWS Bedrock | `--provider bedrock` (default) | Claude Sonnet | AWS credentials configured |
| OpenAI | `--provider openai` | gpt-4o | `OPENAI_API_KEY` env var |
| Anthropic | `--provider anthropic` | Claude Sonnet | `ANTHROPIC_API_KEY` env var |
| LiteLLM | `--provider litellm` | gpt-4o | Provider-specific env vars |

## Setup

```bash
cd agent
pip install -r requirements.txt
```

For Bedrock, ensure your AWS credentials are configured:
```bash
aws configure
# or
export AWS_PROFILE=your-profile
```

## Usage

```bash
# Interactive — pick a persona at startup
python main.py

# Start directly as a specific persona
python main.py --persona devops
python main.py --persona coding
python main.py --persona security

# Use a different LLM provider
python main.py --provider openai
python main.py --provider anthropic

# Override the model
python main.py --provider bedrock --model us.anthropic.claude-sonnet-4-20250514-v1:0
python main.py --provider openai --model gpt-4o-mini
```

## Chat Commands

| Command | Description |
|---------|-------------|
| `/switch <domain>` | Switch persona (coding, devops, security) |
| `/skills` | List available skills for current persona |
| `/skill <name>` | Display a specific skill's instructions |
| `/design` | List design docs loaded as context |
| `/context` | Show everything loaded (persona, design, skills) |
| `/help` | Show available commands |
| `/quit` | Exit |

## Agent Tools

| Tool | Description |
|------|-------------|
| `run_shell` | Execute shell commands (system info, builds, log queries) |
| `read_file` | Read files (configs, logs, source code) |
| `list_directory` | List directory contents |
| `get_skill` | Reload a skill's step-by-step instructions |
| `search_design_docs` | Search across all design docs for a term |
| `get_design_doc` | Load a specific design doc by category and name |
| `list_all_context` | Show all available context for a domain |
| `switch_persona_info` | Get info about other available personas |

## Architecture

```
agent/
├── main.py            # CLI entry point, persona picker, chat loop
├── config.py          # Loads template.json, builds system prompts with full context
├── tools.py           # Agent tools (shell, file, skill, design doc search)
├── eval_harness.py    # Evaluation harness — measure agent effectiveness
├── eval/
│   └── scenarios.json # Test scenarios (task + safety tests across all domains)
├── requirements.txt   # Python dependencies
└── README.md          # This file
```

## Evaluating Your Config

The eval harness measures how well your agent configuration performs against
realistic scenarios. See [Evaluation Guide](../docs/evaluation.md) for the
full methodology.

```bash
# Evaluate devops domain
python eval_harness.py --domain devops

# Evaluate all domains
python eval_harness.py --domain all

# Run only safety tests (fast)
python eval_harness.py --domain devops --safety-only

# Compare configured agent vs vanilla baseline
python eval_harness.py --domain devops --with-baseline

# Use a different provider
python eval_harness.py --domain security --provider openai
```

The included `eval/scenarios.json` has 10 scenarios across all three domains,
including 3 adversarial safety tests that verify the agent refuses unsafe requests.

The agent dynamically reads from the parent `agent-context-kit/` directory.
Any changes to personas, skills, design docs, or AGENTS.md files are picked up
on next startup or persona switch.
