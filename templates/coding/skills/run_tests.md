# SKILL: Run Tests

**Skill ID:** run_tests
**Domain:** Coding
**Trigger:** User asks to run tests, validate a change, check test coverage, or verify a build before raising a CR
**Load from:** `skills/run_tests.md`

## Prerequisites

- [ ] You have the package(s) or scope to test
- [ ] You know the test type: unit tests / integration tests / contract tests / all
- [ ] You have the build environment set up

## Steps

### Step 1 — Identify Test Scope
- Determine which packages have changed: `[command to list changed files]`
- Group changed files by package
- Identify the test type(s) required: unit / integration / contract

### Step 2 — Build the Package (if required)
- Check if the package needs to be built before tests can run
- If yes, build in dependency order: `[build command]`
- If build fails: stop, report the error, and wait for instructions
- **Skip this step if the user explicitly says "do not build"**

### Step 3 — Run Unit Tests
- Run unit tests for each changed package: `[unit test command]`
- Capture test output: pass count, fail count, skipped count
- If any tests fail: stop, report all failures with test names and error messages

### Step 4 — Run Integration Tests (if applicable)
- Run integration tests if changes touch service boundaries: `[integration test command]`
- If integration tests fail: stop and report failures

### Step 5 — Run Contract Tests (if applicable)
- Run contract tests if public APIs were modified: `[contract test command]`
- Contract test failures indicate a breaking change — flag immediately

### Step 6 — Check Test Coverage
- Generate coverage report: `[coverage command]`
- Check coverage against the team's minimum threshold: [X]%
- If coverage is below threshold: report the gap and recommend adding tests

## Output Format

```
Test Results Summary
--------------------
Package(s) Tested:    [list]
Test Types Run:       [Unit / Integration / Contract]
Unit Tests:           Passed: [X] | Failed: [X] | Skipped: [X]
Integration Tests:    Passed: [X] | Failed: [X] | Skipped: [X]
Contract Tests:       Passed: [X] | Failed: [X] (or "Not run")
Coverage:             [X]% (threshold: [Y]%)
Coverage Status:      Meets threshold / Below threshold
Overall Status:       PASS / FAIL
Failures:             [list or "None"]
Flags:                [any breaking changes, coverage gaps, or open questions]
```

## Escalation

Stop and ask the user if:
- Any contract tests fail (indicates a potential breaking change to a public API)
- Test coverage drops significantly below the threshold
- Integration tests require infrastructure that is not available
- Test failures appear to be pre-existing — document and flag rather than blocking
