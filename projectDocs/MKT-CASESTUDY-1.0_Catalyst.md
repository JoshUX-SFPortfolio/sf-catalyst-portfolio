# MKT-CASESTUDY-1.0 — Catalyst Marketing Technologies
## Portfolio Case Study — Salesforce Implementation

| Field | Value |
|---|---|
| Document ID | MKT-CASESTUDY-1.0 |
| Version | 1.0 |
| Status | Complete |
| Author | Portfolio Architect |
| Date | 2026-03-08 |
| Classification | Public — Portfolio Artefact |
| Branch | `vertical/marketing` |

---

## Executive Summary

Catalyst Marketing Technologies is a Series C B2B SaaS company (~280 employees, Austin TX) selling a multi-channel marketing orchestration platform. This case study documents a complete greenfield Salesforce implementation across Sales Cloud, Service Cloud, and Experience Cloud — designed, built, and documented to real-world consulting standards as a portfolio demonstration.

The build comprises **83 Apex tests at 100% pass rate**, **13 LWC components**, **4 Agentforce actions**, **full SDLC documentation** (BRD → DRP), and a live org with realistic sample data.

---

## The Fictional Client Scenario

**Company:** Catalyst Marketing Technologies, Inc.
**Tagline:** Accelerate Every Campaign.
**Size:** ~280 employees, Series C
**HQ:** Austin, Texas
**Industry:** Marketing Technology (B2B SaaS)

**The Platform** Catalyst sells four modules:

| Module | Description |
|---|---|
| Campaign Intelligence | Multi-channel campaign planning and execution |
| Audience Studio | Segmentation and data enrichment |
| Attribution Engine | Multi-touch attribution and ROI dashboards |
| Content Hub | Digital asset management and personalisation |

**Key Stakeholders**

| Name | Role |
|---|---|
| Marcus Chen | CEO |
| Priya Sharma | VP of Sales |
| Daniel Torres | VP of Customer Success |
| Ben Wallace | Revenue Ops Manager (primary process owner) |
| Sam Okafor | IT Director |

**Business Problem:** Catalyst was managing sales, service, and customer onboarding across disconnected tools — no single view of the customer, no SLA enforcement, no self-service portal. The implementation required a unified platform that could scale with a Series C growth trajectory.

---

## What Was Built

### Sales Cloud

- **Lead-to-Close process** with custom validation rules (phone/email format, close date future-dating, amount floor per tier)
- **Two Opportunity record types** — New Business and Renewal — with separate business processes and picklist values
- **Subscription Tier field** (`Starter / Professional / Enterprise`) driving SLA routing logic
- **10 Sales reports** covering pipeline, forecast vs quota, win/loss rate, rep activities, and renewal risk
- **3 dashboards** — Sales Leadership, Rep Performance, Service SLA — all deployed with `useReportChart: true` for Metadata API compatibility

### Service Cloud

- **5 Case record types** — Technical Support, Billing, Feature Request, General Enquiry, Onboarding
- **Entitlement-based SLA tiers** mapped to Subscription Tier (1hr / 4hr / 8hr first response)
- **Apex trigger framework** — one trigger per object, all logic in handler/service classes; no business logic in trigger bodies
- **`CaseService`** — auto-stamps SLA tier at creation, handles escalation flag logic
- **Case escalation flow** (`Case_AfterSave_NotifyOnHighPriority`) — auto-notifies owner on Priority = High

### Experience Cloud (LWR)

- **Catalyst Client Portal** — authenticated LWR site (`Customer Community Plus User` profile)
- **13 LWC components** including:
  - `catalystClientDashboard` — container grid wiring all tiles
  - `catalystCaseList` — filterable, paginated case datatable
  - `catalystCaseForm` — case submission with live knowledge deflection
  - `catalystOnboardingChecklist` — dynamic step-by-step progress tracker
  - `catalystUsageHeatmap` — platform usage visualisation
  - `catalystAriaLauncher` — FAB toggle embedding the Agentforce Aria chat widget
- All components built to **SLDS 2** standards (updated design tokens, no legacy Aura patterns)

### Agentforce — Aria Client Assistant

- **4 `@InvocableMethod` Apex actions** deployed and verified via REST:
  - `AriaSearchKnowledge` — dynamic SOSL against KnowledgeArticleVersion (graceful no-Knowledge fallback)
  - `AriaGetCaseStatus` — returns open cases for the authenticated portal user
  - `AriaGetOnboardingProgress` — delegates to `OnboardingPortalController`, returns % complete + next step
  - `AriaEscalateToAgent` — creates a Chat-origin Case pre-populated from the conversation
- **`GenAiPlugin`** (`ClientSelfService` topic) and **`GenAiFunction`** metadata deployed for all 4 actions
- **Aria agent** created in Agentforce Studio with Client Self-Service topic attached; EscalateToAgent wired successfully
- **Known limitation (LL-064):** GetCaseStatus / GetOnboardingProgress / SearchKnowledge blocked from Agentforce Builder "Add to Agent" by a Developer Edition org platform bug (error -1458072159). Actions deployed and API-verified; will wire when platform resolves or in sandbox.

### Custom Object Model (Core Layer)

| Object | Purpose |
|---|---|
| `Project__c` | Active implementations — linked to Account + Opportunity |
| `Service_Region__c` | Geographic service routing |
| `Asset_Item__c` | Customer-owned platform assets (AutoNumber ID) |
| `Feedback_Survey__c` | Post-interaction CSAT/NPS, flags negative scores to Case |
| `Portal_User_Group__c` | Experience Cloud user content targeting |

### Vertical Custom Fields (Account)

| Field | Type | Purpose |
|---|---|---|
| `Subscription_Tier__c` | Picklist | Starter / Professional / Enterprise — drives SLA |
| `Modules_Purchased__c` | MultiselectPicklist | Campaign Intelligence · Audience Studio · Attribution Engine · Content Hub |
| `Annual_Contract_Value__c` | Currency | ACV for revenue reporting |
| `Contract_Renewal_Date__c` | Date | Renewal pipeline tracking |
| `Health_Score__c` | Number | 0–100 customer health indicator |
| `Platform_Usage_Index__c` | Percent | Usage engagement metric |
| `CSAT_Average__c` | Number | 1.0–5.0 satisfaction score |

### Security Model

| Layer | Implementation |
|---|---|
| Profiles | 7 — Sales User, Sales Manager, Service User, Service Manager, Sys Admin, Customer Community Plus, Guest |
| Permission Sets | 7 — Sales Core, Sales Manager Extended, Service Core, Service Manager Extended, Portal Standard User, Portal Account Admin, Agentforce Service User |
| Role Hierarchy | 10 roles from CEO → SDR and Support tier leads |
| OWD | Accounts: Private · Cases: Read/Write · Opportunities: Private |
| Sharing Rules | Account criteria-based (by Subscription Tier) + Case criteria-based (by Priority) |
| Apex | `with sharing` throughout; `insert as user` for portal case creation; `WITH USER_MODE` on all portal SOQL |

### Sample Data

| Object | Count | Notable |
|---|---|---|
| Accounts | 50 | ~10 Starter / ~25 Professional / ~15 Enterprise; all 7 custom fields populated |
| Contacts | 196 | Linked to accounts across all tiers |
| Opportunities | 80 | New Business + Renewal record types; spread across stages |
| Cases | 120 | All 5 record types; mix of open/closed, priorities, tiers |
| Leads | 59 | Varied sources and statuses |

---

## SDLC Documentation Suite

All 9 documents produced and finalised:

| Doc ID | Document | Status |
|---|---|---|
| MKT-BRD-1.0 | Business Requirements Document | Complete |
| MKT-USAC-1.0 | User Stories & Acceptance Criteria | Complete |
| MKT-TDD-1.0 | Technical Design Document | Complete |
| MKT-DD-1.0 | Data Dictionary & ERD | Complete |
| MKT-TPQA-1.0 | Test Plan & QA Scripts | Complete |
| MKT-BDD-1.0 | BDD Testing Examples | Complete |
| MKT-DDT-1.0 | Data-Driven Testing Examples | Complete |
| MKT-PTS-1.0 | Performance Testing Suite | Complete |
| MKT-DRP-1.0 | Deployment & Release Plan | Complete |

---

## Technical Decisions Worth Noting

### Dynamic SOSL for Knowledge (no add-on required)

`AriaSearchKnowledge` and `KnowledgePortalController` use `Search.query()` and `Database.query()` with dynamically-constructed strings rather than static SOSL/SOQL. This allows the classes to compile and deploy without the Knowledge add-on licence, returning graceful empty results when the feature isn't enabled. The pattern is also injection-safe — `String.escapeSingleQuotes()` applied before interpolation.

### Single-Result invocable output for Agentforce

Agentforce Builder requires actions to return a **single output object**, not a list. All 4 Aria actions return `List<Result>{ r }` where `Result` contains one `String` field with the data serialised as plain text (pipe-delimited lines, `\n` separators). This avoids Builder compatibility issues with complex output shapes and keeps the LLM prompt context clean.

### `insert as user` + `WITH USER_MODE`

All portal-facing DML uses `insert as user` and all portal SOQL uses `WITH USER_MODE`. This enforces FLS and sharing at the Apex layer rather than relying solely on profile restrictions — a pattern appropriate for externally-accessible Experience Cloud code. FLS grants were added to `Admin.profile-meta.xml` for all custom Case fields to satisfy this enforcement.

### Trigger framework

The `TriggerHandler` abstract base class (from the Master Template Foundation) provides: handler registration, before/after dispatch, bypass API (`TriggerHandler.bypass('ObjectName')`), and exception-outside-trigger context guard. Handlers contain zero DML — all persistence is delegated to service classes (`CaseService`, `ProjectService`, etc.) which are independently testable.

### useReportChart: true

All dashboard chart components use `useReportChart: true` to delegate chart configuration to the report's saved chart. This avoids the Metadata API validation that checks `chartSummary` + `groupingColumn` compatibility with the report type — a common source of deploy failures when chart config is specified inline.

---

## Test Results (B.6 Gate)

| Metric | Value |
|---|---|
| Test classes | 12 |
| Tests ran | 83 |
| Pass rate | 100% |
| Fail rate | 0% |
| Run ID | `707gL00000dWsJo` |
| Org | `josh.45ca40001658@agentforce.com` |

All tests use `TestDataFactory` — no inline data creation. All assertions use `System.assertEquals` with messages. No `System.assert(true)` or assertion-free tests.

---

## Known Limitations & Open Items

| Ref | Description | Status |
|---|---|---|
| LL-064 | Agentforce Builder cannot add GetCaseStatus / GetOnboardingProgress / SearchKnowledge in DE org (error -1458072159) | Open — platform bug |
| LL-065 | `GenAiPlanner` metadata does not create an `AIApplication` in Agentforce Studio | Documented — create agent via UI |
| CI/CD | GitHub Actions workflows committed; JWT secrets not yet configured | Pending manual setup |
| Knowledge add-on | Not enabled on Developer Edition — KB search returns graceful fallback | By design |

---

## Skills Demonstrated

| Skill | Evidence |
|---|---|
| Apex (triggers, services, invocable) | 12 Apex classes, trigger handler framework, 83 tests |
| LWC / SLDS 2 | 13 components, design tokens, Jest tests |
| Experience Cloud (LWR) | Authenticated portal, network metadata, DigitalExperienceBundle |
| Agentforce | GenAiPlugin, GenAiFunction, @InvocableMethod, Agentforce Studio |
| Data modelling | 5 custom objects, 7 Account vertical fields, full ERD |
| Security | OWD, sharing rules, permission sets, `with sharing`, `WITH USER_MODE` |
| Reports & dashboards | 15 reports, 3 dashboards, Metadata API deployment |
| SDLC documentation | 9 documents from BRD → DRP, requirement traceability IDs throughout |
| Bulk data | Python + Bulk API 2.0 import; runtime RecordType resolution |
| CI/CD | GitHub Actions workflows, branch protection, CODEOWNERS |
| Git / SFDX | Feature branching, source-tracked deployments, `sf` CLI |
