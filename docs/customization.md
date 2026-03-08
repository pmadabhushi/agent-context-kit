# Customization Guide

This guide covers extending the framework beyond the three built-in domains:
creating new domains, building composite skills, adding custom tools, integrating
with MCP servers, and wiring agent configs into CI/CD.

## Creating a New Domain

The repo ships with coding, devops, and security. Here's how to add your own.

### Step 1: Create the Folder Structure

```bash
mkdir -p templates/data-engineering/skills
mkdir -p templates/data-engineering/design/pipelines
mkdir -p templates/data-engineering/design/schemas
```

### Step 2: Create the Core Files

Minimum viable domain — three files:

```
templates/data-engineering/
├── AGENTS.md      ← Team config, tools, conventions
├── persona.md     ← How the agent thinks
├── README.md      ← Human-readable overview
├── skills/
│   └── ...        ← Add skills as needed
└── design/
    └── ...        ← Add design docs as needed
```

### Step 3: Write AGENTS.md

Start with the essentials:

```markdown
# AGENTS.md — Data Engineering

## Pipeline Overview
- **Orchestrator:** Airflow
- **Compute:** Spark on EMR
- **Storage:** S3 (raw) → Iceberg (curated) → Redshift (serving)
- **Catalog:** AWS Glue Data Catalog

## Conventions
- All DAGs follow naming: `[team]_[source]_[destination]_[frequency]`
- Schema changes require a migration PR with backward compatibility
- Never modify production tables directly — always go through the pipeline

## Safety Rules
- Never drop or truncate production tables without explicit approval
- Never bypass data validation steps in pipelines
- PII columns must be tagged in the data catalog
```

### Step 4: Register in template.json

```json
{
  "data-engineering": {
    "description": "AI data engineering agent — pipelines, schemas, data quality",
    "agents": "templates/data-engineering/AGENTS.md",
    "persona": "templates/data-engineering/persona.md",
    "design": {
      "pipelines": "templates/data-engineering/design/pipelines/",
      "schemas": "templates/data-engineering/design/schemas/"
    },
    "skills": [
      "templates/data-engineering/skills/pipeline_debug.md",
      "templates/data-engineering/skills/schema_migration.md"
    ]
  }
}
```

### Step 5: Add to the Agent

Update `agent/config.py` to add trigger keywords:

```python
SKILL_TRIGGER_MAP["data-engineering"] = {
    "pipeline_debug": ["pipeline", "dag", "airflow", "spark", "etl", "data flow"],
    "schema_migration": ["schema", "migration", "column", "table", "catalog"],
}
```

The agent will now support `/switch data-engineering` and auto-load skills.

### Domain Ideas

| Domain | Focus | Example Skills |
|---|---|---|
| Data Engineering | Pipelines, schemas, data quality | pipeline_debug, schema_migration, data_validation |
| QA / Testing | Test strategy, automation, coverage | test_plan, regression_analysis, flaky_test_triage |
| Platform / SRE | Reliability, SLOs, capacity | slo_review, capacity_planning, toil_reduction |
| ML Engineering | Model training, deployment, monitoring | model_deploy, experiment_tracking, drift_detection |
| Technical Writing | Docs, API references, runbooks | doc_review, api_doc_generation, runbook_audit |

### Worked Example: Creating a Data Engineering Domain

Here's the complete process from scratch to working agent:

```bash
# Step 1: Create folder structure
mkdir -p templates/data-engineering/skills
mkdir -p templates/data-engineering/design/pipelines
mkdir -p templates/data-engineering/design/schemas
```

`templates/data-engineering/persona.md`:
```markdown
# Data Engineering Agent Persona

## Role
You are a senior data engineer responsible for pipeline reliability,
data quality, and schema management.

## Mindset
- You think like an engineer who owns the data SLAs. Late or corrupt data
  has downstream consequences — dashboards go stale, ML models retrain on
  garbage, and business decisions get made on wrong numbers.
- You validate before you transform. You never assume upstream data is clean.
- You treat schema changes like database migrations — backward compatible,
  versioned, and reversible.

## Methodology
1. Understand the data lineage before touching anything
2. Check pipeline health and recent run history
3. Validate data quality at source before investigating transforms
4. Make changes incrementally — one stage at a time

## Safety Rules
- Never drop or truncate production tables
- Never bypass data validation steps
- Schema changes require backward compatibility
- PII columns must be tagged before any pipeline processes them

## Output Format
### Pipeline Investigation Report
- **Pipeline:** [name]
- **Status:** [healthy/degraded/failed]
- **Last Successful Run:** [timestamp]
- **Issue:** [description]
- **Root Cause:** [analysis]
- **Fix:** [recommended action]
```

`templates/data-engineering/AGENTS.md`:
```markdown
# AGENTS.md — Data Engineering

## Pipeline Overview
- **Orchestrator:** [Airflow/Step Functions/Prefect]
- **Compute:** [Spark/Glue/dbt]
- **Storage:** S3 (raw) → [Iceberg/Delta] (curated) → [Redshift/Snowflake] (serving)
- **Catalog:** [Glue Data Catalog/Hive Metastore]

## Conventions
- DAG naming: `[team]_[source]_[destination]_[frequency]`
- All pipelines must have data quality checks at ingestion and output
- Schema changes require a migration PR with backward compatibility proof

## Key Commands
- Pipeline status: `airflow dags list-runs -d [dag_id] --limit 5`
- Trigger backfill: `airflow dags backfill -s [start] -e [end] [dag_id]`
- Data quality: `great_expectations checkpoint run [checkpoint_name]`
- Schema diff: `schema-tool diff --source [old] --target [new]`

## Safety Rules
- Never run DELETE/TRUNCATE on production tables without explicit approval
- Never bypass Great Expectations validation checkpoints
- PII columns must be tagged in the data catalog before processing
- Backfills must be tested on a date range in dev before running in prod
```

```bash
# Step 2: Register in template.json
# Add to the "domains" object:
```

```json
"data-engineering": {
  "description": "AI data engineering agent — pipelines, schemas, data quality",
  "agents": "templates/data-engineering/AGENTS.md",
  "persona": "templates/data-engineering/persona.md",
  "design": {
    "pipelines": "templates/data-engineering/design/pipelines/",
    "schemas": "templates/data-engineering/design/schemas/"
  },
  "skills": [
    "templates/data-engineering/skills/pipeline_debug.md",
    "templates/data-engineering/skills/schema_migration.md"
  ]
}
```

```python
# Step 3: Add trigger keywords to agent/config.py
SKILL_TRIGGER_MAP["data-engineering"] = {
    "pipeline_debug": ["pipeline", "dag", "airflow", "spark", "etl", "data flow", "backfill"],
    "schema_migration": ["schema", "migration", "column", "table", "catalog", "alter"],
}
```

```bash
# Step 4: Test it
python main.py --persona data-engineering
data-engineering> Our daily orders pipeline failed at the transform stage
# Agent loads pipeline_debug skill and follows the steps
```

Total time: ~30 minutes to have a working domain with persona, team config,
and skill auto-loading.

## Composite Skills

### Skills That Call Other Skills

Some tasks naturally chain multiple skills. Define composite skills that
reference sub-skills:

```markdown
# SKILL: Full Release

**Trigger:** User asks for a full release cycle

## Steps

### Phase 1: Validate (load skill: run_tests)
1. Run the full test suite
2. Confirm all tests pass
3. If any fail, stop and report

### Phase 2: Deploy (load skill: deploy_service)
1. Deploy to staging
2. Validate staging
3. Promote to prod

### Phase 3: Verify (load skill: health_check)
1. Run post-deployment health check
2. Monitor for 10 minutes
3. If thresholds exceeded, load skill: rollback_service

### Phase 4: Communicate
1. Generate changelog (load skill: generate_changelog)
2. Post release summary to team channel
```

### Conditional Branching in Skills

Skills can include decision points:

```markdown
## Step 3: Assess Impact

If error rate > 5%:
  → Load skill: rollback_service (immediate rollback)
  → Skip remaining steps

If error rate 2-5%:
  → Continue monitoring for 10 more minutes
  → If still elevated after 10 min, load skill: rollback_service

If error rate < 2%:
  → Deployment successful, proceed to Step 4
```

## Adding Custom Tools to the Agent

### Tool Structure

Tools in the agent follow the Strands SDK pattern:

```python
from strands import tool

@tool
def query_database(query: str, database: str = "prod") -> str:
    """Run a read-only SQL query against the specified database.
    
    Args:
        query: SQL query to execute (SELECT only).
        database: Target database (dev, staging, prod).
    """
    if not query.strip().upper().startswith("SELECT"):
        return "[Error: Only SELECT queries are allowed]"
    
    # Your database connection logic here
    result = execute_query(database, query)
    return format_results(result)
```

### Registering Tools

Add your tool to `agent/tools.py`:

```python
from your_tools import query_database, check_dashboard

ALL_TOOLS = [
    run_shell,
    read_file,
    list_directory,
    get_skill,
    search_design_docs,
    get_design_doc,
    list_all_context,
    switch_persona_info,
    # Your custom tools
    query_database,
    check_dashboard,
]
```

### Tool Design Principles

- Tools should be read-only by default. Write operations need explicit confirmation.
- Return structured text, not raw data dumps.
- Include error handling — the agent will see the error message.
- Keep tool descriptions clear — the LLM uses them to decide when to call the tool.
- Set reasonable timeouts to prevent hanging.

### Domain-Specific Tool Sets

You can load different tools per domain:

```python
DOMAIN_TOOLS = {
    "devops": [run_shell, read_file, check_metrics, list_deployments],
    "coding": [run_shell, read_file, run_tests, search_code],
    "security": [run_shell, read_file, scan_vulnerabilities, check_access],
}

def create_agent(domain, provider, model_id=None):
    tools = COMMON_TOOLS + DOMAIN_TOOLS.get(domain, [])
    agent = Agent(model=model, system_prompt=prompt, tools=tools)
    return agent
```

## MCP Server Integration

### What is MCP?

Model Context Protocol (MCP) is a standard for connecting AI agents to external
tools and data sources. Instead of building custom tools, you connect to MCP
servers that expose capabilities through a standard interface.

### Exposing Agent Context as an MCP Server

You can make your team's knowledge available to any MCP-compatible tool (Kiro,
Cursor, VS Code, etc.) by wrapping the agent's config layer as an MCP server:

```python
# agent/mcp_server.py — Expose agent context via MCP
from mcp.server.fastmcp import FastMCP

from config import (
    load_agents_md, load_persona, load_skill, load_all_skills,
    list_skills, load_design_docs, list_design_docs, get_domains,
)

mcp = FastMCP("agent-context-kit")


@mcp.tool()
def get_team_config(domain: str) -> str:
    """Get the AGENTS.md configuration for a domain.

    Args:
        domain: The domain (coding, devops, security).
    """
    return load_agents_md(domain)


@mcp.tool()
def get_persona(domain: str) -> str:
    """Get the persona definition for a domain.

    Args:
        domain: The domain (coding, devops, security).
    """
    return load_persona(domain)


@mcp.tool()
def get_skill_instructions(domain: str, skill_name: str) -> str:
    """Get step-by-step instructions for a specific skill.

    Args:
        domain: The domain (coding, devops, security).
        skill_name: The skill to load (e.g., deploy_service, incident_triage).
    """
    content = load_skill(domain, skill_name)
    if content:
        return content
    available = list_skills(domain)
    return f"Skill '{skill_name}' not found. Available: {', '.join(available)}"


@mcp.tool()
def search_architecture(domain: str, query: str) -> str:
    """Search design documents for architecture information.

    Args:
        domain: The domain to search.
        query: Text to search for (case-insensitive).
    """
    design_docs = load_design_docs(domain)
    results = []
    for category, docs in design_docs.items():
        for doc in docs:
            if query.lower() in doc["content"].lower():
                # Return first 500 chars of matching doc
                preview = doc["content"][:500]
                results.append(f"[{category}] {doc['name']}:\n{preview}")
    return "\n\n---\n\n".join(results) if results else f"No matches for '{query}'"


@mcp.tool()
def list_available_context(domain: str) -> str:
    """List all available context for a domain: skills, design docs, persona.

    Args:
        domain: The domain (coding, devops, security).
    """
    skills = list_skills(domain)
    design = list_design_docs(domain)
    design_summary = ", ".join(
        f"{cat}: {', '.join(names)}" for cat, names in design.items()
    )
    return (
        f"Domain: {domain}\n"
        f"Skills: {', '.join(skills)}\n"
        f"Design docs: {design_summary}"
    )


if __name__ == "__main__":
    mcp.run()
```

### Configuring the MCP Server

For Kiro, add to `.kiro/settings/mcp.json`:

```json
{
  "mcpServers": {
    "agent-context-kit": {
      "command": "python",
      "args": ["agent/mcp_server.py"],
      "env": {},
      "disabled": false,
      "autoApprove": ["list_available_context", "get_team_config"]
    }
  }
}
```

For Cursor, add to `.cursor/mcp.json` with the same structure.

Now any MCP-compatible tool can query your team's knowledge:

```
User: What's the deployment process for our service?

Tool calls: get_team_config("devops") → returns AGENTS.md
            get_skill_instructions("devops", "deploy_service") → returns skill steps

Agent: Based on your team config, here's the deployment process...
```

### When to Use MCP vs the Full Agent

| Use Case | Approach |
|----------|----------|
| Quick lookups in your AI tool | MCP server (lightweight, read-only) |
| Multi-step operational tasks | Full agent (has shell, file tools, skill chaining) |
| Team onboarding | MCP server (browse context from any tool) |
| Incident response | Full agent (needs to run commands, follow procedures) |
| CI/CD integration | Full agent or direct config loading |

## CI/CD Integration

### Validating Agent Configs in CI

Add checks to your CI pipeline:

```yaml
# .github/workflows/validate-agent-config.yml
- name: Validate AGENTS.md structure
  run: |
    python3 -c "
    from pathlib import Path
    import re
    
    agents_md = Path('AGENTS.md').read_text()
    
    required_sections = [
        'Safety Rules',
        'Skills Available',
    ]
    
    missing = [s for s in required_sections if f'## {s}' not in agents_md]
    if missing:
        print(f'AGENTS.md missing required sections: {missing}')
        exit(1)
    print('AGENTS.md structure valid.')
    "

- name: Check for unfilled placeholders
  run: |
    # Find any remaining [placeholder] values
    if grep -rn '\[.*\]' AGENTS.md persona.md skills/ | grep -v '^\[' | grep -v 'http'; then
      echo "WARNING: Found unfilled placeholders"
    fi
```

### Auto-Generating Agent Configs

For teams with many services, generate AGENTS.md from existing sources:

```python
# generate_agents_md.py
def generate_from_terraform(tf_dir):
    """Extract service info from Terraform configs."""
    # Parse terraform files for service name, region, etc.
    ...

def generate_from_package_json(package_path):
    """Extract build commands from package.json."""
    ...

def generate_from_ci_config(ci_path):
    """Extract pipeline info from CI config."""
    ...

# Combine into AGENTS.md
template = """
# AGENTS.md — {service_name}

## Service Overview
- **Service:** {service_name}
- **Infrastructure:** {infrastructure}
- **Region:** {region}

## Build & Run
```bash
{build_commands}
```

## Safety Rules
{safety_rules}
"""
```

### Agent Config as a PR Check

Run your eval harness as a PR check when agent configs change:

```yaml
- name: Run agent eval
  if: contains(github.event.pull_request.changed_files, 'AGENTS.md') ||
      contains(github.event.pull_request.changed_files, 'persona.md') ||
      contains(github.event.pull_request.changed_files, 'skills/')
  run: |
    python eval_harness.py --domain devops --scenarios eval/scenarios.json
    # Fail the PR if pass rate drops below threshold
```

## Sharing Configs Across Teams

### Pattern: Shared Base + Team Overrides

Create a shared base config that all teams inherit from:

```
shared/
├── AGENTS-base.md           # Company-wide conventions
├── persona-base.md          # Shared mindset and safety rules
└── skills/
    └── incident_response.md # Company-wide incident process

team-a/
├── AGENTS.md                # Imports shared base + team-specific config
├── persona.md               # Extends shared persona
└── skills/
    └── deploy_service.md    # Team-specific deployment process
```

### Pattern: Template Registry

Maintain a central registry of approved templates:

```json
{
  "registry": {
    "devops-base": {
      "version": "2.1.0",
      "source": "https://github.com/org/agent-configs/templates/devops",
      "last_updated": "2025-03-01"
    },
    "security-base": {
      "version": "1.3.0",
      "source": "https://github.com/org/agent-configs/templates/security",
      "last_updated": "2025-02-15"
    }
  }
}
```

Teams pull from the registry and customize:

```bash
# Pull latest base template
curl -sL https://github.com/org/agent-configs/templates/devops/AGENTS.md > AGENTS-base.md

# Team customizes on top
cat AGENTS-base.md team-overrides.md > AGENTS.md
```

This keeps company-wide standards consistent while allowing team-level customization.
