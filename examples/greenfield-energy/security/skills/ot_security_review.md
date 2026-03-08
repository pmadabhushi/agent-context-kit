# SKILL: OT Security Review

**Skill ID:** ot_security_review
**Domain:** Security
**Trigger:** Review of edge gateway security, MQTT communication, dispatch command authorization, or firmware update pipeline
**Load from:** `skills/ot_security_review.md`

## Prerequisites

- [ ] You have the scope: specific site, fleet-wide, or specific component (edge, MQTT, dispatch, firmware)
- [ ] You have access to the OT architecture doc
- [ ] You have approval to review OT systems (do NOT scan production OT without approval)

## Steps

### Step 1 — Map the OT Boundary
- Identify all components in scope:
  - Edge gateways (per-site Linux appliances)
  - MQTT broker (cloud-side, TLS-encrypted)
  - Dispatch service (sends commands to edge gateways)
  - Firmware update pipeline (pushes firmware to edge gateways)
  - Field units (linear generators — not directly network-accessible)

### Step 2 — Review Network Segmentation
- Verify edge gateways are in a separate VPC/subnet from the main platform
- Verify no direct cloud-to-unit communication (all commands go through edge gateway)
- Verify MQTT uses mutual TLS (mTLS) for edge-to-cloud communication
- Verify VPN or private connectivity for edge gateway management

### Step 3 — Review Authentication & Authorization
- Edge gateway authentication: certificate-based, per-device certificates
- Dispatch command authorization: verify commands are signed and validated at the edge
- Firmware update authorization: verify firmware images are signed and verified before installation
- Review who has access to dispatch and firmware pipelines (should be restricted to fleet ops + security)

### Step 4 — Review Firmware Update Pipeline
- Verify firmware images are cryptographically signed
- Verify edge gateways validate signatures before applying updates
- Verify rollback capability exists if firmware update fails
- Verify firmware updates cannot be pushed to generating units (safety interlock)

### Step 5 — Check for Common OT Risks
- [ ] Default credentials on edge gateways
- [ ] Unencrypted protocols (Modbus TCP without TLS wrapper)
- [ ] Overly permissive firewall rules on OT network
- [ ] Stale certificates (check expiry dates)
- [ ] Lack of logging on edge gateway commands
- [ ] No rate limiting on dispatch commands

### Step 6 — Document Findings

```
OT Security Review Report
-------------------------
Scope:              [Site / Fleet / Component]
Date:               [date]
Reviewer:           [name]

Network Segmentation:  [Pass / Fail — details]
Edge Authentication:   [Pass / Fail — details]
Dispatch Authorization:[Pass / Fail — details]
Firmware Signing:      [Pass / Fail — details]
Certificate Status:    [Valid / Expiring / Expired — details]

Findings:
  [#1] [Severity] — [description]
  [#2] [Severity] — [description]

Compliance Impact:     [SOC2 / NERC CIP / None]
Recommendations:       [list]
Next Review Due:       [date]
```

## Escalation

Escalate immediately if:
- Unsigned firmware can be pushed to edge gateways
- Dispatch commands can be sent without authentication
- Edge gateway has internet-facing management interface
- Evidence of unauthorized access to OT network
