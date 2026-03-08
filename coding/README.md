# [ServiceName]

> **For AI agents:** Read `AGENTS.md` for repo-specific workflows, build conventions, and safety rules. Do not use this file as your primary instruction source.

## Overview

[ServiceName] is a [brief description of what the service does and its role in the broader system].

- **Team:** [Team name]
- **Primary language:** [Language]
- **Status:** [Active / In Development / Deprecated]
- **Security contact:** [alias or team name]

## Architecture

[Brief description of the service architecture. Include a diagram link if available.]

- **Key components:** [List top-level packages or modules, e.g., `core/`, `api/`, `lib/`]
- **Data flow:** [One-paragraph description of how data flows through the service]
- **Dependencies:** [List key upstream/downstream service dependencies]
- **Design doc index:** [Link to design doc index]

## Getting Started

### Prerequisites

- [Prerequisite 1, e.g., Java 17+, Python 3.11+]
- [Prerequisite 2, e.g., Maven, Gradle, npm]
- [Prerequisite 3, e.g., AWS credentials configured]

### Setup

```bash
git clone [repo URL]
cd [repo name]
[install command]
[build command]
```

### Running Tests

```bash
[unit test command]
[integration test command]
[coverage command]
```

## Project Structure

```
[repo-name]/
├── [package-1]/
├── [package-2]/
├── skills/
│   ├── raise_cr.md
│   ├── run_tests.md
│   └── generate_changelog.md
├── persona.md
├── AGENTS.md
└── README.md
```

## Development Workflow

1. Create a feature branch: `[your-alias]/[ticket-id]-[short-description]`
2. Make your changes
3. Run unit tests: `[test command]`
4. Raise a Code Review targeting `mainline`
5. Add reviewers: [default reviewer group]
6. Link to the relevant ticket and design doc

> **Full CR workflow:** See `skills/raise_cr.md`

## API Documentation

- **API reference:** [Link]
- **Contract tests:** [Link or location in repo]

## Runbooks & Operational Docs

- **On-call runbook:** [Link]
- **Deployment guide:** [Link]
- **Troubleshooting guide:** [Link]

## Contact

- **Team:** [Team name] — [team alias or Slack/Chime channel]
- **On-call:** [On-call rotation link]
- **Security issues:** Report to [security contact] — do not open a public ticket
