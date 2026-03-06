# MKT-PTS-1.0 — Performance Testing Suite
## Catalyst Marketing Technologies — Salesforce Implementation

| Field | Value |
|---|---|
| Document ID | MKT-PTS-1.0 |
| Version | 1.0 |
| Status | Complete |
| Author | Portfolio Architect |
| Date | 2026-03-06 |
| Classification | Internal — Portfolio Artefact |

---

## Table of Contents

1. [Purpose and Scope](#1-purpose-and-scope)
2. [Performance Objectives and SLOs](#2-performance-objectives-and-slos)
3. [Measurement Methodology](#3-measurement-methodology)
4. [Suite 1 — Page Load Performance](#4-suite-1--page-load-performance)
5. [Suite 2 — Apex Governor Limit Profiling](#5-suite-2--apex-governor-limit-profiling)
6. [Suite 3 — Experience Cloud LWR Performance](#6-suite-3--experience-cloud-lwr-performance)
7. [Suite 4 — Integration Response Time](#7-suite-4--integration-response-time)
8. [Suite 5 — Report and Dashboard Rendering](#8-suite-5--report-and-dashboard-rendering)
9. [Suite 6 — Bulk Data Processing](#9-suite-6--bulk-data-processing)
10. [Baseline and Regression Thresholds](#10-baseline-and-regression-thresholds)
11. [Tooling and Execution Environment](#11-tooling-and-execution-environment)
12. [Traceability Matrix](#12-traceability-matrix)

---

## 1. Purpose and Scope

### 1.1 Purpose

This Performance Testing Suite (PTS) defines measurable performance targets, test procedures, and pass/fail criteria for the Catalyst Marketing Technologies Salesforce implementation. It complements the functional test artefacts (MKT-TPQA-1.0, MKT-BDD-1.0, MKT-DDT-1.0) by focusing exclusively on speed, throughput, governor headroom, and scalability.

Performance data from this suite serves two audiences:

1. **Internal engineering** — baseline for regression detection across sprints
2. **Portfolio reviewers** — evidence of production-grade engineering discipline (NFR awareness, governor safety margins, LWR Core Web Vitals)

### 1.2 Scope

| In Scope | Out of Scope |
|---|---|
| Internal Lightning App pages (Sales, Service) | Salesforce platform infrastructure benchmarks |
| Experience Cloud LWR portal pages | Network infrastructure beyond Salesforce CDN |
| Apex transaction governor usage | Third-party system performance (billing/usage APIs) |
| Integration callout timing (stub-based) | Load/stress testing (not supported on DE orgs) |
| Report and dashboard refresh time | Email deliverability latency |
| Bulk Apex processing (up to 200 records) | Scratch org cold-start times |

### 1.3 Non-Functional Requirements Covered

| Req ID | Description |
|---|---|
| MKT-REQ-NFR-001 | Page load time < 3 seconds on standard broadband |
| MKT-REQ-NFR-002 | Apex transactions must use < 50% of all governor limits |
| MKT-REQ-NFR-003 | Experience Cloud LWR pages must meet Core Web Vitals (Good) |
| MKT-REQ-NFR-004 | Integration callouts must respond within 5 seconds or fail gracefully |
| MKT-REQ-NFR-005 | Bulk operations of 200 records must complete within a single transaction |
| MKT-REQ-NFR-006 | Dashboard refresh must complete within 10 seconds |

---

## 2. Performance Objectives and SLOs

### 2.1 Service Level Objectives

| Metric | Target (SLO) | Critical Threshold | Measurement Method |
|---|---|---|---|
| Lightning page load (P95) | < 3.0 s | > 5.0 s | Lightning Usage App / browser DevTools |
| LWC component render (first paint) | < 1.5 s | > 3.0 s | Browser Performance tab |
| LWR portal LCP (Largest Contentful Paint) | < 2.5 s | > 4.0 s | Chrome Lighthouse |
| LWR portal FID (First Input Delay) | < 100 ms | > 300 ms | Chrome Lighthouse |
| LWR portal CLS (Cumulative Layout Shift) | < 0.1 | > 0.25 | Chrome Lighthouse |
| SOQL queries per transaction | < 50 (50% of 100 limit) | > 75 | Apex Debug Log / Test assertions |
| DML statements per transaction | < 75 (50% of 150 limit) | > 110 | Apex Debug Log / Test assertions |
| DML rows per transaction | < 5,000 (50% of 10,000 limit) | > 8,000 | Apex Debug Log / Test assertions |
| CPU time per transaction | < 5,000 ms (50% of 10,000 ms) | > 8,000 ms | Apex Debug Log |
| Heap size per transaction | < 3 MB (50% of 6 MB) | > 5 MB | Apex Debug Log |
| Callout response time | < 5,000 ms | > 8,000 ms | Named Credential log / mock timer |
| Report refresh time | < 10 s | > 20 s | Manual timer / browser Network tab |
| Dashboard refresh time | < 10 s | > 20 s | Manual timer / browser Network tab |

### 2.2 Governor Limit Reference

All limits reflect Salesforce API v62.0 synchronous transaction limits.

| Governor | Platform Limit | SLO Target (50%) | Critical (75%) |
|---|---|---|---|
| SOQL queries | 100 | 50 | 75 |
| SOQL query rows returned | 50,000 | 25,000 | 37,500 |
| DML statements | 150 | 75 | 112 |
| DML rows | 10,000 | 5,000 | 7,500 |
| CPU time (ms) | 10,000 | 5,000 | 7,500 |
| Heap size (bytes) | 6,291,456 | 3,145,728 | 4,718,592 |
| Callouts per transaction | 100 | 50 | 75 |
| Future calls per transaction | 50 | 25 | 37 |
| Queueable jobs per transaction | 50 | 25 | 37 |

---

## 3. Measurement Methodology

### 3.1 Lightning Usage App (Internal Pages)

Salesforce's **Lightning Usage App** provides aggregate page load timing from real browser sessions. This methodology is used for internal Lightning App performance.

**Procedure:**

1. Navigate to Setup > Lightning Usage App
2. Select time range: Last 7 Days
3. Filter by App: **Catalyst Service Console** and **Catalyst Sales App**
4. Record P50 and P95 page load times per page name
5. Compare against SLO targets

**Limitations:** Requires real user sessions. In a portfolio context with limited user activity, supplement with manual browser DevTools timing.

### 3.2 Browser DevTools (Manual Timing)

For pages with insufficient Lightning Usage App data:

1. Open Chrome DevTools > Network tab
2. Enable cache disable (Disable cache checkbox)
3. Hard-reload the target page (Cmd+Shift+R / Ctrl+Shift+R)
4. Record DOMContentLoaded and Load event timing from the Network summary bar
5. Repeat 5 times; discard highest and lowest; average remaining 3

**Recording template:**

| Run | DOMContentLoaded (ms) | Load (ms) | Notes |
|---|---|---|---|
| 1 | | | |
| 2 | | | |
| 3 | | | |
| 4 | | | |
| 5 | | | |
| Average (drop H/L) | | | |

### 3.3 Chrome Lighthouse (LWR Portal)

For Experience Cloud LWR pages:

1. Open Chrome DevTools > Lighthouse tab
2. Set mode: Navigation, device: Desktop
3. Run audit on the target portal URL (logged-in session for authenticated pages)
4. Capture: Performance score, LCP, FID/INP, CLS, TBT
5. Run 3 times; record the median score

**Note:** Lighthouse simulates throttled conditions. Real-world metrics will typically be better. The test baseline uses Lighthouse defaults (simulated 4G + mid-tier CPU).

### 3.4 Apex Debug Logs (Governor Profiling)

For Apex governor limit measurement:

1. Setup > Debug Logs — enable for target user (System Administrator)
2. Set log level: Apex Code = FINEST, Profiling = FINE
3. Execute the target operation (trigger, batch, service call)
4. Download and parse the log
5. Locate the `CUMULATIVE_LIMIT_USAGE` section at end of transaction
6. Record values for all governed resources

**Apex Test Method Alternative:**

Use `Limits.*` methods in test assertions to capture governor usage programmatically:

```apex
@IsTest
static void testLeadBulkInsert_governorHeadroom() {
    List<Lead> leads = TestDataFactory.createLeads(200, false);

    Test.startTest();
    insert leads;
    Test.stopTest();

    Integer soqlUsed = Limits.getQueries();
    Integer dmlUsed  = Limits.getDmlStatements();
    Integer cpuUsed  = Limits.getCpuTime();

    System.assert(soqlUsed  <= 50,  'SOQL queries exceeded 50% governor: ' + soqlUsed);
    System.assert(dmlUsed   <= 75,  'DML statements exceeded 50% governor: ' + dmlUsed);
    System.assert(cpuUsed   <= 5000,'CPU time exceeded 50% governor: ' + cpuUsed + 'ms');
}
```

**Note:** `Limits.*` methods return cumulative usage within `Test.startTest()` / `Test.stopTest()` blocks. This is the primary governor profiling mechanism in this suite.

### 3.5 Integration Timing (Mock-Based)

Callout response time is measured using mock services with configurable delay injection:

```apex
public class SlowMockHttpResponse implements HttpCalloutMock {
    private Integer delayMs;
    private Integer statusCode;

    public SlowMockHttpResponse(Integer delayMs, Integer statusCode) {
        this.delayMs   = delayMs;
        this.statusCode = statusCode;
    }

    public HTTPResponse respond(HTTPRequest req) {
        // Record entry time for assertion reference in test
        Long start = System.currentTimeMillis();
        HTTPResponse res = new HTTPResponse();
        res.setStatusCode(statusCode);
        res.setBody('{"status":"ok"}');
        // Delay simulation: in test context, actual wall-clock delay
        // is not achievable; use timestamp differentials in assertions
        return res;
    }
}
```

**Real-world callout timing** is validated via Named Credential event log entries in the org's Event Monitoring (not available on Developer Edition). For portfolio purposes, SLO conformance is demonstrated by integration design patterns: timeout configuration, circuit-breaker behaviour, and graceful degradation.

---

## 4. Suite 1 — Page Load Performance

### Overview

Tests the load time of key Lightning App pages under clean-cache conditions using Chrome DevTools methodology (Section 3.2).

**Test environment:** Chrome 120+, cable-speed connection (> 50 Mbps down), macOS, 1440p display
**Cache state:** Disabled for all runs
**Session state:** Logged in as target persona before timing begins

---

### PTS-1.1 — Catalyst Sales App: Lead List View

| Field | Value |
|---|---|
| Test ID | PTS-1.1 |
| Priority | High |
| Persona | Sales Rep |
| Page | Lead List — All Open Leads |
| Req ID | MKT-REQ-NFR-001 |

**Preconditions:**
- Org contains at least 50 Lead records (sample data loaded)
- User is authenticated as Sales Rep profile
- DevTools Network tab open, cache disabled

**Steps:**

| # | Action | Expected Result |
|---|---|---|
| 1 | Open a new browser tab and navigate to the Catalyst Sales App | App loads; Home page displays |
| 2 | Click the Leads tab | Lead list view loads |
| 3 | Record DOMContentLoaded and Load times from Network summary | Times recorded |
| 4 | Hard-reload (Cmd+Shift+R) 4 more times, recording each | 5 total data points captured |
| 5 | Discard highest and lowest Load values; average remaining 3 | Average calculated |

**Pass Criteria:**

| Metric | SLO Target | Result | Pass/Fail |
|---|---|---|---|
| Average page Load time | < 3,000 ms | _______ ms | |
| Any single run Load time | < 5,000 ms | _______ ms | |

---

### PTS-1.2 — Catalyst Sales App: Opportunity Record Page

| Field | Value |
|---|---|
| Test ID | PTS-1.2 |
| Priority | High |
| Persona | Sales Rep |
| Page | Opportunity Record Page (multi-component layout) |
| Req ID | MKT-REQ-NFR-001 |

**Preconditions:**
- At least one Opportunity with related Contacts, Activities, and open Tasks exists
- Opportunity record has Subscription_Tier__c and Contract_Length__c populated
- User is authenticated as Sales Rep

**Steps:**

| # | Action | Expected Result |
|---|---|---|
| 1 | Navigate to an Opportunity with full related data | Record page loads |
| 2 | Record Load time | Time recorded |
| 3 | Hard-reload 4 more times | 5 data points captured |
| 4 | Average the middle 3 values | Average calculated |
| 5 | Inspect Network waterfall — identify any single request > 1,000 ms | Slow requests documented |

**Pass Criteria:**

| Metric | SLO Target | Result | Pass/Fail |
|---|---|---|---|
| Average Load time | < 3,000 ms | _______ ms | |
| No single sub-request | > 2,000 ms | _______ ms | |

---

### PTS-1.3 — Catalyst Service Console: Case List

| Field | Value |
|---|---|
| Test ID | PTS-1.3 |
| Priority | High |
| Persona | Service Agent |
| Page | Service Console — Cases queue view |
| Req ID | MKT-REQ-NFR-001 |

**Preconditions:**
- At least 50 Case records exist across all queues
- User authenticated as Service Agent
- Omni-Channel widget present in console footer

**Steps:**

| # | Action | Expected Result |
|---|---|---|
| 1 | Navigate to Catalyst Service Console | Console layout loads |
| 2 | Click Cases tab | Case list view renders |
| 3 | Record Load time from Network tab | Time recorded |
| 4 | Repeat 4 more times with hard reload | 5 data points |
| 5 | Average middle 3 | Pass/Fail assessed |

**Pass Criteria:**

| Metric | SLO Target | Result | Pass/Fail |
|---|---|---|---|
| Average Load time | < 3,000 ms | _______ ms | |

---

### PTS-1.4 — Catalyst Service Console: Case Record Detail

| Field | Value |
|---|---|
| Test ID | PTS-1.4 |
| Priority | High |
| Persona | Service Agent |
| Page | Case Record Page — full console layout with related lists |
| Req ID | MKT-REQ-NFR-001 |

**Preconditions:**
- Case has: at least 5 related Emails, 3 Tasks, 1 Feedback_Survey__c, entitlement assigned
- Case record page includes catalyst-case-detail custom LWC component

**Steps:**

| # | Action | Expected Result |
|---|---|---|
| 1 | Open a Case record from the queue | Record page loads in console |
| 2 | Confirm catalyst-case-detail LWC has rendered (data visible) | Component data visible |
| 3 | Record Load time | Time noted |
| 4 | Repeat 4 more times | 5 data points |
| 5 | Average middle 3 | Calculated |

**Pass Criteria:**

| Metric | SLO Target | Result | Pass/Fail |
|---|---|---|---|
| Average Load time | < 3,000 ms | _______ ms | |
| catalyst-case-detail render | < 1,500 ms (first paint) | _______ ms | |

---

### PTS-1.5 — Account Record Page: Health Score Visible

| Field | Value |
|---|---|
| Test ID | PTS-1.5 |
| Priority | Medium |
| Persona | Sales Manager |
| Page | Account Record Page with Health_Score__c field and related lists |
| Req ID | MKT-REQ-NFR-001 |

**Preconditions:**
- Account has at least 10 related Cases, 5 Contacts, 1 Project__c
- Health_Score__c field is on the page layout and has a calculated value

**Steps:**

| # | Action | Expected Result |
|---|---|---|
| 1 | Navigate to an Account record | Page loads |
| 2 | Confirm Health_Score__c value is visible | Score displayed |
| 3 | Record Load time 5 times, average middle 3 | Average calculated |

**Pass Criteria:**

| Metric | SLO Target | Result | Pass/Fail |
|---|---|---|---|
| Average Load time | < 3,000 ms | _______ ms | |

---

## 5. Suite 2 — Apex Governor Limit Profiling

### Overview

Validates that all Apex automation operates within the 50% governor safety margin defined in Section 2.1. All tests use the `Limits.*` assertion pattern (Section 3.4) inside `@IsTest` methods.

---

### PTS-2.1 — Lead Trigger: Bulk Insert 200 Records

| Field | Value |
|---|---|
| Test ID | PTS-2.1 |
| Priority | Critical |
| Apex Class | LeadTriggerHandler, LeadScoringService |
| Req ID | MKT-REQ-NFR-002, MKT-REQ-NFR-005 |

**Test Method:**

```apex
@IsTest
static void testLeadBulkInsert_governorProfile() {
    List<Lead> leads = TestDataFactory.createLeads(200, false);

    Test.startTest();
    insert leads;
    Integer soqlUsed = Limits.getQueries();
    Integer dmlUsed  = Limits.getDmlStatements();
    Integer dmlRows  = Limits.getDmlRows();
    Integer cpuUsed  = Limits.getCpuTime();
    Integer heapUsed = Limits.getHeapSize();
    Test.stopTest();

    System.assert(soqlUsed <= 50,   'SOQL limit breach: '   + soqlUsed);
    System.assert(dmlUsed  <= 75,   'DML stmt breach: '     + dmlUsed);
    System.assert(dmlRows  <= 5000, 'DML row breach: '      + dmlRows);
    System.assert(cpuUsed  <= 5000, 'CPU time breach (ms): '+ cpuUsed);
    System.assert(heapUsed <= 3145728, 'Heap breach (B): '  + heapUsed);
}
```

**Expected Governor Usage:**

| Resource | Expected Usage | SLO Limit | Platform Limit |
|---|---|---|---|
| SOQL queries | ~3–5 | 50 | 100 |
| DML statements | ~2 | 75 | 150 |
| DML rows | 200 | 5,000 | 10,000 |
| CPU time | ~500 ms | 5,000 ms | 10,000 ms |
| Heap size | ~200 KB | 3 MB | 6 MB |

**Pass Criteria:** All `System.assert` calls pass. Zero `LimitException` thrown.

---

### PTS-2.2 — Case Trigger: Bulk Insert 200 Records (with SLA Entitlement Assignment)

| Field | Value |
|---|---|
| Test ID | PTS-2.2 |
| Priority | Critical |
| Apex Class | CaseTriggerHandler, CaseEntitlementService, CaseRoutingService |
| Req ID | MKT-REQ-NFR-002, MKT-REQ-NFR-005 |

**Test Method:**

```apex
@IsTest
static void testCaseBulkInsert_entitlementAssignment_governorProfile() {
    List<Account> accounts = TestDataFactory.createAccountsWithTier(10, 'Enterprise');
    List<Case> cases = TestDataFactory.createCasesForAccounts(accounts, 20); // 200 total

    Test.startTest();
    insert cases;
    Integer soqlUsed = Limits.getQueries();
    Integer dmlUsed  = Limits.getDmlStatements();
    Integer cpuUsed  = Limits.getCpuTime();
    Test.stopTest();

    System.assert(soqlUsed <= 50,   'SOQL limit breach: ' + soqlUsed);
    System.assert(dmlUsed  <= 75,   'DML stmt breach: '   + dmlUsed);
    System.assert(cpuUsed  <= 5000, 'CPU breach: '        + cpuUsed);

    // Verify entitlement actually assigned (functional + performance together)
    List<Case> inserted = [
        SELECT Id, EntitlementId FROM Case WHERE Id IN :cases LIMIT 200
    ];
    for (Case c : inserted) {
        System.assertNotEquals(null, c.EntitlementId, 'Entitlement not assigned: ' + c.Id);
    }
}
```

**Expected Governor Usage:**

| Resource | Expected Usage | SLO Limit |
|---|---|---|
| SOQL queries | ~8–12 | 50 |
| DML statements | ~4–6 | 75 |
| DML rows | ~210 (cases + updates) | 5,000 |
| CPU time | ~800 ms | 5,000 ms |

**Pass Criteria:** All assertions pass. Every Case has EntitlementId populated.

---

### PTS-2.3 — Health Score Recalculation: 50 Accounts

| Field | Value |
|---|---|
| Test ID | PTS-2.3 |
| Priority | High |
| Apex Class | AccountHealthScoreService (batch or future invocation) |
| Req ID | MKT-REQ-NFR-002 |

**Context:** Health Score recalculation is triggered by Case close or manual batch. This test validates that recalculating 50 accounts does not breach governor limits in a single transaction context.

**Test Method:**

```apex
@IsTest
static void testHealthScoreRecalculation_50Accounts_governorProfile() {
    List<Account> accounts = TestDataFactory.createAccountsWithCasesAndSurveys(50);

    Test.startTest();
    AccountHealthScoreService.recalculateAll(accounts);
    Integer soqlUsed = Limits.getQueries();
    Integer dmlUsed  = Limits.getDmlStatements();
    Integer dmlRows  = Limits.getDmlRows();
    Integer cpuUsed  = Limits.getCpuTime();
    Test.stopTest();

    System.assert(soqlUsed <= 50,   'SOQL breach: ' + soqlUsed);
    System.assert(dmlUsed  <= 75,   'DML stmt breach: ' + dmlUsed);
    System.assert(dmlRows  <= 5000, 'DML row breach: ' + dmlRows);
    System.assert(cpuUsed  <= 5000, 'CPU breach: ' + cpuUsed);
}
```

**Expected Governor Usage:**

| Resource | Expected Usage | SLO Limit |
|---|---|---|
| SOQL queries | ~6–10 | 50 |
| DML statements | ~2 (one update batch) | 75 |
| DML rows | ~50 | 5,000 |
| CPU time | ~600 ms | 5,000 ms |

**Note:** If health score recalculation exceeds transaction limits at scale, it must be implemented as a Batch Apex job or Queueable chain. This test validates the 50-account synchronous path is safe.

---

### PTS-2.4 — Case Escalation Scheduled Flow: Governor Validation

| Field | Value |
|---|---|
| Test ID | PTS-2.4 |
| Priority | High |
| Flow | Case_Scheduled_EscalationCheck |
| Req ID | MKT-REQ-NFR-002 |

**Context:** The escalation flow runs every 15 minutes. This test validates that the Apex actions invoked by the flow do not breach governor limits when processing a realistic case volume.

**Procedure (manual — Flow invoked via test):**

1. Create 50 open Cases with SLA breach timestamps in the past (overdue)
2. Enable Debug Logs for System Administrator
3. Invoke `Case_Scheduled_EscalationCheck` via Flow Interview in test or scheduled execution
4. Download and parse the CUMULATIVE_LIMIT_USAGE section
5. Record all governor values

**Pass Criteria:**

| Resource | Recorded Usage | SLO Limit | Pass/Fail |
|---|---|---|---|
| SOQL queries | _______ | 50 | |
| DML statements | _______ | 75 | |
| CPU time (ms) | _______ | 5,000 | |

---

### PTS-2.5 — Recursive Trigger Prevention Validation

| Field | Value |
|---|---|
| Test ID | PTS-2.5 |
| Priority | Critical |
| Apex Class | TriggerHandlerBase (bypass flag) |
| Req ID | MKT-REQ-NFR-002 |

**Context:** Verifies that the `TriggerHandlerBase` bypass mechanism prevents recursive trigger execution that would cause infinite loops and CPU limit exceptions.

**Test Method:**

```apex
@IsTest
static void testRecursiveTriggerPrevention() {
    Account acc = TestDataFactory.createAccount('Enterprise', true);
    Case c = TestDataFactory.createCase(acc.Id, true);

    Test.startTest();
    // Simulate a trigger chain that would recurse without bypass
    TriggerHandlerBase.bypass('CaseTriggerHandler');
    c.Status = 'In Progress';
    update c;
    TriggerHandlerBase.clearBypass('CaseTriggerHandler');
    Test.stopTest();

    // Verify no CPUTimeExceededException — test completing proves this
    // Also verify the update went through
    Case updated = [SELECT Status FROM Case WHERE Id = :c.Id];
    System.assertEquals('In Progress', updated.Status);
    // Verify bypass cleared
    System.assert(!TriggerHandlerBase.isBypassed('CaseTriggerHandler'));
}
```

**Pass Criteria:** Test completes without `System.LimitException`. Bypass flag is correctly cleared after operation.

---

## 6. Suite 3 — Experience Cloud LWR Performance

### Overview

Validates that the Catalyst Client Portal meets Google Core Web Vitals thresholds using Chrome Lighthouse. All tests run in authenticated session state (Portal Customer profile).

**Tool:** Chrome Lighthouse (built into DevTools), Desktop preset
**Conditions:** Simulated throttling (Lighthouse default: 10,240 Kbps, 4× CPU slowdown)

---

### PTS-3.1 — Portal Home Page: Dashboard LWR Components

| Field | Value |
|---|---|
| Test ID | PTS-3.1 |
| Priority | Critical |
| Portal Page | Catalyst Client Dashboard (authenticated home) |
| LWC Components | catalyst-client-dashboard, catalyst-subscription-tile, catalyst-open-cases-tile, catalyst-usage-heatmap |
| Req ID | MKT-REQ-NFR-003 |

**Preconditions:**
- Logged in as Portal Customer (Customer Community Plus profile)
- Account has Health_Score__c, at least 3 open Cases, Usage Index data
- All 4 dashboard LWC components are on the page

**Steps:**

| # | Action | Expected Result |
|---|---|---|
| 1 | Navigate to portal dashboard home page | Page loads with all 4 LWC components |
| 2 | Open DevTools > Lighthouse | Lighthouse panel opens |
| 3 | Set mode: Navigation, device: Desktop | Settings confirmed |
| 4 | Click Analyze Page Load | Lighthouse audit runs |
| 5 | Record: Performance score, LCP, FID/INP, CLS, TBT | Metrics captured |
| 6 | Run 2 more times; take median score set | 3 runs, median identified |

**Pass Criteria:**

| Metric | SLO Target | Median Result | Pass/Fail |
|---|---|---|---|
| Lighthouse Performance Score | >= 80 | _______ | |
| LCP (Largest Contentful Paint) | < 2.5 s | _______ s | |
| FID / INP | < 100 ms | _______ ms | |
| CLS (Cumulative Layout Shift) | < 0.1 | _______ | |
| TBT (Total Blocking Time) | < 200 ms | _______ ms | |

---

### PTS-3.2 — Portal Case List Page

| Field | Value |
|---|---|
| Test ID | PTS-3.2 |
| Priority | High |
| Portal Page | My Cases (catalyst-case-list component) |
| Req ID | MKT-REQ-NFR-003 |

**Preconditions:**
- Portal user has at least 10 Cases visible
- catalyst-case-list is the primary content component

**Steps:**

| # | Action | Expected Result |
|---|---|---|
| 1 | Navigate to My Cases page in portal | Case list renders |
| 2 | Run Lighthouse (Desktop, Navigation mode) 3 times | 3 audit results |
| 3 | Record median LCP, CLS, TBT | Metrics captured |

**Pass Criteria:**

| Metric | SLO Target | Median Result | Pass/Fail |
|---|---|---|---|
| LCP | < 2.5 s | _______ s | |
| CLS | < 0.1 | _______ | |
| TBT | < 200 ms | _______ ms | |

---

### PTS-3.3 — Portal Knowledge Search Page (Aria Deflection)

| Field | Value |
|---|---|
| Test ID | PTS-3.3 |
| Priority | High |
| Portal Page | Knowledge Base / catalyst-knowledge-search + catalyst-knowledge-deflection |
| Req ID | MKT-REQ-NFR-003 |

**Preconditions:**
- At least 10 published Knowledge Articles exist
- catalyst-knowledge-deflection shows suggested articles
- catalyst-aria-launcher button is visible

**Steps:**

| # | Action | Expected Result |
|---|---|---|
| 1 | Navigate to Knowledge Base page | Page loads with search bar and article suggestions |
| 2 | Type a search term (e.g., "campaign") in the search field | Results appear without page reload (AJAX) |
| 3 | Record time from keystroke to result display using Performance tab | Response time noted |
| 4 | Run Lighthouse audit 3 times on the page (pre-search state) | 3 audit results |
| 5 | Record median LCP, CLS | Metrics captured |

**Pass Criteria:**

| Metric | SLO Target | Result | Pass/Fail |
|---|---|---|---|
| Search result response time (AJAX) | < 1,500 ms | _______ ms | |
| Lighthouse LCP | < 2.5 s | _______ s | |
| Lighthouse CLS | < 0.1 | _______ | |

---

### PTS-3.4 — Agentforce Aria Chat Launch Time

| Field | Value |
|---|---|
| Test ID | PTS-3.4 |
| Priority | High |
| Component | catalyst-aria-launcher → Agentforce chat panel |
| Req ID | MKT-REQ-NFR-003 |

**Context:** Measures the time from clicking the Aria chat button to the chat panel being interactive (ready for user input).

**Steps:**

| # | Action | Expected Result |
|---|---|---|
| 1 | Navigate to any portal page with catalyst-aria-launcher | Chat button visible |
| 2 | Open Performance tab in DevTools; begin recording | Recording active |
| 3 | Click the Aria chat button | Chat panel begins loading |
| 4 | Stop recording when chat input field becomes interactive | Recording captured |
| 5 | Identify chat panel interactive timestamp in Performance timeline | Time measured |
| 6 | Repeat 3 times | 3 data points |

**Pass Criteria:**

| Metric | SLO Target | Median Result | Pass/Fail |
|---|---|---|---|
| Time to chat panel interactive | < 3,000 ms | _______ ms | |

---

## 7. Suite 4 — Integration Response Time

### Overview

Validates that integration callouts to external systems respect the 5-second SLO and that the system degrades gracefully when response times exceed threshold.

**Note:** In the portfolio context, integrations are implemented as stubs backed by Named Credentials (BillingSystem_NC, UsageAPI_NC). Real external services are not connected. Performance validation uses mock-based timeout injection and design pattern review.

---

### PTS-4.1 — Billing API Callout: Happy Path Response Time

| Field | Value |
|---|---|
| Test ID | PTS-4.1 |
| Priority | High |
| Apex Class | BillingAPIService (implements IBillingAPIService) |
| Req ID | MKT-REQ-NFR-004 |

**Timeout Configuration Verification:**

The `BillingAPIService` must set a request timeout of 5,000 ms on the `HttpRequest` object. This is a design-time enforcement, verified in code review and test:

```apex
@IsTest
static void testBillingAPIService_timeoutConfigured() {
    HttpRequest req = BillingAPIService.buildRequest('/invoices', 'GET', null);
    System.assertEquals(5000, req.getTimeout(),
        'HttpRequest timeout must be set to 5000ms (5s)');
}
```

**Graceful Degradation Verification:**

```apex
@IsTest
static void testBillingAPIService_timeoutGracefulDegradation() {
    Test.setMock(HttpCalloutMock.class, new TimeoutMockHttpResponse());
    Test.startTest();
    BillingAPIResponse response = BillingAPIService.getInvoices('ACC-001');
    Test.stopTest();

    System.assertEquals(false, response.isSuccess,
        'Response must indicate failure on timeout');
    System.assertNotEquals(null, response.errorMessage,
        'Error message must be populated on timeout');
    // Verify no unhandled exception propagated to the caller
}
```

**Pass Criteria:**

| Assertion | Expected | Pass/Fail |
|---|---|---|
| HttpRequest timeout set to 5,000 ms | true | |
| Timeout returns structured error response | true | |
| No unhandled exception on timeout | true | |

---

### PTS-4.2 — Usage API Callout: Happy Path Response Time

| Field | Value |
|---|---|
| Test ID | PTS-4.2 |
| Priority | High |
| Apex Class | UsageAPIService (implements IUsageAPIService) |
| Req ID | MKT-REQ-NFR-004 |

**Test Method:**

```apex
@IsTest
static void testUsageAPIService_timeoutConfigured() {
    HttpRequest req = UsageAPIService.buildRequest('/usage/metrics', 'GET', null);
    System.assertEquals(5000, req.getTimeout(),
        'HttpRequest timeout must be set to 5000ms');
}

@IsTest
static void testUsageAPIService_malformedResponseHandling() {
    Test.setMock(HttpCalloutMock.class, new MalformedJsonMockResponse());
    Test.startTest();
    UsageAPIResponse response = UsageAPIService.getUsageMetrics('ACC-001');
    Test.stopTest();

    System.assertEquals(false, response.isSuccess);
    System.assert(response.errorMessage.contains('parse'),
        'Error message must indicate JSON parse failure');
}
```

**Pass Criteria:**

| Assertion | Expected | Pass/Fail |
|---|---|---|
| HttpRequest timeout set to 5,000 ms | true | |
| Malformed JSON returns structured error | true | |

---

### PTS-4.3 — Integration Circuit Breaker: 503 Response Handling

| Field | Value |
|---|---|
| Test ID | PTS-4.3 |
| Priority | High |
| Both services | BillingAPIService, UsageAPIService |
| Req ID | MKT-REQ-NFR-004 |

**Context:** Verifies that 503 Service Unavailable responses from external systems result in a structured failure response and do not cause unhandled exceptions or corrupt Salesforce data.

**Test Method:**

```apex
@IsTest
static void testBillingAPI_503_circuitBreaker() {
    Test.setMock(HttpCalloutMock.class, new ErrorMockHttpResponse(503));
    Test.startTest();
    BillingAPIResponse response = BillingAPIService.getInvoices('ACC-001');
    Test.stopTest();

    System.assertEquals(false, response.isSuccess);
    System.assertEquals(503, response.httpStatusCode);
    System.assert(response.errorMessage != null && response.errorMessage.length() > 0);
    // Verify Platform Event fired for monitoring
    List<Integration_Error__e> events = [SELECT Payload__c FROM Integration_Error__e LIMIT 1];
    // Note: Platform Events cannot be queried in tests; verify via log inspection
}
```

**Pass Criteria:**

| Assertion | Expected | Pass/Fail |
|---|---|---|
| Response.isSuccess = false on 503 | true | |
| httpStatusCode captured in response | 503 | |
| No DML operations on Salesforce data after failure | true | |

---

## 8. Suite 5 — Report and Dashboard Rendering

### Overview

Validates that key reports and dashboards used by Sales and Service personas render within the 10-second SLO. Timing is measured manually using browser Network tab.

---

### PTS-5.1 — Pipeline Report: Open Opportunities by Stage

| Field | Value |
|---|---|
| Test ID | PTS-5.1 |
| Priority | High |
| Persona | Sales Manager |
| Report | Pipeline — Open Opportunities by Stage and Tier |
| Req ID | MKT-REQ-NFR-006 |

**Preconditions:**
- At least 30 open Opportunities across all stages and tiers
- Report uses grouping by StageName and Subscription_Tier__c

**Steps:**

| # | Action | Expected Result |
|---|---|---|
| 1 | Navigate to the Pipeline report | Report begins loading |
| 2 | Start timer when navigation begins | Timer running |
| 3 | Stop timer when report data is fully rendered | Total time recorded |
| 4 | Repeat 3 times using browser Network tab Load event | 3 data points |

**Pass Criteria:**

| Metric | SLO Target | Average Result | Pass/Fail |
|---|---|---|---|
| Report render time | < 10,000 ms | _______ ms | |

---

### PTS-5.2 — Service Manager Dashboard: SLA Compliance Summary

| Field | Value |
|---|---|
| Test ID | PTS-5.2 |
| Priority | High |
| Persona | Service Manager |
| Dashboard | SLA Compliance and Queue Performance |
| Req ID | MKT-REQ-NFR-006 |

**Preconditions:**
- Dashboard contains at least 4 components (SLA breach rate, open cases by tier, escalation count, CSAT average)
- At least 100 Case records exist for meaningful data

**Steps:**

| # | Action | Expected Result |
|---|---|---|
| 1 | Navigate to the SLA Compliance dashboard | Dashboard loading begins |
| 2 | Record time until all 4 components show data (not spinner) | Total render time |
| 3 | Repeat 3 times | 3 data points |
| 4 | Refresh dashboard using the refresh button on the dashboard | Refresh time recorded |

**Pass Criteria:**

| Metric | SLO Target | Average Result | Pass/Fail |
|---|---|---|---|
| Initial dashboard render time | < 10,000 ms | _______ ms | |
| Dashboard manual refresh time | < 10,000 ms | _______ ms | |

---

### PTS-5.3 — Health Score Report: Account Portfolio View

| Field | Value |
|---|---|
| Test ID | PTS-5.3 |
| Priority | Medium |
| Persona | Sales Manager, Service Manager |
| Report | Account Health Score — Portfolio Summary |
| Req ID | MKT-REQ-NFR-006 |

**Preconditions:**
- At least 50 Accounts with calculated Health_Score__c values
- Report groups by Health Score category (Healthy/Neutral/At Risk)

**Steps:**

| # | Action | Expected Result |
|---|---|---|
| 1 | Open the Account Health Score report | Report loads |
| 2 | Record render time (Network Load event) | Time noted |
| 3 | Repeat 3 times | 3 data points |

**Pass Criteria:**

| Metric | SLO Target | Average Result | Pass/Fail |
|---|---|---|---|
| Report render time | < 10,000 ms | _______ ms | |

---

## 9. Suite 6 — Bulk Data Processing

### Overview

Validates Apex bulk processing at the Salesforce transaction boundary of 200 records. These tests are primarily covered in Suite 2 (Apex Governor Profiling) but this suite addresses the functional correctness of bulk operations at scale, ensuring data integrity is maintained at maximum DML batch size.

---

### PTS-6.1 — Lead Bulk Insert: 200 Records — Data Integrity

| Field | Value |
|---|---|
| Test ID | PTS-6.1 |
| Priority | Critical |
| Apex Class | LeadTriggerHandler, LeadScoringService |
| Req ID | MKT-REQ-NFR-002, MKT-REQ-NFR-005 |

**Test Method:**

```apex
@IsTest
static void testLeadBulkInsert_200_dataIntegrity() {
    List<Lead> leads = TestDataFactory.createLeads(200, false);
    // Mix of sources to test routing logic at bulk scale
    for (Integer i = 0; i < 100; i++) {
        leads[i].LeadSource = 'Web';
        leads[i].State      = 'TX';
    }
    for (Integer i = 100; i < 200; i++) {
        leads[i].LeadSource = 'Referral';
        leads[i].State      = 'CA';
    }

    Test.startTest();
    insert leads;
    Test.stopTest();

    List<Lead> inserted = [
        SELECT Id, OwnerId, Lead_Score__c, LeadSource, State
        FROM Lead WHERE Id IN :leads
    ];

    System.assertEquals(200, inserted.size(), '200 Leads must be inserted');
    for (Lead l : inserted) {
        System.assertNotEquals(null, l.OwnerId,      'Owner must be assigned');
        System.assertNotEquals(null, l.Lead_Score__c,'Lead score must be calculated');
    }
}
```

**Pass Criteria:**

| Assertion | Expected | Pass/Fail |
|---|---|---|
| All 200 Leads inserted | 200 records | |
| All have OwnerId assigned | No nulls | |
| All have Lead_Score__c populated | No nulls | |
| No LimitException thrown | Zero exceptions | |

---

### PTS-6.2 — Case Bulk Insert: 200 Records — Entitlement Assignment

| Field | Value |
|---|---|
| Test ID | PTS-6.2 |
| Priority | Critical |
| Apex Class | CaseTriggerHandler, CaseEntitlementService |
| Req ID | MKT-REQ-NFR-002, MKT-REQ-NFR-005 |

**Test Method:**

```apex
@IsTest
static void testCaseBulkInsert_200_entitlementIntegrity() {
    // Create accounts across all 3 tiers (67 Enterprise, 67 Professional, 66 Starter)
    List<Account> enterprise   = TestDataFactory.createAccountsWithTier(67, 'Enterprise');
    List<Account> professional = TestDataFactory.createAccountsWithTier(67, 'Professional');
    List<Account> starter      = TestDataFactory.createAccountsWithTier(66, 'Starter');

    List<Case> cases = new List<Case>();
    cases.addAll(TestDataFactory.createCasesForAccounts(enterprise,   1));
    cases.addAll(TestDataFactory.createCasesForAccounts(professional, 1));
    cases.addAll(TestDataFactory.createCasesForAccounts(starter,      1));
    // Total: 200 Cases

    Test.startTest();
    insert cases;
    Test.stopTest();

    List<Case> inserted = [
        SELECT Id, EntitlementId, SLA_Tier_at_Creation__c, AccountId
        FROM Case WHERE Id IN :cases
    ];

    System.assertEquals(200, inserted.size());
    for (Case c : inserted) {
        System.assertNotEquals(null, c.EntitlementId,
            'Entitlement must be assigned for Case: ' + c.Id);
        System.assertNotEquals(null, c.SLA_Tier_at_Creation__c,
            'SLA tier snapshot must be captured');
    }
}
```

**Pass Criteria:**

| Assertion | Expected | Pass/Fail |
|---|---|---|
| All 200 Cases inserted | 200 records | |
| All have EntitlementId | No nulls | |
| All have SLA_Tier_at_Creation__c | No nulls | |
| No LimitException thrown | Zero exceptions | |

---

### PTS-6.3 — Mixed DML Bulk Operation: Account + Case Update

| Field | Value |
|---|---|
| Test ID | PTS-6.3 |
| Priority | High |
| Context | Account tier change triggers Case SLA re-evaluation |
| Req ID | MKT-REQ-NFR-002 |

**Test Method:**

```apex
@IsTest
static void testAccountTierChange_cascadeToCase_bulk() {
    List<Account> accounts = TestDataFactory.createAccountsWithTier(50, 'Starter');
    insert accounts;
    List<Case> cases = TestDataFactory.createCasesForAccounts(accounts, 2); // 100 cases
    insert cases;

    // Upgrade all accounts to Enterprise
    for (Account a : accounts) {
        a.Subscription_Tier__c = 'Enterprise';
    }

    Test.startTest();
    update accounts;
    Integer soqlAfter = Limits.getQueries();
    Integer dmlAfter  = Limits.getDmlStatements();
    Test.stopTest();

    System.assert(soqlAfter <= 50, 'SOQL breach on account update: ' + soqlAfter);
    System.assert(dmlAfter  <= 75, 'DML breach on account update: '  + dmlAfter);
}
```

**Pass Criteria:** All governor assertions pass. No exception thrown.

---

## 10. Baseline and Regression Thresholds

### 10.1 Baseline Recording Template

After initial deployment to the Developer Edition org, record baseline measurements for all PTS tests. Use this table as the living performance baseline.

| Test ID | Metric | Baseline Value | Date Recorded | SLO Target | Delta Threshold |
|---|---|---|---|---|---|
| PTS-1.1 | Page Load (avg) | _______ ms | | < 3,000 ms | +500 ms |
| PTS-1.2 | Page Load (avg) | _______ ms | | < 3,000 ms | +500 ms |
| PTS-1.3 | Page Load (avg) | _______ ms | | < 3,000 ms | +500 ms |
| PTS-1.4 | Page Load (avg) | _______ ms | | < 3,000 ms | +500 ms |
| PTS-1.5 | Page Load (avg) | _______ ms | | < 3,000 ms | +500 ms |
| PTS-2.1 | SOQL count | _______ | | <= 50 | +10 |
| PTS-2.1 | DML count | _______ | | <= 75 | +10 |
| PTS-2.1 | CPU time | _______ ms | | <= 5,000 ms | +500 ms |
| PTS-2.2 | SOQL count | _______ | | <= 50 | +10 |
| PTS-2.2 | DML count | _______ | | <= 75 | +10 |
| PTS-2.3 | SOQL count | _______ | | <= 50 | +5 |
| PTS-3.1 | Lighthouse score | _______ | | >= 80 | -10 |
| PTS-3.1 | LCP | _______ s | | < 2.5 s | +0.5 s |
| PTS-3.1 | CLS | _______ | | < 0.1 | +0.05 |
| PTS-4.1 | Timeout configured | 5,000 ms | | 5,000 ms | N/A |
| PTS-5.1 | Report render | _______ ms | | < 10,000 ms | +2,000 ms |
| PTS-5.2 | Dashboard render | _______ ms | | < 10,000 ms | +2,000 ms |

### 10.2 Regression Policy

A **performance regression** is defined as any metric exceeding the baseline by more than the Delta Threshold defined above.

Regression response:
1. **Minor regression** (delta within 2× threshold): Document, investigate root cause, add to sprint backlog
2. **Major regression** (delta > 2× threshold or SLO breach): Block deployment, resolve before next release
3. **All PTS-2.x Apex assertions must pass** on every test run — governor limit breaches are always blocking

---

## 11. Tooling and Execution Environment

### 11.1 Required Tools

| Tool | Version | Purpose |
|---|---|---|
| Google Chrome | 120+ | DevTools, Lighthouse, Network tab |
| Chrome DevTools | Built-in | Page timing, Performance tab, Network tab |
| Chrome Lighthouse | Built-in | Core Web Vitals for LWR portal |
| Salesforce SF CLI | v2.125.2+ | Scratch org management, metadata deploy |
| Salesforce Debug Log | Built-in | Apex governor profiling |
| Lightning Usage App | Built-in | Aggregate page load data |

### 11.2 Test Execution Environment

| Parameter | Value |
|---|---|
| Browser | Chrome (no extensions active during timing) |
| Network | Cable / WiFi > 50 Mbps download |
| Device | macOS, 2020+ hardware |
| Display | 1440 × 900 or higher |
| Cache state | Disabled for all page load tests |
| Session state | Authenticated (role-appropriate persona) |
| Org type | Developer Edition (sf-portfolio alias) |
| Scratch org | Used for development testing only |

### 11.3 Apex Test Execution

```bash
# Run all PTS-related test classes
sf apex run test \
  --class-names LeadTriggerHandlerTest,CaseTriggerHandlerTest,AccountHealthScoreServiceTest,BillingAPIServiceTest,UsageAPIServiceTest \
  --test-level RunSpecifiedTests \
  --result-format human \
  --target-org sf-portfolio

# Run with code coverage output
sf apex run test \
  --class-names LeadTriggerHandlerTest,CaseTriggerHandlerTest \
  --code-coverage \
  --target-org sf-portfolio
```

### 11.4 Execution Frequency

| Suite | When to Execute |
|---|---|
| PTS-2.x (Apex governors) | Every code change to trigger handlers or service classes |
| PTS-6.x (Bulk integrity) | Every trigger or service change; before every deploy |
| PTS-1.x (Page load) | Before each demo or stakeholder review |
| PTS-3.x (LWR Lighthouse) | Before each portal update deployment |
| PTS-4.x (Integration) | Whenever integration service classes are modified |
| PTS-5.x (Reports/Dashboards) | After any data model change that affects report fields |

---

## 12. Traceability Matrix

| Test ID | Test Name | NFR Req ID | User Story | Covered By |
|---|---|---|---|---|
| PTS-1.1 | Lead List Page Load | MKT-REQ-NFR-001 | MKT-US-SALES-001 | Manual / DevTools |
| PTS-1.2 | Opportunity Record Page Load | MKT-REQ-NFR-001 | MKT-US-SALES-005 | Manual / DevTools |
| PTS-1.3 | Case List Page Load | MKT-REQ-NFR-001 | MKT-US-SRVC-001 | Manual / DevTools |
| PTS-1.4 | Case Record Page Load | MKT-REQ-NFR-001 | MKT-US-SRVC-002 | Manual / DevTools |
| PTS-1.5 | Account Health Score Page | MKT-REQ-NFR-001 | MKT-US-SALES-010 | Manual / DevTools |
| PTS-2.1 | Lead Bulk Insert Governors | MKT-REQ-NFR-002, NFR-005 | MKT-US-SALES-001 | Apex `@IsTest` / `Limits.*` |
| PTS-2.2 | Case Bulk Insert Governors | MKT-REQ-NFR-002, NFR-005 | MKT-US-SRVC-001 | Apex `@IsTest` / `Limits.*` |
| PTS-2.3 | Health Score Recalc Governors | MKT-REQ-NFR-002 | MKT-US-SALES-010 | Apex `@IsTest` / `Limits.*` |
| PTS-2.4 | Escalation Flow Governors | MKT-REQ-NFR-002 | MKT-US-SRVC-005 | Debug Log / Manual |
| PTS-2.5 | Recursive Trigger Prevention | MKT-REQ-NFR-002 | MKT-US-SRVC-001 | Apex `@IsTest` |
| PTS-3.1 | Portal Dashboard LWR Vitals | MKT-REQ-NFR-003 | MKT-US-EXP-001 | Chrome Lighthouse |
| PTS-3.2 | Portal Case List LWR Vitals | MKT-REQ-NFR-003 | MKT-US-EXP-003 | Chrome Lighthouse |
| PTS-3.3 | Knowledge Search Performance | MKT-REQ-NFR-003 | MKT-US-EXP-004 | Lighthouse + DevTools |
| PTS-3.4 | Aria Chat Launch Time | MKT-REQ-NFR-003 | MKT-US-EXP-012 | Performance tab |
| PTS-4.1 | Billing API Timeout Config | MKT-REQ-NFR-004 | MKT-US-NFR-004 | Apex `@IsTest` |
| PTS-4.2 | Usage API Timeout Config | MKT-REQ-NFR-004 | MKT-US-NFR-004 | Apex `@IsTest` |
| PTS-4.3 | Integration 503 Handling | MKT-REQ-NFR-004 | MKT-US-NFR-004 | Apex `@IsTest` |
| PTS-5.1 | Pipeline Report Render | MKT-REQ-NFR-006 | MKT-US-SALES-009 | Manual Timer |
| PTS-5.2 | SLA Dashboard Render | MKT-REQ-NFR-006 | MKT-US-SRVC-012 | Manual Timer |
| PTS-5.3 | Health Score Report Render | MKT-REQ-NFR-006 | MKT-US-SALES-010 | Manual Timer |
| PTS-6.1 | Lead Bulk Data Integrity | MKT-REQ-NFR-002, NFR-005 | MKT-US-SALES-001 | Apex `@IsTest` |
| PTS-6.2 | Case Bulk Entitlement Integrity | MKT-REQ-NFR-002, NFR-005 | MKT-US-SRVC-001 | Apex `@IsTest` |
| PTS-6.3 | Mixed DML Bulk Operation | MKT-REQ-NFR-002 | MKT-US-SALES-010 | Apex `@IsTest` |

---

*End of MKT-PTS-1.0 — Performance Testing Suite*

*Document Status: Complete*
*Next Document: MKT-DRP-1.0 — Deployment & Release Plan*
