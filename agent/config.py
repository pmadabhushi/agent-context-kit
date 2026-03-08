"""
Configuration for the multi-persona agent.
Reads template.json and resolves all persona/skill file paths.
"""

import json
import os
from pathlib import Path

# Root of the templates repo (one level up from agent/)
TEMPLATES_ROOT = Path(__file__).resolve().parent.parent

TEMPLATE_MANIFEST = TEMPLATES_ROOT / "template.json"


def load_manifest() -> dict:
    """Load template.json manifest."""
    with open(TEMPLATE_MANIFEST) as f:
        return json.load(f)


def get_domains() -> dict:
    """Return domain configs keyed by domain name."""
    return load_manifest()["domains"]


def read_md(relative_path: str) -> str:
    """Read a markdown file relative to the templates root."""
    full_path = TEMPLATES_ROOT / relative_path
    if not full_path.exists():
        return f"[File not found: {relative_path}]"
    return full_path.read_text()


def load_persona(domain: str) -> str:
    """Load the persona markdown for a domain."""
    domains = get_domains()
    if domain not in domains:
        raise ValueError(f"Unknown domain: {domain}. Choose from: {list(domains.keys())}")
    persona_path = domains[domain]["personas"][0]
    return read_md(persona_path)


def load_agents_md(domain: str) -> str:
    """Load the AGENTS.md for a domain."""
    domains = get_domains()
    return read_md(domains[domain]["agents"])


def load_skill(domain: str, skill_name: str) -> str | None:
    """Load a specific skill by name for a domain. Returns None if not found."""
    domains = get_domains()
    for skill_path in domains[domain]["skills"]:
        if skill_name in skill_path:
            return read_md(skill_path)
    return None


def list_skills(domain: str) -> list[str]:
    """List available skill names for a domain."""
    domains = get_domains()
    skills = []
    for skill_path in domains[domain]["skills"]:
        # Extract skill name from path like "devops/skills/deploy_service/SKILL.md"
        parts = skill_path.split("/")
        skill_name = parts[-2]  # e.g., "deploy_service"
        skills.append(skill_name)
    return skills


def build_system_prompt(domain: str) -> str:
    """Build the full system prompt for a domain agent."""
    persona = load_persona(domain)
    agents_md = load_agents_md(domain)
    skills = list_skills(domain)

    return f"""You are an AI agent operating in the **{domain}** domain.

Your persona, mindset, methodology, and safety rules are defined below.
Follow them precisely.

---
# PERSONA
{persona}

---
# TEAM CONFIGURATION (AGENTS.MD)
{agents_md}

---
# AVAILABLE SKILLS
You can load any of these skills when the task requires it: {', '.join(skills)}

When you need a skill, tell the user which skill you are loading and follow its
step-by-step instructions precisely.

---
# INTERACTION RULES
- Always identify yourself by your persona at the start of a conversation.
- If the user asks you to do something outside your domain, suggest switching to the appropriate persona.
- Use the tools available to you (shell, file reading) to gather real data when answering.
- Follow the output format defined in your persona for all reports.
- Ask for confirmation before any destructive or production-impacting action.
"""
