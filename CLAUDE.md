# CLAUDE.md — Salesforce Portfolio Framework
> This file is injected automatically into every Claude Code session.
> It defines the project's permanent context. Never delete or compact this knowledge.

---

## What This Project Is

A professional Salesforce portfolio framework built for job applications across multiple industries. It consists of one **Master Template Foundation (MTF)** org that is cloned and verticalised into industry-specific profiles.

This is not a throwaway demo. Every decision should reflect real-world Salesforce consulting standards.

---

## Repository

- **GitHub Org:** JoshUX-SFPortfolio
- **Repo:** sf-catalyst-portfolio
- **Visibility:** Public — this is a portfolio artefact

---

## Current Status

**Active phase:** B.1 — Catalyst Vertical: SDLC Phase 1 (Business)
**Next:** B.2 — Catalyst Vertical: SDLC Phase 2 (Technical)

**Track A — Master Template Foundation: COMPLETE (`develop` tagged `v1.0`)**

**Completed phases:**

- A.1 Project Setup ✅
- A.2 Core Object Model ✅ — PR #3 merged to `develop`
- A.3 Security Model ✅ — PR #4 merged to `develop`
- A.4 Automation Library ✅ — PR #5 merged to `develop`
- A.5 LWC Components ✅ — PR #6 merged to `develop`
- A.6 Reports & Dashboards ✅ — PR #7 merged to `develop`
- A.7 Experience Cloud ✅ — PR #8 merged to `develop`
- A.8 Agentforce ✅ — PR #9 merged to `develop`
- A.9 MTF Stabilisation ✅ — PR #10 merged to `develop`, tagged `v1.0`

**Pinned for follow-up project (do not suggest):**
- Figma design / design system
- React / Next.js frontend
- Custom headless dashboard
- SF-PORTFOLIO-UX-1.0 implementation

The Experience Cloud LWR site (Phase A.7) built with SLDS 2 
is the portfolio presentation layer for this project.

---

## Branch Strategy

| Branch | Purpose |
|---|---|
| `main` | Master Template Foundation — always deployable, protected |
| `develop` | Integration branch — PRs required, no direct pushes |
| `vertical/marketing` | Catalyst Marketing Technologies (first vertical, active) |
| `vertical/environmental` | Future |
| `vertical/gis` | Future |
| `vertical/maritime` | Future |
| `vertical/education` | Future |
| `vertical/gov-defense` | Future |
| `vertical/startup` | Future |

**Rule:** Vertical branches receive from `main`. They never merge back to `main`. Core layer changes are tagged `[core-update]` in commit messages.

---

## Salesforce Org

- **Org Type:** Developer Edition (persistent demo/portfolio org)
- **Scratch Orgs:** Used for all active development — Dev Edition is the deploy target
- **Auth alias:** `sf-portfolio`
- **Clouds in scope:** Sales Cloud · Service Cloud · Experience Cloud

---

## Technology Standards — Non-Negotiable

| Technology | Standard |
|---|---|
| UI Components | SLDS 2 — always use updated design tokens and primitives |
| Experience Cloud | LWR (Lightning Web Runtime) only — no legacy Aura sites |
| AI | Agentforce — two agents per vertical (see Agents section) |
| CLI | SFDX (`sf` CLI) — all metadata source-tracked |
| Version Control | Git — SFDX project format, all metadata committed |
| Apex API Version | v62.0 or latest available |
| Test Coverage | Minimum 85% — meaningful assertions, test factory pattern |

---

## Active Vertical: Catalyst Marketing Technologies

**Document ID prefix:** `MKT-`  
**Company:** Catalyst Marketing Technologies, Inc.  
**Tagline:** Accelerate Every Campaign.  
**Type:** Series C B2B SaaS — marketing orchestration platform  
**HQ:** Austin, Texas  
**Employees:** ~280  

### The Catalyst Platform (product being sold)
| Module | Description |
|---|---|
| Campaign Intelligence | Multi-channel campaign planning and execution |
| Audience Studio | Segmentation and data enrichment |
| Attribution Engine | Multi-touch attribution and ROI dashboards |
| Content Hub | Digital asset management and personalisation |

### Key Stakeholders (fictional)
- **Marcus Chen** — CEO
- **Priya Sharma** — VP of Sales
- **Daniel Torres** — VP of Customer Success
- **Ben Wallace** — Revenue Ops Manager (primary process owner)
- **Sam Okafor** — IT Director

### Subscription Tiers (drive SLA and routing logic)
| Tier | First Response | Resolution |
|---|---|---|
| Starter | 8 business hours | 5 business days |
| Professional | 4 business hours | 2 business days |
| Enterprise | 1 business hour | 4 business hours |

---

## Requirement ID Conventions

All requirements, user stories, and test cases use traceable IDs:

```
Requirements:   MKT-REQ-[MODULE]-[NNN]    e.g. MKT-REQ-SALES-012
User Stories:   MKT-US-[MODULE]-[NNN]     e.g. MKT-US-SALES-012
Test Cases:     MKT-TC-[MODULE]-[NNN]     e.g. MKT-TC-SALES-012
Documents:      MKT-[DOCTYPE]-[VERSION]   e.g. MKT-BRD-1.0
```

Modules: `SALES` · `SRVC` · `EXP` · `NFR`

**Always maintain traceability.** A user story must reference its parent requirement. A test case must reference its parent user story.

---

## Custom Objects (Core Layer — present in all verticals)

| API Name | Relates To | Purpose |
|---|---|---|
| `Project__c` | Account, Opportunity | Active engagements |
| `Service_Region__c` | Account | Geographic service regions |
| `Asset_Item__c` | Account, Contact | Customer-owned assets |
| `Feedback_Survey__c` | Contact, Case | Post-interaction feedback |
| `Portal_User_Group__c` | Contact | Experience Cloud user grouping |

---

## User Personas (present in all verticals)

| Persona | Profile | Key Scenario |
|---|---|---|
| Sales Rep | Sales User | Full lead-to-close lifecycle |
| Sales Manager | Sales Manager | Pipeline, forecast, coaching |
| Service Agent | Service User | Case handling via console |
| Service Manager | Service Manager | SLA compliance, queue management |
| Sys Admin | System Administrator | All config and deployment |
| Portal Customer | Customer Community Plus | Authenticated Experience Cloud user |
| Portal Guest | Guest User | Public-facing Experience Cloud pages |

---

## Agentforce Agents

### 1. Meta-Portfolio Recruiter Agent (public portfolio site)
- **Name:** TBD
- **Location:** Public Experience Cloud LWR site
- **Purpose:** Answers recruiter questions about the portfolio without login
- **Agent Topic:** Portfolio Enquiry
- **Actions:** GetVerticalSummary · GetSkillList · GetContactInfo · ScheduleInterview
- **Audience:** Unauthenticated recruiters and hiring managers

### 2. Catalyst Client Assistant — "Aria" (per-vertical agent)
- **Name:** Aria
- **Location:** Catalyst Client Portal (authenticated Experience Cloud)
- **Purpose:** Client self-service assistant for the Catalyst portal
- **Agent Topic:** Client Self-Service
- **Actions:** SearchKnowledge · GetCaseStatus · GetOnboardingProgress · EscalateToAgent
- **Audience:** Authenticated Catalyst customers
- **Req IDs:** MKT-REQ-EXP-012 through MKT-REQ-EXP-015

---

## Portfolio-Level Documents

| Doc ID | Document | Status |
|---|---|---|
| SF-PORTFOLIO-UX-1.0 | UI/UX Specification — Portfolio Site, Dashboard, Case Studies | Draft — Figma Design Phase |

---

## SDLC Document Registry

| Doc ID | Document | Status |
|---|---|---|
| MKT-BRD-1.0 | Business Requirements Document | ✅ Complete |
| MKT-USAC-1.0 | User Stories & Acceptance Criteria | ✅ Complete |
| MKT-TDD-1.0 | Technical Design Document | ✅ Complete |
| MKT-DD-1.0 | Data Dictionary & ERD | ✅ Complete |
| MKT-TPQA-1.0 | Test Plan & QA Scripts | ✅ Complete |
| MKT-BDD-1.0 | BDD Testing Examples | ✅ Complete |
| MKT-DDT-1.0 | Data-Driven Testing Examples | ✅ Complete |
| MKT-PTS-1.0 | Performance Testing Suite | ✅ Complete |
| MKT-DRP-1.0 | Deployment & Release Plan | ✅ Complete |
| MKT-LL-1.0 | Lessons Learned — All Phases | Active — Living Document |

---

## CI/CD Status

| Item | Status |
|---|---|
| Branch protection (require PR, no direct push) | ✅ Active on `main` |
| PR template (`.github/PULL_REQUEST_TEMPLATE.md`) | ✅ Committed |
| GitHub Actions — Workflow 1 (PR Validation) | 🔲 Post MTF v1.0 |
| GitHub Actions — Workflow 2 (Develop Integration) | 🔲 Post MTF v1.0 |
| GitHub Actions — Workflow 3 (Main Protection) | 🔲 Post MTF v1.0 |
| GitHub Actions — Workflow 4 (Vertical Drift Check) | 🔲 Post MTF v1.0 |
| JWT Connected App for CI auth | 🔲 Post MTF v1.0 |

CI/CD is intentionally deferred until `main` is tagged `v1.0`. See `projectDocs/CICD_ADDENDUM.md`.

---

## Coding Standards

### Apex
- Use a trigger handler framework — one trigger per object, logic in handler class
- All triggers delegate to a service/handler class — no business logic in trigger body
- Test classes use a `TestDataFactory` — never create data inline
- All SOQL must be bulkified — no queries inside loops
- Use `with sharing` by default — explicitly use `without sharing` only when justified with a comment
- No hardcoded IDs, record type names, or org-specific values — use custom metadata or labels

### LWC
- All components use SLDS 2 design tokens — no hardcoded colours or spacing values
- Component names use kebab-case directories: `catalyst-case-card`, `catalyst-dashboard-widget`
- Public properties use `@api`, reactive state uses `@track` only when necessary
- Every component has a matching Jest test file

### Flow
- Flow API names use format: `[Object]_[Trigger]_[Purpose]` e.g. `Case_BeforeSave_SetEntitlement`
- All flows have a description field completed
- No hardcoded IDs in flows — use Get Records to look up by developer name

### Git Commits
- Format: `[type]: brief description` — e.g. `feat: add case entitlement assignment flow`
- Types: `feat` · `fix` · `refactor` · `test` · `docs` · `config` · `[core-update]`
- Commit after every logical unit of work — never commit a broken state to any branch

---

## Phase Close Checklist

Complete these steps in order at the end of every phase:

1. Deploy succeeds with 0 errors
2. Commit all phase files on the feature branch
3. Create PR — fill out the template fully (it is a portfolio artefact)
4. Squash-merge to `develop`, delete the feature branch
5. Update `CLAUDE.md` — active phase, completed phase list
6. Update `MEMORY.md` — phase status table, any new gotchas
7. Append to `projectDocs/MKT-LL-1.0_Catalyst.md` — one entry per resolved problem from this phase
8. Commit `CLAUDE.md` + `MEMORY.md` + `MKT-LL-1.0_Catalyst.md` together on `develop`:
   `docs: phase A.N close — update CLAUDE.md, MEMORY.md, lessons learned`

---

## Portfolio Access Tiers (recruiter engagement model)

| Tier | Access | What They See |
|---|---|---|
| Public | Experience Cloud URL (no login) | Portfolio site + Agentforce recruiter agent |
| Hiring Manager | Shared read-only login | Live org, dashboards, record pages |
| Interview | Screen share | Full walkthrough, controlled narrative |
| Technical | GitHub repo (public) | All source code, SFDX metadata, SDLC docs |

---

## What NOT To Do

- Do not use legacy Aura components — LWC only
- Do not build Experience Cloud sites on the Aura Builder runtime — LWR only
- Do not use `WidthType.PERCENTAGE` in docx generation — always use `DXA`
- Do not create metadata outside the SFDX project structure — everything must be retrievable
- Do not push directly to `main` or `develop` — PRs required
- Do not hardcode Salesforce IDs anywhere
- Do not modify core-layer metadata from a vertical branch
- Do not let a scratch org expire with uncommitted work

---

## Key Files & Paths

```
sf-catalyst-portfolio/
├── CLAUDE.md                                    ← you are here
├── README.md                                    ← portfolio-facing overview (pending)
├── package.json                                 ← Jest / LWC test config
├── sfdx-project.json                            ← SFDX project config
├── .github/
│   ├── PULL_REQUEST_TEMPLATE.md                 ← ✅ committed
│   └── workflows/                               ← CI/CD YAML (post v1.0)
├── config/
│   └── project-scratch-def.json                 ← scratch org definition
├── projectDocs/
│   ├── SF_Portfolio_Master_Project_Plan_v1.0.md
│   ├── SF-PORTFOLIO-UX-1.0.md                  ← portfolio site UI/UX spec (cross-vertical)
│   ├── A3_OWD_MANUAL_STEPS.md                  ← A.3 manual OWD config steps
│   ├── revisedProjectScope0306.md
│   ├── MKT-BRD-1.0_Catalyst.md
│   ├── MKT-USAC-1.0_Catalyst.md
│   ├── MKT-TDD-1.0_Catalyst.md
│   ├── MKT-DD-1.0_Catalyst.md
│   ├── MKT-TPQA-1.0_Catalyst.md
│   ├── MKT-BDD-1.0_Catalyst.md
│   ├── MKT-DDT-1.0_Catalyst.md
│   ├── MKT-PTS-1.0_Catalyst.md
│   ├── MKT-DRP-1.0_Catalyst.md
│   ├── MKT-LL-1.0_Catalyst.md                  ← lessons learned, all phases
│   ├── CICD_ADDENDUM.md
│   └── PULL_REQUEST_TEMPLATE.md
└── force-app/
    └── main/
        └── default/                             ← all SFDX metadata lives here
            ├── classes/                         ← Apex classes + test classes
            │   ├── TriggerHandler.cls           ← abstract trigger handler base
            │   ├── TestDataFactory.cls          ← shared test data factory
            │   ├── CaseService.cls              ← entitlement stamping, SLA tier
            │   ├── ProjectService.cls           ← status guard, default status
            │   ├── AssetItemService.cls
            │   ├── FeedbackSurveyService.cls    ← CSAT/NPS flag to case
            │   ├── [Object]TriggerHandler.cls   ← 6 handler classes (Case, Project, etc.)
            │   ├── CasePortalController.cls     ← portal: cases list, detail, submit
            │   ├── SubscriptionPortalController.cls
            │   ├── OnboardingPortalController.cls
            │   ├── KnowledgePortalController.cls ← dynamic SOSL/SOQL, licence-agnostic
            │   ├── AriaActionController.cls     ← Agentforce shared util (portal user ID)
            │   ├── AriaGetCaseStatus.cls        ← @InvocableMethod: open cases
            │   ├── AriaGetOnboardingProgress.cls ← @InvocableMethod: onboarding %
            │   ├── AriaEscalateToAgent.cls      ← @InvocableMethod: create Chat case
            │   └── *Test.cls                    ← test class per controller/service
            ├── triggers/                        ← 6 triggers (one per object)
            │   └── CaseTrigger, ProjectTrigger, AssetItemTrigger, ...
            ├── objects/                         ← custom + standard object metadata
            │   ├── Project__c/
            │   ├── Asset_Item__c/
            │   ├── Feedback_Survey__c/
            │   ├── Portal_User_Group__c/
            │   ├── Service_Region__c/
            │   ├── Domain_Exclusion__mdt/       ← custom metadata type
            │   └── Account/, Case/, Contact/, Lead/, Opportunity/
            ├── flows/
            │   └── Case_AfterSave_NotifyOnHighPriority.flow-meta.xml
            ├── lwc/                             ← 13 LWC components (all with Jest tests)
            │   ├── catalystClientDashboard/     ← container, 2-row grid
            │   ├── catalystCaseList/            ← datatable, filter, pagination
            │   ├── catalystCaseForm/            ← submit form + knowledge deflection
            │   ├── catalystCaseDetail/
            │   ├── catalystKnowledgeSearch/
            │   ├── catalystKnowledgeArticle/
            │   ├── catalystKnowledgeDeflection/
            │   ├── catalystSubscriptionTile/
            │   ├── catalystModuleList/
            │   ├── catalystOpenCasesTile/
            │   ├── catalystUsageHeatmap/
            │   ├── catalystOnboardingChecklist/
            │   └── catalystAriaLauncher/        ← FAB toggle, Agentforce embed
            ├── permissionsets/                  ← 7 permission sets
            │   ├── Sales_Core.permissionset-meta.xml
            │   ├── Sales_Manager_Extended.permissionset-meta.xml
            │   ├── Service_Core.permissionset-meta.xml
            │   ├── Service_Manager_Extended.permissionset-meta.xml
            │   ├── Portal_Standard_User.permissionset-meta.xml
            │   ├── Portal_Account_Admin.permissionset-meta.xml
            │   └── Agentforce_Service_User.permissionset-meta.xml
            ├── profiles/
            │   └── Admin.profile-meta.xml       ← FLS grants for custom Case fields
            ├── roles/                           ← 10 roles (CEO → SDR, Support tiers)
            ├── sharingRules/                    ← Account + Case sharing rules
            ├── customMetadata/                  ← Domain_Exclusion records (4)
            ├── settings/
            │   └── Communities.settings-meta.xml
            ├── networks/
            │   └── Catalyst Client Portal.network-meta.xml
            ├── digitalExperiences/
            │   └── site/Catalyst_Client_Portal1/ ← LWR Experience Cloud site bundle
            ├── dashboards/
            │   ├── Catalyst_Sales_Dashboards/   ← Sales Leadership, Rep Performance
            │   └── Catalyst_Service_Dashboards/ ← Service SLA
            ├── reports/
            │   ├── Catalyst_Sales_Reports/      ← 10 sales reports
            │   └── Catalyst_Service_Reports/    ← 5 service reports
            ├── genAiFunctions/                  ← Agentforce action definitions
            │   ├── GetCaseStatus/
            │   ├── GetOnboardingProgress/
            │   └── EscalateToAgent/
            ├── genAiPlugins/
            │   └── ClientSelfService.genAiPlugin-meta.xml  ← Topic: Client Self-Service
            ├── genAiPlanners/
            │   └── Aria.genAiPlanner-meta.xml   ← Aria agent (AiCopilot__ReAct)
            └── genAiPromptTemplates/
                └── AriaSystemPrompt.genAiPromptTemplate-meta.xml
```

---

*Update this file whenever a major decision is made, a document is completed, or a status changes. This is the single source of truth for Claude Code session context.*
