# API: [ServiceName API]

This document describes the API surface, contracts, and operational characteristics for [ServiceName].

> **Related**: For service architecture, see `design/architecture/`. For implementation patterns, see `design/patterns/`. When updating this document, ensure related docs stay consistent.

## Overview

- **API style:** [REST / gRPC / GraphQL]
- **Entry point:** [e.g., API Gateway, ALB, NLB]
- **Auth:** [e.g., IAM SigV4, OAuth 2.0, API Key]
- **Spec:** [Link to OpenAPI / protobuf / GraphQL schema]

## Base URLs

| Environment | URL | Auth |
|-------------|-----|------|
| Dev | `[https://dev.example.com/api/v1]` | [method] |
| Staging | `[https://staging.example.com/api/v1]` | [method] |
| Prod | `[https://api.example.com/api/v1]` | [method] |

## Authentication & Authorization

### Authentication
- **Method:** [e.g., IAM SigV4, OAuth 2.0 Bearer, API Key, mTLS]
- **Required headers:** [e.g., `Authorization: Bearer <token>`, `x-api-key: <key>`]
- **Token TTL:** [e.g., 1 hour, refresh via /auth/token]

### Authorization
- **Model:** [e.g., RBAC, ABAC, resource-based IAM policies]
- **Resource policy:** [e.g., API Gateway resource policy restricts to allowlisted accounts]
- **Allowed callers:** [List accounts, service principals, or roles]

### Resource Policy (if applicable)

```json
{
  "Effect": "Allow",
  "Principal": {
    "AWS": [
      "[account-1]",
      "[account-2]",
      "[service-principal]"
    ]
  },
  "Action": "execute-api:Invoke",
  "Resource": "arn:aws:execute-api:[region]:[account]:[api-id]/*"
}
```

## API Operations

### [Group 1: e.g., Resource Management]

#### POST /[resource]

**Description:** [Create a new resource]

**Handler:** [CreateResourceActivity / CreateResourceController]

**Request:**
```json
{
  "name": "string (required) — unique name within account",
  "config": {
    "key1": "string (required) — description",
    "key2": "number (optional, default: 10) — description"
  },
  "tags": {
    "key": "value (optional)"
  }
}
```

**Response (201):**
```json
{
  "resourceArn": "arn:aws:service:region:account:resource/id",
  "resourceId": "string",
  "name": "string",
  "status": "CREATING",
  "createdAt": "2025-01-15T10:30:00Z"
}
```

**Errors:**

| Status | Code | Condition | Customer Message |
|--------|------|-----------|-----------------|
| 400 | ValidationException | [Missing required field, invalid format] | [Field-level error details] |
| 409 | ConflictException | [Name already exists in account] | [Resource with name X already exists] |
| 403 | AccessDeniedException | [Caller lacks permission] | [Not authorized to perform this action] |
| 429 | ThrottlingException | [Rate limit exceeded] | [Rate exceeded, retry after X seconds] |
| 500 | InternalServiceException | [Unexpected server error] | [Internal error, request ID: X] |

**Validation Rules:**
- `name`: 1-256 chars, alphanumeric + hyphens, unique per account
- `config.key1`: must be one of [allowed values]
- `tags`: max 50 tags, key max 128 chars, value max 256 chars

---

#### GET /[resource]/{resourceId}

**Description:** [Retrieve resource details]

**Handler:** [GetResourceActivity]

**Path params:** `resourceId` (required) — resource identifier

**Response (200):**
```json
{
  "resourceArn": "string",
  "resourceId": "string",
  "name": "string",
  "status": "ACTIVE | CREATING | DELETING | FAILED",
  "config": { },
  "tags": { },
  "createdAt": "ISO 8601",
  "updatedAt": "ISO 8601",
  "statusDetails": {
    "phase": "string",
    "message": "string"
  }
}
```

**Errors:**

| Status | Code | Condition |
|--------|------|-----------|
| 404 | ResourceNotFoundException | [Resource does not exist or was deleted] |
| 403 | AccessDeniedException | [Caller lacks permission for this resource] |

---

#### GET /[resources]

**Description:** [List resources with pagination and filtering]

**Handler:** [ListResourcesActivity]

**Query params:**

| Param | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| maxResults | number | No | 10 | [Max items per page, 1-100] |
| nextToken | string | No | — | [Pagination token from previous response] |
| status | string | No | — | [Filter by status] |
| sortBy | string | No | createdAt | [Sort field] |
| sortOrder | string | No | DESC | [ASC or DESC] |

**Response (200):**
```json
{
  "resources": [ { } ],
  "nextToken": "string (null if no more pages)"
}
```

---

#### PUT /[resource]/{resourceId}

**Description:** [Update resource configuration]

**Handler:** [UpdateResourceActivity]

**Request:**
```json
{
  "config": {
    "key1": "string — updated value"
  }
}
```

**Response (200):** [Updated resource object]

**Errors:**

| Status | Code | Condition |
|--------|------|-----------|
| 400 | ValidationException | [Invalid update parameters] |
| 404 | ResourceNotFoundException | [Resource not found] |
| 409 | ConflictException | [Resource in non-updatable state] |

---

#### DELETE /[resource]/{resourceId}

**Description:** [Delete a resource]

**Handler:** [DeleteResourceActivity]

**Response (200):**
```json
{
  "resourceId": "string",
  "status": "DELETING"
}
```

**Behavior:**
- [Soft delete: marks as DELETING, async cleanup]
- [Hard delete after [N] days by sweeper Lambda]
- [Associated sub-resources are cascade deleted]

## Internal APIs (Service-to-Service)

APIs not exposed to customers, used by internal services:

| Operation | Caller | Purpose | Auth |
|-----------|--------|---------|------|
| [DescribeResourceInternal] | [Workflow service] | [Get resource with internal fields] | [IAM role] |
| [UpdateResourceStatus] | [Workflow service] | [Update status from workflow] | [IAM role] |
| [GetResourceForInference] | [Frontend service] | [Hot-path lookup for routing] | [IAM role] |

**Performance note:** [e.g., GetResourceForInference is a hot-path operation on every request. Must respond in < 50ms P99. Callers should implement caching.]

## Pagination

- **Strategy:** [e.g., Cursor-based using DynamoDB LastEvaluatedKey, encoded as opaque nextToken]
- **Default page size:** [10]
- **Max page size:** [100]
- **Token expiry:** [Tokens are stateless, no expiry]
- **Consistency:** [Eventually consistent — new items may appear in subsequent pages]

## Rate Limits & Throttling

| Operation | Default Limit | Burst | Scope | Configurable |
|-----------|--------------|-------|-------|-------------|
| Create | [X TPS] | [Y] | [Per account] | [Yes — via limit increase] |
| Get/Describe | [X TPS] | [Y] | [Per account] | [Yes] |
| List | [X TPS] | [Y] | [Per account] | [Yes] |
| Update | [X TPS] | [Y] | [Per account] | [Yes] |
| Delete | [X TPS] | [Y] | [Per account] | [Yes] |

**Throttling response:**
```json
{
  "message": "Rate exceeded",
  "retryAfterSeconds": 1
}
```

## Versioning

- **Strategy:** [e.g., URL path /v1/, header-based, query param]
- **Current version:** [v1]
- **Deprecation policy:** [e.g., 12-month notice, 6-month overlap]
- **Breaking change policy:** [e.g., New version for breaking changes, additive changes in-place]

## Idempotency

| Operation | Idempotent | Mechanism |
|-----------|-----------|-----------|
| Create | [Yes — via clientToken] | [clientToken stored in DB, duplicate returns existing resource] |
| Get | [Yes — read-only] | [N/A] |
| Update | [Conditional — via ETag] | [If-Match header with ETag for optimistic locking] |
| Delete | [Yes] | [Deleting already-deleted resource returns 200] |

## Error Response Format

All errors follow a consistent format:

```json
{
  "message": "Human-readable error description",
  "code": "ErrorCode",
  "requestId": "unique-request-id",
  "details": [
    {
      "field": "config.key1",
      "message": "Must be one of: [allowed values]"
    }
  ]
}
```

## Event Publishing

API operations publish events for downstream consumers:

| Event | Trigger | Schema | Destination |
|-------|---------|--------|-------------|
| [resource.created] | [POST /resource succeeds] | [EventBridge schema] | [EventBridge bus] |
| [resource.updated] | [PUT /resource succeeds] | [EventBridge schema] | [EventBridge bus] |
| [resource.deleted] | [DELETE /resource succeeds] | [EventBridge schema] | [EventBridge bus] |
| [resource.status_changed] | [Status transition] | [DDB Stream → Lambda] | [EventBridge bus] |

## Contract Tests

- **Location:** [path to contract tests in repo]
- **Framework:** [e.g., Pact, custom schema validation]
- **Run:** `[test command]`
- **CI integration:** [e.g., Runs on every PR, blocks merge on failure]

## SDK / Client Libraries

| Language | Package | Install |
|----------|---------|---------|
| [Java] | [com.org:service-client:1.0] | [Maven/Gradle dependency] |
| [Python] | [service-client] | [pip install service-client] |
| [TypeScript] | [@org/service-client] | [npm install @org/service-client] |

## Performance Characteristics

| Operation | P50 Latency | P99 Latency | Notes |
|-----------|------------|------------|-------|
| Create | [~100ms] | [~500ms] | [Includes DDB transact write] |
| Get | [~20ms] | [~100ms] | [Single-item read] |
| List | [~50ms] | [~200ms] | [Query with GSI] |
| Update | [~50ms] | [~200ms] | [Conditional update] |
| Delete | [~30ms] | [~150ms] | [Soft delete, single write] |

## API Gateway Configuration (if applicable)

- **Type:** [REST / HTTP / WebSocket]
- **Endpoint:** [Regional / Edge / Private]
- **Custom domain:** [e.g., api.example.com]
- **Logging:** [Access logging enabled, [N]-year retention]
- **Tracing:** [X-Ray enabled]
- **WAF:** [Enabled / Disabled — rules]
- **Execute-api endpoint:** [Disabled for security]

## References

- OpenAPI spec: [Link]
- Architecture doc: `design/architecture/[name].md`
- SDK documentation: [Link]
- Postman collection: [Link]
- API changelog: [Link]
