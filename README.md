# Salesforce Portfolio — Master Template Foundation

> A production-grade Salesforce portfolio framework built to consulting standards.
> Every artefact here reflects real-world implementation practice — not tutorial code.

---

## What This Is

This repository contains the **Master Template Foundation (MTF)** — a reusable Salesforce implementation framework that is verticalised into industry-specific demos for job applications across multiple Salesforce clouds.

The first vertical is **Catalyst Marketing Technologies** — a fictional Series C B2B SaaS company used to demonstrate a full Sales Cloud, Service Cloud, and Experience Cloud implementation, including Agentforce AI.

---

## Repository Structure

```
sf-catalyst-portfolio/
├── projectDocs/          ← Full SDLC document suite (9 documents)
├── force-app/            ← SFDX metadata source (Apex, LWC, Flows, Objects)
├── config/               ← Scratch org definition
├── .github/              ← PR template, CI/CD workflows (post v1.0)
├── CLAUDE.md             ← Session context for Claude Code
└── sfdx-project.json     ← SFDX project config (API v62.0)
```

---

## Branch Strategy

| Branch | Purpose |
|---|---|
| `main` | Master Template Foundation — always deployable, protected |
| `develop` | Integration — PRs required |
| `vertical/marketing` | Catalyst Marketing Technologies (active) |
| `vertical/environmental` | Planned |
| `vertical/gis` | Planned |
| `vertical/maritime` | Planned |
| `vertical/education` | Planned |
| `vertical/gov-defense` | Planned |
| `vertical/startup` | Planned |

Vertical branches never merge back to `main`. Each vertical is a standalone, demo-ready implementation built on top of the MTF core layer.

---

## Catalyst Vertical — Technology Stack

| Layer | Technology |
|---|---|
| UI Components | SLDS 2 — Lightning Web Components |
| Experience Cloud | LWR (Lightning Web Runtime) — authenticated portal |
| AI | Agentforce — Aria client assistant + recruiter agent |
| Automation | Flows + Apex trigger handler framework |
| API | SF CLI v2, API version 62.0 |
| Test Coverage | >= 85% — meaningful assertions, TestDataFactory pattern |
| Version Control | Git + SFDX source format |

---

## SDLC Document Suite

All planning artefacts are committed alongside the code. This is deliberate — the documentation is part of the portfolio.

| Document | Description |
|---|---|
| [MKT-BRD-1.0](projectDocs/MKT-BRD-1.0_Catalyst.md) | Business Requirements Document |
| [MKT-USAC-1.0](projectDocs/MKT-USAC-1.0_Catalyst.md) | User Stories & Acceptance Criteria |
| [MKT-TDD-1.0](projectDocs/MKT-TDD-1.0_Catalyst.md) | Technical Design Document |
| [MKT-DD-1.0](projectDocs/MKT-DD-1.0_Catalyst.md) | Data Dictionary & ERD |
| [MKT-TPQA-1.0](projectDocs/MKT-TPQA-1.0_Catalyst.md) | Test Plan & QA Scripts |
| [MKT-BDD-1.0](projectDocs/MKT-BDD-1.0_Catalyst.md) | BDD Testing Examples (Gherkin) |
| [MKT-DDT-1.0](projectDocs/MKT-DDT-1.0_Catalyst.md) | Data-Driven Testing Examples |
| [MKT-PTS-1.0](projectDocs/MKT-PTS-1.0_Catalyst.md) | Performance Testing Suite |
| [MKT-DRP-1.0](projectDocs/MKT-DRP-1.0_Catalyst.md) | Deployment & Release Plan |
| [MKT-LL-1.0](projectDocs/MKT-LL-1.0_Catalyst.md) | Lessons Learned — all phases (living document) |

---

## What the Catalyst Implementation Covers

### Sales Cloud
- Lead scoring, routing by source and geography, conversion gate (activity count)
- Opportunity stage gates with required field validation
- Quote discount approval process (VP of Sales at > 15%)
- Account Health Score — 4-component weighted formula (CSAT, open cases, usage, renewal proximity)
- Pipeline and forecast reports

### Service Cloud
- Case management with 5 record types (Technical, Billing, Onboarding, General, Feature Request)
- SLA Entitlement Processes for 3 subscription tiers (Enterprise 1hr/4hr, Professional 4hr/2day, Starter 8hr/5day)
- Omni-Channel skills-based routing (Technical Support, Billing, Onboarding Specialist)
- Automated escalation (scheduled flow, every 15 minutes)
- Post-close CSAT survey flow feeding Account Health Score
- Service console with custom LWC case detail component

### Experience Cloud (LWR Portal)
- Authenticated Catalyst Client Portal
- 13 custom LWC components — dashboard, subscription tile, case list, knowledge search, onboarding checklist, Aria launcher FAB
- Data isolation enforced — portal users see only their own account's data
- Knowledge article deflection before case submission

### Agentforce
- **Aria** — authenticated client assistant in the portal (SearchKnowledge, GetCaseStatus, GetOnboardingProgress, EscalateToAgent)
- **Recruiter Agent** — public portfolio site, answers questions about the portfolio without login

### Apex Architecture
- One trigger per object → handler class → service class (no logic in trigger body)
- `ITriggerHandler` interface + `TriggerHandlerBase` with bypass mechanism
- All SOQL bulkified — no queries inside loops
- `WITH USER_MODE` on all portal-facing SOQL
- Integration stubs for Billing API and Usage API (Named Credentials, HttpCalloutMock in tests)
- TestDataFactory for all test data

---

## Project Status

| Phase | Description | Status |
|---|---|---|
| SDLC Docs | 10-document planning suite (incl. Lessons Learned) | Complete |
| A.1 | SFDX project setup + repo structure | Complete |
| A.2 | Core object model (5 custom objects, 60+ fields) | Complete |
| A.3 | Security architecture (profiles, permission sets, OWD, sharing rules) | Complete |
| A.4 | Automation library (trigger framework, 6 handlers, flows) | Complete |
| A.5 | LWC component library (13 components, 4 Apex controllers) | Complete |
| A.6 | Reports & dashboards (15 reports, 3 dashboards) | Complete |
| A.7 | Experience Cloud LWR site (authenticated portal, 8 pages) | Complete |
| A.8 | Agentforce — Aria client assistant (3 invocable actions, topic, system prompt) | Complete |
| A.9 | MTF stabilisation + v1.0 tag | Active |
| B | Catalyst vertical configuration + go-live | Pending |

---

## Recruiter & Hiring Manager Access

| Tier | What You Can See |
|---|---|
| Public | This repo — all source code and SDLC documents |
| Hiring Manager | Shared read-only org login (request via contact) |
| Interview | Screen share walkthrough — live org, controlled narrative |

---

## Contact

**Josh Murdadrum**
Salesforce Architect / Developer
[GitHub: JoshUX-SFPortfolio](https://github.com/JoshUX-SFPortfolio)
