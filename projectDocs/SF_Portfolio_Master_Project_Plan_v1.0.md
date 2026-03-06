

**SALESFORCE PORTFOLIO**

**FRAMEWORK PROJECT**

**MASTER PROJECT PLAN**

Version 1.0  |  2025

*Confidential — Portfolio Use*

| Document Type | Master Project Plan |
| :---- | :---- |
| **Owner** | Portfolio Developer |
| **Status** | Active — Living Document |
| **Clouds In Scope** | Sales Cloud · Service Cloud · Experience Cloud |
| **Technology Standards** | SLDS 2 · LWR · Agentforce · SFDX \+ Git |

# **Table of Contents**

# **1\. Project Vision & Strategic Goals**

This project establishes a professional-grade Salesforce portfolio framework built to modern standards, designed for use in job applications, technical interviews, and skills demonstration across multiple industry verticals.

## **1.1 The Core Problem This Solves**

Most Salesforce portfolios are limited to a single generic demo org with basic configuration. This framework takes a fundamentally different approach: it builds one rigorously engineered master template org, then systematically clones and verticalises it for each target industry. The result is a portfolio that demonstrates both technical depth and real-world consulting methodology.

## **1.2 Strategic Goals**

* Demonstrate hands-on competency across Sales Cloud, Service Cloud, and Experience Cloud

* Showcase cutting-edge capabilities: SLDS 2, Lightning Web Runtime, and Agentforce

* Produce a full SDLC documentation suite that signals professional maturity

* Enable rapid deployment of new industry-specific org profiles as targeting evolves

* Surface all work via a public portfolio Experience Cloud site with an Agentforce recruiter assistant

## **1.3 Positioning Statement**

*This portfolio demonstrates not just Salesforce configuration ability, but the full professional skill set of a consultant: requirements gathering, technical design, quality assurance, data modelling, automation architecture, and structured delivery. Each industry vertical is a self-contained proof of adaptability.*

# **2\. The Org Profile Framework Architecture**

The framework is structured as a single Master Template Foundation (MTF) from which all industry-specific profiles are derived. This mirrors the accelerator methodology used by leading Salesforce implementation partners.

## **2.1 Framework Layers**

| Layer | Component | Description |
| :---- | :---- | :---- |
| **Core Layer** | Object Model | Standard \+ custom objects, relationships, record types |
|  | Security Architecture | Profiles, permission sets, sharing rules, OWD |
|  | Automation Library | Flow templates, validation rules, Apex triggers |
|  | LWC Component Library | Reusable SLDS 2 components used across all verticals |
|  | Dashboard & Report Framework | Standard layout templates, parameterised report types |
| **Vertical Layer** | Industry Terminology | Picklist values, field labels, object naming conventions |
|  | Sample Data Sets | Realistic, industry-appropriate data loaded per vertical |
|  | Scenario Narrative | Fictional company, personas, business processes |
|  | SDLC Document Suite | Full BRD, TDD, test plans, ERD — generated per vertical |
| **Presentation Layer** | Experience Cloud Site | LWR-based public portfolio site, SLDS 2 branded |
|  | Meta-Portfolio Agent | Agentforce agent answering recruiter questions about all verticals |
|  | Per-Industry Agent | Agentforce agent acting as the fictional company's assistant |

## **2.2 Industry Verticals Planned**

| Priority | Vertical | Fictional Company | Key Differentiator |
| :---- | :---- | :---- | :---- |
| **1 — Baseline** | Marketing & Media | TBD during BRD phase | Full-featured reference build |
| 2 | Environmental / Clean Tech | TBD | Field service, asset management |
| 3 | GIS / Geospatial | TBD | Mapping integrations, location data |
| 4 | Maritime | TBD | Fleet, vessel, and voyage tracking |
| 5 | Education | TBD | Education Cloud patterns, student lifecycle |
| 6 | Government & Defense | TBD | Compliance, security model, FedRAMP context |
| 7 | Silicon Valley Startup | TBD | Rapid iteration, PLG motion, Slack integration |

*Note: Fictional company names, personas, and scenarios for each vertical will be defined as part of that vertical's BRD. The Baseline (Marketing) BRD will be the first document produced after this Master Plan is ratified.*

# **3\. Technology Stack & Standards**

All components of this portfolio are built to the latest available Salesforce standards as of the project start date. No legacy patterns are used.

## **3.1 Platform Standards**

| Technology | Version / Standard | Usage in This Project |
| :---- | :---- | :---- |
| Salesforce Lightning Design System | SLDS 2 (latest) | All LWC components built with SLDS 2 design tokens and updated component primitives |
| Lightning Web Components | LWC (current) | Primary UI development framework for all custom pages and components |
| Experience Cloud Runtime | Lightning Web Runtime (LWR) | All Experience Cloud sites built on LWR, not legacy Aura Builder |
| Agentforce | Einstein AI Platform (latest) | Meta-portfolio recruiter agent \+ per-vertical company agents |
| Salesforce DX | SFDX (latest CLI) | Source-driven development; all metadata in version control |
| Version Control | Git with feature branching | One branch per industry vertical, main branch \= master template |
| Apex | API v62.0+ | Triggers, services, test classes — all with minimum 85% coverage |
| Flow | Flow Builder (current) | Screen flows, auto-launched flows, scheduled flows per vertical need |
| Data Loader / SFDX | SFDX Data Commands | Seed data management and environment replication |

## **3.2 Agentforce Architecture**

Two distinct Agentforce agents are configured per the scope decision. Their architectures are defined as follows:

### **3.2.1 Meta-Portfolio Agent — "Ask About My Work"**

* Lives on the public Experience Cloud portfolio site

* Grounded in Knowledge Articles describing each org vertical, skills demonstrated, and certification status

* Configured with a custom Agent Topic: Portfolio Enquiry

* Custom Actions: GetVerticalSummary, GetSkillList, GetContactInfo, ScheduleInterview

* System Prompt persona: professional, knowledgeable, concise — speaks on behalf of the developer

* Available to any recruiter who visits the public site without logging in

### **3.2.2 Per-Industry Agent — Fictional Company Assistant**

* One agent per vertical, deployed within that vertical's Experience Cloud site

* Acts as the fictional company's internal or customer-facing AI assistant

* Grounded in that vertical's Knowledge Base and Salesforce object data via Apex Actions

* Demonstrates domain-specific prompt engineering and Agent Topic design

* Shows a recruiter how Agentforce would function in a real client context

# **4\. Git Branching & SFDX Strategy**

The project uses a structured Git branching model that mirrors professional Salesforce DX development practices, enabling clean separation between the master template and each industry vertical.

## **4.1 Branch Structure**

| Branch | Type | Purpose |
| :---- | :---- | :---- |
| **main** | Protected | The Master Template Foundation — stable, deployable at all times |
| **develop** | Integration | Integration branch; feature work merges here before promoting to main |
| **vertical/marketing** | Vertical | Marketing industry org — the first vertical; derived from main |
| **vertical/environmental** | Vertical | Environmental / Clean Tech vertical |
| **vertical/gis** | Vertical | GIS / Geospatial vertical |
| **vertical/maritime** | Vertical | Maritime vertical |
| **vertical/education** | Vertical | Education vertical |
| **vertical/gov-defense** | Vertical | Government & Defense vertical |
| **vertical/startup** | Vertical | Silicon Valley Startup vertical |
| **feature/\*** | Feature | Short-lived; branched from develop, merged back via PR |
| **hotfix/\*** | Hotfix | Critical fixes to main; merged to both main and develop |

## **4.2 Vertical Branch Creation Workflow**

When a new vertical is ready to be initialised, the following process is followed:

1. Ensure main is stable and all core layer components are committed

2. Create vertical branch: git checkout \-b vertical/\<name\> main

3. Update sfdx-project.json with vertical-specific package directories

4. Run the Vertical Initialisation Script to rename/relabel industry terminology

5. Load vertical-specific sample data via SFDX data commands

6. Update Experience Cloud site theme and branding tokens

7. Configure per-vertical Agentforce agent and knowledge articles

8. Execute full test suite — all tests must pass before branch is considered stable

## **4.3 Keeping Verticals in Sync with the Core Layer**

When improvements are made to the master template (main branch), they are propagated to vertical branches via a controlled merge process:

* Core-layer changes are tagged with the label core-update in the commit message

* A monthly sync schedule merges main into each vertical branch

* Conflicts are resolved in the vertical branch; vertical customisations are never merged back to main

* All merges go through a pull request with a checklist confirming no vertical-specific data contaminates the core

# **5\. SDLC Document Registry**

Each industry vertical receives a complete, independently generated SDLC documentation suite. The following table defines every document type, its purpose, and its generation approach.

| \# | Document | Abbreviation | Phase | Generation |
| :---- | :---- | :---- | :---- | :---- |
| 1 | **Business Requirements Document** | BRD | Phase 1 — Business | Full per vertical |
| 2 | **User Stories & Acceptance Criteria** | USAC | Phase 1 — Business | Full per vertical |
| 3 | **Technical Design Document** | TDD | Phase 2 — Technical | Full per vertical |
| 4 | **Data Dictionary & ERD** | DD/ERD | Phase 2 — Technical | Full per vertical |
| 5 | **Test Plan & QA Scripts** | TPQA | Phase 3 — Quality | Full per vertical |
| 6 | **BDD Testing Examples** | BDD | Phase 3 — Quality | Full per vertical |
| 7 | **Data-Driven Testing Examples** | DDT | Phase 3 — Quality | Full per vertical |
| 8 | **Performance Testing Suite** | PTS | Phase 3 — Quality | Configurable template |
| 9 | **Deployment & Release Plan** | DRP | Phase 4 — Delivery | Full per vertical |

## **5.1 Document ID Convention**

All documents are assigned an ID using the convention: \[VERTICAL-CODE\]-\[DOC-ABBR\]-\[VERSION\]

* Example: MKT-BRD-1.0 \= Marketing vertical, Business Requirements Document, version 1.0

* Example: MAR-TDD-2.1 \= Maritime vertical, Technical Design Document, version 2.1

* All document IDs are referenced consistently across related documents (e.g. user stories reference BRD requirement IDs)

## **5.2 Requirement ID Convention**

Functional requirements within each BRD follow the format: \[VERTICAL-CODE\]-REQ-\[MODULE\]-\[NUMBER\]

* Example: MKT-REQ-SALES-001 \= Marketing vertical, Sales Cloud module, requirement 001

* User stories reference their parent requirement: MKT-US-SALES-001 traces to MKT-REQ-SALES-001

* Test cases reference their parent user story: MKT-TC-SALES-001 traces to MKT-US-SALES-001

*This traceability chain is a deliberate portfolio signal — it demonstrates understanding of enterprise SDLC governance.*

# **6\. Phased Delivery Plan**

The project is delivered in two macro tracks that run in parallel once the master template is stable: the Core Build track and the Vertical Rollout track.

## **6.1 Track A — Master Template Foundation (MTF)**

| Phase | Name | Deliverables | Gate |
| :---- | :---- | :---- | :---- |
| **A.1** | **Project Setup** | GitHub repo, SFDX project structure, scratch org config, branch protection rules | Repo live |
| **A.2** | **Core Object Model** | Custom objects, fields, relationships, record types, page layouts for all 3 clouds | ERD signed off |
| **A.3** | **Security Architecture** | Profiles, permission sets, OWD, sharing rules, role hierarchy | Security review |
| **A.4** | **Automation Library** | Core flows, validation rules, Apex trigger framework, test classes | 85% coverage |
| **A.5** | **LWC Component Library** | SLDS 2 components: header, dashboard widgets, timeline, case card, record panels | SLDS 2 audit |
| **A.6** | **Reports & Dashboards** | Standard dashboard templates, parameterised reports for Sales, Service, Experience | Demo ready |
| **A.7** | **Experience Cloud Site** | LWR site structure, navigation, branding tokens, login/self-reg flows | Site published |
| **A.8** | **Agentforce Meta-Agent** | Portfolio recruiter agent, knowledge articles, actions, system prompt | Agent tested |
| **A.9** | **MTF Stabilisation** | Full test suite pass, documentation of core layer, baseline snapshot tagged in Git | v1.0 tag |

## **6.2 Track B — Vertical Rollout (per industry)**

| Phase | Name | Deliverables | Gate |
| :---- | :---- | :---- | :---- |
| **B.1** | **SDLC Phase 1: Business** | BRD, User Stories & Acceptance Criteria, fictional company brief | BRD approved |
| **B.2** | **SDLC Phase 2: Technical** | TDD, Data Dictionary, ERD (vertical overlay), vertical branch initialised | TDD reviewed |
| **B.3** | **Vertical Configuration** | Record types, picklists, page layouts, terminology, branding tokens updated | Demo run |
| **B.4** | **Sample Data Load** | Realistic data set loaded via SFDX; minimum 50 Accounts, 200 Contacts | Data verified |
| **B.5** | **Per-Vertical Agent** | Agentforce agent configured, knowledge base populated, agent actions tested | Agent tested |
| **B.6** | **SDLC Phase 3: Quality** | Test plan, BDD examples, data-driven tests, performance testing suite configured | All tests pass |
| **B.7** | **SDLC Phase 4: Delivery** | Deployment & release plan, environment strategy documented | DRP complete |
| **B.8** | **Portfolio Publish** | Screenshots, case study narrative, Experience Cloud site updated | Published |

# **7\. Salesforce Org Architecture**

## **7.1 Cloud Coverage Summary**

| Cloud | Core Features Demonstrated | Advanced Features Demonstrated |
| :---- | :---- | :---- |
| **Sales Cloud** | Leads, Contacts, Accounts, Opportunities, Activities, Quotes, Products, Price Books, Forecasting | Territory Management, Einstein Activity Capture, Opportunity Scoring, custom Sales Process per vertical |
| **Service Cloud** | Cases, Case Teams, Entitlements, SLAs, Knowledge, Macros, Email-to-Case, Live Chat | Omni-Channel routing, Einstein Case Classification, Service Console custom components, Escalation flows |
| **Experience Cloud** | LWR Site, Self-Registration, Community login, Knowledge portal, Case deflection, Member dashboard | Agentforce embedded chat, custom LWC components in LWR, headless CMS content, partner portal patterns |

## **7.2 Custom Object Framework**

The following custom objects form the backbone of the master template. Each vertical may add to this list but does not remove from it.

| Object API Name | Relates To | Purpose |
| :---- | :---- | :---- |
| **Project\_\_c** | Account, Opportunity | Tracks active engagements or implementations; used in all verticals |
| **Service\_Region\_\_c** | Account | Geographic or logical service region for territory and routing |
| **Asset\_Item\_\_c** | Account, Contact | Tracks physical or digital assets owned by a customer |
| **Feedback\_Survey\_\_c** | Contact, Case | Structured feedback linked to service interactions or onboarding |
| **Portal\_User\_Group\_\_c** | Contact | Groups Experience Cloud users for content targeting and access |

## **7.3 User Roles & Personas**

The following user personas are instantiated in every vertical. Each has a dedicated user account, profile, permission set, and sample data set.

| Persona | Profile | Scenario Role |
| :---- | :---- | :---- |
| **Sales Rep** | Sales User | Manages the full sales lifecycle from lead to closed-won opportunity |
| **Sales Manager** | Sales Manager | Manages team pipeline, forecasts, and coaches reps via dashboards |
| **Service Agent** | Service User | Handles inbound cases via console, resolves using knowledge articles |
| **Service Manager** | Service Manager | Monitors SLA compliance, manages queues and escalation paths |
| **Sys Admin** | System Administrator | Configures the org; used for all setup and deployment activities |
| **Portal Customer** | Customer Community Plus | Authenticated Experience Cloud user; submits cases, views dashboards |
| **Portal Guest** | (Guest User) | Unauthenticated visitor to public-facing Experience Cloud pages |

# **8\. Testing Strategy Overview**

The portfolio employs a multi-layered testing strategy designed to demonstrate professional QA competence. Each testing type produces its own document artifact within the SDLC suite.

| Testing Type | Tooling / Format | Document Artifact | What It Demonstrates |
| :---- | :---- | :---- | :---- |
| **Manual QA** | Test Plan (Excel-format scripts) | TPQA | Systematic scenario coverage, acceptance criteria validation |
| **BDD** | Gherkin / Cucumber-style scenarios | BDD | Requirements traceability, collaborative test authoring, readable specs |
| **Data-Driven Testing** | Parameterised test tables \+ CSV sets | DDT | Boundary testing, equivalence classes, negative testing patterns |
| **Apex Unit Tests** | Salesforce Apex test classes | TDD | Code quality, 85%+ coverage, mock data, assert patterns |
| **Performance Testing** | Configurable suite (volume \+ load) | PTS | Scalability thinking, data volume strategy, governor limit awareness |

## **8.1 Performance Testing Suite — Configurable Parameters**

The Performance Testing Suite (PTS) is delivered as a user-configurable template with the following adjustable parameters:

* Data Volume Profile: Small (1K records), Medium (50K records), Large (500K records)

* Concurrent User Simulation: 1, 10, 50, 100 simulated users

* Test Scenario Selection: Report execution, Flow trigger volume, API bulk upsert, Page load timing

* Governor Limit Thresholds: Configurable warn/fail thresholds per limit category

* Environment Target: Scratch Org, Developer Org, Sandbox (affects baseline expectations)

*The PTS template includes pre-written test scenarios, a results capture table, and a findings summary section that can be completed and included in the SDLC doc suite as evidence of performance due diligence.*

# **9\. Immediate Next Steps**

The following actions initiate Track A of the project. They are sequenced to unblock subsequent work as quickly as possible.

| \# | Action | Owner | Dependency |
| :---- | :---- | :---- | :---- |
| **1** | Sign off on this Master Project Plan (ratify scope, tech stack, vertical list) | Portfolio Developer | None |
| **2** | Name the Marketing baseline company (confirm fictional name, industry sub-focus, and tagline) | Portfolio Developer | Step 1 |
| **3** | Generate Marketing Vertical BRD (MKT-BRD-1.0) — first SDLC document | Claude \+ Developer | Step 2 |
| **4** | Generate Marketing Vertical User Stories (MKT-USAC-1.0) | Claude \+ Developer | Step 3 |
| **5** | Set up GitHub repo with SFDX project structure and branch protection | Portfolio Developer | Step 1 |
| **6** | Provision Salesforce Developer Org and connect to SFDX | Portfolio Developer | Step 5 |
| **7** | Generate Marketing Vertical TDD (MKT-TDD-1.0) and Data Dictionary (MKT-DD-1.0) | Claude \+ Developer | Step 4 |
| **8** | Begin Phase A.2: Core Object Model build in scratch org | Portfolio Developer | Step 7 |

## **9.1 How Claude Supports This Project**

Claude will generate each SDLC document on request, using the framework defined in this plan. For every new vertical, the following will be produced in order:

* BRD — full functional requirements for the fictional company scenario

* User Stories — full backlog in Gherkin-format acceptance criteria

* TDD — object model, automation design, security model, integration points

* Data Dictionary & ERD — all objects, fields, types, relationships

* Test Plan & QA Scripts — scenario-level manual test cases

* BDD Testing Examples — Gherkin scenarios mapped to org features

* Data-Driven Testing Examples — parameterised test tables with sample data

* Performance Testing Suite — configured template for the vertical

* Deployment & Release Plan — environment strategy and go-live checklist

*All documents reference requirement IDs consistently for cross-document traceability. Each document is delivered as a formatted Word file (.docx) ready for portfolio inclusion.*