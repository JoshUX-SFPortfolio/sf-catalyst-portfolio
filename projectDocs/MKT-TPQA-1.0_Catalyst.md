
**CATALYST MARKETING TECHNOLOGIES, INC.**

*Accelerate Every Campaign.*

**TEST PLAN & QA SCRIPTS**

**Salesforce CRM Implementation**

Sales Cloud · Service Cloud · Experience Cloud

| Document ID | MKT-TPQA-1.0 |
| :---- | :---- |
| **Status** | COMPLETE |
| **Version** | 1.0 |
| **Vertical** | Marketing — Baseline |
| **Company** | Catalyst Marketing Technologies, Inc. |
| **Prepared By** | Portfolio Developer |
| **Date** | 2026-03-08 |
| **Parent Doc** | MKT-DD-1.0 — Data Dictionary & ERD |
| **Traces From** | MKT-USAC-1.0, MKT-TDD-1.0 |

---

# Table of Contents

1. Document Control
2. Purpose & Scope
3. Test Strategy
4. Test Environments
5. Test Case Summary
6. Detailed Test Scripts — Sales Cloud
7. Detailed Test Scripts — Service Cloud
8. Detailed Test Scripts — Experience Cloud
9. Detailed Test Scripts — Non-Functional
10. Regression Test Suite
11. UAT Scenarios
12. Defect Management
13. Go-Live Entry Criteria
14. Traceability Matrix

---

# 1. Document Control

## 1.1 Version History

| Version | Date | Author | Changes | Status |
| :---- | :---- | :---- | :---- | :---- |
| 1.0 | 2026-03-08 | Portfolio Developer | Initial draft — full test suite | Draft |
| 1.1 | 2026-03-08 | Portfolio Developer | B.6 phase close — 83/83 Apex tests passing (Run ID: 707gL00000dWsJo); all acceptance criteria validated | Complete |

## 1.2 Related Documents

| Doc ID | Document | Relationship |
| :---- | :---- | :---- |
| MKT-BRD-1.0 | Business Requirements Document | Source requirements |
| MKT-USAC-1.0 | User Stories & Acceptance Criteria | Acceptance criteria this plan validates |
| MKT-TDD-1.0 | Technical Design Document | System design under test |
| MKT-DD-1.0 | Data Dictionary & ERD | Field names and validation rules referenced in test steps |

---

# 2. Purpose & Scope

This document defines the complete test plan and QA script library for the Catalyst Salesforce CRM implementation. It provides:

- A test strategy aligned to the delivery phases in MKT-TDD-1.0 Section 13
- Individual test case scripts with step-by-step procedures and expected results
- Acceptance criteria validation mapping to MKT-USAC-1.0
- A regression test suite for post-build validation
- UAT scenarios for business stakeholder sign-off
- Defect severity classification and go-live entry criteria

## 2.1 In Scope

All functional and non-functional requirements defined in MKT-BRD-1.0. Specifically:

- Sales Cloud: Lead management, Account/Contact management, Opportunity lifecycle, quoting, forecasting, dashboards
- Service Cloud: Case management, SLA entitlements, escalation, Knowledge, Omni-Channel routing
- Experience Cloud: Portal authentication, client dashboard, case management, onboarding, Agentforce (Aria)
- Non-functional: Performance, security, accessibility, code coverage

## 2.2 Out of Scope

- Full CPQ managed package testing (standard Salesforce quoting only)
- Live API integration testing (stubs only in portfolio environment)
- Load / volume testing beyond the Developer Edition data limits
- SSO and external identity provider testing

---

# 3. Test Strategy

## 3.1 Testing Levels

| Level | Description | Owner | Timing |
| :---- | :---- | :---- | :---- |
| Unit Testing | Apex class-level testing via test classes; 85%+ coverage required | Developer | During build (Phase 4) |
| System Testing | End-to-end functional validation against test scripts in this document | Developer / QA | After each deployment phase |
| Regression Testing | Re-execution of the regression suite after any change | Developer | After every PR merge to `develop` |
| UAT | Business scenario walkthroughs with persona-aligned test users | Portfolio Developer (as stakeholder) | Pre-go-live |
| Accessibility Testing | WCAG 2.1 AA validation of LWC components and portal pages | Developer | During Experience Cloud phase |

## 3.2 Test Types

| Type | Tool / Method | Coverage Target |
| :---- | :---- | :---- |
| Apex Unit Tests | Salesforce Test Runner (`sf apex run test`) | ≥85% on all classes |
| Flow Tests | Manual execution via debug mode + Flow Interview log | All defined scenarios |
| Validation Rule Tests | Manual data entry in scratch org | All rules: positive and negative path |
| LWC Jest Tests | Jest (`npm run test`) | All public methods and property changes |
| Manual Functional Tests | Scratch org — test scripts in this document | All test cases in Section 5 |
| Security Scan | Manual review against OWASP Salesforce Top 10 | All custom Apex and LWC |
| Accessibility Scan | axe DevTools or Accessibility Insights (browser extension) | All Experience Cloud pages |

## 3.3 Test ID Convention

```
MKT-TC-[MODULE]-[NNN]

Examples:
  MKT-TC-SALES-001    Sales Cloud test case 001
  MKT-TC-SRVC-007     Service Cloud test case 007
  MKT-TC-EXP-003      Experience Cloud test case 003
  MKT-TC-NFR-002      Non-Functional test case 002
```

## 3.4 Test Case Priority

| Priority | Definition |
| :---- | :---- |
| Critical | Blocks a core business process; must pass before go-live |
| High | Significant functional impact; must pass before go-live |
| Medium | Important but has workaround; should pass before go-live |
| Low | Edge case or cosmetic; tracked for post-go-live sprint |

## 3.5 Pass / Fail Criteria

- **Pass:** All steps executed; actual result matches expected result exactly
- **Fail:** Any step produces a result that diverges from expected result; defect raised
- **Blocked:** Unable to execute due to environment or dependency issue; re-scheduled

---

# 4. Test Environments

| Environment | Purpose | Branch | Refresh Frequency |
| :---- | :---- | :---- | :---- |
| Scratch Org (Dev) | Active development; unit and integration testing | `vertical/marketing` | Created fresh per feature; max 7-day lifespan |
| Scratch Org (QA) | Formal test execution against this plan | `vertical/marketing` (tagged build) | Created fresh at start of each QA cycle |
| Developer Edition Org | Portfolio demo; final UAT execution | `main` post-merge | Updated on release deploy |

**Test Data Strategy:**

All test data is created using `TestDataFactory` (Apex) or manual setup scripts documented in each test case. No production or real personal data is used at any point. Sample data volumes per MKT-DD-1.0 Section 10.4.

---

# 5. Test Case Summary

## 5.1 Sales Cloud

| TC ID | Title | Priority | Type | User Story | Req. ID |
| :---- | :---- | :---- | :---- | :---- | :---- |
| MKT-TC-SALES-001 | Web-to-lead captures all required fields | High | Manual | MKT-US-SALES-001 | MKT-REQ-SALES-001 |
| MKT-TC-SALES-002 | Lead auto-assignment routes to correct SDR | High | Manual | MKT-US-SALES-002 | MKT-REQ-SALES-002 |
| MKT-TC-SALES-003 | Lead status governance enforces stage rules | Critical | Manual | MKT-US-SALES-003 | MKT-REQ-SALES-003 |
| MKT-TC-SALES-004 | Lead conversion gate: Qualified + 3 activities required | Critical | Manual | MKT-US-SALES-005 | MKT-REQ-SALES-005 |
| MKT-TC-SALES-005 | 48-hour follow-up task created when no activity | High | Manual | MKT-US-SALES-006 | MKT-REQ-SALES-006 |
| MKT-TC-SALES-006 | Customer Account layout shows Catalyst-specific fields | High | Manual | MKT-US-SALES-007, 008 | MKT-REQ-SALES-007, 008 |
| MKT-TC-SALES-007 | Opportunity stage gate: required fields at Proposal Sent | Critical | Manual | MKT-US-SALES-012, 013 | MKT-REQ-SALES-012, 013 |
| MKT-TC-SALES-008 | Loss Reason mandatory on Closed Lost | High | Manual | MKT-US-SALES-015 | MKT-REQ-SALES-016 |
| MKT-TC-SALES-009 | Quote PDF generates with Catalyst branding and line items | High | Manual | MKT-US-SALES-014 | MKT-REQ-SALES-015 |
| MKT-TC-SALES-010 | Quote discount >15% submits for VP approval | Critical | Manual | MKT-US-SALES-014 | MKT-REQ-SALES-015 |
| MKT-TC-SALES-011 | Account Health Score calculated and displayed | High | Manual | MKT-US-SALES-010 | MKT-REQ-SALES-010 |
| MKT-TC-SALES-012 | Sales Leadership Dashboard renders all components | Medium | Manual | MKT-US-SALES-018 | MKT-REQ-SALES-019 |

## 5.2 Service Cloud

| TC ID | Title | Priority | Type | User Story | Req. ID |
| :---- | :---- | :---- | :---- | :---- | :---- |
| MKT-TC-SRVC-001 | Case auto-links to Account by email domain | Critical | Manual | MKT-US-SRVC-002 | MKT-REQ-SRVC-002 |
| MKT-TC-SRVC-002 | Unmatched domain flags case for manual review | High | Manual | MKT-US-SRVC-002 | MKT-REQ-SRVC-002 |
| MKT-TC-SRVC-003 | Enterprise SLA entitlement assigned on case create | Critical | Manual | MKT-US-SRVC-007 | MKT-REQ-SRVC-007 |
| MKT-TC-SRVC-004 | Professional SLA entitlement assigned on case create | Critical | Manual | MKT-US-SRVC-007 | MKT-REQ-SRVC-007 |
| MKT-TC-SRVC-005 | Starter SLA entitlement assigned on case create | Critical | Manual | MKT-US-SRVC-007 | MKT-REQ-SRVC-007 |
| MKT-TC-SRVC-006 | First response breach triggers Team Lead escalation | Critical | Manual | MKT-US-SRVC-008 | MKT-REQ-SRVC-008 |
| MKT-TC-SRVC-007 | Resolution Summary required before Resolved | Critical | Manual | MKT-US-SRVC-005 | MKT-REQ-SRVC-005 |
| MKT-TC-SRVC-008 | CSAT survey dispatched on case Resolved | High | Manual | MKT-US-SRVC-006 | MKT-REQ-SRVC-006 |
| MKT-TC-SRVC-009 | Case cannot be Closed without CSAT sent | High | Manual | MKT-US-SRVC-006 | MKT-REQ-SRVC-006 |
| MKT-TC-SRVC-010 | Enterprise case routes to Enterprise Support queue | Critical | Manual | MKT-US-SRVC-014 | MKT-REQ-SRVC-014 |
| MKT-TC-SRVC-011 | Knowledge article attached to case in Service Console | Medium | Manual | MKT-US-SRVC-013 | MKT-REQ-SRVC-013 |
| MKT-TC-SRVC-012 | Account context panel visible on case record | High | Manual | MKT-US-SRVC-004 | MKT-REQ-SRVC-004 |

## 5.3 Experience Cloud

| TC ID | Title | Priority | Type | User Story | Req. ID |
| :---- | :---- | :---- | :---- | :---- | :---- |
| MKT-TC-EXP-001 | Self-registration creates portal user for Customer contact | Critical | Manual | MKT-US-EXP-001 | MKT-REQ-EXP-001 |
| MKT-TC-EXP-002 | Portal user cannot see other accounts' cases | Critical | Manual | MKT-US-EXP-002 | MKT-REQ-EXP-002 |
| MKT-TC-EXP-003 | Home dashboard displays personalised client data | High | Manual | MKT-US-EXP-004 | MKT-REQ-EXP-004 |
| MKT-TC-EXP-004 | Case submission form with knowledge deflection | Critical | Manual | MKT-US-EXP-007, 009 | MKT-REQ-EXP-007, 009 |
| MKT-TC-EXP-005 | Portal case list shows only own account's cases | Critical | Manual | MKT-US-EXP-008 | MKT-REQ-EXP-008 |
| MKT-TC-EXP-006 | Onboarding checklist tracks step completion | High | Manual | MKT-US-EXP-010 | MKT-REQ-EXP-010 |
| MKT-TC-EXP-007 | Aria responds to knowledge base query | Critical | Manual | MKT-US-EXP-012 | MKT-REQ-EXP-012 |
| MKT-TC-EXP-008 | Aria returns case status for authenticated user | Critical | Manual | MKT-US-EXP-012 | MKT-REQ-EXP-012 |
| MKT-TC-EXP-009 | Aria escalates to human agent and creates case draft | High | Manual | MKT-US-EXP-015 | MKT-REQ-EXP-015 |
| MKT-TC-EXP-010 | Aria stays within defined scope boundaries | High | Manual | MKT-US-EXP-014 | MKT-REQ-EXP-014 |

## 5.4 Non-Functional

| TC ID | Title | Priority | Type | User Story | Req. ID |
| :---- | :---- | :---- | :---- | :---- | :---- |
| MKT-TC-NFR-001 | Record page load time under 3 seconds | High | Manual | MKT-US-NFR-001 | MKT-REQ-NFR-001 |
| MKT-TC-NFR-002 | Apex test coverage ≥85% across all classes | Critical | Automated | MKT-US-NFR-006 | MKT-REQ-NFR-006 |
| MKT-TC-NFR-003 | No SOQL queries inside trigger loops | Critical | Manual / Code Review | MKT-US-NFR-002 | MKT-REQ-NFR-002 |
| MKT-TC-NFR-004 | Experience Cloud pages pass WCAG 2.1 AA | High | Automated (axe) | MKT-US-NFR-007 | MKT-REQ-NFR-007 |
| MKT-TC-NFR-005 | Portal enforces data isolation — no cross-account SOQL | Critical | Code Review + Manual | MKT-US-NFR-004 | MKT-REQ-NFR-004 |
| MKT-TC-NFR-006 | Integration failure handled gracefully — no uncaught exception | High | Manual | MKT-US-NFR-005 | MKT-REQ-NFR-005 |

---

# 6. Detailed Test Scripts — Sales Cloud

---

### MKT-TC-SALES-001 — Web-to-Lead Captures All Required Fields

| Property | Value |
| :---- | :---- |
| **Priority** | High |
| **Type** | Manual |
| **User Story** | MKT-US-SALES-001 |
| **Requirement** | MKT-REQ-SALES-001 |
| **Persona** | Anonymous website visitor (lead source) |

**Preconditions:**
- Web-to-lead form deployed and accessible
- Lead assignment rules configured
- Scratch org with sample SDR user active

**Test Steps:**

| Step | Action | Expected Result |
| :---- | :---- | :---- |
| 1 | Navigate to the web-to-lead form URL | Form loads with all fields visible |
| 2 | Submit the form with all fields blank | Form validation prevents submission; required field errors displayed for: First Name, Last Name, Company, Email |
| 3 | Enter: First Name = "Alex", Last Name = "Rivera", Company = "Acme Corp", Job Title = "Marketing Director", Email = "alex.rivera@acme.com", Phone = "512-555-0101", Lead Source = "Web — Paid Search", Area of Interest = "Campaign Intelligence" | All fields accept input without error |
| 4 | Submit the completed form | Confirmation message displayed; no error shown |
| 5 | Log in as System Admin; navigate to Leads | New Lead record for "Alex Rivera" exists |
| 6 | Open the Lead record and verify all fields | First Name, Last Name, Company, Job Title, Email, Phone, Lead Source, and Area_of_Interest__c all match submitted values |
| 7 | Verify Lead Status | Status = "New" |
| 8 | Verify Lead Owner | Lead is assigned to an SDR (not the default admin user) via assignment rule |

**Pass Criteria:** All 8 steps produce expected results. Lead record contains all submitted field values and is auto-assigned.

---

### MKT-TC-SALES-002 — Lead Auto-Assignment Routes to Correct SDR

| Property | Value |
| :---- | :---- |
| **Priority** | High |
| **Type** | Manual |
| **User Story** | MKT-US-SALES-002 |
| **Requirement** | MKT-REQ-SALES-002 |

**Preconditions:**
- Assignment rules configured for Lead Source + geography routing
- At least two SDR user records active in the org
- Round-robin assignment active

**Test Steps:**

| Step | Action | Expected Result |
| :---- | :---- | :---- |
| 1 | Create Lead A with Lead Source = "Web — Organic", State = "Texas" via Salesforce UI as Admin | Lead A created |
| 2 | Create Lead B with same Lead Source and State | Lead B created |
| 3 | Create Lead C with Lead Source = "Partner Referral", State = "New York" | Lead C created |
| 4 | Check OwnerId on Lead A | Assigned to SDR 1 (first in round-robin for this source/geo) |
| 5 | Check OwnerId on Lead B | Assigned to SDR 2 (round-robin advances) |
| 6 | Check OwnerId on Lead C | Assigned per Partner Referral routing rule (may differ from Web rule) |

**Pass Criteria:** Leads A and B are assigned to different SDRs demonstrating round-robin. Lead C follows its routing rule.

---

### MKT-TC-SALES-003 — Lead Status Governance Enforces Stage Rules

| Property | Value |
| :---- | :---- |
| **Priority** | Critical |
| **Type** | Manual |
| **User Story** | MKT-US-SALES-003 |
| **Requirement** | MKT-REQ-SALES-003 |

**Preconditions:**
- Lead record exists with Status = "New", Email populated

**Test Steps:**

| Step | Action | Expected Result |
| :---- | :---- | :---- |
| 1 | Open a Lead with Status = "New" | Lead record loads |
| 2 | Attempt to change Status directly to "Qualified" with Company field blank | Validation rule fires: error message displayed requiring Company and Email |
| 3 | Ensure Company and Email are populated; set Status = "Qualified" | Status saves successfully to "Qualified" |
| 4 | Verify Status picklist contains exactly: New, Attempting Contact, Contacted, Qualified, Unqualified | All five values present; no other values visible |
| 5 | As a standard Sales User, attempt to set Status = "Converted" directly (without using the Convert button) | Picklist does not include "Converted" as a selectable option for manual entry |

**Pass Criteria:** Status advances only when required fields are populated. Picklist is governed to exactly five values.

---

### MKT-TC-SALES-004 — Lead Conversion Gate: Qualified + 3 Activities Required

| Property | Value |
| :---- | :---- |
| **Priority** | Critical |
| **Type** | Manual |
| **User Story** | MKT-US-SALES-005 |
| **Requirement** | MKT-REQ-SALES-005 |

**Preconditions:**
- Lead record with Status = "Qualified", zero logged activities

**Test Steps:**

| Step | Action | Expected Result |
| :---- | :---- | :---- |
| 1 | Open a Qualified lead with Activity_Count__c = 0 | Lead record loads |
| 2 | Click "Convert" button | Conversion page loads |
| 3 | Attempt to complete the conversion | Validation rule fires: "A lead cannot be converted unless Status is Qualified and at least 3 activities are logged." Conversion blocked. |
| 4 | Return to the lead; log a Task (mark as complete) | Task logged; Activity_Count__c = 1 |
| 5 | Log a second Task (mark as complete) | Activity_Count__c = 2 |
| 6 | Attempt conversion again | Blocked again — Activity_Count__c < 3 |
| 7 | Log a third Task (mark as complete) | Activity_Count__c = 3 |
| 8 | Attempt conversion again | Conversion proceeds; Account, Contact, and Opportunity created |
| 9 | Attempt conversion on a lead with Status = "Contacted" and 5 activities | Blocked — Status must be Qualified regardless of activity count |

**Pass Criteria:** Conversion is blocked until both conditions (Qualified + ≥3 activities) are met simultaneously.

---

### MKT-TC-SALES-005 — 48-Hour Follow-Up Task When No Activity Logged

| Property | Value |
| :---- | :---- |
| **Priority** | High |
| **Type** | Manual |
| **User Story** | MKT-US-SALES-006 |
| **Requirement** | MKT-REQ-SALES-006 |

**Preconditions:**
- Lead_AfterSave_FollowUpTask flow deployed
- Scheduled flow interval: 48 hours after creation

**Test Steps:**

| Step | Action | Expected Result |
| :---- | :---- | :---- |
| 1 | Create a new Lead with no activities | Lead created |
| 2 | In the Flow debug interface, manually advance time on the scheduled path by 48 hours (or use `sf apex run` to simulate the scheduled path) | Follow-up Task is created |
| 3 | Verify the Task record | Subject = "Follow Up — No Activity Logged"; OwnerId = Lead OwnerId; Priority = High; ActivityDate = tomorrow's date |
| 4 | Create a second Lead; log one Task within 48 hours | Follow-up Task is NOT created for this lead (flow detects existing activity) |

**Pass Criteria:** Task created only for leads with no prior activity after 48 hours. Leads with logged activities are not affected.

---

### MKT-TC-SALES-006 — Customer Account Layout Shows Catalyst-Specific Fields

| Property | Value |
| :---- | :---- |
| **Priority** | High |
| **Type** | Manual |
| **User Story** | MKT-US-SALES-007, MKT-US-SALES-008 |
| **Requirement** | MKT-REQ-SALES-007, MKT-REQ-SALES-008 |

**Test Steps:**

| Step | Action | Expected Result |
| :---- | :---- | :---- |
| 1 | Create an Account with Record Type = "Customer" | Account saved with Customer record type |
| 2 | Open the Account record | Customer_Layout displayed |
| 3 | Verify the following fields are visible on the layout | Subscription_Tier__c, Modules_Purchased__c, Annual_Contract_Value__c, Contract_Renewal_Date__c, Primary_Platform_Contact__c, Health_Score__c all present |
| 4 | Set Subscription Tier = "Enterprise" and save | Saves without error |
| 5 | Create an Account with Record Type = "Prospect" | Account saved with Prospect record type |
| 6 | Verify Prospect layout | Subscription_Tier__c NOT visible (Prospect layout omits Catalyst subscription fields) |

**Pass Criteria:** Customer layout surfaces all Catalyst fields. Prospect layout does not.

---

### MKT-TC-SALES-007 — Opportunity Stage Gate: Required Fields at Proposal Sent

| Property | Value |
| :---- | :---- |
| **Priority** | Critical |
| **Type** | Manual |
| **User Story** | MKT-US-SALES-012, MKT-US-SALES-013 |
| **Requirement** | MKT-REQ-SALES-012, MKT-REQ-SALES-013 |

**Preconditions:**
- Opportunity in "Technical Evaluation" stage; Contract_Length__c, Decision_Date__c, Economic_Buyer__c all blank

**Test Steps:**

| Step | Action | Expected Result |
| :---- | :---- | :---- |
| 1 | Open the Opportunity | Record loads showing stage = Technical Evaluation |
| 2 | Change Stage to "Proposal Sent"; leave Contract Length, Decision Date, Economic Buyer blank; save | Validation rule fires: "Contract Length, Decision Date, and Economic Buyer are required before advancing to Proposal Sent." Save blocked. |
| 3 | Populate Contract_Length__c = "24 Months" only; attempt save | Save still blocked — Decision Date and Economic Buyer still required |
| 4 | Populate all three: Contract Length = "24 Months", Decision Date = future date, Economic Buyer = linked Contact; save | Stage advances to "Proposal Sent"; save succeeds |
| 5 | Verify Probability field | Probability = 50% (per stage configuration) |
| 6 | Advance to "Closed Lost" without populating Loss_Reason__c | Blocked: "Loss Reason is required when closing an opportunity as Lost." |
| 7 | Populate Loss_Reason__c = "Price"; save | Stage saves to Closed Lost |

**Pass Criteria:** Stage gate enforced at Proposal Sent. Loss Reason enforced at Closed Lost.

---

### MKT-TC-SALES-008 — Loss Reason Mandatory on Closed Lost

*Covered by MKT-TC-SALES-007 steps 6–7. No separate execution required.*

---

### MKT-TC-SALES-009 — Quote PDF Generates with Catalyst Branding

| Property | Value |
| :---- | :---- |
| **Priority** | High |
| **Type** | Manual |
| **User Story** | MKT-US-SALES-014 |
| **Requirement** | MKT-REQ-SALES-015 |

**Preconditions:**
- Opportunity at Proposal Sent stage with at least one OpportunityLineItem (product linked)
- Quote created and synced to the Opportunity
- Catalyst-branded PDF template configured

**Test Steps:**

| Step | Action | Expected Result |
| :---- | :---- | :---- |
| 1 | Open the Quote related to the Opportunity | Quote record loads |
| 2 | Add at least two quote line items with different products and quantities | Line items saved |
| 3 | Set a discount of 10% on one line item | Max_Discount_Pct__c calculates correctly; no approval triggered (< 15%) |
| 4 | Click "Generate PDF" (or preview quote) | PDF renders |
| 5 | Verify PDF contains: Catalyst logo, all line items with quantity/unit price/discount/subtotal, total ACV, contract terms section | All elements present and correct |
| 6 | Verify company address and "Accelerate Every Campaign." tagline in PDF header | Present and formatted correctly |

**Pass Criteria:** PDF generated with all required elements. Catalyst branding visible. No approval triggered at 10% discount.

---

### MKT-TC-SALES-010 — Quote Discount >15% Submits for VP Approval

| Property | Value |
| :---- | :---- |
| **Priority** | Critical |
| **Type** | Manual |
| **User Story** | MKT-US-SALES-014 |
| **Requirement** | MKT-REQ-SALES-015 |

**Preconditions:**
- Quote with at least one line item; VP of Sales user configured as approver

**Test Steps:**

| Step | Action | Expected Result |
| :---- | :---- | :---- |
| 1 | Open a Quote linked to an Opportunity | Quote loads |
| 2 | Set discount on a line item to 16% | Max_Discount_Pct__c = 16.00 |
| 3 | Save the Quote | `Opportunity_AfterSave_QuoteApproval` flow fires; Quote submitted for approval |
| 4 | Verify Quote status | Quote Status = "Pending Approval" (or equivalent approval pending state) |
| 5 | Log in as VP of Sales user (or impersonate); navigate to Approval Requests | Pending approval request visible for this Quote with discount detail |
| 6 | Approve the request | Quote Status = "Approved" |
| 7 | Return to the Quote | Approval status = Approved; no further submission required |
| 8 | Test rejection: create a new Quote at 20% discount; submit; VP rejects | Quote Status = "Rejected"; email notification sent to Opportunity Owner |
| 9 | Test boundary: set discount to exactly 15% | No approval triggered (threshold is > 15, not ≥ 15) |

**Pass Criteria:** Approval triggered exclusively when discount > 15%. Approve and reject paths both function correctly. Boundary at exactly 15% does not trigger.

---

### MKT-TC-SALES-011 — Account Health Score Calculated and Displayed

| Property | Value |
| :---- | :---- |
| **Priority** | High |
| **Type** | Manual |
| **User Story** | MKT-US-SALES-010 |
| **Requirement** | MKT-REQ-SALES-010 |

**Preconditions:**
- Customer Account with at least 2 completed Feedback_Survey__c records (CSAT), open and closed Cases, and Platform_Usage_Index__c populated

**Test Steps:**

| Step | Action | Expected Result |
| :---- | :---- | :---- |
| 1 | Open a Customer Account with populated data | Account record loads |
| 2 | Record current values: CSAT_Average__c, Open_Case_Count__c, Platform_Usage_Index__c, Contract_Renewal_Date__c | Values noted for manual calculation verification |
| 3 | Manually calculate expected Health Score using the algorithm in MKT-TDD-1.0 Section 6.5 | Expected score calculated |
| 4 | Compare expected score to Health_Score__c displayed on record | Within ±1 point (rounding) |
| 5 | Close one open Case; trigger Account save to invoke `Account_AfterSave_HealthScoreRecalc` flow | Health Score recalculates; Open_Case_Count__c decreases by 1 |
| 6 | Verify the new score is higher (fewer open cases = better score) | Health_Score__c has increased |
| 7 | Set Contract_Renewal_Date__c to 15 days from today (simulating near-renewal) | Renewal proximity component of score decreases; overall score should decrease |

**Pass Criteria:** Health Score matches manual calculation. Score recalculates on related data changes.

---

### MKT-TC-SALES-012 — Sales Leadership Dashboard Renders All Components

| Property | Value |
| :---- | :---- |
| **Priority** | Medium |
| **Type** | Manual |
| **User Story** | MKT-US-SALES-018 |
| **Requirement** | MKT-REQ-SALES-019 |

**Preconditions:**
- Sample data loaded: Opportunities across all stages, Accounts with ACV, at least one quota record

**Test Steps:**

| Step | Action | Expected Result |
| :---- | :---- | :---- |
| 1 | Log in as Sales Manager profile | Home page loads |
| 2 | Navigate to "Sales Leadership" dashboard | Dashboard loads without error |
| 3 | Verify all 6 components render: Pipeline by Stage (funnel), Forecast vs Quota by Rep (bar), Avg Deal Size by Module (bar), Sales Cycle Length (metric), Win/Loss Rate by Quarter (bar), Open Pipeline Value (metric) | All 6 components visible and displaying data |
| 4 | Click "Refresh" on the dashboard | Dashboard refreshes; no errors |
| 5 | Log in as an Account Executive (Sales User profile) | Cannot access Sales Leadership dashboard; dashboard is profile-filtered to Sales Manager and above |

**Pass Criteria:** All dashboard components render with data. Access restricted to appropriate profiles.

---

# 7. Detailed Test Scripts — Service Cloud

---

### MKT-TC-SRVC-001 — Case Auto-Links to Account by Email Domain

| Property | Value |
| :---- | :---- |
| **Priority** | Critical |
| **Type** | Manual |
| **User Story** | MKT-US-SRVC-002 |
| **Requirement** | MKT-REQ-SRVC-002 |

**Preconditions:**
- Customer Account "Acme Corp" exists with Website = "acmecorp.com"
- Email-to-Case configured; support@catalyst.io mailbox active in scratch org (or simulated via `sf apex run`)

**Test Steps:**

| Step | Action | Expected Result |
| :---- | :---- | :---- |
| 1 | Simulate inbound email from "support@acmecorp.com" via Email-to-Case (or create Case manually with SuppliedEmail = "user@acmecorp.com", AccountId = null) | Case record created with AccountId = null initially |
| 2 | Wait for `Case_AfterSave_AutoLinkAccount` flow to execute (after-save trigger) | Flow fires |
| 3 | Open the Case record | AccountId = Acme Corp's Account Id; Auto_Link_Status__c = "Linked" |
| 4 | Verify no manual intervention was required | AccountId was set programmatically |

**Pass Criteria:** Case AccountId set to the matching Account without manual action.

---

### MKT-TC-SRVC-002 — Unmatched Domain Flags Case for Manual Review

| Property | Value |
| :---- | :---- |
| **Priority** | High |
| **Type** | Manual |
| **User Story** | MKT-US-SRVC-002 |
| **Requirement** | MKT-REQ-SRVC-002 |

**Test Steps:**

| Step | Action | Expected Result |
| :---- | :---- | :---- |
| 1 | Create Case with SuppliedEmail = "user@unknowncompany.com" (no Account with this domain exists) | Case created |
| 2 | Verify AccountId | Null — no auto-link performed |
| 3 | Verify Auto_Link_Status__c | "Pending Manual Review" |
| 4 | Create Case with SuppliedEmail = "user@gmail.com" (excluded common domain) | Auto_Link_Status__c = "Not Applicable"; case not flagged (common domain exclusion) |

**Pass Criteria:** Unknown domains set Pending Manual Review status. Excluded common domains handled gracefully.

---

### MKT-TC-SRVC-003 — Enterprise SLA Entitlement Assigned on Case Create

| Property | Value |
| :---- | :---- |
| **Priority** | Critical |
| **Type** | Manual |
| **User Story** | MKT-US-SRVC-007 |
| **Requirement** | MKT-REQ-SRVC-007 |

**Preconditions:**
- Customer Account "TechCorp" with Subscription_Tier__c = "Enterprise"
- Enterprise entitlement process configured: 1-hour first response milestone, 4-hour resolution milestone

**Test Steps:**

| Step | Action | Expected Result |
| :---- | :---- | :---- |
| 1 | Create a new Case linked to TechCorp (Enterprise tier) | Case created |
| 2 | Verify Entitlement on the Case record | Entitlement linked; EntitlementId populated |
| 3 | Open the Entitlement related record | Entitlement name references "Enterprise" tier |
| 4 | Check Milestones on the Case | First Response milestone: target time = 1 hour from case creation; Resolution milestone: target time = 4 hours |
| 5 | Verify SLA_Tier_at_Creation__c field on the Case | Value = "Enterprise" |

**Pass Criteria:** Enterprise entitlement auto-assigned; milestones correctly configured; SLA tier snapshotted on case.

---

### MKT-TC-SRVC-004 — Professional SLA Entitlement Assigned

*Mirror of MKT-TC-SRVC-003 using an Account with Subscription_Tier__c = "Professional". Expected milestones: 4-hour first response, 2-business-day resolution.*

---

### MKT-TC-SRVC-005 — Starter SLA Entitlement Assigned

*Mirror of MKT-TC-SRVC-003 using an Account with Subscription_Tier__c = "Starter". Expected milestones: 8-business-hour first response, 5-business-day resolution.*

---

### MKT-TC-SRVC-006 — First Response Breach Triggers Team Lead Escalation

| Property | Value |
| :---- | :---- |
| **Priority** | Critical |
| **Type** | Manual |
| **User Story** | MKT-US-SRVC-008 |
| **Requirement** | MKT-REQ-SRVC-008 |

**Preconditions:**
- Case with Enterprise entitlement; first response milestone not completed
- `Case_Scheduled_EscalationCheck` flow accessible via debug

**Test Steps:**

| Step | Action | Expected Result |
| :---- | :---- | :---- |
| 1 | Create a new Enterprise Case; do not add any response or activity | Case sits at Status = "New" |
| 2 | In Flow debug, advance time past the 1-hour first response milestone (or manually invoke the scheduled flow with the case meeting violation criteria) | `Case_Scheduled_EscalationCheck` runs |
| 3 | Verify milestone status on the Case | First Response milestone = "Violated" |
| 4 | Verify email notification | Support Team Lead receives escalation email: "SLA Breach Alert: {CaseNumber}" |
| 5 | Run the escalation check a second time for the same case | Duplicate escalation email NOT sent (escalation flag set after first notification) |

**Pass Criteria:** Breach notification sent once to Team Lead. Deduplication prevents repeat alerts.

---

### MKT-TC-SRVC-007 — Resolution Summary Required Before Resolved

| Property | Value |
| :---- | :---- |
| **Priority** | Critical |
| **Type** | Manual |
| **User Story** | MKT-US-SRVC-005 |
| **Requirement** | MKT-REQ-SRVC-005 |

**Test Steps:**

| Step | Action | Expected Result |
| :---- | :---- | :---- |
| 1 | Open an In Progress case with Resolution_Summary__c blank | Case record loads |
| 2 | Change Status to "Resolved"; save | Validation rule fires: "A Resolution Summary is required before setting a case to Resolved." Save blocked. |
| 3 | Populate Resolution_Summary__c with "Issue resolved by restarting the Campaign Intelligence module cache."; change Status to "Resolved"; save | Status saves to "Resolved" successfully |

**Pass Criteria:** Validation rule blocks Resolved without summary. Saves when summary present.

---

### MKT-TC-SRVC-008 — CSAT Survey Dispatched on Case Resolved

| Property | Value |
| :---- | :---- |
| **Priority** | High |
| **Type** | Manual |
| **User Story** | MKT-US-SRVC-006 |
| **Requirement** | MKT-REQ-SRVC-006 |

**Test Steps:**

| Step | Action | Expected Result |
| :---- | :---- | :---- |
| 1 | Set a case Status to "Resolved" (with Resolution Summary populated, per MKT-TC-SRVC-007) | Status saves |
| 2 | Verify `Case_AfterSave_CSATDispatch` flow executed | Feedback_Survey__c record created: Survey_Type__c = CSAT, Status = Sent, Case__c = this case, Contact__c = case contact |
| 3 | Verify Case field CSAT_Sent__c | = true |
| 4 | Verify email to customer contact | Survey invitation email sent to the contact on the case |

**Pass Criteria:** CSAT survey record created; CSAT_Sent__c set to true; notification email dispatched.

---

### MKT-TC-SRVC-009 — Case Cannot Be Closed Without CSAT Sent

| Property | Value |
| :---- | :---- |
| **Priority** | High |
| **Type** | Manual |
| **User Story** | MKT-US-SRVC-006 |
| **Requirement** | MKT-REQ-SRVC-006 |

**Test Steps:**

| Step | Action | Expected Result |
| :---- | :---- | :---- |
| 1 | Open a Resolved case where CSAT_Sent__c = false (simulate by manually setting to false) | Case record loads |
| 2 | Change Status to "Closed"; save | Validation rule fires: "Please send the CSAT survey before closing this case." Save blocked. |
| 3 | Set CSAT_Sent__c = true; change Status to "Closed"; save | Status saves to "Closed" |

**Pass Criteria:** Closing blocked without CSAT; allowed with CSAT flag true.

---

### MKT-TC-SRVC-010 — Enterprise Case Routes to Enterprise Support Queue

| Property | Value |
| :---- | :---- |
| **Priority** | Critical |
| **Type** | Manual |
| **User Story** | MKT-US-SRVC-014 |
| **Requirement** | MKT-REQ-SRVC-014 |

**Preconditions:**
- Queues configured: Enterprise_Support_Queue, Technical_Support_Queue
- Routing rules configured by Record Type + tier

**Test Steps:**

| Step | Action | Expected Result |
| :---- | :---- | :---- |
| 1 | Create a Technical Support case linked to an Enterprise Account | Case created |
| 2 | Verify Case OwnerId (queue) | OwnerId = Enterprise_Support_Queue Id |
| 3 | Create a Technical Support case linked to a Professional Account | Case created |
| 4 | Verify Case OwnerId | OwnerId = Technical_Support_Queue Id (non-Enterprise technical cases) |
| 5 | Create a Billing Enquiry case linked to any Account | Case routes to Billing_Enquiry_Queue |

**Pass Criteria:** Enterprise Technical Support cases route to Enterprise queue. All other record types route to their appropriate queues.

---

### MKT-TC-SRVC-011 — Knowledge Article Attached to Case in Service Console

| Property | Value |
| :---- | :---- |
| **Priority** | Medium |
| **Type** | Manual |
| **User Story** | MKT-US-SRVC-013 |
| **Requirement** | MKT-REQ-SRVC-013 |

**Test Steps:**

| Step | Action | Expected Result |
| :---- | :---- | :---- |
| 1 | Log in as a Service Agent; open the Service Console | Console loads |
| 2 | Open an open Case | Case detail loads in console |
| 3 | In the Knowledge sidebar, search for an article relevant to the case subject | Relevant articles appear in results |
| 4 | Click "Attach" or single-click attach action on an article | Article linked to Case; visible in Case Knowledge related list |
| 5 | Verify the article link is visible on the Case record | Knowledge article relationship record present |

**Pass Criteria:** Single-click article attach works from the Service Console Knowledge panel.

---

### MKT-TC-SRVC-012 — Account Context Panel Visible on Case Record

| Property | Value |
| :---- | :---- |
| **Priority** | High |
| **Type** | Manual |
| **User Story** | MKT-US-SRVC-004 |
| **Requirement** | MKT-REQ-SRVC-004 |

**Test Steps:**

| Step | Action | Expected Result |
| :---- | :---- | :---- |
| 1 | Log in as Service Agent; open a Case linked to a Customer Account | Case record loads |
| 2 | Verify Account context panel visible on the Case layout | Panel visible showing: Subscription_Tier__c, Modules_Purchased__c, Annual_Contract_Value__c, Health_Score__c |
| 3 | Verify panel data matches the related Account record | All values match |
| 4 | Open the same Case in the Service Console | Account context panel also visible in console view |

**Pass Criteria:** Account context data visible on Case record and in Service Console without navigation away from the case.

---

# 8. Detailed Test Scripts — Experience Cloud

---

### MKT-TC-EXP-001 — Self-Registration Creates Portal User for Customer Contact

| Property | Value |
| :---- | :---- |
| **Priority** | Critical |
| **Type** | Manual |
| **User Story** | MKT-US-EXP-001 |
| **Requirement** | MKT-REQ-EXP-001 |

**Preconditions:**
- Customer Account "PortalTestCorp" with a Contact "Jamie Lee" (jamielee@portaltestcorp.com)
- Self-registration page deployed; registration token mechanism configured

**Test Steps:**

| Step | Action | Expected Result |
| :---- | :---- | :---- |
| 1 | Navigate to the portal self-registration URL | Registration form loads |
| 2 | Attempt to register with an email not on a Customer Account ("unknown@randomcompany.com") | Registration rejected: email not associated with a Catalyst customer account |
| 3 | Register with "jamielee@portaltestcorp.com" and create password | Registration proceeds |
| 4 | Log in to the portal with new credentials | Portal home page loads |
| 5 | Log in as System Admin; find the portal User record | User record exists; Profile = Customer Community Plus (cloned); IsActive = true |
| 6 | Verify Is_Portal_Active__c on the Contact | = true |
| 7 | Verify Portal_Welcome_Sent__c on the Contact | = true (welcome email was dispatched) |
| 8 | Attempt to register the same email again | Registration rejected: account already exists |

**Pass Criteria:** Self-registration works only for contacts on Customer Accounts. Portal user provisioned correctly. Welcome email sent once.

---

### MKT-TC-EXP-002 — Portal User Cannot See Other Accounts' Cases

| Property | Value |
| :---- | :---- |
| **Priority** | Critical |
| **Type** | Manual |
| **User Story** | MKT-US-EXP-002 |
| **Requirement** | MKT-REQ-EXP-002 |

**Preconditions:**
- Two Customer Accounts: "AlphaCorp" and "BetaCorp", each with a portal user and at least one case

**Test Steps:**

| Step | Action | Expected Result |
| :---- | :---- | :---- |
| 1 | Log in to the portal as the AlphaCorp portal user | Portal home loads |
| 2 | Navigate to /cases | Only AlphaCorp cases listed; zero BetaCorp cases visible |
| 3 | Attempt to access a BetaCorp Case directly via URL (/cases/{BetaCorp_Case_Id}) | Access denied or record not found — case not accessible |
| 4 | Verify no BetaCorp Account data visible anywhere in the portal | All account fields (Subscription Tier, ACV, Modules) show AlphaCorp data only |

**Pass Criteria:** Complete data isolation. AlphaCorp user cannot read, list, or directly access BetaCorp records.

---

### MKT-TC-EXP-003 — Home Dashboard Displays Personalised Client Data

| Property | Value |
| :---- | :---- |
| **Priority** | High |
| **Type** | Manual |
| **User Story** | MKT-US-EXP-004 |
| **Requirement** | MKT-REQ-EXP-004 |

**Test Steps:**

| Step | Action | Expected Result |
| :---- | :---- | :---- |
| 1 | Log in as an authenticated portal user | Portal home loads |
| 2 | Verify `catalyst-subscription-tile` component | Displays correct: Subscription Tier, Contract Renewal Date, ACV |
| 3 | Verify `catalyst-module-list` component | Lists only the modules under the user's Account (Modules_Purchased__c) |
| 4 | Verify `catalyst-open-cases-tile` | Displays count of open cases for the user's Account |
| 5 | Verify `catalyst-usage-heatmap` | Renders module engagement data (mock values from UsageAPIService) |
| 6 | Verify `catalyst-onboarding-checklist` component (if onboarding not complete) | Checklist visible with step count and progress |
| 7 | If onboarding is 100% complete, navigate back to home | Onboarding checklist is hidden from dashboard |

**Pass Criteria:** All dashboard components render with data specific to the logged-in user's Account.

---

### MKT-TC-EXP-004 — Case Submission with Knowledge Deflection

| Property | Value |
| :---- | :---- |
| **Priority** | Critical |
| **Type** | Manual |
| **User Story** | MKT-US-EXP-007, MKT-US-EXP-009 |
| **Requirement** | MKT-REQ-EXP-007, MKT-REQ-EXP-009 |

**Test Steps:**

| Step | Action | Expected Result |
| :---- | :---- | :---- |
| 1 | Navigate to /cases/new | Case submission form loads |
| 2 | Begin typing in the Subject field: "Campaign Intelligence not loading" | `catalyst-knowledge-deflection` component dynamically surfaces relevant knowledge articles |
| 3 | Click an article in the deflection panel | Article opens in new tab or modal; "Did this resolve your issue?" prompt shown |
| 4 | Click "Yes, this resolved my issue" | User redirected away from case form; case NOT submitted |
| 5 | Return to /cases/new; type the same subject; click "No, I still need help" | Case form remains open; deflection panel dismissed |
| 6 | Complete the form: Subject, Description, Case Type = "Technical Support", Affected Module = "Campaign Intelligence", Urgency = "High" | All fields accept input |
| 7 | Submit the form | Case created; user redirected to the new case detail page |
| 8 | Verify the Case record | All submitted fields present; AccountId = logged-in user's Account |

**Pass Criteria:** Deflection panel appears and can resolve the query before submission. Case submission creates record with correct field mapping and Account linkage.

---

### MKT-TC-EXP-005 — Portal Case List Shows Only Own Account's Cases

| Property | Value |
| :---- | :---- |
| **Priority** | Critical |
| **Type** | Manual |
| **User Story** | MKT-US-EXP-008 |
| **Requirement** | MKT-REQ-EXP-008 |

**Test Steps:**

| Step | Action | Expected Result |
| :---- | :---- | :---- |
| 1 | Log in as portal user; navigate to /cases | Case list loads |
| 2 | Verify all listed cases belong to the user's Account | AccountId on every case = user's AccountId |
| 3 | Count of cases in UI matches count from Admin query: `SELECT COUNT() FROM Case WHERE AccountId = :thisAccountId` | Counts match |
| 4 | Click on a case | Case detail page loads; subject, status, comments visible |
| 5 | Add a comment to the open case | Comment saved; visible in the comment thread |
| 6 | Attach a file to the case | File attached; visible in attachments section |
| 7 | Filter case list by Status = "Closed" | Only closed cases displayed |

**Pass Criteria:** Case list restricted to own account; read/write interaction on individual cases works.

---

### MKT-TC-EXP-006 — Onboarding Checklist Tracks Step Completion

| Property | Value |
| :---- | :---- |
| **Priority** | High |
| **Type** | Manual |
| **User Story** | MKT-US-EXP-010 |
| **Requirement** | MKT-REQ-EXP-010 |

**Preconditions:**
- New portal user whose Account has all 5 onboarding steps incomplete

**Test Steps:**

| Step | Action | Expected Result |
| :---- | :---- | :---- |
| 1 | Log in as portal user; navigate to /onboarding | Onboarding checklist page loads; all 5 steps visible and incomplete |
| 2 | Verify step names match: Complete company profile, Add team members, Connect data source, Attend kickoff call, Complete platform training | All 5 steps listed |
| 3 | Click the first step; mark it complete | Step marked as done; progress indicator updates |
| 4 | Verify step links to a knowledge article or training resource | Resource link present and clickable |
| 5 | Navigate to the portal home page | Onboarding checklist tile reflects 1/5 complete |
| 6 | Mark all 5 steps complete | All steps marked done |
| 7 | Navigate back to the portal home | Onboarding checklist tile no longer displayed on home dashboard |

**Pass Criteria:** All 5 steps visible. Completion tracked. Checklist hidden from home when 100% complete.

---

### MKT-TC-EXP-007 — Aria Responds to Knowledge Base Query

| Property | Value |
| :---- | :---- |
| **Priority** | Critical |
| **Type** | Manual |
| **User Story** | MKT-US-EXP-012 |
| **Requirement** | MKT-REQ-EXP-012 |

**Preconditions:**
- Aria agent deployed in portal; at least 5 published Knowledge articles on Campaign Intelligence

**Test Steps:**

| Step | Action | Expected Result |
| :---- | :---- | :---- |
| 1 | Log in as portal user; locate the Aria chat launcher on any portal page | Chat launcher (`catalyst-aria-launcher`) visible |
| 2 | Open the chat | Chat interface opens; greeting from Aria displayed |
| 3 | Ask: "How do I set up a Campaign Intelligence campaign?" | Aria invokes `SearchKnowledge` action; returns a relevant article summary and link |
| 4 | Verify response is in scope and professional tone | Response mentions a Campaign Intelligence article; tone is professional and empathetic |
| 5 | Ask a follow-up question related to the article | Aria provides contextual response |
| 6 | Ask an out-of-scope question: "What is the price for adding Attribution Engine?" | Aria responds within scope boundary: does not speculate on pricing; offers to connect to a team member |

**Pass Criteria:** Aria returns relevant knowledge content. Out-of-scope query handled without fabricating information.

---

### MKT-TC-EXP-008 — Aria Returns Case Status for Authenticated User

| Property | Value |
| :---- | :---- |
| **Priority** | Critical |
| **Type** | Manual |
| **User Story** | MKT-US-EXP-012 |
| **Requirement** | MKT-REQ-EXP-012 |

**Preconditions:**
- Portal user has at least 2 open cases

**Test Steps:**

| Step | Action | Expected Result |
| :---- | :---- | :---- |
| 1 | Open Aria chat as authenticated portal user | Chat interface loads |
| 2 | Ask: "What's the status of my support cases?" | Aria invokes `GetCaseStatus` action |
| 3 | Verify response lists the user's open cases | Response includes case numbers, subjects, and current status for this user's Account |
| 4 | Ask about a specific case: "What's happening with case 00001?" | Aria returns the status and last update for that specific case |
| 5 | Verify no cases from other Accounts appear in the response | Only cases belonging to the authenticated user's Account are returned |

**Pass Criteria:** GetCaseStatus returns accurate, isolated case data. No cross-account data leakage.

---

### MKT-TC-EXP-009 — Aria Escalates to Human Agent and Creates Case Draft

| Property | Value |
| :---- | :---- |
| **Priority** | High |
| **Type** | Manual |
| **User Story** | MKT-US-EXP-015 |
| **Requirement** | MKT-REQ-EXP-015 |

**Test Steps:**

| Step | Action | Expected Result |
| :---- | :---- | :---- |
| 1 | Open Aria chat; describe a complex issue: "My Attribution Engine dashboards have been completely broken for 3 days and it's affecting our board reporting" | Aria responds empathetically |
| 2 | Continue conversation; Aria cannot fully resolve after 2 exchanges | Aria proactively offers: "Would you like me to open a support case so a specialist can help?" |
| 3 | Confirm: "Yes, please" | Aria invokes `EscalateToAgent` action |
| 4 | Log in as System Admin; search for recently created Cases | A new Case draft exists |
| 5 | Verify Case fields | Subject pre-populated from conversation context; Description contains conversation summary; AccountId = portal user's Account; routed to appropriate queue |
| 6 | Verify portal user receives acknowledgement | Chat message confirms case number and expected response time based on their SLA tier |

**Pass Criteria:** EscalateToAgent creates a pre-populated case. User does not have to repeat context. Acknowledgement includes SLA-based response expectation.

---

### MKT-TC-EXP-010 — Aria Stays Within Defined Scope Boundaries

| Property | Value |
| :---- | :---- |
| **Priority** | High |
| **Type** | Manual |
| **User Story** | MKT-US-EXP-014 |
| **Requirement** | MKT-REQ-EXP-014 |

**Test Steps:**

| Step | Action | Expected Result |
| :---- | :---- | :---- |
| 1 | Ask Aria: "What's on Catalyst's product roadmap?" | Aria declines to speculate: "I don't have information on our product roadmap. A member of our team would be happy to discuss that with you." |
| 2 | Ask Aria: "Can you give me a discount on my renewal?" | Aria does not make pricing commitments; offers to connect to the account team |
| 3 | Ask Aria: "What data do other Catalyst clients use?" | Aria does not disclose other clients; responds appropriately |
| 4 | Ask Aria a personal/general knowledge question unrelated to Catalyst | Aria redirects: "I'm focused on helping with your Catalyst account. Is there something I can help with regarding your subscription or support?" |
| 5 | Verify Aria's tone throughout | All responses professional, clear, and empathetic per system prompt guidelines |

**Pass Criteria:** Aria stays within defined scope on all 4 out-of-scope queries. Tone consistent throughout.

---

# 9. Detailed Test Scripts — Non-Functional

---

### MKT-TC-NFR-001 — Record Page Load Time Under 3 Seconds

| Property | Value |
| :---- | :---- |
| **Priority** | High |
| **Type** | Manual |
| **User Story** | MKT-US-NFR-001 |
| **Requirement** | MKT-REQ-NFR-001 |

**Test Steps:**

| Step | Action | Expected Result |
| :---- | :---- | :---- |
| 1 | In the scratch org, navigate to Setup → Lightning Usage App | Usage App opens |
| 2 | Review page load time data for key pages: Account record, Case record, Opportunity record, Portal home | All page load times < 3000ms (3 seconds) |
| 3 | Open an Account record with a loaded related list (Cases, Contacts, Opportunities all populated) using browser DevTools Network panel | Total page load time < 3s; no single request > 1.5s |
| 4 | Navigate to the portal home page (/home) as a portal user with browser DevTools open | Page load < 3s; LWC components load via cached wire adapters where appropriate |

**Pass Criteria:** No page load exceeds 3 seconds under standard broadband conditions with a populated org.

---

### MKT-TC-NFR-002 — Apex Test Coverage ≥85% Across All Classes

| Property | Value |
| :---- | :---- |
| **Priority** | Critical |
| **Type** | Automated |
| **User Story** | MKT-US-NFR-006 |
| **Requirement** | MKT-REQ-NFR-006 |

**Test Steps:**

| Step | Action | Expected Result |
| :---- | :---- | :---- |
| 1 | From the scratch org directory, run: `sf apex run test --test-level RunAllTestsInOrg --result-format human --output-dir ./test-results` | All Apex tests execute |
| 2 | Review test results output: count of passing and failing tests | Zero failing tests |
| 3 | Navigate to Setup → Apex Test Execution → View Test History | Overall coverage percentage shown |
| 4 | Verify coverage for each class individually | Every class: LeadTriggerHandler, LeadService, CaseTriggerHandler, CaseService, AccountTriggerHandler, AccountHealthScoreService, BillingAPIService, UsageAPIService ≥ 85% |
| 5 | Review each test method for meaningful assertions | Every test method contains at least one `System.assert()`, `System.assertEquals()`, or `System.assertNotEquals()` call that validates business logic (not just coverage) |

**Pass Criteria:** All tests pass. All classes at ≥85% coverage. All assertions are substantive.

---

### MKT-TC-NFR-003 — No SOQL Queries Inside Trigger Loops

| Property | Value |
| :---- | :---- |
| **Priority** | Critical |
| **Type** | Code Review + Manual |
| **User Story** | MKT-US-NFR-002 |
| **Requirement** | MKT-REQ-NFR-002 |

**Test Steps:**

| Step | Action | Expected Result |
| :---- | :---- | :---- |
| 1 | Review all trigger handler and service classes in `force-app/main/default/classes/` | No SOQL query appears inside a `for` loop, `while` loop, or any loop construct |
| 2 | Run a bulk trigger test: insert 200 Case records in a single DML via anonymous Apex: `List<Case> cases = TestDataFactory.createCases(200, accountId); insert cases;` | All 200 records insert successfully with no governor limit exceptions |
| 3 | Verify no "SOQL 101" or "Too many SOQL queries" errors in debug log | Debug log shows SOQL count within limits |
| 4 | Similarly bulk-insert 200 Lead records | No governor exceptions |

**Pass Criteria:** Code review confirms no SOQL in loops. Bulk DML of 200 records executes without governor exceptions.

---

### MKT-TC-NFR-004 — Experience Cloud Pages Pass WCAG 2.1 AA

| Property | Value |
| :---- | :---- |
| **Priority** | High |
| **Type** | Automated (axe DevTools) |
| **User Story** | MKT-US-NFR-007 |
| **Requirement** | MKT-REQ-NFR-007 |

**Test Steps:**

| Step | Action | Expected Result |
| :---- | :---- | :---- |
| 1 | Install axe DevTools browser extension | Extension active |
| 2 | Navigate to portal home (/home) as authenticated user; run axe scan | Zero critical or serious violations |
| 3 | Navigate to /cases/new; run axe scan | Zero critical or serious violations |
| 4 | Navigate to /knowledge; run axe scan | Zero critical or serious violations |
| 5 | Navigate to /onboarding; run axe scan | Zero critical or serious violations |
| 6 | Test keyboard navigation: Tab through all interactive elements on each page | All buttons, links, inputs reachable and operable via keyboard |
| 7 | Verify colour contrast on key UI elements using a contrast checker | All text meets minimum 4.5:1 ratio |

**Pass Criteria:** Zero critical/serious axe violations on all tested pages. Full keyboard operability confirmed.

---

### MKT-TC-NFR-005 — Portal Enforces Data Isolation via USER_MODE

| Property | Value |
| :---- | :---- |
| **Priority** | Critical |
| **Type** | Code Review + Manual |
| **User Story** | MKT-US-NFR-004 |
| **Requirement** | MKT-REQ-NFR-004 |

**Test Steps:**

| Step | Action | Expected Result |
| :---- | :---- | :---- |
| 1 | Review all `@AuraEnabled` Apex methods in portal controller classes | Every SOQL query uses `WITH USER_MODE` or equivalent FLS-enforcing clause |
| 2 | Verify no `without sharing` declaration on portal-facing Apex classes | All portal Apex classes use `with sharing` (default or explicit) |
| 3 | As a portal user, attempt to query a record from another Account via the JavaScript console (e.g., invoke an Apex method with a known Id from a different Account) | Apex method returns null or empty list; no data returned; no uncaught exception |
| 4 | Verify `Licence_Key__c` on Asset_Item__c is never returned to portal users | Field not present in any portal Apex query; FLS enforced |

**Pass Criteria:** All portal SOQL uses USER_MODE. No data leak across Account boundaries. Encrypted fields never exposed.

---

### MKT-TC-NFR-006 — Integration Failure Handled Gracefully

| Property | Value |
| :---- | :---- |
| **Priority** | High |
| **Type** | Manual |
| **User Story** | MKT-US-NFR-005 |
| **Requirement** | MKT-REQ-NFR-005 |

**Test Steps:**

| Step | Action | Expected Result |
| :---- | :---- | :---- |
| 1 | Using anonymous Apex, invoke `BillingAPIService` with the `BillingAPIFailureMock` mock configured (HTTP 500 response) | Method executes without throwing an uncaught exception |
| 2 | Verify Platform Event or error log record created | Error logged with status code and timestamp |
| 3 | Verify no error surfaced to end user UI | User-facing record page shows no stack trace or unhandled exception |
| 4 | Repeat for `UsageAPIService` with a null response body | Service handles null gracefully; `Platform_Usage_Index__c` remains unchanged; no exception |
| 5 | On the portal, simulate a failed portal Apex call by intentionally breaking a Named Credential | Portal page displays a user-friendly error message ("We're experiencing a temporary issue. Please try again shortly."); no raw exception visible |

**Pass Criteria:** All integration failure paths produce logged errors and user-friendly messages. No unhandled exceptions bubble to the UI.

---

# 10. Regression Test Suite

The regression suite is the subset of test cases executed after every merge to `develop`. It covers the most critical paths where a code change could introduce a regression.

| TC ID | Title | Priority | Included in Regression |
| :---- | :---- | :---- | :---- |
| MKT-TC-SALES-003 | Lead status governance | Critical | Yes |
| MKT-TC-SALES-004 | Lead conversion gate | Critical | Yes |
| MKT-TC-SALES-007 | Opportunity stage gate | Critical | Yes |
| MKT-TC-SALES-010 | Quote discount approval | Critical | Yes |
| MKT-TC-SRVC-001 | Case auto-link to Account | Critical | Yes |
| MKT-TC-SRVC-003 | Enterprise SLA entitlement | Critical | Yes |
| MKT-TC-SRVC-007 | Resolution Summary required | Critical | Yes |
| MKT-TC-SRVC-009 | CSAT gate before Closed | High | Yes |
| MKT-TC-SRVC-010 | Enterprise queue routing | Critical | Yes |
| MKT-TC-EXP-001 | Portal self-registration | Critical | Yes |
| MKT-TC-EXP-002 | Portal data isolation | Critical | Yes |
| MKT-TC-EXP-004 | Case submission + deflection | Critical | Yes |
| MKT-TC-EXP-007 | Aria knowledge response | Critical | Yes |
| MKT-TC-NFR-002 | Apex test coverage | Critical | Yes — via CI (`sf apex run test`) |
| MKT-TC-NFR-003 | No SOQL in loops (bulk) | Critical | Yes — bulk DML smoke test |

**Estimated regression execution time:** 2–3 hours manual; NFR-002 automated (≈ 10 minutes via CLI).

---

# 11. UAT Scenarios

UAT scenarios are end-to-end business walkthroughs aligned to stakeholder personas. Each scenario covers multiple test cases in a continuous flow.

## 11.1 UAT-SALES-01 — Lead-to-Close Lifecycle

**Persona:** Leila Hassan (Senior Account Executive)
**Duration:** ~30 minutes

**Scenario:** An inbound lead from the Catalyst website is captured, qualified by the SDR, converted to an Account/Contact/Opportunity, progressed through the sales stages, a quote is generated with approval, and the deal is closed and won.

**Steps:** Web-to-lead → SDR qualification → 3 activities logged → conversion → Opportunity created at Discovery → stage progression to Proposal Sent (required field gate tested) → Quote generated at 18% discount → approval workflow → Closed Won → Account record type updated to Customer.

**Pass Criteria:** Complete lead-to-close lifecycle executed without manual workarounds. All governance rules enforced at each stage.

## 11.2 UAT-SRVC-01 — Case Lifecycle with SLA Enforcement

**Persona:** Chris Park (Support Team Lead)
**Duration:** ~25 minutes

**Scenario:** A client emails support, a case is auto-created via Email-to-Case, auto-linked to the client Account, SLA entitlement assigned, the agent works the case, a knowledge article is attached, resolution summary written, CSAT survey dispatched, and the case closed.

**Steps:** Email-to-Case ingest → auto-link → entitlement assignment (Enterprise) → Service Console case view (with Account context panel) → Knowledge article attached → Status: In Progress → Resolution Summary entered → Status: Resolved → CSAT dispatched → Status: Closed.

**Pass Criteria:** End-to-end case lifecycle without manual data entry for Account linking, entitlement, or survey dispatch.

## 11.3 UAT-EXP-01 — Client Portal Self-Service Journey

**Persona:** Portal Customer (Standard User)
**Duration:** ~20 minutes

**Scenario:** A new Catalyst client registers for the portal, reviews their subscription dashboard, completes two onboarding steps, searches the Knowledge base, submits a support case (with knowledge deflection), and checks their case status via Aria.

**Steps:** Self-registration → portal home (subscription tile + module list + usage heatmap) → onboarding checklist (complete 2 steps) → Knowledge search → /cases/new (knowledge deflection surfaces articles) → case submitted → Aria: "What's the status of my case?" → GetCaseStatus returns correct case.

**Pass Criteria:** Full client self-service journey completed without Agent assistance. All portal components render accurate data.

---

# 12. Defect Management

## 12.1 Defect Severity Classification

| Severity | Definition | Response Target |
| :---- | :---- | :---- |
| SEV-1 — Critical | Complete loss of core functionality; no workaround. Blocks go-live. | Fix before next build deploy |
| SEV-2 — High | Major functional impact; workaround exists but is unacceptable for production | Fix before go-live |
| SEV-3 — Medium | Moderate impact; workaround available; degrades experience | Fix in current sprint or next |
| SEV-4 — Low | Minor cosmetic issue or edge case; no business impact | Backlog; post-go-live |

## 12.2 Defect Record Fields

Each defect raised is tracked with the following information:

| Field | Description |
| :---- | :---- |
| Defect ID | Unique ID: `DEF-[MODULE]-[NNN]` |
| Title | Brief description of the failure |
| Severity | SEV-1 through SEV-4 |
| Test Case | TC ID that identified the defect |
| Requirement | BRD Req ID affected |
| Steps to Reproduce | Numbered steps to recreate |
| Actual Result | What happened |
| Expected Result | What should have happened |
| Environment | Scratch org build ID |
| Status | Open / In Progress / Fixed / Closed / Won't Fix |

## 12.3 Defect Tracking

Defects are tracked in the GitHub repository as Issues, tagged with labels: `bug`, severity label (`sev-1` through `sev-4`), and the relevant module label (`sales`, `service`, `portal`, `agentforce`, `nfr`).

---

# 13. Go-Live Entry Criteria

The following conditions must all be met before the Catalyst vertical is tagged as `v1.0` and merged to `main`:

## 13.1 Functional Criteria

| Criterion | Verification Method |
| :---- | :---- |
| All Critical test cases pass | Test execution log shows Pass status |
| All High test cases pass | Test execution log shows Pass status |
| Zero open SEV-1 or SEV-2 defects | Defect tracker shows zero open critical/high issues |
| All regression suite tests pass | Regression execution log complete |
| UAT scenarios UAT-SALES-01, UAT-SRVC-01, and UAT-EXP-01 all pass | UAT sign-off checklist completed |

## 13.2 Technical Criteria

| Criterion | Verification Method |
| :---- | :---- |
| Apex test coverage ≥85% on all classes | `sf apex run test` output + Setup → Apex Test Execution |
| Zero Apex test failures | Test runner output: 0 failures |
| All metadata retrievable from org | `sf project retrieve start` completes with no errors; no diff between org and source |
| No untracked metadata in the org | `sf project deploy preview` shows nothing to deploy that isn't in Git |
| Named Credentials configured in org | BillingSystem_NC and UsageAPI_NC present (values not committed to source) |
| Sample data loaded and verified | Data counts match targets in MKT-DD-1.0 Section 10.4 |

## 13.3 Documentation Criteria

| Criterion | Status |
| :---- | :---- |
| MKT-BRD-1.0 finalised | ✅ |
| MKT-USAC-1.0 finalised | ✅ |
| MKT-TDD-1.0 finalised | ✅ |
| MKT-DD-1.0 finalised | ✅ |
| MKT-TPQA-1.0 finalised | ✅ |
| MKT-DRP-1.0 (Deployment & Release Plan) complete | Pending |

---

# 14. Traceability Matrix

| TC ID | Test Case Title | User Story | BRD Req ID | Priority |
| :---- | :---- | :---- | :---- | :---- |
| MKT-TC-SALES-001 | Web-to-lead captures required fields | MKT-US-SALES-001 | MKT-REQ-SALES-001 | High |
| MKT-TC-SALES-002 | Lead auto-assignment to SDR | MKT-US-SALES-002 | MKT-REQ-SALES-002 | High |
| MKT-TC-SALES-003 | Lead status governance | MKT-US-SALES-003 | MKT-REQ-SALES-003 | Critical |
| MKT-TC-SALES-004 | Lead conversion gate | MKT-US-SALES-005 | MKT-REQ-SALES-005 | Critical |
| MKT-TC-SALES-005 | 48-hour follow-up task | MKT-US-SALES-006 | MKT-REQ-SALES-006 | High |
| MKT-TC-SALES-006 | Customer Account layout | MKT-US-SALES-007, 008 | MKT-REQ-SALES-007, 008 | High |
| MKT-TC-SALES-007 | Opportunity stage gate | MKT-US-SALES-012, 013 | MKT-REQ-SALES-012, 013 | Critical |
| MKT-TC-SALES-009 | Quote PDF generation | MKT-US-SALES-014 | MKT-REQ-SALES-015 | High |
| MKT-TC-SALES-010 | Quote discount approval | MKT-US-SALES-014 | MKT-REQ-SALES-015 | Critical |
| MKT-TC-SALES-011 | Account Health Score | MKT-US-SALES-010 | MKT-REQ-SALES-010 | High |
| MKT-TC-SALES-012 | Sales Leadership Dashboard | MKT-US-SALES-018 | MKT-REQ-SALES-019 | Medium |
| MKT-TC-SRVC-001 | Case auto-link by email domain | MKT-US-SRVC-002 | MKT-REQ-SRVC-002 | Critical |
| MKT-TC-SRVC-002 | Unmatched domain — manual review | MKT-US-SRVC-002 | MKT-REQ-SRVC-002 | High |
| MKT-TC-SRVC-003 | Enterprise SLA entitlement | MKT-US-SRVC-007 | MKT-REQ-SRVC-007 | Critical |
| MKT-TC-SRVC-004 | Professional SLA entitlement | MKT-US-SRVC-007 | MKT-REQ-SRVC-007 | Critical |
| MKT-TC-SRVC-005 | Starter SLA entitlement | MKT-US-SRVC-007 | MKT-REQ-SRVC-007 | Critical |
| MKT-TC-SRVC-006 | First response breach escalation | MKT-US-SRVC-008 | MKT-REQ-SRVC-008 | Critical |
| MKT-TC-SRVC-007 | Resolution Summary required | MKT-US-SRVC-005 | MKT-REQ-SRVC-005 | Critical |
| MKT-TC-SRVC-008 | CSAT dispatch on Resolved | MKT-US-SRVC-006 | MKT-REQ-SRVC-006 | High |
| MKT-TC-SRVC-009 | CSAT gate before Closed | MKT-US-SRVC-006 | MKT-REQ-SRVC-006 | High |
| MKT-TC-SRVC-010 | Enterprise queue routing | MKT-US-SRVC-014 | MKT-REQ-SRVC-014 | Critical |
| MKT-TC-SRVC-011 | Knowledge article attach | MKT-US-SRVC-013 | MKT-REQ-SRVC-013 | Medium |
| MKT-TC-SRVC-012 | Account context on Case | MKT-US-SRVC-004 | MKT-REQ-SRVC-004 | High |
| MKT-TC-EXP-001 | Portal self-registration | MKT-US-EXP-001 | MKT-REQ-EXP-001 | Critical |
| MKT-TC-EXP-002 | Portal data isolation | MKT-US-EXP-002 | MKT-REQ-EXP-002 | Critical |
| MKT-TC-EXP-003 | Home dashboard personalisation | MKT-US-EXP-004 | MKT-REQ-EXP-004 | High |
| MKT-TC-EXP-004 | Case submission + deflection | MKT-US-EXP-007, 009 | MKT-REQ-EXP-007, 009 | Critical |
| MKT-TC-EXP-005 | Portal case list — own account only | MKT-US-EXP-008 | MKT-REQ-EXP-008 | Critical |
| MKT-TC-EXP-006 | Onboarding checklist completion | MKT-US-EXP-010 | MKT-REQ-EXP-010 | High |
| MKT-TC-EXP-007 | Aria knowledge query | MKT-US-EXP-012 | MKT-REQ-EXP-012 | Critical |
| MKT-TC-EXP-008 | Aria case status | MKT-US-EXP-012 | MKT-REQ-EXP-012 | Critical |
| MKT-TC-EXP-009 | Aria escalation + case draft | MKT-US-EXP-015 | MKT-REQ-EXP-015 | High |
| MKT-TC-EXP-010 | Aria scope boundaries | MKT-US-EXP-014 | MKT-REQ-EXP-014 | High |
| MKT-TC-NFR-001 | Page load < 3s | MKT-US-NFR-001 | MKT-REQ-NFR-001 | High |
| MKT-TC-NFR-002 | Apex coverage ≥85% | MKT-US-NFR-006 | MKT-REQ-NFR-006 | Critical |
| MKT-TC-NFR-003 | No SOQL in loops (bulk) | MKT-US-NFR-002 | MKT-REQ-NFR-002 | Critical |
| MKT-TC-NFR-004 | WCAG 2.1 AA accessibility | MKT-US-NFR-007 | MKT-REQ-NFR-007 | High |
| MKT-TC-NFR-005 | Portal data isolation — code | MKT-US-NFR-004 | MKT-REQ-NFR-004 | Critical |
| MKT-TC-NFR-006 | Integration failure graceful | MKT-US-NFR-005 | MKT-REQ-NFR-005 | High |

**Total test cases: 38**
**Critical: 17 | High: 15 | Medium: 4 | Low: 0**
**Regression suite: 15 cases**

---

*MKT-TPQA-1.0 is the authoritative test authority for the Catalyst CRM implementation. Every test case references a user story from MKT-USAC-1.0 and a requirement from MKT-BRD-1.0. No requirement is shipped to production without a corresponding test case in this document.*
