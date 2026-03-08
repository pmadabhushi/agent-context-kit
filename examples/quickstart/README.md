# Quickstart Example: Todo App

This is the simplest possible agent configuration — a small Python API with
just enough context to show how the pieces fit together.

## What's Here

```
quickstart/
├── AGENTS.md          ← Agent reads this first (build commands, API endpoints, safety rules)
├── persona.md         ← How the agent behaves (mindset, output format)
├── skills/
│   ├── run_tests.md   ← Step-by-step: how to run and interpret tests
│   └── deploy.md      ← Step-by-step: how to deploy to production
└── README.md          ← You're reading this
```

That's it. Four files. This is all you need to give an AI agent useful context
about your project.

## How to Use This

1. Copy these files into your own project
2. Open `AGENTS.md` and replace the Todo App details with your project's info
3. Edit `persona.md` to match how you want the agent to behave
4. Update the skills with your actual commands and procedures
5. Point your AI tool at `AGENTS.md` and start chatting

## What Changes vs. the Templates

Compare this with the full templates in `templates/`:

| This example | Full templates |
|---|---|
| 1 persona | 1 persona with detailed methodology |
| 2 skills | 3-7 skills with prerequisites and escalation rules |
| No design docs | Full design doc templates (architecture, APIs, threat models) |
| Simple safety rules | Comprehensive safety rules with escalation paths |

Start here, then add more structure as your project grows.
