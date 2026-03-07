# Contributing to AI Agent Templates

## Adding a New Domain

1. Create a new folder: `mkdir -p [domain]/personas [domain]/skills/[skill-name]`
2. Copy the structure from an existing domain as a starting point
3. Update the root `README.md` inventory table
4. Replace all `[placeholder]` values before committing

## Adding a New Skill

1. Create the skill folder: `mkdir -p [domain]/skills/[skill-name]`
2. Create `SKILL.md` using the standard format:
   - Skill ID, Domain, Trigger, Load from path
   - Prerequisites checklist
   - Numbered steps with sub-steps
   - Output format (code block)
   - Escalation rules
3. Add the skill to the domain's `AGENTS.md` skills table

## Adding a New Persona

1. Create `[domain]/personas/[persona-name].md`
2. Include: Persona ID, Domain, Load when, Mindset, Investigation Methodology,
   Approach, Safety Rules, Output Format, Skills to Load table, References
3. Add the persona to the domain's `AGENTS.md` personas table

## Placeholder Convention

All values requiring team-specific customization use `[placeholder]` format.
Run `grep -r "\[" .` to find all unfilled placeholders in the repository.

## Commit Convention

- `feat: add [skill/persona/domain] for [domain]`
- `fix: correct [file] [description]`
- `docs: update [file] [description]`
