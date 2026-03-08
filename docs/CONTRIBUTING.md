# Contributing to AI Agent Templates

## Adding a New Domain

1. Create the domain folder structure:
   ```
   [domain]/
   ├── AGENTS.md
   ├── README.md
   ├── persona.md
   ├── skills/
   └── design/
   ```
2. Copy the structure from an existing domain as a starting point
3. Update `template.json` with the new domain entry
4. Update the root `README.md` inventory table
5. Replace all `[placeholder]` values before committing

## Adding a New Skill

1. Create `[domain]/skills/[skill-name].md`
2. Use the standard format:
   - Skill ID, Domain, Trigger, Load from path
   - Prerequisites checklist
   - Numbered steps with sub-steps
   - Output format (code block)
   - Escalation rules
3. Add the skill to the domain's `AGENTS.md` skills table
4. Add the skill path to `template.json`

## Adding a New Persona

1. Create or edit `[domain]/persona.md` (one persona per domain)
2. Include: Persona ID, Domain, Load when, Mindset, Investigation Methodology,
   Approach, Safety Rules, Output Format, Skills to Load table, References
3. Update the domain's `AGENTS.md` persona table
4. Update `template.json` with the persona path

## Adding a Design Template

1. Create `[domain]/design/[category]/[TEMPLATE_NAME].md`
2. Design categories by domain:
   - coding: `architecture/`, `apis/`, `patterns/`
   - devops: `services/`, `features/`, `workflows/`
   - security: `threat_models/`, `policies/`, `controls/`
3. Use `[placeholder]` format for all team-specific values

## Placeholder Convention

All values requiring team-specific customization use `[placeholder]` format.
Run `grep -r "\[" --include="*.md" .` to find all unfilled placeholders.

## Commit Convention

- `feat: add [skill/persona/domain] for [domain]`
- `fix: correct [file] [description]`
- `docs: update [file] [description]`
