# Pattern: [PatternName]

This document describes the [PatternName] pattern, when to use it, implementation guidelines, and examples from the codebase.

> **Related**: For service architecture, see `design/architecture/`. For API contracts that use this pattern, see `design/apis/`.

## Overview

[One-paragraph description of the pattern, what problem it solves, and why it was chosen for this codebase.]

## When to Use

- [Scenario 1: e.g., "When integrating a new external service dependency"]
- [Scenario 2: e.g., "When adding a new API endpoint that requires input validation"]
- [Scenario 3: e.g., "When implementing async processing with retry semantics"]

## When NOT to Use

- [Anti-scenario 1: e.g., "Simple CRUD with no business logic — use direct DAO access"]
- [Anti-scenario 2: e.g., "Internal utilities with no external dependencies"]
- [Anti-scenario 3: e.g., "One-off scripts or migration tools"]

## Architecture

```
┌──────────────────────────────────────────────────────┐
│  [Entry Point / Caller]                               │
│  └── Calls interface, not implementation              │
└──────────────────┬───────────────────────────────────┘
                   │
                   ▼
┌──────────────────────────────────────────────────────┐
│  [Interface / Contract]                               │
│  └── Defines the contract (methods, types, errors)    │
└──────────────────┬───────────────────────────────────┘
                   │
          ┌────────┴────────┐
          ▼                 ▼
┌─────────────────┐ ┌─────────────────┐
│ [Implementation │ │ [Implementation │
│  A — e.g., Prod]│ │  B — e.g., Mock]│
└────────┬────────┘ └─────────────────┘
         │
         ▼
┌──────────────────────────────────────────────────────┐
│  [Dependency / Adapter / External Service]            │
└──────────────────────────────────────────────────────┘
```

## Implementation

### Step 1: Define the Interface

```[language]
// [Interface that defines the contract]
// All implementations must satisfy this contract

public interface [InterfaceName] {

    /**
     * [Method description]
     * @param [param] [description]
     * @return [description]
     * @throws [ExceptionType] [when this happens]
     */
    [ReturnType] [methodName]([ParamType] [param]);
}
```

### Step 2: Implement the Contract

```[language]
// [Production implementation]
// Handles real service calls, retries, error mapping

public class [ImplementationName] implements [InterfaceName] {

    private final [DependencyType] [dependency];
    private final [MetricsType] [metrics];

    public [ImplementationName]([DependencyType] dependency, [MetricsType] metrics) {
        this.[dependency] = dependency;
        this.[metrics] = metrics;
    }

    @Override
    public [ReturnType] [methodName]([ParamType] [param]) {
        // 1. Validate input
        // 2. Call dependency
        // 3. Map response
        // 4. Handle errors
        // 5. Emit metrics
    }
}
```

### Step 3: Wire via Dependency Injection

```[language]
// [DI configuration — Dagger, Spring, Guice, etc.]

@Module
public class [ModuleName] {

    @Provides
    @Singleton
    [InterfaceName] provide[InterfaceName]([DependencyType] dep) {
        return new [ImplementationName](dep);
    }
}
```

### Step 4: Write Tests

```[language]
// [Unit test with mocked dependencies]

@Test
void [testMethodName]_[scenario]_[expectedBehavior]() {
    // Given
    when([mockDependency].[method]([any])).thenReturn([expected]);

    // When
    var result = [subject].[methodName]([input]);

    // Then
    assertThat(result).[assertion]([expected]);
    verify([mockDependency]).[method]([expected]);
}
```

## Error Handling

This pattern requires consistent error handling across all implementations:

### Exception Mapping

| Source Error | Mapped Exception | HTTP Status | Retryable | Customer Message |
|-------------|-----------------|-------------|-----------|-----------------|
| [DependencyTimeout] | [ServiceUnavailableException] | 503 | Yes | [Service temporarily unavailable] |
| [InvalidResponse] | [InternalServiceException] | 500 | Yes | [Internal error] |
| [AuthFailure] | [AccessDeniedException] | 403 | No | [Not authorized] |
| [NotFound] | [ResourceNotFoundException] | 404 | No | [Resource not found] |
| [Throttled] | [ThrottlingException] | 429 | Yes | [Rate exceeded] |

### Retry Strategy

```[language]
// [Retry configuration for this pattern]

RetryConfig retryConfig = RetryConfig.builder()
    .maxAttempts([3])
    .backoff(BackoffStrategy.exponential(
        Duration.ofMillis([100]),   // initial delay
        Duration.ofSeconds([5]),    // max delay
        [2.0]                       // multiplier
    ))
    .retryOn([ServiceUnavailableException.class, ThrottlingException.class])
    .doNotRetryOn([ClientException.class])
    .build();
```

### Circuit Breaker (if applicable)

| Parameter | Value | Description |
|-----------|-------|-------------|
| Failure threshold | [5 failures in 60s] | [Open circuit after N failures] |
| Half-open after | [30s] | [Allow one test request] |
| Success threshold | [3 consecutive] | [Close circuit after N successes] |
| Fallback | [Return cached / Return default / Throw] | [Behavior when circuit is open] |

## Metrics & Observability

Every implementation of this pattern should emit:

| Metric | Type | Dimensions | Purpose |
|--------|------|-----------|---------|
| [operation.latency] | Timer | [operation, status] | [Track P50/P99 latency] |
| [operation.count] | Counter | [operation, status] | [Track success/failure rate] |
| [operation.retry] | Counter | [operation, attempt] | [Track retry frequency] |
| [circuit.state] | Gauge | [dependency] | [Track circuit breaker state] |

### Structured Logging

```json
{
  "level": "INFO",
  "message": "[Operation] completed",
  "operation": "[methodName]",
  "duration_ms": 42,
  "status": "SUCCESS",
  "dependency": "[serviceName]",
  "request_id": "[traceId]"
}
```

## Validation Pattern

Input validation follows a layered approach:

```
[API Layer]          → Schema validation (required fields, types, formats)
[Service Layer]      → Business rule validation (uniqueness, state transitions, limits)
[DAO Layer]          → Data integrity validation (constraints, foreign keys)
```

### Validator Implementation

```[language]
// [Validator for this pattern]

public class [ValidatorName] {

    public void validate([InputType] input) {
        var errors = new ArrayList<ValidationError>();

        if ([condition]) {
            errors.add(new ValidationError("[field]", "[message]"));
        }

        if (!errors.isEmpty()) {
            throw new ValidationException(errors);
        }
    }
}
```

## Testing Strategy

### Unit Tests
- **What to mock:** [External dependencies, clients, DAOs]
- **What to assert:** [Return values, exception types, metric emissions, audit calls]
- **Naming:** `[methodName]_[scenario]_[expectedBehavior]`

### Integration Tests
- **What to test:** [End-to-end flow through real dependencies]
- **Environment:** [Local (DynamoDB Local, LocalStack) or deployed (Beta)]
- **Data setup:** [How test data is created and cleaned up]

### Contract Tests
- **Required for:** [All public API endpoints using this pattern]
- **Verify:** [Request/response schema matches OpenAPI spec]

### Negative Tests
- **Required scenarios:**
  - [Invalid input → 400 with field-level errors]
  - [Missing auth → 403]
  - [Resource not found → 404]
  - [Dependency down → 503 with retry headers]
  - [Rate limited → 429 with retry-after]

## Examples in Codebase

| Location | Description | Notes |
|----------|-------------|-------|
| [src/main/.../activity/CreateResourceActivity.java] | [Create flow using this pattern] | [Good reference implementation] |
| [src/main/.../client/DependencyClient.java] | [External service client using this pattern] | [Shows retry + circuit breaker] |
| [src/test/.../activity/CreateResourceActivityTest.java] | [Unit tests for this pattern] | [Shows mocking strategy] |

## Anti-Patterns to Avoid

| Anti-Pattern | Problem | Correct Approach |
|-------------|---------|-----------------|
| [Swallowing exceptions] | [Hides failures, makes debugging impossible] | [Always log, map to appropriate exception, emit metric] |
| [Retrying non-retryable errors] | [Wastes resources, delays failure response] | [Classify errors, only retry 5xx/transient] |
| [Hardcoding config] | [Cannot change without redeploy] | [Use SSM/AppConfig/env vars] |
| [Skipping validation] | [Bad data reaches DB, causes downstream failures] | [Validate at API layer, enforce at service layer] |
| [Direct dependency calls] | [Tight coupling, hard to test, no retry/metrics] | [Use client interface with retry, metrics, error mapping] |

## Checklist for New Implementations

- [ ] Interface defined with clear contract (methods, types, exceptions)
- [ ] Implementation handles all error cases (maps to correct exception type)
- [ ] Retry configured for retryable errors only
- [ ] Metrics emitted (latency, count, errors)
- [ ] Structured logging with correlation IDs
- [ ] Input validation at API layer
- [ ] Unit tests with mocked dependencies (happy path + error cases)
- [ ] Integration test for end-to-end flow
- [ ] Contract test for API schema
- [ ] Code review checklist items addressed

## Related Patterns

| Pattern | Relationship | When to Use Instead |
|---------|-------------|-------------------|
| [RelatedPattern1] | [e.g., Complementary — use together] | [e.g., When you need async processing] |
| [RelatedPattern2] | [e.g., Alternative] | [e.g., When simpler CRUD is sufficient] |

## References

- [Pattern origin / industry reference]: [Link]
- Architecture doc: `design/architecture/[name].md`
- API doc: `design/apis/[name].md`
- Team coding standards: [Link]
