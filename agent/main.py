#!/usr/bin/env python3
"""
Multi-Persona AI Agent
======================
A working agent that can impersonate DevOps, Coding, or Security personas
using the ai-agent-templates knowledge base.

Supports:
  - AWS Bedrock (default)
  - OpenAI (via OPENAI_API_KEY)
  - Anthropic (via ANTHROPIC_API_KEY)
  - LiteLLM (any provider)

Usage:
  python main.py                    # Interactive mode, pick persona
  python main.py --persona devops   # Start directly as DevOps agent
  python main.py --provider openai  # Use OpenAI instead of Bedrock

Commands during chat:
  /switch <domain>   Switch persona (coding, devops, security)
  /skills            List available skills for current persona
  /skill <name>      Load a specific skill
  /help              Show commands
  /quit              Exit
"""

import argparse
import sys
import os

from rich.console import Console
from rich.markdown import Markdown
from rich.panel import Panel
from rich.prompt import Prompt

from config import get_domains, build_system_prompt, list_skills, load_skill, list_design_docs
from tools import ALL_TOOLS

console = Console()

# ---------------------------------------------------------------------------
# Model provider setup
# ---------------------------------------------------------------------------

def create_model(provider: str, model_id: str | None = None):
    """Create the appropriate model based on provider choice."""

    if provider == "bedrock":
        from strands.models.bedrock import BedrockModel
        mid = model_id or "us.anthropic.claude-sonnet-4-20250514-v1:0"
        console.print(f"  Using Bedrock model: {mid}", style="dim")
        return BedrockModel(model_id=mid)

    elif provider == "openai":
        from strands.models.openai import OpenAIModel
        mid = model_id or "gpt-4o"
        console.print(f"  Using OpenAI model: {mid}", style="dim")
        return OpenAIModel(model_id=mid)

    elif provider == "anthropic":
        from strands.models.anthropic import AnthropicModel
        mid = model_id or "claude-sonnet-4-20250514"
        console.print(f"  Using Anthropic model: {mid}", style="dim")
        return AnthropicModel(model_id=mid)

    elif provider == "litellm":
        from strands.models.litellm import LiteLLMModel
        mid = model_id or "gpt-4o"
        console.print(f"  Using LiteLLM model: {mid}", style="dim")
        return LiteLLMModel(model_id=mid)

    else:
        console.print(f"[red]Unknown provider: {provider}[/red]")
        sys.exit(1)


# ---------------------------------------------------------------------------
# Agent creation
# ---------------------------------------------------------------------------

def create_agent(domain: str, provider: str, model_id: str | None = None):
    """Create a Strands agent with the given persona."""
    from strands import Agent

    system_prompt = build_system_prompt(domain)
    model = create_model(provider, model_id)

    agent = Agent(
        model=model,
        system_prompt=system_prompt,
        tools=ALL_TOOLS,
    )
    return agent


# ---------------------------------------------------------------------------
# CLI interface
# ---------------------------------------------------------------------------

def pick_persona() -> str:
    """Interactive persona picker."""
    domains = get_domains()

    console.print()
    console.print(Panel(
        "[bold]Choose a persona to start:[/bold]\n\n"
        "  [cyan]1[/cyan]  coding    — Dev Agent (code reviews, testing, changelogs)\n"
        "  [cyan]2[/cyan]  devops    — Ops Engineer (deployments, incidents, scaling)\n"
        "  [cyan]3[/cyan]  security  — Security Analyst (vuln triage, incidents, access)\n",
        title="🤖 AI Agent Personas",
        border_style="cyan"
    ))

    choice_map = {"1": "coding", "2": "devops", "3": "security",
                  "coding": "coding", "devops": "devops", "security": "security"}

    while True:
        choice = Prompt.ask("Select persona", choices=["1", "2", "3", "coding", "devops", "security"])
        if choice in choice_map:
            return choice_map[choice]


def show_help():
    console.print(Panel(
        "[cyan]/switch <domain>[/cyan]   Switch persona (coding, devops, security)\n"
        "[cyan]/skills[/cyan]            List available skills for current persona\n"
        "[cyan]/skill <name>[/cyan]      Load and display a specific skill\n"
        "[cyan]/design[/cyan]            List design docs loaded as context\n"
        "[cyan]/context[/cyan]           Show all loaded context (persona, design, skills)\n"
        "[cyan]/help[/cyan]              Show this help\n"
        "[cyan]/quit[/cyan]              Exit",
        title="Commands",
        border_style="dim"
    ))


def main():
    parser = argparse.ArgumentParser(description="Multi-Persona AI Agent")
    parser.add_argument("--persona", choices=["coding", "devops", "security"],
                        help="Start with a specific persona")
    parser.add_argument("--provider", default="bedrock",
                        choices=["bedrock", "openai", "anthropic", "litellm"],
                        help="LLM provider (default: bedrock)")
    parser.add_argument("--model", default=None,
                        help="Override the model ID for the chosen provider")
    args = parser.parse_args()

    console.print(Panel(
        "[bold]Multi-Persona AI Agent[/bold]\n"
        "Powered by your ai-agent-templates knowledge base",
        border_style="green"
    ))

    # Pick persona
    domain = args.persona or pick_persona()
    console.print(f"\n  Loading [bold cyan]{domain}[/bold cyan] persona...\n")

    # Create agent
    agent = create_agent(domain, args.provider, args.model)

    skills = list_skills(domain)
    design = list_design_docs(domain)
    console.print(f"  Persona loaded. Skills: [dim]{', '.join(skills)}[/dim]")
    if design:
        for cat, names in design.items():
            console.print(f"  Design [{cat}]: [dim]{', '.join(names)}[/dim]")
    console.print(f"  Type [cyan]/help[/cyan] for commands, [cyan]/context[/cyan] to see what's loaded.\n")

    # Chat loop
    while True:
        try:
            user_input = Prompt.ask(f"[bold green]{domain}[/bold green]")
        except (KeyboardInterrupt, EOFError):
            console.print("\nGoodbye.")
            break

        if not user_input.strip():
            continue

        # Handle slash commands
        cmd = user_input.strip().lower()

        if cmd == "/quit" or cmd == "/exit":
            console.print("Goodbye.")
            break

        elif cmd == "/help":
            show_help()
            continue

        elif cmd == "/skills":
            skills = list_skills(domain)
            console.print(f"Available skills for [cyan]{domain}[/cyan]:")
            for s in skills:
                console.print(f"  • {s}")
            continue

        elif cmd.startswith("/skill "):
            skill_name = cmd.split(" ", 1)[1].strip()
            content = load_skill(domain, skill_name)
            if content:
                console.print(Markdown(content))
            else:
                console.print(f"[red]Skill '{skill_name}' not found.[/red] Available: {', '.join(list_skills(domain))}")
            continue

        elif cmd.startswith("/switch "):
            new_domain = cmd.split(" ", 1)[1].strip()
            if new_domain in get_domains():
                domain = new_domain
                console.print(f"\n  Switching to [bold cyan]{domain}[/bold cyan] persona...\n")
                agent = create_agent(domain, args.provider, args.model)
                skills = list_skills(domain)
                design = list_design_docs(domain)
                console.print(f"  Persona loaded. Skills: [dim]{', '.join(skills)}[/dim]")
                if design:
                    for cat, names in design.items():
                        console.print(f"  Design [{cat}]: [dim]{', '.join(names)}[/dim]")
                console.print()
            else:
                console.print(f"[red]Unknown domain.[/red] Choose from: coding, devops, security")
            continue

        elif cmd == "/design":
            design = list_design_docs(domain)
            if design:
                console.print(f"Design docs loaded as context for [cyan]{domain}[/cyan]:")
                for cat, names in design.items():
                    console.print(f"  [bold]{cat}[/bold]:")
                    for n in names:
                        console.print(f"    • {n}")
            else:
                console.print(f"[dim]No design docs found for {domain}[/dim]")
            continue

        elif cmd == "/context":
            console.print(f"\n[bold]Loaded context for [cyan]{domain}[/cyan]:[/bold]\n")
            domains = get_domains()
            console.print(f"  Persona: {domains[domain]['persona']}")
            console.print(f"  Team config: {domains[domain]['agents']}")
            design = list_design_docs(domain)
            if design:
                console.print("  Design docs:")
                for cat, names in design.items():
                    console.print(f"    {cat}: {', '.join(names)}")
            skills = list_skills(domain)
            console.print(f"  Skills: {', '.join(skills)}")
            console.print(f"\n  [dim]All of the above are included in the agent's system prompt.[/dim]\n")
            continue

        # Send to agent
        try:
            response = agent(user_input)
            console.print()
            console.print(Markdown(str(response)))
            console.print()
        except Exception as e:
            console.print(f"[red]Error: {e}[/red]")


if __name__ == "__main__":
    main()
