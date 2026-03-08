# SKILL: Access Review

**Skill ID:** access_review
**Domain:** Security
**Trigger:** User asks to review IAM roles, permissions, or access grants; periodic access review is due; post-incident access audit required; or a team member has changed roles or left the organization
**Load from:** `skills/access_review.md`

## Prerequisites

- [ ] You have the scope of the review: specific service / team / role / all access
- [ ] You have the trigger: periodic review / post-incident / personnel change / compliance audit
- [ ] You have access to the IAM system and access records
- [ ] You have the list of current team members and their roles

## Steps

### Step 1 — Define Review Scope
- Identify what is being reviewed: IAM roles / access grants / permissions for a specific resource / all access for a departing team member
- Set the review period: `[start date]` to `[end date]`

### Step 2 — Enumerate Current Access
- List all IAM roles associated with the service or scope: `[IAM list command]`
- List all users or principals with access: `[access list command]`
- List all permissions granted per role: `[permissions list command]`
- Export access records for the review period: `[access log export command]`

### Step 3 — Apply Least-Privilege Analysis
For each role or access grant, assess:
- **Is this access still needed?** (Has the use case changed or been deprecated?)
- **Is the permission scope appropriate?** (Is it broader than required?)
- **Is this access actively used?** (Check last-used date: `[last-used command]`)
- **Does this access comply with the principle of least privilege?**

Flag any access that is:
- Unused for more than [X] days
- Broader than required (e.g., `*` wildcard permissions on sensitive resources)
- Assigned to a departed or role-changed team member
- Not documented in the access register

### Step 4 — Identify Violations

| Severity | Criteria |
|---|---|
| Critical | Access to sensitive data (PII, credentials, financial) by unauthorized principals |
| High | Overly broad permissions on production systems; access by departed employees |
| Medium | Unused access grants; permissions broader than required |
| Low | Documentation gaps; access not logged in the access register |

### Step 5 — Recommend Remediations
For each finding, recommend one of:
- **Revoke:** Remove access entirely
- **Reduce scope:** Replace broad permissions with narrowly scoped ones
- **Document:** Add missing access to the access register with business justification
- **Monitor:** Add enhanced logging for sensitive access that is legitimately needed

### Step 6 — Execute Approved Remediations
For each remediation approved by the user:
- Revoke access: `[revocation command]`
- Update IAM policy: `[policy update command]`
- Log every change to `[audit log system]` with timestamp and rationale

### Step 7 — Produce Access Review Report

## Output Format

```
Access Review Report
--------------------
Review Scope:         [service / team / individual / all]
Review Trigger:       [Periodic / Post-Incident / Personnel Change / Compliance Audit]
Review Period:        [start date] to [end date]
Completed At:         [timestamp]

Summary:
- Total roles reviewed:      [X]
- Total principals reviewed: [X]
- Findings — Critical:       [X]
- Findings — High:           [X]
- Findings — Medium:         [X]
- Findings — Low:            [X]

Findings:
- ID: [F-001] | Principal: [user/role] | Resource: [resource]
  Issue: [description] | Severity: [level] | Action: [Revoke/Reduce/Document/Monitor] | Status: [Completed/Pending]

Remediations Executed:  [list with timestamps]
Audit Trail:            Logged to [system]
Next Review Due:        [date]
Compliance Notes:       [any framework-specific findings]
```

## Escalation

Stop and escalate to security contact immediately if:
- A departed employee still has active access to production systems or sensitive data
- Unauthorized access to PII, credentials, or financial data is discovered
- Access records show suspicious patterns (bulk data export, off-hours access to sensitive resources)
- A compliance violation is identified that requires regulatory notification
- You are unable to enumerate all access for the review scope
