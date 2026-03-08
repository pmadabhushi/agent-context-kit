# SKILL: Incident Response

**Skill ID:** incident_response
**Domain:** Security
**Trigger:** A security incident is declared, a breach is suspected, anomalous access is detected, or a critical vulnerability is being actively exploited
**Load from:** `skills/incident_response.md`

## Prerequisites

- [ ] You have the incident report, alert, or finding that triggered the response
- [ ] You know the affected service(s) and data classification
- [ ] The security contact has been notified (or you are about to notify them)
- [ ] You have access to logs, access records, and the asset inventory

## Steps

### Step 1 — Declare the Incident
- Assign an incident ID: `INC-[YYYY-MM-DD]-[sequence]`
- Identify the incident type: unauthorized access / data exfiltration / credential exposure / active exploitation / malware / insider threat
- Notify the security contact immediately
- Open an incident ticket in `[ticketing system]` — do not delay this step

### Step 2 — Contain the Threat (Read-Only Assessment First)
Before taking any containment action, assess the blast radius:
- Which systems are affected? What data classifications are involved?
- Is the threat still active or historical?
- What is the potential for lateral movement?

Containment actions (require explicit user confirmation before executing):
- Revoke compromised credentials: `[credential revocation command]`
- Isolate affected instance/container: `[isolation command]`
- Disable compromised IAM role or access key: `[IAM command]`

**Document every containment action with timestamp and rationale.**

### Step 3 — Preserve Evidence
Before making any changes to affected systems:
- Capture logs for the affected time window: `[log export command]`
- Snapshot affected instances if applicable: `[snapshot command]`
- Store evidence in: `[evidence storage location]`

**Never modify or delete logs — preserve them in their original state.**

### Step 4 — Assess Impact
- Determine what data was accessed, modified, or exfiltrated
- Assess compliance impact: which frameworks are triggered?
- Determine notification obligations: internal only / regulatory / customer notification required

### Step 5 — Eradicate the Threat
- Remove malicious access, backdoors, or compromised credentials
- Patch or mitigate the exploited vulnerability (load `vuln_triage` skill if needed)
- Rotate all potentially compromised secrets (load `secrets_rotation` skill)

### Step 6 — Recover
- Restore affected services from clean backups or known-good state
- Re-enable access for legitimate users after credential rotation
- Monitor for recurrence for [X] hours post-recovery

### Step 7 — Post-Incident Review
Within [X] days of incident closure:
- Document the full incident timeline and root cause
- Create follow-up tickets for systemic fixes
- Update threat model and AGENTS.md if new attack vectors were identified

## Output Format

```
Security Incident Report
------------------------
Incident ID:          [INC-YYYY-MM-DD-XXX]
Incident Type:        [type]
Declared At:          [timestamp]
Affected Service:     [ServiceName]
Data Classification:  [Confidential/Internal/Public]
Compliance Impact:    [frameworks triggered or "None identified"]
Blast Radius:         [description]
Threat Status:        [Active / Contained / Eradicated]
Evidence Preserved:   Yes / No — stored at [location]
Notification Required: [Internal / Regulatory / Customer / None]
Root Cause:           [description]
Eradication Steps:    [list]
Recovery Steps:       [list]
Follow-Up Tickets:    [links]
Audit Trail:          Logged to [system]
```

## Escalation

Escalate to security leadership immediately if:
- Customer data was confirmed to be accessed or exfiltrated
- Regulatory notification obligations are triggered (GDPR, HIPAA, PCI, etc.)
- The threat is still active and cannot be contained
- An insider threat is suspected
