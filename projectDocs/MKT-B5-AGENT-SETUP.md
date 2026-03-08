# MKT-B5-AGENT-SETUP — Aria Agent Configuration Guide

| Field | Value |
|---|---|
| **Doc ID** | MKT-B5-AGENT-SETUP |
| **Phase** | B.5 — Per-Vertical Agent |
| **Agent** | Aria — Catalyst Client Assistant |
| **Org** | sf-portfolio (`josh.45ca40001658@agentforce.com`) |
| **Status** | Deployed — Agentforce Builder steps required |

---

## Overview

Aria is the Catalyst Marketing Technologies client self-service agent. She is embedded in the authenticated Catalyst Client Portal and handles four agent actions:

| Action | Apex Class | GenAiFunction | Status |
|---|---|---|---|
| Search Knowledge | `AriaSearchKnowledge` | `SearchKnowledge` | ✅ Deployed |
| Get Case Status | `AriaGetCaseStatus` | `GetCaseStatus` | ✅ Deployed |
| Get Onboarding Progress | `AriaGetOnboardingProgress` | `GetOnboardingProgress` | ✅ Deployed |
| Escalate To Agent | `AriaEscalateToAgent` | `EscalateToAgent` | ✅ Deployed |

All metadata is deployed. The following steps must be completed in the Agentforce Builder UI — they cannot be done via Metadata API.

---

## Deployed Metadata Summary

| Component | Type | Developer Name |
|---|---|---|
| Aria | GenAiPlanner | `Aria` |
| Client Self-Service | GenAiPlugin (Topic) | `ClientSelfService` |
| Search Knowledge | GenAiFunction | `SearchKnowledge` |
| Get Case Status | GenAiFunction | `GetCaseStatus` |
| Get Onboarding Progress | GenAiFunction | `GetOnboardingProgress` |
| Escalate To Agent | GenAiFunction | `EscalateToAgent` |
| AriaSearchKnowledge | ApexClass | — |
| AriaGetCaseStatus | ApexClass | — |
| AriaGetOnboardingProgress | ApexClass | — |
| AriaEscalateToAgent | ApexClass | — |

---

## Step 1 — Link the Topic to Aria in Agentforce Builder

The `GenAiPlanner → GenAiPlugin` link cannot be set via Metadata API v62.0. It must be wired in the Agentforce Builder UI.

1. In the org, go to **Setup > Agentforce > Agents**
2. Find **Aria** in the agents list (MasterLabel: `Aria`)
3. Click **Open in Agentforce Builder**
4. In the Topics panel, click **+ Add Topic**
5. Select **Client Self-Service** from the list
6. Confirm all 4 actions are shown under the topic:
   - Search Knowledge
   - Get Case Status
   - Get Onboarding Progress
   - Escalate To Agent
7. Click **Save**

---

## Step 2 — Set the System Prompt Template

The `GenAiPromptTemplate` type field is a restricted picklist that cannot be set via Metadata API. It must be configured in Prompt Builder.

1. Go to **Setup > Einstein > Prompt Builder**
2. Find **Aria System Prompt** in the template list
3. Open the template and verify the content reads as expected (it was authored in A.8):
   - Persona: Aria, professional, empathetic
   - Scope: case status, onboarding, knowledge search, escalation
   - Escalation instruction: confirm subject before escalating
4. If the `type` field is blank, set it to **Agent System Prompt** (or the available type for Agentforce)
5. Click **Save & Publish**
6. Return to Agentforce Builder > Aria > Settings and select **Aria System Prompt** as the system prompt template

---

## Step 3 — Activate the Agent

1. In Agentforce Builder with Aria open, click **Activate**
2. Aria's status changes from `Inactive` to `Active`
3. Confirm the activation — the agent is now live for the Experience Cloud site

---

## Step 4 — Link Aria to the Catalyst Client Portal

The `catalystAriaLauncher` LWC component (FAB toggle) is already deployed and placed on the portal home page. To connect it to the active Aria agent:

1. In Experience Builder for the Catalyst Client Portal, open the **Home** page
2. Click on the **catalystAriaLauncher** component in the canvas
3. In the right panel, set the **Agent API Name** property to: `Aria`
4. Click **Publish**

If the launcher component does not show a property for Agent API Name, the Embedded Service configuration must be set up first — see Step 5.

---

## Step 5 — Embedded Service Deployment (if required)

If the Aria chat window does not appear on the portal, the Embedded Service channel may need to be configured:

1. Go to **Setup > Embedded Service Deployments > New**
2. Select **Agentforce** as the deployment type
3. Name: `Catalyst Portal — Aria`
4. Select the **Catalyst Client Portal** as the Experience Cloud site
5. Select **Aria** as the agent
6. Copy the Embedded Service code snippet — paste into the `catalystAriaLauncher` component if needed
7. Activate the deployment

---

## Step 6 — Test the Agent

### Test via Agentforce Builder Preview
1. In Agentforce Builder with Aria open, click **Preview**
2. Enter test prompts:
   - `"What are my open support cases?"` → should invoke `GetCaseStatus`
   - `"How do I set up Campaign Intelligence?"` → should invoke `SearchKnowledge`
   - `"Where am I in my onboarding?"` → should invoke `GetOnboardingProgress`
   - `"I need to speak to someone"` → should invoke `EscalateToAgent` (with confirmation)

### Expected Behaviour
- **GetCaseStatus:** Returns a list of up to 5 open cases (empty for portal users with no cases in test context)
- **SearchKnowledge:** Returns article titles and summaries (empty until Knowledge add-on is enabled — graceful empty response expected)
- **GetOnboardingProgress:** Returns completion % and next step (0% if no Project record linked to the portal user's account)
- **EscalateToAgent:** Confirms case subject, creates a Case record with `Origin = Chat`

---

## Knowledge Base Note

The Catalyst Knowledge articles are authored and stored in `data/catalyst/knowledge_articles.csv` (10 articles covering core platform topics). These articles are ready for import once the Salesforce Knowledge add-on is enabled on this org.

To enable Knowledge: **Setup > Knowledge Settings > Enable Salesforce Knowledge**

To import articles once enabled:
```bash
# Knowledge import requires the Data Loader or a Knowledge-specific API
# Article CSV format matches: Title, UrlName, Summary, ArticleBody, PublishStatus, Language
# Use the Import Articles wizard in Setup > Knowledge > Article Management
```

Until Knowledge is enabled, `AriaSearchKnowledge` returns an empty list gracefully — Aria will respond: "I wasn't able to find an article on that topic" and offer to escalate.

---

## Verification Checklist

- [x] `AriaSearchKnowledge` Apex class deployed — 6/6 tests passing (Run ID: `707gL00000dWQHO`)
- [x] `SearchKnowledge` GenAiFunction deployed
- [x] `ClientSelfService` GenAiPlugin updated — all 4 functions linked
- [x] All 4 invocable actions verified via REST `/actions/custom/apex`
- [ ] Aria → Client Self-Service topic linked in Agentforce Builder
- [ ] System prompt type set in Prompt Builder
- [ ] Agent activated
- [ ] Portal launcher connected to Aria
- [ ] Agent preview tested with all 4 action scenarios

---

## Requirement Traceability

| Requirement | Description | Status |
|---|---|---|
| MKT-REQ-EXP-012 | Aria agent deployed and configured | ✅ Metadata deployed |
| MKT-REQ-EXP-013 | Agent actions: GetCaseStatus, GetOnboardingProgress, EscalateToAgent, SearchKnowledge | ✅ All 4 deployed |
| MKT-REQ-EXP-014 | Knowledge base articles authored | ✅ 10 articles in `knowledge_articles.csv` |
| MKT-REQ-EXP-015 | EscalateToAgent creates a pre-populated Chat case | ✅ Confirmed in test `testEscalateToAgent_createCase` |
