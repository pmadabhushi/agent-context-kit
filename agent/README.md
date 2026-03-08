# Multi-Persona AI Agent

A working AI agent that impersonates DevOps, Coding, or Security personas using the `ai-agent-templates` knowledge base.

Built with [Strands Agents SDK](https://github.com/strands-agents/sdk-python) (open-source).

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
| `/help` | Show available commands |
| `/quit` | Exit |

## How It Works

1. Reads `template.json` to discover all domains, personas, and skills
2. Loads the selected persona's markdown as the agent's system prompt
3. Loads the domain's `AGENTS.md` as team configuration context
4. Gives the agent tools: shell execution, file reading, skill loading
5. The agent follows the persona's mindset, methodology, safety rules, and output format

## Agent Tools

| Tool | Description |
|------|-------------|
| `run_shell` | Execute shell commands (for gathering system info, running builds, etc.) |
| `read_file` | Read files (configs, logs, source code, design docs) |
| `list_directory` | List directory contents |
| `get_skill` | Load a skill's step-by-step instructions |
| `switch_persona_info` | Get info about other available personas |

## Architecture

```
agent/
├── main.py          # CLI entry point and chat loop
├── config.py        # Loads template.json, builds system prompts
├── tools.py         # Agent tools (shell, file, skill loading)
├── requirements.txt # Python dependencies
└── README.md        # This file
```

The agent dynamically reads from the parent `ai-agent-templates/` directory,
so any changes to personas, skills, or AGENTS.md files are picked up immediately.
