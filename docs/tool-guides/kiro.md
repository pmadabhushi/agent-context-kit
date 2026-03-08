# Using Agent Context Kit with Kiro

Kiro reads `AGENTS.md` automatically from your workspace root. This guide shows
how to get the most out of it.

## Basic Setup

1. Copy a template folder (e.g., `templates/coding/`) into your project root
2. Fill in the `[placeholder]` values in `AGENTS.md`
3. Open the project in Kiro — it reads `AGENTS.md` on startup

That's it. Kiro will use your team config, safety rules, and conventions
automatically in every conversation.

## Using Steering Files for Personas

Kiro supports steering files that provide additional context. You can use them
to load your persona:

1. Create `.kiro/steering/persona.md` in your project
2. Copy the contents of your `persona.md` into it
3. Kiro will include this context in every interaction

For conditional loading (only when certain files are open):

```yaml
---
inclusion: fileMatch
fileMatchPattern: "*.py"
---
# Your Python-specific persona content here
```

## Using Skills

Reference skills directly in chat:

```
@skills/deploy_service.md deploy the service to staging
```

Or tell Kiro about them in your steering file so it knows they exist.

## Using Design Docs

Reference design docs when asking architecture questions:

```
#File:design/services/SERVICE_TEMPLATE.md What are the failure modes?
```

## Tips

- Keep `AGENTS.md` at the project root — Kiro finds it automatically
- Use steering files for context you want in every conversation
- Reference specific files with `#File:` when you need targeted context
- Kiro's specs feature pairs well with design doc templates for planning new features
