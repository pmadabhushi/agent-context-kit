# Agent Context Kit — Cheat Sheet

One-page reference for building AI agent configurations.

## File Structure (Minimum Viable)

```
your-repo/
├── AGENTS.md      ← Required. Agent reads this first.
├── persona.md     ← Recommended. How the agent thinks.
├── skills/        ← Optional. Step-by-step runbooks.
└── design/        ← Optional. Architecture docs.
```

## AGENTS.md — Quick Template

```markdown
# AGENTS.md — [Your Service]

## Service Overview
- **Service:** [ServiceName]
- **Language:** [Language/Framework]
- **Database:** [Database]

## Build & Run
\```bash
[install command]
[build command]
[test command]
\```

## Safety Rules
- Never commit secrets
- Always run tests before pushing
- Ask before modifying production

## Skills Available
| Skill | File | When to Load |
|---|---|---|
| [Skill Name] | `skills/[name].md` | [When to use it] |
```

## persona.md — Quick Template

```markdown
# PERSONA: [Role Name]

## Identity
- **Role:** [Role] — [Team/Project]
- **Scope:** [What this agent covers]

## Mindset
- [How the agent should think]
- [What it prioritizes]
- [What it avoids]

## Safety Rules
- [Rule 1]
- [Rule 2]

## Output Format
\```
Task:     [What was done]
Status:   [Result]
Next:     [Recommended action]
\```
```

## skills/[name].md — Quick Template

```markdown
# SKILL: [Skill Name]

**Trigger:** [When to use this skill]

## Prerequisites
- [ ] [Prerequisite 1]
- [ ] [Prerequisite 2]

## Steps
1. [Step 1]
2. [Step 2]
3. [Step 3]

## Output Format
\```
[Structured output template]
\```

## Escalation
- [When to escalate and to whom]
```

## Placeholder Convention

Use `[brackets]` for values teams need to fill in:
- `[ServiceName]` — your service name
- `[Language]` — programming language
- `[X]%` — numeric thresholds
- `[Link]` — URLs to dashboards, wikis, etc.
- `[team alias]` — team contact info

## What Goes Where

| Information | Put it in |
|---|---|
| Build commands, branch strategy | `AGENTS.md` |
| How the agent thinks and behaves | `persona.md` |
| Step-by-step procedures | `skills/[name].md` |
| Architecture, API specs | `design/[category]/[name].md` |
| Thresholds, SLAs, escalation | `AGENTS.md` or relevant skill |
| Safety rules | `AGENTS.md` + `persona.md` |

## Common Mistakes

| Mistake | Fix |
|---|---|
| Putting everything in AGENTS.md | Split: config in AGENTS.md, procedures in skills, behavior in persona |
| No safety rules | Always include at least: no secrets, confirm before destructive actions |
| Vague skills ("deploy the thing") | Numbered steps with actual commands |
| No output format | Define a structured template so reports are consistent |
| Forgetting placeholders | Use `[brackets]` so it's obvious what needs customizing |

## Progressive Adoption

```
Week 1:  AGENTS.md only (build commands, safety rules)
Week 2:  Add persona.md (consistent behavior)
Week 3:  Add your first skill (most common procedure)
Week 4+: Add design docs as needed
```
