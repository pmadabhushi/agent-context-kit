# Using Agent Context Kit with Amazon Q Developer

Amazon Q Developer reads your workspace context and can reference files directly.
Here's how to use your agent configuration with it.

## Basic Setup

1. Copy a template folder (e.g., `templates/devops/`) into your project root
2. Fill in the `[placeholder]` values in `AGENTS.md`
3. Open the project in your IDE with Amazon Q Developer installed

Amazon Q reads your workspace files as context. Having `AGENTS.md` at the root
means it's available for reference in every conversation.

## Referencing Files in Chat

Point Amazon Q at your config files:

```
Look at AGENTS.md for our project conventions. Help me deploy the service.
```

For skills:
```
Read skills/incident_triage.md and help me investigate the elevated error rate.
```

For design context:
```
Based on design/services/SERVICE_TEMPLATE.md, what are the failure modes?
```

## Using with Amazon Q Developer Agent

When using Amazon Q's `/dev` agent for code generation:

```
/dev Read AGENTS.md for conventions. Add a health check endpoint following
our API patterns in design/apis/.
```

The agent will read your files and follow the conventions defined in them.

## Tips

- Keep `AGENTS.md` at the project root for easy discovery
- Reference specific files when you need targeted context
- Amazon Q's workspace indexing means your design docs are searchable
- Use `/dev` for code generation tasks that should follow your conventions
