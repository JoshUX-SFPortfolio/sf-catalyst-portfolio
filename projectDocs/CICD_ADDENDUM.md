# CI/CD Strategy Addendum
**Document ID:** SF-PORTFOLIO-CICD-1.0  
**Parent:** SF Portfolio Framework — Master Project Plan v1.0  
**Status:** Planned — Implementation after MTF v1.0 stabilisation  
**Last Updated:** 2025

---

## Overview

This addendum defines the GitHub Actions CI/CD strategy for the Salesforce Portfolio Framework. It supplements Section 4 (Git Branching & SFDX Strategy) and Section 6 (Phased Delivery Plan) of the Master Project Plan.

CI/CD is intentionally deferred until the Master Template Foundation (MTF) reaches its `v1.0` stable tag (Phase A.9). Standing up automation before a known-good state exists creates pipeline noise rather than protection. Once `main` is stable and Apex test coverage is established, CI becomes a genuine quality gate rather than a configuration burden.

---

## Insertion Point

CI/CD is introduced **after Phase A.9 — MTF Stabilisation**, when the following conditions are met:

| Condition | Rationale |
|---|---|
| `main` branch tagged `v1.0` | A deployable state worth protecting exists |
| Apex test classes written | Tests can actually run in a CI scratch org |
| 85%+ coverage established | Coverage threshold is meaningful to enforce |
| Scratch org definition file stable | CI can spin up a reproducible environment |
| Catalyst vertical baselined | Sufficient metadata for deploy validation |

From this point forward, every subsequent vertical branch benefits from CI from day one.

---

## Workflow Suite

Four GitHub Actions workflows will be implemented in priority order.

---

### Workflow 1 — PR Validation
**Trigger:** `pull_request` targeting `develop`  
**Purpose:** Validate every feature branch before it touches the integration branch

```
Steps:
  1. Authenticate to Salesforce (JWT-based auth via GitHub Secrets)
  2. Create scratch org from project-scratch-def.json
  3. Deploy branch metadata to scratch org
  4. Run all Apex tests
  5. Assert coverage ≥ 85%
  6. Report pass/fail as PR status check
  7. Destroy scratch org
```

**Effect:** No unvalidated code reaches `develop`. Every PR shows a green or red deployment status inline.

---

### Workflow 2 — Develop Integration
**Trigger:** `push` to `develop`  
**Purpose:** Confirm the integrated state of `develop` is always deployable

```
Steps:
  1–6. Same as Workflow 1
  7. Post Slack/email notification on failure (optional)
  8. Destroy scratch org
```

**Effect:** `develop` is always in a known-good state. Protects `main` from bad integration merges.

---

### Workflow 3 — Main Branch Protection
**Trigger:** `pull_request` targeting `main`  
**Purpose:** Full validation gate before anything reaches the Master Template Foundation

```
Steps:
  1. Authenticate to Salesforce
  2. Create scratch org
  3. Deploy full main + incoming branch metadata
  4. Run all Apex tests
  5. Assert coverage ≥ 85%
  6. Run static analysis (PMD ruleset for Apex)
  7. Require passing status to merge (enforced via branch protection rule)
  8. Destroy scratch org
```

**Effect:** `main` is always deployable to the persistent Dev Edition org. The v1.0 tag and all subsequent tags are guaranteed clean.

---

### Workflow 4 — Vertical Drift Check ⭐
**Trigger:** `push` to `vertical/*`  
**Purpose:** Enforce the framework's architectural rule that vertical branches stay in sync with the core layer and never modify core-layer metadata

```
Steps:
  1. Compare vertical branch against main
  2. Flag if vertical branch has drifted from main by > 30 commits (sync reminder)
  3. Scan changed files — fail if any core-layer metadata path is modified
     Core paths: force-app/main/default/objects/standard/
                 force-app/main/default/permissionsets/core-*
                 force-app/main/default/flows/core-*
                 force-app/main/default/lwc/core-*
  4. Post warning annotation on PR if drift threshold is approaching
```

**Effect:** The framework's core/vertical separation is machine-enforced, not just a convention. Demonstrates architectural governance thinking — a strong portfolio signal.

---

## Secrets & Authentication

CI authenticates to Salesforce using **JWT-based connected app auth** — no passwords stored in GitHub. The following secrets are required in the GitHub repository settings:

| Secret Name | Description |
|---|---|
| `SF_CLIENT_ID` | Connected App consumer key |
| `SF_USERNAME` | Salesforce username for CI user |
| `SF_SERVER_KEY` | Base64-encoded JWT private key |
| `SF_INSTANCE_URL` | Target org login URL |

A dedicated CI user with minimal permissions will be created in the Dev Edition org. This follows the principle of least privilege defined in MKT-REQ-NFR-004.

---

## Branch Protection Rules

The following branch protection rules are configured in GitHub (some already active):

| Branch | Rule | Status |
|---|---|---|
| `main` | Require PR to merge — no direct pushes | ✅ Active |
| `main` | Require Workflow 3 to pass before merge | Planned — post v1.0 |
| `develop` | Require PR to merge — no direct pushes | Planned |
| `develop` | Require Workflow 1 to pass before merge | Planned |
| `vertical/*` | Require Workflow 1 to pass before merge | Planned |

---

## Additional Repository Hygiene (Implement Now)

The following can be added to the repo immediately, before CI is formally stood up:

| File | Purpose | Status |
|---|---|---|
| `.github/PULL_REQUEST_TEMPLATE.md` | Enforces consistent PR descriptions and checklists | ✅ Created |
| `.github/CODEOWNERS` | Auto-assigns reviewers by path | Planned |
| `README.md` | Portfolio-facing project overview | Planned |
| `CONTRIBUTING.md` | Documents branching and commit conventions | Planned |
| `.github/workflows/` | CI workflow YAML files | Planned — post v1.0 |

---

## CI as a Portfolio Artefact

The CI/CD setup will be documented as a standalone deliverable in the SDLC suite:

- Workflow design decisions recorded in a `CI-DESIGN.md` file in the repo
- Each workflow YAML will include inline comments explaining architectural choices
- The Vertical Drift Check (Workflow 4) in particular demonstrates custom governance tooling — worth calling out explicitly in portfolio case studies and interviews

---

## Delivery Timeline

```
Now          A.9 (v1.0 tag)      Post-Catalyst        Vertical 2+
 │                │                    │                   │
 ├── PR Template  ├── Workflow 1+2     ├── Workflow 3+4    ├── All workflows
 ├── Branch rules ├── Secrets setup    ├── CODEOWNERS      ├── active from
 └── This doc     └── CI user in org   └── CI design doc   └── branch creation
```

---

*This addendum is a living document. Update the Delivery Timeline section as phases complete.*
