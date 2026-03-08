"""
Custom tools for the multi-persona agent.
These give the agent real capabilities beyond just chatting.
"""

import subprocess
import os
from pathlib import Path
from strands import tool

from config import TEMPLATES_ROOT, read_md, load_skill, list_skills, get_domains


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
    return (
        f"Domain: {target_domain}\n"
        f"Description: {desc}\n"
        f"Skills: {', '.join(skills)}\n\n"
        f"To switch, the user should type: /switch {target_domain}"
    )


# Collect all tools for the agent
ALL_TOOLS = [run_shell, read_file, list_directory, get_skill, switch_persona_info]
