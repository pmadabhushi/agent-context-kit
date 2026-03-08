# AGENTS.md — Platform Development (Greenfield Energy)

> This file is read automatically by AI coding agents at session start.

## Platform Overview

- **Platform:** FleetOS — Greenfield's fleet management and telemetry platform
- **Primary languages:** Python (backend, data pipeline), TypeScript (frontend, customer portal)
- **Backend framework:** FastAPI
- **Frontend framework:** React + Next.js
- **Database:** TimescaleDB (telemetry time-series), PostgreSQL (fleet registry, customers)
- **Message broker:** MQTT (edge-to-cloud), Kafka (internal event streaming)
- **Infrastructure:** Kubernetes on AWS EKS
- **CI/CD:** GitHub Actions → staging → prod

## Repo Structure

```
fleetos/
├── services/
│   ├── telemetry-ingest/      # MQTT → Kafka → TimescaleDB pipeline
│   ├── fleet-api/             # REST API for fleet management
│   ├── alert-engine/          # Anomaly detection and threshold alerts
│   ├── dispatch-service/      # Dispatch command routing to edge gateways
│   └── customer-portal/       # Next.js customer-facing dashboard
├── libs/
│   ├── lgen-models/           # Shared data models (unit, site, telemetry)
│   └── fleet-client/          # Internal SDK for service-to-service calls
├── edge/
│   └── gateway-firmware/      # Edge gateway software (Rust)
├── infra/
│   └── terraform/             # AWS infrastructure as code
└── tests/
    ├── unit/
    ├── integration/
    └── e2e/
```

## Build Conventions

- Backend: `make build-backend` (runs linting, type checks, builds all Python services)
- Frontend: `cd services/customer-portal && npm run build`
- Run unit tests before any PR: `make test-unit`
- Run integration tests before merging to main: `make test-integration`

## Branch Strategy

- Main branch: `main`
- Feature branches: `[name]/[ticket-id]-[description]`
- All PRs require 1 approval + passing CI
- Never commit directly to `main`

## Design Patterns & Conventions

- All telemetry data uses UTC timestamps in ISO 8601 format
- Unit IDs follow format: `LG-[SITE]-[SEQ]` (e.g., `LG-DC01-003`)
- All API endpoints are versioned: `/api/v1/...`
- Use the shared `lgen-models` library for all data types — never redefine unit/telemetry schemas
- Error handling: use structured error responses with error codes, never raw exceptions

## Safety Rules

- Never commit credentials, API keys, or customer data to the repo
- Never modify the `lgen-models` shared library without team review
- Never deploy telemetry pipeline changes without validating against replay data
- Customer PII must never appear in logs — use customer ID only

## Skills Available

| Skill | File | When to Load |
|---|---|---|
| Run Tests | `skills/run_tests.md` | When running tests or validating changes |
| Raise PR | `skills/raise_pr.md` | When creating a pull request |
| Telemetry Pipeline | `skills/telemetry_pipeline.md` | When working on the ingest pipeline |

## Persona

| Persona | File | When to Load |
|---|---|---|
| Platform Developer | `persona.md` | Default persona for all coding tasks |

## References

- API docs: https://api-docs.internal.greenfield.io
- Architecture overview: https://wiki.internal.greenfield.io/fleetos-architecture
- Telemetry schema: https://wiki.internal.greenfield.io/telemetry-schema
- Design doc index: https://wiki.internal.greenfield.io/design-docs
