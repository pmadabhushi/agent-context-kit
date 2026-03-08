# Service Design: OrderService

## Overview

OrderService is the core order processing service for the Commerce Platform.
It handles order creation, payment orchestration, inventory reservation, and
order lifecycle management.

## Architecture

```
                    ┌──────────────┐
                    │     ALB      │
                    │ (port 443)   │
                    └──────┬───────┘
                           │
                    ┌──────┴───────┐
                    │ OrderService │
                    │ (ECS Fargate)│
                    │ 2-10 tasks   │
                    └──┬───┬───┬───┘
                       │   │   │
          ┌────────────┘   │   └────────────┐
          │                │                │
   ┌──────┴──────┐ ┌──────┴──────┐ ┌───────┴──────┐
   │ PaymentSvc  │ │ InventorySvc│ │   RDS        │
   │ (REST API)  │ │ (REST API)  │ │ (PostgreSQL) │
   └─────────────┘ └─────────────┘ └──────────────┘
          │                │                │
          │                │         ┌──────┴──────┐
          │                │         │   SQS       │
          │                │         │ (async jobs)│
          │                │         └─────────────┘
          │                │
   ┌──────┴──────┐ ┌──────┴──────┐
   │ Stripe API  │ │ Warehouse   │
   │ (external)  │ │ API (ext)   │
   └─────────────┘ └─────────────┘
```

## Infrastructure

| Component | Technology | Details |
|---|---|---|
| Compute | ECS Fargate | 2-10 tasks, auto-scaling on CPU (target 60%) |
| Load Balancer | ALB | HTTPS termination, path-based routing |
| Database | RDS PostgreSQL 15 | db.r6g.large, Multi-AZ, automated backups |
| Queue | SQS | Order processing queue, DLQ for failed messages |
| Cache | ElastiCache Redis | Session cache, rate limiting counters |
| Storage | S3 | Order documents, invoices, export files |

## API Endpoints

| Method | Path | Description | Rate Limit |
|--------|------|-------------|------------|
| POST | `/api/v1/orders` | Create a new order | 100/min per customer |
| GET | `/api/v1/orders/{id}` | Get order by ID | 500/min per customer |
| GET | `/api/v1/orders` | List orders (paginated) | 200/min per customer |
| PUT | `/api/v1/orders/{id}/cancel` | Cancel an order | 50/min per customer |
| GET | `/api/v1/orders/{id}/status` | Get order status | 1000/min per customer |
| POST | `/api/v1/orders/{id}/refund` | Initiate refund | 20/min per customer |

## Data Model

```sql
orders (
  id              UUID PRIMARY KEY,
  customer_id     UUID NOT NULL,
  status          VARCHAR(20) NOT NULL,  -- pending, confirmed, shipped, delivered, cancelled
  total_amount    DECIMAL(10,2) NOT NULL,
  currency        VARCHAR(3) DEFAULT 'USD',
  payment_id      VARCHAR(100),          -- Stripe payment intent ID
  shipping_address JSONB,
  created_at      TIMESTAMP DEFAULT NOW(),
  updated_at      TIMESTAMP DEFAULT NOW()
)

order_items (
  id              UUID PRIMARY KEY,
  order_id        UUID REFERENCES orders(id),
  product_id      UUID NOT NULL,
  quantity        INTEGER NOT NULL,
  unit_price      DECIMAL(10,2) NOT NULL,
  inventory_hold_id VARCHAR(100)         -- InventoryService hold reference
)
```

## Dependencies

| Service | Type | What For | Failure Impact |
|---|---|---|---|
| PaymentService | Internal REST | Payment processing | Orders stuck in "pending" |
| InventoryService | Internal REST | Stock reservation | Cannot confirm orders |
| Stripe API | External | Payment gateway | Payment failures |
| Warehouse API | External | Fulfillment | Shipping delays |
| SQS | AWS | Async order processing | Processing delays (retryable) |
| RDS | AWS | Primary data store | Full outage |
| ElastiCache | AWS | Caching, rate limiting | Degraded performance, no rate limiting |

## Failure Modes

| Failure | Detection | Impact | Mitigation |
|---|---|---|---|
| PaymentService down | 5xx from payment calls, circuit breaker open | New orders fail at payment step | Circuit breaker, retry with backoff, queue for later |
| InventoryService down | 5xx from inventory calls | Cannot reserve stock | Circuit breaker, allow order creation with deferred reservation |
| Database connection exhaustion | Connection pool metrics, slow queries | All requests fail | Connection pool limits (max 20), query timeouts (5s) |
| SQS message processing failure | DLQ depth > 0 | Delayed order processing | DLQ alarm, manual replay via `./scripts/replay-dlq.sh` |
| High traffic spike | CPU > 80%, request queue depth | Increased latency | Auto-scaling (target CPU 60%), rate limiting |
| Stripe API degradation | Increased payment latency, timeout errors | Slow checkouts | 10s timeout, retry once, fail gracefully with "try again" |

## Scaling

- Auto-scaling: CPU target 60%, min 2 tasks, max 10 tasks
- Scale-up cooldown: 60 seconds
- Scale-down cooldown: 300 seconds
- Database: vertical scaling (change instance type), read replicas for reporting
- Expected capacity: ~500 orders/minute at current scaling config

## Monitoring

| Metric | Normal | Warning | Critical |
|---|---|---|---|
| Error rate (5xx) | < 0.5% | > 2% | > 5% |
| P99 latency | < 200ms | > 500ms | > 1000ms |
| CPU utilization | < 60% | > 75% | > 90% |
| DB connections | < 15 | > 18 | = 20 (pool exhausted) |
| SQS DLQ depth | 0 | > 0 | > 10 |
| Order success rate | > 98% | < 95% | < 90% |

## Security

- All traffic over HTTPS (TLS 1.2+)
- API authentication via JWT tokens (issued by AuthService)
- Database credentials in AWS Secrets Manager, rotated every 90 days
- PII (customer addresses) encrypted at rest in RDS
- No customer PII in logs — use customer_id only
