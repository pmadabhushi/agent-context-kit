# Advanced Patterns

This guide is for practitioners who have working agent configs and want to push
further — multi-agent setups, context window optimization, prompt engineering
techniques, and versioning strategies.

## Multi-Agent Orchestration

### When One Persona Isn't Enough

Real incidents often cross domain boundaries. A production outage might need:
1. DevOps persona to diagnose the infrastructure issue
2. Coding persona to identify the bug in the code
3. Security persona to assess whether the incident has security implications

### Pattern: Sequential Handoff

The simplest multi-agent pattern. One persona completes its work and hands off
to the next with a structured summary.

```
User: "We're seeing 5xx errors and suspicious access patterns in the logs"

→ DevOps persona runs incident_triage skill
  Output: structured incident report with root cause hypothesis

→ User: "/switch security"
→ Security persona receives the incident report as context
  Output: security assessment with IOC analysis

→ User: "/switch coding"  
→ Coding persona receives both reports
  Output: code fix with PR
```

To make this work well, design your output formats to be machine-readable.
The structured output from one persona becomes input context for the next.

### Pattern: Parallel Investigation

For time-sensitive incidents, run multiple personas simultaneously (in separate
sessions) and merge their findings:

```
Session 1 (DevOps):  Investigate infrastructure, check deployments, analyze metrics
Session 2 (Security): Check access logs, scan for IOCs, review auth events
Session 3 (Coding):   Review recent commits, check for known bug patterns

→ Merge findings into a unified incident report
```

### Pattern: Supervisor Agent

Build a lightweight orchestrator that decides which persona to invoke:

```python
# Pseudocode for a supervisor pattern
def handle_request(user_input):
    # Classify the request
    domain = classify_domain(user_input)  # "devops", "coding", "security"
    
    # Check if it spans multiple domains
    if spans_multiple_domains(user_input):
        # Run primary domain first, then hand off
        primary = run_agent(domain, user_input)
        secondary_domains = get_secondary_domains(user_input, domain)
        for d in secondary_domains:
            run_agent(d, user_input + "\n\nContext from previous analysis:\n" + primary)
    else:
        run_agent(domain, user_input)
```

## Context Window Management

### The Problem

A fully loaded system prompt (persona + AGENTS.md + all design docs + all skills)
can easily hit 20-30K tokens. That leaves less room for conversation history and
tool outputs.

### Strategy 1: Tiered Loading

Load context in tiers based on what's needed:

```
Tier 1 (Always loaded):  persona.md + AGENTS.md (~2-4K tokens)
Tier 2 (Auto-loaded):    Matching skill based on keyword detection (~1-2K tokens)
Tier 3 (On demand):      Design docs loaded via search_design_docs tool (~1-5K tokens)
```

The agent code already supports this — skills are in the system prompt but design
docs can also be fetched on demand via tools. For very large configurations, consider
moving skills to on-demand loading too.

### Strategy 2: Summarized Context

For large design docs, create summary versions:

```
design/
├── services/
│   ├── ORDER_SERVICE.md           # Full design doc (5K tokens)
│   └── ORDER_SERVICE_SUMMARY.md   # Key facts only (500 tokens)
```

Load summaries into the system prompt. The agent can fetch the full doc when it
needs details.

### Strategy 3: Scoped Configs

Instead of one massive AGENTS.md, create scoped versions:

```
AGENTS.md                    # Core config (always loaded)
AGENTS-deployment.md         # Extra context for deployment tasks
AGENTS-incident-response.md  # Extra context for incident work
```

Load the scoped config based on the task at hand.

### Measuring Token Usage

Add a token counter to your agent to track how much context you're using:

```python
import tiktoken

def count_tokens(text, model="cl100k_base"):
    enc = tiktoken.get_encoding(model)
    return len(enc.encode(text))

# In your agent setup:
system_prompt = build_system_prompt(domain)
print(f"System prompt: {count_tokens(system_prompt)} tokens")
```

## Dynamic Skill Loading

### Beyond Keyword Matching

The built-in keyword trigger map is a good start, but you can build more
sophisticated skill loading:

### Pattern: Intent Classification

Use the LLM itself to classify intent before loading a skill:

```python
CLASSIFICATION_PROMPT = """Given this user message, which skill should be loaded?
Available skills: {skills}
User message: {message}
Respond with just the skill name, or "none" if no skill matches."""
```

### Pattern: Skill Chaining

Some tasks require multiple skills in sequence. Define chains:

```yaml
# skill_chains.yaml
deploy_with_validation:
  - run_tests        # Step 1: Validate
  - deploy_service   # Step 2: Deploy
  - health_check     # Step 3: Verify

incident_to_fix:
  - incident_triage  # Step 1: Diagnose
  - run_tests        # Step 2: Reproduce
  - raise_cr         # Step 3: Fix
```

### Pattern: Conditional Skills

Load different skill variants based on context:

```python
def select_skill(domain, skill_name, context):
    # Check if there's a context-specific variant
    env = context.get("environment", "prod")
    variant = f"{skill_name}_{env}"  # e.g., "deploy_service_staging"
    
    if skill_exists(domain, variant):
        return load_skill(domain, variant)
    return load_skill(domain, skill_name)
```

## Prompt Engineering for Agent Configs

### Effective Persona Writing

Weak persona:
```markdown
## Mindset
- Be helpful
- Be careful with production
```

Strong persona:
```markdown
## Mindset
- You think like an on-call engineer who has been paged at 3am. Every action
  has consequences. You gather data before forming hypotheses.
- You treat production as a live patient — observe first, diagnose second,
  intervene only when you have a clear plan and rollback strategy.
- When you don't know something, you say so. You never guess at system state.
```

The difference: specificity, mental models, and concrete behavioral rules.

### Effective Skill Writing

Weak skill:
```markdown
## Steps
1. Deploy the service
2. Check if it works
3. Tell the user
```

Strong skill:
```markdown
## Steps
1. Verify prerequisites:
   - [ ] Tests passing: `make test`
   - [ ] Pipeline badge: `pipeline-status --service [ServiceName]`
   - [ ] No active incidents: check PagerDuty
2. Deploy to staging: `deploy --service [ServiceName] --env staging --version [X.Y.Z]`
3. Validate staging (wait 5 minutes):
   - Error rate: `metrics --service [ServiceName] --env staging --metric error_rate`
   - Expected: < 0.5%. If > 1%, abort and investigate.
4. Promote to prod: `deploy --service [ServiceName] --env prod --version [X.Y.Z]`
5. Monitor prod for 10 minutes:
   - Error rate: < 0.5%
   - P99 latency: < 500ms
   - If thresholds exceeded: initiate rollback (see skills/rollback_service.md)
```

The difference: actual commands, specific thresholds, decision points, and
cross-references to other skills.

### The "Think Like" Pattern

The most effective persona technique is giving the agent a mental model:

```markdown
- Think like a threat actor first, then switch to defender.
- Think like an on-call engineer who just got paged.
- Think like a code reviewer who has to maintain this code for 5 years.
- Think like a field engineer who can't physically touch the equipment.
```

This single line shapes all downstream reasoning more than pages of rules.

## Versioning Agent Configs

### Treat Configs as Code

Agent configs should follow the same versioning discipline as application code:

```
# In your service repo
git log --oneline -- AGENTS.md persona.md skills/ design/

a1b2c3d feat: add health_check skill for pre-deployment validation
d4e5f6g fix: update deploy thresholds after capacity increase
g7h8i9j docs: add new API endpoint to AGENTS.md
```

### Semantic Versioning for Templates

If you distribute templates across teams, version them:

```json
{
  "name": "devops-agent-config",
  "version": "2.1.0",
  "min_compatible_agent": "1.0.0"
}
```

- Major: breaking changes (renamed skills, restructured AGENTS.md)
- Minor: new skills or design docs added
- Patch: threshold updates, typo fixes, clarifications

### Config Drift Detection

Add a CI check that validates your agent config matches reality:

```yaml
# .github/workflows/validate-agent-config.yml
- name: Check deploy commands exist
  run: |
    # Extract commands from skills and verify they exist
    grep -oP '`[^`]+`' skills/deploy_service.md | while read cmd; do
      command_name=$(echo $cmd | awk '{print $1}' | tr -d '`')
      which $command_name || echo "WARNING: $command_name not found"
    done
```

### Environment-Specific Overrides

Maintain a base config with environment overlays:

```
AGENTS.md                    # Base config
AGENTS.staging.md            # Staging-specific overrides
AGENTS.prod.md               # Prod-specific overrides (stricter safety rules)
```

Your agent loader merges them:

```python
def load_agents_md(domain, environment="prod"):
    base = read_md(f"{domain}/AGENTS.md")
    override_path = f"{domain}/AGENTS.{environment}.md"
    if Path(override_path).exists():
        override = read_md(override_path)
        return base + "\n\n# Environment Overrides\n" + override
    return base
```

## Worked Example: Cross-Domain Incident Response

Here's a concrete example using the actual repo files to handle an incident
that spans DevOps and Security domains.

### The Scenario

OrderService is returning 5xx errors AND the security team flagged suspicious
access patterns in the same timeframe. This needs both domains.

### Session 1: DevOps Triage

```
# Start with devops persona
python main.py --persona devops

devops> We're seeing 5xx errors on OrderService (3% error rate) AND security
        flagged unusual API access patterns in the last 2 hours.

Agent: Loading skill: incident_triage

       Step 1 — Severity Assessment:
       Error rate 3% exceeds the 2% threshold → SEV2
       Combined with security flag → escalating to SEV1

       Step 2 — Recent Changes:
       > Checking deployments...
       v2.4.0 deployed 2 hours ago (correlates with both issues)

       Step 3 — Root Cause Hypothesis:
       The v2.4.0 deploy changed the auth middleware. This could explain
       both the 5xx errors (broken auth → rejections) and the unusual
       access patterns (auth bypass → unauthorized requests getting through).

       Recommendation: Rollback v2.4.0 immediately, then hand off to
       security for access pattern analysis.

       Investigation Summary
       ---------------------
       Service:     OrderService
       Severity:    SEV1 (infra + security)
       Root Cause:  v2.4.0 auth middleware change
       Action:      Immediate rollback, security handoff

devops> /switch security
```

### Session 2: Security Assessment

```
security> Based on the DevOps triage (v2.4.0 auth middleware change caused
          5xx errors and unusual access patterns), assess the security impact.

Agent: Loading skill: incident_response

       Step 1 — Scope Assessment:
       Timeframe: 2 hours (v2.4.0 deploy to rollback)
       Affected endpoint: POST /api/v1/orders (auth middleware path)

       Step 2 — Access Log Analysis:
       > Checking auth logs for the 2-hour window...
       Found: 47 requests that bypassed auth validation
       Source IPs: 3 unique IPs, 2 are known internal, 1 external

       Step 3 — Data Exposure Check:
       Per design/services/order-service.md, the orders endpoint
       handles PII (customer name, address, payment token).
       47 requests × order data = potential PII exposure.

       Step 4 — Containment:
       - Rollback already completed (DevOps)
       - Block external IP at WAF
       - Invalidate any sessions created during the window

       Security Assessment
       --------------------
       Classification: Data exposure incident
       PII at risk:    47 order records
       External access: 1 IP (blocked)
       Required:        Privacy team notification within 24h
```

This shows the sequential handoff pattern in practice — the DevOps persona's
structured output becomes input context for the Security persona.

### Token Budget for This Session

```
DevOps persona system prompt:
  persona.md:           ~800 tokens
  AGENTS.md:            ~600 tokens
  Design docs:          ~2,000 tokens (service templates)
  All 7 skills:         ~3,500 tokens
  Trigger map + rules:  ~500 tokens
  Total:                ~7,400 tokens

Security persona system prompt:
  persona.md:           ~900 tokens
  AGENTS.md:            ~500 tokens
  Design docs:          ~2,500 tokens (threat models, policies, controls)
  All 4 skills:         ~2,000 tokens
  Trigger map + rules:  ~400 tokens
  Total:                ~6,300 tokens
```

Both fit comfortably in a 128K context window. For smaller windows (8K-32K),
use the tiered loading strategy from the Context Window Management section.

## Anti-Patterns to Avoid

| Anti-Pattern | Why It's Bad | What to Do Instead |
|---|---|---|
| Putting everything in AGENTS.md | Hits token limits, hard to maintain | Split into persona, skills, design docs |
| Vague safety rules ("be careful") | Agent interprets loosely | Specific rules with thresholds and actions |
| No output format | Inconsistent reports, hard to parse | Define structured templates in persona |
| Copy-pasting between personas | Drift over time, maintenance burden | Use shared snippets or inheritance |
| Hardcoding URLs in skills | Breaks across environments | Use placeholders or env-specific configs |
| Loading all context always | Wastes tokens, dilutes relevance | Tiered loading: always → auto → on-demand |
| No escalation rules | Agent tries to handle everything | Define clear "stop and escalate" conditions |
