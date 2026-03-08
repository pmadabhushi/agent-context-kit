# SKILL: Raise Code Review

**Skill ID:** raise_cr
**Domain:** Coding
**Trigger:** User asks to raise a CR, submit a code review, or create a pull request
**Load from:** `skills/raise_cr.md`

## Prerequisites

- [ ] You have a list of changed files or packages
- [ ] You know the target branch (default: `mainline`)
- [ ] You have the associated ticket ID or design doc link

## Steps

### Step 1 — Identify Changed Packages
- Run `[command to list changed files]` (e.g., `git diff --name-only HEAD`)
- Group changed files by package
- Note any changes to shared interfaces or public APIs — **flag these before proceeding**

### Step 2 — Build Changed Packages (if instructed)
- Build each changed package in dependency order: `[package-1]` → `[package-2]`
- Command: `[build command]`
- If build fails: stop, report the error, and wait for instructions
- **Skip this step if the user explicitly says "do not build"**

### Step 3 — Run Unit Tests
- Run tests for each changed package: `[test command]`
- If tests fail: stop, report failures, and wait for instructions
- Do not proceed to CR creation if tests are failing

### Step 4 — Create the Code Review
- Use `[CR tool/command]` to create the CR
- Set title: `[Ticket ID] — [Short description of change]`
- Set description: include summary of changes, testing done, and link to design doc
- Set reviewers: [default reviewer list or group]
- Set target branch: `mainline` (and `[secondary-branch]` if required)

### Step 5 — Link Supporting Context
- Add link to the associated ticket: `[ticket URL]`
- Add link to the relevant design doc section: `[design doc URL]`
- If this is a two-CR change, note the companion CR in the description

### Step 6 — Notify the Team
- Post a summary to `[team Slack/Chime channel]`:
  > CR raised: [CR link] | Ticket: [ticket link] | Summary: [one-line description]

## Output Format

```
CR Raised Successfully
----------------------
CR Link:        [link]
Target Branch:  [branch]
Reviewers:      [list]
Ticket:         [link]
Design Doc:     [link]
Tests Passed:   Yes / No
Notes:          [any flags or issues]
```

## Escalation

Stop and ask the user if:
- Any shared interface or public API was modified
- Build or tests fail and cannot be resolved automatically
- The correct reviewer group is unclear
- The target branch is ambiguous
