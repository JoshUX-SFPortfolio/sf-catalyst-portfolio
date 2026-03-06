# A.3 — OWD Manual Configuration Steps

Org-Wide Default (OWD) sharing settings cannot be deployed via SFDX metadata.
These must be configured manually in each target org after deployment.

## Setup Path

**Setup → Sharing Settings → Organization-Wide Defaults**

## Required OWD Settings

| Object | Default Access | Internal Access |
|---|---|---|
| Account | **Private** | Private |
| Contact | Controlled by Parent | — |
| Lead | **Private** | Private |
| Opportunity | **Private** | Private |
| Case | **Private** | Private |
| Knowledge | Public Read Only | Public Read Only |
| Quote | Controlled by Parent | — |
| Project__c | **Private** | Private |
| Asset_Item__c | Controlled by Parent | — |
| Feedback_Survey__c | **Private** | Private |
| Portal_User_Group__c | Controlled by Parent | — |
| Service_Region__c | Public Read Only | Public Read Only |

## Notes

- `Controlled by Parent` objects inherit from their parent's OWD automatically — no further configuration needed.
- Role hierarchy grants upward visibility for Private objects without sharing rules.
- Grant Access Using Hierarchies must remain **enabled** for Account, Lead, Opportunity, Case, Project__c, Feedback_Survey__c.

## Applies To

- Scratch org (`catalyst-scratch`)
- Developer Edition org (`sf-portfolio`)

Configure OWD before deploying sharing rules — sharing rules depend on the OWD being Private to function correctly.
