# Contributing — Salesforce Portfolio Framework

This document defines the branching model, commit conventions, and PR process for the SF Portfolio Framework. All contributors (including Claude Code sessions) must follow these conventions — they are enforced by CI and CODEOWNERS.

---

## Branch Model

| Branch | Purpose | Direct Push |
|---|---|---|
| `main` | Master Template Foundation — always deployable, tagged | Blocked |
| `develop` | Integration branch — always in a known-good state | Blocked |
| `feature/<description>` | All new work — one branch per logical unit | Allowed |
| `hotfix/<description>` | Urgent fixes to `main` or `develop` | Allowed |
| `vertical/<name>` | Industry vertical builds on top of the MTF core | Allowed |

### Rules

- `main` and `develop` require a PR to merge — direct pushes are blocked by branch protection.
- Feature branches are created from `develop`.
- Hotfix branches may be created from `main` when patching the stable baseline.
- Vertical branches are created from `main` and never merged back. They are standalone demo builds.
- A vertical branch may rebase from `main` to receive core layer updates — it never merges up.

---

## Branch Naming

```
feature/a7-experience-cloud
feature/cicd-workflows
hotfix/case-entitlement-null-pointer
vertical/marketing
vertical/environmental
```

Use lowercase kebab-case. Be descriptive but concise.

---

## Commit Format

```
<type>: <brief description>
```

| Type | When to use |
|---|---|
| `feat` | New feature or metadata (components, classes, flows, objects) |
| `fix` | Bug fix |
| `refactor` | Code restructure with no behaviour change |
| `test` | Test class additions or changes |
| `docs` | Documentation only (CLAUDE.md, README.md, projectDocs/) |
| `config` | Configuration changes (scratch org def, sfdx-project.json, CI YAML) |
| `[core-update]` | Change to the MTF core layer — flag explicitly for vertical branch awareness |

### Examples

```
feat: add case entitlement assignment flow
fix: correct SLA tier extraction for Enterprise prefix
refactor: extract entitlement logic into CaseService
test: add FeedbackSurveyServiceTest coverage for NPS edge cases
docs: phase A.6 close — update CLAUDE.md and lessons learned
config: add pr-validation workflow (Workflow 1)
[core-update] feat: add Portal_User_Group__c trigger handler
```

Commit after every logical unit of work. Never commit a broken state to any branch.

---

## Pull Request Process

1. Create a feature branch from `develop` (or `main` for hotfixes).
2. Do your work in small, logical commits following the format above.
3. Push the branch and open a PR against `develop` (or `main` for hotfixes).
4. Fill out the PR template fully — it is a portfolio artefact as much as the code.
5. Workflow 1 (PR Validation) will trigger automatically:
   - Creates a scratch org from `config/project-scratch-def.json`
   - Deploys branch metadata
   - Runs all Apex tests
   - Asserts org-wide coverage >= 85%
   - Deletes the scratch org
6. The PR must show a green CI check before merge.
7. Squash merge to `develop` — keep the integration branch history clean.
8. Delete the feature branch after merge.

---

## Test Coverage

- Minimum **85% org-wide Apex coverage** — CI will block PRs that drop below this threshold.
- All test classes must use `TestDataFactory` — never create test data inline.
- Assertions must be meaningful — do not write tests that only exercise DML without asserting outcomes.
- One test class per Apex class or controller.

---

## Core Layer Rule

The MTF core layer is the shared foundation that all vertical branches build on. Core-layer metadata must never be modified from a vertical branch.

**Core-layer paths:**

```
force-app/main/default/objects/standard/
force-app/main/default/permissionsets/core-*
force-app/main/default/flows/core-*
force-app/main/default/lwc/core-*
```

If a vertical branch needs a core-layer change:

1. Make the change on a `feature/*` branch.
2. Merge to `develop`, then promote to `main` via PR.
3. Tag the commit with `[core-update]` in the message.
4. Rebase all active vertical branches from the updated `main`.

Workflow 4 (Vertical Drift Check) — planned post-Catalyst — will machine-enforce this rule.

---

## Metadata Standards

- All metadata must be in SFDX source format — no unpackaged or untracked metadata.
- API version: **62.0** (as declared in `sfdx-project.json`).
- No hardcoded Salesforce IDs, record type names, or org-specific values. Use custom metadata or custom labels.
- SOQL: bulkified — no queries inside loops. Use `WITH USER_MODE` on all portal-facing queries.
- LWC: SLDS 2 design tokens only — no hardcoded colour or spacing values.
- Flows: `[Object]_[Trigger]_[Purpose]` naming convention. Description field required.

---

## CI/CD

| Workflow | Trigger | Purpose |
|---|---|---|
| PR Validation | PR targeting `develop` | Validate feature branch before merge |
| Develop Integration | Push to `develop` | Confirm integrated state is always deployable |
| Main Protection | PR targeting `main` | Full gate before touching the MTF stable baseline (planned) |
| Vertical Drift Check | Push to `vertical/*` | Enforce core/vertical separation (planned) |

All workflows use JWT-based Salesforce auth. No passwords stored in GitHub. Secrets are configured under **Settings → Secrets → Actions** in the repository.

---

*This document is version-controlled alongside the code. Update it when conventions change.*
