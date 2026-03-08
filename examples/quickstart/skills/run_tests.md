# SKILL: Run Tests

**Skill ID:** run_tests
**Trigger:** User asks to run tests, validate changes, or check for regressions

## Steps

1. Run the full test suite: `pytest tests/ -v`
2. If tests fail, read the error output and identify the failing test
3. Check if the failure is related to recent changes
4. Suggest a fix or ask the user for guidance

## Output Format

```
Test Results
------------
Total:    [N] tests
Passed:   [N]
Failed:   [N]
Errors:   [N]

Failures:
  [test name] — [brief reason]

Recommendation: [fix suggestion or "all tests passing"]
```
