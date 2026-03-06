
**CATALYST MARKETING TECHNOLOGIES, INC.**

*Accelerate Every Campaign.*

**DATA DICTIONARY & ERD**

**Salesforce CRM Implementation**

Sales Cloud · Service Cloud · Experience Cloud

| Document ID | MKT-DD-1.0 |
| :---- | :---- |
| **Status** | DRAFT — In Progress |
| **Version** | 1.0 |
| **Vertical** | Marketing — Baseline |
| **Company** | Catalyst Marketing Technologies, Inc. |
| **Prepared By** | Portfolio Developer |
| **Date** | 2026 |
| **Parent Doc** | MKT-TDD-1.0 — Technical Design Document |
| **Traces From** | MKT-TDD-1.0 Section 4 (Data Model Design) |
| **Traces To** | MKT-TPQA-1.0 |

---

# Table of Contents

1. Document Control
2. Purpose & Scope
3. Entity Relationship Diagram
4. Naming Conventions
5. Standard Object Extensions
6. Custom Objects
7. Picklist Value Reference
8. Relationship Summary
9. Integration Field Reference
10. Data Governance Notes

---

# 1. Document Control

## 1.1 Version History

| Version | Date | Author | Changes | Status |
| :---- | :---- | :---- | :---- | :---- |
| 1.0 | 2026 | Portfolio Developer | Initial draft — full data dictionary | Draft |

## 1.2 How to Read This Document

- **Standard Object Extensions:** Only custom fields and governed picklist values are documented. Native Salesforce standard fields are not repeated unless they are specifically configured (renamed, required, or restricted).
- **Custom Objects:** All fields documented in full, including system fields.
- **Type notation:** `Text(n)` = max length n characters. `Number(p,s)` = p total digits, s decimal places. `Currency(p,s)` follows the same pattern. `Lookup(Object)` = lookup relationship. `MD(Object)` = master-detail relationship.
- **Required column:** "Yes" = Salesforce required. "VR" = enforced by Validation Rule (field itself is not required at API level). "UI" = required on page layout only.

---

# 2. Purpose & Scope

This Data Dictionary is the authoritative field-level reference for all Salesforce objects in the Catalyst CRM implementation. It supplements the Technical Design Document (MKT-TDD-1.0) with the specific configuration details needed to build and validate the data model:

- Precise field types, lengths, and precision values
- Required/unique/external ID flags
- Picklist value sets with API names
- Business descriptions and traceability to BRD requirements
- Indexing and performance notes
- Relationship cardinality for ERD validation

Developers building from this document should treat it as the ground truth for field configuration. Any deviation from these specifications during build must be logged as a change and this document updated accordingly.

---

# 3. Entity Relationship Diagram

## 3.1 Object Relationship Map

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        CATALYST CRM — OBJECT MODEL                          │
└─────────────────────────────────────────────────────────────────────────────┘

  ┌──────────┐
  │   Lead   │ ── converts to ──────────────────────────────────┐
  └──────────┘                                                  │
                                                                ▼
  ┌──────────────────────────────────────────────┐    ┌────────────────┐
  │                  Account                     │    │    Contact     │
  │  (Record Types: Prospect, Customer,          │◄───│                │
  │   Partner, Competitor)                       │    └────────────────┘
  │                                              │          │
  │  Subscription_Tier__c                        │          │ Lookup
  │  Modules_Purchased__c                        │          │
  │  Annual_Contract_Value__c                    │    ┌─────┴──────────────┐
  │  Contract_Renewal_Date__c                    │    │  Feedback_Survey__c│
  │  Health_Score__c                             │    └────────────────────┘
  └──────────────────────────────────────────────┘
        │ 1                  │ 1          │ 1
        │                    │            │
        │ M                  │ M          │ M
        ▼                    ▼            ▼
  ┌───────────┐    ┌─────────────────┐  ┌──────────────────────┐
  │Opportunity│    │      Case       │  │    Asset_Item__c      │
  │           │    │ (Record Types:  │  │  (MD → Account)       │
  │ Stages:   │    │  Technical,     │  │                       │
  │ Discovery │    │  Billing,       │  │  Module__c            │
  │ Eval      │    │  Onboarding,    │  │  Status__c            │
  │ Proposal  │    │  Feature,       │  │  Activation_Date__c   │
  │ Negotiation│   │  General)       │  └──────────────────────┘
  │ Closed Won│    │                 │
  │ Closed Lost│   │ SLA_Tier_       │  ┌──────────────────────┐
  └───────────┘    │ at_Creation__c  │  │   Project__c          │
        │ 1        └─────────────────┘  │  (MD → Account)       │
        │ M              │ 1            │  Opportunity__c (lkp) │
        ▼                │ M            └──────────────────────┘
  ┌──────────┐           ▼
  │  Quote   │    ┌─────────────────┐  ┌──────────────────────┐
  │          │    │Feedback_Survey__c│  │ Portal_User_Group__c  │
  └──────────┘    │  CSAT / NPS     │  │  (MD → Account)       │
                  └─────────────────┘  │  Contact__c (lkp)     │
                                       └──────────────────────┘

                                       ┌──────────────────────┐
                                       │  Service_Region__c    │
                                       │  (Lookup → Account)   │
                                       └──────────────────────┘
```

## 3.2 Relationship Cardinality Summary

| Parent Object | Child Object | Relationship Type | Cardinality |
| :---- | :---- | :---- | :---- |
| Account | Contact | Standard (Lookup) | 1:Many |
| Account | Opportunity | Standard (Lookup) | 1:Many |
| Account | Case | Standard (Lookup) | 1:Many |
| Account | Asset_Item__c | Master-Detail | 1:Many |
| Account | Project__c | Master-Detail | 1:Many |
| Account | Portal_User_Group__c | Master-Detail | 1:Many |
| Account | Service_Region__c | Lookup | 1:Many |
| Contact | Feedback_Survey__c | Lookup | 1:Many |
| Contact | Portal_User_Group__c | Lookup | 1:Many |
| Case | Feedback_Survey__c | Lookup | 1:Many |
| Opportunity | Quote | Standard | 1:Many |
| Opportunity | Project__c | Lookup | Many:1 |
| Lead | Account / Contact / Opportunity | Convert (system) | 1:1 on convert |

---

# 4. Naming Conventions

## 4.1 Field API Name Patterns

| Pattern | Example | Notes |
| :---- | :---- | :---- |
| Custom field suffix | `__c` | All custom fields and objects |
| Abbreviate where standard | `ACV` not `Annual_Contract_Value` | Only for widely-understood acronyms |
| Boolean fields prefix | `Is_` or past tense verb | `Is_Portal_Active__c`, `CSAT_Sent__c` |
| Date fields suffix | `_Date__c` or `_Date_Time__c` | `Contract_Renewal_Date__c`, `Sent_Date__c` |
| Lookup fields: singular noun | `Account__c`, `Contact__c` | Matches the related object name |
| Score fields suffix | `_Score__c` | `Health_Score__c`, `CSAT_Score__c` |
| Count fields suffix | `_Count__c` | `Open_Case_Count__c`, `Activity_Count__c` |
| External ID fields suffix | `_ID__c` | `Billing_Account_ID__c` |

## 4.2 Object API Name Patterns

| Pattern | Example |
| :---- | :---- |
| PascalCase noun + `__c` | `Asset_Item__c`, `Feedback_Survey__c` |
| Core layer prefix: none (generic names) | `Project__c` not `Catalyst_Project__c` |
| Describe the entity, not the vertical | `Portal_User_Group__c` not `Catalyst_Portal_Group__c` |

## 4.3 Record Type Developer Names

`PascalCase`, no spaces, no underscores: `TechnicalSupport`, `BillingEnquiry`, `Customer`, `ClosedWon`

---

# 5. Standard Object Extensions

## 5.1 Lead

### 5.1.1 Custom Fields

| Field Label | API Name | Type | Required | Unique | Default | Indexed | Description | Req. ID |
| :---- | :---- | :---- | :---- | :---- | :---- | :---- | :---- | :---- |
| Area of Interest | `Area_of_Interest__c` | Multi-Select Picklist | No | — | — | No | Catalyst Platform modules the lead has expressed interest in. Values: see Section 7.1. | MKT-REQ-SALES-001 |
| Lead Score | `Lead_Score__c` | Number(3,0) | No | No | — | No | Einstein Lead Scoring output. Range 0–100. Populated by Einstein; read-only on page layout. | MKT-REQ-SALES-004 |
| Activity Count | `Activity_Count__c` | Number(4,0) | No | No | 0 | No | Count of related Tasks and Events. Maintained by `LeadService` Apex on Task/Event insert. Used by conversion gate validation rule. | MKT-REQ-SALES-005 |

### 5.1.2 Governed Standard Fields

| Field Label | API Name | Type | Notes |
| :---- | :---- | :---- | :---- |
| Lead Source | `LeadSource` | Picklist | Values extended — see Section 7.2. |
| Status | `Status` | Picklist | Replaced with governed values — see Section 7.3. Conversion allowed only from `Qualified`. |
| Rating | `Rating` | Picklist | Retained as standard. Values: Hot, Warm, Cold. |

### 5.1.3 Record Types

Lead uses no custom record types. All leads follow the same layout. SDR routing is by Lead Source and geography (assignment rules), not record type.

---

## 5.2 Account

### 5.2.1 Custom Fields

| Field Label | API Name | Type | Required | Unique | Default | Indexed | Description | Req. ID |
| :---- | :---- | :---- | :---- | :---- | :---- | :---- | :---- | :---- |
| Subscription Tier | `Subscription_Tier__c` | Picklist | Yes (for Customer RT) | No | — | Yes | Client subscription tier. Drives SLA entitlement assignment and case routing. Values: see Section 7.4. | MKT-REQ-SALES-008 |
| Modules Purchased | `Modules_Purchased__c` | Multi-Select Picklist | No | — | — | No | Catalyst Platform modules under active licence. Values: see Section 7.1. | MKT-REQ-SALES-008 |
| Contract Renewal Date | `Contract_Renewal_Date__c` | Date | No | No | — | Yes | Date of next contract renewal. Used in Health Score calculation and Rep Performance Dashboard renewal risk filter. | MKT-REQ-SALES-008 |
| Annual Contract Value | `Annual_Contract_Value__c` | Currency(18,2) | No | No | — | No | Annualised subscription value, excluding professional services. | MKT-REQ-SALES-008 |
| Primary Platform Contact | `Primary_Platform_Contact__c` | Lookup(Contact) | No | No | — | No | The client's primary technical point of contact for the Catalyst Platform. | MKT-REQ-SALES-008 |
| Health Score | `Health_Score__c` | Number(3,0) | No | No | — | No | Composite score 0–100 calculated by `AccountHealthScoreService`. Derived from CSAT, case volume, usage index, and renewal proximity. Read-only on page layout. | MKT-REQ-SALES-010 |
| CSAT Average | `CSAT_Average__c` | Roll-Up Summary | — | — | — | — | AVG of `Feedback_Survey__c.CSAT_Score__c` where Survey_Type__c = CSAT and Status = Completed. Input to Health Score. | MKT-REQ-SALES-010 |
| Open Case Count | `Open_Case_Count__c` | Roll-Up Summary | — | — | — | — | COUNT of related Cases where Status NOT IN (Resolved, Closed). Input to Health Score. | MKT-REQ-SALES-010 |
| Platform Usage Index | `Platform_Usage_Index__c` | Number(5,2) | No | No | — | No | Normalised platform engagement score 0–100. Populated nightly by `UsageAPIService` scheduled job. Input to Health Score. | MKT-REQ-SALES-010 |
| Billing Account ID | `Billing_Account_ID__c` | Text(50) | No | Yes | — | Yes | External system key for billing integration. Set on account creation. External ID = true. | MKT-REQ-NFR-008 |
| Duplicate Domain Flag | `Duplicate_Domain_Flag__c` | Checkbox | — | — | false | No | Set by `AccountTriggerHandler` when a new account is created with a Website domain that matches an existing account. Triggers duplicate review notification. | MKT-REQ-SALES-011 |

### 5.2.2 Record Types

| Developer Name | Label | Page Layout | Key Fields Surfaced |
| :---- | :---- | :---- | :---- |
| `Prospect` | Prospect | Prospect_Layout | Industry, Annual Revenue, Lead Source, Lead Score (related leads) |
| `Customer` | Customer | Customer_Layout | Subscription_Tier__c, Modules_Purchased__c, Annual_Contract_Value__c, Contract_Renewal_Date__c, Health_Score__c, Primary_Platform_Contact__c |
| `Partner` | Partner | Partner_Layout | Partner type picklist (future field), primary contact |
| `Competitor` | Competitor | Competitor_Layout | Industry, annual revenue (Dunn & Bradstreet), notes |

---

## 5.3 Contact

### 5.3.1 Custom Fields

| Field Label | API Name | Type | Required | Unique | Default | Indexed | Description | Req. ID |
| :---- | :---- | :---- | :---- | :---- | :---- | :---- | :---- | :---- |
| Role at Catalyst | `Role_at_Catalyst__c` | Picklist | No | No | — | No | The contact's buying or influence role in the Catalyst relationship. Used for multi-threading strategy. Values: see Section 7.5. | MKT-REQ-SALES-009 |
| Portal User Type | `Portal_User_Type__c` | Picklist | No | No | — | No | Governs portal permission set assignment on user provisioning. Values: Account Admin; Standard User. | MKT-REQ-EXP-003 |
| Portal Active | `Is_Portal_Active__c` | Checkbox | — | — | false | No | True when a Customer Community Plus user record exists and is active for this contact. Updated by `Contact_AfterSave_PortalWelcomeEmail` flow. | MKT-REQ-EXP-001 |
| Portal Welcome Sent | `Portal_Welcome_Sent__c` | Checkbox | — | — | false | No | Prevents duplicate welcome emails. Set to true after welcome email dispatch. | MKT-REQ-EXP-001 |

---

## 5.4 Opportunity

### 5.4.1 Custom Fields

| Field Label | API Name | Type | Required | Unique | Default | Indexed | Description | Req. ID |
| :---- | :---- | :---- | :---- | :---- | :---- | :---- | :---- | :---- |
| Contract Length | `Contract_Length__c` | Picklist | VR | No | — | No | Length of proposed subscription term. Required before advancing to Proposal Sent. Values: see Section 7.6. | MKT-REQ-SALES-013 |
| Decision Date | `Decision_Date__c` | Date | VR | No | — | No | Anticipated date of client purchase decision. Required before advancing to Proposal Sent. Must not be in the past. | MKT-REQ-SALES-013 |
| Economic Buyer | `Economic_Buyer__c` | Lookup(Contact) | VR | No | — | No | The contact with budget authority. Must be a contact on the related Account. Required before advancing to Proposal Sent. | MKT-REQ-SALES-013 |
| Loss Reason | `Loss_Reason__c` | Picklist | VR | No | — | No | Mandatory on Closed Lost. Values: see Section 7.7. | MKT-REQ-SALES-016 |
| Loss Notes | `Loss_Notes__c` | Long Text Area(2000) | No | — | — | No | Optional free-text context for loss analysis. Visible to Sales Manager and above. | MKT-REQ-SALES-016 |
| Proposed ACV | `Proposed_ACV__c` | Currency(18,2) | No | No | — | No | Formula: `SUMPRODUCT` of opportunity line item quantities and unit prices. Read-only. | MKT-REQ-SALES-014 |
| Max Discount Pct | `Max_Discount_Pct__c` | Percent(5,2) | No | No | — | No | Formula: MAX discount percentage across all quote line items on the primary quote. Triggers approval process if > 15%. | MKT-REQ-SALES-015 |

### 5.4.2 Stage Configuration

| Stage Name | API Value | Probability | Forecast Category | Stage Description |
| :---- | :---- | :---- | :---- | :---- |
| Discovery | `Discovery` | 10 | Pipeline | Initial qualification; need and budget confirmed in outline |
| Technical Evaluation | `Technical Evaluation` | 25 | Pipeline | Technical fit assessment, POC, or demo in progress |
| Proposal Sent | `Proposal Sent` | 50 | Best Case | Formal quote sent; Contract_Length__c, Decision_Date__c, Economic_Buyer__c required |
| Negotiation | `Negotiation` | 75 | Best Case | Quote accepted in principle; legal or procurement review underway |
| Closed Won | `Closed Won` | 100 | Closed | Contract signed; triggers Account record type conversion to Customer |
| Closed Lost | `Closed Lost` | 0 | Omitted | Loss_Reason__c required; opportunity archived |

---

## 5.5 Case

### 5.5.1 Custom Fields

| Field Label | API Name | Type | Required | Unique | Default | Indexed | Description | Req. ID |
| :---- | :---- | :---- | :---- | :---- | :---- | :---- | :---- | :---- |
| Affected Module | `Affected_Module__c` | Multi-Select Picklist | No | — | — | No | Catalyst Platform module(s) involved in the issue. Surfaced on portal submission form. Values: see Section 7.1. | MKT-REQ-EXP-007 |
| Urgency | `Urgency__c` | Picklist | No | No | Medium | No | Client-selected urgency. Influences routing within a tier. Values: see Section 7.8. | MKT-REQ-EXP-007 |
| CSAT Sent | `CSAT_Sent__c` | Checkbox | — | — | false | No | Set to true by `Case_AfterSave_CSATDispatch` flow when Status changes to Resolved. Validated by `Case_CSATGate` VR before Closed. | MKT-REQ-SRVC-006 |
| Resolution Summary | `Resolution_Summary__c` | Long Text Area(2000) | VR | — | — | No | Required before Status = Resolved. Describes resolution action taken. | MKT-REQ-SRVC-005 |
| SLA Tier at Creation | `SLA_Tier_at_Creation__c` | Text(50) | No | No | — | No | Snapshot of the related Account's Subscription_Tier__c at case creation time. Stored as text to preserve historical SLA tier even if account tier changes. | MKT-REQ-SRVC-007 |
| Auto Link Status | `Auto_Link_Status__c` | Picklist | No | No | Not Applicable | No | Set by `Case_AfterSave_AutoLinkAccount` flow. Values: see Section 7.9. | MKT-REQ-SRVC-002 |

### 5.5.2 Status Configuration

| Status Value | API Value | Terminal? | Notes |
| :---- | :---- | :---- | :---- |
| New | `New` | No | Default on creation |
| Awaiting Agent | `Awaiting Agent` | No | Set by routing flow after queue assignment |
| In Progress | `In Progress` | No | Agent is actively working |
| Awaiting Customer | `Awaiting Customer` | No | Pending client response; SLA paused |
| On Hold | `On Hold` | No | Blocked by internal dependency |
| Resolved | `Resolved` | No | Requires Resolution_Summary__c; triggers CSAT dispatch |
| Closed | `Closed` | Yes | Requires CSAT_Sent__c = true |

### 5.5.3 Record Types

| Developer Name | Label | Entry Point | Key Routing | Req. ID |
| :---- | :---- | :---- | :---- | :---- |
| `Technical_Support` | Technical Support | All channels | Technical_Support_Queue; skill: Technical_Support | MKT-REQ-SRVC-003 |
| `Billing_Enquiry` | Billing Enquiry | Portal, Email, Manual | Billing_Enquiry_Queue; skill: Billing | MKT-REQ-SRVC-003 |
| `Onboarding_Request` | Onboarding Request | Portal, Manual | Onboarding_Queue; skill: Onboarding_Specialist | MKT-REQ-SRVC-003 |
| `Feature_Request` | Feature Request | Portal, Manual | General_Enquiry_Queue | MKT-REQ-SRVC-003 |
| `General_Enquiry` | General Enquiry | All channels | General_Enquiry_Queue | MKT-REQ-SRVC-003 |

---

## 5.6 Quote

Standard Salesforce Quote object is used (no full CPQ managed package). The following configurations apply:

| Configuration | Detail | Req. ID |
| :---- | :---- | :---- |
| Synced to Opportunity | Yes — primary quote syncs `Amount` back to Opportunity | MKT-REQ-SALES-014 |
| Custom field: Max Discount % | Calculated on Quote: MAX of `QuoteLineItem.Discount` | MKT-REQ-SALES-015 |
| PDF template | Catalyst-branded Visualforce Quote template with logo, line items, discount, ACV, and terms | MKT-REQ-SALES-015 |
| Approval trigger | `Opportunity_AfterSave_QuoteApproval` flow monitors `Max_Discount_Pct__c` > 15 | MKT-REQ-SALES-015 |

---

# 6. Custom Objects

## 6.1 Project__c

**Purpose:** Active client delivery engagements linked to Accounts and Opportunities. Core layer — present in all verticals.

**OWD:** Private | **Sharing:** Via Account role hierarchy | **Relationship:** Master-Detail to Account

### System Fields (auto-created by Salesforce)

| Field Label | API Name | Type | Notes |
| :---- | :---- | :---- | :---- |
| Record ID | `Id` | ID(18) | System-generated |
| Created By | `CreatedById` | Lookup(User) | |
| Created Date | `CreatedDate` | DateTime | |
| Last Modified By | `LastModifiedById` | Lookup(User) | |
| Last Modified Date | `LastModifiedDate` | DateTime | |
| Owner | `OwnerId` | Lookup(User) | Project Manager is a separate custom field |

### Custom Fields

| Field Label | API Name | Type | Required | Unique | Default | Indexed | Description |
| :---- | :---- | :---- | :---- | :---- | :---- | :---- | :---- |
| Project Name | `Name` | Text(80) | Yes | No | — | Yes | Descriptive project title. Format: "{Account Name} — {Engagement Type}" |
| Account | `Account__c` | MD(Account) | Yes | No | — | Yes | Master-detail parent. Cascade-deletes project on account deletion. |
| Opportunity | `Opportunity__c` | Lookup(Opportunity) | No | No | — | No | Originating opportunity. Optional — projects can exist without an open opp. |
| Status | `Status__c` | Picklist | Yes | No | Planning | No | Current project lifecycle state. Values: see Section 7.10. |
| Start Date | `Start_Date__c` | Date | No | No | — | No | Planned or actual project commencement date. |
| End Date | `End_Date__c` | Date | No | No | — | No | Planned or actual project completion date. Must be >= Start_Date__c (enforced by VR). |
| Project Manager | `Project_Manager__c` | Lookup(User) | No | No | — | No | Internal Catalyst staff member responsible for delivery. |
| Description | `Description__c` | Long Text Area(5000) | No | — | — | No | Scope summary, objectives, and key deliverables. |

---

## 6.2 Service_Region__c

**Purpose:** Geographic service regions for account segmentation and routing reference. Core layer.

**OWD:** Public Read Only | **Sharing:** Open read | **Relationship:** Lookup to Account

### Custom Fields

| Field Label | API Name | Type | Required | Unique | Default | Indexed | Description |
| :---- | :---- | :---- | :---- | :---- | :---- | :---- | :---- |
| Region Name | `Name` | Text(80) | Yes | No | — | Yes | Descriptive region label. Format: "{Region} — {Sub-region}" e.g. "North America — West" |
| Account | `Account__c` | Lookup(Account) | No | No | — | Yes | Related account. Optional — regions can be defined independently of any account. |
| Region | `Region__c` | Picklist | Yes | No | — | No | Top-level geographic grouping. Values: see Section 7.11. |
| Country | `Country__c` | Text(80) | No | No | — | No | Country (ISO 3166-1 name). |
| State / Province | `State_Province__c` | Text(80) | No | No | — | No | State or province where applicable. |
| Primary Contact | `Primary_Contact__c` | Lookup(Contact) | No | No | — | No | Account-side point of contact for this region. |

---

## 6.3 Asset_Item__c

**Purpose:** Individual Catalyst Platform module licences held by a client Account. Populated on contract signature and updated on renewal or module change. Core layer.

**OWD:** Private | **Sharing:** Via Account master-detail | **Relationship:** Master-Detail to Account

### Custom Fields

| Field Label | API Name | Type | Required | Unique | Default | Indexed | Description |
| :---- | :---- | :---- | :---- | :---- | :---- | :---- | :---- |
| Asset Name | `Name` | Auto-Number | — | — | ASSET-{0000} | Yes | System-generated. Format: ASSET-0001. |
| Account | `Account__c` | MD(Account) | Yes | No | — | Yes | Master-detail parent. |
| Contact | `Contact__c` | Lookup(Contact) | No | No | — | No | Primary contact responsible for this asset. |
| Asset Type | `Asset_Type__c` | Picklist | Yes | No | Module Licence | No | Classification of the asset. Values: see Section 7.12. |
| Module | `Module__c` | Picklist | No | No | — | No | Specific Catalyst Platform module. Required when Asset_Type__c = Module Licence. Values: see Section 7.1 (modules). |
| Status | `Status__c` | Picklist | Yes | No | Pending Activation | No | Lifecycle state of the asset. Values: see Section 7.13. |
| Activation Date | `Activation_Date__c` | Date | No | No | — | No | Date the module was activated in the client's environment. |
| Expiry Date | `Expiry_Date__c` | Date | No | No | — | No | Date the licence expires. Should match Contract_Renewal_Date__c on parent Account. |
| Licence Key | `Licence_Key__c` | Text(255), Encrypted | No | No | — | No | Platform-generated licence key. Encrypted field — not readable in API by standard users. Never surfaced in portal. |

---

## 6.4 Feedback_Survey__c

**Purpose:** CSAT and NPS survey responses linked to Cases and Contacts. Feeds Account Health Score calculation. Core layer.

**OWD:** Private | **Sharing:** Case owner + Service Manager | **Relationship:** Lookup to Case, Lookup to Contact

### Custom Fields

| Field Label | API Name | Type | Required | Unique | Default | Indexed | Description |
| :---- | :---- | :---- | :---- | :---- | :---- | :---- | :---- |
| Survey Reference | `Name` | Auto-Number | — | — | SURVEY-00001 | Yes | System-generated. Five digits zero-padded. |
| Contact | `Contact__c` | Lookup(Contact) | No | No | — | Yes | Survey recipient. May be null for anonymous NPS. |
| Case | `Case__c` | Lookup(Case) | No | No | — | Yes | Source case for CSAT surveys. Null for standalone NPS campaigns. |
| Survey Type | `Survey_Type__c` | Picklist | Yes | No | — | No | Classification of the survey. Values: see Section 7.14. |
| Status | `Status__c` | Picklist | Yes | No | Sent | No | Completion state. Values: see Section 7.15. |
| Sent Date | `Sent_Date__c` | DateTime | No | No | — | No | Timestamp when survey was dispatched. Set by `Case_AfterSave_CSATDispatch` flow. |
| Completed Date | `Completed_Date__c` | DateTime | No | No | — | No | Timestamp when survey was submitted. |
| CSAT Score | `CSAT_Score__c` | Number(1,0) | No | No | — | No | Client satisfaction score 1–5. Validated by `Survey_CSATRange` VR. 1 = Very Dissatisfied, 5 = Very Satisfied. |
| NPS Score | `NPS_Score__c` | Number(2,0) | No | No | — | No | Net Promoter Score 0–10. Validated by `Survey_NPSRange` VR. |
| Comments | `Comments__c` | Long Text Area(2000) | No | — | — | No | Optional free-text response from client. Surfaced on Account and Case page layouts for Service Manager. |

---

## 6.5 Portal_User_Group__c

**Purpose:** Defines portal user roles within an Account. Used to distinguish Account Admin users (who can manage other users and view billing) from Standard Users (case management and knowledge only). Core layer.

**OWD:** Private | **Sharing:** Via Account master-detail | **Relationship:** Master-Detail to Account, Lookup to Contact

### Custom Fields

| Field Label | API Name | Type | Required | Unique | Default | Indexed | Description |
| :---- | :---- | :---- | :---- | :---- | :---- | :---- | :---- |
| Group Name | `Name` | Text(80) | Yes | No | — | Yes | Format: "{Account Name} — {Portal_Role__c}" |
| Account | `Account__c` | MD(Account) | Yes | No | — | Yes | Master-detail parent. |
| Contact | `Contact__c` | Lookup(Contact) | Yes | No | — | Yes | The Contact whose portal access this record governs. 1:1 with portal user. |
| Portal Role | `Portal_Role__c` | Picklist | Yes | No | Standard User | No | Determines permission set assignment on user provisioning. Values: see Section 7.16. |
| Is Active | `Is_Active__c` | Checkbox | — | — | true | No | False when a user's portal access is suspended. Drives permission set removal in de-provisioning flow. |
| Last Login | `Last_Login__c` | DateTime | No | No | — | No | Populated by a login flow or platform event on Experience Cloud login. Used for adoption reporting. |

---

# 7. Picklist Value Reference

## 7.1 Catalyst Platform Modules

Used in: `Area_of_Interest__c` (Lead), `Modules_Purchased__c` (Account), `Affected_Module__c` (Case), `Module__c` (Asset_Item__c)

| Display Label | API Value |
| :---- | :---- |
| Campaign Intelligence | `Campaign_Intelligence` |
| Audience Studio | `Audience_Studio` |
| Attribution Engine | `Attribution_Engine` |
| Content Hub | `Content_Hub` |

## 7.2 Lead Source

Extends standard Salesforce LeadSource picklist with Catalyst-specific values:

| Display Label | API Value |
| :---- | :---- |
| Web — Organic | `Web_Organic` |
| Web — Paid Search | `Web_Paid_Search` |
| Web — Paid Social | `Web_Paid_Social` |
| Event — Conference | `Event_Conference` |
| Event — Webinar | `Event_Webinar` |
| Partner Referral | `Partner_Referral` |
| Customer Referral | `Customer_Referral` |
| Outbound — SDR | `Outbound_SDR` |
| Outbound — Executive | `Outbound_Executive` |
| Content Download | `Content_Download` |
| Free Trial | `Free_Trial` |
| Other | `Other` |

## 7.3 Lead Status

Replaces default Salesforce Lead Status values:

| Display Label | API Value | Converted Eligible |
| :---- | :---- | :---- |
| New | `New` | No |
| Attempting Contact | `Attempting_Contact` | No |
| Contacted | `Contacted` | No |
| Qualified | `Qualified` | Yes |
| Unqualified | `Unqualified` | No |
| Converted | `Converted` | — (system-set) |

## 7.4 Account Subscription Tier

| Display Label | API Value | SLA Profile |
| :---- | :---- | :---- |
| Starter | `Starter` | 8hr / 5 business day |
| Professional | `Professional` | 4hr / 2 business day |
| Enterprise | `Enterprise` | 1hr / 4hr (24/7) |

## 7.5 Contact Role at Catalyst

| Display Label | API Value |
| :---- | :---- |
| Economic Buyer | `Economic_Buyer` |
| Technical Evaluator | `Technical_Evaluator` |
| Champion | `Champion` |
| End User | `End_User` |
| Detractor | `Detractor` |

## 7.6 Opportunity Contract Length

| Display Label | API Value |
| :---- | :---- |
| 12 Months | `12_Months` |
| 24 Months | `24_Months` |
| 36 Months | `36_Months` |

## 7.7 Opportunity Loss Reason

| Display Label | API Value |
| :---- | :---- |
| Competitor — Named | `Competitor_Named` |
| Price | `Price` |
| Timing | `Timing` |
| No Decision | `No_Decision` |
| Product Gap | `Product_Gap` |

## 7.8 Case Urgency

| Display Label | API Value | Notes |
| :---- | :---- | :---- |
| Low | `Low` | Informational; no production impact |
| Medium | `Medium` | Default; partial functionality impacted |
| High | `High` | Significant business impact |
| Critical | `Critical` | Complete production outage |

## 7.9 Case Auto Link Status

| Display Label | API Value |
| :---- | :---- |
| Linked | `Linked` |
| Pending Manual Review | `Pending_Manual_Review` |
| Not Applicable | `Not_Applicable` |

## 7.10 Project Status

| Display Label | API Value |
| :---- | :---- |
| Planning | `Planning` |
| Active | `Active` |
| On Hold | `On_Hold` |
| Completed | `Completed` |
| Cancelled | `Cancelled` |

## 7.11 Service Region

| Display Label | API Value |
| :---- | :---- |
| North America | `North_America` |
| EMEA | `EMEA` |
| APAC | `APAC` |
| LATAM | `LATAM` |

## 7.12 Asset Type

| Display Label | API Value |
| :---- | :---- |
| Module Licence | `Module_Licence` |
| Professional Service | `Professional_Service` |
| Training | `Training` |

## 7.13 Asset Status

| Display Label | API Value |
| :---- | :---- |
| Pending Activation | `Pending_Activation` |
| Active | `Active` |
| Inactive | `Inactive` |
| Expired | `Expired` |

## 7.14 Survey Type

| Display Label | API Value | Use Case |
| :---- | :---- | :---- |
| CSAT | `CSAT` | Post-case resolution satisfaction (1–5 scale) |
| NPS | `NPS` | Quarterly relationship health (0–10 scale) |
| Onboarding | `Onboarding` | Post-onboarding completion feedback |

## 7.15 Survey Status

| Display Label | API Value |
| :---- | :---- |
| Sent | `Sent` |
| Completed | `Completed` |
| Expired | `Expired` |

## 7.16 Portal Role

| Display Label | API Value | Permission Set Assigned |
| :---- | :---- | :---- |
| Account Admin | `Account_Admin` | `Portal_Account_Admin` |
| Standard User | `Standard_User` | `Portal_Standard_User` |

---

# 8. Relationship Summary

| Relationship | Type | Delete Behaviour | Cascade | Notes |
| :---- | :---- | :---- | :---- | :---- |
| Account → Asset_Item__c | Master-Detail | Cascade delete | Yes | Asset_Item__c cannot exist without Account |
| Account → Project__c | Master-Detail | Cascade delete | Yes | Project__c cannot exist without Account |
| Account → Portal_User_Group__c | Master-Detail | Cascade delete | Yes | Group membership tied to Account |
| Account → Contact | Standard Lookup | Don't delete (blocked) | No | Standard Salesforce behaviour |
| Account → Opportunity | Standard Lookup | Don't delete (blocked) | No | Standard Salesforce behaviour |
| Account → Case | Standard Lookup | Don't delete (blocked) | No | Standard Salesforce behaviour |
| Account → Service_Region__c | Lookup | Set null on delete | No | Region records persist independently |
| Contact → Feedback_Survey__c | Lookup | Set null on delete | No | Survey history preserved |
| Case → Feedback_Survey__c | Lookup | Set null on delete | No | Survey preserved for reporting |
| Opportunity → Project__c | Lookup | Set null on delete | No | Project survives opportunity closure |

---

# 9. Integration Field Reference

Fields that serve as keys or data conduits for external system integrations.

## 9.1 Billing System Integration (BillingAPIService)

| Object | Field | API Name | Type | Direction | Notes |
| :---- | :---- | :---- | :---- | :---- | :---- |
| Account | Billing Account ID | `Billing_Account_ID__c` | Text(50), External ID, Unique, Indexed | Outbound key | Used as the identifier in PUT requests to the billing system |
| Account | Annual Contract Value | `Annual_Contract_Value__c` | Currency(18,2) | Outbound | Synced to billing on contract change |
| Account | Contract Renewal Date | `Contract_Renewal_Date__c` | Date | Outbound | Synced on renewal update |
| Account | Subscription Tier | `Subscription_Tier__c` | Picklist | Outbound | Tier change triggers billing update |

## 9.2 Usage API Integration (UsageAPIService)

| Object | Field | API Name | Type | Direction | Notes |
| :---- | :---- | :---- | :---- | :---- | :---- |
| Account | Billing Account ID | `Billing_Account_ID__c` | Text(50) | Outbound key | Query parameter in GET request to usage API |
| Account | Platform Usage Index | `Platform_Usage_Index__c` | Number(5,2) | Inbound | Updated nightly from API response; input to Health Score |

## 9.3 Named Credentials

| Name | Auth Type | Used By |
| :---- | :---- | :---- |
| `BillingSystem_NC` | Basic Auth (placeholder) | BillingAPIService |
| `UsageAPI_NC` | API Key Header (placeholder) | UsageAPIService |

Both Named Credentials store no secrets in source control. Values are configured in the org Settings post-deployment. See MKT-TDD-1.0 Section 7 for full integration design.

---

# 10. Data Governance Notes

## 10.1 Field-Level Security Principles

All custom fields follow the least-privilege model defined in MKT-TDD-1.0 Section 5:

- **Sensitive fields** (`Licence_Key__c`, `Annual_Contract_Value__c`, `Loss_Notes__c`) are hidden from portal profiles and restricted to internal roles via FLS on permission sets
- **Read-only computed fields** (`Health_Score__c`, `CSAT_Average__c`, `Open_Case_Count__c`, `Platform_Usage_Index__c`, `Proposed_ACV__c`) are set as read-only on all page layouts and cannot be edited via UI
- **Encrypted fields** (`Licence_Key__c`) are never returned in SOQL by standard users; require the `View Encrypted Data` permission

## 10.2 Indexed Fields

Fields marked as Indexed in the field tables above are flagged for Salesforce custom indexing requests where query performance demands it. Standard Salesforce indexed fields (Id, Name, OwnerId, CreatedDate, external ID fields) are indexed automatically.

Priority index candidates:
- `Account.Subscription_Tier__c` — used in case routing and SLA queries
- `Account.Contract_Renewal_Date__c` — used in daily renewal risk report
- `Account.Billing_Account_ID__c` — external ID; auto-indexed
- `Asset_Item__c.Status__c` — filtered frequently in portal and agent views

## 10.3 Data Retention

| Object | Retention Policy | Notes |
| :---- | :---- | :---- |
| Lead (Converted) | 7 years | Retained for audit; view restricted by OWD |
| Opportunity (Closed) | 7 years | Retained for revenue reporting |
| Case (Closed) | 5 years | Retained for SLA and QA audit |
| Feedback_Survey__c | 3 years | CSAT/NPS trend analysis |
| Project__c (Completed/Cancelled) | 5 years | Client engagement history |

*Note: Retention policies are defined here for design completeness. Enforcement in the Developer Edition portfolio org is via manual archive procedures; automated retention enforcement is out of scope.*

## 10.4 Sample Data Volumes

Per MKT-BRD-1.0 Section 6.1, the portfolio org is seeded with synthetic sample data within Developer Edition limits (5MB data storage):

| Object | Target Volume | Notes |
| :---- | :---- | :---- |
| Account | 50 | Mix of Prospect (15), Customer (30), Partner (5) |
| Contact | 200 | 3–5 per Customer Account; 1–2 per Prospect |
| Lead | 80 | Mix of statuses and sources |
| Opportunity | 150 | Spread across all stages; ~30 Closed Won/Lost |
| Case | 300 | Spread across record types and SLA tiers |
| Knowledge Articles | 80 | 20 per article type |
| Feedback_Survey__c | 200 | 1 per resolved/closed case where CSAT sent |
| Asset_Item__c | 100 | 2–4 per Customer Account |
| Project__c | 40 | 1–2 per Customer Account |
| Portal_User_Group__c | 60 | 1–3 per Customer Account |
| Quote | 50 | 1 per Proposal Sent / Negotiation / Won opportunity |

## 10.5 No Real Personal Data

All sample data is synthetically generated. Names, emails, and company data are fictitious and contain no real personal information. No GDPR, CCPA, or equivalent obligations apply to the portfolio org data.

---

*MKT-DD-1.0 is the field-level authority for the Catalyst CRM data model. Any field created, renamed, or removed during the build phase must be reflected here before the change is committed to source control. This document feeds directly into MKT-TPQA-1.0 test data requirements.*
