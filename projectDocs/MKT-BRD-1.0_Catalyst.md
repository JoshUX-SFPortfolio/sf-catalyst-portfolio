  
**CATALYST MARKETING TECHNOLOGIES, INC.**

*Accelerate Every Campaign.*

**BUSINESS REQUIREMENTS DOCUMENT**

**Salesforce CRM Implementation**

Sales Cloud  ·  Service Cloud  ·  Experience Cloud

| Document ID | MKT-BRD-1.0 |
| :---- | :---- |
| **Status** | DRAFT — Pending Stakeholder Review |
| **Version** | 1.0 |
| **Vertical** | Marketing — Baseline |
| **Company** | Catalyst Marketing Technologies, Inc. |
| **Prepared By** | Portfolio Developer |
| **Date** | 2025 |
| **Parent Doc** | SF Portfolio Framework — Master Project Plan v1.0 |

# **Table of Contents**

# **1\. Document Control**

## **1.1 Version History**

| Version | Date | Author | Changes | Status |
| :---- | :---- | :---- | :---- | :---- |
| 1.0 | 2025 | Portfolio Developer | Initial draft | Draft |

## **1.2 Reviewers & Approvers**

| Name / Role | Department | Review Type | Status |
| :---- | :---- | :---- | :---- |
| VP of Sales | Sales | Business Review | Pending |
| VP of Customer Success | Service | Business Review | Pending |
| Head of Product | Product | Technical Review | Pending |
| Salesforce Architect | IT / Delivery | Technical Review | Pending |

# **2\. Executive Summary**

This Business Requirements Document (BRD) defines the functional and non-functional requirements for the implementation of Salesforce CRM at Catalyst Marketing Technologies, Inc. (hereafter referred to as "Catalyst"). The implementation spans three Salesforce clouds — Sales Cloud, Service Cloud, and Experience Cloud — and will serve as the operational backbone for Catalyst's go-to-market, customer success, and client portal capabilities.

Catalyst is a Series C B2B SaaS company headquartered in Austin, Texas, providing a marketing orchestration platform to mid-market and enterprise clients. The company has experienced rapid growth since its founding and requires a scalable, unified CRM to replace fragmented point solutions currently in use across its Sales, Support, and Client Success functions.

*This document is the governing requirements artifact for the Catalyst Salesforce implementation. All downstream technical design documents (TDD), user stories, test plans, and deployment artefacts reference the requirement IDs defined herein. Any change to scope must be reflected in a revised version of this BRD before implementation proceeds.*

# **3\. Company Overview — Catalyst Marketing Technologies**

## **3.1 Company Profile**

| Legal Name | Catalyst Marketing Technologies, Inc. |
| :---- | :---- |
| **Trading Name** | Catalyst |
| **Tagline** | Accelerate Every Campaign. |
| **Founded** | 2018 |
| **Headquarters** | Austin, Texas, USA |
| **Offices** | Austin TX (HQ) · New York NY · London UK · Singapore |
| **Stage** | Series C — $72M raised |
| **Employees** | \~280 (as of implementation date) |
| **Industry** | Marketing Technology (MarTech) — B2B SaaS |
| **Target Market** | Mid-market and enterprise B2B companies (100–5,000 employees) |
| **Revenue Model** | Annual SaaS subscriptions \+ Professional Services (onboarding, training, strategic consulting) |

## **3.2 The Catalyst Platform — Product Overview**

Catalyst's core offering is the Catalyst Platform, a modular marketing orchestration solution sold as an annual SaaS subscription. Clients purchase a base licence and add modules based on their needs. Understanding the product is essential for interpreting the CRM requirements, as the Sales and Service processes are tightly coupled to the product's module structure.

| Module | Description | Typical Buyer |
| :---- | :---- | :---- |
| **Campaign Intelligence** | Multi-channel campaign planning, scheduling, and execution across email, paid, organic, and event channels | Marketing Ops Teams |
| **Audience Studio** | Audience segmentation, third-party data enrichment, and lookalike modelling | Demand Generation |
| **Attribution Engine** | Multi-touch attribution, pipeline influence reporting, and marketing ROI dashboards | CMO / Revenue Ops |
| **Content Hub** | Digital asset management, dynamic content personalisation, and A/B testing | Content / Brand Teams |

## **3.3 Current State — Systems & Pain Points**

Prior to this Salesforce implementation, Catalyst operates across several disconnected tools:

| Function | Current Tool | Pain Point |
| :---- | :---- | :---- |
| Sales Pipeline | HubSpot CRM | No formal stage governance; deal data inconsistent; no CPQ; no forecasting |
| Support / Cases | Zendesk | Disconnected from sales data; no account context on tickets; SLA tracking manual |
| Client Portal | Static SharePoint site | No self-service; clients email support for tasks that should be self-serve |
| Reporting | Spreadsheets / Looker | No single source of truth; reports built manually each week; no live dashboards |
| Contracts / CPQ | None (email \+ PDF) | Quote turnaround averages 4 days; no approval workflows; pricing errors common |

# **4\. Stakeholder Register**

The following stakeholders have been identified as having a material interest in or responsibility for the Salesforce CRM implementation at Catalyst.

| Stakeholder | Title | Department | Interest / Responsibility | Engagement |
| :---- | :---- | :---- | :---- | :---- |
| Marcus Chen | CEO | Executive | Strategic sponsor; revenue visibility | Inform |
| Priya Sharma | VP of Sales | Sales | Pipeline, forecasting, rep productivity | Consult / Approve |
| Daniel Torres | VP of Customer Success | Service | Case mgmt, SLAs, client health scores | Consult / Approve |
| Aiko Nakamura | Head of Product | Product | Module data in CRM, roadmap visibility | Consult |
| Ben Wallace | Revenue Ops Manager | Operations | Process design, data quality, reporting | Lead / Responsible |
| Sam Okafor | IT Director | IT | Integration, security, data governance | Consult |
| Leila Hassan | Sr. Account Executive | Sales | End-user rep; day-to-day sales workflows | Consult |
| Chris Park | Support Team Lead | Service | Case queue management, agent experience | Consult |

# **5\. Business Objectives**

The following objectives define the measurable outcomes this Salesforce implementation must support. Requirements in subsequent sections map back to these objectives.

| Obj. ID | Cloud | Objective | Success Metric |
| :---- | :---- | :---- | :---- |
| **OBJ-001** | Sales | Achieve a single, governed sales pipeline from lead to closed-won with defined stage criteria and exit conditions | 100% of open deals tracked in Salesforce; deal data completeness \>95% |
| **OBJ-002** | Sales | Reduce average quote turnaround time from 4 days to under 4 hours via CPQ and approval automation | Average quote generation time \<4 hours within 90 days of go-live |
| **OBJ-003** | Sales | Provide sales leadership with real-time pipeline and forecast visibility to support weekly revenue reviews | Weekly forecast report produced without manual intervention |
| **OBJ-004** | Service | Centralise all client support interactions with full account and subscription context available to agents | Zero cases requiring manual account lookup; all cases linked to Account on creation |
| **OBJ-005** | Service | Enforce SLA response and resolution targets by subscription tier, with automated escalation on breach | SLA compliance rate \>92% within 60 days of go-live |
| **OBJ-006** | Service | Reduce repeat case volume through a self-service knowledge base integrated into the client portal | 20% reduction in case volume attributable to self-service deflection within 6 months |
| **OBJ-007** | Exp. | Provide authenticated Catalyst clients with a branded self-service portal to manage their account, submit cases, and access knowledge | Portal adoption rate \>60% of active client contacts within 90 days |
| **OBJ-008** | Exp. | Surface product usage and subscription data in the portal to enable clients to self-serve onboarding and expansion requests | Onboarding task completion rate via portal \>75% |

# **6\. Project Scope**

## **6.1 In Scope**

* Sales Cloud: Lead management, contact and account management, opportunity lifecycle, products and price books, quotes (CPQ-lite via standard Salesforce CPQ), approval processes, activity tracking, pipeline dashboards and forecasting

* Service Cloud: Case management (email-to-case, web-to-case, portal case submission), case queues, SLA entitlements by subscription tier, knowledge article management, service console, Omni-Channel routing, escalation flows, service dashboards

* Experience Cloud: Authenticated client portal (LWR runtime), self-registration and login, knowledge article access, case submission and tracking, subscription and usage summary page, onboarding task checklist, Agentforce embedded assistant

* Agentforce: Per-vertical agent (Catalyst Client Assistant) configured within the Experience Cloud portal; meta-portfolio recruiter agent on the public portfolio site

* Security Model: Profiles, permission sets, role hierarchy, OWD, sharing rules for all three clouds

* Integrations: Bidirectional sync with Catalyst's billing system (mocked via Apex callout stub for portfolio purposes); read integration with Catalyst Platform usage API (mocked)

* Sample Data: Minimum 50 Accounts, 200 Contacts, 150 Opportunities, 300 Cases, 80 Knowledge Articles, 40 portal users across all SLA tiers

* SDLC Artefacts: Full document suite per the Master Project Plan registry

## **6.2 Out of Scope**

* Marketing Cloud: Excluded from this implementation phase

* Salesforce CPQ (full package): Standard Salesforce product/quote functionality used; full CPQ managed package out of scope for baseline vertical

* Revenue Cloud / Billing: Billing integration is stubbed only; no live Stripe or payment processing

* Salesforce Maps or Field Service Lightning: Not required for MarTech vertical

* Single Sign-On (SSO): Not configured for portfolio org; documented as a future-state requirement

* Data Migration: No migration from HubSpot or Zendesk; org seeded with synthetic sample data only

# **7\. Assumptions & Constraints**

## **7.1 Assumptions**

* A Salesforce Developer Edition org is available and provisioned prior to build commencement

* All stakeholders listed in Section 4 are fictional personas; decisions within this project are made by the portfolio developer

* The Catalyst Platform usage API is simulated via an Apex HTTP callout stub returning mock JSON; no live API connection is required

* Agentforce is available in the provisioned Developer Edition org; relevant Einstein features are enabled

* SLDS 2 components are available for use in the LWR Experience Cloud site

* All sample data is synthetically generated and contains no real personal information

* The org will not process real financial transactions; all billing data is fictitious

## **7.2 Constraints**

* Developer Edition org limits apply (5MB data storage, 200MB file storage); sample data volumes are calibrated accordingly

* Agentforce usage limits on Developer Edition orgs may restrict agent conversation volumes; documented as an environment constraint

* No managed packages beyond those freely available on the Developer Edition license may be installed

* All implementation work performed by a single developer; no parallel build team

# **8\. Functional Requirements — Sales Cloud**

The following requirements govern the Sales Cloud configuration for Catalyst. Requirements are prioritised using MoSCoW notation (Must Have, Should Have, Could Have).

## **8.1 Lead Management**

| Req. ID | Priority | Requirement | Rationale |
| :---- | :---- | :---- | :---- |
| **MKT-REQ-SALES-001** | **Must Have** | The system shall capture inbound leads via web-to-lead form with fields for First Name, Last Name, Company, Job Title, Email, Phone, Lead Source, and primary area of interest (mapped to Catalyst Platform modules) | Inbound lead capture is the entry point of the sales funnel; field completeness ensures routing accuracy |
| **MKT-REQ-SALES-002** | **Must Have** | The system shall automatically assign leads to the correct Sales Development Representative (SDR) based on lead source and geography using a round-robin assignment rule | Manual assignment creates response time delays of up to 24 hours in current state |
| **MKT-REQ-SALES-003** | **Must Have** | The system shall enforce a lead status picklist with values: New, Attempting Contact, Contacted, Qualified, Unqualified, Converted — with mandatory fields required before advancing to Qualified | Stage governance is absent in current HubSpot instance; data quality is a primary pain point |
| **MKT-REQ-SALES-004** | **Should Have** | The system shall surface a Lead Score field (integer, 0–100) populated via Salesforce Einstein Lead Scoring based on demographic and behavioural signals | Enables SDRs to prioritise outreach; directly supports OBJ-001 |
| **MKT-REQ-SALES-005** | **Must Have** | The system shall prevent a lead from being converted unless Lead Status is Qualified and a minimum of three logged activities (calls, emails, or meetings) are recorded | Prevents premature conversion; ensures pipeline quality |
| **MKT-REQ-SALES-006** | **Should Have** | The system shall send an automated follow-up task to the assigned SDR 48 hours after lead creation if no activity has been logged | Addresses current-state failure where new leads are not contacted within SLA |

## **8.2 Account & Contact Management**

| Req. ID | Priority | Requirement | Rationale |
| :---- | :---- | :---- | :---- |
| **MKT-REQ-SALES-007** | **Must Have** | The system shall support Account record types: Prospect, Customer, Partner, and Competitor — each with a tailored page layout and relevant fields surfaced per type | Different account types require different data and workflows |
| **MKT-REQ-SALES-008** | **Must Have** | Accounts shall store the following Catalyst-specific fields: Subscription Tier (Starter / Professional / Enterprise), Modules Purchased (multi-select), Contract Renewal Date, Annual Contract Value (ACV), and Primary Platform Contact | These fields are the CRM's product relationship data; critical for service routing and renewal workflows |
| **MKT-REQ-SALES-009** | **Must Have** | Contact records shall capture Role at Catalyst (Economic Buyer, Technical Evaluator, Champion, End User, Detractor) to support multi-threading strategies | Multi-threading is a standard enterprise sales technique; not tracked at all in current state |
| **MKT-REQ-SALES-010** | **Should Have** | The system shall display an Account Health Score on the Account record, calculated from: case volume (last 90 days), NPS score, product usage index (from mock API), and contract renewal proximity | Proactive account management; supports OBJ-003 and upsell identification |
| **MKT-REQ-SALES-011** | **Could Have** | The system shall flag duplicate Account records and prompt the user to merge when a new Account is created with a matching domain name | Data quality safeguard; prevents fragmented account history |

## **8.3 Opportunity Management**

| Req. ID | Priority | Requirement | Rationale |
| :---- | :---- | :---- | :---- |
| **MKT-REQ-SALES-012** | **Must Have** | The system shall enforce a Sales Process with stages: Discovery, Technical Evaluation, Proposal Sent, Negotiation, Closed Won, Closed Lost — with Probability and mandatory fields defined per stage | Stage discipline is the primary gap in current-state pipeline management |
| **MKT-REQ-SALES-013** | **Must Have** | Opportunities shall require the following fields before advancing past Proposal Sent: Modules Selected (relates to Products), Contract Length (12/24/36 months), Decision Date, and Named Economic Buyer (Contact lookup) | These fields are required for accurate forecasting and quote generation |
| **MKT-REQ-SALES-014** | **Must Have** | The system shall support opportunity line items linked to the Catalyst Platform product catalogue. Each module shall be a separate product with standard and discounted price books | Directly supports OBJ-002; enables quote generation from a governed product catalogue |
| **MKT-REQ-SALES-015** | **Must Have** | The system shall generate a PDF Quote from the opportunity, including Catalyst branding, line items with quantity/price/discount, total ACV, and contract terms. Quotes exceeding 15% discount shall require VP of Sales approval | Directly supports OBJ-002; approval workflow reduces unauthorised discounting |
| **MKT-REQ-SALES-016** | **Should Have** | Closed Lost opportunities shall require a mandatory Loss Reason picklist (Competitor — Named, Price, Timing, No Decision, Product Gap) and an optional Loss Notes text field | Loss data feeds competitive intelligence and informs product roadmap |
| **MKT-REQ-SALES-017** | **Should Have** | The system shall display an Opportunity Kanban view by default on the Opportunities list view for Account Executive profiles | Kanban view improves pipeline visibility for field reps |

## **8.4 Forecasting & Reporting**

| Req. ID | Priority | Requirement | Rationale |
| :---- | :---- | :---- | :---- |
| **MKT-REQ-SALES-018** | **Must Have** | The system shall enable Collaborative Forecasting by territory and by rep, rolling up to VP of Sales, with forecast categories mapped to Catalyst's sales stages | Directly supports OBJ-003; replaces current spreadsheet-based forecast |
| **MKT-REQ-SALES-019** | **Must Have** | A Sales Leadership Dashboard shall be available showing: pipeline by stage (funnel chart), forecast vs. quota by rep, average deal size by module, average sales cycle length, and win/loss rate by quarter | Supports OBJ-003; executive dashboard is currently non-existent |
| **MKT-REQ-SALES-020** | **Should Have** | A Rep Performance Dashboard shall show each AE their own quota attainment, open pipeline, activities this week vs. goal, and next 30-day renewal risk accounts | Promotes self-management and reduces need for 1:1 data reviews |

# **9\. Functional Requirements — Service Cloud**

The following requirements govern the Service Cloud configuration for Catalyst's Customer Success and Technical Support functions.

## **9.1 Case Management**

| Req. ID | Priority | Requirement | Rationale |
| :---- | :---- | :---- | :---- |
| **MKT-REQ-SRVC-001** | **Must Have** | The system shall support case creation via four channels: Email-to-Case (support@catalyst.io), Web-to-Case (portal form), Experience Cloud portal submission, and manual agent creation | Multi-channel intake mirrors current client behaviour; consolidation into one platform supports OBJ-004 |
| **MKT-REQ-SRVC-002** | **Must Have** | Cases shall be automatically linked to an Account upon creation by matching the submitter's email domain to Account records. Where no match is found, the case shall be flagged for manual review | Auto-linking to Account is the primary functional gap vs. current Zendesk implementation |
| **MKT-REQ-SRVC-003** | **Must Have** | Case record types shall include: Technical Support, Billing Enquiry, Onboarding Request, Feature Request, and General Enquiry — each with a tailored page layout | Different case types require different fields, workflows, and routing logic |
| **MKT-REQ-SRVC-004** | **Must Have** | Cases shall display the related Account's Subscription Tier, Modules Purchased, ACV, and Account Health Score prominently on the case record and in the Service Console | Agents currently have no account context when handling cases; this is a top pain point per VP of Customer Success |
| **MKT-REQ-SRVC-005** | **Must Have** | The system shall enforce case status values: New, Awaiting Agent, In Progress, Awaiting Customer, On Hold, Resolved, Closed — with a mandatory Resolution Summary field before status can be set to Resolved | Consistent status lifecycle enables SLA tracking and reporting accuracy |
| **MKT-REQ-SRVC-006** | **Should Have** | The system shall prevent a case from being set to Closed if customer satisfaction (CSAT) survey has not been sent, prompting the agent to dispatch the survey from the case record | Ensures CSAT data collection is not bypassed; supports service quality measurement |

## **9.2 SLA Entitlements**

Catalyst's subscription tiers define distinct SLA commitments. The CRM must enforce these programmatically.

| Tier | First Response Target | Resolution Target | Support Hours |
| :---- | :---- | :---- | :---- |
| **Starter** | 8 business hours | 5 business days | Mon–Fri, 9am–6pm CT |
| **Professional** | 4 business hours | 2 business days | Mon–Fri, 8am–8pm CT |
| **Enterprise** | 1 business hour | 4 business hours | 24/7 |

| Req. ID | Priority | Requirement | Rationale |
| :---- | :---- | :---- | :---- |
| **MKT-REQ-SRVC-007** | **Must Have** | The system shall apply an Entitlement to every case based on the related Account's Subscription Tier, enforcing the first response and resolution milestones defined in the SLA table above | Supports OBJ-005; SLA tracking is currently entirely manual in Zendesk |
| **MKT-REQ-SRVC-008** | **Must Have** | The system shall trigger an automated escalation notification to the Support Team Lead when a case breaches its first response milestone. A second escalation to the VP of Customer Success shall fire at 50% of resolution time remaining | Automated escalation replaces a manual monitoring process prone to SLA breaches |
| **MKT-REQ-SRVC-009** | **Should Have** | A Service SLA Dashboard shall display: cases by status, SLA compliance rate by tier, average resolution time by case type, breach count by agent, and case volume trend over 90 days | Supports OBJ-005; visibility is a prerequisite for SLA improvement |

## **9.3 Knowledge Management**

| Req. ID | Priority | Requirement | Rationale |
| :---- | :---- | :---- | :---- |
| **MKT-REQ-SRVC-010** | **Must Have** | The system shall support a Salesforce Knowledge base with article types: How-To Guide, Troubleshooting, Release Note, and FAQ. Articles shall be searchable from the Service Console and the Experience Cloud portal | Knowledge is the primary deflection mechanism supporting OBJ-006 |
| **MKT-REQ-SRVC-011** | **Must Have** | Knowledge articles shall support draft, review, and published states with a mandatory peer-review step before publication | Quality control ensures clients receive accurate guidance; prevents misinformation reaching the portal |
| **MKT-REQ-SRVC-012** | **Should Have** | The system shall surface the top 5 recommended knowledge articles on the case creation screen in the portal, based on the subject line entered, to encourage self-service before ticket submission | Directly supports OBJ-006 — self-service deflection at the point of case creation |
| **MKT-REQ-SRVC-013** | **Should Have** | Agents shall be able to attach a knowledge article link to a case response with a single click from the Service Console | Reduces agent handle time; improves response consistency |

## **9.4 Omni-Channel & Queue Management**

| Req. ID | Priority | Requirement | Rationale |
| :---- | :---- | :---- | :---- |
| **MKT-REQ-SRVC-014** | **Must Have** | The system shall route incoming cases to queues based on Case Record Type and Account Subscription Tier. Enterprise cases shall be routed to a dedicated Enterprise Support queue with highest priority | Priority routing ensures Enterprise SLA targets are achievable |
| **MKT-REQ-SRVC-015** | **Should Have** | Omni-Channel shall be configured to assign cases to available agents based on skill matching (Technical, Billing, Onboarding) and current workload capacity | Skills-based routing improves first-contact resolution rates |
| **MKT-REQ-SRVC-016** | **Should Have** | The Service Console shall display an Omni-Channel supervisor panel for the Support Team Lead, showing agent availability, queue depth, and work item assignment in real time | Supervisor visibility is required to manage intraday queue spikes |

# **10\. Functional Requirements — Experience Cloud**

The Experience Cloud implementation delivers the Catalyst Client Portal — a branded, authenticated self-service destination for all Catalyst customers. The portal is built on Lightning Web Runtime (LWR) using SLDS 2 components.

## **10.1 Authentication & Access**

| Req. ID | Priority | Requirement | Rationale |
| :---- | :---- | :---- | :---- |
| **MKT-REQ-EXP-001** | **Must Have** | The portal shall require authenticated login for all content beyond the landing page. Self-registration shall be available for contacts on existing Customer Account records, triggered by a welcome email sent at contract signature | Restricts portal access to paying clients; self-registration reduces onboarding burden |
| **MKT-REQ-EXP-002** | **Must Have** | Portal users shall be assigned the Customer Community Plus licence profile with object-level permissions scoped strictly to their own Account's data via sharing rules | Data isolation is a security requirement; clients must not see other clients' records |
| **MKT-REQ-EXP-003** | **Should Have** | The portal shall support role-based access for two portal user types: Account Admin (full portal access including user management and billing summary) and Standard User (case management and knowledge only) | Different client personas have different access needs |

## **10.2 Client Dashboard & Subscription Summary**

| Req. ID | Priority | Requirement | Rationale |
| :---- | :---- | :---- | :---- |
| **MKT-REQ-EXP-004** | **Must Have** | The portal home page shall display a personalised client dashboard showing: active modules, contract renewal date, open case count, unread knowledge articles, and a platform usage summary (populated from mock API) | Supports OBJ-007 and OBJ-008; the primary client landing experience |
| **MKT-REQ-EXP-005** | **Should Have** | The subscription summary page shall display ACV, contract start and end date, payment status, and a list of all licensed modules with their activation status | Reduces inbound billing enquiry case volume; clients self-serve contract information |
| **MKT-REQ-EXP-006** | **Could Have** | The portal shall display a module usage heat map showing the client's engagement with each Catalyst Platform module over the previous 30 days, powered by the mock usage API | Drives product adoption conversations; supports Customer Success upsell identification |

## **10.3 Case Management in the Portal**

| Req. ID | Priority | Requirement | Rationale |
| :---- | :---- | :---- | :---- |
| **MKT-REQ-EXP-007** | **Must Have** | Portal users shall be able to submit new cases via a structured form capturing: Subject, Description, Case Type (mapped to record types), Affected Module (multi-select), and Urgency | Structured intake improves routing accuracy and reduces back-and-forth |
| **MKT-REQ-EXP-008** | **Must Have** | Portal users shall be able to view all open and closed cases related to their Account, add comments, and upload attachments without agent intervention | Supports OBJ-007; eliminates email threads for case updates |
| **MKT-REQ-EXP-009** | **Must Have** | The case submission form shall surface recommended knowledge articles based on the subject line before the form is submitted, with a prompt asking the user whether their issue is resolved | Directly supports OBJ-006; article surfacing at the point of submission is the highest-impact deflection mechanism |

## **10.4 Onboarding Experience**

| Req. ID | Priority | Requirement | Rationale |
| :---- | :---- | :---- | :---- |
| **MKT-REQ-EXP-010** | **Must Have** | New clients shall see an Onboarding Checklist on their portal home page until all steps are complete. Steps include: Complete company profile, Add team members, Connect data source, Attend kickoff call, and Complete platform training | Supports OBJ-008; structured onboarding reduces time-to-value and early churn risk |
| **MKT-REQ-EXP-011** | **Should Have** | Each onboarding step shall link to a relevant knowledge article or a Catalyst-hosted training video embedded within the portal | Reduces onboarding case volume by providing guidance in context |

## **10.5 Agentforce — Catalyst Client Assistant**

| Req. ID | Priority | Requirement | Rationale |
| :---- | :---- | :---- | :---- |
| **MKT-REQ-EXP-012** | **Must Have** | An Agentforce AI assistant named 'Aria' shall be embedded in the Catalyst Client Portal. Aria shall be capable of: answering questions using the Salesforce Knowledge base, surfacing case status for the authenticated user, and guiding users through the onboarding checklist steps | Demonstrates Agentforce implementation in a realistic client-facing context |
| **MKT-REQ-EXP-013** | **Must Have** | Aria shall be configured with a custom Agent Topic — Client Self-Service — with defined actions: SearchKnowledge, GetCaseStatus, GetOnboardingProgress, and EscalateToAgent | Multi-action agent demonstrates breadth of Agentforce Action configuration |
| **MKT-REQ-EXP-014** | **Should Have** | Aria shall be persona-prompted to communicate in a professional, empathetic tone consistent with Catalyst's brand voice. The system prompt shall include tone guidelines, escalation instructions, and scope boundaries | Demonstrates prompt engineering skill; persona consistency is a client experience requirement |
| **MKT-REQ-EXP-015** | **Should Have** | Aria shall gracefully escalate to a human agent when a query cannot be resolved, collecting a brief summary and pre-populating a case draft for agent review | Prevents negative experiences from AI dead-ends; demonstrates responsible Agentforce design |

# **11\. Non-Functional Requirements**

| Req. ID | Category | Requirement | Measure |
| :---- | :---- | :---- | :---- |
| **MKT-REQ-NFR-001** | Performance | All Lightning record pages shall load within 3 seconds on a standard broadband connection for users in the continental US | Page load time \<3s; measured via Lightning Usage App |
| **MKT-REQ-NFR-002** | Performance | Apex classes shall complete governor-safe execution with no SOQL queries exceeding 100 rows without pagination, and no unguarded loops performing DML | Zero governor limit exceptions in production-equivalent test run |
| **MKT-REQ-NFR-003** | Security | All custom Apex must pass Salesforce Security Review standards: no hardcoded credentials, no SOQL injection vectors, all user inputs sanitised | Zero critical findings in manual security review against OWASP SF Top 10 |
| **MKT-REQ-NFR-004** | Security | The principle of least privilege shall govern all profiles and permission sets. No user shall have access beyond what their role requires | Verified by permission set audit checklist in TDD |
| **MKT-REQ-NFR-005** | Availability | The Salesforce org shall leverage Salesforce's standard 99.9% uptime SLA. Any custom integration stubs shall implement graceful failure handling with user-facing error messages | No uncaught exceptions surfaced to end users |
| **MKT-REQ-NFR-006** | Code Quality | All Apex classes shall have a minimum test coverage of 85%, with meaningful assertions. Test classes shall use test factories, not inline data creation | Coverage verified in Salesforce Setup; test factory pattern demonstrated |
| **MKT-REQ-NFR-007** | Accessibility | All custom LWC components and Experience Cloud pages shall meet WCAG 2.1 AA accessibility standards, leveraging SLDS 2 accessible primitives | Verified using browser accessibility audit tooling |
| **MKT-REQ-NFR-008** | Maintainability | All configuration and code shall be stored in source control (Git) using SFDX project format. No untracked metadata shall exist in the org | 100% of org metadata retrievable via SFDX pull; confirmed by diff check |

# **12\. Requirements Traceability Summary**

The table below maps each business objective (Section 5\) to its supporting functional requirements. Detailed traceability from requirements to user stories and test cases is maintained in the downstream SDLC documents MKT-USAC-1.0 and MKT-TPQA-1.0.

| Obj. ID | Objective Summary | Supporting Requirements |
| :---- | :---- | :---- |
| **OBJ-001** | Single governed sales pipeline | MKT-REQ-SALES-001, 002, 003, 007, 012, 013 |
| **OBJ-002** | Quote turnaround \<4 hours | MKT-REQ-SALES-014, 015 |
| **OBJ-003** | Real-time pipeline and forecast visibility | MKT-REQ-SALES-018, 019, 020 |
| **OBJ-004** | Case management with full account context | MKT-REQ-SRVC-001, 002, 003, 004 |
| **OBJ-005** | SLA enforcement and automated escalation | MKT-REQ-SRVC-007, 008, 009 |
| **OBJ-006** | Self-service deflection via knowledge | MKT-REQ-SRVC-010, 011, 012, 013, MKT-REQ-EXP-009 |
| **OBJ-007** | Branded client self-service portal | MKT-REQ-EXP-001, 002, 003, 004, 007, 008 |
| **OBJ-008** | Client onboarding and product adoption via portal | MKT-REQ-EXP-010, 011, 012, 013, 014, 015 |

# **13\. Glossary**

| Term | Definition |
| :---- | :---- |
| **ACV** | Annual Contract Value — the annualised value of a subscription contract, excluding professional services |
| **Agentforce** | Salesforce's AI agent platform, enabling the configuration of autonomous AI agents grounded in CRM data and knowledge |
| **Attribution Engine** | A Catalyst Platform module providing multi-touch marketing attribution and pipeline influence reporting |
| **Audience Studio** | A Catalyst Platform module providing audience segmentation and data enrichment capabilities |
| **BRD** | Business Requirements Document — this document; the governing requirements artefact for the implementation |
| **Campaign Intelligence** | A Catalyst Platform module for multi-channel campaign planning and execution |
| **Content Hub** | A Catalyst Platform module for digital asset management and content personalisation |
| **CPQ** | Configure, Price, Quote — the process and tooling for generating sales quotes from a product catalogue |
| **LWC** | Lightning Web Component — Salesforce's modern component framework for building UI in the platform |
| **LWR** | Lightning Web Runtime — the modern Salesforce Experience Cloud site runtime, replacing legacy Aura-based sites |
| **MarTech** | Marketing Technology — the category of software tools used to plan, execute, and measure marketing activities |
| **MoSCoW** | Prioritisation framework: Must Have, Should Have, Could Have, Won't Have |
| **OWD** | Organisation-Wide Defaults — the baseline sharing settings in a Salesforce org |
| **SLDS 2** | Salesforce Lightning Design System version 2 — the updated design token system and component primitives for the Lightning platform |
| **SLA** | Service Level Agreement — contractual commitments on response and resolution time |
| **TDD** | Technical Design Document — the downstream artefact (MKT-TDD-1.0) that translates these requirements into technical specifications |

