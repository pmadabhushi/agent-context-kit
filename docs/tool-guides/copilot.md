# Using Agent Context Kit with GitHub Copilot

GitHub Copilot Chat supports file references and custom instructions. Here's
how to use your agent configuration with it.

## Basic Setup

1. Copy a template folder (e.g., `templates/security/`) into your project root
2. Fill in the `[placeholder]` values in `AGENTS.md`
3. Reference files in Copilot Chat using `#file:`

## Referencing Files in Chat

Pull in your agent config at the start of a conversation:

```
#file:AGENTS.md #file:persona.md

Help me investigate the elevated error rate on the order service.
```

For specific skills:
```
#file:skills/incident_triage.md We're seeing 5xx errors on the API.
```

For design context:
```
#file:design/services/SERVICE_TEMPLATE.md What are the dependencies?
```

## Using Custom Instructions

GitHub Copilot supports custom instructions via `.github/copilot-instructions.md`:

```markdown
# Copilot Instructions

Always read AGENTS.md for project conventions before answering questions.
Follow the persona defined in persona.md for tone and methodology.
When performing tasks that match a skill in skills/, follow those steps exactly.
Reference design docs in design/ when answering architecture questions.
```

## Using Copilot Chat Participants

In VS Code, you can use workspace-aware participants:

```
@workspace #file:AGENTS.md What's the deployment process?
```

The `@workspace` participant gives Copilot broader project context alongside
your specific file references.

## Tips

- `#file:` is your main tool — use it to pull in exactly the context you need
- Custom instructions (`.github/copilot-instructions.md`) load automatically
- Start conversations with `#file:AGENTS.md` for consistent context
- Copilot works best when you reference specific files rather than entire directories
