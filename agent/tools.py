"""
Custom tools for the multi-persona agent.
These give the agent real capabilities beyond just chatting.
"""

import subprocess
import os
from pathlib import Path
from strands import tool

from config import (
    TEMPLATES_ROOT, read_md, load_skill, load_all_skills,
    list_skills, get_domains, load_design_docs, list_design_docs,
)


@tool
def run_shell(command: str, timeout: int = 30) -> str:
    """Run a shell command and return the output. Use for gathering system info,
    checking service health, running builds, querying logs, etc.

    Args:
        command: The shell command to execute.
        timeout: Max seconds to wait (default 30).
    """
    try:
        result = subprocess.run(
            command, shell=True, capture_output=True, text=True,
            timeout=timeout, cwd=str(TEMPLATES_ROOT)
        )
        output = result.stdout
        if result.stderr:
            output += f"\nSTDERR:\n{result.stderr}"
        if result.returncode != 0:
            output += f"\n[Exit code: {result.returncode}]"
        return output.strip() or "[No output]"
    except subprocess.TimeoutExpired:
        return f"[Command timed out after {timeout}s]"
    except Exception as e:
        return f"[Error: {e}]"


@tool
def read_file(file_path: str) -> str:
    """Read the contents of a file. Use for reading config files, logs,
    source code, design docs, etc.

    Args:
        file_path: Path to the file (absolute or relative to repo root).
    """
    path = Path(file_path)
    if not path.is_absolute():
        path = TEMPLATES_ROOT / path
    if not path.exists():
        return f"[File not found: {file_path}]"
    try:
        content = path.read_text()
        if len(content) > 10000:
            return content[:10000] + f"\n\n[Truncated — file is {len(content)} chars]"
        return content
    except Exception as e:
        return f"[Error reading file: {e}]"


@tool
def list_directory(dir_path: str = ".") -> str:
    """List files and directories at the given path.

    Args:
        dir_path: Directory path (absolute or relative to repo root).
    """
    path = Path(dir_path)
    if not path.is_absolute():
        path = TEMPLATES_ROOT / path
    if not path.exists():
        return f"[Directory not found: {dir_path}]"
    try:
        entries = sorted(path.iterdir())
        lines = []
        for e in entries:
            prefix = "📁" if e.is_dir() else "📄"
            lines.append(f"  {prefix} {e.name}")
        return f"Contents of {dir_path}/:\n" + "\n".join(lines)
    except Exception as e:
        return f"[Error: {e}]"


@tool
def get_skill(domain: str, skill_name: str) -> str:
    """Load a specific skill's step-by-step instructions.
    Call this before performing any operational task.

    Args:
        domain: The domain (coding, devops, security).
        skill_name: The skill to load (e.g., deploy_service, incident_triage).
    """
    content = load_skill(domain, skill_name)
    if content:
        return content
    available = list_skills(domain)
    return f"[Skill '{skill_name}' not found in {domain}. Available: {', '.join(available)}]"


@tool
def search_design_docs(domain: str, search_term: str) -> str:
    """Search across all design documents for a domain.
    Use this to find specific architecture details, API specs, patterns,
    threat models, policies, or controls.

    Args:
        domain: The domain to search (coding, devops, security).
        search_term: Text to search for (case-insensitive).
    """
    design_docs = load_design_docs(domain)
    if not design_docs:
        return f"[No design docs found for {domain}]"

    results = []
    term_lower = search_term.lower()

    for category, docs in design_docs.items():
        for doc in docs:
            content = doc["content"]
            if term_lower in content.lower():
                # Find matching lines with context
                lines = content.split("\n")
                matches = []
                for i, line in enumerate(lines):
                    if term_lower in line.lower():
                        start = max(0, i - 1)
                        end = min(len(lines), i + 2)
                        context = "\n".join(lines[start:end])
                        matches.append(f"  Line {i+1}:\n{context}")

                results.append(
                    f"📄 [{category}] {doc['name']} ({doc['path']})\n"
                    + "\n---\n".join(matches[:5])  # cap at 5 matches per doc
                )

    if not results:
        return f"[No matches for '{search_term}' in {domain} design docs]"

    return f"Found {len(results)} document(s) matching '{search_term}':\n\n" + "\n\n".join(results)


@tool
def get_design_doc(domain: str, category: str, doc_name: str) -> str:
    """Load a specific design document by category and name.

    Args:
        domain: The domain (coding, devops, security).
        category: The design category (e.g., services, architecture, threat_models).
        doc_name: The document name (without .md extension).
    """
    design_docs = load_design_docs(domain)
    if category not in design_docs:
        available = list(design_docs.keys())
        return f"[Category '{category}' not found. Available: {', '.join(available)}]"

    for doc in design_docs[category]:
        if doc["name"].lower() == doc_name.lower():
            return f"# {doc['name']} ({doc['path']})\n\n{doc['content']}"

    names = [d["name"] for d in design_docs[category]]
    return f"[Doc '{doc_name}' not found in {category}. Available: {', '.join(names)}]"


@tool
def list_all_context(domain: str) -> str:
    """List all available context for a domain: design docs, skills, and persona.
    Use this to understand what knowledge is available before answering.

    Args:
        domain: The domain (coding, devops, security).
    """
    domains = get_domains()
    if domain not in domains:
        return f"[Unknown domain. Available: {', '.join(domains.keys())}]"

    lines = [f"# Available Context for {domain}\n"]

    # Persona
    lines.append(f"## Persona: {domains[domain]['persona']}")

    # AGENTS.md
    lines.append(f"## Team Config: {domains[domain]['agents']}")

    # Design docs
    design = list_design_docs(domain)
    if design:
        lines.append("\n## Design Documents")
        for category, names in design.items():
            lines.append(f"  **{category}:** {', '.join(names)}")

    # Skills
    skills = list_skills(domain)
    lines.append(f"\n## Skills: {', '.join(skills)}")

    return "\n".join(lines)


@tool
def switch_persona_info(target_domain: str) -> str:
    """Get information about switching to a different persona.
    Returns the available personas and how to switch.

    Args:
        target_domain: The domain to switch to (coding, devops, security).
    """
    domains = get_domains()
    if target_domain not in domains:
        return f"[Unknown domain. Available: {', '.join(domains.keys())}]"
    desc = domains[target_domain]["description"]
    skills = list_skills(target_domain)
    design = list_design_docs(target_domain)
    design_summary = ", ".join(
        f"{cat}: {len(docs)}" for cat, docs in design.items()
    ) if design else "none"
    return (
        f"Domain: {target_domain}\n"
        f"Description: {desc}\n"
        f"Skills: {', '.join(skills)}\n"
        f"Design docs: {design_summary}\n\n"
        f"To switch, the user should type: /switch {target_domain}"
    )


# Collect all tools for the agent
ALL_TOOLS = [
    run_shell,
    read_file,
    list_directory,
    get_skill,
    search_design_docs,
    get_design_doc,
    list_all_context,
    switch_persona_info,
]
