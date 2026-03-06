# SF-PORTFOLIO-UX-1.0 — UI / UX Specification
**Portfolio Site · Dashboard · Case Study Pages**  
**Figma Design Brief + Component Specification**

| Field | Value |
|---|---|
| Document ID | SF-PORTFOLIO-UX-1.0 |
| Status | Draft — Figma Design Phase |
| Visual Theme | Dark Corporate — Professional & Contemporary |
| Primary Font | Inter (headings & body) |
| Accent Colours | `#00C2E0` Cyan · `#0176D3` Salesforce Blue |
| Frameworks | Experience Cloud LWR · React/Next.js (Phase 2) |
| Parent Doc | SF Portfolio Framework — Master Project Plan v1.0 |

---

## Table of Contents

1. [Purpose & Scope](#1-purpose--scope)
2. [Design System](#2-design-system)
3. [Site Architecture](#3-site-architecture)
4. [Public Pages](#4-public-pages)
5. [Authenticated Dashboard](#5-authenticated-dashboard--dashboard)
6. [Component Library](#6-component-library)
7. [Figma File Structure](#7-figma-file-structure)
8. [Dashboard Data Architecture](#8-dashboard-data-architecture)
9. [Next Steps](#9-next-steps)

---

## 1. Purpose & Scope

This document defines the UI/UX specification for the Salesforce Portfolio Framework public-facing site. It serves as the design brief for Figma mockups and the implementation reference for Experience Cloud LWR development and, subsequently, React/Next.js development.

The portfolio site is the top layer of a four-tier recruiter engagement model. Its purpose is to create a memorable, professional first impression that demonstrates both Salesforce technical depth and design sensibility — capabilities rarely combined in a single candidate portfolio.

> **Note:** This spec governs the Catalyst Marketing vertical as the full reference implementation. Subsequent verticals reuse the component library with updated content and colour accents. The full case study format (screenshots + downloadable SDLC docs + narrative) applies to Catalyst only at initial launch.

### 1.1 Design Philosophy

- Dark, contemporary aesthetic — professional without being sterile
- Data-forward — metrics and status are hero content, not decoration
- Progressive disclosure — public pages hook interest, authenticated pages reward depth
- SLDS 2 compatible — Figma tokens map directly to Salesforce design tokens where possible
- Component-first — every UI element is a reusable component, not a one-off layout

### 1.2 Delivery Phases

| Phase | Deliverable | Scope | Timing |
|---|---|---|---|
| 1 | Figma Design | All pages to high fidelity; design system established | Before SF build begins |
| 2 | Experience Cloud LWR | All pages built in Salesforce LWR using SLDS 2 | During Catalyst build |
| 3 | React/Next.js Layer | Dashboard rebuilt headless; one additional page per sprint | Post Catalyst v1.0 |

---

## 2. Design System

### 2.1 Colour Palette

| Hex | Name | Usage |
|---|---|---|
| `#0A0E1A` | Obsidian | Page background — deepest layer |
| `#0D1B2A` | Navy | Card backgrounds, sidebar, header |
| `#1A2744` | Slate | Elevated surfaces, modals, table rows |
| `#0176D3` | Salesforce Blue | Primary actions, links, active states |
| `#00C2E0` | Cyan | Accent, highlights, borders, chart lines |
| `#00A99D` | Teal | Secondary accent, hover states, tags |
| `#FFFFFF` | White | Primary text on dark backgrounds |
| `#8896A5` | Grey Mid | Secondary text, metadata, labels |
| `#10B981` | Emerald | Success, passing tests, live status |
| `#F59E0B` | Amber | Warning, in-progress, pending |
| `#EF4444` | Red | Failure, failing CI, critical defects |

### 2.2 Typography

| Element | Font | Size / Weight | Usage |
|---|---|---|---|
| H1 — Page Title | Inter | 36px / 700 | Primary page headings only |
| H2 — Section Title | Inter | 24px / 600 | Major section headers |
| H3 — Card Title | Inter | 18px / 600 | Card and component headings |
| H4 — Label | Inter | 13px / 600 | Data labels, stat captions — ALL CAPS |
| Body | Inter | 15px / 400 | Paragraph text, descriptions |
| Body Small | Inter | 13px / 400 | Secondary text, metadata, timestamps |
| Metric Value | Inter | 32–48px / 700 | Large KPI numbers on dashboard cards |
| Code / Monospace | JetBrains Mono | 13px / 400 | API responses, code snippets, IDs |
| Navigation | Inter | 14px / 500 | Nav links, tab labels, breadcrumbs |

### 2.3 Spacing & Grid

- **Base unit:** 4px — all spacing is a multiple of 4
- **Page max-width:** 1440px — centred with 80px horizontal padding on desktop
- **Card padding:** 24px
- **Section vertical spacing:** 64px between major sections
- **Grid:** 12-column — dashboard uses 3 and 4 column layouts; public pages use 2 and full-width

### 2.4 Component Tokens (SLDS 2 Mapping)

These tokens must be defined in both Figma (as variables) and in the LWR site's branding configuration.

| Token Name | Value | Applies To |
|---|---|---|
| `--color-background-alt` | `#0D1B2A` | Card and panel backgrounds |
| `--color-background-highlight` | `#1A2744` | Hover states, selected rows |
| `--color-brand-primary` | `#0176D3` | Buttons, links, focus rings |
| `--color-brand-accent` | `#00C2E0` | Borders, chart highlights, badges |
| `--color-text-default` | `#FFFFFF` | Primary text |
| `--color-text-secondary` | `#8896A5` | Labels, metadata |
| `--color-success` | `#10B981` | Pass indicators, live badges |
| `--color-warning` | `#F59E0B` | Pending, in-progress |
| `--color-error` | `#EF4444` | Fail, critical |
| `--border-radius-card` | `12px` | All card components |
| `--border-radius-badge` | `6px` | Status badges, tags |
| `--shadow-card` | `0 4px 24px rgba(0,194,224,0.08)` | Card elevation |

---

## 3. Site Architecture

### 3.1 Page Map

| Auth | Route | Page Name | Priority | Phase |
|---|---|---|---|---|
| Public | `/` | Home — Hero & Agent | P1 — Critical | Phase 1 |
| Public | `/about` | About — Skills & Background | P1 — Critical | Phase 1 |
| Public | `/portfolio` | Portfolio — Vertical Grid | P1 — Critical | Phase 1 |
| Public | `/portfolio/marketing` | Case Study — Catalyst MKT | P1 — Critical | Phase 1 |
| Public | `/portfolio/[slug]` | Case Study — Other Verticals | P2 — Important | Phase 2+ |
| Public | `/contact` | Contact — Web-to-Lead | P2 — Important | Phase 1 |
| Private | `/dashboard` | Live Metrics Dashboard | P1 — Critical | Phase 1 |
| Private | `/dashboard/[vertical]` | Vertical Detail Dashboard | P2 — Important | Phase 2 |
| Private | `/org/[vertical]` | Org Explorer — Live Records | P3 — Nice to Have | Phase 3 |

### 3.2 Navigation Structure

| Element | Unauthenticated | Authenticated |
|---|---|---|
| Logo / Wordmark | Visible — links to `/` | Visible — links to `/dashboard` |
| Nav Links | Home · About · Portfolio · Contact | Home · About · Portfolio · Dashboard · Contact |
| CTA Button | "Request Access" — opens login modal | "View Dashboard" — links to `/dashboard` |
| User Avatar | Not shown | Shown — dropdown: profile, org links, logout |
| Mobile | Hamburger menu | Hamburger menu |

---

## 4. Public Pages

### 4.1 Home Page ( `/` )

The home page is the first impression for any recruiter. It must communicate who you are, what the portfolio is, and what makes it different — within 5 seconds. The Agentforce recruiter agent is the interactive centrepiece.

#### 4.1.1 Hero Section

| Element | Spec |
|---|---|
| Layout | Full-width, 100vh — two column on desktop (60/40 split), stacked on mobile |
| Left Column | Headline, subheadline, two CTAs, social/GitHub links |
| Right Column | Agentforce chat widget — embedded, visible on load |
| Background | `#0A0E1A` with subtle cyan grid or particle animation — low opacity |

**Copy & Content**
- Eyebrow label (ALL CAPS, cyan, small): `SALESFORCE QA ENGINEER & DEVELOPER`
- H1 Headline: `"Building Salesforce Orgs That Prove the Point"`
- Subheadline: `"A full-stack portfolio of Sales Cloud, Service Cloud, and Experience Cloud implementations — with complete SDLC documentation, automated testing, and Agentforce AI built in."`
- CTA 1 (primary button, blue): `"Explore the Portfolio"` → `/portfolio`
- CTA 2 (ghost button, cyan border): `"View Source on GitHub"` → GitHub repo
- Social row: GitHub icon · LinkedIn icon · Salesforce Trailhead icon

**Agentforce Chat Widget (right column)**
- Visible on load — not hidden behind a chat bubble
- Card: dark navy background, cyan border, 12px radius
- Header: small avatar + `"Ask about this portfolio"` label
- Starter prompt chips: `"What clouds are covered?"` · `"Show me the test coverage"` · `"What industries are included?"` · `"How do I get access?"`
- Input field: `"Ask me anything about this work..."`
- Response area: scrollable, max 4 visible messages before scroll

#### 4.1.2 Stats Bar

A horizontal strip directly below the hero — full width, dark surface.

| Stat 1 | Stat 2 | Stat 3 | Stat 4 |
|---|---|---|---|
| 7 Industry Verticals | 3 Salesforce Clouds | 9 SDLC Documents per Vertical | 85%+ Apex Test Coverage |

*Each stat: large bold number in cyan, label in grey below. Animated count-up on scroll into view.*

#### 4.1.3 Vertical Preview Grid

3–4 column card grid previewing each industry vertical. Each card links to its case study page.

| Element | Spec |
|---|---|
| Card Contents | Industry icon · Vertical name · Company name · Status badge · 1-line description |
| Card Style | Dark navy background · Cyan top border on hover · Subtle shadow · 12px radius |
| Status Badges | Live = green · In Progress = amber · Planned = grey |
| Click | Links to `/portfolio/[slug]` |

---

### 4.2 Portfolio Page ( `/portfolio` )

Expanded vertical grid with filtering, search, and richer card detail.

| Element | Spec |
|---|---|
| Filter Bar | Filter by Cloud · Filter by Status · Search by keyword |
| Card — Default | Industry icon, company name, tagline, cloud tags, status badge, "View Case Study" CTA |
| Card — Hover | Expands to show 2–3 key metrics (coverage %, doc count, record count) + tech stack tags |
| Layout | 3-column desktop · 2-column tablet · 1-column mobile |

---

### 4.3 Case Study Page — Catalyst MKT ( `/portfolio/marketing` )

The most content-rich public page. Three content layers: narrative, screenshots, and downloadable SDLC documents.

#### 4.3.1 Page Header

- Company wordmark: `CATALYST` with tagline `"Accelerate Every Campaign."`
- Breadcrumb: Portfolio → Marketing → Catalyst
- Status badge: `LIVE` (green)
- Tech stack tags: Sales Cloud · Service Cloud · Experience Cloud · Agentforce · SLDS 2 · LWR
- CTAs: `"Request Org Access"` (primary) · `"View on GitHub"` (ghost)

#### 4.3.2 Narrative — Problem → Solution → Outcome

| | Content |
|---|---|
| **Problem** | Catalyst's 280-person B2B SaaS company operated across 5 disconnected tools — HubSpot, Zendesk, SharePoint, Looker, and email-based CPQ — with no unified pipeline governance, no SLA enforcement, and a 4-day quote turnaround. |
| **Solution** | A full Sales Cloud, Service Cloud, and Experience Cloud implementation built to SLDS 2 standards — including CPQ-lite quoting, Omni-Channel case routing, a branded LWR client portal, and an Agentforce AI assistant named Aria. |
| **Outcome** | All 8 business objectives met: pipeline governance from lead to closed-won, quote turnaround under 4 hours, SLA compliance enforced by tier, and a self-service portal with Agentforce deflection built in. |

#### 4.3.3 Screenshot Gallery

Full-width scrollable gallery. Each screenshot has a caption and requirement reference.

| # | Screenshot Subject | Caption / Req Reference |
|---|---|---|
| 1 | Sales Pipeline Kanban View | Opportunity pipeline showing all 6 stages — MKT-REQ-SALES-017 |
| 2 | Sales Leadership Dashboard | Real-time pipeline, forecast vs. quota, win/loss rate — OBJ-003 |
| 3 | Quote PDF (generated from org) | Branded quote with line items, discount, approval status — OBJ-002 |
| 4 | Service Console — Case with Context | Case record showing Account tier, ACV, health score — OBJ-004 |
| 5 | SLA Entitlement Milestone view | Visual SLA timeline with breach warning indicators — OBJ-005 |
| 6 | Knowledge Article — published | Article in published state showing review workflow — MKT-REQ-SRVC-011 |
| 7 | Experience Cloud Portal — Home | Catalyst Client Portal home with onboarding checklist — OBJ-007 |
| 8 | Aria — Agentforce Chat (in portal) | Aria answering a case status query in the client portal — MKT-REQ-EXP-012 |
| 9 | Onboarding Checklist component | Progress tracker showing step completion — OBJ-008 |
| 10 | Omni-Channel Supervisor Panel | Queue depth, agent availability, work assignment — MKT-REQ-SRVC-016 |
| 11 | Account Health Score on record | Composite health score with contributing factors — MKT-REQ-SALES-010 |
| 12 | Flow Builder — SLA Escalation Flow | Flow canvas showing escalation path logic — MKT-REQ-SRVC-008 |

#### 4.3.4 SDLC Documents Download Section

Card grid of downloadable documents. Each card: document ID, title, status badge, file type, download button.

| Doc ID | Title | Status |
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

---

### 4.4 About Page ( `/about` )

| Section | Contents |
|---|---|
| 1 | Professional summary — 3–4 sentences: QA engineering + Salesforce development positioning |
| 2 | Skills grid — grouped: Salesforce Platform · Testing & QA · Dev Tools · Design |
| 3 | Certifications — Trailhead badge display with issue dates |
| 4 | Experience timeline — previous roles, duration, key responsibilities |
| 5 | Currently studying — active Trailhead trails, superbadges in progress |

---

### 4.5 Contact Page ( `/contact` )

- Form fields: Name, Email, Company, Role, Message, "How did you find this portfolio?" (picklist)
- Submits via **Salesforce Web-to-Lead** — creates a Lead record in the org
- On submit: inline success message + confirmation email auto-sent from Salesforce
- Secondary: LinkedIn link · GitHub link · Email address

> **Note:** The Web-to-Lead integration means every recruiter enquiry is tracked in the Salesforce org — a subtle but powerful demonstration that the portfolio itself runs on Salesforce.

---

## 5. Authenticated Dashboard ( `/dashboard` )

The visual centrepiece of the portfolio. Accessible after login only — a deliberate reward for engaged recruiters and a controlled environment for interviews.

> **Phase 3 target:** This page is the primary candidate for the React/Next.js headless rebuild. Design it in Figma to the highest fidelity.

### 5.1 Layout Structure

- **Fixed left sidebar:** navigation between verticals, user info, logout
- **Top bar:** vertical selector dropdown, last-updated timestamp, refresh button
- **Main content:** scrollable grid of metric cards and chart panels
- **Grid:** 12-column — cards span 3, 4, 6, or 12 columns

---

### 5.2 Metric Cards

#### Row 1 — Code Quality

| Card | Data Source | Display | Status Logic |
|---|---|---|---|
| Apex Test Coverage % | Salesforce Tooling API | Large % number, radial progress ring | ≥85% = green · 70–84% = amber · <70% = red |
| Code Coverage Trend | Tooling API (historical) | Sparkline chart — last 30 days | Trending up = green · down = red |
| Classes with 0% Coverage | Tooling API | Integer count | 0 = green · >0 = red |
| Total Apex Classes | Tooling API | Integer count | Informational |

#### Row 2 — CI/CD Status

| Card | Data Source | Display | Status Logic |
|---|---|---|---|
| Branch Build Status | GitHub Actions API → Platform Event → Custom Object | Status pill per branch: main · develop · vertical/marketing · etc. | Pass = green · Fail = red · Running = amber pulse |
| Last Deploy Timestamp | GitHub Actions API | Relative time ("2 hours ago"), absolute on hover | Informational |
| Deploy Success Rate % | GitHub Actions API | % over last 30 deployments, bar chart | ≥95% = green · 85–94% = amber · <85% = red |
| Open PRs | GitHub API | Count with link to GitHub PR list | 0 = green · >0 = informational |

#### Row 3 — Quality & Defects

| Card | Data Source | Display | Status Logic |
|---|---|---|---|
| Open Defects | GitHub Issues (label: bug) | Count by severity: Critical · High · Medium · Low | Critical > 0 = red banner |
| Defect Resolution Rate | GitHub Issues API | % closed vs opened in last 30 days, trend arrow | ≥80% = green · 60–79% = amber · <60% = red |
| SDLC Doc Completion | Custom SF Object (`DocStatus__c`) | Progress bar per vertical — 9 docs each | 100% = green · <100% = amber |
| Test Cases Executed | Custom SF Object (`TestRun__c`) | Total count, pass/fail breakdown, donut chart | All pass = green · Any fail = red |

#### Row 4 — Performance Testing

| Card | Data Source | Display | Status Logic |
|---|---|---|---|
| Last Load Test Result | Custom SF Object (`PerfTestRun__c`) | Pass/Fail badge + date + scenario name | Pass = green · Fail = red |
| Page Load Time (avg) | Custom SF Object | ms value, colour-coded, trend sparkline | <3000ms = green · 3–5s = amber · >5s = red |
| Concurrent Users Tested | Custom SF Object | Max users tested in last run, scenario label | Informational |
| Governor Limit Headroom | Tooling API / Apex | % of limits used: SOQL · DML · CPU | <50% used = green · 50–80% = amber · >80% = red |

#### Row 5 — Agentforce & Live Data

| Card | Data Source | Display | Status Logic |
|---|---|---|---|
| Agentforce Sessions (total) | Einstein Usage API | Total conversation count since launch, trend | Informational |
| Agent Escalation Rate | Einstein Usage API | % sessions escalated to human, trend arrow | <20% = green · 20–40% = amber · >40% = red |
| Sample Record Counts | Salesforce REST API | Accounts · Contacts · Opportunities · Cases — count per vertical | Informational |
| Live API Status | SF Status API + GitHub Status | Green/red pill per service: SF Org · GitHub · Experience Cloud | All green = good · Any red = banner alert |

---

### 5.3 Dashboard Interactivity

- **Vertical selector:** switches all cards to selected vertical's data
- **Time range picker:** 7 days · 30 days · All time — affects trend charts and rates
- **Card click:** expands to full-width detail panel with raw data table and chart
- **Refresh button:** re-queries all data sources, updates last-updated timestamp
- **Export button:** downloads current dashboard state as PDF snapshot
- All charts use consistent cyan/teal palette with dark backgrounds

---

## 6. Component Library

All components must be designed in Figma with variants and auto-layout, then built as LWC (Phase 1) and React components (Phase 2). Every component requires a matching Jest test file.

| Component Name | Variants | Used On | LWC API Name |
|---|---|---|---|
| Metric Card | default · expanded · loading · error | Dashboard | `portfolioMetricCard` |
| Status Badge | live · in-progress · planned · pass · fail | All pages | `portfolioStatusBadge` |
| Vertical Card | default · hover · compact | Home, Portfolio | `portfolioVerticalCard` |
| Chart — Sparkline | up-trend · down-trend · flat | Dashboard metric cards | `portfolioSparkline` |
| Chart — Donut | pass/fail · completion | Dashboard | `portfolioDonutChart` |
| Chart — Bar | horizontal · vertical · stacked | Dashboard | `portfolioBarChart` |
| Agent Chat Widget | expanded · collapsed · loading | Home page, Portal | `portfolioAgentChat` |
| Screenshot Viewer | single · gallery · fullscreen | Case Study page | `portfolioScreenshotViewer` |
| Doc Download Card | available · pending | Case Study page | `portfolioDocCard` |
| Nav Bar | public · authenticated · mobile | All pages | `portfolioNavBar` |
| Progress Bar | linear · segmented | Dashboard, Onboarding | `portfolioProgressBar` |
| Timeline | vertical | About page, Case Study | `portfolioTimeline` |
| Stats Bar | 4-up · 6-up | Home page | `portfolioStatsBar` |
| Filter Bar | with search · without search | Portfolio page | `portfolioFilterBar` |
| API Status Pill | online · degraded · offline | Dashboard | `portfolioApiStatus` |

---

## 7. Figma File Structure

### 7.1 Page Organisation

| Figma Page | Contents |
|---|---|
| 🎨 Design System | Colour styles · Text styles · Spacing tokens · Component tokens · SLDS 2 mapping |
| 🧩 Component Library | All 15 components — all variants, auto-layout, annotated |
| 🏠 Home | Desktop (1440px) · Tablet (768px) · Mobile (375px) |
| 📋 Portfolio Grid | Desktop · Mobile · Filter bar states |
| 📄 Case Study — MKT | Desktop · Mobile — header, narrative, gallery, docs |
| 👤 About | Desktop · Mobile |
| 📬 Contact | Desktop · Mobile — default, validation, success states |
| 📊 Dashboard | Desktop only (data-dense — mobile Phase 2) |
| 📱 Mobile Nav | Open · Closed states |
| 🔄 Prototype Flows | Clickable prototype connections — use for interview demos |
| 📐 Redlines / Specs | Annotated specs for handoff — spacing, typography, interactions |

> **Naming convention:** `[PageName]/[Device]/[State]`  
> Example: `Home/Desktop/Default` · `Dashboard/Desktop/Catalyst` · `Contact/Mobile/Success`

### 7.2 Design-to-Code Handoff Checklist

- [ ] All colours reference Figma colour styles (not hardcoded hex)
- [ ] All text uses Figma text styles (not manual font settings)
- [ ] All components use auto-layout with named constraints
- [ ] All interactive states (hover, focus, active, error, loading) represented as variants
- [ ] Spacing uses 4px base unit consistently
- [ ] All assets exported at 1x, 2x, and SVG where applicable
- [ ] Component descriptions filled in (used as LWC documentation)
- [ ] Prototype flows completed: Home → Portfolio → Case Study and Home → Dashboard

---

## 8. Dashboard Data Architecture

| Metric Group | Source System | Collection Method | SF Storage |
|---|---|---|---|
| Apex Coverage % | Salesforce Tooling API | Apex REST callout on demand | `CoverageSnapshot__c` |
| CI/CD Build Status | GitHub Actions API | GitHub webhook → Platform Event | `BuildStatus__c` |
| Defect Count | GitHub Issues API | Scheduled Apex job (hourly sync) | `Defect__c` |
| SDLC Doc Completion | Manual / Claude Code | Updated in Salesforce directly | `DocStatus__c` |
| Test Run Results | Apex test execution | Post-deploy test run result stored | `TestRun__c` |
| Performance Tests | Manual test execution | Results entered via LWC form | `PerfTestRun__c` |
| Agentforce Sessions | Einstein Usage API | Scheduled Apex job (daily sync) | `AgentStat__c` |
| Sample Record Counts | Salesforce REST API | Real-time SOQL count on page load | Direct query |
| Live API Status | SF Status API + GitHub Status | Client-side fetch on dashboard load | Not stored — live |

> **Note:** Custom objects above (`CoverageSnapshot__c`, `BuildStatus__c`, etc.) will be fully defined in `MKT-TDD-1.0` with field-level specifications.

---

## 9. Next Steps

| # | Action | Owner | Phase |
|---|---|---|---|
| 1 | Set up Figma file using the page structure in Section 7 | Designer | Phase 1 |
| 2 | Define Figma colour styles and text styles from Section 2 | Designer | Phase 1 |
| 3 | Build Component Library page — all 15 components with variants | Designer | Phase 1 |
| 4 | Design Home page at 1440px, 768px, and 375px breakpoints | Designer | Phase 1 |
| 5 | Design Dashboard page at 1440px — highest fidelity priority | Designer | Phase 1 |
| 6 | Design remaining pages: Portfolio, Case Study, About, Contact | Designer | Phase 1 |
| 7 | Complete Figma prototype flows for interview demo scenarios | Designer | Phase 1 |
| 8 | Build custom SF objects for dashboard data storage (Section 8) | Developer | Phase 2 |
| 9 | Build LWC component library matching Figma designs using SLDS 2 | Developer | Phase 2 |
| 10 | Configure Experience Cloud LWR site using component library | Developer | Phase 2 |
| 11 | Wire dashboard data sources: Tooling API, GitHub webhook, Einstein Usage API | Developer | Phase 2 |
| 12 | Rebuild Dashboard page as React/Next.js headless component | Developer | Phase 3 |

---

*SF-PORTFOLIO-UX-1.0 · Draft · Portfolio Use Only*  
*Update status column in Section 9 as steps complete.*
