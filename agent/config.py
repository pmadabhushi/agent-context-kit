"""
Configuration for the multi-persona agent.
Reads template.json and resolves all persona/skill/design file paths.
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
    persona_path = domains[domain]["persona"]
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


def load_all_skills(domain: str) -> dict[str, str]:
    """Load ALL skills for a domain. Returns dict of skill_name -> content."""
    domains = get_domains()
    result = {}
    for skill_path in domains[domain]["skills"]:
        # Extract skill name from path like "devops/skills/deploy_service.md"
        name = Path(skill_path).stem  # e.g., "deploy_service"
        content = read_md(skill_path)
        if not content.startswith("[File not found"):
            result[name] = content
    return result


def list_skills(domain: str) -> list[str]:
    """List available skill names for a domain."""
    domains = get_domains()
    skills = []
    for skill_path in domains[domain]["skills"]:
        skill_name = Path(skill_path).stem  # e.g., "deploy_service"
        skills.append(skill_name)
    return skills


def load_design_docs(domain: str) -> dict[str, list[dict]]:
    """Load all design docs for a domain.

    Returns dict of category -> list of {name, path, content}.
    Scans each design directory for .md files.
    """
    domains = get_domains()
    design_config = domains[domain].get("design", {})
    result = {}

    for category, dir_path in design_config.items():
        full_dir = TEMPLATES_ROOT / dir_path
        if not full_dir.exists():
            continue
        docs = []
        for md_file in sorted(full_dir.glob("*.md")):
            relative = str(md_file.relative_to(TEMPLATES_ROOT))
            docs.append({
                "name": md_file.stem,
                "path": relative,
                "content": md_file.read_text()
            })
        if docs:
            result[category] = docs

    return result


def list_design_docs(domain: str) -> dict[str, list[str]]:
    """List design doc names by category for a domain (without loading content)."""
    domains = get_domains()
    design_config = domains[domain].get("design", {})
    result = {}

    for category, dir_path in design_config.items():
        full_dir = TEMPLATES_ROOT / dir_path
        if not full_dir.exists():
            continue
        files = [f.stem for f in sorted(full_dir.glob("*.md"))]
        if files:
            result[category] = files

    return result


def _build_design_context(domain: str) -> str:
    """Build the design docs section of the system prompt."""
    design_docs = load_design_docs(domain)
    if not design_docs:
        return "No design documents found for this domain."

    sections = []
    for category, docs in design_docs.items():
        sections.append(f"### {category.replace('_', ' ').title()}")
        for doc in docs:
            sections.append(f"#### {doc['name']} (`{doc['path']}`)")
            sections.append(doc["content"])
            sections.append("")  # blank line separator

    return "\n".join(sections)


def _build_skills_context(domain: str) -> str:
    """Build the skills section — includes full skill content in the prompt."""
    all_skills = load_all_skills(domain)
    if not all_skills:
        return "No skills found for this domain."

    sections = []
    for skill_name, content in all_skills.items():
        sections.append(f"### Skill: {skill_name}")
        sections.append(content)
        sections.append("")

    return "\n".join(sections)


SKILL_TRIGGER_MAP = {
    "devops": {
        "deploy_service": ["deploy", "deployment", "release", "ship", "push to prod"],
        "rollback_service": ["rollback", "revert", "undo deploy", "roll back"],
        "incident_triage": ["incident", "outage", "sev1", "sev2", "pager", "alert firing", "down"],
        "scale_service": ["scale", "scaling", "capacity", "autoscal", "traffic spike"],
        "log_analysis": ["log", "logs", "logging", "log search", "cloudwatch", "splunk", "trace"],
        "infrastructure_management": ["infrastructure", "iac", "terraform", "cdk", "cloudformation", "provision"],
        "health_check": ["health", "health check", "status", "heartbeat", "readiness", "liveness"],
    },
    "coding": {
        "raise_cr": ["code review", "cr", "pull request", "pr", "merge request"],
        "run_tests": ["test", "tests", "unit test", "integration test", "test suite"],
        "generate_changelog": ["changelog", "release notes", "what changed"],
    },
    "security": {
        "vuln_triage": ["vulnerability", "vuln", "cve", "security scan", "finding", "cvss"],
        "incident_response": ["security incident", "breach", "compromise", "unauthorized access"],
        "secrets_rotation": ["secret", "rotate", "credential", "api key", "token", "password rotation"],
        "access_review": ["access review", "iam", "permissions", "role", "access audit", "least privilege"],
    },
}


def build_system_prompt(domain: str) -> str:
    """Build the full system prompt for a domain agent.

    Includes: persona + AGENTS.md + all design docs + all skills + trigger map.
    """
    persona = load_persona(domain)
    agents_md = load_agents_md(domain)
    design_context = _build_design_context(domain)
    skills_context = _build_skills_context(domain)
    skills_list = list_skills(domain)

    # Build trigger instructions
    triggers = SKILL_TRIGGER_MAP.get(domain, {})
    trigger_lines = []
    for skill, keywords in triggers.items():
        trigger_lines.append(f"  - If the user mentions: {', '.join(keywords)} → auto-load skill **{skill}**")
    trigger_instructions = "\n".join(trigger_lines) if trigger_lines else "  (No auto-triggers defined)"

    return f"""You are an AI agent operating in the **{domain}** domain.

Your persona, mindset, methodology, safety rules, design context, and skills are
all defined below. Follow them precisely.

---
# PERSONA
{persona}

---
# TEAM CONFIGURATION (AGENTS.MD)
{agents_md}

---
# DESIGN CONTEXT
These are the architecture, service, and design documents for your domain.
Use them to understand the system before answering questions or taking action.
Reference specific sections when explaining your reasoning.

{design_context}

---
# SKILLS (FULL INSTRUCTIONS)
Below are all the skills available to you with their complete step-by-step
instructions. When a task matches a skill, follow its procedure exactly.

{skills_context}

---
# SKILL AUTO-LOADING RULES
When the user's message matches certain keywords, automatically load and follow
the corresponding skill without being asked:

{trigger_instructions}

When you auto-load a skill, tell the user: "Loading skill: [skill_name]" before
proceeding with the skill's steps.

---
# INTERACTION RULES
- Always identify yourself by your persona at the start of a conversation.
- Before answering any architecture or design question, reference the design docs above.
- When performing any operational task, follow the matching skill's steps exactly.
- If the user asks you to do something outside your domain, suggest switching to the appropriate persona.
- Use the tools available to you (shell, file reading, design doc search) to gather real data.
- Follow the output format defined in your persona for all reports.
- Ask for confirmation before any destructive or production-impacting action.
- You can also use the `get_skill` tool to reload a skill at any time, or
  `search_design_docs` to find specific information across design documents.
"""
