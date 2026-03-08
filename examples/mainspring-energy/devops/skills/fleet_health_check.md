# SKILL: Fleet Health Check

**Skill ID:** fleet_health_check
**Domain:** DevOps / Fleet Operations
**Trigger:** User asks for fleet status, site health, unit health, or pre-maintenance readiness check
**Load from:** `skills/fleet_health_check.md`

## Prerequisites

- [ ] You have access to FleetOS CLI (`fleetctl`)
- [ ] You know the scope: fleet-wide, specific site, or specific unit

## Steps

### Step 1 — Determine Scope
- Fleet-wide: `fleetctl fleet-status`
- Specific site: `fleetctl site-status --site [SITE-ID]`
- Specific unit: `fleetctl status --unit [UNIT-ID]`

### Step 2 — Check Key Metrics
For each unit in scope, check:
- Power output vs. dispatch setpoint (deviation > 10% = warning)
- Electrical efficiency (< 42% = warning, < 38% = critical)
- NOx emissions (> 1.5 ppm = warning, > 3.0 ppm = critical/shutdown)
- Vibration (> 3.0 mm/s = warning, > 5.0 mm/s = critical/shutdown)
- Fuel pressure (< 5 psig = warning, < 3 psig = critical)
- Coolant temperature (> 90°C = warning, > 100°C = critical)

### Step 3 — Check Alert History
- `fleetctl alerts --scope [fleet|site|unit] --last 24h`
- Note any recurring alerts or patterns across multiple units

### Step 4 — Check Availability
- `fleetctl availability --scope [fleet|site] --period 30d`
- Fleet target: > 95% availability
- Flag any units below 90%

### Step 5 — Summarize Findings

```
Fleet Health Report
-------------------
Scope:           [Fleet / Site: X / Unit: X]
Date:            [date]
Units in Scope:  [N]

Status Summary:
  Generating:    [N] units
  Standby:       [N] units
  Fault:         [N] units
  Maintenance:   [N] units
  Offline:       [N] units

Alerts (last 24h):
  Critical:      [N]
  Warning:       [N]

Units Requiring Attention:
  [UNIT-ID] — [issue summary]
  [UNIT-ID] — [issue summary]

Fleet Availability (30d): [X]%
Recommendation:  [next step or "fleet healthy — no action needed"]
```

## Escalation

Escalate to field service if:
- Any unit has a mechanical fault (vibration critical, unusual noise reported)
- Any unit has emissions above regulatory limits
- Any unit has been in fault state for > 4 hours without remote resolution
