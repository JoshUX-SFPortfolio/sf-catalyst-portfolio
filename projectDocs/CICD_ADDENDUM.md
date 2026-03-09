# CI/CD Strategy Addendum
**Document ID:** SF-PORTFOLIO-CICD-1.0  
**Parent:** SF Portfolio Framework — Master Project Plan v1.0  
**Status:** Deferred — Pinned Post-MKT Action Item (non-blocking for MKT closeout)  
**Last Updated:** 2026-03-09

---

## Overview

This addendum defines the GitHub Actions CI/CD strategy for the Salesforce Portfolio Framework. It supplements Section 4 (Git Branching & SFDX Strategy) and Section 6 (Phased Delivery Plan) of the Master Project Plan.

As of 2026-03-09, Track A is complete (`main` tagged `v1.0`) and Workflows 1+2 exist. The active recovery path is now:

1. Stabilize engineering baseline (tests + branch hygiene) before auth changes.
2. Rebuild JWT auth cleanly on a Connected App with canonical secret names and deterministic workflow guards.

Execution decision (2026-03-09):

- CI/Actions/Automation hardening remains documented and ready, but execution is **deferred** until all remaining MKT closeout work is complete.
- This item is **pinned** as the first post-MKT technical backlog action.
- MKT delivery decisions are not blocked by the current CI auth defect (`C-1016`) while this deferment is in effect.

---

## Recovery Sequence

### Stage 1 — Baseline Stabilization (Pre-CI Auth)

Required before further CI auth iteration:

- Local unit baseline is deterministic (`npm run test:unit` executable without ad-hoc flags).
- Org validation target is confirmed and non-empty for Apex test execution.
- Working tree is clean enough to avoid local source-tracking noise contaminating CI findings.

### Stage 2 — JWT Auth Rebuild (Connected App)

- Full reset of Salesforce CI auth secrets.
- Canonical secret source of truth = repository-level Actions secrets only.
- Connected App JWT path re-established with matching cert/private key pair.
- CI workflows updated to fail fast on missing secrets and avoid cleanup false negatives.

---

## Workflow Suite

Four GitHub Actions workflows are planned in priority order.

### Workflow 1 — PR Validation
**Trigger:** `pull_request` targeting `develop`  
**Purpose:** Validate every feature branch before it reaches the integration branch.

### Workflow 2 — Develop Integration
**Trigger:** `push` to `develop`  
**Purpose:** Validate the merged/integrated state of `develop`.

### Workflow 3 — Main Branch Protection
**Trigger:** `pull_request` targeting `main`  
**Purpose:** Full pre-merge quality gate for the Master Template Foundation.

### Workflow 4 — Vertical Drift Check
**Trigger:** `push` to `vertical/*`  
**Purpose:** Enforce core/vertical separation and drift guardrails.

---

## Secrets & Authentication (Canonical)

CI authenticates using **JWT-based Connected App auth**.

### Canonical secret scope

Use **repository-level Actions secrets only** for this project. Org-level secrets are not source-of-truth for CI in this repository.

### Required repository secrets

| Secret Name | Description |
|---|---|
| `SF_CLIENT_ID` | Connected App Consumer Key |
| `SF_USERNAME` | Salesforce username for CI user |
| `SF_INSTANCE_URL` | Login host for target org |
| `SF_SERVER_KEY` | **Raw PEM private key text** (not base64) |

### Key handling standard

- `SF_SERVER_KEY` is stored as raw PEM content.
- Workflow writes PEM directly to `server.key` and validates it with `openssl pkey`.
- This removes recurring base64 copy/paste corruption failures.

### Connected App setup standard

- App type: **Connected App** (not External Client App for this release cycle).
- OAuth enabled with scopes: `api`, `refresh_token/offline_access`, `web`.
- Upload matching `server.crt` to the Connected App.
- In Salesforce newer UI, keep **Issue JSON Web Token (JWT)-based access tokens for named users** disabled for CLI compatibility.
- Consumer Key from this Connected App populates `SF_CLIENT_ID`.
- `SF_USERNAME` and `SF_INSTANCE_URL` must target the same org where that Connected App exists.

---

## Branch Protection Rules

Current and target branch protections:

| Branch | Rule | Status |
|---|---|---|
| `main` | Require PR to merge — no direct pushes | ✅ Active |
| `develop` | Require status check context `validate` | ✅ Active |
| `main` | Require Workflow 3 to pass before merge | Planned |
| `vertical/*` | Require drift/validation checks | Planned |

---

## Repository Hygiene Status

| Item | Status |
|---|---|
| `.github/PULL_REQUEST_TEMPLATE.md` | ✅ Present |
| `.github/workflows/pr-validation.yml` | ✅ Present (updated for preflight + raw PEM) |
| `.github/workflows/develop-integration.yml` | ✅ Present (updated for preflight + raw PEM) |
| `scripts/ci/stage1-baseline-check.sh` | ✅ Added (Stage 1 baseline gate script) |
| `projectDocs/CI_JWT_RESET_RUNBOOK.md` | ✅ Added (secret reset + Connected App JWT runbook) |
| `.github/CODEOWNERS` | On `develop`; not present on this branch |
| `CONTRIBUTING.md` | On `develop`; not present on this branch |

---

## Acceptance Criteria

### Stage 1 acceptance

- `npm run test:unit` baseline passes locally without ad-hoc runner arguments.
- Org-side Apex test baseline is confirmed for CI target org context.
- Branch state is stable enough for deterministic CI verification.

### Stage 2 acceptance

- Manual local `sf org login jwt` succeeds with the four canonical secrets.
- `Develop Integration` passes JWT auth and proceeds to scratch org creation.
- `PR Validation` produces expected `validate` status check on PRs.
- Missing secret negative test fails with explicit preflight error.

---

## Delivery Timeline (Updated)

```
Now (2026-03-09)     Stage 1 Baseline      Stage 2 Auth Rebuild      Post-Recovery
      |                      |                       |                     |
      |                      |                       |                     |
  Workflow 1+2 present   Test stability gate    Connected App JWT      Workflow 3+4
  Rules on main/develop  + branch hygiene       + canonical secrets    rollout + hard gates
```

---

*This addendum is a living document. Update status and acceptance evidence as each stage is completed.*
