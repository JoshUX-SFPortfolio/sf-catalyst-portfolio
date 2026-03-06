## Summary
<!-- Briefly describe what this PR does and why. One paragraph is enough. -->



## Type of Change
<!-- Check all that apply -->
- [ ] 🏗️ Core layer change (affects `main` — requires extra scrutiny)
- [ ] 🎨 Vertical configuration (terminology, picklists, page layouts)
- [ ] ⚡ Automation (Flow, Process, Apex trigger)
- [ ] 🧩 LWC component (new or modified)
- [ ] 🔐 Security model (profile, permission set, sharing rule, OWD)
- [ ] 📊 Report / Dashboard
- [ ] 🤖 Agentforce (agent, topic, action, prompt)
- [ ] 📄 SDLC documentation
- [ ] 🐛 Bug fix
- [ ] ♻️ Refactor (no functional change)
- [ ] 🔧 Repo / CI configuration

---

## Related Documents
<!-- Link to any BRD requirement IDs, user stories, or design docs this PR fulfils -->

| Doc ID | Description |
|--------|-------------|
|        |             |

---

## Salesforce Org Changes

### Objects & Fields
<!-- List any new or modified custom objects, fields, or record types -->
- 

### Automation
<!-- List any Flows, Apex classes, triggers, or validation rules added or changed -->
- 

### Security
<!-- List any profile, permission set, or sharing rule changes -->
- 

### Experience Cloud
<!-- List any site, page, or component changes -->
- 

> Leave sections blank if not applicable — do not delete them.

---

## Pre-Merge Checklist

### Code Quality
- [ ] All Apex classes have corresponding test classes
- [ ] Test coverage is ≥ 85% for all new/modified classes
- [ ] Test classes use test factory pattern — no inline data creation
- [ ] No hardcoded IDs, credentials, or org-specific values
- [ ] No SOQL queries inside loops
- [ ] All user-facing error messages are meaningful

### Metadata & Config
- [ ] All changes retrieved via `sf project retrieve start` and committed
- [ ] No untracked metadata exists in the org that isn't in this PR
- [ ] Page layouts and record types are consistent with the data dictionary
- [ ] Picklist values follow the naming conventions in the TDD

### Security
- [ ] Principle of least privilege observed — no over-permissioning
- [ ] Guest User profile reviewed if Experience Cloud pages were changed
- [ ] Sharing rules reviewed if OWD or role hierarchy was changed

### Core Layer (complete only if Type of Change includes 🏗️)
- [ ] Change has been reviewed against the Master Project Plan core layer definition
- [ ] All vertical branches have been notified of the pending core update
- [ ] Commit message includes `[core-update]` tag for downstream tracking

### Documentation
- [ ] Relevant SDLC document updated or new document created if scope changed
- [ ] Inline comments added to complex Apex or Flow logic
- [ ] CHANGELOG or commit message is descriptive enough to understand without this PR

### Testing
- [ ] Manual testing completed in scratch org
- [ ] All existing Apex tests still pass
- [ ] Relevant BDD / data-driven test scenarios updated if behaviour changed

---

## Screenshots / Evidence
<!-- 
For UI changes (LWC, page layouts, Experience Cloud pages) paste before/after screenshots.
For Apex changes, paste the test run result showing coverage.
For Flow changes, paste a screenshot of the flow canvas or relevant path.
-->



---

## Deployment Notes
<!-- 
Anything the reviewer or deployer needs to know:
- Manual steps required before or after deploy?
- Data migration or seeding needed?
- Feature flags or custom settings to configure?
- Known issues or follow-up items?
-->



---

## Reviewer Guidance
<!-- 
Direct the reviewer's attention. What's the riskiest part of this change?
What should they look at most carefully?
-->


