# Example: Mainspring Energy — Fleet Management Platform

This is a filled-out example showing what AI agent configuration looks like for an
energy technology company that manufactures and operates a fleet of modular linear
generators deployed at customer sites.

Based on publicly available information about [Mainspring Energy](https://www.mainspringenergy.com/),
a company that builds fuel-flexible, low-emission linear generators for data centers,
utilities, and industrial customers.

## Why This Example?

This demonstrates agent configuration for a very different domain than a typical
web service: **IoT fleet management for physical hardware**. It shows how the
templates adapt to:

- Monitoring physical devices (generators) in the field, not just cloud services
- Industrial telemetry (power output, fuel flow, emissions, vibration)
- Safety-critical operations (energy equipment, grid interconnection)
- Multi-site fleet management across customer locations
- Regulatory compliance (emissions standards, grid codes, permitting)

## What's Here

All three personas are represented:

| Domain | Persona | Focus |
|--------|---------|-------|
| DevOps | Fleet Operations Engineer | Generator fleet monitoring, remote diagnostics, firmware updates |
| Coding | Platform Developer | Fleet management platform, telemetry pipeline, customer portal |
| Security | Security Analyst | OT/IT security, NERC CIP compliance, fleet access control |

## Architecture (Fictional but Realistic)

```
┌─────────────────────────────────────────────────────────────┐
│ Field Sites (Customer Locations)                            │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐                  │
│  │ LGen-001 │  │ LGen-002 │  │ LGen-003 │  ... (fleet)     │
│  │ 250kW    │  │ 250kW    │  │ 250kW    │                  │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘                  │
│       └──────────────┼──────────────┘                       │
│                      │ MQTT / Modbus                        │
│              ┌───────┴───────┐                              │
│              │  Edge Gateway │  (per site)                   │
│              └───────┬───────┘                              │
└──────────────────────┼──────────────────────────────────────┘
                       │ TLS / VPN
              ┌────────┴────────┐
              │   Cloud Platform │
              │                  │
              │  ┌────────────┐  │
              │  │ Telemetry  │  │  ← Time-series DB (InfluxDB/TimescaleDB)
              │  │ Pipeline   │  │
              │  ├────────────┤  │
              │  │ Fleet Mgmt │  │  ← Unit registry, firmware, dispatch
              │  │ Service    │  │
              │  ├────────────┤  │
              │  │ Alert      │  │  ← Anomaly detection, threshold alerts
              │  │ Engine     │  │
              │  ├────────────┤  │
              │  │ Customer   │  │  ← Dashboard, reports, billing
              │  │ Portal     │  │
              │  └────────────┘  │
              └─────────────────┘
```

## How to Use This Example

1. Browse the files to see how templates adapt to an IoT/energy domain
2. Compare with the generic templates in `templates/coding/`, `templates/devops/`, `templates/security/`
3. Notice how the same structure (AGENTS.md → persona → skills) works for
   physical hardware operations, not just cloud services
