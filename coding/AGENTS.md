# AGENTS.md — Coding Agent

> This file is read automatically by AI coding agents at session start. Do not duplicate content from README.md.

## Repo Overview

- **Service:** [ServiceName]
- **Primary language:** [Language]
- **Package structure:** [Describe top-level packages, e.g., `core/`, `api/`, `lib/`, `tests/`]
- **Design doc index:** [Link to design doc index]

## Build Conventions

- Always build packages in this order: `[package-1]` → `[package-2]` → `[package-3]`
- Use `[build tool and command]` to build (e.g., `brazil-build` or `mvn clean install`)
- Run unit tests before raising any CR: `[test command]`
- Do NOT build packages unless explicitly instructed to do so before raising a CR

## Branch Strategy

- Main branch: `mainline`
- Feature branches: `[your-alias]/[ticket-id]-[short-description]`
- Always raise **two CRs per change**: one targeting `mainline`, one targeting `[secondary-branch]`
- Never commit directly to `mainline`

## Code Review Workflow

1. Identify all changed packages
2. Build each changed package (unless instructed otherwise)
3. Run unit tests for changed packages
4. Create CR using `[CR tool/command]`
5. Add reviewers: [list default reviewers or reviewer group]
6. Link to the relevant design doc or ticket
7. Post CR summary to `[team channel]`

> For detailed steps, load skill: `skills/raise_cr/SKILL.md`

## Design Patterns & Conventions

- Follow [pattern name] for all new service integrations
- All public APIs must have corresponding contract tests
- Never modify shared interfaces in `[shared-package]` without flagging for team review
- Error handling: always use `[ErrorHandlingClass/pattern]`; never swallow exceptions silently

## Safety Rules

- Do NOT push credentials, secrets, or API keys to the repo under any circumstances
- Do NOT modify `[critical-config-file]` without explicit approval
- Flag any change to shared interfaces or public APIs before proceeding
- If unsure about a design decision, stop and ask rather than guessing

## Skills Available

| Skill | File | When to Load |
|---|---|---|
| Raise Code Review | `skills/raise_cr/SKILL.md` | When asked to raise a CR or submit a code review |
| Run Tests | `skills/run_tests/SKILL.md` | When asked to run tests or validate a change |
| Generate Changelog | `skills/generate_changelog/SKILL.md` | When preparing a release or summarizing changes |

## Personas Available

| Persona | File | When to Load |
|---|---|---|
| Dev Agent | `personas/dev_agent.md` | Default persona for all coding tasks |

## References

- Design doc index: [Link]
- Architecture overview: [Link]
- Code review guide: [Link]
- Team wiki: [Link]
