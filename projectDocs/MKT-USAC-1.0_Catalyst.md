

**CATALYST MARKETING TECHNOLOGIES, INC.**

*Accelerate Every Campaign.*

**USER STORIES & ACCEPTANCE CRITERIA**

**Salesforce CRM Implementation**

Sales Cloud · Service Cloud · Experience Cloud

| Document ID | MKT-USAC-1.0 |
| :---- | :---- |
| **Status** | DRAFT — Pending Review |
| **Version** | 1.0 |
| **Vertical** | Marketing — Baseline |
| **Company** | Catalyst Marketing Technologies, Inc. |
| **Prepared By** | Portfolio Developer |
| **Date** | 2026 |
| **Parent Doc** | MKT-BRD-1.0 — Business Requirements Document |
| **Traces To** | MKT-TDD-1.0, MKT-TPQA-1.0 |

---

# **1. Document Control**

## **1.1 Version History**

| Version | Date | Author | Changes | Status |
| :---- | :---- | :---- | :---- | :---- |
| 1.0 | 2026 | Portfolio Developer | Initial draft — full story backlog | Draft |

## **1.2 Document Purpose**

This document defines the complete User Story backlog for the Catalyst Salesforce CRM implementation. Each story is derived from a functional requirement in MKT-BRD-1.0 and includes:

- A user story in standard **As a / I want / So that** format
- Gherkin-style **Given / When / Then** acceptance criteria
- **Priority** using MoSCoW notation, inheriting from the parent BRD requirement
- A **Definition of Done** checklist applicable to all stories in the vertical

Stories are organised by cloud and module, mirroring the BRD structure. All downstream test cases in MKT-TPQA-1.0 reference the story IDs defined here.

## **1.3 ID Convention**

| ID Format | Example | Meaning |
| :---- | :---- | :---- |
| MKT-US-SALES-NNN | MKT-US-SALES-001 | Marketing vertical, Sales Cloud story 001 |
| MKT-US-SRVC-NNN | MKT-US-SRVC-001 | Marketing vertical, Service Cloud story 001 |
| MKT-US-EXP-NNN | MKT-US-EXP-001 | Marketing vertical, Experience Cloud story 001 |
| MKT-US-NFR-NNN | MKT-US-NFR-001 | Marketing vertical, Non-Functional story 001 |

---

# **2. Personas Reference**

The following personas are referenced throughout this document. Full persona definitions including profiles, permission sets, and sample users are documented in MKT-TDD-1.0.

| Persona | Role | Primary Cloud |
| :---- | :---- | :---- |
| **SDR** | Sales Development Representative — manages inbound leads and outbound prospecting | Sales |
| **Account Executive (AE)** | Manages the full opportunity lifecycle from discovery to close | Sales |
| **Sales Manager** | Coaches reps, reviews pipeline, manages forecasts and approvals | Sales |
| **VP of Sales** | Revenue leadership; owns forecast, quota, and strategic pipeline visibility | Sales |
| **Support Agent** | Handles inbound cases via the Service Console | Service |
| **Support Team Lead** | Manages agent queues, monitors SLA compliance, handles escalations | Service |
| **VP of Customer Success** | Owns SLA performance, client health, and escalation governance | Service |
| **Knowledge Manager** | Authors and publishes knowledge articles; owns the article review workflow | Service |
| **System Administrator** | Configures the org; responsible for all setup and metadata | All |
| **Catalyst Client (Portal User)** | Authenticated customer using the Experience Cloud self-service portal | Experience |
| **Portal Account Admin** | Catalyst client with elevated portal permissions for user management and billing | Experience |

---

# **3. Universal Definition of Done**

The following criteria apply to every user story in this backlog. A story is not considered complete unless all applicable items are satisfied.

- [ ] Salesforce configuration or Apex code deployed to the target org via SFDX
- [ ] All acceptance criteria scenarios pass without error
- [ ] Relevant Apex classes achieve minimum 85% test coverage with meaningful assertions
- [ ] All custom metadata is committed to Git in source format
- [ ] Page layouts, compact layouts, and list views updated for all affected objects
- [ ] Relevant profiles and permission sets updated to grant/restrict access as designed
- [ ] Record tested end-to-end by at least two distinct user profiles
- [ ] No open critical or high bugs against this story
- [ ] Traceability entry added to MKT-TPQA-1.0 test plan

---

# **4. User Stories — Sales Cloud**

## **4.1 Lead Management**

---

### MKT-US-SALES-001 — Web-to-Lead Capture

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-SALES-001 |
| **Priority** | Must Have |
| **Persona** | SDR |

**User Story**

As an **SDR**, I want inbound prospects to be automatically captured in Salesforce via a web-to-lead form so that no inbound interest is lost and all lead data meets our minimum quality standard from the point of entry.

**Acceptance Criteria**

```
Scenario: Successful web-to-lead submission with all required fields
  Given a prospect visits the Catalyst inbound lead form
  When they complete all required fields (First Name, Last Name, Company,
       Job Title, Email, Phone, Lead Source, Area of Interest)
  And they submit the form
  Then a Lead record is created in Salesforce with all submitted values
  And Lead Status is set to "New" automatically
  And the lead is assigned within 5 minutes per MKT-US-SALES-002

Scenario: Web-to-lead submission missing a required field
  Given a prospect visits the Catalyst inbound lead form
  When they attempt to submit without completing a required field
  Then the form displays an inline validation error identifying the missing field
  And no Lead record is created in Salesforce

Scenario: Area of Interest maps to Catalyst module picklist
  Given a prospect selects "Campaign Intelligence" as their Area of Interest
  When the form is submitted
  Then the Lead's Area of Interest field contains "Campaign Intelligence"
  And this value is available for routing and SDR context
```

---

### MKT-US-SALES-002 — Automated Lead Assignment

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-SALES-002 |
| **Priority** | Must Have |
| **Persona** | SDR, Sales Manager |

**User Story**

As a **Sales Manager**, I want inbound leads to be automatically assigned to the correct SDR based on lead source and geography so that response times are consistent and no SDR receives a disproportionate volume.

**Acceptance Criteria**

```
Scenario: Lead assigned by geography using round-robin
  Given a new lead is created with Lead Source = "Web" and Country = "United States"
  When the lead assignment rule evaluates the record
  Then the lead is assigned to the next SDR in the US round-robin sequence
  And the SDR receives an email notification of the new lead assignment

Scenario: Lead assigned by lead source — Event
  Given a new lead is created with Lead Source = "Event"
  When the lead assignment rule evaluates the record
  Then the lead is assigned to the SDR designated for Event leads in that geography

Scenario: No matching assignment rule
  Given a new lead is created with a Lead Source and Country combination
       not covered by any active assignment rule
  When the assignment rule evaluates the record
  Then the lead is assigned to the Sales Manager as the default owner
  And the Sales Manager is notified to manually reassign
```

---

### MKT-US-SALES-003 — Lead Status Governance

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-SALES-003 |
| **Priority** | Must Have |
| **Persona** | SDR, Sales Manager |

**User Story**

As a **Sales Manager**, I want the lead status lifecycle to be enforced by the system with mandatory fields required before advancing to Qualified so that our pipeline data is consistent and conversion rates are meaningful.

**Acceptance Criteria**

```
Scenario: Lead status picklist contains exactly the required values
  Given an SDR views a lead record
  When they open the Status picklist
  Then the available values are exactly:
       New | Attempting Contact | Contacted | Qualified | Unqualified | Converted
  And no other values are present

Scenario: Advancing to Qualified requires mandatory fields
  Given a lead is in "Contacted" status
  When the SDR attempts to change Status to "Qualified"
  And the Budget Confirmed and Decision Timeline fields are not populated
  Then a validation error is displayed
  And the status change is prevented

Scenario: Advancing to Qualified with all required fields populated
  Given a lead is in "Contacted" status
  And all mandatory Qualified-stage fields are populated
  When the SDR changes Status to "Qualified"
  Then the status is saved successfully
  And the lead becomes eligible for conversion per MKT-US-SALES-005
```

---

### MKT-US-SALES-004 — Einstein Lead Scoring

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-SALES-004 |
| **Priority** | Should Have |
| **Persona** | SDR |

**User Story**

As an **SDR**, I want to see an Einstein Lead Score on each lead record so that I can prioritise outreach to the highest-potential prospects and avoid wasting time on low-fit contacts.

**Acceptance Criteria**

```
Scenario: Lead Score field is visible on the Lead record page layout
  Given an SDR opens any Lead record
  Then the Lead Score field (integer 0–100) is visible on the page layout
  And a score tier label (Hot / Warm / Cold) is displayed alongside the numeric score

Scenario: Lead Score updates after activity is logged
  Given a Lead has an initial score of 45
  When the SDR logs a completed call activity against the lead
  Then the Lead Score field updates within 24 hours to reflect the new activity signal

Scenario: Lead list view sortable by Lead Score
  Given an SDR is viewing the "My Leads" list view
  When they click the Lead Score column header
  Then the list is sorted in descending order of score
  And the highest-scoring leads appear at the top
```

---

### MKT-US-SALES-005 — Lead Conversion Gate

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-SALES-005 |
| **Priority** | Must Have |
| **Persona** | SDR |

**User Story**

As a **Sales Manager**, I want the system to prevent lead conversion unless the lead is Qualified and at least three activities have been logged so that opportunities are only created from genuinely engaged prospects.

**Acceptance Criteria**

```
Scenario: Conversion blocked — Lead Status is not Qualified
  Given a lead has Status = "Contacted"
  When the SDR clicks the Convert button
  Then a validation message is displayed: "Lead must be Qualified before conversion"
  And the conversion flow does not proceed

Scenario: Conversion blocked — fewer than three activities logged
  Given a lead has Status = "Qualified"
  And only two activities (one call, one email) are logged against the lead
  When the SDR clicks the Convert button
  Then a validation message is displayed:
       "At least 3 logged activities are required before conversion.
        Current count: 2"
  And the conversion flow does not proceed

Scenario: Conversion permitted — all gates passed
  Given a lead has Status = "Qualified"
  And three or more activities are logged against the lead
  When the SDR clicks the Convert button
  Then the standard lead conversion flow is presented
  And the SDR can create or associate an Account, Contact, and Opportunity
```

---

### MKT-US-SALES-006 — 48-Hour Follow-Up Task

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-SALES-006 |
| **Priority** | Should Have |
| **Persona** | SDR, Sales Manager |

**User Story**

As a **Sales Manager**, I want the system to automatically create a follow-up task for an SDR 48 hours after lead creation if no activity has been logged so that no lead is left uncontacted.

**Acceptance Criteria**

```
Scenario: No activity logged — follow-up task created at 48 hours
  Given a lead was created 48 hours ago
  And no activity (call, email, or meeting) has been logged against the lead
  When the scheduled flow runs
  Then a Task is created with Subject = "Follow up: [Lead Name]"
  And the Task is assigned to the lead owner
  And the Task Due Date is set to today
  And the Task Priority is set to "High"

Scenario: Activity logged within 48 hours — no task created
  Given a lead was created 36 hours ago
  And the SDR has logged one email activity against the lead
  When the scheduled flow evaluates the lead
  Then no follow-up task is created

Scenario: Task created — SDR receives notification
  Given the 48-hour follow-up task has been created
  Then the assigned SDR receives a Salesforce in-app notification
  And the task appears in their task list
```

---

## **4.2 Account & Contact Management**

---

### MKT-US-SALES-007 — Account Record Types

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-SALES-007 |
| **Priority** | Must Have |
| **Persona** | AE, Support Agent, System Administrator |

**User Story**

As a **System Administrator**, I want Account records to have four distinct record types — Prospect, Customer, Partner, and Competitor — each with a tailored page layout so that users only see fields relevant to that account relationship.

**Acceptance Criteria**

```
Scenario: Account record types are available during record creation
  Given an AE creates a new Account
  When they select Record Type
  Then the available options are exactly: Prospect | Customer | Partner | Competitor

Scenario: Customer record type shows Catalyst-specific fields
  Given an AE opens an Account with Record Type = "Customer"
  Then the page layout displays: Subscription Tier, Modules Purchased,
       Contract Renewal Date, ACV, Primary Platform Contact, and Account Health Score
  And these fields are not visible on the Prospect layout

Scenario: Prospect record type shows pipeline-relevant fields
  Given an AE opens an Account with Record Type = "Prospect"
  Then the page layout displays: Industry, Employee Count, Lead Source,
       and Estimated ACV
  And Subscription Tier and ACV fields are not displayed
```

---

### MKT-US-SALES-008 — Catalyst-Specific Account Fields

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-SALES-008 |
| **Priority** | Must Have |
| **Persona** | AE, Sales Manager, Support Agent |

**User Story**

As an **AE**, I want Catalyst-specific product relationship fields on Customer Account records so that I always have contract, module, and renewal context without switching to another system.

**Acceptance Criteria**

```
Scenario: All required fields exist on the Customer Account layout
  Given a System Administrator views the Customer Account page layout
  Then the following fields are present and correctly typed:
       Subscription Tier (Picklist: Starter / Professional / Enterprise)
       Modules Purchased (Multi-select picklist: Campaign Intelligence,
                          Audience Studio, Attribution Engine, Content Hub)
       Contract Renewal Date (Date field)
       Annual Contract Value — ACV (Currency field)
       Primary Platform Contact (Lookup: Contact)

Scenario: Subscription Tier drives SLA entitlement
  Given an Account has Subscription Tier = "Enterprise"
  When a new case is created linked to this Account
  Then the Entitlement applied to the case reflects the Enterprise SLA tier
       per MKT-US-SRVC-007

Scenario: Contract Renewal Date triggers renewal workflow
  Given an Account has a Contract Renewal Date 90 days from today
  When the daily scheduled flow evaluates the record
  Then the Account owner receives a renewal alert task
```

---

### MKT-US-SALES-009 — Contact Role at Catalyst

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-SALES-009 |
| **Priority** | Must Have |
| **Persona** | AE |

**User Story**

As an **AE**, I want to record the role each Contact plays in a buying decision so that I can manage multi-threaded enterprise deals and avoid single-threading risk.

**Acceptance Criteria**

```
Scenario: Role at Catalyst field available on Contact record
  Given an AE opens a Contact record
  Then a "Role at Catalyst" picklist is visible with values:
       Economic Buyer | Technical Evaluator | Champion | End User | Detractor

Scenario: Multiple contacts on an opportunity with different roles
  Given an opportunity has three related contacts
  When the AE assigns roles: Economic Buyer (CFO), Champion (Marketing Ops),
       Technical Evaluator (IT Manager)
  Then all three role values are saved and visible on each respective Contact

Scenario: Contact Role field is reportable
  Given a Sales Manager runs a report on Contacts
  When they add "Role at Catalyst" as a filter
  Then they can filter to show only Economic Buyers across all active opportunities
```

---

### MKT-US-SALES-010 — Account Health Score

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-SALES-010 |
| **Priority** | Should Have |
| **Persona** | AE, VP of Customer Success |

**User Story**

As a **VP of Customer Success**, I want an Account Health Score visible on each Customer Account record so that my team can proactively identify at-risk accounts before they churn.

**Acceptance Criteria**

```
Scenario: Account Health Score calculated from composite inputs
  Given a Customer Account has the following data:
       Case volume (last 90 days): 12 (above average)
       NPS Score: 6 (Passive)
       Product Usage Index (mock API): 42%
       Days to Contract Renewal: 45
  When the Health Score flow evaluates the record
  Then the Account Health Score is calculated as a composite value (0–100)
  And a Health Tier label is displayed: Green / Amber / Red

Scenario: Health Score updates when a new case is submitted
  Given an Account has Health Score = 78 (Green)
  When the account's 5th case this month is created
  Then the Health Score is recalculated within 1 hour
  And reflects the increased case volume in the score

Scenario: Health Score visible on Account page layout and dashboard
  Given a Sales Manager views the Sales Leadership Dashboard
  Then they can see Account Health Score on the at-risk accounts component
  And can click through to the Account record
```

---

### MKT-US-SALES-011 — Duplicate Account Detection

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-SALES-011 |
| **Priority** | Could Have |
| **Persona** | AE, System Administrator |

**User Story**

As a **System Administrator**, I want Salesforce to detect and flag potential duplicate Account records when a new Account is created with a matching domain so that data fragmentation is prevented at the point of entry.

**Acceptance Criteria**

```
Scenario: Duplicate detected — matching domain
  Given an Account with domain "acmecorp.com" already exists
  When a user creates a new Account and enters "acmecorp.com" as the website
  Then Salesforce displays a duplicate alert banner on save
  And the user is presented with a link to the existing matching Account
  And an option to merge or continue creating the new record

Scenario: No duplicate — unique domain
  Given no Account with domain "newclient.io" exists
  When a user creates a new Account with website "newclient.io"
  Then the record saves without a duplicate warning

Scenario: Admin can override duplicate alert
  Given a duplicate alert has been triggered
  When a System Administrator reviews and determines the accounts are distinct
  Then they can dismiss the alert and save the record with an override note
```

---

## **4.3 Opportunity Management**

---

### MKT-US-SALES-012 — Sales Process Stage Governance

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-SALES-012 |
| **Priority** | Must Have |
| **Persona** | AE, Sales Manager |

**User Story**

As a **Sales Manager**, I want the opportunity sales process to enforce defined stages with associated probability values and mandatory fields so that our pipeline data is consistent and forecast accuracy is reliable.

**Acceptance Criteria**

```
Scenario: Sales process stages and probabilities are correctly configured
  Given an AE views an Opportunity record
  When they open the Stage picklist
  Then the available stages are exactly, in order:
       Discovery (10%) | Technical Evaluation (25%) | Proposal Sent (50%) |
       Negotiation (75%) | Closed Won (100%) | Closed Lost (0%)

Scenario: Probability auto-updates when Stage changes
  Given an opportunity is in "Discovery" with Probability = 10%
  When the AE advances the stage to "Technical Evaluation"
  Then the Probability field automatically updates to 25%

Scenario: Closed Lost requires Loss Reason
  Given an AE attempts to set Stage = "Closed Lost"
  When the Loss Reason field is blank
  Then a validation error is displayed per MKT-US-SALES-016
```

---

### MKT-US-SALES-013 — Mandatory Fields at Proposal Sent

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-SALES-013 |
| **Priority** | Must Have |
| **Persona** | AE |

**User Story**

As a **Sales Manager**, I want the system to require key deal qualification fields before an opportunity can advance to Proposal Sent so that no quote is generated without complete deal data.

**Acceptance Criteria**

```
Scenario: Advance to Proposal Sent blocked — missing required fields
  Given an opportunity is in "Technical Evaluation"
  And the following fields are not populated:
       Modules Selected, Contract Length, Decision Date, Named Economic Buyer
  When the AE attempts to change Stage to "Proposal Sent"
  Then a validation error lists each missing required field
  And the stage change is prevented

Scenario: Advance to Proposal Sent succeeds — all fields complete
  Given an opportunity has all four required fields populated:
       Modules Selected = "Campaign Intelligence; Attribution Engine"
       Contract Length = "24 months"
       Decision Date = [valid future date]
       Named Economic Buyer = [valid Contact lookup]
  When the AE changes Stage to "Proposal Sent"
  Then the stage saves successfully
  And the opportunity becomes eligible for quote generation

Scenario: Contract Length picklist values are correct
  Given an AE edits the Contract Length field
  Then the available values are exactly: 12 months | 24 months | 36 months
```

---

### MKT-US-SALES-014 — Product Catalogue & Opportunity Line Items

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-SALES-014 |
| **Priority** | Must Have |
| **Persona** | AE |

**User Story**

As an **AE**, I want to add Catalyst Platform modules as product line items to an opportunity so that quotes are generated from a governed catalogue with accurate pricing and no manual calculation.

**Acceptance Criteria**

```
Scenario: All four Catalyst modules are available as products
  Given an AE adds products to an opportunity
  When they search the product catalogue
  Then the following products are available:
       Campaign Intelligence | Audience Studio | Attribution Engine | Content Hub
  And each has a Standard Price and a Discounted Price Book entry

Scenario: Line item quantity and discount can be set per product
  Given an AE adds "Campaign Intelligence" to an opportunity
  When they set Quantity = 1 and Discount = 10%
  Then the line item correctly calculates: List Price × (1 - Discount%) = Net Price
  And the Total ACV on the opportunity header updates accordingly

Scenario: Removing a line item recalculates opportunity total
  Given an opportunity has two line items with a combined value of £120,000
  When the AE removes one line item worth £40,000
  Then the opportunity Amount field updates to £80,000
```

---

### MKT-US-SALES-015 — PDF Quote Generation & Discount Approval

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-SALES-015 |
| **Priority** | Must Have |
| **Persona** | AE, Sales Manager, VP of Sales |

**User Story**

As an **AE**, I want to generate a branded PDF quote from an opportunity so that I can send a professional proposal to the client without manual formatting, and any discount over 15% is automatically routed for VP approval.

**Acceptance Criteria**

```
Scenario: PDF quote generated with correct content
  Given an opportunity has at least one product line item and is in "Proposal Sent" stage
  When the AE clicks "Generate Quote"
  Then a PDF is produced containing:
       Catalyst logo and branding
       Line items with product name, quantity, list price, discount %, and net price
       Total ACV (annualised)
       Contract terms (length and start date)
       AE contact details and quote expiry date

Scenario: Discount under 15% — quote saves without approval
  Given a quote has a maximum line item discount of 10%
  When the AE saves the quote
  Then the quote status is set to "Draft" and no approval is triggered
  And the AE can proceed to generate the PDF

Scenario: Discount at or above 15% — approval required
  Given a quote has a line item with a discount of 18%
  When the AE attempts to save the quote
  Then an approval process is triggered automatically
  And the VP of Sales receives an approval request notification
  And the quote status is set to "Pending Approval"
  And the AE cannot generate the PDF until approval is granted

Scenario: VP of Sales approves the quote
  Given a quote is in "Pending Approval" status
  When the VP of Sales approves the request
  Then the quote status changes to "Approved"
  And the AE is notified and can now generate the PDF
```

---

### MKT-US-SALES-016 — Loss Reason Capture

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-SALES-016 |
| **Priority** | Should Have |
| **Persona** | AE |

**User Story**

As a **VP of Sales**, I want a mandatory loss reason to be recorded on every Closed Lost opportunity so that we can track competitive losses and identify pricing and product gaps.

**Acceptance Criteria**

```
Scenario: Loss Reason is required when closing lost
  Given an AE sets an opportunity Stage to "Closed Lost"
  When the Loss Reason field is blank
  Then the record cannot be saved
  And a validation message is displayed: "Loss Reason is required to close an opportunity as lost"

Scenario: Loss Reason picklist contains the correct values
  Given an AE selects the Loss Reason field on a Closed Lost opportunity
  Then the available values are exactly:
       Competitor — Named | Price | Timing | No Decision | Product Gap

Scenario: Loss Notes is optional and unrestricted
  Given an AE has selected a Loss Reason
  When they optionally enter free text in Loss Notes
  Then the text is saved without length restriction (up to the field limit)
  And is visible to the Sales Manager on the record and in reports
```

---

### MKT-US-SALES-017 — Opportunity Kanban View

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-SALES-017 |
| **Priority** | Should Have |
| **Persona** | AE |

**User Story**

As an **AE**, I want to see my open opportunities in a Kanban view organised by sales stage so that I can visually manage my pipeline and identify gaps at a glance.

**Acceptance Criteria**

```
Scenario: Kanban view is the default for the AE opportunities list view
  Given an AE navigates to the Opportunities tab
  When the page loads
  Then the default view renders as Kanban
  And columns correspond to the six sales stages (excluding Closed Won / Closed Lost)

Scenario: Opportunity cards show key deal data
  Given an AE is viewing the Kanban board
  Then each opportunity card displays:
       Opportunity Name | Account Name | Amount | Close Date | Days in Stage

Scenario: AE can drag a card to advance the stage
  Given an AE's opportunity is in "Discovery"
  When they drag the card to the "Technical Evaluation" column
  Then the Opportunity Stage updates to "Technical Evaluation"
  And any stage-entry validation rules are enforced
```

---

## **4.4 Forecasting & Reporting**

---

### MKT-US-SALES-018 — Collaborative Forecasting

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-SALES-018 |
| **Priority** | Must Have |
| **Persona** | AE, Sales Manager, VP of Sales |

**User Story**

As a **VP of Sales**, I want Collaborative Forecasting enabled and configured to roll up pipeline by rep and territory so that I have a single, real-time forecast view for weekly revenue reviews.

**Acceptance Criteria**

```
Scenario: Forecast categories map to Catalyst sales stages
  Given Collaborative Forecasting is enabled
  Then the forecast category mapping is:
       Discovery → Pipeline
       Technical Evaluation → Pipeline
       Proposal Sent → Best Case
       Negotiation → Commit
       Closed Won → Closed
       Closed Lost → Omitted

Scenario: VP of Sales can view forecast by rep
  Given the VP of Sales navigates to the Forecasts tab
  Then they see a rollup of each AE's Commit, Best Case, and Pipeline amounts
  And they can drill into individual rep forecasts
  And they can adjust a forecast amount with an override and note

Scenario: Forecast updates in real time when stage changes
  Given an opportunity moves from "Technical Evaluation" to "Proposal Sent"
  When a Sales Manager views the forecast
  Then the opportunity moves from the Pipeline column to the Best Case column
  And the totals update without requiring a page refresh
```

---

### MKT-US-SALES-019 — Sales Leadership Dashboard

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-SALES-019 |
| **Priority** | Must Have |
| **Persona** | VP of Sales, Sales Manager |

**User Story**

As a **VP of Sales**, I want a Sales Leadership Dashboard that gives me live pipeline and performance metrics so that I can lead the weekly revenue review without relying on spreadsheets.

**Acceptance Criteria**

```
Scenario: Dashboard contains all required components
  Given the VP of Sales opens the "Sales Leadership Dashboard"
  Then the dashboard contains the following components:
       Pipeline by Stage (funnel chart)
       Forecast vs. Quota by Rep (bar chart)
       Average Deal Size by Module (horizontal bar)
       Average Sales Cycle Length in days (metric tile)
       Win/Loss Rate by Quarter (donut chart)

Scenario: Dashboard data is filtered to the current quarter by default
  Given the VP of Sales opens the dashboard
  Then all components default to the current fiscal quarter
  And a date range picker allows switching to previous quarters

Scenario: Clicking a chart segment drills into underlying opportunities
  Given the VP of Sales clicks on the "Negotiation" segment of the funnel chart
  Then a filtered list of all opportunities in Negotiation stage is displayed
  And the list includes: Account Name, AE, Amount, Close Date, and Days in Stage
```

---

### MKT-US-SALES-020 — Rep Performance Dashboard

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-SALES-020 |
| **Priority** | Should Have |
| **Persona** | AE |

**User Story**

As an **AE**, I want a personal performance dashboard showing my quota attainment, pipeline, and activity metrics so that I can self-manage my performance without waiting for my weekly 1:1.

**Acceptance Criteria**

```
Scenario: Dashboard is scoped to the logged-in AE's data
  Given AE Leila Hassan logs in and opens the "Rep Performance Dashboard"
  Then all components show only Leila's opportunities and activities
  And she cannot see data belonging to other AEs

Scenario: Dashboard contains all required components
  Given an AE opens their Rep Performance Dashboard
  Then the following components are present:
       Quota Attainment % (gauge or metric tile)
       Open Pipeline by Stage (stacked bar)
       Activities This Week vs. Weekly Goal (progress bar)
       Next 30-Day Renewal Risk Accounts (list view)

Scenario: Renewal risk accounts are correctly identified
  Given an Account has Contract Renewal Date within 30 days
  And Account Health Score = Amber or Red
  Then that Account appears on the AE's renewal risk list
  And is ordered by renewal date ascending
```

---

# **5. User Stories — Service Cloud**

## **5.1 Case Management**

---

### MKT-US-SRVC-001 — Multi-Channel Case Creation

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-SRVC-001 |
| **Priority** | Must Have |
| **Persona** | Support Agent, Catalyst Client |

**User Story**

As a **Support Agent**, I want cases to be automatically created from all four intake channels — email, web form, portal submission, and manual entry — so that no client issue falls through the cracks regardless of how it is submitted.

**Acceptance Criteria**

```
Scenario: Email-to-Case — inbound email creates a case
  Given a client sends an email to support@catalyst.io
  When the email is received by Salesforce
  Then a Case is automatically created with:
       Subject = email subject line
       Description = email body
       Origin = "Email"
       Status = "New"
  And the case is linked to the client's Account per MKT-US-SRVC-002

Scenario: Web-to-Case — portal form submission creates a case
  Given a client submits the Web-to-Case form on the portal
  When the submission is received
  Then a Case is created with Origin = "Web"
  And the form field values are mapped to the correct Case fields

Scenario: Manual case creation by agent
  Given a client phones the support team
  When a Support Agent manually creates a Case record
  Then all mandatory fields are enforced
  And Origin = "Phone" can be selected by the agent
```

---

### MKT-US-SRVC-002 — Auto-Link Case to Account

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-SRVC-002 |
| **Priority** | Must Have |
| **Persona** | Support Agent |

**User Story**

As a **Support Agent**, I want cases to be automatically linked to the correct Account based on the submitter's email domain so that I always have full account context when I open a case.

**Acceptance Criteria**

```
Scenario: Submitter's email domain matches one Account
  Given a case is created from email "jane.doe@acmecorp.com"
  And a single Account exists with domain "acmecorp.com"
  When the case creation automation runs
  Then the Case is automatically linked to the Acme Corp Account
  And the Account Name field is populated on the Case record

Scenario: Submitter's email domain matches multiple Accounts
  Given two Accounts share the domain "enterprise.com"
  When a case is created from an "@enterprise.com" email address
  Then the case is NOT auto-linked
  And it is flagged for manual review with status = "Awaiting Agent"
  And the Support Team Lead receives a notification

Scenario: No matching Account found
  Given no Account exists with the submitter's email domain
  When a case is created
  Then the Case is created without an Account link
  And it is flagged with a "No Account Match" indicator for manual review
```

---

### MKT-US-SRVC-003 — Case Record Types

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-SRVC-003 |
| **Priority** | Must Have |
| **Persona** | Support Agent, System Administrator |

**User Story**

As a **Support Agent**, I want case record types to present only the fields and picklist values relevant to each case category so that I complete intake efficiently without irrelevant fields cluttering the layout.

**Acceptance Criteria**

```
Scenario: Case record types are available and correctly named
  Given a Support Agent creates a new Case
  When they select the Record Type
  Then the available values are exactly:
       Technical Support | Billing Enquiry | Onboarding Request |
       Feature Request | General Enquiry

Scenario: Technical Support layout shows technical-specific fields
  Given a Case has Record Type = "Technical Support"
  Then the page layout includes: Affected Module (multi-select),
       Severity (Critical / High / Medium / Low), Error Message (text area)
  And billing-specific fields are not shown

Scenario: Feature Request layout shows product feedback fields
  Given a Case has Record Type = "Feature Request"
  Then the page layout includes: Use Case Description (text area),
       Business Impact (picklist), Target Module (picklist)
  And technical diagnostic fields are not shown
```

---

### MKT-US-SRVC-004 — Account Context on Case Record

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-SRVC-004 |
| **Priority** | Must Have |
| **Persona** | Support Agent |

**User Story**

As a **Support Agent**, I want the related Account's subscription and health information to be displayed prominently on the case record so that I have full client context before I read the first word of the case description.

**Acceptance Criteria**

```
Scenario: Account context panel is visible on the Case record
  Given a Case is linked to an Account with Subscription Tier = "Enterprise"
  When a Support Agent opens the Case
  Then a dedicated Account Context panel displays:
       Subscription Tier | Modules Purchased | ACV | Account Health Score
  And this panel is positioned at the top of the Service Console sidebar

Scenario: Clicking Account fields in the context panel navigates to the Account
  Given a Support Agent sees the Account context panel on a Case
  When they click the Account Name
  Then they are taken to the full Account record without losing the Case context
  And they can return to the Case via browser back or the console tab

Scenario: Account context updates if the Account record changes
  Given an Account's Subscription Tier is upgraded from "Professional" to "Enterprise"
  When a Support Agent next opens any case linked to that Account
  Then the Account context panel reflects "Enterprise" tier
```

---

### MKT-US-SRVC-005 — Case Status Lifecycle

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-SRVC-005 |
| **Priority** | Must Have |
| **Persona** | Support Agent, Support Team Lead |

**User Story**

As a **Support Team Lead**, I want the case status lifecycle to be enforced with a mandatory Resolution Summary before resolution so that we have complete closure notes for every case and SLA reporting is accurate.

**Acceptance Criteria**

```
Scenario: Case status picklist contains only the required values
  Given a Support Agent opens the Case Status picklist
  Then the available values are exactly:
       New | Awaiting Agent | In Progress | Awaiting Customer |
       On Hold | Resolved | Closed

Scenario: Setting Status to Resolved requires Resolution Summary
  Given a Case is in "In Progress" status
  When the agent attempts to set Status = "Resolved"
  And the Resolution Summary field is blank
  Then a validation error is displayed:
       "Resolution Summary is required before this case can be resolved"
  And the status change is blocked

Scenario: Setting Status to Resolved with summary populated succeeds
  Given the Resolution Summary field contains a valid text entry
  When the agent sets Status = "Resolved"
  Then the record saves successfully
  And the Resolved Date/Time is automatically stamped on the case
```

---

### MKT-US-SRVC-006 — CSAT Survey Gate Before Close

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-SRVC-006 |
| **Priority** | Should Have |
| **Persona** | Support Agent |

**User Story**

As a **VP of Customer Success**, I want the system to prevent a case from being Closed unless a CSAT survey has been dispatched so that we always collect satisfaction data and cannot bypass the measurement step.

**Acceptance Criteria**

```
Scenario: Closing a case without dispatching CSAT is blocked
  Given a Case is in "Resolved" status
  And the CSAT Survey Sent field = false
  When the agent attempts to set Status = "Closed"
  Then a prompt is displayed:
       "CSAT survey has not been sent. Send now before closing?"
  And the case remains in "Resolved" status until the survey is sent

Scenario: Agent sends CSAT from the case record
  Given a Case is in "Resolved" status
  When the agent clicks "Send CSAT Survey" from the case action button
  Then an email is sent to the case contact from the CSAT survey template
  And CSAT Survey Sent is set to true on the case record

Scenario: Case can be Closed after CSAT is sent
  Given CSAT Survey Sent = true on a Resolved case
  When the agent sets Status = "Closed"
  Then the case saves without error
  And the Closed Date/Time is stamped automatically
```

---

## **5.2 SLA Entitlements**

---

### MKT-US-SRVC-007 — Entitlement Enforcement by Subscription Tier

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-SRVC-007 |
| **Priority** | Must Have |
| **Persona** | Support Agent, Support Team Lead |

**User Story**

As a **Support Team Lead**, I want the correct SLA entitlement to be automatically applied to every case based on the Account's subscription tier so that response and resolution milestones are tracked without manual configuration.

**Acceptance Criteria**

```
Scenario: Enterprise case receives correct SLA milestones
  Given a Case is created linked to an Account with Subscription Tier = "Enterprise"
  When the entitlement process runs
  Then the Case is linked to the Enterprise Entitlement Plan
  And milestones are set:
       First Response: 1 business hour from case creation
       Resolution: 4 business hours from case creation (24/7 coverage)

Scenario: Professional case receives correct SLA milestones
  Given a Case is linked to a Professional tier Account
  When the entitlement process runs
  Then First Response milestone = 4 business hours (Mon–Fri, 8am–8pm CT)
  And Resolution milestone = 2 business days

Scenario: Starter case receives correct SLA milestones
  Given a Case is linked to a Starter tier Account
  When the entitlement process runs
  Then First Response milestone = 8 business hours (Mon–Fri, 9am–6pm CT)
  And Resolution milestone = 5 business days
```

---

### MKT-US-SRVC-008 — Automated SLA Escalation

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-SRVC-008 |
| **Priority** | Must Have |
| **Persona** | Support Team Lead, VP of Customer Success |

**User Story**

As a **VP of Customer Success**, I want automated escalation notifications to fire when a case breaches its first response milestone and at 50% of resolution time remaining so that at-risk cases never go unnoticed.

**Acceptance Criteria**

```
Scenario: First response milestone breach triggers escalation to Team Lead
  Given a Case's first response milestone target has passed
  And no first response has been logged by an agent
  When the entitlement process evaluates the milestone
  Then the milestone status is set to "Violated"
  And the Support Team Lead receives an email and Salesforce notification:
       "ESCALATION: Case [Number] — First Response SLA breached. Account: [Name]. Tier: [Tier]"

Scenario: 50% of resolution time elapsed triggers VP escalation
  Given a Case's resolution milestone deadline is 4 hours away
  And the case is not yet resolved (50% of total resolution time elapsed)
  When the milestone warning action fires
  Then the VP of Customer Success receives a notification:
       "WARNING: Case [Number] — Resolution SLA at risk. 50% of resolution time elapsed."

Scenario: Case resolved before breach — no escalation fires
  Given a Case has an active first response milestone
  When the agent logs the first response before the milestone deadline
  Then the milestone is marked "Completed"
  And no escalation notification is sent
```

---

### MKT-US-SRVC-009 — Service SLA Dashboard

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-SRVC-009 |
| **Priority** | Should Have |
| **Persona** | Support Team Lead, VP of Customer Success |

**User Story**

As a **VP of Customer Success**, I want a live SLA performance dashboard so that I can monitor compliance rates and identify systemic issues before they affect client relationships.

**Acceptance Criteria**

```
Scenario: Dashboard contains all required components
  Given the VP of Customer Success opens the "Service SLA Dashboard"
  Then the following components are present:
       Cases by Status (donut chart)
       SLA Compliance Rate by Tier — Enterprise / Professional / Starter (bar chart)
       Average Resolution Time by Case Type (horizontal bar)
       Breach Count by Agent (leaderboard table)
       Case Volume Trend — last 90 days (line chart)

Scenario: SLA Compliance Rate is calculated correctly
  Given 100 Enterprise cases closed this quarter
  And 95 met their resolution milestone
  When the VP opens the dashboard
  Then SLA Compliance Rate for Enterprise = 95%

Scenario: Breach Count by Agent identifies individuals needing support
  Given Agent Chris Park has breached 4 SLAs this month
  When the VP views the Breach Count component
  Then Chris Park appears with a count of 4
  And the Team Lead can click through to the specific breached cases
```

---

## **5.3 Knowledge Management**

---

### MKT-US-SRVC-010 — Knowledge Base Setup

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-SRVC-010 |
| **Priority** | Must Have |
| **Persona** | Knowledge Manager, Support Agent, Catalyst Client |

**User Story**

As a **Knowledge Manager**, I want Salesforce Knowledge configured with four article types and made searchable from both the Service Console and the portal so that agents and clients can find answers without escalating.

**Acceptance Criteria**

```
Scenario: Article types are correctly configured
  Given a Knowledge Manager creates a new Knowledge Article
  When they select the Article Type
  Then the available types are exactly:
       How-To Guide | Troubleshooting | Release Note | FAQ

Scenario: Knowledge articles are searchable from the Service Console
  Given a Support Agent is handling a case in the Service Console
  When they type a keyword in the Knowledge sidebar search
  Then relevant articles are returned ranked by relevance
  And the agent can view the article in a panel without leaving the console

Scenario: Knowledge articles are searchable from the Experience Cloud portal
  Given an authenticated portal user types a search query
  When they search from the portal knowledge page
  Then published articles matching the query are returned
  And draft or archived articles are not visible to portal users
```

---

### MKT-US-SRVC-011 — Article Review & Publication Workflow

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-SRVC-011 |
| **Priority** | Must Have |
| **Persona** | Knowledge Manager, Support Agent |

**User Story**

As a **Knowledge Manager**, I want all new knowledge articles to pass through a mandatory peer review before publication so that clients and agents only see accurate, approved content.

**Acceptance Criteria**

```
Scenario: New article is created in Draft status
  Given a Support Agent creates a new knowledge article
  When they save it for the first time
  Then the article status is set to "Draft"
  And it is not visible in portal or console search results

Scenario: Agent submits article for review
  Given an article is in "Draft" status
  When the author submits it for review
  Then the article moves to "In Review" status
  And the Knowledge Manager receives a review request notification

Scenario: Knowledge Manager approves and publishes the article
  Given an article is in "In Review" status
  When the Knowledge Manager reviews and approves it
  Then the article status changes to "Published"
  And it becomes immediately searchable in both the console and portal

Scenario: Knowledge Manager rejects the article with feedback
  Given an article is in "In Review" status
  When the Knowledge Manager clicks "Request Revision" with a feedback note
  Then the article returns to "Draft" status
  And the author is notified with the revision notes
```

---

### MKT-US-SRVC-012 — Recommended Articles on Case Creation (Portal)

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-SRVC-012 |
| **Priority** | Should Have |
| **Persona** | Catalyst Client |

**User Story**

As a **Catalyst Client**, I want the portal to suggest relevant knowledge articles as I type my case subject so that I can resolve my issue myself without submitting a ticket.

**Acceptance Criteria**

```
Scenario: Articles surface as user types the case subject
  Given a portal user begins typing a case subject
  When they have entered at least 3 characters
  Then a panel displays up to 5 recommended knowledge articles matching the subject
  And each suggestion shows the article title and a short excerpt

Scenario: User finds their answer in a suggested article
  Given suggested articles are displayed
  When the user clicks an article and reads it
  Then they are presented with a prompt:
       "Did this article resolve your issue?"
       [Yes — return to portal] [No — continue with case submission]
  And if they select "Yes", no case is submitted and the deflection is recorded

Scenario: No matching articles found
  Given a portal user types a very specific or novel subject
  And no published articles match the keywords
  Then no article panel is displayed
  And the user can proceed directly to case submission
```

---

### MKT-US-SRVC-013 — Attach Knowledge Article to Case Response

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-SRVC-013 |
| **Priority** | Should Have |
| **Persona** | Support Agent |

**User Story**

As a **Support Agent**, I want to attach a knowledge article link to a case response with a single click so that I can provide consistent, accurate answers quickly without copying and pasting URLs manually.

**Acceptance Criteria**

```
Scenario: Agent attaches an article to a case email response
  Given a Support Agent is composing a case email reply in the Service Console
  When they click "Insert Knowledge Article"
  Then a search panel opens within the compose window
  And the agent can search and select a published article
  And the article title and URL are automatically inserted into the email body

Scenario: Article inserted in response is tracked on the case
  Given an agent inserts a knowledge article into a case response
  Then the article is recorded in the Case's "Knowledge Articles Used" related list
  And this data is available for reporting on article effectiveness
```

---

## **5.4 Omni-Channel & Queue Management**

---

### MKT-US-SRVC-014 — Case Routing by Record Type and Tier

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-SRVC-014 |
| **Priority** | Must Have |
| **Persona** | Support Agent, Support Team Lead |

**User Story**

As a **Support Team Lead**, I want cases to be automatically routed to the correct queue based on case record type and subscription tier so that Enterprise cases are always prioritised and agents handle cases within their domain.

**Acceptance Criteria**

```
Scenario: Enterprise case routed to Enterprise Support queue
  Given a new case is created with Record Type = "Technical Support"
  And the related Account has Subscription Tier = "Enterprise"
  When the routing rule evaluates the case
  Then the case is assigned to the "Enterprise Technical Support" queue
  And its priority is set to "High"

Scenario: Billing Enquiry routed to Billing queue regardless of tier
  Given a new case is created with Record Type = "Billing Enquiry"
  When the routing rule evaluates the case
  Then the case is assigned to the "Billing" queue
  And priority reflects the Account's subscription tier

Scenario: Starter/Professional Technical Support routed to General queue
  Given a new case has Record Type = "Technical Support"
  And the Account has Subscription Tier = "Starter" or "Professional"
  When the routing rule runs
  Then the case is assigned to the "General Technical Support" queue
  And priority is set to "Normal"
```

---

### MKT-US-SRVC-015 — Skills-Based Routing via Omni-Channel

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-SRVC-015 |
| **Priority** | Should Have |
| **Persona** | Support Agent, Support Team Lead |

**User Story**

As a **Support Team Lead**, I want Omni-Channel to route cases to the most suitable available agent based on their declared skills and current capacity so that first-contact resolution rates improve.

**Acceptance Criteria**

```
Scenario: Technical case routed to agent with Technical skill
  Given Agent A has skills: Technical (Level 4), Billing (Level 2)
  And Agent B has skills: Billing (Level 4), Onboarding (Level 3)
  And a new Technical Support case enters the queue
  When Omni-Channel evaluates agent availability and skills
  Then the case is offered to Agent A before Agent B
  And Agent A's capacity utilisation is updated accordingly

Scenario: Agent at capacity does not receive new work items
  Given Agent A is configured with a maximum capacity of 3 work items
  And Agent A currently has 3 active cases
  When a new case enters the Technical Support queue
  Then the case is not offered to Agent A
  And is instead offered to the next eligible available agent

Scenario: No eligible agent available — case waits in queue
  Given all agents with the required skill are at capacity or offline
  When a new case enters the queue
  Then the case remains in queue and is not assigned
  And the Support Team Lead sees the queued case in the supervisor panel
```

---

### MKT-US-SRVC-016 — Omni-Channel Supervisor Panel

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-SRVC-016 |
| **Priority** | Should Have |
| **Persona** | Support Team Lead |

**User Story**

As a **Support Team Lead**, I want a real-time Omni-Channel supervisor panel so that I can see agent availability, queue depth, and work assignments at any moment and react to intraday spikes.

**Acceptance Criteria**

```
Scenario: Supervisor panel shows all agent statuses
  Given the Support Team Lead opens the Omni-Channel Supervisor panel
  Then they see all configured agents with their current status:
       Available | Busy | On Break | Offline
  And the number of active work items assigned to each agent

Scenario: Supervisor panel shows queue depth in real time
  Given the Enterprise Support queue has 4 unassigned cases
  When the Team Lead views the supervisor panel
  Then the Enterprise Support queue shows a depth of 4
  And updates dynamically as cases are assigned or new cases arrive

Scenario: Team Lead can manually reassign a work item
  Given a case is assigned to an agent who has gone offline
  When the Team Lead selects the case in the supervisor panel
  And clicks "Reassign"
  Then they can select another available agent
  And the case is transferred to the selected agent
```

---

# **6. User Stories — Experience Cloud**

## **6.1 Authentication & Access**

---

### MKT-US-EXP-001 — Portal Authentication & Self-Registration

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-EXP-001 |
| **Priority** | Must Have |
| **Persona** | Catalyst Client, System Administrator |

**User Story**

As a **new Catalyst client**, I want to receive a self-registration link via welcome email so that I can activate my portal account without contacting support, and all subsequent visits require my credentials.

**Acceptance Criteria**

```
Scenario: New client receives self-registration email on contract signature
  Given a new Account is set to Subscription Status = "Active"
  When the onboarding flow triggers
  Then a welcome email is sent to the Primary Platform Contact
  And the email contains a unique self-registration URL valid for 7 days

Scenario: Client completes self-registration
  Given a client clicks their self-registration link
  When they set a password meeting the portal's complexity requirements
  Then their portal user account is activated
  And they are directed to the portal home page
  And the self-registration link is invalidated

Scenario: Unauthenticated visitor cannot access protected portal content
  Given a user has not logged in
  When they attempt to navigate to the portal dashboard URL directly
  Then they are redirected to the portal login page
  And no client data is visible
```

---

### MKT-US-EXP-002 — Portal User Data Isolation

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-EXP-002 |
| **Priority** | Must Have |
| **Persona** | Catalyst Client, System Administrator |

**User Story**

As a **System Administrator**, I want portal users to be restricted to data belonging to their own Account only, so that no client can ever see another client's cases, subscriptions, or contacts.

**Acceptance Criteria**

```
Scenario: Portal user can only see their own Account's cases
  Given Client A and Client B both have open cases
  When Client A's portal user views the "My Cases" page
  Then only cases linked to Client A's Account are displayed
  And Client B's cases are not returned in any query or list

Scenario: Portal user cannot access another Account's record via URL manipulation
  Given Client A knows Client B's case record ID
  When Client A manually enters the case URL in their browser
  Then they receive a "Record Not Found" or "Insufficient Privileges" error
  And Client B's case data is not exposed

Scenario: Sharing rules grant access within the client's Account hierarchy
  Given a portal user has colleagues on the same Account
  When they view the "Team Cases" section
  Then they can see all cases submitted by any contact on their Account
```

---

### MKT-US-EXP-003 — Portal Role-Based Access

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-EXP-003 |
| **Priority** | Should Have |
| **Persona** | Portal Account Admin, Catalyst Client |

**User Story**

As a **Portal Account Admin**, I want a distinct set of permissions that allow me to manage team members and view billing information, while Standard Users only access case management and knowledge.

**Acceptance Criteria**

```
Scenario: Standard portal user cannot access billing summary page
  Given a Standard User navigates to the Subscription Summary page
  Then they receive a "You do not have access to this page" message
  And the billing data is not displayed

Scenario: Account Admin can view the subscription and billing summary
  Given a Portal Account Admin navigates to the Subscription Summary page
  Then they can see ACV, contract dates, payment status, and module licences
  And can request an invoice download

Scenario: Account Admin can add team members to the portal
  Given a Portal Account Admin navigates to "Team Management"
  When they enter a colleague's email address and select a role
  Then a self-registration invitation is sent to the colleague
  And the colleague appears as "Pending" in the team list until they activate
```

---

## **6.2 Client Dashboard & Subscription Summary**

---

### MKT-US-EXP-004 — Client Portal Home Dashboard

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-EXP-004 |
| **Priority** | Must Have |
| **Persona** | Catalyst Client |

**User Story**

As a **Catalyst Client**, I want a personalised home dashboard when I log into the portal so that I can immediately see the health and status of my Catalyst subscription without navigating multiple pages.

**Acceptance Criteria**

```
Scenario: Dashboard displays personalised data on login
  Given Client A logs into the portal
  Then the home dashboard displays:
       Active Modules (from Account — Modules Purchased)
       Contract Renewal Date (from Account)
       Open Case Count (cases linked to their Account in open status)
       Unread Knowledge Articles count (based on publication date)
       Platform Usage Summary (from mock API — overall usage %)

Scenario: Open Case Count is a clickable link
  Given the dashboard shows "3 Open Cases"
  When the client clicks the count
  Then they are taken to the filtered case list showing only their open cases

Scenario: Usage summary reflects mock API data
  Given the mock Catalyst Platform usage API returns usage data for the client's account
  When the dashboard loads
  Then the Platform Usage Summary tile displays the correct overall percentage
  And a breakdown by module is visible on hover or click
```

---

### MKT-US-EXP-005 — Subscription Summary Page

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-EXP-005 |
| **Priority** | Should Have |
| **Persona** | Portal Account Admin |

**User Story**

As a **Portal Account Admin**, I want a subscription summary page that shows my contract details and licence status so that I can answer internal billing questions without emailing Catalyst support.

**Acceptance Criteria**

```
Scenario: Subscription summary page shows correct contract data
  Given a Portal Account Admin navigates to "Subscription & Billing"
  Then the page displays:
       Annual Contract Value (formatted as currency)
       Contract Start Date and Contract End Date
       Payment Status (Current / Overdue)
       Licensed Modules with activation status (Active / Inactive)

Scenario: Days to Renewal is prominently displayed
  Given a contract has 45 days remaining
  Then a "45 days to renewal" indicator is shown prominently on the page
  And a "Contact Your Account Manager" CTA is displayed

Scenario: Billing data is read-only for portal users
  Given a Portal Account Admin views the subscription summary
  Then all displayed values are read-only
  And no edit controls are available on the page
```

---

### MKT-US-EXP-006 — Module Usage Heat Map

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-EXP-006 |
| **Priority** | Could Have |
| **Persona** | Catalyst Client |

**User Story**

As a **Catalyst Client**, I want to see a visual heat map of my module usage over the past 30 days so that I can understand which tools my team is using and identify underutilised modules.

**Acceptance Criteria**

```
Scenario: Heat map displays usage data from mock API
  Given the mock usage API returns 30-day usage percentages per module
  When an authenticated portal user views the "Usage Analytics" section
  Then a heat map is displayed showing each licensed module
  And each module cell is colour-coded: High (≥70%), Medium (30–69%), Low (<30%)

Scenario: Hovering a module cell shows usage detail
  Given the heat map is displayed
  When the user hovers over "Attribution Engine"
  Then a tooltip shows: Module name, 30-day usage %, active users count

Scenario: Unlicensed modules are displayed as greyed out with upgrade CTA
  Given the client does not have "Content Hub" licensed
  When they view the usage heat map
  Then Content Hub is displayed in grey with text: "Not in your plan — Upgrade"
  And clicking it opens a contact form to the Account Manager
```

---

## **6.3 Case Management in the Portal**

---

### MKT-US-EXP-007 — Portal Case Submission Form

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-EXP-007 |
| **Priority** | Must Have |
| **Persona** | Catalyst Client |

**User Story**

As a **Catalyst Client**, I want to submit a structured support case through the portal so that the support team receives complete information upfront and I don't spend time on back-and-forth clarification emails.

**Acceptance Criteria**

```
Scenario: Case submission form contains all required fields
  Given an authenticated portal user navigates to "Submit a Case"
  Then the form presents the following fields:
       Subject (text, required)
       Description (text area, required, min 20 characters)
       Case Type (picklist: maps to Case Record Types, required)
       Affected Module (multi-select picklist: licensed modules, required)
       Urgency (picklist: Low / Medium / High / Critical, required)

Scenario: Form submission creates a Case in Salesforce
  Given the portal user completes all required fields and submits
  Then a Case record is created with:
       Origin = "Portal"
       Status = "New"
       Contact = authenticated user
       Account = user's Account
       All form field values correctly mapped

Scenario: Portal user receives confirmation after submission
  Given a case has been submitted successfully
  Then the portal user sees a confirmation message with the Case Number
  And a confirmation email is sent to the user's registered address
```

---

### MKT-US-EXP-008 — Portal Case List & Management

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-EXP-008 |
| **Priority** | Must Have |
| **Persona** | Catalyst Client |

**User Story**

As a **Catalyst Client**, I want to view, update, and track all my cases in the portal so that I can monitor progress and add context without sending emails to the support team.

**Acceptance Criteria**

```
Scenario: Portal user can view all cases for their Account
  Given an authenticated portal user navigates to "My Cases"
  Then they see a list of all open and closed cases linked to their Account
  And each row shows: Case Number, Subject, Status, Last Updated, and Urgency

Scenario: Portal user can add a comment to an open case
  Given a portal user opens a specific case detail page
  When they type a comment and click "Add Comment"
  Then the comment is saved and visible as a Case Comment on the record
  And the assigned Support Agent receives a notification of the new comment

Scenario: Portal user can upload an attachment to a case
  Given a portal user is on the case detail page
  When they click "Add Attachment" and select a file from their device
  Then the file is attached to the case record
  And the file is visible in the case's Files related list to both the client and agent
```

---

### MKT-US-EXP-009 — Knowledge Deflection at Case Submission

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-EXP-009 |
| **Priority** | Must Have |
| **Persona** | Catalyst Client |

**User Story**

As a **Catalyst Client**, I want the portal to surface relevant articles as I describe my issue so that I can resolve common problems myself without waiting for agent response.

**Acceptance Criteria**

```
Scenario: Article suggestions appear as the subject is typed
  Given a portal user begins entering the case subject field
  When they have typed at least 3 words
  Then up to 5 relevant published knowledge articles are displayed in a panel
  And each suggestion shows the article title and a one-sentence excerpt

Scenario: User resolves issue via suggested article — no case submitted
  Given article suggestions are displayed
  When the user clicks an article and then selects "Yes, this resolved my issue"
  Then the case submission form is cleared
  And the user is returned to the portal home
  And a deflection event is recorded against the article for reporting

Scenario: User dismisses suggestions and continues with case submission
  Given article suggestions are displayed
  When the user selects "No, I still need help"
  Then the article panel collapses
  And the user can complete and submit the case form normally
```

---

## **6.4 Onboarding Experience**

---

### MKT-US-EXP-010 — Onboarding Checklist

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-EXP-010 |
| **Priority** | Must Have |
| **Persona** | Catalyst Client |

**User Story**

As a **new Catalyst Client**, I want a structured onboarding checklist visible on my portal home page so that I know exactly what steps I need to complete to get started and can track my progress.

**Acceptance Criteria**

```
Scenario: Onboarding checklist is visible for new clients
  Given a client has activated their portal account within the last 90 days
  And not all onboarding steps are marked complete
  When they log into the portal
  Then the Onboarding Checklist is displayed prominently on the home page
  And shows progress as a percentage (e.g., "3 of 5 steps complete — 60%")

Scenario: Checklist contains exactly the required steps
  Given a new client views their onboarding checklist
  Then the following steps are listed in order:
       1. Complete company profile
       2. Add team members
       3. Connect data source
       4. Attend kickoff call
       5. Complete platform training

Scenario: Completed steps are marked and checklist updates dynamically
  Given a client completes "Add team members" by inviting a colleague
  When they return to the portal home
  Then step 2 is shown with a checkmark and strikethrough
  And the progress indicator updates to reflect the new completion state

Scenario: Checklist is hidden after all steps are complete
  Given a client has completed all 5 onboarding steps
  When they log into the portal
  Then the onboarding checklist is no longer displayed on the home page
  And a "Onboarding Complete" badge is shown in its place
```

---

### MKT-US-EXP-011 — Onboarding Step Resource Links

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-EXP-011 |
| **Priority** | Should Have |
| **Persona** | Catalyst Client |

**User Story**

As a **new Catalyst Client**, I want each onboarding step to link to a relevant knowledge article or training video so that I can complete setup with guided help, not trial and error.

**Acceptance Criteria**

```
Scenario: Each checklist step has an associated resource link
  Given a client views the Onboarding Checklist
  When they expand any checklist step
  Then a "Help Guide" link is displayed pointing to the relevant published knowledge article

Scenario: Training video is embedded for "Complete platform training" step
  Given a client expands step 5 "Complete platform training"
  Then an embedded video player is displayed within the portal
  And the video plays without navigating away from the portal

Scenario: Article link opens without losing checklist state
  Given a client clicks a "Help Guide" link from step 3
  When the article opens in a modal or side panel
  Then the checklist state is preserved
  And the client can return to the checklist without losing their position
```

---

## **6.5 Agentforce — Aria, the Catalyst Client Assistant**

---

### MKT-US-EXP-012 — Aria Core Capabilities

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-EXP-012 |
| **Priority** | Must Have |
| **Persona** | Catalyst Client |

**User Story**

As a **Catalyst Client**, I want access to an AI assistant named Aria within the portal so that I can get instant answers to common questions, check my case status, and get onboarding guidance without waiting for a human agent.

**Acceptance Criteria**

```
Scenario: Aria is accessible from the portal via a persistent chat widget
  Given an authenticated portal user is on any portal page
  Then an Aria chat widget is visible in the lower-right corner of the screen
  And clicking it opens a chat panel without leaving the current page

Scenario: Aria answers a knowledge-grounded question
  Given a client asks Aria: "How do I connect a data source to Audience Studio?"
  When Aria evaluates the query
  Then Aria returns a response grounded in a published knowledge article
  And includes a link to the full article for further reading

Scenario: Aria retrieves case status for the authenticated user
  Given a client asks Aria: "What is the status of my latest case?"
  When Aria invokes the GetCaseStatus action
  Then Aria returns the Case Number, Subject, and current Status
  And the response includes when the case was last updated

Scenario: Aria guides a user through an onboarding step
  Given a client asks Aria: "How do I complete my company profile?"
  When Aria evaluates the query
  Then Aria provides step-by-step guidance
  And offers a link to the relevant onboarding checklist item in the portal
```

---

### MKT-US-EXP-013 — Aria Agent Topic & Actions

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-EXP-013 |
| **Priority** | Must Have |
| **Persona** | System Administrator |

**User Story**

As a **System Administrator**, I want Aria configured with a defined Agent Topic and four named actions so that the agent's scope is explicitly bounded and each capability is independently testable.

**Acceptance Criteria**

```
Scenario: Aria has one configured Agent Topic
  Given a System Administrator opens Aria's agent configuration in Setup
  Then one Agent Topic exists named: "Client Self-Service"
  And the topic description clearly scopes Aria to portal support tasks

Scenario: All four actions are configured on the Client Self-Service topic
  Given the Agent Topic "Client Self-Service" is open in Setup
  Then the following actions are configured:
       SearchKnowledge — searches the Knowledge base by user query
       GetCaseStatus — retrieves open case status for the authenticated user
       GetOnboardingProgress — returns the client's onboarding checklist state
       EscalateToAgent — initiates human escalation per MKT-US-EXP-015

Scenario: Aria invokes the correct action for each intent
  Given Aria receives a user message
  When the intent maps to a configured action
  Then Aria invokes only that action and returns a response grounded in its output
  And does not invoke out-of-scope actions or make up information
```

---

### MKT-US-EXP-014 — Aria Persona & Tone

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-EXP-014 |
| **Priority** | Should Have |
| **Persona** | System Administrator |

**User Story**

As a **System Administrator**, I want Aria's system prompt to define her persona, communication tone, and scope boundaries so that every response is professional, empathetic, and consistent with Catalyst's brand voice.

**Acceptance Criteria**

```
Scenario: System prompt enforces professional and empathetic tone
  Given Aria's system prompt is configured
  Then the prompt includes:
       Persona definition: "You are Aria, Catalyst's client support assistant..."
       Tone guidelines: professional, empathetic, concise, jargon-free
       Scope boundary: Aria only responds to topics within the Client Self-Service topic

Scenario: Aria does not respond to out-of-scope questions
  Given a client asks Aria: "Write me a marketing strategy"
  When Aria evaluates the request
  Then Aria politely declines and redirects:
       "That's outside what I can help with. I'm here to assist with your
        Catalyst account, cases, and onboarding. Is there anything on those topics I can help with?"

Scenario: Aria uses the client's first name where available
  Given the authenticated user's name is "Sarah"
  When Aria responds to any message
  Then the response addresses the user as "Sarah" where contextually appropriate
  And never uses generic salutations like "Dear User"
```

---

### MKT-US-EXP-015 — Aria Human Escalation

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-EXP-015 |
| **Priority** | Should Have |
| **Persona** | Catalyst Client, Support Agent |

**User Story**

As a **Catalyst Client**, I want Aria to recognise when she cannot resolve my issue and smoothly hand me off to a human agent, so that I never reach a dead end in the chat.

**Acceptance Criteria**

```
Scenario: Aria recognises an unresolvable query and offers escalation
  Given a client asks a question Aria cannot answer from the knowledge base
  Or Aria has attempted to answer twice without satisfying the client
  When Aria determines escalation is appropriate
  Then Aria says:
       "I wasn't able to fully resolve this for you. Would you like me to
        connect you with a support agent? They'll have your conversation summary ready."
  And presents [Yes, connect me] and [No, I'll try another way] options

Scenario: Client confirms escalation — case is pre-populated
  Given the client selects "Yes, connect me"
  When the EscalateToAgent action fires
  Then a Case record is created in Salesforce with:
       Subject = summary of the Aria conversation topic
       Description = transcript of the chat session
       Origin = "Agentforce Chat"
       Status = "New"
  And the case is assigned to the Omni-Channel queue per routing rules

Scenario: Client declines escalation
  Given the client selects "No, I'll try another way"
  When Aria continues the conversation
  Then no case is created
  And Aria offers alternative self-service options (knowledge search, onboarding checklist)
```

---

# **7. Non-Functional User Stories**

---

### MKT-US-NFR-001 — Page Load Performance

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-NFR-001 |
| **Priority** | Must Have |
| **Persona** | All users |

**User Story**

As any **user of the Catalyst org**, I want all Lightning record pages to load in under 3 seconds on a standard broadband connection so that the CRM feels responsive and does not slow down my work.

**Acceptance Criteria**

```
Scenario: Record pages meet load time threshold
  Given a user with a standard broadband connection (≥50 Mbps)
  When they navigate to any standard or custom Lightning record page
  Then the page is fully interactive within 3 seconds
  As measured by the Lightning Usage App and browser developer tools

Scenario: Dashboard components load within threshold
  Given a user opens a Sales or Service dashboard
  When all dashboard components have rendered
  Then total load time does not exceed 3 seconds for a dashboard with ≤10 components
```

---

### MKT-US-NFR-002 — Apex Governor Limit Safety

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-NFR-002 |
| **Priority** | Must Have |
| **Persona** | System Administrator |

**User Story**

As a **System Administrator**, I want all Apex code to execute within Salesforce governor limits so that no operation fails in production due to limit exceptions.

**Acceptance Criteria**

```
Scenario: No SOQL queries return more than 100 rows without pagination
  Given any Apex class performs a SOQL query
  When the query could return more than 100 rows
  Then the query uses LIMIT or is paginated using OFFSET or SOQL cursor
  And is verified in test execution with a large data volume scenario

Scenario: No DML operations occur inside loops
  Given any Apex class performs DML (insert, update, delete, upsert)
  Then DML is performed outside of for/while loops in all cases
  And bulk-safe patterns (collections + single DML) are used throughout

Scenario: No governor limit exceptions in test execution
  Given all Apex test classes are executed in the target org
  Then zero LimitException errors appear in the test results
```

---

### MKT-US-NFR-003 — Apex Security Standards

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-NFR-003 |
| **Priority** | Must Have |
| **Persona** | System Administrator |

**User Story**

As a **System Administrator**, I want all custom Apex to pass Salesforce security standards so that the org has no code-level vulnerabilities that could expose client data.

**Acceptance Criteria**

```
Scenario: No hardcoded credentials in Apex
  Given any Apex class is reviewed
  Then no usernames, passwords, API keys, or tokens are present as string literals
  And Named Credentials or Custom Metadata is used for all credential references

Scenario: No SOQL injection vectors
  Given any Apex class constructs a dynamic SOQL query
  Then the query uses String.escapeSingleQuotes() or bind variables
  And is verified with a test case supplying a SQL injection attack string

Scenario: All user inputs are sanitised before processing
  Given any Apex class receives input from a user-facing form or API
  Then inputs are validated against expected type and format before use
  And invalid inputs throw a handled exception with a user-friendly message
```

---

### MKT-US-NFR-004 — Principle of Least Privilege

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-NFR-004 |
| **Priority** | Must Have |
| **Persona** | System Administrator |

**User Story**

As a **System Administrator**, I want all profiles and permission sets configured to grant only the access each role requires so that no user has unnecessary access to sensitive data or configuration.

**Acceptance Criteria**

```
Scenario: Sales Rep profile cannot access Service Console or Knowledge admin
  Given a user with the Sales User profile logs in
  Then the Service Console app is not accessible
  And Knowledge article management tabs are not visible

Scenario: Portal user cannot access internal Salesforce records
  Given an authenticated portal user attempts to access a non-portal object
  Then they receive an "Insufficient Privileges" error
  And no internal-only record data is returned

Scenario: Permission set audit checklist is complete
  Given the TDD security model is finalised
  Then a permission set audit has been documented in MKT-TDD-1.0
  And no profile grants "Modify All Data" except the System Administrator
```

---

### MKT-US-NFR-005 — Graceful Integration Failure Handling

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-NFR-005 |
| **Priority** | Must Have |
| **Persona** | All users |

**User Story**

As any **user of the Catalyst org**, I want integration failures (mock API timeouts or errors) to display a friendly message rather than a system error so that my workflow is not disrupted by external dependency issues.

**Acceptance Criteria**

```
Scenario: Mock API callout returns a timeout — graceful UI message displayed
  Given the mock Catalyst Platform usage API does not respond within 10 seconds
  When a portal user loads the platform usage widget
  Then the widget displays: "Usage data is temporarily unavailable. Please try again shortly."
  And no stack trace or system error is shown

Scenario: Failed callout is logged for admin review
  Given a callout to the mock billing API fails
  Then a Platform Event or Custom Log record is created with:
       Timestamp, endpoint, error code, and affected user/record
  And the admin can view failures in a dedicated error log report
```

---

### MKT-US-NFR-006 — Apex Test Coverage

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-NFR-006 |
| **Priority** | Must Have |
| **Persona** | System Administrator |

**User Story**

As a **System Administrator**, I want all Apex classes to achieve a minimum of 85% test coverage using test factory patterns so that the codebase is regression-safe and meets deployment standards.

**Acceptance Criteria**

```
Scenario: All Apex classes meet minimum 85% coverage
  Given all Apex test classes are run in the target org
  Then every custom Apex class reports ≥85% line coverage in Salesforce Setup
  And the overall org coverage is ≥85%

Scenario: Test classes use a centralised test factory
  Given any Apex test class is reviewed
  Then test data is created using a TestDataFactory class
  And no test class creates records inline using Account acct = new Account(Name='Test')

Scenario: Test assertions are meaningful
  Given any Apex test method is reviewed
  Then every test method contains at least one System.assert / System.assertEquals call
  And no test passes purely by reaching 100% line coverage without assertions
```

---

### MKT-US-NFR-007 — WCAG 2.1 AA Accessibility

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-NFR-007 |
| **Priority** | Must Have |
| **Persona** | All users |

**User Story**

As any **user of the Catalyst portal**, I want the Experience Cloud site and all custom components to meet WCAG 2.1 AA accessibility standards so that the platform is usable regardless of ability.

**Acceptance Criteria**

```
Scenario: All custom LWC components pass automated accessibility audit
  Given any custom LWC component is deployed to the Experience Cloud site
  When a browser accessibility audit is run (Chrome Lighthouse or axe)
  Then zero critical or serious accessibility violations are reported
  And any warnings are documented with remediation plans

Scenario: All portal pages meet colour contrast requirements
  Given any Experience Cloud page is rendered
  Then all text elements meet a minimum contrast ratio of 4.5:1 (normal text)
       and 3:1 (large text) per WCAG 2.1 AA criteria

Scenario: All interactive elements are keyboard navigable
  Given a user navigates the portal using keyboard only (Tab, Enter, Space)
  Then all interactive elements (buttons, links, form fields, modals) are reachable
  And focus indicators are visible on all interactive elements
```

---

### MKT-US-NFR-008 — Source Control Coverage

| Field | Value |
| :---- | :---- |
| **Parent Req.** | MKT-REQ-NFR-008 |
| **Priority** | Must Have |
| **Persona** | System Administrator |

**User Story**

As a **System Administrator**, I want all org configuration and code to be tracked in Git via SFDX so that the org can be fully reproduced from source control at any time.

**Acceptance Criteria**

```
Scenario: SFDX retrieve returns no untracked metadata delta
  Given all configuration work has been committed to the vertical branch
  When sf project retrieve start is run against the target org
  Then the retrieved metadata produces no diff against the committed source
  And all objects, flows, Apex, LWC, and profiles are present in the repo

Scenario: Org can be deployed to a clean scratch org from source
  Given the main branch is at a stable release tag
  When sf project deploy start is run against a new scratch org
  Then all metadata deploys without error
  And all Apex tests pass in the newly deployed scratch org
```

---

# **8. Requirements Traceability Matrix**

The table below maps each user story to its parent BRD requirement and confirms the priority inheritance. All test cases in MKT-TPQA-1.0 reference the User Story ID in the leftmost column.

| User Story ID | Parent Req. ID | Priority | Module | Persona |
| :---- | :---- | :---- | :---- | :---- |
| MKT-US-SALES-001 | MKT-REQ-SALES-001 | Must Have | Lead Mgmt | SDR |
| MKT-US-SALES-002 | MKT-REQ-SALES-002 | Must Have | Lead Mgmt | Sales Manager |
| MKT-US-SALES-003 | MKT-REQ-SALES-003 | Must Have | Lead Mgmt | Sales Manager |
| MKT-US-SALES-004 | MKT-REQ-SALES-004 | Should Have | Lead Mgmt | SDR |
| MKT-US-SALES-005 | MKT-REQ-SALES-005 | Must Have | Lead Mgmt | Sales Manager |
| MKT-US-SALES-006 | MKT-REQ-SALES-006 | Should Have | Lead Mgmt | Sales Manager |
| MKT-US-SALES-007 | MKT-REQ-SALES-007 | Must Have | Acct & Contact | AE |
| MKT-US-SALES-008 | MKT-REQ-SALES-008 | Must Have | Acct & Contact | AE |
| MKT-US-SALES-009 | MKT-REQ-SALES-009 | Must Have | Acct & Contact | AE |
| MKT-US-SALES-010 | MKT-REQ-SALES-010 | Should Have | Acct & Contact | VP CS |
| MKT-US-SALES-011 | MKT-REQ-SALES-011 | Could Have | Acct & Contact | Sys Admin |
| MKT-US-SALES-012 | MKT-REQ-SALES-012 | Must Have | Opportunity | Sales Manager |
| MKT-US-SALES-013 | MKT-REQ-SALES-013 | Must Have | Opportunity | AE |
| MKT-US-SALES-014 | MKT-REQ-SALES-014 | Must Have | Opportunity | AE |
| MKT-US-SALES-015 | MKT-REQ-SALES-015 | Must Have | Opportunity | AE |
| MKT-US-SALES-016 | MKT-REQ-SALES-016 | Should Have | Opportunity | AE |
| MKT-US-SALES-017 | MKT-REQ-SALES-017 | Should Have | Opportunity | AE |
| MKT-US-SALES-018 | MKT-REQ-SALES-018 | Must Have | Forecasting | VP Sales |
| MKT-US-SALES-019 | MKT-REQ-SALES-019 | Must Have | Forecasting | VP Sales |
| MKT-US-SALES-020 | MKT-REQ-SALES-020 | Should Have | Forecasting | AE |
| MKT-US-SRVC-001 | MKT-REQ-SRVC-001 | Must Have | Case Mgmt | Support Agent |
| MKT-US-SRVC-002 | MKT-REQ-SRVC-002 | Must Have | Case Mgmt | Support Agent |
| MKT-US-SRVC-003 | MKT-REQ-SRVC-003 | Must Have | Case Mgmt | Support Agent |
| MKT-US-SRVC-004 | MKT-REQ-SRVC-004 | Must Have | Case Mgmt | Support Agent |
| MKT-US-SRVC-005 | MKT-REQ-SRVC-005 | Must Have | Case Mgmt | Team Lead |
| MKT-US-SRVC-006 | MKT-REQ-SRVC-006 | Should Have | Case Mgmt | VP CS |
| MKT-US-SRVC-007 | MKT-REQ-SRVC-007 | Must Have | SLA | Team Lead |
| MKT-US-SRVC-008 | MKT-REQ-SRVC-008 | Must Have | SLA | VP CS |
| MKT-US-SRVC-009 | MKT-REQ-SRVC-009 | Should Have | SLA | VP CS |
| MKT-US-SRVC-010 | MKT-REQ-SRVC-010 | Must Have | Knowledge | Knowledge Mgr |
| MKT-US-SRVC-011 | MKT-REQ-SRVC-011 | Must Have | Knowledge | Knowledge Mgr |
| MKT-US-SRVC-012 | MKT-REQ-SRVC-012 | Should Have | Knowledge | Catalyst Client |
| MKT-US-SRVC-013 | MKT-REQ-SRVC-013 | Should Have | Knowledge | Support Agent |
| MKT-US-SRVC-014 | MKT-REQ-SRVC-014 | Must Have | Omni-Channel | Team Lead |
| MKT-US-SRVC-015 | MKT-REQ-SRVC-015 | Should Have | Omni-Channel | Team Lead |
| MKT-US-SRVC-016 | MKT-REQ-SRVC-016 | Should Have | Omni-Channel | Team Lead |
| MKT-US-EXP-001 | MKT-REQ-EXP-001 | Must Have | Auth | Catalyst Client |
| MKT-US-EXP-002 | MKT-REQ-EXP-002 | Must Have | Auth | Sys Admin |
| MKT-US-EXP-003 | MKT-REQ-EXP-003 | Should Have | Auth | Portal Admin |
| MKT-US-EXP-004 | MKT-REQ-EXP-004 | Must Have | Dashboard | Catalyst Client |
| MKT-US-EXP-005 | MKT-REQ-EXP-005 | Should Have | Dashboard | Portal Admin |
| MKT-US-EXP-006 | MKT-REQ-EXP-006 | Could Have | Dashboard | Catalyst Client |
| MKT-US-EXP-007 | MKT-REQ-EXP-007 | Must Have | Portal Cases | Catalyst Client |
| MKT-US-EXP-008 | MKT-REQ-EXP-008 | Must Have | Portal Cases | Catalyst Client |
| MKT-US-EXP-009 | MKT-REQ-EXP-009 | Must Have | Portal Cases | Catalyst Client |
| MKT-US-EXP-010 | MKT-REQ-EXP-010 | Must Have | Onboarding | Catalyst Client |
| MKT-US-EXP-011 | MKT-REQ-EXP-011 | Should Have | Onboarding | Catalyst Client |
| MKT-US-EXP-012 | MKT-REQ-EXP-012 | Must Have | Agentforce | Catalyst Client |
| MKT-US-EXP-013 | MKT-REQ-EXP-013 | Must Have | Agentforce | Sys Admin |
| MKT-US-EXP-014 | MKT-REQ-EXP-014 | Should Have | Agentforce | Sys Admin |
| MKT-US-EXP-015 | MKT-REQ-EXP-015 | Should Have | Agentforce | Catalyst Client |
| MKT-US-NFR-001 | MKT-REQ-NFR-001 | Must Have | Performance | All |
| MKT-US-NFR-002 | MKT-REQ-NFR-002 | Must Have | Performance | Sys Admin |
| MKT-US-NFR-003 | MKT-REQ-NFR-003 | Must Have | Security | Sys Admin |
| MKT-US-NFR-004 | MKT-REQ-NFR-004 | Must Have | Security | Sys Admin |
| MKT-US-NFR-005 | MKT-REQ-NFR-005 | Must Have | Availability | All |
| MKT-US-NFR-006 | MKT-REQ-NFR-006 | Must Have | Code Quality | Sys Admin |
| MKT-US-NFR-007 | MKT-REQ-NFR-007 | Must Have | Accessibility | All |
| MKT-US-NFR-008 | MKT-REQ-NFR-008 | Must Have | Maintainability | Sys Admin |

---

*End of MKT-USAC-1.0 — User Stories & Acceptance Criteria*

*Next document in sequence: MKT-TDD-1.0 — Technical Design Document*
