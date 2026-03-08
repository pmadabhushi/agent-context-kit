# SKILL: Vulnerability Triage

**Skill ID:** vuln_triage
**Domain:** Security
**Trigger:** User asks to triage a vulnerability, CVE, or security finding
**Load from:** `skills/vuln_triage.md`

## Prerequisites

- [ ] You have the finding ID, CVE ID, or scanner report
- [ ] You know the affected service or package
- [ ] You have access to the asset inventory or service criticality register

## Steps

### Step 1 — Fetch the Finding
- Retrieve full finding details from `[scanner/finding source]`
- Extract: CVE ID, CVSS score, affected component, affected version, fix version (if available)

### Step 2 — Assess CVSS Score & Severity

| CVSS Score | Severity | SLA |
|---|---|---|
| 9.0 – 10.0 | Critical | 24 hours |
| 7.0 – 8.9 | High | 7 days |
| 4.0 – 6.9 | Medium | 30 days |
| 0.1 – 3.9 | Low | 90 days |

- If CVSS >= 7.0: **immediately notify security contact** before continuing

### Step 3 — Check Asset Criticality
- Look up the affected service in the asset inventory: `[asset inventory link or command]`
- Determine asset criticality: Critical / High / Medium / Low
- Adjust effective severity if asset criticality is Critical (escalate one level)

### Step 4 — Assess Exploitability
- Check if a public exploit exists: `[exploit database reference, e.g., NVD, ExploitDB]`
- Check if the vulnerable code path is reachable in this service's deployment
- Document exploitability: Exploitable / Not Exploitable / Unknown

### Step 5 — Assign Final Severity & SLA
- Combine CVSS score, asset criticality, and exploitability to assign final severity

### Step 6 — Create Ticket
- Title: `[CVE-XXXX-XXXX] — [Affected Component] — [Severity]`
- Include: finding details, CVSS score, asset criticality, exploitability, recommended fix
- Assignee: service owner | Due date: SLA deadline | Labels: `security`, `[severity]`

### Step 7 — Notify Service Owner
- Send notification via `[notification channel]`:
  > Security finding assigned: [CVE ID] | Severity: [X] | SLA: [date] | Ticket: [link]

### Step 8 — Post Audit Trail
- Log to `[audit log system]`: Finding ID, CVSS score, final severity, asset criticality, exploitability, ticket link, timestamp, analyst

## Output Format

```
Vulnerability Triage Summary
-----------------------------
CVE / Finding ID:     [ID]
Affected Component:   [component@version]
CVSS Score:           [X.X] ([Severity])
Asset Criticality:    [Critical/High/Medium/Low]
Exploitability:       [Exploitable/Not Exploitable/Unknown]
Final Severity:       [Critical/High/Medium/Low]
SLA Deadline:         [YYYY-MM-DD]
Recommended Fix:      [description]
Ticket:               [link]
Owner Notified:       Yes / No
Audit Trail:          Logged to [system]
```

## Escalation

Stop and escalate to security contact immediately if:
- CVSS score >= 9.0 (Critical)
- A public exploit is confirmed and the service is internet-facing
- The finding involves exposed credentials or PII
- The affected asset is classified as Critical and CVSS >= 7.0
