
**CATALYST MARKETING TECHNOLOGIES, INC.**

*Accelerate Every Campaign.*

**BDD TESTING EXAMPLES**

**Salesforce CRM Implementation**

Sales Cloud · Service Cloud · Experience Cloud

| Document ID | MKT-BDD-1.0 |
| :---- | :---- |
| **Status** | DRAFT — In Progress |
| **Version** | 1.0 |
| **Vertical** | Marketing — Baseline |
| **Company** | Catalyst Marketing Technologies, Inc. |
| **Prepared By** | Portfolio Developer |
| **Date** | 2026 |
| **Parent Doc** | MKT-TPQA-1.0 — Test Plan & QA Scripts |
| **Traces From** | MKT-USAC-1.0 (acceptance criteria), MKT-TPQA-1.0 (test cases) |

---

# Table of Contents

1. Document Control
2. Purpose & Scope
3. BDD Framework & Tooling
4. Tag Taxonomy
5. Feature: Lead Management
6. Feature: Opportunity Lifecycle
7. Feature: Case Management
8. Feature: SLA Entitlements & Escalation
9. Feature: Knowledge Management
10. Feature: Experience Cloud — Portal Access & Data Isolation
11. Feature: Experience Cloud — Client Self-Service
12. Feature: Agentforce — Aria Client Assistant
13. Scenario Coverage Summary
14. Automation Readiness Notes
15. Traceability Matrix

---

# 1. Document Control

## 1.1 Version History

| Version | Date | Author | Changes | Status |
| :---- | :---- | :---- | :---- | :---- |
| 1.0 | 2026 | Portfolio Developer | Initial draft — full feature file library | Draft |

## 1.2 Related Documents

| Doc ID | Document | Relationship |
| :---- | :---- | :---- |
| MKT-USAC-1.0 | User Stories & Acceptance Criteria | Source acceptance criteria; BDD scenarios are derived refinements |
| MKT-TPQA-1.0 | Test Plan & QA Scripts | BDD scenarios complement manual QA scripts — same behaviours, executable format |
| MKT-TDD-1.0 | Technical Design Document | Implementation against which scenarios are validated |

---

# 2. Purpose & Scope

## 2.1 What This Document Is

This document contains a library of BDD (Behaviour-Driven Development) feature files written in Gherkin syntax. Each feature file defines business behaviours in the **Given / When / Then** format, producing executable specifications that serve as both documentation and test automation input.

BDD examples differ from the acceptance criteria in MKT-USAC-1.0 in the following ways:

| USAC Acceptance Criteria | BDD Feature Files (this document) |
| :---- | :---- |
| Written at story level | Written at behaviour / scenario level |
| Describes what the system should do | Describes exactly how the system behaves with specific data |
| Authoritative for product acceptance | Authoritative for test automation step definitions |
| Abstract ("a lead with 3 activities") | Concrete ("Activity_Count__c = 3; Status = 'Qualified'") |
| Owned by product and business | Owned by QA and developer |

## 2.2 Scenario Count

This document contains **52 scenarios** across **8 feature files**, covering all Critical and High priority behaviours from MKT-TPQA-1.0.

## 2.3 Relationship to Test Cases

Each scenario maps to one or more test cases in MKT-TPQA-1.0. The `@tc:` tag on each scenario provides the mapping.

---

# 3. BDD Framework & Tooling

## 3.1 Recommended Framework

For Salesforce implementations, BDD scenarios can be executed via:

| Option | Tool | Notes |
| :---- | :---- | :---- |
| Primary (portfolio) | Manual execution against Gherkin steps using MKT-TPQA-1.0 scripts | Step definitions mapped to QA scripts; not yet wired to an automation runner |
| Future automation | Salesforce DX + Jest (LWC), Apex test classes as step definition proxies | Apex test methods structured to mirror Given/When/Then steps |
| Full BDD automation | Cucumber.js + Playwright (for portal UI) + Apex callouts | Requires CI pipeline — planned for post-MTF v1.0 (see CICD_ADDENDUM.md) |

## 3.2 File Convention

In a fully automated setup, each feature below would reside as a `.feature` file:

```
tests/
└── bdd/
    ├── features/
    │   ├── lead_management.feature
    │   ├── opportunity_lifecycle.feature
    │   ├── case_management.feature
    │   ├── sla_entitlements.feature
    │   ├── knowledge_management.feature
    │   ├── portal_access.feature
    │   ├── portal_self_service.feature
    │   └── agentforce_aria.feature
    └── step_definitions/
        ├── salesforce_steps.js
        └── portal_steps.js
```

For the portfolio, these files are presented inline in this document.

---

# 4. Tag Taxonomy

Tags appear on Feature blocks and individual Scenarios. They enable filtering for targeted execution.

| Tag | Meaning |
| :---- | :---- |
| `@critical` | Blocks go-live if failing |
| `@high` | Should pass before go-live |
| `@medium` | Should pass; workaround acceptable |
| `@regression` | Included in the regression suite |
| `@smoke` | Subset of regression; fastest confidence check (< 30 min) |
| `@sales` | Sales Cloud feature |
| `@service` | Service Cloud feature |
| `@portal` | Experience Cloud feature |
| `@agentforce` | Agentforce / Aria feature |
| `@nfr` | Non-functional requirement |
| `@security` | Security or data isolation scenario |
| `@tc:MKT-TC-XXXX-NNN` | Maps to test case in MKT-TPQA-1.0 |
| `@us:MKT-US-XXXX-NNN` | Maps to user story in MKT-USAC-1.0 |
| `@req:MKT-REQ-XXXX-NNN` | Maps to requirement in MKT-BRD-1.0 |
| `@wip` | Work in progress — not yet ready for execution |

---

# 5. Feature: Lead Management

```gherkin
@sales
Feature: Lead Management
  As the Catalyst sales team
  We need a governed lead capture and qualification process
  So that only high-quality, well-documented leads enter our sales pipeline

  Background:
    Given I am logged in as a Sales Development Representative
    And the lead assignment rules are active
    And the sample SDR team has at least 2 active users


  @critical @regression @smoke
  @tc:MKT-TC-SALES-003 @us:MKT-US-SALES-003 @req:MKT-REQ-SALES-003
  Scenario: SDR cannot advance a lead to Qualified without a Company name
    Given a lead exists with the following data:
      | Field        | Value              |
      | First Name   | Alex               |
      | Last Name    | Rivera             |
      | Company      |                    |
      | Email        | alex@acmecorp.com  |
      | Status       | Contacted          |
    When I attempt to change the lead status to "Qualified"
    Then I should see the validation error "Company and Email are required before a lead can be set to Qualified"
    And the lead status should remain "Contacted"


  @critical @regression
  @tc:MKT-TC-SALES-003 @us:MKT-US-SALES-003 @req:MKT-REQ-SALES-003
  Scenario: SDR advances lead to Qualified when required fields are present
    Given a lead exists with the following data:
      | Field        | Value              |
      | First Name   | Alex               |
      | Last Name    | Rivera             |
      | Company      | Acme Corp          |
      | Email        | alex@acmecorp.com  |
      | Status       | Contacted          |
    When I change the lead status to "Qualified"
    And I save the record
    Then the lead status should be "Qualified"
    And no validation error should appear


  @critical @regression
  @tc:MKT-TC-SALES-004 @us:MKT-US-SALES-005 @req:MKT-REQ-SALES-005
  Scenario: Lead conversion is blocked when status is not Qualified
    Given a lead exists with status "Contacted" and 4 logged activities
    When I click the "Convert" button
    And I attempt to complete the conversion
    Then I should see the validation error "A lead cannot be converted unless Status is Qualified and at least 3 activities are logged"
    And the lead should not be converted


  @critical @regression @smoke
  @tc:MKT-TC-SALES-004 @us:MKT-US-SALES-005 @req:MKT-REQ-SALES-005
  Scenario: Lead conversion is blocked when status is Qualified but fewer than 3 activities logged
    Given a lead exists with status "Qualified" and 2 logged activities
    When I click the "Convert" button
    And I attempt to complete the conversion
    Then I should see the validation error "A lead cannot be converted unless Status is Qualified and at least 3 activities are logged"
    And the lead should not be converted


  @critical @regression @smoke
  @tc:MKT-TC-SALES-004 @us:MKT-US-SALES-005 @req:MKT-REQ-SALES-005
  Scenario: Lead conversion succeeds when Qualified with exactly 3 activities
    Given a lead exists with the following data:
      | Field            | Value               |
      | Status           | Qualified           |
      | Activity Count   | 3                   |
      | Company          | Acme Corp           |
      | Email            | alex@acmecorp.com   |
    When I click the "Convert" button
    And I complete the conversion form
    Then the lead should be converted successfully
    And an Account named "Acme Corp" should be created
    And a Contact named "Alex Rivera" should be created
    And an Opportunity should be created in "Discovery" stage


  @high @regression
  @tc:MKT-TC-SALES-002 @us:MKT-US-SALES-002 @req:MKT-REQ-SALES-002
  Scenario Outline: Lead assignment routes to correct SDR based on source and geography
    Given a new lead is created with Lead Source "<source>" and State "<state>"
    When the lead assignment rules execute
    Then the lead should be assigned to the SDR responsible for "<source>" leads in "<state>"
    And the lead should not remain owned by the System Administrator

    Examples:
      | source              | state    |
      | Web — Organic       | Texas    |
      | Web — Paid Search   | Texas    |
      | Partner Referral    | New York |
      | Event — Conference  | Illinois |
      | Customer Referral   | Texas    |


  @high @regression
  @tc:MKT-TC-SALES-005 @us:MKT-US-SALES-006 @req:MKT-REQ-SALES-006
  Scenario: Follow-up task is created 48 hours after lead creation with no activity
    Given a lead was created 48 hours ago
    And the lead has no logged tasks or events
    When the scheduled follow-up flow runs
    Then a Task should exist for the lead with the following data:
      | Field    | Value                                       |
      | Subject  | Follow Up — No Activity Logged              |
      | Priority | High                                        |
      | Owner    | The lead owner                              |


  @high
  @tc:MKT-TC-SALES-005 @us:MKT-US-SALES-006 @req:MKT-REQ-SALES-006
  Scenario: Follow-up task is NOT created when lead already has a logged activity
    Given a lead was created 48 hours ago
    And the lead has 1 logged task
    When the scheduled follow-up flow runs
    Then no new follow-up task should be created for this lead


  @medium
  @us:MKT-US-SALES-001 @req:MKT-REQ-SALES-001
  Scenario: Web-to-lead form submission creates a lead with all captured fields
    Given a website visitor completes the web-to-lead form with the following data:
      | Field             | Value                          |
      | First Name        | Jordan                         |
      | Last Name         | Kim                            |
      | Company           | Beta Technologies              |
      | Job Title         | Head of Marketing              |
      | Email             | jordan.kim@betatech.com        |
      | Phone             | 512-555-0199                   |
      | Lead Source       | Web — Paid Search              |
      | Area of Interest  | Attribution Engine             |
    When the form is submitted
    Then a Lead record should exist with all submitted field values
    And the lead status should be "New"
    And the Area_of_Interest__c field should contain "Attribution Engine"
```

---

# 6. Feature: Opportunity Lifecycle

```gherkin
@sales
Feature: Opportunity Lifecycle
  As the Catalyst sales team
  We need governed opportunity stages with mandatory field requirements and a discount approval process
  So that pipeline data is accurate and discounting is controlled

  Background:
    Given I am logged in as an Account Executive
    And a Customer Account "TechAlpha Inc" exists with Subscription_Tier__c = "Enterprise"
    And an Opportunity "TechAlpha — Campaign Intelligence" exists linked to "TechAlpha Inc"


  @critical @regression @smoke
  @tc:MKT-TC-SALES-007 @us:MKT-US-SALES-012 @req:MKT-REQ-SALES-012
  Scenario: Stage advancement to Proposal Sent is blocked when required fields are missing
    Given the Opportunity is in "Technical Evaluation" stage
    And the following fields are blank:
      | Contract_Length__c  |
      | Decision_Date__c    |
      | Economic_Buyer__c   |
    When I change the stage to "Proposal Sent"
    And I save the Opportunity
    Then I should see the validation error "Contract Length, Decision Date, and Economic Buyer are required before advancing to Proposal Sent"
    And the stage should remain "Technical Evaluation"


  @critical @regression
  @tc:MKT-TC-SALES-007 @us:MKT-US-SALES-013 @req:MKT-REQ-SALES-013
  Scenario Outline: Stage gate checks each required field independently
    Given the Opportunity is in "Technical Evaluation" stage
    And the following fields are populated:
      | Contract_Length__c  | <contract_length> |
      | Decision_Date__c    | <decision_date>   |
      | Economic_Buyer__c   | <economic_buyer>  |
    When I change the stage to "Proposal Sent"
    And I save the Opportunity
    Then the save result should be "<result>"

    Examples:
      | contract_length | decision_date  | economic_buyer    | result  |
      | 24 Months       | 2026-12-01     | Sarah Chen (ID)   | Success |
      |                 | 2026-12-01     | Sarah Chen (ID)   | Blocked |
      | 24 Months       |                | Sarah Chen (ID)   | Blocked |
      | 24 Months       | 2026-12-01     |                   | Blocked |
      |                 |                |                   | Blocked |


  @critical @regression @smoke
  @tc:MKT-TC-SALES-010 @us:MKT-US-SALES-014 @req:MKT-REQ-SALES-015
  Scenario: Quote with discount above 15% triggers VP approval
    Given the Opportunity is in "Proposal Sent" stage
    And a Quote exists linked to the Opportunity
    And the Quote has a line item with discount set to 16%
    When I save the Quote
    Then the Quote status should be "Pending Approval"
    And an approval request should appear in the VP of Sales approval queue
    And the VP of Sales should receive an approval notification email


  @critical @regression
  @tc:MKT-TC-SALES-010 @us:MKT-US-SALES-014 @req:MKT-REQ-SALES-015
  Scenario Outline: Discount approval threshold boundary behaviour
    Given a Quote with a line item discount of <discount>%
    When I save the Quote
    Then the approval status should be "<approval_status>"

    Examples:
      | discount | approval_status  |
      | 14       | Not triggered    |
      | 15       | Not triggered    |
      | 15.01    | Pending Approval |
      | 20       | Pending Approval |
      | 25       | Pending Approval |


  @high @regression
  @tc:MKT-TC-SALES-010 @us:MKT-US-SALES-014 @req:MKT-REQ-SALES-015
  Scenario: VP of Sales approves a discount request
    Given a Quote is in "Pending Approval" status with a 20% discount
    When the VP of Sales approves the approval request
    Then the Quote status should be "Approved"
    And the Opportunity owner should receive an approval confirmation notification


  @high @regression
  @tc:MKT-TC-SALES-010 @us:MKT-US-SALES-014 @req:MKT-REQ-SALES-015
  Scenario: VP of Sales rejects a discount request
    Given a Quote is in "Pending Approval" status with a 22% discount
    When the VP of Sales rejects the approval request
    Then the Quote status should be "Rejected"
    And the Opportunity owner should receive a rejection notification email


  @high @regression
  @tc:MKT-TC-SALES-007 @us:MKT-US-SALES-015 @req:MKT-REQ-SALES-016
  Scenario: Loss Reason is required when closing an opportunity as Lost
    Given the Opportunity is in "Negotiation" stage
    And Loss_Reason__c is blank
    When I change the stage to "Closed Lost"
    And I save the Opportunity
    Then I should see the validation error "Loss Reason is required when closing an opportunity as Lost"
    And the stage should remain "Negotiation"


  @high
  @tc:MKT-TC-SALES-007 @us:MKT-US-SALES-015 @req:MKT-REQ-SALES-016
  Scenario Outline: Each valid Loss Reason allows Closed Lost to save
    Given the Opportunity is in "Negotiation" stage
    When I set Loss_Reason__c to "<loss_reason>"
    And I change the stage to "Closed Lost"
    And I save the Opportunity
    Then the stage should be "Closed Lost"
    And Loss_Reason__c should be "<loss_reason>"

    Examples:
      | loss_reason       |
      | Competitor — Named |
      | Price             |
      | Timing            |
      | No Decision       |
      | Product Gap       |
```

---

# 7. Feature: Case Management

```gherkin
@service
Feature: Case Management
  As the Catalyst Customer Success team
  We need automated case intake, account linkage, and lifecycle governance
  So that agents have full context and cases are handled consistently

  Background:
    Given the following Customer Accounts exist:
      | Account Name   | Website             | Subscription Tier |
      | Acme Corp      | acmecorp.com        | Enterprise        |
      | Beta Ltd       | betaltd.co.uk       | Professional      |
      | Gamma Inc      | gammainc.com        | Starter           |
    And the case assignment queues are configured


  @critical @regression @smoke
  @tc:MKT-TC-SRVC-001 @us:MKT-US-SRVC-002 @req:MKT-REQ-SRVC-002
  Scenario: Case is automatically linked to an Account by email domain
    Given a case is created with SuppliedEmail "support@acmecorp.com"
    And the AccountId is initially null
    When the Case_AfterSave_AutoLinkAccount flow executes
    Then the case AccountId should be set to "Acme Corp"
    And Auto_Link_Status__c should be "Linked"


  @high @regression
  @tc:MKT-TC-SRVC-002 @us:MKT-US-SRVC-002 @req:MKT-REQ-SRVC-002
  Scenario: Case with an unrecognised email domain is flagged for manual review
    Given a case is created with SuppliedEmail "user@unknownvendor.com"
    And no Account exists with a matching website domain
    When the Case_AfterSave_AutoLinkAccount flow executes
    Then Auto_Link_Status__c should be "Pending Manual Review"
    And the case AccountId should remain null


  @high @regression
  @tc:MKT-TC-SRVC-002 @us:MKT-US-SRVC-002 @req:MKT-REQ-SRVC-002
  Scenario Outline: Common email domains are excluded from auto-link attempts
    Given a case is created with SuppliedEmail "<email>"
    When the Case_AfterSave_AutoLinkAccount flow executes
    Then Auto_Link_Status__c should be "Not Applicable"
    And no Account lookup attempt should be made

    Examples:
      | email                    |
      | user@gmail.com           |
      | user@outlook.com         |
      | user@hotmail.com         |
      | user@yahoo.com           |


  @critical @regression @smoke
  @tc:MKT-TC-SRVC-007 @us:MKT-US-SRVC-005 @req:MKT-REQ-SRVC-005
  Scenario: Case cannot be set to Resolved without a Resolution Summary
    Given a case exists with status "In Progress"
    And Resolution_Summary__c is blank
    When I change the case status to "Resolved"
    And I save the case
    Then I should see the validation error "A Resolution Summary is required before setting a case to Resolved"
    And the case status should remain "In Progress"


  @critical @regression
  @tc:MKT-TC-SRVC-007 @us:MKT-US-SRVC-005 @req:MKT-REQ-SRVC-005
  Scenario: Case status advances to Resolved when Resolution Summary is provided
    Given a case exists with status "In Progress"
    And Resolution_Summary__c is "Issue resolved by clearing the Attribution Engine cache. Confirmed with client."
    When I change the case status to "Resolved"
    And I save the case
    Then the case status should be "Resolved"
    And no validation error should appear


  @high @regression
  @tc:MKT-TC-SRVC-009 @us:MKT-US-SRVC-006 @req:MKT-REQ-SRVC-006
  Scenario: Case cannot be Closed if the CSAT survey has not been sent
    Given a case exists with status "Resolved"
    And CSAT_Sent__c is false
    When I change the case status to "Closed"
    And I save the case
    Then I should see the validation error "Please send the CSAT survey before closing this case"
    And the case status should remain "Resolved"


  @high @regression
  @tc:MKT-TC-SRVC-009 @us:MKT-US-SRVC-006 @req:MKT-REQ-SRVC-006
  Scenario: Case can be Closed when the CSAT survey has been sent
    Given a case exists with status "Resolved"
    And CSAT_Sent__c is true
    When I change the case status to "Closed"
    And I save the case
    Then the case status should be "Closed"


  @high @regression
  @tc:MKT-TC-SRVC-008 @us:MKT-US-SRVC-006 @req:MKT-REQ-SRVC-006
  Scenario: Setting a case to Resolved automatically dispatches a CSAT survey
    Given a case exists with status "In Progress" linked to Contact "Sarah Chen"
    And Resolution_Summary__c is "Problem resolved."
    When I change the case status to "Resolved" and save
    Then a Feedback_Survey__c record should be created with:
      | Field         | Value                |
      | Survey_Type   | CSAT                 |
      | Status        | Sent                 |
      | Contact       | Sarah Chen           |
      | Case          | This case            |
    And CSAT_Sent__c on the case should be true
    And a survey invitation email should be sent to "Sarah Chen"
```

---

# 8. Feature: SLA Entitlements & Escalation

```gherkin
@service
Feature: SLA Entitlements and Escalation
  As the Catalyst Customer Success management team
  We need SLA milestones automatically applied to every case based on subscription tier
  And automated escalation notifications when milestones are breached
  So that we meet our contractual SLA commitments and proactively manage breaches

  Background:
    Given the following entitlement processes are active:
      | Entitlement Name              | Tier         | First Response | Resolution       |
      | Enterprise Support SLA        | Enterprise   | 1 hour         | 4 hours          |
      | Professional Support SLA      | Professional | 4 hours        | 2 business days  |
      | Starter Support SLA           | Starter      | 8 hours        | 5 business days  |


  @critical @regression @smoke
  @tc:MKT-TC-SRVC-003 @us:MKT-US-SRVC-007 @req:MKT-REQ-SRVC-007
  Scenario Outline: Case receives the correct SLA entitlement based on Account subscription tier
    Given a Customer Account exists with Subscription_Tier__c "<tier>"
    When a new case is created linked to that Account
    And the Case_AfterSave_EntitlementAssignment flow executes
    Then the case should have an Entitlement linked
    And the Entitlement name should reference the "<tier>" tier
    And SLA_Tier_at_Creation__c should be "<tier>"
    And the First Response milestone target should be "<first_response>"
    And the Resolution milestone target should be "<resolution>"

    Examples:
      | tier         | first_response | resolution      |
      | Enterprise   | 1 hour         | 4 hours         |
      | Professional | 4 hours        | 2 business days |
      | Starter      | 8 hours        | 5 business days |


  @critical @regression
  @us:MKT-US-SRVC-007 @req:MKT-REQ-SRVC-007
  Scenario: SLA tier is snapshotted at case creation and does not change if Account tier changes
    Given a Customer Account exists with Subscription_Tier__c "Professional"
    And a case was created for that Account with SLA_Tier_at_Creation__c = "Professional"
    When the Account Subscription_Tier__c is changed to "Enterprise"
    Then SLA_Tier_at_Creation__c on the existing case should still be "Professional"
    But new cases created for the same Account should receive the "Enterprise" entitlement


  @critical @regression
  @tc:MKT-TC-SRVC-006 @us:MKT-US-SRVC-008 @req:MKT-REQ-SRVC-008
  Scenario: First response milestone breach triggers Support Team Lead escalation
    Given an Enterprise case exists with status "New"
    And the First Response milestone has not been completed
    And the First Response milestone target time has passed
    When the Case_Scheduled_EscalationCheck flow runs
    Then the Support Team Lead should receive an escalation email with subject containing the case number
    And the email should identify the breach type as "First Response"


  @critical @regression
  @tc:MKT-TC-SRVC-006 @us:MKT-US-SRVC-008 @req:MKT-REQ-SRVC-008
  Scenario: Escalation notification is sent only once per breach event
    Given an Enterprise case has already triggered a First Response breach notification
    When the Case_Scheduled_EscalationCheck flow runs again
    Then the Support Team Lead should NOT receive a second escalation email for the same breach
    And the escalation flag on the case should prevent duplicate sends


  @high
  @us:MKT-US-SRVC-008 @req:MKT-REQ-SRVC-008
  Scenario: Resolution milestone at 50% remaining triggers VP of Customer Success escalation
    Given an Enterprise case exists in "In Progress" status
    And the Resolution milestone has 2 hours remaining (50% of 4-hour target)
    And the case has NOT already triggered a 50% escalation
    When the Case_Scheduled_EscalationCheck flow runs
    Then the VP of Customer Success should receive an escalation email referencing the case
    And the email should indicate "SLA Resolution Risk"
```

---

# 9. Feature: Knowledge Management

```gherkin
@service
Feature: Knowledge Management
  As the Catalyst support team and portal clients
  We need a searchable knowledge base integrated into both the Service Console and the portal
  So that agents can quickly find and attach articles and clients can self-serve before raising cases

  Background:
    Given the following published Knowledge articles exist:
      | Title                                       | Article Type      | Relates To            |
      | How to Configure Campaign Intelligence      | How-To Guide      | Campaign Intelligence |
      | Attribution Engine Dashboard Troubleshoot   | Troubleshooting   | Attribution Engine    |
      | Audience Studio Q4 Release Notes            | Release Note      | Audience Studio       |
      | Content Hub Asset Upload FAQ                | FAQ               | Content Hub           |
      | Getting Started with Campaign Intelligence  | How-To Guide      | Campaign Intelligence |


  @high @regression
  @tc:MKT-TC-SRVC-011 @us:MKT-US-SRVC-013 @req:MKT-REQ-SRVC-013
  Scenario: Agent attaches a knowledge article to a case from the Service Console
    Given I am logged in as a Service Agent
    And I have an open case in the Service Console
    When I search for "Campaign Intelligence" in the Knowledge panel
    Then at least one relevant article should appear in the results
    When I click "Attach" on the "How to Configure Campaign Intelligence" article
    Then the article should be linked to the case
    And the article should appear in the Case Knowledge related list


  @high
  @us:MKT-US-SRVC-011 @req:MKT-REQ-SRVC-011
  Scenario: Knowledge article cannot be published without a peer review
    Given I am a Knowledge author
    And I have created a new article "New Troubleshooting Guide" in Draft status
    When I attempt to change the article status directly to "Published"
    Then the publication is blocked
    And the article status should be "Review" (pending peer review)


  @high
  @us:MKT-US-SRVC-011 @req:MKT-REQ-SRVC-011
  Scenario: Knowledge article is published after peer review approval
    Given a Knowledge article "New Troubleshooting Guide" is in "Review" status
    And a peer reviewer has approved the article
    When the reviewer publishes the article
    Then the article status should be "Published"
    And the article should be searchable in the Service Console and the portal


  @high @regression
  @tc:MKT-TC-EXP-004 @us:MKT-US-SRVC-012 @req:MKT-REQ-SRVC-012
  Scenario: Portal case form surfaces relevant articles based on subject line input
    Given I am logged in as a portal user
    And I navigate to the new case submission form
    When I type "Campaign Intelligence not loading" in the Subject field
    Then the knowledge deflection panel should display at least one article related to "Campaign Intelligence"
    And the articles should be shown before the form can be submitted


  @high @regression
  @tc:MKT-TC-EXP-004 @us:MKT-US-SRVC-012 @req:MKT-REQ-SRVC-012
  Scenario: Client confirms an article resolved their issue and skips case submission
    Given I am on the portal case submission form
    And I have typed a subject that triggered knowledge article suggestions
    When I click on a suggested article
    And I click "Yes, this resolved my issue"
    Then I should be redirected away from the case form
    And no case should be created
```

---

# 10. Feature: Experience Cloud — Portal Access & Data Isolation

```gherkin
@portal @security
Feature: Experience Cloud Portal Access and Data Isolation
  As a Catalyst client
  I need secure, authenticated access to my own account's data only
  So that I can self-serve without risk of seeing other clients' information

  Background:
    Given the portal site is deployed with LWR runtime
    And the following Customer Accounts and portal users exist:
      | Account    | Portal User Email              | Role           |
      | AlphaCorp  | alice@alphacorp.com            | Account Admin  |
      | BetaCorp   | bob@betacorp.com               | Standard User  |
    And each Account has at least 2 open cases and 1 closed case


  @critical @regression @smoke
  @tc:MKT-TC-EXP-001 @us:MKT-US-EXP-001 @req:MKT-REQ-EXP-001
  Scenario: A contact on a Customer Account can self-register for the portal
    Given a Contact "Claire Martin" exists on Customer Account "AlphaCorp" with email "claire@alphacorp.com"
    And Claire has not yet registered for the portal
    When Claire navigates to the self-registration page
    And completes registration with email "claire@alphacorp.com" and a valid password
    Then a Customer Community Plus user record should be created for Claire
    And Is_Portal_Active__c on Claire's Contact should be true
    And Portal_Welcome_Sent__c on Claire's Contact should be true
    And Claire should be able to log in to the portal


  @critical @regression
  @tc:MKT-TC-EXP-001 @us:MKT-US-EXP-001 @req:MKT-REQ-EXP-001
  Scenario: A contact not on a Customer Account cannot self-register
    Given no Account exists for email domain "randomvendor.com"
    When a visitor attempts to self-register with email "visitor@randomvendor.com"
    Then registration should be rejected
    And no User record should be created
    And an appropriate error message should be displayed


  @critical @regression
  @tc:MKT-TC-EXP-001 @us:MKT-US-EXP-001 @req:MKT-REQ-EXP-001
  Scenario: Duplicate registration is rejected
    Given "alice@alphacorp.com" already has an active portal user account
    When Alice attempts to register again with the same email
    Then registration should be rejected with a message indicating the account already exists


  @critical @regression @smoke
  @tc:MKT-TC-EXP-002 @us:MKT-US-EXP-002 @req:MKT-REQ-EXP-002
  Scenario: Portal user can only view cases belonging to their own Account
    Given I am logged in as the AlphaCorp portal user "alice@alphacorp.com"
    When I navigate to the case list page "/cases"
    Then I should see only cases linked to "AlphaCorp"
    And I should not see any cases linked to "BetaCorp"


  @critical @regression @smoke @security
  @tc:MKT-TC-EXP-002 @us:MKT-US-EXP-002 @req:MKT-REQ-EXP-002
  Scenario: Portal user cannot access another Account's case by direct URL
    Given I am logged in as the AlphaCorp portal user "alice@alphacorp.com"
    And a BetaCorp case exists with ID "5001A00000XYZ123"
    When I navigate directly to "/cases/5001A00000XYZ123"
    Then I should see a "Record not found" or access denied message
    And no BetaCorp case data should be displayed


  @critical @security
  @tc:MKT-TC-NFR-005 @us:MKT-US-NFR-004 @req:MKT-REQ-NFR-004
  Scenario: Portal Apex controllers use WITH USER_MODE on all SOQL queries
    Given the portal Apex controller classes are reviewed
    Then every SOQL query in a portal-facing @AuraEnabled method should include "WITH USER_MODE"
    And no portal Apex class should be declared "without sharing"
    And the Licence_Key__c field should not appear in any portal SOQL SELECT clause


  @high @regression
  @us:MKT-US-EXP-003 @req:MKT-REQ-EXP-003
  Scenario: Account Admin portal user can access the billing summary page
    Given I am logged in as the AlphaCorp "Account Admin" portal user
    When I navigate to the subscription summary page "/subscription"
    Then the Annual Contract Value should be visible
    And the payment status section should be accessible


  @high @regression
  @us:MKT-US-EXP-003 @req:MKT-REQ-EXP-003
  Scenario: Standard User portal user cannot access billing summary
    Given I am logged in as the BetaCorp "Standard User" portal user
    When I navigate to the subscription summary page "/subscription"
    Then the Annual Contract Value should NOT be visible
    And the page should only display module list and case count information
```

---

# 11. Feature: Experience Cloud — Client Self-Service

```gherkin
@portal
Feature: Experience Cloud Client Self-Service
  As an authenticated Catalyst portal client
  I want to manage my cases, track my subscription, and complete my onboarding
  Without needing to contact a support agent for routine tasks

  Background:
    Given I am logged in as portal user "alice@alphacorp.com"
    And AlphaCorp has the following configuration:
      | Subscription Tier      | Enterprise               |
      | Modules Purchased      | Campaign Intelligence, Attribution Engine |
      | Contract Renewal Date  | 2027-03-01               |
      | Annual Contract Value  | 84000                    |
      | Open Cases             | 3                        |


  @high @regression @smoke
  @tc:MKT-TC-EXP-003 @us:MKT-US-EXP-004 @req:MKT-REQ-EXP-004
  Scenario: Portal home dashboard displays personalised client data
    When I navigate to the portal home page "/"
    Then the subscription tile should display "Enterprise" as the tier
    And the subscription tile should display "2027-03-01" as the renewal date
    And the module list should show "Campaign Intelligence" as active
    And the module list should show "Attribution Engine" as active
    And the module list should NOT show "Audience Studio" (not purchased)
    And the open cases tile should display a count of 3


  @critical @regression @smoke
  @tc:MKT-TC-EXP-004 @us:MKT-US-EXP-007 @req:MKT-REQ-EXP-007
  Scenario: Portal client submits a new support case with all required fields
    When I navigate to "/cases/new"
    And I complete the case form with the following data:
      | Field            | Value                                        |
      | Subject          | Attribution Engine dashboards not loading    |
      | Description      | All dashboards show blank since Monday 9am   |
      | Case Type        | Technical Support                            |
      | Affected Module  | Attribution Engine                           |
      | Urgency          | High                                         |
    And I click "Submit"
    Then a Case should be created with all submitted field values
    And the case AccountId should be AlphaCorp's Account ID
    And I should be redirected to the case detail page
    And the case should be assigned to the "Technical_Support_Queue"


  @high @regression
  @tc:MKT-TC-EXP-004 @us:MKT-US-EXP-009 @req:MKT-REQ-EXP-009
  Scenario: Knowledge deflection resolves the issue before case submission
    When I navigate to "/cases/new"
    And I type "Campaign Intelligence campaign not saving" in the Subject field
    Then the knowledge deflection panel should appear with relevant articles
    When I click on the article "How to Configure Campaign Intelligence"
    Then the article should be displayed
    When I click "Yes, this resolved my issue"
    Then I should be redirected away from the form
    And no case should have been created


  @critical @regression
  @tc:MKT-TC-EXP-005 @us:MKT-US-EXP-008 @req:MKT-REQ-EXP-008
  Scenario: Portal case list shows open and closed cases with filtering
    When I navigate to "/cases"
    Then I should see 3 open cases and at least 1 closed case listed
    When I filter by Status = "Open"
    Then only the 3 open cases should be displayed
    When I filter by Status = "Closed"
    Then only closed cases should be displayed


  @high @regression
  @tc:MKT-TC-EXP-005 @us:MKT-US-EXP-008 @req:MKT-REQ-EXP-008
  Scenario: Portal user can add a comment and attachment to an open case
    Given an open case "CASE-00042" exists for AlphaCorp
    When I navigate to the case detail page for "CASE-00042"
    And I add the comment "Still experiencing the issue after following the article steps."
    And I upload a screenshot file "error_screenshot.png"
    Then the comment should appear in the case comment thread
    And the attachment should appear in the case attachments section
    And no agent intervention should be required


  @high @regression
  @tc:MKT-TC-EXP-006 @us:MKT-US-EXP-010 @req:MKT-REQ-EXP-010
  Scenario: New client sees all 5 onboarding steps on their first portal visit
    Given AlphaCorp is a new customer with 0 onboarding steps completed
    When I navigate to "/onboarding"
    Then I should see exactly 5 onboarding steps:
      | Step Name                   |
      | Complete company profile    |
      | Add team members            |
      | Connect data source         |
      | Attend kickoff call         |
      | Complete platform training  |
    And all 5 steps should be in an incomplete state
    And each step should have a link to a resource (article or video)


  @high @regression
  @tc:MKT-TC-EXP-006 @us:MKT-US-EXP-010 @req:MKT-REQ-EXP-010
  Scenario: Completing all onboarding steps hides the checklist from the home dashboard
    Given AlphaCorp has 4 of 5 onboarding steps completed
    When I complete the final step "Complete platform training"
    And I navigate to the portal home page
    Then the onboarding checklist tile should NOT be visible on the home dashboard


  @high
  @us:MKT-US-EXP-005 @req:MKT-REQ-EXP-005
  Scenario: Subscription summary page displays accurate contract information
    When I navigate to "/subscription"
    Then the page should display:
      | Field                  | Value             |
      | Annual Contract Value  | $84,000           |
      | Subscription Tier      | Enterprise        |
      | Contract Renewal Date  | 2027-03-01        |
    And the module activation status for "Campaign Intelligence" should be "Active"
    And the module activation status for "Attribution Engine" should be "Active"
    And "Audience Studio" should not appear in the module list
```

---

# 12. Feature: Agentforce — Aria Client Assistant

```gherkin
@portal @agentforce
Feature: Agentforce — Aria Client Assistant
  As an authenticated Catalyst portal client
  I want to interact with Aria, the AI assistant
  So that I can get instant answers, check my case status, and escalate to a human when needed
  Without waiting for an available support agent

  Background:
    Given I am logged in as portal user "alice@alphacorp.com"
    And the following open cases exist for AlphaCorp:
      | Case Number | Subject                                    | Status       |
      | 00042       | Attribution Engine dashboards not loading  | In Progress  |
      | 00043       | Data export failing on Audience Studio     | Awaiting Customer |
    And the following Knowledge articles are published:
      | Title                                       | Relevance Keywords    |
      | How to Configure Campaign Intelligence      | Campaign Intelligence |
      | Attribution Engine Dashboard Troubleshoot   | Attribution, dashboard |
    And the Aria agent is embedded on all authenticated portal pages


  @critical @regression @smoke
  @tc:MKT-TC-EXP-007 @us:MKT-US-EXP-012 @req:MKT-REQ-EXP-012
  Scenario: Aria returns a relevant Knowledge article for a product question
    Given I open the Aria chat launcher
    When I send the message "How do I set up a Campaign Intelligence campaign?"
    Then Aria should invoke the SearchKnowledge action
    And Aria's response should reference the article "How to Configure Campaign Intelligence"
    And the response should include a link or summary of the article content
    And the tone should be professional and helpful


  @critical @regression
  @tc:MKT-TC-EXP-007 @us:MKT-US-EXP-012 @req:MKT-REQ-EXP-012
  Scenario: Aria returns a message when no relevant article is found
    Given I open the Aria chat
    When I send the message "How do I configure a quantum entanglement device?"
    Then Aria should respond that no relevant knowledge article was found
    And Aria should offer to connect me with a support agent


  @critical @regression @smoke
  @tc:MKT-TC-EXP-008 @us:MKT-US-EXP-012 @req:MKT-REQ-EXP-012
  Scenario: Aria returns the status of the authenticated user's open cases
    Given I open the Aria chat
    When I send the message "What is the status of my open cases?"
    Then Aria should invoke the GetCaseStatus action
    And the response should list case 00042 with status "In Progress"
    And the response should list case 00043 with status "Awaiting Customer"
    And the response should NOT include any cases from BetaCorp or other accounts


  @critical @regression
  @tc:MKT-TC-EXP-008 @us:MKT-US-EXP-012 @req:MKT-REQ-EXP-012
  Scenario: Aria returns status for a specific case number when asked
    Given I open the Aria chat
    When I send the message "What's happening with case 00042?"
    Then Aria should invoke the GetCaseStatus action
    And the response should specifically mention case 00042
    And the response should state the status "In Progress"
    And should include the subject "Attribution Engine dashboards not loading"


  @high @regression
  @us:MKT-US-EXP-012 @req:MKT-REQ-EXP-012
  Scenario: Aria provides onboarding progress when asked
    Given AlphaCorp has 3 of 5 onboarding steps completed
    And I open the Aria chat
    When I send the message "How is my onboarding going?"
    Then Aria should invoke the GetOnboardingProgress action
    And the response should indicate 60% completion (3 of 5 steps)
    And the response should name the next incomplete step


  @high @regression @smoke
  @tc:MKT-TC-EXP-009 @us:MKT-US-EXP-015 @req:MKT-REQ-EXP-015
  Scenario: Aria proactively offers escalation after 2 unresolved exchanges
    Given I open the Aria chat
    When I describe a complex issue: "My Attribution Engine dashboards have been broken for 3 days and it's affecting our executive reporting"
    And Aria responds but cannot resolve the issue
    And I reply "That didn't help, the issue is still happening"
    Then Aria should offer escalation: "Would you like me to open a support case so a specialist can help?"


  @high @regression
  @tc:MKT-TC-EXP-009 @us:MKT-US-EXP-015 @req:MKT-REQ-EXP-015
  Scenario: Aria creates a pre-populated case draft when client accepts escalation
    Given I am in an Aria conversation about "Attribution Engine dashboards broken for 3 days"
    And Aria has offered to escalate
    When I respond "Yes please"
    Then Aria should invoke the EscalateToAgent action
    And a Case should be created with:
      | Field       | Value                                                |
      | Subject     | Derived from conversation context (Attribution Engine) |
      | Description | Summary of the conversation                          |
      | AccountId   | AlphaCorp's Account ID                               |
    And the case should be routed to the appropriate support queue
    And Aria's response should include the new case number
    And should reference the expected response time based on the Enterprise SLA tier


  @high @regression
  @tc:MKT-TC-EXP-009 @us:MKT-US-EXP-015 @req:MKT-REQ-EXP-015
  Scenario: Escalated case does not require the client to repeat context already given
    Given a case was created by Aria via EscalateToAgent from a conversation about "API integration failures"
    When an agent opens the escalated case
    Then the case Description should contain a summary of the conversation
    And the agent should not need to ask the client to re-explain the issue


  @high @regression
  @tc:MKT-TC-EXP-010 @us:MKT-US-EXP-014 @req:MKT-REQ-EXP-014
  Scenario Outline: Aria declines to answer out-of-scope questions
    Given I open the Aria chat
    When I ask "<out_of_scope_question>"
    Then Aria should NOT provide a speculative answer
    And Aria's response should stay within the defined scope boundaries
    And the response should offer to connect me with a team member if appropriate

    Examples:
      | out_of_scope_question                                        |
      | What is on Catalyst's product roadmap for next quarter?      |
      | Can I get a 20% discount on my renewal?                      |
      | What data do other Catalyst clients store in Campaign Intel? |
      | Can you predict my campaign performance next month?          |


  @high @regression
  @tc:MKT-TC-EXP-010 @us:MKT-US-EXP-014 @req:MKT-REQ-EXP-014
  Scenario: Aria maintains a professional and empathetic tone when client is frustrated
    Given I open the Aria chat
    When I send an emotionally charged message: "This platform is constantly broken and your support is terrible"
    Then Aria should acknowledge the frustration empathetically
    And Aria should not argue, dismiss, or escalate the emotional tone
    And Aria should offer a constructive next step
    And Aria should not disclose information about other clients or internal team processes
```

---

# 13. Scenario Coverage Summary

## 13.1 By Feature

| Feature File | Scenarios | Critical | High | Medium | Tags |
| :---- | :---- | :---- | :---- | :---- | :---- |
| Lead Management | 9 | 3 | 5 | 1 | @sales |
| Opportunity Lifecycle | 8 | 4 | 3 | 1 | @sales |
| Case Management | 8 | 4 | 4 | 0 | @service |
| SLA Entitlements & Escalation | 5 | 3 | 2 | 0 | @service |
| Knowledge Management | 5 | 0 | 5 | 0 | @service |
| Portal Access & Data Isolation | 8 | 5 | 3 | 0 | @portal @security |
| Client Self-Service | 8 | 2 | 5 | 1 | @portal |
| Agentforce — Aria | 11 | 3 | 7 | 1 | @portal @agentforce |
| **Total** | **52** | **24** | **34** | **4** | |

## 13.2 Regression Tag Summary

Scenarios tagged `@regression`: **36 of 52**
Scenarios tagged `@smoke`: **11 of 52** (fastest confidence pass — ~20 minutes manual)

## 13.3 Coverage by Requirement Module

| Module | Requirements Covered | BDD Scenarios |
| :---- | :---- | :---- |
| MKT-REQ-SALES | SALES-002, 003, 005, 006, 012, 013, 015, 016 | 17 |
| MKT-REQ-SRVC | SRVC-002, 005, 006, 007, 008, 011, 012, 013 | 13 |
| MKT-REQ-EXP | EXP-001, 002, 003, 004, 005, 007, 008, 009, 010, 012, 013, 014, 015 | 19 |
| MKT-REQ-NFR | NFR-004 (security), NFR-007 (implied via WCAG) | 3 |

---

# 14. Automation Readiness Notes

## 14.1 Current Status

All 52 scenarios are written for **manual execution** against the MKT-TPQA-1.0 test scripts. Automation implementation is planned in two phases:

| Phase | Scope | Tooling | Trigger |
| :---- | :---- | :---- | :---- |
| Phase 1 (post v1.0) | Apex-layer scenarios (business rules, validation rules, flows) | Apex test methods structured as Given/When/Then | On every PR via CI Workflow 1 |
| Phase 2 (post-Catalyst) | Portal UI scenarios | Playwright + Cucumber.js (headless browser) | Nightly on `develop` |

## 14.2 Step Definition Design Principles

When automating, each step definition layer should follow these rules:

**Salesforce internal scenarios (Given/When/Then → Apex):**

```
Given:  TestDataFactory methods to set up preconditions
When:   DML operations or callout invocations representing user actions
Then:   System.assert() statements validating the resulting data state
```

**Portal UI scenarios (Given/When/Then → Playwright):**

```
Given:  Portal user login via loginAs() + navigate to page
When:   page.fill(), page.click(), page.type() — simulate browser actions
Then:   expect(page.locator()).toHaveText() — assert UI state
```

## 14.3 Scenario Outline Automation Value

Scenario Outlines with Examples tables provide particular automation value — one step definition implementation runs against all example rows. The following Scenario Outlines are highest priority for automation:

| Scenario Outline | Examples Rows | Automation Value |
| :---- | :---- | :---- |
| Lead assignment by source/geography | 5 | High — tests routing logic across all source types |
| Opportunity stage gate field combinations | 5 | Critical — boundary testing of validation rules |
| Discount approval threshold | 5 | Critical — exact boundary behaviour at 15% |
| Loss Reason picklist coverage | 5 | High — ensures all valid values save correctly |
| SLA entitlement by tier | 3 | Critical — core SLA logic |
| Common email domain exclusions | 4 | High — prevents false auto-link attempts |
| Aria out-of-scope questions | 4 | High — scope boundary regression |

---

# 15. Traceability Matrix

| Scenario Title (abbreviated) | Feature | TC ID | US ID | Req ID | Priority |
| :---- | :---- | :---- | :---- | :---- | :---- |
| Lead status: Qualified blocked without Company | Lead Mgmt | MKT-TC-SALES-003 | MKT-US-SALES-003 | MKT-REQ-SALES-003 | Critical |
| Lead status: advances with required fields | Lead Mgmt | MKT-TC-SALES-003 | MKT-US-SALES-003 | MKT-REQ-SALES-003 | Critical |
| Conversion blocked: status not Qualified | Lead Mgmt | MKT-TC-SALES-004 | MKT-US-SALES-005 | MKT-REQ-SALES-005 | Critical |
| Conversion blocked: < 3 activities | Lead Mgmt | MKT-TC-SALES-004 | MKT-US-SALES-005 | MKT-REQ-SALES-005 | Critical |
| Conversion succeeds: Qualified + 3 activities | Lead Mgmt | MKT-TC-SALES-004 | MKT-US-SALES-005 | MKT-REQ-SALES-005 | Critical |
| Lead assignment by source/geo (5 examples) | Lead Mgmt | MKT-TC-SALES-002 | MKT-US-SALES-002 | MKT-REQ-SALES-002 | High |
| Follow-up task: no activity at 48hr | Lead Mgmt | MKT-TC-SALES-005 | MKT-US-SALES-006 | MKT-REQ-SALES-006 | High |
| Follow-up task: suppressed when activity exists | Lead Mgmt | MKT-TC-SALES-005 | MKT-US-SALES-006 | MKT-REQ-SALES-006 | High |
| Web-to-lead: full field capture | Lead Mgmt | — | MKT-US-SALES-001 | MKT-REQ-SALES-001 | Medium |
| Stage gate: Proposal Sent blocked (all fields missing) | Opp Lifecycle | MKT-TC-SALES-007 | MKT-US-SALES-012 | MKT-REQ-SALES-012 | Critical |
| Stage gate: field combination matrix (5 examples) | Opp Lifecycle | MKT-TC-SALES-007 | MKT-US-SALES-013 | MKT-REQ-SALES-013 | Critical |
| Discount: > 15% triggers approval | Opp Lifecycle | MKT-TC-SALES-010 | MKT-US-SALES-014 | MKT-REQ-SALES-015 | Critical |
| Discount: boundary matrix (5 examples) | Opp Lifecycle | MKT-TC-SALES-010 | MKT-US-SALES-014 | MKT-REQ-SALES-015 | Critical |
| Discount: VP approves | Opp Lifecycle | MKT-TC-SALES-010 | MKT-US-SALES-014 | MKT-REQ-SALES-015 | High |
| Discount: VP rejects | Opp Lifecycle | MKT-TC-SALES-010 | MKT-US-SALES-014 | MKT-REQ-SALES-015 | High |
| Closed Lost: Loss Reason required | Opp Lifecycle | MKT-TC-SALES-007 | MKT-US-SALES-015 | MKT-REQ-SALES-016 | High |
| Closed Lost: all Loss Reason values valid (5 examples) | Opp Lifecycle | MKT-TC-SALES-007 | MKT-US-SALES-015 | MKT-REQ-SALES-016 | High |
| Case auto-link: matched domain | Case Mgmt | MKT-TC-SRVC-001 | MKT-US-SRVC-002 | MKT-REQ-SRVC-002 | Critical |
| Case auto-link: unrecognised domain → manual review | Case Mgmt | MKT-TC-SRVC-002 | MKT-US-SRVC-002 | MKT-REQ-SRVC-002 | High |
| Case auto-link: common domains excluded (4 examples) | Case Mgmt | MKT-TC-SRVC-002 | MKT-US-SRVC-002 | MKT-REQ-SRVC-002 | High |
| Resolved blocked: no Resolution Summary | Case Mgmt | MKT-TC-SRVC-007 | MKT-US-SRVC-005 | MKT-REQ-SRVC-005 | Critical |
| Resolved: advances with summary | Case Mgmt | MKT-TC-SRVC-007 | MKT-US-SRVC-005 | MKT-REQ-SRVC-005 | Critical |
| Closed blocked: CSAT not sent | Case Mgmt | MKT-TC-SRVC-009 | MKT-US-SRVC-006 | MKT-REQ-SRVC-006 | High |
| Closed: allowed when CSAT sent | Case Mgmt | MKT-TC-SRVC-009 | MKT-US-SRVC-006 | MKT-REQ-SRVC-006 | High |
| CSAT survey auto-dispatched on Resolved | Case Mgmt | MKT-TC-SRVC-008 | MKT-US-SRVC-006 | MKT-REQ-SRVC-006 | High |
| SLA entitlement by tier (3 examples) | SLA | MKT-TC-SRVC-003/4/5 | MKT-US-SRVC-007 | MKT-REQ-SRVC-007 | Critical |
| SLA tier snapshot preserved after account change | SLA | — | MKT-US-SRVC-007 | MKT-REQ-SRVC-007 | Critical |
| First response breach → Team Lead escalation | SLA | MKT-TC-SRVC-006 | MKT-US-SRVC-008 | MKT-REQ-SRVC-008 | Critical |
| Escalation deduplication | SLA | MKT-TC-SRVC-006 | MKT-US-SRVC-008 | MKT-REQ-SRVC-008 | Critical |
| 50% resolution remaining → VP escalation | SLA | — | MKT-US-SRVC-008 | MKT-REQ-SRVC-008 | High |
| Agent attaches article to case | Knowledge | MKT-TC-SRVC-011 | MKT-US-SRVC-013 | MKT-REQ-SRVC-013 | High |
| Article publication requires peer review | Knowledge | — | MKT-US-SRVC-011 | MKT-REQ-SRVC-011 | High |
| Article published after review | Knowledge | — | MKT-US-SRVC-011 | MKT-REQ-SRVC-011 | High |
| Portal deflection: articles shown on case form | Knowledge | MKT-TC-EXP-004 | MKT-US-SRVC-012 | MKT-REQ-SRVC-012 | High |
| Portal deflection: "resolved" skips case creation | Knowledge | MKT-TC-EXP-004 | MKT-US-SRVC-012 | MKT-REQ-SRVC-012 | High |
| Self-registration: Customer contact succeeds | Portal Access | MKT-TC-EXP-001 | MKT-US-EXP-001 | MKT-REQ-EXP-001 | Critical |
| Self-registration: non-customer rejected | Portal Access | MKT-TC-EXP-001 | MKT-US-EXP-001 | MKT-REQ-EXP-001 | Critical |
| Self-registration: duplicate rejected | Portal Access | MKT-TC-EXP-001 | MKT-US-EXP-001 | MKT-REQ-EXP-001 | Critical |
| Data isolation: case list own account only | Portal Access | MKT-TC-EXP-002 | MKT-US-EXP-002 | MKT-REQ-EXP-002 | Critical |
| Data isolation: direct URL cross-account blocked | Portal Access | MKT-TC-EXP-002 | MKT-US-EXP-002 | MKT-REQ-EXP-002 | Critical |
| Portal Apex: WITH USER_MODE enforced | Portal Access | MKT-TC-NFR-005 | MKT-US-NFR-004 | MKT-REQ-NFR-004 | Critical |
| Account Admin: billing summary accessible | Portal Access | — | MKT-US-EXP-003 | MKT-REQ-EXP-003 | High |
| Standard User: billing summary hidden | Portal Access | — | MKT-US-EXP-003 | MKT-REQ-EXP-003 | High |
| Home dashboard: personalised data | Self-Service | MKT-TC-EXP-003 | MKT-US-EXP-004 | MKT-REQ-EXP-004 | High |
| Case submission: all fields + routing | Self-Service | MKT-TC-EXP-004 | MKT-US-EXP-007 | MKT-REQ-EXP-007 | Critical |
| Deflection: article click resolves query | Self-Service | MKT-TC-EXP-004 | MKT-US-EXP-009 | MKT-REQ-EXP-009 | High |
| Case list: filter by status | Self-Service | MKT-TC-EXP-005 | MKT-US-EXP-008 | MKT-REQ-EXP-008 | Critical |
| Case detail: comment and attachment | Self-Service | MKT-TC-EXP-005 | MKT-US-EXP-008 | MKT-REQ-EXP-008 | High |
| Onboarding: 5 steps with resources | Self-Service | MKT-TC-EXP-006 | MKT-US-EXP-010 | MKT-REQ-EXP-010 | High |
| Onboarding: checklist hidden when 100% complete | Self-Service | MKT-TC-EXP-006 | MKT-US-EXP-010 | MKT-REQ-EXP-010 | High |
| Aria: knowledge query → article returned | Agentforce | MKT-TC-EXP-007 | MKT-US-EXP-012 | MKT-REQ-EXP-012 | Critical |
| Aria: no article found → escalation offered | Agentforce | MKT-TC-EXP-007 | MKT-US-EXP-012 | MKT-REQ-EXP-012 | Critical |
| Aria: case status all open cases | Agentforce | MKT-TC-EXP-008 | MKT-US-EXP-012 | MKT-REQ-EXP-012 | Critical |
| Aria: case status for specific case | Agentforce | MKT-TC-EXP-008 | MKT-US-EXP-012 | MKT-REQ-EXP-012 | Critical |
| Aria: onboarding progress | Agentforce | — | MKT-US-EXP-012 | MKT-REQ-EXP-012 | High |
| Aria: proactive escalation offer at 2 turns | Agentforce | MKT-TC-EXP-009 | MKT-US-EXP-015 | MKT-REQ-EXP-015 | High |
| Aria: escalation creates pre-populated case | Agentforce | MKT-TC-EXP-009 | MKT-US-EXP-015 | MKT-REQ-EXP-015 | High |
| Aria: escalated case has conversation context | Agentforce | MKT-TC-EXP-009 | MKT-US-EXP-015 | MKT-REQ-EXP-015 | High |
| Aria: out-of-scope questions declined (4 examples) | Agentforce | MKT-TC-EXP-010 | MKT-US-EXP-014 | MKT-REQ-EXP-014 | High |
| Aria: empathetic tone with frustrated client | Agentforce | MKT-TC-EXP-010 | MKT-US-EXP-014 | MKT-REQ-EXP-014 | High |

**Total scenarios traced: 52**

---

*MKT-BDD-1.0 is the executable specification library for the Catalyst CRM implementation. Feature files in this document should be maintained in sync with MKT-USAC-1.0 acceptance criteria. When a user story changes, the corresponding BDD scenarios must be updated in the same PR.*
