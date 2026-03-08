# SKILL: Generate Changelog

**Skill ID:** generate_changelog
**Domain:** Coding
**Trigger:** User asks to generate a changelog, prepare release notes, or summarize changes between two versions
**Load from:** `skills/generate_changelog.md`

## Prerequisites

- [ ] You have the version range or date range (e.g., `v1.2.0` → `v1.3.0`)
- [ ] You have access to the commit history or merged CR list
- [ ] You know the target audience: internal team / external customers

## Steps

### Step 1 — Define the Changelog Scope
- Confirm the version range: from `[version/tag/date]` to `[version/tag/date]`
- Confirm the target audience: internal (all changes) or external (user-visible only)

### Step 2 — Retrieve Commit History
- List all commits in the version range:
  `git log [v1.2.0]..[v1.3.0] --oneline --no-merges`
- Group commits/CRs by package or component

### Step 3 — Categorize Changes

| Category | Description |
|---|---|
| New Features | New user-visible functionality |
| Bug Fixes | Fixes to existing functionality |
| Performance | Speed, throughput, or resource improvements |
| Breaking Changes | Changes requiring action from consumers |
| Security | Security patches or hardening |
| Internal / Refactor | Internal changes with no user-visible impact |
| Infrastructure | Deployment, pipeline, or infrastructure changes |

**Flag all Breaking Changes prominently.**

### Step 4 — Draft the Changelog
- Write concise, human-readable entries for each change
- For external changelogs: use plain language; avoid internal jargon and ticket IDs
- For internal changelogs: include ticket IDs, CR links, and technical details
- List Breaking Changes first

### Step 5 — Format and Deliver
- Format using the output format below
- Post to `[team channel or release notes location]` if requested

## Output Format

```markdown
# Changelog — [ServiceName]

## [Version X.Y.Z] — [YYYY-MM-DD]

> **Breaking Changes** (action required before upgrading)
- [Description] — [ticket/CR link]

### New Features
- [Feature description] — [ticket/CR link]

### Bug Fixes
- [Fix description] — [ticket/CR link]

### Performance
- [Improvement description] — [ticket/CR link]

### Security
- [Security fix] — [CVE ID if applicable] — [ticket/CR link]

### Internal / Refactor
- [Internal change] — [ticket/CR link]

### Infrastructure
- [Infrastructure change] — [ticket/CR link]

---
Full diff: [link]
Release ticket: [link]
```

## Escalation

Stop and ask the user if:
- Breaking changes are identified that were not previously flagged
- The commit history contains changes with no associated ticket or CR
- The target audience is unclear (internal vs. external)
- The version range spans a very large number of changes
