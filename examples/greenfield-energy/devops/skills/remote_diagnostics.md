# SKILL: Remote Diagnostics

**Skill ID:** remote_diagnostics
**Domain:** DevOps / Fleet Operations
**Trigger:** Unit fault, performance degradation, customer-reported issue, or anomalous telemetry
**Load from:** `skills/remote_diagnostics.md`

## Prerequisites

- [ ] You have the unit ID and site information
- [ ] You have the fault code or symptom description
- [ ] You have access to FleetOS CLI and Grafana

## Steps

### Step 1 — Gather Unit Context
- Unit status: `fleetctl status --unit [UNIT-ID] --verbose`
- Unit history: `fleetctl history --unit [UNIT-ID] --last 7d`
- Firmware version: `fleetctl firmware --unit [UNIT-ID]`
- Dispatch mode and setpoint: note current operating mode

### Step 2 — Analyze Telemetry Trends
- Open Grafana: `https://grafana.internal.greenfield.io/d/unit-detail?unit=[UNIT-ID]`
- Check 24h trends for: power output, efficiency, emissions, vibration, temperatures
- Look for: sudden changes, gradual degradation, correlation with time of day or ambient temp

### Step 3 — Decode Fault Code (if applicable)
Common fault codes:
| Code | Description | Likely Cause | Remote Fix? |
|------|-------------|-------------|-------------|
| F001 | Low fuel pressure | Fuel supply issue | No — check site fuel system |
| F002 | High vibration | Mechanical wear or misalignment | No — dispatch field service |
| F003 | Emissions limit exceeded | Combustion anomaly | Try: `fleetctl recalibrate --unit [UNIT-ID]` |
| F004 | Coolant over-temp | Cooling system issue | Check: ambient temp, coolant level |
| F005 | Communication lost | Network/gateway issue | Check: `fleetctl gateway-status --site [SITE-ID]` |
| F006 | Output deviation | Control system drift | Try: `fleetctl reset-controller --unit [UNIT-ID]` |

### Step 4 — Attempt Remote Resolution (if applicable)
- Only attempt remote fixes for fault codes marked "Remote Fix? Yes/Try"
- Log every command sent: `fleetctl` automatically logs to audit trail
- After any remote fix, monitor for 30 minutes to confirm resolution

### Step 5 — Document Findings

```
Remote Diagnostics Report
-------------------------
Unit:            [UNIT-ID] at [Site Name] ([Customer])
Fault Code:      [code] — [description]
Reported By:     [alert / customer / routine check]
Date:            [date]

Telemetry at Time of Fault:
  Power Output:  [X] kW (setpoint: [Y] kW)
  Efficiency:    [X]% LHV
  NOx:           [X] ppm
  Vibration:     [X] mm/s RMS
  Fuel Pressure: [X] psig
  Coolant Temp:  [X]°C
  Ambient Temp:  [X]°C

Root Cause:      [diagnosis]
Evidence:        [telemetry trends, fault code, correlation]
Remote Fix:      [attempted / successful / not applicable]
Field Service:   [dispatched / not needed]
Customer Impact: [Yes/No — description]
```

## Escalation

Dispatch field service immediately if:
- Vibration > 5.0 mm/s (potential mechanical failure)
- Fuel leak suspected
- Electrical fault codes (high voltage, ground fault)
- Remote fix attempted twice without resolution
- Customer reports unusual noise, smell, or visible issue
