# Using Agent Context Kit with Cursor

Cursor uses `.cursorrules` and file references to load context. Here's how to
wire up your agent configuration.

## Basic Setup

1. Copy a template folder (e.g., `templates/devops/`) into your project root
2. Fill in the `[placeholder]` values in `AGENTS.md`
3. Create a `.cursorrules` file that references your agent config

## Option 1: .cursorrules (Always Loaded)

Create `.cursorrules` in your project root:

```
Read AGENTS.md for project conventions, build commands, and safety rules.
Read persona.md for your role, mindset, and output format.

When performing operational tasks, check the skills/ directory for step-by-step
procedures before proceeding.

When answering architecture questions, reference the design/ directory for
system documentation.
```

This gives Cursor a pointer to your files. It will read them as needed.

## Option 2: Reference Files in Chat

Use Cursor's `@` syntax to pull in specific files:

```
@AGENTS.md @persona.md Deploy the service to staging
```

For skills:
```
@skills/deploy_service.md Walk me through deploying to prod
```

## Option 3: Add to Project Context

In Cursor Settings → Features → Docs, you can add your `AGENTS.md` as a
documentation source that's always available.

## Tips

- `.cursorrules` is the closest equivalent to automatic `AGENTS.md` loading
- Use `@file` references for skills and design docs when you need them
- Keep your `.cursorrules` short — point to files rather than duplicating content
- Cursor's Composer mode works well with the full template structure
