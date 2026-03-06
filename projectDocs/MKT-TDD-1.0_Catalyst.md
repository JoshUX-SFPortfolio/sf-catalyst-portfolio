
**CATALYST MARKETING TECHNOLOGIES, INC.**

*Accelerate Every Campaign.*

**TECHNICAL DESIGN DOCUMENT**

**Salesforce CRM Implementation**

Sales Cloud · Service Cloud · Experience Cloud

| Document ID | MKT-TDD-1.0 |
| :---- | :---- |
| **Status** | DRAFT — In Progress |
| **Version** | 1.0 |
| **Vertical** | Marketing — Baseline |
| **Company** | Catalyst Marketing Technologies, Inc. |
| **Prepared By** | Portfolio Developer |
| **Date** | 2026 |
| **Parent Doc** | MKT-BRD-1.0 — Business Requirements Document |
| **Traces From** | MKT-USAC-1.0 — User Stories & Acceptance Criteria |
| **Traces To** | MKT-DD-1.0, MKT-TPQA-1.0 |

---

# Table of Contents

1. Document Control
2. Purpose & Scope
3. Architecture Overview
4. Data Model Design
5. Security Model
6. Automation Design
7. Integration Architecture
8. Experience Cloud Design
9. Agentforce Design
10. Reporting & Dashboards
11. Testing Strategy
12. Non-Functional Implementation
13. Deployment Sequence
14. Requirements Traceability Matrix

---

# 1. Document Control

## 1.1 Version History

| Version | Date | Author | Changes | Status |
| :---- | :---- | :---- | :---- | :---- |
| 1.0 | 2026 | Portfolio Developer | Initial draft — full technical design | Draft |

## 1.2 Reviewers

| Name / Role | Department | Review Type | Status |
| :---- | :---- | :---- | :---- |
| Ben Wallace — Revenue Ops Manager | Operations | Business Logic | Pending |
| Sam Okafor — IT Director | IT | Security / Architecture | Pending |
| Salesforce Architect | IT / Delivery | Technical | Pending |

## 1.3 Related Documents

| Doc ID | Document | Relationship |
| :---- | :---- | :---- |
| MKT-BRD-1.0 | Business Requirements Document | Parent — all requirements traced here |
| MKT-USAC-1.0 | User Stories & Acceptance Criteria | Peer — stories inform design decisions |
| MKT-DD-1.0 | Data Dictionary & ERD | Child — field-level detail derived from Section 4 |
| MKT-TPQA-1.0 | Test Plan & QA Scripts | Child — test cases validate designs in this document |

---

# 2. Purpose & Scope

This Technical Design Document (TDD) translates the business requirements defined in MKT-BRD-1.0 into technical specifications for the Salesforce CRM implementation at Catalyst Marketing Technologies. It is the authoritative reference for all build decisions and serves as the basis for the Data Dictionary (MKT-DD-1.0) and Test Plan (MKT-TPQA-1.0).

## 2.1 What This Document Covers

- Salesforce data model: standard object extensions, custom objects, record types, page layouts, and validation rules
- Security model: OWD, role hierarchy, profiles, permission sets, and sharing rules
- Automation: Flow inventory and specifications, Apex trigger and class design, approval processes
- Integration: External system callout stubs (billing and usage APIs)
- Experience Cloud: LWR site architecture, page inventory, and LWC component specifications
- Agentforce: Agent configuration, topics, actions, and system prompts
- Reporting and dashboards
- Testing approach and deployment sequence

## 2.2 Design Principles

All technical decisions follow these governing principles, consistent with MKT-REQ-NFR-001 through MKT-REQ-NFR-008:

| Principle | Application |
| :---- | :---- |
| Declarative-first | Flows before Apex; custom metadata before hardcoded values |
| Least privilege | No over-permissioning; permissions granted at the role/persona level, not individually |
| Bulkify everything | All Apex designed for 200-record batches; no SOQL in loops |
| One trigger per object | All trigger logic delegated to handler and service classes |
| Source-controlled | 100% of metadata retrievable via `sf project retrieve start` |
| SLDS 2 throughout | No hardcoded colours, spacing, or legacy component patterns |

---

# 3. Architecture Overview

## 3.1 Cloud Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    SALESFORCE ORG                            │
│                                                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐  │
│  │  Sales Cloud │  │Service Cloud │  │ Experience Cloud │  │
│  │              │  │              │  │  (LWR Runtime)   │  │
│  │ Leads        │  │ Cases        │  │                  │  │
│  │ Accounts     │  │ Knowledge    │  │ Catalyst Client  │  │
│  │ Contacts     │  │ Entitlements │  │ Portal           │  │
│  │ Opportunities│  │ Omni-Channel │  │                  │  │
│  │ Products     │  │ Queues       │  │ Agentforce       │  │
│  │ Quotes       │  │ Service      │  │ (Aria agent)     │  │
│  │ Forecasting  │  │ Console      │  │                  │  │
│  └──────────────┘  └──────────────┘  └──────────────────┘  │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐   │
│  │               Core Custom Objects                     │   │
│  │  Project__c · Service_Region__c · Asset_Item__c      │   │
│  │  Feedback_Survey__c · Portal_User_Group__c           │   │
│  └──────────────────────────────────────────────────────┘   │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐   │
│  │               Integration Layer (Stubs)               │   │
│  │   BillingAPIService (mock)  ·  UsageAPIService (mock)│   │
│  └──────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

## 3.2 API Version

All metadata is authored at **API version 62.0**.

## 3.3 Environment Strategy

| Environment | Purpose | Metadata Source |
| :---- | :---- | :---- |
| Scratch Org (Developer edition) | All active development and testing | Git `vertical/marketing` branch |
| Developer Edition Org (persistent) | Portfolio demo target; deployed from `main` | Git `main` branch |

---

# 4. Data Model Design

## 4.1 Standard Object Extensions

### 4.1.1 Lead — Custom Fields

| Field Label | API Name | Type | Values / Notes | Req. ID |
| :---- | :---- | :---- | :---- | :---- |
| Area of Interest | `Area_of_Interest__c` | Multi-Select Picklist | Campaign Intelligence; Audience Studio; Attribution Engine; Content Hub | MKT-REQ-SALES-001 |
| Lead Score | `Lead_Score__c` | Number (3, 0) | 0–100; populated by Einstein Lead Scoring | MKT-REQ-SALES-004 |
| Activity Count | `Activity_Count__c` | Formula (Number) | COUNT of related Tasks/Events (workaround via Apex — see Section 6.5) | MKT-REQ-SALES-005 |

**Lead Status Picklist Values (governed — replace default):**
New · Attempting Contact · Contacted · Qualified · Unqualified · Converted

### 4.1.2 Account — Custom Fields

| Field Label | API Name | Type | Values / Notes | Req. ID |
| :---- | :---- | :---- | :---- | :---- |
| Subscription Tier | `Subscription_Tier__c` | Picklist | Starter; Professional; Enterprise | MKT-REQ-SALES-008 |
| Modules Purchased | `Modules_Purchased__c` | Multi-Select Picklist | Campaign Intelligence; Audience Studio; Attribution Engine; Content Hub | MKT-REQ-SALES-008 |
| Contract Renewal Date | `Contract_Renewal_Date__c` | Date | | MKT-REQ-SALES-008 |
| Annual Contract Value | `Annual_Contract_Value__c` | Currency (18, 2) | | MKT-REQ-SALES-008 |
| Primary Platform Contact | `Primary_Platform_Contact__c` | Lookup (Contact) | | MKT-REQ-SALES-008 |
| Health Score | `Health_Score__c` | Number (3, 0) | 0–100; calculated by `AccountHealthScoreService` | MKT-REQ-SALES-010 |
| CSAT Average | `CSAT_Average__c` | Roll-Up Summary | AVG of `Feedback_Survey__c.CSAT_Score__c` | MKT-REQ-SALES-010 |
| Open Case Count | `Open_Case_Count__c` | Roll-Up Summary | COUNT of Cases where Status != Closed | MKT-REQ-SALES-010 |
| Platform Usage Index | `Platform_Usage_Index__c` | Number (5, 2) | Populated by `UsageAPIService` stub | MKT-REQ-SALES-010 |
| Billing Account ID | `Billing_Account_ID__c` | Text (50), External ID | Key for billing stub callout | MKT-REQ-NFR-008 |
| Duplicate Domain Flag | `Duplicate_Domain_Flag__c` | Checkbox | Set by `AccountTriggerHandler` on domain match | MKT-REQ-SALES-011 |

**Account Record Types:**

| Developer Name | Label | Purpose |
| :---- | :---- | :---- |
| `Prospect` | Prospect | Pre-sale accounts |
| `Customer` | Customer | Active subscription accounts |
| `Partner` | Partner | Reseller and integration partners |
| `Competitor` | Competitor | Competitive intelligence tracking |

### 4.1.3 Contact — Custom Fields

| Field Label | API Name | Type | Values / Notes | Req. ID |
| :---- | :---- | :---- | :---- | :---- |
| Role at Catalyst | `Role_at_Catalyst__c` | Picklist | Economic Buyer; Technical Evaluator; Champion; End User; Detractor | MKT-REQ-SALES-009 |
| Portal User Type | `Portal_User_Type__c` | Picklist | Account Admin; Standard User | MKT-REQ-EXP-003 |
| Portal Active | `Is_Portal_Active__c` | Checkbox | Set when Experience Cloud user is provisioned | MKT-REQ-EXP-001 |
| Welcome Email Sent | `Portal_Welcome_Sent__c` | Checkbox | Prevents duplicate welcome emails | MKT-REQ-EXP-001 |

### 4.1.4 Opportunity — Custom Fields

| Field Label | API Name | Type | Values / Notes | Req. ID |
| :---- | :---- | :---- | :---- | :---- |
| Contract Length | `Contract_Length__c` | Picklist | 12 Months; 24 Months; 36 Months | MKT-REQ-SALES-013 |
| Decision Date | `Decision_Date__c` | Date | Required at Proposal Sent | MKT-REQ-SALES-013 |
| Economic Buyer | `Economic_Buyer__c` | Lookup (Contact) | Required at Proposal Sent | MKT-REQ-SALES-013 |
| Loss Reason | `Loss_Reason__c` | Picklist | Competitor — Named; Price; Timing; No Decision; Product Gap | MKT-REQ-SALES-016 |
| Loss Notes | `Loss_Notes__c` | Long Text Area (2000) | Optional on Closed Lost | MKT-REQ-SALES-016 |
| Proposed ACV | `Proposed_ACV__c` | Currency (18, 2) | Formula: sum of opportunity line items | MKT-REQ-SALES-014 |
| Max Discount Pct | `Max_Discount_Pct__c` | Percent (5, 2) | Formula: MAX discount across quote line items | MKT-REQ-SALES-015 |

**Opportunity Stage Picklist (governed):**

| Stage | Probability | Forecast Category | Exit Criteria |
| :---- | :---- | :---- | :---- |
| Discovery | 10% | Pipeline | Qualified need confirmed, budget estimated |
| Technical Evaluation | 25% | Pipeline | Technical fit confirmed, POC or demo complete |
| Proposal Sent | 50% | Best Case | Modules selected, contract length, decision date, economic buyer set |
| Negotiation | 75% | Best Case | Quote approved, legal review in progress |
| Closed Won | 100% | Closed | Contract signed |
| Closed Lost | 0% | Omitted | Loss reason required |

### 4.1.5 Case — Custom Fields

| Field Label | API Name | Type | Values / Notes | Req. ID |
| :---- | :---- | :---- | :---- | :---- |
| Affected Module | `Affected_Module__c` | Multi-Select Picklist | Campaign Intelligence; Audience Studio; Attribution Engine; Content Hub | MKT-REQ-EXP-007 |
| Urgency | `Urgency__c` | Picklist | Low; Medium; High; Critical | MKT-REQ-EXP-007 |
| CSAT Sent | `CSAT_Sent__c` | Checkbox | Set when CSAT survey dispatched | MKT-REQ-SRVC-006 |
| Resolution Summary | `Resolution_Summary__c` | Long Text Area (2000) | Required before Resolved status | MKT-REQ-SRVC-005 |
| SLA Tier at Creation | `SLA_Tier_at_Creation__c` | Text (50) | Formula snapshot of Account.Subscription_Tier__c at case creation | MKT-REQ-SRVC-007 |
| Auto-Link Status | `Auto_Link_Status__c` | Picklist | Linked; Pending Manual Review; Not Applicable | MKT-REQ-SRVC-002 |

**Case Status Picklist (governed):**
New · Awaiting Agent · In Progress · Awaiting Customer · On Hold · Resolved · Closed

**Case Record Types:**

| Developer Name | Label | Default Queue | Req. ID |
| :---- | :---- | :---- | :---- |
| `Technical_Support` | Technical Support | Technical_Support_Queue | MKT-REQ-SRVC-003 |
| `Billing_Enquiry` | Billing Enquiry | Billing_Enquiry_Queue | MKT-REQ-SRVC-003 |
| `Onboarding_Request` | Onboarding Request | Onboarding_Queue | MKT-REQ-SRVC-003 |
| `Feature_Request` | Feature Request | General_Enquiry_Queue | MKT-REQ-SRVC-003 |
| `General_Enquiry` | General Enquiry | General_Enquiry_Queue | MKT-REQ-SRVC-003 |

---

## 4.2 Custom Objects

All custom objects below are part of the **Core Layer** — present in every vertical branch. They must not be modified from a `vertical/*` branch.

### 4.2.1 Project__c

**Purpose:** Tracks active client delivery engagements linked to Accounts and Opportunities.

| Field Label | API Name | Type | Notes |
| :---- | :---- | :---- | :---- |
| Project Name | `Name` | Text (80), required | Auto-populated or manual |
| Account | `Account__c` | Master-Detail (Account) | |
| Opportunity | `Opportunity__c` | Lookup (Opportunity) | Optional — links to originating opp |
| Status | `Status__c` | Picklist | Planning; Active; On Hold; Completed; Cancelled |
| Start Date | `Start_Date__c` | Date | |
| End Date | `End_Date__c` | Date | |
| Project Manager | `Project_Manager__c` | Lookup (User) | |
| Description | `Description__c` | Long Text Area (5000) | |

**OWD:** Private. Sharing via Account role hierarchy.

### 4.2.2 Service_Region__c

**Purpose:** Maps geographic service regions to Accounts for routing and reporting segmentation.

| Field Label | API Name | Type | Notes |
| :---- | :---- | :---- | :---- |
| Region Name | `Name` | Text (80) | e.g. "North America — West" |
| Account | `Account__c` | Lookup (Account) | |
| Region | `Region__c` | Picklist | North America; EMEA; APAC; LATAM |
| Country | `Country__c` | Text (80) | |
| State / Province | `State_Province__c` | Text (80) | |
| Primary Contact | `Primary_Contact__c` | Lookup (Contact) | |

**OWD:** Public Read Only. No sensitive data.

### 4.2.3 Asset_Item__c

**Purpose:** Records each Catalyst Platform module licence held by a client Account.

| Field Label | API Name | Type | Notes |
| :---- | :---- | :---- | :---- |
| Asset Name | `Name` | Auto-Number | Format: ASSET-{0000} |
| Account | `Account__c` | Master-Detail (Account) | |
| Contact | `Contact__c` | Lookup (Contact) | Primary contact for this asset |
| Asset Type | `Asset_Type__c` | Picklist | Module Licence; Professional Service; Training |
| Module | `Module__c` | Picklist | Campaign Intelligence; Audience Studio; Attribution Engine; Content Hub |
| Status | `Status__c` | Picklist | Active; Inactive; Expired; Pending Activation |
| Activation Date | `Activation_Date__c` | Date | |
| Expiry Date | `Expiry_Date__c` | Date | |
| Licence Key | `Licence_Key__c` | Text (255), Encrypted | Not exposed to portal |

**OWD:** Private. Sharing via Account parent (Master-Detail).

### 4.2.4 Feedback_Survey__c

**Purpose:** Records CSAT and NPS survey responses linked to Cases and Contacts.

| Field Label | API Name | Type | Notes |
| :---- | :---- | :---- | :---- |
| Survey Reference | `Name` | Auto-Number | Format: SURVEY-{00000} |
| Contact | `Contact__c` | Lookup (Contact) | Recipient |
| Case | `Case__c` | Lookup (Case) | Source case; optional for NPS |
| Survey Type | `Survey_Type__c` | Picklist | CSAT; NPS; Onboarding |
| Status | `Status__c` | Picklist | Sent; Completed; Expired |
| Sent Date | `Sent_Date__c` | DateTime | |
| Completed Date | `Completed_Date__c` | DateTime | |
| CSAT Score | `CSAT_Score__c` | Number (1, 0) | 1–5; validated by VR |
| NPS Score | `NPS_Score__c` | Number (2, 0) | 0–10; validated by VR |
| Comments | `Comments__c` | Long Text Area (2000) | Free-text response |

**OWD:** Private.

### 4.2.5 Portal_User_Group__c

**Purpose:** Governs portal user roles within an Account — enables Account Admin and Standard User distinction within Experience Cloud.

| Field Label | API Name | Type | Notes |
| :---- | :---- | :---- | :---- |
| Group Name | `Name` | Text (80) | |
| Account | `Account__c` | Master-Detail (Account) | |
| Contact | `Contact__c` | Lookup (Contact) | |
| Portal Role | `Portal_Role__c` | Picklist | Account Admin; Standard User |
| Is Active | `Is_Active__c` | Checkbox | Default true |
| Last Login | `Last_Login__c` | DateTime | Populated by login flow |

**OWD:** Private. Sharing via Account Master-Detail.

---

## 4.3 Validation Rules

### 4.3.1 Lead Validation Rules

| Rule Name | Object | Condition | Error Message | Req. ID |
| :---- | :---- | :---- | :---- | :---- |
| `Lead_ConversionGate` | Lead | `ISNEW() = FALSE && ISCHANGED(IsConverted) && IsConverted = TRUE && (Status__c != 'Qualified' || Activity_Count_Formula__c < 3)` | "A lead cannot be converted unless Status is Qualified and at least 3 activities are logged." | MKT-REQ-SALES-005 |
| `Lead_QualifiedFieldsRequired` | Lead | `ISCHANGED(Status) && Status = 'Qualified' && (ISBLANK(Company) || ISBLANK(Email))` | "Company and Email are required before a lead can be set to Qualified." | MKT-REQ-SALES-003 |

> **Note:** Activity count cannot be natively counted in a formula on Lead. `LeadService` maintains a counter field `Activity_Count__c` (Number) via trigger on Task/Event. The VR references this counter field.

### 4.3.2 Opportunity Validation Rules

| Rule Name | Object | Condition | Error Message | Req. ID |
| :---- | :---- | :---- | :---- | :---- |
| `Opp_ProposalSentGate` | Opportunity | `ISCHANGED(StageName) && ISPICKVAL(StageName, 'Proposal Sent') && (ISBLANK(Contract_Length__c) || ISBLANK(Decision_Date__c) || ISBLANK(Economic_Buyer__c))` | "Contract Length, Decision Date, and Economic Buyer are required before advancing to Proposal Sent." | MKT-REQ-SALES-013 |
| `Opp_ClosedLostRequiresReason` | Opportunity | `ISCHANGED(StageName) && ISPICKVAL(StageName, 'Closed Lost') && ISBLANK(Loss_Reason__c)` | "Loss Reason is required when closing an opportunity as Lost." | MKT-REQ-SALES-016 |

### 4.3.3 Case Validation Rules

| Rule Name | Object | Condition | Error Message | Req. ID |
| :---- | :---- | :---- | :---- | :---- |
| `Case_ResolutionSummaryRequired` | Case | `ISCHANGED(Status) && ISPICKVAL(Status, 'Resolved') && ISBLANK(Resolution_Summary__c)` | "A Resolution Summary is required before setting a case to Resolved." | MKT-REQ-SRVC-005 |
| `Case_CSATGate` | Case | `ISCHANGED(Status) && ISPICKVAL(Status, 'Closed') && CSAT_Sent__c = FALSE` | "Please send the CSAT survey before closing this case." | MKT-REQ-SRVC-006 |

### 4.3.4 Feedback_Survey__c Validation Rules

| Rule Name | Object | Condition | Error Message |
| :---- | :---- | :---- | :---- |
| `Survey_CSATRange` | Feedback_Survey__c | `NOT(ISBLANK(CSAT_Score__c)) && (CSAT_Score__c < 1 || CSAT_Score__c > 5)` | "CSAT Score must be between 1 and 5." |
| `Survey_NPSRange` | Feedback_Survey__c | `NOT(ISBLANK(NPS_Score__c)) && (NPS_Score__c < 0 || NPS_Score__c > 10)` | "NPS Score must be between 0 and 10." |

---

# 5. Security Model

## 5.1 Org-Wide Defaults

| Object | Default Access | Rationale |
| :---- | :---- | :---- |
| Account | **Private** | Clients must not see competing accounts; reps own their accounts |
| Contact | Controlled by Parent | Inherits Account OWD |
| Lead | **Private** | SDR owns their leads; no cross-SDR visibility |
| Opportunity | **Private** | AE owns their pipeline; forecasting managed via role hierarchy |
| Case | **Private** | Client data; agents access via queue membership |
| Knowledge | Public Read Only | Agents and portal users need read access across all articles |
| Quote | Controlled by Parent | Inherits Opportunity OWD |
| Project__c | **Private** | Access via Account sharing |
| Asset_Item__c | Controlled by Parent | Master-Detail to Account |
| Feedback_Survey__c | **Private** | Sensitive; access restricted to owning agent and manager |
| Portal_User_Group__c | Controlled by Parent | Master-Detail to Account |
| Service_Region__c | Public Read Only | Non-sensitive geographic reference data |

## 5.2 Role Hierarchy

```
Chief Executive Officer (Marcus Chen)
├── VP of Sales (Priya Sharma)
│   └── Sales Manager
│       ├── Account Executive
│       └── Sales Development Representative
└── VP of Customer Success (Daniel Torres)
    └── Support Team Lead (Chris Park)
        ├── Support Agent — Technical
        ├── Support Agent — Billing
        └── Support Agent — Onboarding
```

Role-based sharing is the primary mechanism for granting manager visibility into subordinate records. No sharing rules are required for standard upward visibility — it flows through the hierarchy automatically.

## 5.3 Profiles

| Profile Name | Base | Users |
| :---- | :---- | :---- |
| System Administrator | Standard (Salesforce) | Sys Admin persona |
| Sales User | Standard User (cloned) | Account Executive, SDR |
| Sales Manager | Standard User (cloned, elevated) | Sales Manager role |
| Service User | Standard User (cloned) | Support Agent roles |
| Service Manager | Standard User (cloned, elevated) | Support Team Lead |
| Portal Customer | Customer Community Plus Login (cloned) | Portal Client users |
| Portal Guest | Authenticated Website (site guest) | Public pages (login/register only) |

**Profile design principle:** Profiles grant minimum object CRUD access. All functional capability is layered via Permission Sets. Profiles are not modified after initial clone — all incremental access uses PSets.

## 5.4 Permission Sets

| API Name | Label | Granted To | Key Permissions |
| :---- | :---- | :---- | :---- |
| `Sales_Core` | Sales — Core Access | Sales User, Sales Manager profiles | Read/Write: Lead, Account, Contact, Opportunity, Product, Quote. Read: Asset_Item__c, Project__c |
| `Sales_Manager_Extended` | Sales — Manager Extended | Sales Manager profile | + Collaborative Forecasting manage, + View All Opportunities (hierarchy), + Approval process admin |
| `Service_Core` | Service — Core Access | Service User, Service Manager profiles | Read/Write: Case, Knowledge, Entitlement, Feedback_Survey__c. Read: Account, Contact, Asset_Item__c |
| `Service_Manager_Extended` | Service — Manager Extended | Service Manager profile | + Omni-Channel Supervisor, + View All Cases (hierarchy), + Delete Case |
| `Portal_Account_Admin` | Portal — Account Admin | Portal Customer profile (Account Admin role) | Portal: Read/Write Cases, Read Subscription, Manage portal users within own Account |
| `Portal_Standard_User` | Portal — Standard User | Portal Customer profile (Standard User role) | Portal: Read/Write own Cases, Read Knowledge, Read own Subscription data |
| `Agentforce_Service_User` | Agentforce — Service User | Aria agent's connected app user | Read: Knowledge, Case, Asset_Item__c, Portal_User_Group__c. Write: Case (EscalateToAgent action only) |

## 5.5 Sharing Rules

| Rule Name | Object | Criteria | Shared With | Access |
| :---- | :---- | :---- | :---- | :---- |
| `Customer_Accounts_To_Service` | Account | Record Type = Customer | Support Team Lead role and subordinates | Read Only |
| `Cases_To_Account_Team` | Case | All Cases | Account team members | Read/Write |
| `Assets_To_Service_Team` | Asset_Item__c | All active asset records | Service User profile group | Read Only |

## 5.6 Guest User Security

The Experience Cloud site has a Guest User profile for the login and self-registration pages only. The following constraints apply:

- No Apex classes accessible via Guest profile
- No custom objects readable by Guest
- CSRF protection enabled on all site pages
- `Guest_User_Sharing_Rule` is **not** configured — Guest access is limited to login/register pages; all content requires authentication
- Reviewed against MKT-REQ-NFR-003 and MKT-REQ-NFR-004

---

# 6. Automation Design

## 6.1 Flow Inventory

| Flow API Name | Type | Trigger | Purpose | Req. ID |
| :---- | :---- | :---- | :---- | :---- |
| `Lead_AfterSave_FollowUpTask` | Record-Triggered | After Save, Create only | Schedule 48hr follow-up task if no activities logged | MKT-REQ-SALES-006 |
| `Lead_AfterSave_AssignmentRule` | Record-Triggered | After Save, Create only | Invoke assignment rules to route lead to SDR | MKT-REQ-SALES-002 |
| `Opportunity_BeforeSave_StageGating` | Record-Triggered | Before Save, Update only | Enforce field requirements at Proposal Sent (redundant safeguard to VR) | MKT-REQ-SALES-013 |
| `Opportunity_AfterSave_QuoteApproval` | Record-Triggered | After Save | Submit quote for approval when Max_Discount_Pct__c > 15 | MKT-REQ-SALES-015 |
| `Case_AfterSave_AutoLinkAccount` | Record-Triggered | After Save, Create only | Match submitter email domain to Account; set AccountId or flag for review | MKT-REQ-SRVC-002 |
| `Case_AfterSave_EntitlementAssignment` | Record-Triggered | After Save, Create only | Query Entitlement by Account Subscription Tier; link to case | MKT-REQ-SRVC-007 |
| `Case_AfterSave_CSATDispatch` | Record-Triggered | After Save, Update only | Dispatch CSAT survey when Status changes to Resolved | MKT-REQ-SRVC-006 |
| `Case_Scheduled_EscalationCheck` | Scheduled | Every 15 minutes | Check SLA milestones; send escalation alerts on breach | MKT-REQ-SRVC-008 |
| `Contact_AfterSave_PortalWelcomeEmail` | Record-Triggered | After Save, Create/Update | Send portal welcome email when `Is_Portal_Active__c` set to true | MKT-REQ-EXP-001 |
| `Account_AfterSave_HealthScoreRecalc` | Record-Triggered | After Save | Call `AccountHealthScoreService` Apex action; update Health_Score__c | MKT-REQ-SALES-010 |
| `Onboarding_Scheduled_ChecklistReminder` | Scheduled | Daily, 9am CT | Check incomplete onboarding checklists; send reminder email | MKT-REQ-EXP-010 |

## 6.2 Key Flow Specifications

### 6.2.1 Case_AfterSave_AutoLinkAccount

**Trigger:** After Save, Create only, all Cases where `AccountId` is null
**Purpose:** Satisfies MKT-REQ-SRVC-002 — auto-link by email domain.

```
Start
  └─ Get Email Domain from Case.SuppliedEmail
       └─ Get Records: Account WHERE Website CONTAINS domain
            ├─ Match Found (1 result)
            │    └─ Update Case: AccountId = matched Account
            └─ No Match / Multiple Matches
                 └─ Update Case: Auto_Link_Status__c = 'Pending Manual Review'
                                 OwnerId = Manual_Review_Queue
```

**Edge cases:**
- Multiple domain matches: flag for review (do not guess)
- Null email (manual agent creation): skip flow via entry condition
- Common domains (gmail.com, outlook.com): excluded via Custom Metadata exclusion list `Domain_Exclusion__mdt`

### 6.2.2 Case_Scheduled_EscalationCheck

**Trigger:** Scheduled flow, every 15 minutes
**Purpose:** Satisfies MKT-REQ-SRVC-008 — automated escalation on SLA breach.

```
Start
  └─ Get Records: Cases WHERE Status NOT IN ('Resolved', 'Closed')
       └─ For Each Case:
            ├─ Check: CaseEntitlement.MilestoneStatus = 'Violated' (First Response)
            │    └─ Send Email: Support Team Lead — "SLA Breach Alert: {Case.CaseNumber}"
            └─ Check: Resolution milestone remaining time <= 50% AND NOT yet escalated
                 └─ Send Email: VP of Customer Success — "SLA Resolution Risk: {Case.CaseNumber}"
                 └─ Update Case: custom escalation flag to prevent duplicate alerts
```

**Governor consideration:** Flow loops are bulkified. Email send actions use the platform's queued email mechanism. Escalation flag prevents repeated notifications.

### 6.2.3 Lead_AfterSave_FollowUpTask

**Trigger:** After Save, Create only
**Purpose:** Satisfies MKT-REQ-SALES-006 — 48hr follow-up task.

```
Start
  └─ Scheduled Path: 48 hours after Lead.CreatedDate
       └─ Get Records: Tasks WHERE WhoId = Lead.Id AND IsClosed = FALSE
            ├─ Tasks Found: END (lead has been worked)
            └─ No Tasks Found:
                 └─ Create Task:
                      Subject = 'Follow Up — No Activity Logged'
                      OwnerId = Lead.OwnerId
                      ActivityDate = NOW() + 1 day
                      Priority = High
                      Description = 'Lead created 48 hours ago with no activity recorded.'
```

## 6.3 Apex Trigger Design

**Pattern:** One trigger per object → delegates to handler class → calls service class.

```apex
// Pattern: every trigger follows this structure
trigger LeadTrigger on Lead (before insert, before update, after insert, after update) {
    LeadTriggerHandler handler = new LeadTriggerHandler();
    if (Trigger.isBefore) {
        if (Trigger.isInsert) handler.onBeforeInsert(Trigger.new);
        if (Trigger.isUpdate) handler.onBeforeUpdate(Trigger.new, Trigger.oldMap);
    }
    if (Trigger.isAfter) {
        if (Trigger.isInsert) handler.onAfterInsert(Trigger.new);
        if (Trigger.isUpdate) handler.onAfterUpdate(Trigger.new, Trigger.oldMap);
    }
}
```

**ITriggerHandler interface** ensures all handlers implement a consistent contract. `TriggerHandlerBase` provides a bypass mechanism (used in tests via `TriggerHandlerBase.bypass('LeadTriggerHandler')`) to prevent recursive trigger execution.

## 6.4 Apex Class Inventory

| Class Name | Type | Purpose | Req. ID |
| :---- | :---- | :---- | :---- |
| `ITriggerHandler` | Interface | Trigger handler contract | MKT-REQ-NFR-006 |
| `TriggerHandlerBase` | Abstract Class | Bypass mechanism; context helpers | MKT-REQ-NFR-006 |
| `LeadTrigger` | Trigger | Lead trigger (before/after insert/update) | MKT-REQ-SALES-005 |
| `LeadTriggerHandler` | Handler Class | Delegates to LeadService | MKT-REQ-SALES-005 |
| `LeadService` | Service Class | Activity counter maintenance; assignment logic | MKT-REQ-SALES-002, 005 |
| `CaseTrigger` | Trigger | Case trigger (before/after insert/update) | MKT-REQ-SRVC-002 |
| `CaseTriggerHandler` | Handler Class | Delegates to CaseService | MKT-REQ-SRVC-002 |
| `CaseService` | Service Class | Domain exclusion lookup; entitlement query helper | MKT-REQ-SRVC-002, 007 |
| `AccountTrigger` | Trigger | Account trigger (after insert/update) | MKT-REQ-SALES-010, 011 |
| `AccountTriggerHandler` | Handler Class | Delegates to AccountHealthScoreService | MKT-REQ-SALES-010 |
| `AccountHealthScoreService` | Service Class | Calculates Health Score from CSAT, case count, usage index, renewal proximity; invocable method for Flow | MKT-REQ-SALES-010 |
| `BillingAPIService` | Service Class | Mock callout stub to billing system; implements `IBillingService` interface | MKT-REQ-NFR-005 |
| `IBillingService` | Interface | Decouples callout implementation for testability | MKT-REQ-NFR-006 |
| `UsageAPIService` | Service Class | Mock callout stub to Catalyst Platform usage API; implements `IUsageService` | MKT-REQ-SALES-010 |
| `IUsageService` | Interface | Decouples usage callout for testability | MKT-REQ-NFR-006 |
| `TestDataFactory` | Test Utility | Creates test records for all objects; no inline data in test classes | MKT-REQ-NFR-006 |
| `LeadTriggerHandlerTest` | Test Class | 85%+ coverage for LeadTriggerHandler and LeadService | MKT-REQ-NFR-006 |
| `CaseTriggerHandlerTest` | Test Class | 85%+ coverage for CaseTriggerHandler and CaseService | MKT-REQ-NFR-006 |
| `AccountHealthScoreServiceTest` | Test Class | Tests all scoring branches; mock data via TestDataFactory | MKT-REQ-NFR-006 |
| `BillingAPIServiceTest` | Test Class | Uses HttpCalloutMock; verifies graceful failure path | MKT-REQ-NFR-005, 006 |
| `UsageAPIServiceTest` | Test Class | Uses HttpCalloutMock; verifies null usage response handling | MKT-REQ-NFR-005, 006 |

## 6.5 AccountHealthScoreService — Scoring Algorithm

**Invocable method** (callable from Flow on Account after-save):

```
Health Score (0–100) = weighted sum of four components:

Component                 Weight   Source
─────────────────────────────────────────────────────
CSAT Average (normalised)   30%    Account.CSAT_Average__c (scale 1–5 → 0–100)
Open Case Volume (inverse)  25%    Account.Open_Case_Count__c (0 cases = 100, ≥10 = 0)
Platform Usage Index        25%    Account.Platform_Usage_Index__c (0–100 from API)
Renewal Proximity (inverse) 20%    Days to Contract_Renewal_Date__c (>180 days = 100, <30 = 0)

Final score = SUM of weighted components, rounded to nearest integer.
Score < 40 → Health Category: At Risk
Score 40–69 → Health Category: Neutral
Score ≥ 70 → Health Category: Healthy
```

## 6.6 Approval Processes

### Quote Discount Approval

| Property | Value | Req. ID |
| :---- | :---- | :---- |
| Object | Quote | MKT-REQ-SALES-015 |
| Entry Criteria | `Quote.Max_Discount_Pct__c > 15` | |
| Initial Submitter | Opportunity Owner | |
| Approver | VP of Sales role (first available delegate) | |
| Approval Actions | Quote Status = Approved | |
| Rejection Actions | Quote Status = Rejected; email notification to submitter | |
| Recall Actions | Quote Status = Draft | |

**Trigger:** Flow `Opportunity_AfterSave_QuoteApproval` submits the quote for approval when the discount threshold is exceeded and the quote is not already in an approval process.

---

# 7. Integration Architecture

All integrations in this implementation are **mock stubs** for portfolio purposes. The integration design reflects production-grade patterns — the stub simply returns static or configurable JSON rather than calling a live endpoint. This is explicitly documented as an environment constraint in MKT-BRD-1.0 Section 7.2.

## 7.1 Billing System Integration

**Direction:** Bidirectional (Account → Billing System on create/update; Billing → Account on payment events)
**Authentication:** Named Credential (`BillingSystem_NC`) with Basic Auth placeholder
**Mock Approach:** `BillingAPIServiceMock` implements `HttpCalloutMock`; returns configurable JSON response

**Callout Stub — Outbound (Account sync):**
```
Endpoint:   Named Credential: BillingSystem_NC + /v1/accounts/{Billing_Account_ID__c}
Method:     PUT
Payload:    { "accountName": ..., "tier": ..., "acv": ..., "renewalDate": ... }
Success:    HTTP 200 — log sync timestamp on Account
Failure:    HTTP 4xx/5xx — log error in Platform Event; surface user-facing warning (MKT-REQ-NFR-005)
```

**Callout Stub — Inbound (payment event):**
Modelled as an Apex REST endpoint (`@RestResource`) receiving a POST from the billing system. Validates payload, updates `Account.Billing_Status__c`. In portfolio context, triggered manually via anonymous Apex to simulate an inbound event.

## 7.2 Usage API Integration

**Direction:** Inbound read (Usage API → Salesforce)
**Trigger:** Scheduled Apex job, runs nightly
**Mock Approach:** `UsageAPIServiceMock` returns pre-defined usage JSON per Account

**Callout Stub:**
```
Endpoint:   Named Credential: UsageAPI_NC + /v2/usage?accountId={Billing_Account_ID__c}
Method:     GET
Response:   { "usageIndex": 72.4, "modules": { "campaign_intelligence": 85, ... } }
Success:    Update Account.Platform_Usage_Index__c; trigger health score recalculation
Failure:    Null-safe handling; Platform Event logged; no page error surfaced to users
```

**Named Credentials:** Both Named Credentials are stored in the org Settings (never in code or config files). The `.gitignore` excludes all `.pem` and auth files. This satisfies MKT-REQ-NFR-003.

---

# 8. Experience Cloud Design

## 8.1 Site Architecture

| Property | Value |
| :---- | :---- |
| Site Name | Catalyst Client Portal |
| Runtime | LWR (Lightning Web Runtime) |
| Theme | Custom — SLDS 2 design tokens; Catalyst brand palette |
| Authentication | Username/Password + Self-Registration |
| Guest Access | Login and registration pages only |
| Content Delivery Network | Salesforce CDN (standard) |
| Mobile | Responsive — SLDS 2 grid system |

## 8.2 Page Inventory

| Page | URL | Auth Required | Purpose | Req. ID |
| :---- | :---- | :---- | :---- | :---- |
| Login | `/login` | No | Authentication entry point | MKT-REQ-EXP-001 |
| Self-Registration | `/register` | No | New client registration (invite-only via token) | MKT-REQ-EXP-001 |
| Client Home | `/home` | Yes | Personalised dashboard — default landing page | MKT-REQ-EXP-004 |
| Subscription | `/subscription` | Yes | ACV, contract dates, module activation | MKT-REQ-EXP-005 |
| Cases | `/cases` | Yes | Case list — open and closed | MKT-REQ-EXP-008 |
| New Case | `/cases/new` | Yes | Case submission form with knowledge deflection | MKT-REQ-EXP-007, 009 |
| Case Detail | `/cases/{id}` | Yes | Case view, comments, attachments | MKT-REQ-EXP-008 |
| Knowledge | `/knowledge` | Yes | Article search and browse | MKT-REQ-SRVC-010 |
| Article | `/knowledge/{id}` | Yes | Article full view | MKT-REQ-SRVC-010 |
| Onboarding | `/onboarding` | Yes | Onboarding checklist with step resources | MKT-REQ-EXP-010, 011 |
| Error | `/error` | No | Generic error page | MKT-REQ-NFR-005 |

## 8.3 LWC Component Inventory

All components are prefixed `catalyst-` per CLAUDE.md naming convention. Each has a matching Jest test file.

| Component | Directory | Purpose | Used On |
| :---- | :---- | :---- | :---- |
| `catalyst-client-dashboard` | `lwc/catalystClientDashboard` | Container for home dashboard tiles | Home |
| `catalyst-subscription-tile` | `lwc/catalystSubscriptionTile` | Renewal date, ACV, tier badge | Home, Subscription |
| `catalyst-module-list` | `lwc/catalystModuleList` | Active module cards with status | Home, Subscription |
| `catalyst-open-cases-tile` | `lwc/catalystOpenCasesTile` | Count + link to recent open cases | Home |
| `catalyst-usage-heatmap` | `lwc/catalystUsageHeatmap` | Module engagement chart (30 days) | Home, Subscription |
| `catalyst-case-list` | `lwc/catalystCaseList` | Paginated case table, filter by status | Cases |
| `catalyst-case-form` | `lwc/catalystCaseForm` | Case submission with knowledge deflection panel | New Case |
| `catalyst-knowledge-deflection` | `lwc/catalystKnowledgeDeflection` | "Did this help?" panel surfaced in case form | New Case |
| `catalyst-case-detail` | `lwc/catalystCaseDetail` | Case view: status, comments thread, attachments | Case Detail |
| `catalyst-knowledge-search` | `lwc/catalystKnowledgeSearch` | Search input + article results | Knowledge |
| `catalyst-knowledge-article` | `lwc/catalystKnowledgeArticle` | Article renderer with breadcrumb | Article |
| `catalyst-onboarding-checklist` | `lwc/catalystOnboardingChecklist` | Step list with completion state + resource links | Onboarding, Home |
| `catalyst-aria-launcher` | `lwc/catalystAriaLauncher` | Agentforce embedded chat launcher (global footer) | All authenticated pages |

## 8.4 Data Access

Portal components access Salesforce data via **Wire adapters** and **Apex `@AuraEnabled` methods** — not direct SOQL in LWC. All Apex methods callable from the portal use `with sharing` and filter by `UserInfo.getUserId()` / related Account to enforce data isolation.

Key wire / Apex method pattern for case list:

```apex
// CasePortalController.cls
@AuraEnabled(cacheable=true)
public static List<Case> getPortalCases(String status) {
    Id accountId = [SELECT AccountId FROM User WHERE Id = :UserInfo.getUserId()].AccountId;
    return [
        SELECT Id, CaseNumber, Subject, Status, CreatedDate, LastModifiedDate
        FROM Case
        WHERE AccountId = :accountId
          AND (status == 'all' OR Status = :status)
        WITH USER_MODE
        ORDER BY LastModifiedDate DESC
        LIMIT 50
    ];
}
```

`WITH USER_MODE` enforces FLS and sharing rules at the query level — a mandatory pattern on all portal Apex (MKT-REQ-NFR-003, MKT-REQ-NFR-004).

---

# 9. Agentforce Design

## 9.1 Catalyst Client Assistant — "Aria"

### Agent Configuration

| Property | Value | Req. ID |
| :---- | :---- | :---- |
| Agent Name | Aria | MKT-REQ-EXP-012 |
| Agent Type | Service Agent (Einstein Copilot for Service) | |
| Deployment | Embedded in Experience Cloud LWR portal (all authenticated pages) | MKT-REQ-EXP-012 |
| Audience | Authenticated Customer Community Plus users | |
| Grounding | Salesforce Knowledge base + CRM data via Actions | MKT-REQ-EXP-012 |

### Agent Topic

| Property | Value |
| :---- | :---- |
| Topic Name | Client Self-Service |
| Scope | Help authenticated Catalyst clients with knowledge questions, case status, onboarding guidance, and escalation to human agents |
| Out of Scope | Pricing, contract negotiation, product roadmap, account changes |

### Agent Actions

| Action Name | Action Type | Description | Req. ID |
| :---- | :---- | :---- | :---- |
| `SearchKnowledge` | Knowledge Search Action | Queries Salesforce Knowledge; returns top 3 articles by relevance to the user's query | MKT-REQ-EXP-012, 013 |
| `GetCaseStatus` | Apex Action | Calls `AriaActionController.getCaseStatus()`; returns open cases for the authenticated user's Account with status and last activity | MKT-REQ-EXP-012, 013 |
| `GetOnboardingProgress` | Apex Action | Calls `AriaActionController.getOnboardingProgress()`; returns onboarding step completion percentage and next incomplete step | MKT-REQ-EXP-012, 013 |
| `EscalateToAgent` | Apex Action | Calls `AriaActionController.escalateToAgent()`; creates a Case draft with pre-populated Subject and Description from the conversation; routes to appropriate queue | MKT-REQ-EXP-013, 015 |

### System Prompt (excerpt)

```
You are Aria, the Catalyst client assistant. You help authenticated Catalyst clients
manage their subscription, understand their support cases, and navigate their
onboarding journey.

Tone: Professional, clear, and empathetic. Use plain language — avoid jargon.
      Acknowledge frustration when expressed. Never argue with the client.

Scope boundaries:
- Do NOT speculate about product features, pricing, or roadmap.
- Do NOT discuss other clients or their data.
- Do NOT make commitments on behalf of Catalyst's support or sales team.
- If a question falls outside your scope, say: "That's something a member of our team
  can help with directly." Then use EscalateToAgent.

Escalation instruction:
- If you cannot resolve the client's issue within 2 turns, proactively offer to
  escalate: "Would you like me to open a support case so a specialist can help?"
- Use EscalateToAgent to pre-populate the case — never ask the client to repeat
  information already shared in the conversation.
```

## 9.2 Meta-Portfolio Recruiter Agent

| Property | Value |
| :---- | :---- |
| Name | TBD — configured at portfolio public site launch |
| Location | Public Experience Cloud LWR site (unauthenticated) |
| Agent Topic | Portfolio Enquiry |
| Actions | GetVerticalSummary · GetSkillList · GetContactInfo · ScheduleInterview |
| Audience | Recruiters and hiring managers (no login required) |
| Status | Planned — designed after Catalyst vertical is complete |

---

# 10. Reporting & Dashboards

## 10.1 Sales Leadership Dashboard

**Audience:** VP of Sales, Sales Managers
**Refresh:** Real-time

| Component | Chart Type | Source Object | Key Fields |
| :---- | :---- | :---- | :---- |
| Pipeline by Stage | Funnel Chart | Opportunity | StageName, Amount — filtered to Open |
| Forecast vs Quota by Rep | Grouped Bar | Forecast / User | ForecastAmount vs Quota |
| Avg Deal Size by Module | Bar Chart | Opportunity + Products | OpportunityLineItem.Product2.Name, Amount |
| Avg Sales Cycle (Days) | Metric | Opportunity | DATEDIFF(CloseDate, CreatedDate) — Closed Won only |
| Win / Loss Rate by Quarter | Stacked Bar | Opportunity | StageName grouped by Quarter(CloseDate) |
| Open Pipeline Value | Metric (£ / $) | Opportunity | SUM(Amount) — Open stages |

## 10.2 Rep Performance Dashboard

**Audience:** Account Executives (filtered to running user)
**Refresh:** Real-time

| Component | Chart Type | Source | Key Fields |
| :---- | :---- | :---- | :---- |
| My Quota Attainment | Gauge | Forecast | Closed Won / Quota |
| My Open Pipeline | Table | Opportunity | Name, Stage, Amount, CloseDate — owner = me |
| Activities This Week | Bar vs Goal | Activity | Count of Tasks/Events this week vs weekly goal |
| Renewal Risk Accounts | Table | Account | Accounts with renewal within 90 days AND Health_Score__c < 40 |

## 10.3 Service SLA Dashboard

**Audience:** Support Team Lead, VP of Customer Success
**Refresh:** Hourly (scheduled report snapshot)

| Component | Chart Type | Source | Key Fields |
| :---- | :---- | :---- | :---- |
| Cases by Status | Donut Chart | Case | Status |
| SLA Compliance Rate by Tier | Grouped Bar | Case / Entitlement | MilestoneStatus grouped by SLA_Tier_at_Creation__c |
| Avg Resolution Time by Case Type | Bar Chart | Case | AVG(ClosedDate - CreatedDate) grouped by RecordType |
| Breach Count by Agent | Table | Case | OwnerId, COUNT(cases where milestone violated) |
| Case Volume Trend (90 days) | Line Chart | Case | COUNT(CreatedDate) grouped by week |

---

# 11. Testing Strategy

## 11.1 Coverage Requirements

- All Apex classes: minimum **85% line coverage** (MKT-REQ-NFR-006)
- Coverage verified in Salesforce Setup → Apex Test Execution
- Meaningful assertions required — `System.assert()` on every test method, not just coverage runs

## 11.2 TestDataFactory Design

`TestDataFactory` provides static builder methods for all objects. All test classes import from this factory exclusively — no inline `new Object__c()` with field assignments inside test methods.

```apex
// Representative methods
public class TestDataFactory {
    public static Account createCustomerAccount(String tier) { ... }
    public static Contact createContact(Account acct, String role) { ... }
    public static Lead createLead(String source, String areaOfInterest) { ... }
    public static Opportunity createOpportunity(Account acct, String stage) { ... }
    public static Case createCase(Account acct, String recordTypeName) { ... }
    public static Feedback_Survey__c createCsatSurvey(Case c, Integer score) { ... }
    public static User createPortalUser(Contact c, String permissionSet) { ... }
}
```

## 11.3 HttpCalloutMock Implementations

```apex
// Used in BillingAPIServiceTest and UsageAPIServiceTest
public class BillingAPISuccessMock implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setBody('{"status":"synced"}');
        return res;
    }
}

public class BillingAPIFailureMock implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(500);
        res.setBody('{"error":"Internal Server Error"}');
        return res;
    }
}
```

Both success and failure paths are tested. Failure path must not throw an uncaught exception — MKT-REQ-NFR-005.

---

# 12. Non-Functional Implementation

## 12.1 Performance (MKT-REQ-NFR-001, 002)

| Area | Implementation |
| :---- | :---- |
| Page load < 3s | LWC components lazy-load secondary data; cacheable wire adapters used where data is not real-time |
| SOQL limits | All queries outside loops; WHERE clauses always include a selective indexed field (Id, AccountId, CreatedDate) |
| DML limits | Apex handlers collect records from `Trigger.new` in Lists before DML; single DML per transaction |
| Async operations | Health score recalculation uses `@InvocableMethod` called from Flow (queued); billing sync uses scheduled batch |

## 12.2 Accessibility (MKT-REQ-NFR-007)

| Standard | Implementation |
| :---- | :---- |
| WCAG 2.1 AA | All LWC use SLDS 2 accessible primitives (`lightning-button`, `lightning-input`, etc.) |
| Colour contrast | SLDS 2 design tokens ensure minimum 4.5:1 contrast ratio |
| Keyboard navigation | No custom mouse-only interactions; all interactive elements reachable by Tab |
| Screen reader | `aria-label` and `aria-describedby` added to all custom components |
| Validation | Verified using browser Accessibility Insights / axe DevTools |

## 12.3 Governor Limit Strategy (MKT-REQ-NFR-002)

| Limit | Strategy |
| :---- | :---- |
| SOQL rows | All queries include LIMIT clauses; pagination on lists > 200 |
| DML statements | Batch all inserts/updates into Lists before DML |
| Callouts | All API callouts wrapped in try-catch; no callouts inside triggers (delegated to `@future` or Queueable) |
| CPU time | No nested loops in Apex; complex calculations use Map-based lookups |
| Heap | Large result sets use `Iterable<SObject>` in Batch Apex; not loaded into memory whole |

---

# 13. Deployment Sequence

All deployment steps use `sf project deploy start` from the relevant branch. Rollback procedure: retrieve pre-deployment snapshot, redeploy previous state.

| Phase | Contents | Dependencies |
| :---- | :---- | :---- |
| **Phase 1 — Security** | OWD settings, Role Hierarchy, Profiles, Permission Sets | None — must deploy before metadata that references permission sets |
| **Phase 2 — Data Model** | Custom Objects, Custom Fields on standard objects, Record Types, Validation Rules, Page Layouts | Phase 1 (profiles referenced in page layout assignments) |
| **Phase 3 — Automation: Flows** | All record-triggered and scheduled Flows | Phase 2 (flows reference fields and objects) |
| **Phase 4 — Automation: Apex** | ITriggerHandler, TriggerHandlerBase, Service classes, Trigger classes, Test classes | Phase 2 |
| **Phase 5 — Entitlements & Queues** | Entitlement Processes (3 tiers), SLA Milestones, Queues (5), Skills, Omni-Channel Routing Configs | Phase 2 (Case record types) |
| **Phase 6 — Approval Processes** | Quote Discount Approval Process | Phase 2 (Opportunity/Quote fields), Phase 1 (VP of Sales role) |
| **Phase 7 — Experience Cloud** | LWR site definition, Pages, LWC components, Portal profiles | Phase 1 (Portal Customer profile), Phase 2 (objects), Phase 4 (Apex controllers) |
| **Phase 8 — Agentforce** | Agent definition, Agent Topic, Actions, System Prompt | Phase 7 (portal deployment), Phase 4 (action Apex classes) |
| **Phase 9 — Reports & Dashboards** | Report types, Reports (8), Dashboards (3) | Phase 2 (all objects must exist) |
| **Phase 10 — Sample Data** | Synthetic data load (Accounts, Contacts, Leads, Opportunities, Cases, Articles, Portal Users) | All phases complete |

---

# 14. Requirements Traceability Matrix

| Req. ID | Requirement Summary | Design Section(s) |
| :---- | :---- | :---- |
| MKT-REQ-SALES-001 | Lead capture via web-to-lead | 4.1.1 (Lead fields) |
| MKT-REQ-SALES-002 | Lead assignment by source/geography | 6.1 (Lead_AfterSave_AssignmentRule), 6.4 (LeadService) |
| MKT-REQ-SALES-003 | Lead status picklist governance | 4.1.1 (Lead Status values), 4.3.1 (VR: Lead_QualifiedFieldsRequired) |
| MKT-REQ-SALES-004 | Einstein Lead Scoring | 4.1.1 (Lead_Score__c field) |
| MKT-REQ-SALES-005 | Conversion gate (Qualified + 3 activities) | 4.3.1 (VR: Lead_ConversionGate), 6.4 (LeadService activity counter) |
| MKT-REQ-SALES-006 | 48hr follow-up task | 6.1, 6.2.1 (Lead_AfterSave_FollowUpTask) |
| MKT-REQ-SALES-007 | Account record types | 4.1.2 (Account Record Types) |
| MKT-REQ-SALES-008 | Catalyst-specific Account fields | 4.1.2 (Account custom fields) |
| MKT-REQ-SALES-009 | Contact role at Catalyst field | 4.1.3 (Contact custom fields) |
| MKT-REQ-SALES-010 | Account Health Score | 4.1.2 (Health_Score__c), 6.4 (AccountHealthScoreService), 6.5 (algorithm) |
| MKT-REQ-SALES-011 | Duplicate Account domain flag | 4.1.2 (Duplicate_Domain_Flag__c), 6.4 (AccountTriggerHandler) |
| MKT-REQ-SALES-012 | Opportunity stage governance | 4.1.4 (Stage picklist and probabilities) |
| MKT-REQ-SALES-013 | Mandatory fields at Proposal Sent | 4.1.4 (Opp fields), 4.3.2 (VR: Opp_ProposalSentGate), 6.1 (Flow) |
| MKT-REQ-SALES-014 | Product catalogue and line items | 4.1.4 (Opportunity line items reference) |
| MKT-REQ-SALES-015 | PDF Quote + 15% discount approval | 6.6 (Approval Process), 6.1 (Opportunity_AfterSave_QuoteApproval) |
| MKT-REQ-SALES-016 | Loss Reason on Closed Lost | 4.1.4 (Loss_Reason__c, Loss_Notes__c), 4.3.2 (VR) |
| MKT-REQ-SALES-017 | Kanban view for AEs | Page layout / list view config (MDD-DD-1.0 detail) |
| MKT-REQ-SALES-018 | Collaborative Forecasting | 5.4 (Sales_Manager_Extended PSset), 10.1 (Dashboard) |
| MKT-REQ-SALES-019 | Sales Leadership Dashboard | 10.1 |
| MKT-REQ-SALES-020 | Rep Performance Dashboard | 10.2 |
| MKT-REQ-SRVC-001 | Multi-channel case creation | 4.1.5 (Case fields), 5.5 (queues) |
| MKT-REQ-SRVC-002 | Auto-link case to Account by email domain | 6.1, 6.2.1 (Case_AfterSave_AutoLinkAccount) |
| MKT-REQ-SRVC-003 | Case record types | 4.1.5 (Case Record Types) |
| MKT-REQ-SRVC-004 | Account context on case record | Page layout / Service Console config |
| MKT-REQ-SRVC-005 | Case status lifecycle + Resolution Summary | 4.1.5 (Case fields), 4.3.3 (VR: Case_ResolutionSummaryRequired) |
| MKT-REQ-SRVC-006 | CSAT gate before Closed | 4.3.3 (VR: Case_CSATGate), 6.1 (Case_AfterSave_CSATDispatch) |
| MKT-REQ-SRVC-007 | SLA entitlements by tier | 5.5 (Entitlement Processes), 6.1 (Case_AfterSave_EntitlementAssignment) |
| MKT-REQ-SRVC-008 | Automated escalation on SLA breach | 6.1, 6.2.2 (Case_Scheduled_EscalationCheck) |
| MKT-REQ-SRVC-009 | Service SLA Dashboard | 10.3 |
| MKT-REQ-SRVC-010 | Knowledge base with 4 article types | 8.3 (catalyst-knowledge-search, catalyst-knowledge-article) |
| MKT-REQ-SRVC-011 | Knowledge draft/review/publish workflow | Flow: Knowledge_AfterSave_ReviewWorkflow (standard Knowledge process) |
| MKT-REQ-SRVC-012 | Knowledge deflection on case submission | 8.3 (catalyst-knowledge-deflection) |
| MKT-REQ-SRVC-013 | Agent attach article to case response | Service Console quick action (standard Knowledge integration) |
| MKT-REQ-SRVC-014 | Case routing by record type and tier | 5.5 (Queues), 6.1 (Case_AfterSave_EntitlementAssignment routing step) |
| MKT-REQ-SRVC-015 | Skills-based Omni-Channel routing | 5.5 (Omni-Channel skills config, Phase 5 deployment) |
| MKT-REQ-SRVC-016 | Omni-Channel supervisor panel | 5.4 (Service_Manager_Extended), Service Console config |
| MKT-REQ-EXP-001 | Portal authentication + self-registration | 8.1, 8.2, 6.1 (Contact_AfterSave_PortalWelcomeEmail) |
| MKT-REQ-EXP-002 | Customer Community Plus data isolation | 5.1 (OWD), 5.3 (Portal Customer profile), 8.4 (WITH USER_MODE) |
| MKT-REQ-EXP-003 | Portal role-based access | 4.1.3 (Portal_User_Type__c), 4.2.5 (Portal_User_Group__c), 5.4 (PSets) |
| MKT-REQ-EXP-004 | Personalised client home dashboard | 8.2, 8.3 (catalyst-client-dashboard) |
| MKT-REQ-EXP-005 | Subscription summary page | 8.2, 8.3 (catalyst-subscription-tile, catalyst-module-list) |
| MKT-REQ-EXP-006 | Module usage heat map | 8.3 (catalyst-usage-heatmap), 7.2 (UsageAPIService) |
| MKT-REQ-EXP-007 | Case submission form | 8.2, 8.3 (catalyst-case-form) |
| MKT-REQ-EXP-008 | Case list + comments/attachments | 8.2, 8.3 (catalyst-case-list, catalyst-case-detail) |
| MKT-REQ-EXP-009 | Knowledge deflection on case form | 8.3 (catalyst-knowledge-deflection) |
| MKT-REQ-EXP-010 | Onboarding checklist | 8.2, 8.3 (catalyst-onboarding-checklist), 6.1 (Onboarding_Scheduled_ChecklistReminder) |
| MKT-REQ-EXP-011 | Onboarding step resource links | 8.3 (catalyst-onboarding-checklist — step resource links) |
| MKT-REQ-EXP-012 | Aria — core capabilities | 9.1 (Agent configuration, SearchKnowledge, GetCaseStatus) |
| MKT-REQ-EXP-013 | Aria — Agent Topic + 4 Actions | 9.1 (Agent Topic, Action inventory) |
| MKT-REQ-EXP-014 | Aria — persona and tone prompt | 9.1 (System Prompt) |
| MKT-REQ-EXP-015 | Aria — human escalation + case pre-population | 9.1 (EscalateToAgent action) |
| MKT-REQ-NFR-001 | Page load < 3s | 12.1 |
| MKT-REQ-NFR-002 | Apex governor safety | 12.3 |
| MKT-REQ-NFR-003 | Security — no injection / hardcoded creds | 5.6, 7.1, 7.2, 8.4 (WITH USER_MODE) |
| MKT-REQ-NFR-004 | Least privilege | 5.1–5.5 |
| MKT-REQ-NFR-005 | Graceful integration failure | 7.1, 7.2, 11.3 (failure mock) |
| MKT-REQ-NFR-006 | 85% Apex coverage + test factory | 6.4 (class inventory), 11.1, 11.2, 11.3 |
| MKT-REQ-NFR-007 | WCAG 2.1 AA | 12.2 |
| MKT-REQ-NFR-008 | 100% source control | 3.2 (API version), CLAUDE.md coding standards |

---

*MKT-TDD-1.0 is the authoritative technical specification for the Catalyst Salesforce implementation. All downstream build work, data dictionary entries, and test scripts reference the designs in this document. Update this document when design decisions change — do not build from an outdated version.*
