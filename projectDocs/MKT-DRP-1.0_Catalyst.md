# MKT-DRP-1.0 — Deployment & Release Plan
## Catalyst Marketing Technologies — Salesforce Implementation

| Field | Value |
|---|---|
| Document ID | MKT-DRP-1.0 |
| Version | 1.0 |
| Status | Complete |
| Author | Portfolio Architect |
| Date | 2026-03-06 |
| Classification | Internal — Portfolio Artefact |

---

## Table of Contents

1. [Purpose and Scope](#1-purpose-and-scope)
2. [Release Overview](#2-release-overview)
3. [Environments and Org Strategy](#3-environments-and-org-strategy)
4. [Branch Strategy and Code Promotion](#4-branch-strategy-and-code-promotion)
5. [Deployment Prerequisites](#5-deployment-prerequisites)
6. [Phase-by-Phase Deployment Plan](#6-phase-by-phase-deployment-plan)
7. [Metadata Deployment Inventory](#7-metadata-deployment-inventory)
8. [Deployment Runbooks](#8-deployment-runbooks)
9. [Go-Live Checklist](#9-go-live-checklist)
10. [Rollback Plan](#10-rollback-plan)
11. [Post-Deployment Validation](#11-post-deployment-validation)
12. [Change Management and Communication](#12-change-management-and-communication)
13. [CI/CD Readiness (Post v1.0)](#13-cicd-readiness-post-v10)
14. [Traceability Matrix](#14-traceability-matrix)

---

## 1. Purpose and Scope

### 1.1 Purpose

This Deployment & Release Plan (DRP) defines the end-to-end process for deploying the Catalyst Marketing Technologies Salesforce implementation from scratch org development through to the persistent Developer Edition org (`sf-portfolio`). It establishes environment strategy, deployment sequencing, runbook procedures, go-live criteria, and rollback instructions.

This document is the final SDLC artefact before active metadata build begins. It is authoritative for all deployment decisions during the Catalyst vertical build.

### 1.2 Scope

| In Scope | Out of Scope |
|---|---|
| All metadata in `force-app/main/default/` | Managed package installation procedures |
| Scratch org → Developer Edition promotion | Sandbox → Production promotion (no sandbox on DE) |
| Manual SF CLI deployment procedures | GitHub Actions automation (deferred — see Section 13) |
| Data migration (sample data loading) | Production data migration |
| Go-live validation and rollback | Third-party system (billing/usage API) go-live |

### 1.3 Governing Documents

| Document | Role |
|---|---|
| MKT-TDD-1.0 | Authoritative technical design — source of all metadata inventory |
| MKT-TPQA-1.0 | Functional test scripts — used for post-deployment validation |
| MKT-PTS-1.0 | Performance test suite — used for post-deployment performance validation |
| CICD_ADDENDUM.md | CI/CD deferral rationale and future workflow specs |

---

## 2. Release Overview

### 2.1 Release Identity

| Field | Value |
|---|---|
| Release Name | Catalyst v1.0 |
| Release Type | Initial deployment (greenfield) |
| Target Org | Developer Edition — `sf-portfolio` alias |
| Target Branch | `vertical/marketing` (source of truth) |
| Planned Deploy Date | 2026-03-08 — all phases deployed to `sf-portfolio` org |
| Release Manager | Portfolio Architect |

### 2.2 Release Goals

1. Deploy all Catalyst Marketing Technologies metadata to the persistent Developer Edition org
2. Validate functional correctness against MKT-TPQA-1.0 test scripts
3. Validate performance against MKT-PTS-1.0 SLOs
4. Establish a stable, demo-ready org state for portfolio presentation
5. Tag the `vertical/marketing` branch at `catalyst-v1.0` upon successful go-live

### 2.3 Release Phases

| Phase | Name | Scope | Status |
|---|---|---|---|
| Phase 1 | Foundation | Core objects, fields, security model | Pre-build |
| Phase 2 | Automation | Flows, triggers, Apex classes | Pre-build |
| Phase 3 | UI Layer | Page layouts, LWC components, apps | Pre-build |
| Phase 4 | Experience Cloud | LWR portal, portal profiles, Aria config | Pre-build |
| Phase 5 | Data & Validation | Sample data load, validation testing | Pre-build |
| Phase 6 | Go-Live | Final sign-off, tag, org lock | Pre-build |

---

## 3. Environments and Org Strategy

### 3.1 Environment Inventory

| Environment | Org Type | Alias | Purpose | Data |
|---|---|---|---|---|
| Development | Scratch Org | `catalyst-dev` (rotated) | Active feature development | Synthetic test data |
| Deploy Target | Developer Edition | `sf-portfolio` | Portfolio demo org — permanent | Sample data (loaded post-deploy) |

**No sandbox orgs** are used in this portfolio framework. The Developer Edition org is the persistent deploy target. Scratch orgs are disposable and rotated per feature or sprint cycle.

### 3.2 Scratch Org Lifecycle

```
Create scratch org  →  Develop feature  →  Run tests  →  Commit metadata  →  Destroy scratch org
       ↑                                                         ↓
       └─────────────── Pull from vertical/marketing ───────────┘
```

**Scratch Org Configuration (`config/project-scratch-def.json`):**

```json
{
  "orgName": "Catalyst Dev",
  "edition": "Developer",
  "features": [
    "EnableSetPasswordInApi",
    "Communities",
    "ServiceCloud",
    "Entitlements"
  ],
  "settings": {
    "lightningExperienceSettings": {
      "enableS1DesktopEnabled": true
    },
    "mobileSettings": {
      "enableS1EncryptedStoragePref2": false
    }
  }
}
```

### 3.3 Scratch Org Commands

```bash
# Create a new scratch org (30-day default)
sf org create scratch \
  --definition-file config/project-scratch-def.json \
  --alias catalyst-dev \
  --duration-days 30 \
  --set-default

# Open the org
sf org open --target-org catalyst-dev

# Check scratch org expiry
sf org list

# Delete when done
sf org delete scratch --target-org catalyst-dev --no-prompt
```

### 3.4 Developer Edition Org

The Developer Edition org (`sf-portfolio`) is the **permanent** deploy target and must never be left in a broken state. All deployments to this org must pass the go-live checklist (Section 9) before being considered complete.

```bash
# Verify DE org auth
sf org display --target-org sf-portfolio

# Open DE org
sf org open --target-org sf-portfolio
```

---

## 4. Branch Strategy and Code Promotion

### 4.1 Branch Hierarchy

```
main (MTF — protected)
  └── develop (integration — PRs required)
        └── vertical/marketing (Catalyst — active)
              └── feature/* (individual features — short-lived)
```

### 4.2 Code Promotion Flow

```
feature/* ──PR──► vertical/marketing ──PR──► develop
                         ↑
                    deploy to sf-portfolio
                    (direct from vertical branch)
```

**Key rules:**
- `vertical/marketing` never merges into `main`
- All feature work is committed to `vertical/marketing` via PR from a feature branch
- The `sf-portfolio` Developer Edition org is deployed from `vertical/marketing`
- `main` receives only core-layer changes tagged `[core-update]`

### 4.3 Feature Branch Naming

```
feature/[area]-[brief-description]

Examples:
  feature/sales-lead-trigger
  feature/service-case-entitlement
  feature/portal-lwc-dashboard
  feature/agentforce-aria-config
```

### 4.4 Commit Convention

```
[type]: brief description

Types:
  feat      — new feature or metadata component
  fix       — bug fix
  refactor  — code restructure, no behaviour change
  test      — test class or test data update
  docs      — documentation only
  config    — configuration metadata (custom settings, metadata types)
  [core-update] — core-layer change intended to flow to main
```

**Examples:**
```
feat: add LeadTrigger and LeadTriggerHandler
feat: add Case_BeforeSave_SetEntitlement flow
fix: correct CSAT rollup formula on Account
test: add TestDataFactory createLeads method
config: add Entitlement process for Enterprise tier
[core-update]: add Portal_User_Group__c custom object
```

---

## 5. Deployment Prerequisites

### 5.1 Local Environment Prerequisites

| Prerequisite | Required Version | Verification Command |
|---|---|---|
| SF CLI | v2.125.2+ | `sf version` |
| Git | 2.40+ | `git --version` |
| Node.js | 18 LTS+ (for Jest) | `node --version` |
| Java | JDK 11+ (for PMD static analysis) | `java --version` |

### 5.2 Org Authentication Prerequisites

| Org | Auth Method | Verification |
|---|---|---|
| `sf-portfolio` (DE) | Web login (`sf org login web`) | `sf org display --target-org sf-portfolio` |
| `catalyst-dev` (scratch) | Auto-auth on create | `sf org list` |

### 5.3 Pre-Deployment Org Checks

Before deploying to `sf-portfolio`, confirm:

```bash
# 1. Confirm API version compatibility
sf org display --target-org sf-portfolio
# Expect: API version 62.0 or higher in org info

# 2. Confirm no pending changes in target org
sf project retrieve start --target-org sf-portfolio --dry-run
# Expect: Zero conflicts (DE is deploy target, not development org)

# 3. Confirm local metadata is committed and clean
git status
# Expect: nothing to commit, working tree clean

# 4. Confirm on correct branch
git branch
# Expect: * vertical/marketing
```

### 5.4 Required Org Configuration (Manual, Pre-Deploy)

Some configuration cannot be deployed via SF CLI metadata and must be applied manually in the target org before metadata deployment:

| # | Configuration Item | Location in Setup | Phase Required Before |
|---|---|---|---|
| 1 | Enable Communities (Experience Cloud) | Setup > Digital Experiences > Settings | Phase 4 |
| 2 | Enable Entitlements | Setup > Entitlements > Settings | Phase 1 |
| 3 | Enable Omni-Channel | Setup > Omni-Channel > Settings | Phase 2 |
| 4 | Enable Knowledge | Setup > Knowledge > Settings | Phase 3 |
| 5 | Enable Einstein (Agentforce) | Setup > Einstein > Settings | Phase 4 |
| 6 | Assign admin user to Omni-Channel Supervisor permission set | Users > Permission Set Assignments | Phase 2 |

---

## 6. Phase-by-Phase Deployment Plan

### Phase 1 — Foundation

**Goal:** Deploy all custom objects, custom fields on standard objects, validation rules, security model (profiles, permission sets, OWD, sharing rules), and custom metadata types.

**Order matters:** Custom objects must be deployed before custom fields that reference them (lookup/master-detail relationships).

#### 1A — Custom Metadata Types

Deploy first — referenced by flows and Apex automation.

```bash
sf project deploy start \
  --source-dir force-app/main/default/customMetadata \
  --target-org sf-portfolio \
  --wait 10
```

Expected metadata:
- `Domain_Exclusion__mdt` records (common email domains to exclude from auto-link)
- Any other configuration metadata used by Apex/Flow

#### 1B — Custom Objects (Core Layer)

```bash
sf project deploy start \
  --source-dir force-app/main/default/objects \
  --target-org sf-portfolio \
  --wait 10
```

Deployment order within objects directory (SF CLI handles dependency resolution, but confirm these deploy cleanly):

| Order | Object | Dependencies |
|---|---|---|
| 1 | `Service_Region__c` | None |
| 2 | `Portal_User_Group__c` | None |
| 3 | `Project__c` | Account, Opportunity |
| 4 | `Asset_Item__c` | Account, Contact |
| 5 | `Feedback_Survey__c` | Contact, Case |
| 6 | All standard object field extensions | Standard objects must exist |

#### 1C — Security Model

```bash
sf project deploy start \
  --source-dir force-app/main/default/profiles \
  --source-dir force-app/main/default/permissionsets \
  --target-org sf-portfolio \
  --wait 10
```

Post-deploy: Manually verify OWD settings in Setup > Security > Sharing Settings. OWD cannot be deployed via metadata API for all objects; verify:

| Object | OWD Setting | Action |
|---|---|---|
| Lead | Private | Verify in Sharing Settings |
| Opportunity | Private | Verify in Sharing Settings |
| Case | Private | Verify in Sharing Settings |
| Project__c | Private | Verify in Sharing Settings |
| Feedback_Survey__c | Private | Verify in Sharing Settings |

#### 1D — Role Hierarchy

Roles must be created/verified manually if not deployable via metadata. Confirm:
- CEO
  - VP of Sales
    - Sales Manager
      - Sales Rep
  - VP of Customer Success
    - Service Manager
      - Service Agent

#### Phase 1 Validation

```bash
# Run post-Phase 1 deployment validation
sf project deploy validate \
  --source-dir force-app/main/default \
  --target-org sf-portfolio \
  --test-level RunLocalTests \
  --wait 20
```

---

### Phase 2 — Automation

**Goal:** Deploy Apex trigger framework, flows, entitlements, and queue configuration.

**Prerequisites:** Phase 1 complete. Omni-Channel and Entitlements enabled in org.

#### 2A — Apex Classes (Framework First)

Deploy in dependency order:

```bash
# Step 1: Deploy interfaces and base classes first
sf project deploy start \
  --metadata ApexClass:ITriggerHandler \
  --metadata ApexClass:TriggerHandlerBase \
  --target-org sf-portfolio \
  --wait 10

# Step 2: Deploy service classes (no trigger dependencies)
sf project deploy start \
  --metadata ApexClass:LeadScoringService \
  --metadata ApexClass:CaseEntitlementService \
  --metadata ApexClass:CaseRoutingService \
  --metadata ApexClass:AccountHealthScoreService \
  --metadata ApexClass:BillingAPIService \
  --metadata ApexClass:UsageAPIService \
  --target-org sf-portfolio \
  --wait 10

# Step 3: Deploy handler classes
sf project deploy start \
  --metadata ApexClass:LeadTriggerHandler \
  --metadata ApexClass:CaseTriggerHandler \
  --metadata ApexClass:OpportunityTriggerHandler \
  --metadata ApexClass:AccountTriggerHandler \
  --metadata ApexClass:FeedbackSurveyTriggerHandler \
  --target-org sf-portfolio \
  --wait 10

# Step 4: Deploy triggers (after handlers exist)
sf project deploy start \
  --metadata ApexTrigger:LeadTrigger \
  --metadata ApexTrigger:CaseTrigger \
  --metadata ApexTrigger:OpportunityTrigger \
  --metadata ApexTrigger:AccountTrigger \
  --metadata ApexTrigger:FeedbackSurveyTrigger \
  --target-org sf-portfolio \
  --wait 10

# Step 5: Deploy test factory and test classes
sf project deploy start \
  --metadata ApexClass:TestDataFactory \
  --metadata ApexClass:LeadTriggerHandlerTest \
  --metadata ApexClass:CaseTriggerHandlerTest \
  --metadata ApexClass:OpportunityTriggerHandlerTest \
  --metadata ApexClass:AccountHealthScoreServiceTest \
  --metadata ApexClass:BillingAPIServiceTest \
  --metadata ApexClass:UsageAPIServiceTest \
  --target-org sf-portfolio \
  --wait 10
```

#### 2B — Run Apex Tests (First Gate)

```bash
sf apex run test \
  --test-level RunLocalTests \
  --result-format human \
  --code-coverage \
  --target-org sf-portfolio \
  --wait 20
```

**Gate criteria:** All tests pass. Code coverage >= 85% across all Apex classes.

#### 2C — Flows

```bash
sf project deploy start \
  --source-dir force-app/main/default/flows \
  --target-org sf-portfolio \
  --wait 10
```

Flow deployment order (handle dependencies):

| Order | Flow API Name | Trigger | Dependencies |
|---|---|---|---|
| 1 | `Lead_AfterSave_FollowUpTask` | Lead after save | Lead object fields |
| 2 | `Lead_BeforeSave_AssignRegion` | Lead before save | Service_Region__c |
| 3 | `Opportunity_BeforeSave_StageGate` | Opportunity before save | Opportunity fields |
| 4 | `Opportunity_AfterSave_CreateProject` | Opportunity after save | Project__c |
| 5 | `Case_BeforeSave_SetEntitlement` | Case before save | Entitlement Process (must exist) |
| 6 | `Case_AfterSave_AutoLinkAccount` | Case after save | Domain_Exclusion__mdt |
| 7 | `Case_AfterClose_SendSurvey` | Case after save (Status=Closed) | Feedback_Survey__c |
| 8 | `Case_Scheduled_EscalationCheck` | Scheduled (every 15 min) | Case fields, queue config |
| 9 | `Account_AfterSave_HealthScore` | Account after save | AccountHealthScoreService |
| 10 | `Contact_AfterSave_PortalSync` | Contact after save | Portal_User_Group__c |
| 11 | `FeedbackSurvey_AfterSave_UpdateAccountCSAT` | FeedbackSurvey after save | Account CSAT_Average__c |

#### 2D — Entitlement Processes and Milestones

Entitlement Processes cannot be fully deployed via metadata API. Verify in Setup > Entitlements > Entitlement Processes:

| Entitlement Process | First Response | Resolution | Applies To |
|---|---|---|---|
| Enterprise SLA | 1 business hour | 4 business hours | Enterprise tier accounts |
| Professional SLA | 4 business hours | 2 business days | Professional tier accounts |
| Starter SLA | 8 business hours | 5 business days | Starter tier accounts |

#### 2E — Queues and Omni-Channel

```bash
sf project deploy start \
  --metadata Queue:Enterprise_Support \
  --metadata Queue:Professional_Support \
  --metadata Queue:Starter_Support \
  --metadata Queue:Technical_Escalation \
  --target-org sf-portfolio \
  --wait 10
```

Omni-Channel routing configuration (verify manually post-deploy):
- Skills: `Technical_Support`, `Billing`, `Onboarding_Specialist`
- Routing configurations assigned to each queue
- Service channels: Cases, Chats

#### Phase 2 Validation

Run MKT-TPQA-1.0 cases: MKT-TC-SRVC-001 through MKT-TC-SRVC-006 (Case routing and SLA assignment).

---

### Phase 3 — UI Layer

**Goal:** Deploy Lightning App configurations, page layouts, compact layouts, record types, list views, custom labels, and LWC components (internal-facing).

#### 3A — Record Types

```bash
sf project deploy start \
  --metadata RecordType:Case.Technical_Support \
  --metadata RecordType:Case.Billing \
  --metadata RecordType:Case.Onboarding \
  --metadata RecordType:Case.General_Enquiry \
  --metadata RecordType:Case.Feature_Request \
  --target-org sf-portfolio \
  --wait 10
```

#### 3B — Custom Labels

```bash
sf project deploy start \
  --source-dir force-app/main/default/labels \
  --target-org sf-portfolio \
  --wait 10
```

#### 3C — LWC Components (Internal)

```bash
sf project deploy start \
  --source-dir force-app/main/default/lwc \
  --target-org sf-portfolio \
  --wait 10
```

Internal LWC components to verify:
- `catalyst-case-detail`
- `catalyst-case-form`
- `catalyst-module-list`

#### 3D — Page Layouts, Lightning Apps, and App Pages

```bash
sf project deploy start \
  --source-dir force-app/main/default/layouts \
  --source-dir force-app/main/default/applications \
  --source-dir force-app/main/default/flexipages \
  --target-org sf-portfolio \
  --wait 10
```

Post-deploy: Assign Lightning Apps to correct profiles in Setup > App Manager.

#### 3E — Reports and Dashboards

```bash
sf project deploy start \
  --source-dir force-app/main/default/reports \
  --source-dir force-app/main/default/dashboards \
  --target-org sf-portfolio \
  --wait 10
```

#### Phase 3 Validation

Run MKT-TPQA-1.0 cases: MKT-TC-SALES-001 through MKT-TC-SALES-012 (full Sales Cloud functional suite). Run PTS-1.x (page load timing).

---

### Phase 4 — Experience Cloud

**Goal:** Deploy the Catalyst Client Portal (LWR), portal-facing LWC components, guest/customer profiles, Named Credentials, and Agentforce Aria configuration.

**Prerequisites:** Phase 3 complete. Digital Experiences and Einstein enabled in org.

#### 4A — Named Credentials

```bash
sf project deploy start \
  --metadata NamedCredential:BillingSystem_NC \
  --metadata NamedCredential:UsageAPI_NC \
  --target-org sf-portfolio \
  --wait 10
```

**Post-deploy:** Verify Named Credential authentication in Setup > Security > Named Credentials. Update credential secrets if needed (secrets are not deployed via metadata).

#### 4B — Portal LWC Components

All `catalyst-` prefixed portal components:

```bash
sf project deploy start \
  --source-dir force-app/main/default/lwc \
  --target-org sf-portfolio \
  --wait 10
```

Portal LWC components to verify:
- `catalyst-client-dashboard`
- `catalyst-subscription-tile`
- `catalyst-open-cases-tile`
- `catalyst-usage-heatmap`
- `catalyst-case-list`
- `catalyst-knowledge-deflection`
- `catalyst-knowledge-search`
- `catalyst-knowledge-article`
- `catalyst-case-detail`
- `catalyst-onboarding-checklist`
- `catalyst-aria-launcher`

#### 4C — Experience Cloud Site

The LWR site configuration is partially deployable via metadata and partially manual:

**Deployable:**
```bash
sf project deploy start \
  --source-dir force-app/main/default/experiences \
  --target-org sf-portfolio \
  --wait 10
```

**Manual post-deploy steps:**
1. Open Digital Experience Builder for the Catalyst portal
2. Assign LWC components to page regions per SF-PORTFOLIO-UX-1.0.md layout specs
3. Configure navigation menu items
4. Set branding: Inter font, Cyan #00C2E0 primary, Salesforce Blue #0176D3 secondary
5. Publish the site

#### 4D — Agentforce Aria Configuration

Agentforce configuration is applied via Setup > Einstein > Agents. Not fully deployable via SF CLI in API v62.0 — apply manually:

1. Create Agent: **Aria**
2. Set Agent Topic: **Client Self-Service**
3. Configure system prompt (see MKT-TDD-1.0 Section 9.3)
4. Add Actions:
   - `SearchKnowledge` — maps to Knowledge search SOSL
   - `GetCaseStatus` — maps to `CaseStatusAction` Apex class
   - `GetOnboardingProgress` — maps to `OnboardingProgressAction` Apex class
   - `EscalateToAgent` — maps to Omni-Channel escalation flow
5. Set scope restrictions: client data only, no unauthenticated actions
6. Publish and assign to portal page via `catalyst-aria-launcher` component

#### 4E — Knowledge Base

```bash
sf project deploy start \
  --source-dir force-app/main/default/knowledge \
  --target-org sf-portfolio \
  --wait 10
```

Post-deploy: Publish all Knowledge Articles that are in Draft state.

#### Phase 4 Validation

Run MKT-TPQA-1.0 cases: MKT-TC-EXP-001 through MKT-TC-EXP-010 (portal access, data isolation, Aria scope). Run PTS-3.x (LWR Core Web Vitals).

---

### Phase 5 — Data and Validation

**Goal:** Load sample data, run the full functional and performance test suites, resolve all blocking issues.

#### 5A — Sample Data Load

Sample data volume targets (from MKT-DD-1.0):

| Object | Target Records | Load Method |
|---|---|---|
| Account | 50 | CSV import via Data Import Wizard or `sf data import` |
| Contact | 150 | CSV import |
| Lead | 100 | CSV import |
| Opportunity | 80 | CSV import |
| Case | 300 | CSV import or Apex data factory script |
| Knowledge Article | 80 | Manual creation or import |
| Project__c | 40 | CSV import |
| Feedback_Survey__c | 200 | Apex script (linked to Cases) |
| Service_Region__c | 10 | CSV import |

**Sample data requirements:**
- Accounts distributed across all 3 subscription tiers (Starter/Professional/Enterprise)
- Cases distributed across all 5 record types and all 3 tiers
- At least 20 closed Cases with CSAT scores (for Health Score calculation)
- At least 5 Portal Users activated (Customer Community Plus)

```bash
# Import sample data using SFDX data commands
sf data import tree \
  --files data/sample-accounts.json \
  --target-org sf-portfolio

sf data import tree \
  --files data/sample-contacts.json \
  --target-org sf-portfolio

# Verify record counts
sf data query \
  --query "SELECT COUNT() FROM Account" \
  --target-org sf-portfolio

sf data query \
  --query "SELECT COUNT() FROM Case" \
  --target-org sf-portfolio
```

#### 5B — Full Functional Test Execution

Execute all 38 MKT-TPQA-1.0 test cases. Document results in the test execution log.

**Regression suite (blocking):** 15 critical/high test cases must pass before go-live. See MKT-TPQA-1.0 Section 6 for regression suite list.

#### 5C — Performance Test Execution

Execute all PTS suites:
- PTS-2.x: Apex governor assertions (automated via `sf apex run test`)
- PTS-1.x: Page load timing (manual)
- PTS-3.x: LWR Lighthouse (manual)
- PTS-5.x: Report/dashboard timing (manual)

Record baseline measurements in the PTS-1.0 baseline template (Section 10.1).

#### 5D — Issue Resolution

All blocking issues (Critical/High severity) must be resolved and re-tested before advancing to Phase 6. Medium/Low issues are documented in the post-go-live backlog.

**Issue severity definitions:**

| Severity | Definition | Go-Live Impact |
|---|---|---|
| Critical | Feature completely broken; no workaround | Blocking |
| High | Feature broken; workaround exists but poor UX | Blocking |
| Medium | Feature partially impaired; workaround acceptable | Non-blocking; backlog |
| Low | Cosmetic issue; no functional impact | Non-blocking; backlog |

---

### Phase 6 — Go-Live

**Goal:** Execute final go-live checklist, tag the release, and lock org state.

See Section 9 for full go-live checklist.

```bash
# Tag the release on vertical/marketing branch
git tag -a catalyst-v1.0 -m "Catalyst Marketing Technologies v1.0 — initial deploy complete"
git push origin catalyst-v1.0

# Verify tag
git tag -l
```

---

## 7. Metadata Deployment Inventory

Complete inventory of all metadata types to be deployed, mapped to SFDX directory paths.

### 7.1 Core Metadata

| Metadata Type | API Names | Path | Phase |
|---|---|---|---|
| CustomObject | Project__c, Service_Region__c, Asset_Item__c, Feedback_Survey__c, Portal_User_Group__c | `objects/` | 1 |
| CustomField | Lead.*, Account.*, Contact.*, Opportunity.*, Case.* (see TDD Section 2) | `objects/[ObjectName]/fields/` | 1 |
| ValidationRule | 7 rules across Lead, Opportunity, Case, Feedback_Survey__c | `objects/[ObjectName]/validationRules/` | 1 |
| CustomMetadata | Domain_Exclusion__mdt records | `customMetadata/` | 1 |
| Profile | 7 profiles (Sales User, Sales Manager, Service User, Service Manager, System Administrator, Customer Community Plus, Guest) | `profiles/` | 1 |
| PermissionSet | 7 permission sets (see TDD Section 4.3) | `permissionsets/` | 1 |
| SharingRules | 3 sharing rules (Account, Case, Project__c) | `sharingRules/` | 1 |
| Role | Role hierarchy (CEO > VP Sales > Sales Manager > Sales Rep etc.) | `roles/` | 1 |

### 7.2 Automation Metadata

| Metadata Type | API Names | Path | Phase |
|---|---|---|---|
| ApexClass | 20 classes (see TDD Section 7.2) | `classes/` | 2 |
| ApexTrigger | 5 triggers (Lead, Case, Opportunity, Account, FeedbackSurvey) | `triggers/` | 2 |
| Flow | 11 flows (see TDD Section 6.3) | `flows/` | 2 |
| Queue | 4 queues (Enterprise/Professional/Starter Support, Technical Escalation) | `queues/` | 2 |
| ServiceChannel | Cases, Chats | `serviceChannels/` | 2 |
| RoutingConfiguration | 3 Omni-Channel routing configs | `routingConfigurations/` | 2 |

### 7.3 UI Layer Metadata

| Metadata Type | API Names | Path | Phase |
|---|---|---|---|
| RecordType | Case.* (5 record types) | `objects/Case/recordTypes/` | 3 |
| LightningComponentBundle | 13 catalyst-* components | `lwc/` | 3 + 4 |
| FlexiPage | Case record page, Account record page, Lead record page, App pages | `flexipages/` | 3 |
| CustomApplication | Catalyst Sales App, Catalyst Service Console | `applications/` | 3 |
| Layout | Layouts for all objects | `layouts/` | 3 |
| CustomLabel | All Catalyst labels | `labels/` | 3 |
| Report | Pipeline, Health Score, SLA reports | `reports/` | 3 |
| Dashboard | Sales, Service Manager dashboards | `dashboards/` | 3 |

### 7.4 Experience Cloud Metadata

| Metadata Type | API Names | Path | Phase |
|---|---|---|---|
| ExperienceBundle | Catalyst portal site | `experiences/` | 4 |
| NamedCredential | BillingSystem_NC, UsageAPI_NC | `namedCredentials/` | 4 |
| ConnectedApp | Portal Connected App | `connectedApps/` | 4 |

---

## 8. Deployment Runbooks

### 8.1 Full Deployment Runbook (Clean Install)

Use this runbook for a clean deployment to a fresh Developer Edition org or scratch org.

```bash
# ============================================================
# CATALYST v1.0 — FULL DEPLOYMENT RUNBOOK
# Target: sf-portfolio (Developer Edition)
# Branch: vertical/marketing
# ============================================================

# STEP 1: Confirm environment
sf version
git status
git branch
# Expected: vertical/marketing, clean working tree

# STEP 2: Manual org pre-configuration (one-time)
# In Setup, enable: Entitlements, Omni-Channel, Knowledge,
# Digital Experiences, Einstein/Agentforce
# (See Section 5.4 for full list)

# STEP 3: Deploy Phase 1 — Foundation
sf project deploy start \
  --source-dir force-app/main/default/customMetadata \
  --target-org sf-portfolio --wait 10

sf project deploy start \
  --source-dir force-app/main/default/objects \
  --target-org sf-portfolio --wait 10

sf project deploy start \
  --source-dir force-app/main/default/profiles \
  --source-dir force-app/main/default/permissionsets \
  --source-dir force-app/main/default/roles \
  --source-dir force-app/main/default/sharingRules \
  --target-org sf-portfolio --wait 10

echo "✓ Phase 1 complete. Verify OWD settings manually."

# STEP 4: Deploy Phase 2 — Automation
sf project deploy start \
  --metadata ApexClass:ITriggerHandler \
  --metadata ApexClass:TriggerHandlerBase \
  --target-org sf-portfolio --wait 10

sf project deploy start \
  --metadata ApexClass:LeadScoringService \
  --metadata ApexClass:CaseEntitlementService \
  --metadata ApexClass:CaseRoutingService \
  --metadata ApexClass:AccountHealthScoreService \
  --metadata ApexClass:BillingAPIService \
  --metadata ApexClass:UsageAPIService \
  --target-org sf-portfolio --wait 10

sf project deploy start \
  --metadata ApexClass:LeadTriggerHandler \
  --metadata ApexClass:CaseTriggerHandler \
  --metadata ApexClass:OpportunityTriggerHandler \
  --metadata ApexClass:AccountTriggerHandler \
  --metadata ApexClass:FeedbackSurveyTriggerHandler \
  --target-org sf-portfolio --wait 10

sf project deploy start \
  --metadata ApexTrigger:LeadTrigger \
  --metadata ApexTrigger:CaseTrigger \
  --metadata ApexTrigger:OpportunityTrigger \
  --metadata ApexTrigger:AccountTrigger \
  --metadata ApexTrigger:FeedbackSurveyTrigger \
  --target-org sf-portfolio --wait 10

sf project deploy start \
  --metadata ApexClass:TestDataFactory \
  --metadata ApexClass:LeadTriggerHandlerTest \
  --metadata ApexClass:CaseTriggerHandlerTest \
  --metadata ApexClass:OpportunityTriggerHandlerTest \
  --metadata ApexClass:AccountHealthScoreServiceTest \
  --metadata ApexClass:BillingAPIServiceTest \
  --metadata ApexClass:UsageAPIServiceTest \
  --target-org sf-portfolio --wait 10

# Gate: Run Apex tests
sf apex run test \
  --test-level RunLocalTests \
  --code-coverage \
  --result-format human \
  --target-org sf-portfolio --wait 20

echo "✓ Review test results. Coverage must be >= 85%. All tests must pass."
echo "  Press ENTER to continue or Ctrl-C to abort."
read

sf project deploy start \
  --source-dir force-app/main/default/flows \
  --target-org sf-portfolio --wait 10

sf project deploy start \
  --metadata Queue:Enterprise_Support \
  --metadata Queue:Professional_Support \
  --metadata Queue:Starter_Support \
  --metadata Queue:Technical_Escalation \
  --target-org sf-portfolio --wait 10

echo "✓ Phase 2 complete. Configure Entitlement Processes and Omni-Channel routing manually."

# STEP 5: Deploy Phase 3 — UI Layer
sf project deploy start \
  --source-dir force-app/main/default/labels \
  --source-dir force-app/main/default/lwc \
  --source-dir force-app/main/default/layouts \
  --source-dir force-app/main/default/applications \
  --source-dir force-app/main/default/flexipages \
  --source-dir force-app/main/default/reports \
  --source-dir force-app/main/default/dashboards \
  --target-org sf-portfolio --wait 20

echo "✓ Phase 3 complete. Assign Lightning Apps to profiles manually."

# STEP 6: Deploy Phase 4 — Experience Cloud
sf project deploy start \
  --metadata NamedCredential:BillingSystem_NC \
  --metadata NamedCredential:UsageAPI_NC \
  --target-org sf-portfolio --wait 10

sf project deploy start \
  --source-dir force-app/main/default/experiences \
  --target-org sf-portfolio --wait 20

echo "✓ Phase 4 metadata deployed."
echo "  Complete manual steps: Experience Builder branding, Aria agent config, Knowledge publish."

# STEP 7: Load sample data
sf data import tree --files data/sample-accounts.json --target-org sf-portfolio
sf data import tree --files data/sample-contacts.json --target-org sf-portfolio
sf data import tree --files data/sample-leads.json --target-org sf-portfolio
sf data import tree --files data/sample-opportunities.json --target-org sf-portfolio
sf data import tree --files data/sample-cases.json --target-org sf-portfolio

echo "✓ Sample data loaded."

# STEP 8: Final validation (see Section 11)
echo "✓ Proceed to Section 9 (Go-Live Checklist) and Section 11 (Post-Deployment Validation)."
```

### 8.2 Incremental Deployment Runbook (Post-v1.0 Updates)

For individual metadata changes after go-live:

```bash
# Deploy a single Apex class change
sf project deploy start \
  --metadata ApexClass:CaseEntitlementService \
  --metadata ApexClass:CaseTriggerHandlerTest \
  --target-org sf-portfolio --wait 10

# Run targeted tests
sf apex run test \
  --class-names CaseTriggerHandlerTest \
  --result-format human \
  --code-coverage \
  --target-org sf-portfolio --wait 10

# Deploy a single flow change
sf project deploy start \
  --metadata Flow:Case_BeforeSave_SetEntitlement \
  --target-org sf-portfolio --wait 10
```

### 8.3 Scratch Org Development Runbook

Daily developer workflow:

```bash
# Morning: Create or open scratch org
sf org create scratch \
  --definition-file config/project-scratch-def.json \
  --alias catalyst-dev --duration-days 30 --set-default

# Deploy current branch to scratch org
sf project deploy start \
  --source-dir force-app/main/default \
  --target-org catalyst-dev --wait 20

# Run tests in scratch org
sf apex run test \
  --test-level RunLocalTests \
  --code-coverage \
  --target-org catalyst-dev --wait 20

# End of day: Pull any changes made via UI
sf project retrieve start \
  --target-org catalyst-dev

# Commit
git add force-app/
git commit -m "feat: describe what was built"

# End of feature: Delete scratch org
sf org delete scratch --target-org catalyst-dev --no-prompt
```

---

## 9. Go-Live Checklist

All items must be ticked before tagging `catalyst-v1.0`.

### 9.1 Functional Readiness

| # | Check | Owner | Status |
|---|---|---|---|
| 1 | All 15 regression test cases in MKT-TPQA-1.0 pass | QA | |
| 2 | All 3 UAT scenarios (Lead-to-Close, Case Lifecycle, Portal Journey) pass | QA | |
| 3 | No Critical or High severity defects open | QA | |
| 4 | Lead conversion gate enforced (Activity Count >= 3 required) | QA | |
| 5 | Case SLA entitlement assigned on creation for all 3 tiers | QA | |
| 6 | Omni-Channel routing distributes cases to correct queues | QA | |
| 7 | Portal data isolation confirmed — cross-account access blocked | QA | |
| 8 | Agentforce Aria responds correctly and refuses out-of-scope requests | QA | |
| 9 | Quote discount approval triggers at > 15% discount | QA | |
| 10 | Health Score calculates correctly for at least 5 test accounts | QA | |

### 9.2 Technical Readiness

| # | Check | Owner | Status |
|---|---|---|---|
| 11 | Apex test coverage >= 85% across all classes | Dev | |
| 12 | All PTS-2.x governor assertions pass (zero LimitException) | Dev | |
| 13 | All metadata committed to `vertical/marketing` branch — no uncommitted changes | Dev | |
| 14 | `sfdx-project.json` sourceApiVersion = 62.0 | Dev | |
| 15 | No hardcoded IDs in any Apex, Flow, or LWC component | Dev | |
| 16 | All LWC components use SLDS 2 design tokens — no hardcoded CSS values | Dev | |
| 17 | All flows have description fields completed | Dev | |
| 18 | Named Credentials authenticated and callouts verified in DE org | Dev | |

### 9.3 Performance Readiness

| # | Check | Owner | Status |
|---|---|---|---|
| 19 | PTS-1.x: All 5 page load tests < 3,000 ms average | QA | |
| 20 | PTS-3.1: Portal dashboard Lighthouse score >= 80 | QA | |
| 21 | PTS-3.x: LCP < 2.5 s on all portal pages tested | QA | |
| 22 | PTS-5.x: All reports and dashboards render < 10,000 ms | QA | |
| 23 | Baseline performance measurements recorded in MKT-PTS-1.0 Section 10.1 | QA | |

### 9.4 Documentation Readiness

| # | Check | Owner | Status |
|---|---|---|---|
| 24 | MKT-BRD-1.0 approved and committed to `projectDocs/` | Architect | ✅ |
| 25 | MKT-USAC-1.0 approved and committed | Architect | ✅ |
| 26 | MKT-TDD-1.0 approved and committed | Architect | ✅ |
| 27 | MKT-DD-1.0 approved and committed | Architect | ✅ |
| 28 | MKT-TPQA-1.0 approved and committed | Architect | ✅ |
| 29 | MKT-BDD-1.0 approved and committed | Architect | ✅ |
| 30 | MKT-DDT-1.0 approved and committed | Architect | ✅ |
| 31 | MKT-PTS-1.0 approved and committed | Architect | ✅ |
| 32 | MKT-DRP-1.0 (this document) approved and committed | Architect | ✅ |
| 33 | CLAUDE.md updated with all doc statuses ✅ Complete | Architect | |
| 34 | README.md completed for portfolio-facing overview | Architect | |

### 9.5 Go-Live Sign-Off

| Role | Name | Signature | Date |
|---|---|---|---|
| Portfolio Architect | Josh Murdadrum | | |

---

## 10. Rollback Plan

### 10.1 Rollback Triggers

A rollback is required if any of the following occur post-deployment:

- Critical defect discovered post-go-live that cannot be patched within 24 hours
- Data corruption affecting more than 5 records
- `LimitException` in production during normal use
- Portal security breach (cross-account data exposure)
- Deployment failure that leaves org in partially deployed state

### 10.2 Rollback Strategy

**Portfolio context note:** The `sf-portfolio` Developer Edition org is a demo/portfolio org, not a live production system. "Rollback" in this context means restoring the org to a known-good state.

#### Option A — Revert Metadata Deployment

If the deployment introduced a regression, revert specific metadata:

```bash
# Identify the last known-good commit
git log --oneline -10

# Check out a previous version of a specific file
git checkout [previous-commit-hash] -- force-app/main/default/classes/CaseEntitlementService.cls

# Redeploy the reverted file
sf project deploy start \
  --metadata ApexClass:CaseEntitlementService \
  --target-org sf-portfolio --wait 10

# Run tests to confirm revert resolved issue
sf apex run test \
  --class-names CaseTriggerHandlerTest \
  --target-org sf-portfolio --wait 10
```

#### Option B — Full Metadata Rollback

If the deployment is severely broken:

```bash
# Identify the last stable tag
git tag -l

# Check out the previous stable state
git checkout [previous-stable-tag]

# Full redeploy from stable state
sf project deploy start \
  --source-dir force-app/main/default \
  --target-org sf-portfolio --wait 30
```

#### Option C — Org Refresh (Nuclear Option)

If the org is unrecoverable:

1. Document current org state (screenshots, metadata retrieve)
2. Contact Salesforce Support to reset Developer Edition org (if available)
3. Alternatively, create a new Developer Edition org and re-authenticate alias `sf-portfolio`
4. Execute full deployment runbook (Section 8.1) from `vertical/marketing` branch

### 10.3 Rollback Decision Tree

```
Defect discovered post-go-live
         │
         ▼
Is it a Critical/High severity defect?
    │                    │
   YES                   NO
    │                    │
    ▼                    ▼
Can it be patched    Add to backlog
in < 24 hours?       Continue demo
    │                use
   YES    NO
    │      │
    ▼      ▼
Apply   Execute
patch   Rollback
        Option A/B/C
```

---

## 11. Post-Deployment Validation

### 11.1 Smoke Test (15 minutes)

Run immediately after deployment before broader testing:

| # | Action | Expected Result |
|---|---|---|
| 1 | Log in as Sales Rep — navigate to Leads tab | Lead list loads without error |
| 2 | Create a new Lead with all required fields | Lead saved; owner assigned |
| 3 | Log in as Service Agent — navigate to Cases | Case queue visible in console |
| 4 | Create a new Case for an Enterprise account | Case created; entitlement assigned |
| 5 | Log in as Portal Customer — navigate to portal dashboard | Dashboard renders with data |
| 6 | Click the Aria chat button | Chat panel opens |
| 7 | Ask Aria: "What is the status of my latest case?" | Aria responds with case data |
| 8 | Log in as System Administrator — open Setup | Setup loads without error |
| 9 | Run Apex test: `sf apex run test --test-level RunLocalTests` | All tests pass |
| 10 | View an Account record — confirm Health_Score__c visible | Score displayed |

### 11.2 Full Functional Validation

Execute all 38 MKT-TPQA-1.0 test cases in sequence. Record results:

| Suite | Test Cases | Pass | Fail | Blocked |
|---|---|---|---|---|
| Sales Cloud | MKT-TC-SALES-001 to -012 | | | |
| Service Cloud | MKT-TC-SRVC-001 to -012 | | | |
| Experience Cloud | MKT-TC-EXP-001 to -010 | | | |
| NFR | MKT-TC-NFR-001 to -006 | | | |
| **Total** | **38** | | | |

**Acceptance criteria:** All 15 regression cases pass. All Critical test cases pass.

### 11.3 Performance Validation

Record results in PTS-1.0 baseline template:

| Suite | Tests | Pass | Notes |
|---|---|---|---|
| PTS-1 (Page Load) | 5 | | |
| PTS-2 (Apex Governors) | 5 | | |
| PTS-3 (LWR Vitals) | 4 | | |
| PTS-4 (Integration) | 3 | | |
| PTS-5 (Reports) | 3 | | |
| PTS-6 (Bulk) | 3 | | |

### 11.4 Post-Deployment Monitoring (First 48 Hours)

| Monitor | Method | Frequency |
|---|---|---|
| Apex debug logs | Setup > Debug Logs | Check after each demo session |
| Lightning Usage App | Setup > Lightning Usage App | Daily |
| Email logs (for survey emails) | Setup > Email Log Files | Daily |
| Error Platform Events | Query Integration_Error__e | After any integration test |

---

## 12. Change Management and Communication

### 12.1 Stakeholder Communication (Portfolio Context)

| Audience | Communication | Timing |
|---|---|---|
| Portfolio reviewers (recruiters) | README.md updated with demo instructions | At go-live |
| Hiring managers | Shared login credentials issued via email | Post go-live |
| GitHub audience | CLAUDE.md updated; all SDLC docs committed | At go-live |

### 12.2 Demo Org Maintenance

| Activity | Frequency | Action |
|---|---|---|
| Data refresh | Monthly | Re-run sample data load scripts |
| Scratch org cleanup | After each dev cycle | `sf org delete scratch` |
| DE org health check | Monthly | Run smoke test (Section 11.1) |
| Dependency updates | Quarterly | Review SF CLI and API version updates |

### 12.3 Post Go-Live Backlog

Issues and enhancements discovered during go-live that are non-blocking:

| ID | Description | Severity | Planned Resolution |
|---|---|---|---|
| POST-001 | Placeholder: document issues here | Medium | Next sprint |

---

## 13. CI/CD Readiness (Post v1.0)

CI/CD pipelines are intentionally deferred until `main` is tagged `v1.0`. This section documents the planned automation to be activated post-tagging.

See `projectDocs/CICD_ADDENDUM.md` for full workflow specifications.

### 13.1 Planned GitHub Actions Workflows

| Workflow | Trigger | Purpose |
|---|---|---|
| Workflow 1 — PR Validation | Pull Request opened to `develop` | Run Apex tests, static analysis, metadata validate |
| Workflow 2 — Develop Integration | Push to `develop` | Full deploy to scratch org, run all test classes |
| Workflow 3 — Main Protection | Pull Request opened to `main` | Reject vertical branch PRs; enforce core-layer-only |
| Workflow 4 — Vertical Drift Check | Scheduled weekly | Alert if vertical branch diverges significantly from main |

### 13.2 JWT Authentication for CI

```yaml
# Planned: .github/workflows/pr-validation.yml (excerpt)
- name: Authenticate to Salesforce DE Org
  run: |
    sf org login jwt \
      --client-id ${{ secrets.SF_CLIENT_ID }} \
      --jwt-key-file server.key \
      --username ${{ secrets.SF_USERNAME }} \
      --alias sf-portfolio-ci
```

**Prerequisites (post v1.0):**
- Connected App created in DE org with JWT bearer flow enabled
- Server private key stored as GitHub secret `SF_PRIVATE_KEY`
- Client ID stored as GitHub secret `SF_CLIENT_ID`
- Org username stored as GitHub secret `SF_USERNAME`

### 13.3 Activation Criteria

CI/CD workflows activate when ALL of the following are true:
1. `main` branch is tagged `v1.0`
2. Connected App for JWT auth created in DE org
3. GitHub secrets configured
4. All 4 workflow YAML files committed to `.github/workflows/`

---

## 14. Traceability Matrix

| Phase | Action | Source Requirement | Validation Artefact |
|---|---|---|---|
| 1 — Foundation | Deploy custom objects | MKT-TDD-1.0 Section 2 | MKT-TPQA-1.0 all suites |
| 1 — Foundation | Configure OWD + security model | MKT-TDD-1.0 Section 4 | MKT-TC-EXP-007, MKT-TC-EXP-008 |
| 2 — Automation | Deploy Apex trigger framework | MKT-TDD-1.0 Section 7 | PTS-2.1 through PTS-2.5 |
| 2 — Automation | Deploy flows | MKT-TDD-1.0 Section 6 | MKT-TC-SALES-*, MKT-TC-SRVC-* |
| 2 — Automation | Configure Entitlement Processes | MKT-REQ-SRVC-004 | MKT-TC-SRVC-003, MKT-TC-SRVC-004 |
| 2 — Automation | Configure Omni-Channel routing | MKT-REQ-SRVC-005 | MKT-TC-SRVC-005, MKT-TC-SRVC-006 |
| 3 — UI Layer | Deploy LWC components | MKT-TDD-1.0 Section 8 | MKT-TC-SALES-*, PTS-1.x |
| 3 — UI Layer | Deploy reports and dashboards | MKT-REQ-SALES-009, MKT-REQ-SRVC-012 | PTS-5.1, PTS-5.2, PTS-5.3 |
| 4 — Experience Cloud | Deploy portal and LWR components | MKT-REQ-EXP-001 through EXP-010 | MKT-TC-EXP-001 through EXP-010 |
| 4 — Experience Cloud | Configure Agentforce Aria | MKT-REQ-EXP-012 through EXP-015 | MKT-TC-EXP-009, MKT-TC-EXP-010 |
| 4 — Experience Cloud | Configure Named Credentials | MKT-TDD-1.0 Section 10 | PTS-4.1, PTS-4.2, PTS-4.3 |
| 5 — Data & Validation | Load sample data | MKT-DD-1.0 Section 7 | All functional test suites |
| 5 — Data & Validation | Execute full test suite | MKT-TPQA-1.0 | MKT-TPQA-1.0 regression suite |
| 6 — Go-Live | Tag catalyst-v1.0 | Go-live checklist Section 9 | All go-live checklist items ✅ |

---

*End of MKT-DRP-1.0 — Deployment & Release Plan*

*Document Status: Complete*
*All SDLC documents for Catalyst Marketing Technologies v1.0 are now complete.*
*Next step: Active metadata build — Phase A.2 Core Object Model in scratch org.*
