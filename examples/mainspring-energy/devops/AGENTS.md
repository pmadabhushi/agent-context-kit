# AGENTS.md — Fleet Operations (Mainspring Energy)

> This file is read automatically by AI agents at session start for fleet operations tasks.

## Fleet Overview

- **Product:** Mainspring Linear Generator (LGen), 250kW per unit
- **Fleet size:** 450+ MW across multiple customer sites
- **Industries served:** Data centers, utilities, enterprise, industrial
- **Fuels supported:** Natural gas, biogas/RNG, hydrogen, propane, field gas
- **Telemetry platform:** FleetOS (internal fleet management platform)
- **Monitoring:** Grafana + InfluxDB for time-series, PagerDuty for alerting
- **Edge:** Custom edge gateways at each site, MQTT to cloud

## Key Metrics (Per Unit)

| Metric | Normal Range | Warning | Critical |
|--------|-------------|---------|----------|
| Power output | 0–250 kW (as dispatched) | Deviation > 10% from setpoint | Output = 0 when dispatched > 0 |
| Electrical efficiency | 44–46% LHV | < 42% | < 38% |
| NOx emissions | < 1.5 ppm | > 1.5 ppm | > 3.0 ppm |
| Vibration | < 2.0 mm/s RMS | > 3.0 mm/s | > 5.0 mm/s |
| Fuel pressure | 5–20 psig | < 5 psig or > 22 psig | < 3 psig or > 25 psig |
| Coolant temp | 60–85°C | > 90°C | > 100°C |
| Availability | > 95% | < 95% | < 90% |

## Operational Conventions

- All fleet commands go through FleetOS CLI: `fleetctl`
- Never send firmware updates to units currently generating power without customer approval
- Always validate on a staging unit before fleet-wide rollout
- Dispatch changes require customer or grid operator confirmation
- All field operations must be logged to the fleet audit trail

## Dispatch Modes

| Mode | Description | When Used |
|------|-------------|-----------|
| Prime power | Continuous baseload generation | Default for off-grid or behind-the-meter sites |
| Solar firming | Ramp up/down to complement solar output | Sites with co-located solar |
| Peak shaving | Generate during peak demand periods | Utility demand response programs |
| Grid services | Respond to grid operator dispatch signals | Utility and ISO programs |
| Standby | Hot standby, ready to generate on signal | Backup power applications |

## Safety Rules

- **Never** remotely shut down a unit providing prime power without customer confirmation
- **Never** push firmware to a generating unit — wait for maintenance window
- **Prefer read-only operations** when diagnosing field issues remotely
- If emissions exceed regulatory limits, initiate automatic shutdown sequence
- If vibration exceeds critical threshold, shut down immediately (mechanical safety)
- All remote commands to field units must be logged with operator ID and timestamp

## Skills Available

| Skill | File | When to Load |
|---|---|---|
| Fleet Health Check | `skills/fleet_health_check.md` | When checking fleet-wide or site-specific unit health |
| Remote Diagnostics | `skills/remote_diagnostics.md` | When investigating a unit fault or performance degradation |
| Firmware Update | `skills/firmware_update.md` | When rolling out firmware to field units |
| Dispatch Management | `skills/dispatch_management.md` | When changing unit dispatch mode or power setpoint |

## Personas Available

| Persona | File | When to Load |
|---|---|---|
| Fleet Ops Engineer | `personas/fleet_ops_engineer.md` | Default persona for all fleet operations tasks |

## References

- FleetOS dashboard: https://fleetos.internal.mainspring.io
- Grafana fleet metrics: https://grafana.internal.mainspring.io/d/fleet-overview
- PagerDuty schedule: https://mainspring.pagerduty.com/schedules/fleet-ops
- Unit spec sheet: https://wiki.internal.mainspring.io/lgen-specs
- Field service manual: https://wiki.internal.mainspring.io/field-service
