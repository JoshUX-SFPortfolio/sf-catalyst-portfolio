# MKT-LL-1.0 — Lessons Learned

| Field | Value |
|---|---|
| **Doc ID** | MKT-LL-1.0 |
| **Document** | Lessons Learned — All Phases |
| **Owner** | Portfolio Developer |
| **Status** | Active — Living Document |
| **Last Updated** | A.9 MTF Stabilisation |

---

## Purpose

This document records every technical problem encountered during development, its root cause, and the correct solution. It is updated at the close of each phase. Its intent is to eliminate repeated research across sessions and to serve as a technical reference for all future phases and verticals.

**Update rule:** At phase close, append one entry per resolved problem using the standard format below. Commit alongside `CLAUDE.md` and `MEMORY.md`.

---

## Entry Format

```
### LL-NNN — Short Title
**Phase:** A.N — Phase Name
**Problem:** What was attempted and why it failed.
**Root Cause:** Platform constraint, schema mismatch, or incorrect assumption.
**Solution:** The exact correct value, command, or workaround.
```

---

## Index

| ID | Phase | Title |
|---|---|---|
| LL-001 | A.2 — Object Model | `forecastingEnabled` is not a valid scratch org setting |
| LL-002 | A.2 — Object Model | `enableExperienceBundleMetadata` placement in scratch def |
| LL-003 | A.2 — Object Model | `deleteConstraint` is invalid on MasterDetail fields |
| LL-004 | A.2 — Object Model | MasterDetail object sharingModel must be ControlledByParent |
| LL-005 | A.2 — Object Model | EncryptedText max length is 175, not 255 |
| LL-006 | A.3 — Security Model | Picklist validation rules must use ISPICKVAL not ISBLANK |
| LL-007 | A.4 — Automation Library | Entitlement.Status is not directly settable |
| LL-008 | A.4 — Automation Library | Asset_Item__c.Name is AutoNumber — never set it |
| LL-009 | A.4 — Automation Library | System.assertNull does not exist |
| LL-010 | A.4 — Automation Library | BillingCountry/BillingState fail with state/country picklists enabled |
| LL-011 | A.4 — Automation Library | Triggers fire after field-level defaults — isBlank guards are no-ops |
| LL-012 | A.4 — Automation Library | Knowledge__kav unavailable without Knowledge add-on |
| LL-013 | A.4 — Automation Library | Portal user context is null in sys-admin Apex test runs |
| LL-014 | A.4 — Automation Library | Custom Case fields need FLS grants via Admin profile |
| LL-015 | A.5 — LWC Components | __tests__ directories must be excluded from SFDX deploy |
| LL-016 | A.5 — LWC Components | lwc-fontSize/fontWeight tokens are internal and rejected |
| LL-017 | A.5 — LWC Components | Unused meta.xml property requires matching @api in JS |
| LL-018 | A.6 — Reports & Dashboards | Standard report type API names differ from display names |
| LL-019 | A.6 — Reports & Dashboards | scope=mine is not a valid report metadata value |
| LL-020 | A.6 — Reports & Dashboards | UserDateInterval invalid values |
| LL-021 | A.6 — Reports & Dashboards | Grouping fields cannot also appear in columns |
| LL-022 | A.6 — Reports & Dashboards | sortColumn must not be a grouping field in Summary reports |
| LL-023 | A.6 — Reports & Dashboards | ReportSummaryType does not accept Count |
| LL-024 | A.6 — Reports & Dashboards | Report description field max length is 255 chars |
| LL-025 | A.6 — Reports & Dashboards | Dashboard background colour fields are required |
| LL-026 | A.6 — Reports & Dashboards | dashboardColorScheme and componentChartTheme are invalid |
| LL-027 | A.6 — Reports & Dashboards | rowHeight is required and must be a positive integer |
| LL-028 | A.6 — Reports & Dashboards | Gauge/metric/table require all three indicator colour attributes |
| LL-029 | A.6 — Reports & Dashboards | showValues is not valid on Metric or Table components |
| LL-030 | A.6 — Reports & Dashboards | chartAxisRange is not valid on Gauge, Metric, or Table |
| LL-031 | A.6 — Reports & Dashboards | useReportChart:true avoids chart config validation errors |
| LL-032 | A.6 — Reports & Dashboards | folderShares with shareType=Role requires exact Role dev name |
| LL-033 | A.6 — Reports & Dashboards | runningUser must be a real org username |
| LL-034 | A.6 — Reports & Dashboards | CaseList field names differ from expected API names |
| LL-035 | A.6 — Reports & Dashboards | Activity report grouping field is TASK_TYPE not ACTIVITY_TYPE |
| LL-036 | A.7 — Experience Cloud | Metadata type is DigitalExperienceBundle not ExperienceBundle |
| LL-037 | A.7 — Experience Cloud | DigitalExperience child fullName format |
| LL-038 | A.7 — Experience Cloud | Valid CommunitiesSettings fields are limited |
| LL-039 | A.7 — Experience Cloud | sf community create requires explicit template name for LWR |
| LL-040 | A.7 — Experience Cloud | Community creation is asynchronous |
| LL-041 | A.7 — Experience Cloud | pageAccess valid values |
| LL-042 | A.7 — Experience Cloud | routeType and viewType must match exactly |
| LL-043 | A.7 — Experience Cloud | Branding BaseFont only accepts DXP token values |
| LL-044 | A.7 — Experience Cloud | geoBotsAllowed is not a valid sfdc_cms__site property |
| LL-045 | A.7 — Experience Cloud | Network profile names use display name, not API name |
| LL-046 | A.7 — Experience Cloud | New routes cannot be created via Metadata API in BYO LWR |
| LL-047 | A.8 — Agentforce | @InvocableMethod — only one per Apex class |
| LL-048 | A.8 — Agentforce | GenAiFunction invocationTarget is class name only, not ClassName.methodName |
| LL-049 | A.8 — Agentforce | GenAiFunction requires bundle folder structure (SDR adapter: bundle) |
| LL-050 | A.8 — Agentforce | GenAiFunction deploy fails if Apex @InvocableMethod not yet in org |
| LL-051 | A.8 — Agentforce | GenAiPlugin requires developerName and language fields |
| LL-052 | A.8 — Agentforce | GenAiPlugin genAiFunctions element format: child contains functionName |
| LL-053 | A.8 — Agentforce | GenAiPlugin deploy fails if referenced GenAiFunctions not deployed first |
| LL-054 | A.8 — Agentforce | GenAiPlanner→GenAiPlugin link set via Agentforce Builder UI (not Metadata API) |
| LL-055 | A.8 — Agentforce | GenAiPromptTemplate type is a restricted picklist — requires UI configuration |
| LL-056 | A.8 — Agentforce | PermissionSet fieldPermissions on required MasterDetail fields rejected |
| LL-057 | A.9 — MTF Stabilisation | No A.9-specific deploy issues — phase was documentation and test verification only |
| LL-058 | B.3 — Vertical Configuration | BillingState/BillingCountry fail in orgs with state/country picklists enabled |
| LL-059 | B.4 — Sample Data Load | Bulk API 2.0 enforces FLS even for System Administrator — explicit profile metadata required |
| LL-060 | B.4 — Sample Data Load | sf project deploy start returns "Unchanged" when org alias points to different org than source tracking |
| LL-061 | B.4 — Sample Data Load | Hardcoded RecordTypeIds from one org fail in all other orgs — resolve at runtime via SOQL |
| LL-062 | B.4 — Sample Data Load | MultiselectPicklist Bulk API import must use semicolon separators, not commas |
| LL-063 | B.4 — Sample Data Load | numberRecordsProcessed:None is a Bulk API 2.0 display quirk — verify counts via SOQL |
| LL-064 | B.5 — Per-Vertical Agent | Agentforce Builder rejects Apex invocable actions with collection outputs — error -1458072159 |
| LL-065 | B.5 — Per-Vertical Agent | GenAiPlanner metadata deploys GenAiPlannerDefinition but does NOT create an AIApplication in Agentforce Studio |
| LL-066 | B.6 — SDLC Phase 3: Quality | SDLC quality docs (TPQA, BDD, DDT, PTS) authored in B.1 as living documents — mark Complete at B.6 gate with actual test run evidence |
| LL-067 | B.7 — SDLC Phase 4: Delivery | DRP and PTS authored ahead of deployment in B.1 — fill in confirmed deploy date at B.7 gate; no TBD values should remain in released docs |
| LL-068 | B.8 — Portfolio Publish | Case study narrative is the B.8 deliverable — captures what was built, decisions made, and skills demonstrated; written as a recruiter-facing portfolio artefact |
| LL-069 | Post-B.8 — CI/CD Recovery | Connected App OAuth scope and token-mode drift can pass JWT login but fail scratch create (C-1016) and SOAP metadata operations |
| LL-070 | Post-B.8 — Delivery Governance | CI/Actions/Automation is pinned as deferred post-MKT backlog work; non-blocking for MKT closeout |

---

## A.2 — Object Model

### LL-001 — `forecastingEnabled` is not a valid scratch org setting

**Phase:** A.2 — Object Model

**Problem:** Used `"forecastingEnabled": true` in the `settings` block of `project-scratch-def.json`. The scratch org create command failed with a validation error.

**Root Cause:** `forecastingEnabled` is not a valid Salesforce scratch org settings field. Collaborative Forecasting is enabled via a different mechanism.

**Solution:** Use `"forecastingType": "CollaborativeForecasts"` inside the `settings` block instead.

---

### LL-002 — `enableExperienceBundleMetadata` placement in scratch def

**Phase:** A.2 — Object Model

**Problem:** Placed `"enableExperienceBundleMetadata": true` inside the `settings` block of the scratch def file. The org create command rejected it.

**Root Cause:** `enableExperienceBundleMetadata` is a feature flag, not a settings field. Settings and features are separate arrays in the scratch def schema.

**Solution:** Add `"ExperienceBundle"` to the `features` array in the scratch def file. Remove it from `settings` entirely.

---

### LL-003 — `deleteConstraint` is invalid on MasterDetail fields

**Phase:** A.2 — Object Model

**Problem:** Included `deleteConstraint` in a custom field definition for a MasterDetail relationship. Deployment failed.

**Root Cause:** `deleteConstraint` is only valid on Lookup relationship fields. MasterDetail fields always cascade-delete — the platform enforces this and does not accept the property.

**Solution:** Omit `deleteConstraint` entirely from MasterDetail field definitions.

---

### LL-004 — MasterDetail object sharingModel must be ControlledByParent

**Phase:** A.2 — Object Model

**Problem:** Set `sharingModel: ReadWrite` on a custom object that had a MasterDetail relationship. Deployment failed with a schema validation error.

**Root Cause:** Objects with a MasterDetail field cannot have an independent sharing model. Sharing is inherited from the parent object.

**Solution:** Set `sharingModel: ControlledByParent` on any object that has a MasterDetail relationship field.

---

### LL-005 — EncryptedText max length is 175, not 255

**Phase:** A.2 — Object Model

**Problem:** Created an EncryptedText field with `length: 255`. Deployment failed.

**Root Cause:** The Salesforce platform enforces a maximum length of 175 characters for EncryptedText fields, regardless of the value specified.

**Solution:** Set `length: 175` (or lower) for all EncryptedText custom fields.

---

## A.3 — Security Model

### LL-006 — Picklist validation rules must use ISPICKVAL not ISBLANK

**Phase:** A.3 — Security Model

**Problem:** Wrote a validation rule using `ISBLANK(PicklistField__c)` to check if a picklist field was empty. The deploy was accepted but the formula was flagged as unsupported.

**Root Cause:** `ISBLANK()` is not supported on picklist fields in Salesforce formula syntax. Picklist emptiness must be tested differently.

**Solution:** Use `ISPICKVAL(PicklistField__c, '')` to test whether a picklist field has no value selected.

---

## A.4 — Automation Library

### LL-007 — Entitlement.Status is not directly settable

**Phase:** A.4 — Automation Library

**Problem:** Attempted to set `Entitlement.Status = 'Active'` in Apex. The field is read-only and the record failed to save.

**Root Cause:** `Entitlement.Status` is a system-calculated formula field derived from the record's `StartDate` and `EndDate`. It cannot be set directly.

**Solution:** Set `StartDate` to today and `EndDate` to a future date. The platform will compute `Status = 'Active'` automatically.

---

### LL-008 — Asset_Item__c.Name is AutoNumber — never set it

**Phase:** A.4 — Automation Library

**Problem:** Attempted to set `Asset_Item__c.Name` in test data and in Apex service code. Insert failed because the field is read-only.

**Root Cause:** The `Name` field on `Asset_Item__c` is configured as an AutoNumber field (format `ASSET-{0000}`). AutoNumber fields are assigned by the platform on insert and cannot be written.

**Solution:** Never set `Asset_Item__c.Name` in Apex or test code. Omit it from insert and upsert operations entirely.

---

### LL-009 — System.assertNull does not exist

**Phase:** A.4 — Automation Library

**Problem:** Used `System.assertNull(value, 'message')` in a test class. Compilation failed — the method does not exist.

**Root Cause:** Salesforce Apex does not have a `System.assertNull()` method. This method exists in some other testing frameworks (e.g. JUnit) but not in Apex.

**Solution:** Use `System.assertEquals(null, value, 'message')` to assert that a value is null.

---

### LL-010 — BillingCountry/BillingState fail with state/country picklists enabled

**Phase:** A.4 — Automation Library

**Problem:** Set `BillingCountry = 'USA'` and `BillingState = 'TX'` in test Account records. Tests failed on insert because the values did not match the state/country picklist codes.

**Root Cause:** When State and Country picklists are enabled in the org, `BillingCountry` and `BillingState` fields only accept the specific ISO codes configured in the picklist (e.g. `US`, `TX`). Free-text values are rejected.

**Solution:** Omit `BillingCountry` and `BillingState` from test data entirely. They are not required for functional testing and their presence causes fragile org-specific failures.

---

### LL-011 — Triggers fire after field-level defaults — isBlank guards are no-ops

**Phase:** A.4 — Automation Library

**Problem:** Wrote a trigger handler that checked `if (String.isBlank(record.Status__c))` before setting a default value. In testing, the handler never set the value because the field always appeared populated.

**Root Cause:** Salesforce applies field-level default values before trigger execution. By the time a before-insert trigger fires, any field with a configured default is already populated. An `isBlank()` guard will never be true for such fields.

**Solution:** Remove the `isBlank()` guard if the field has a platform-configured default. Either trust the field default entirely, or overwrite the value unconditionally if trigger logic must take precedence.

---

### LL-012 — Knowledge__kav unavailable without Knowledge add-on

**Phase:** A.4 — Automation Library

**Problem:** Referenced the `Knowledge__kav` object in an Apex class. The class compiled in a scratch org with Knowledge enabled but the approach would break in orgs without the Knowledge licence.

**Root Cause:** `Knowledge__kav` is a platform object that only exists when the Salesforce Knowledge add-on is provisioned. Standard Apex compilation will fail if the object is not present.

**Solution:** Use dynamic SOSL via `Search.query()` and dynamic SOQL via `Database.query()` so the Apex compiles in all orgs regardless of the Knowledge licence. Wrap calls in `try/catch` and return empty results gracefully when the object is unavailable.

---

### LL-013 — Portal user context is null in sys-admin Apex test runs

**Phase:** A.4 — Automation Library

**Problem:** Portal controllers that read `UserInfo.getUserId()` and then look up `AccountId`/`ContactId` from the User record returned null in test assertions. Tests run as the sys-admin profile do not have portal user attributes set.

**Root Cause:** Portal-specific fields (`AccountId`, `ContactId` on the User object) are only populated for Community/Experience Cloud users. When tests run as a System Administrator, these fields are null.

**Solution:** All portal controllers must return null or empty results gracefully when `AccountId`/`ContactId` is null — do not throw exceptions. Validate actual portal behaviour through deployed component testing rather than Apex unit tests.

---

### LL-014 — Custom Case fields need FLS grants via Admin profile

**Phase:** A.4 — Automation Library

**Problem:** SOQL queries using `WITH USER_MODE` and DML using `insert as user` failed at runtime. The running user did not have field-level access to custom Case fields.

**Root Cause:** Custom fields added to an object do not automatically receive FLS grants on existing profiles. The `System Administrator` profile required explicit `fieldPermissions` entries for each new custom field.

**Solution:** Add `fieldPermissions` entries for all custom Case fields (`Affected_Module__c`, `Urgency__c`, `SLA_Tier_at_Creation__c`, `Resolution_Summary__c`, etc.) to `Admin.profile-meta.xml` with `editable: true` and `readable: true`. Deploy the profile alongside the object metadata.

---

## A.5 — LWC Components

### LL-015 — `__tests__` directories must be excluded from SFDX deploy

**Phase:** A.5 — LWC Components

**Problem:** Running `sf project deploy start` with LWC components failed. The deploy compiler rejected files inside `__tests__/` directories, flagging imports like `import { createElement } from 'lwc'` as invalid.

**Root Cause:** `__tests__/` directories contain Jest test files intended for local execution only. They use Node.js module syntax that is not valid LWC metadata. The SFDX deploy pipeline attempts to compile every file in the source directory.

**Solution:** Add `**/__tests__/**` to `.forceignore`. This excludes all Jest test files from deploy operations while keeping them in the repository for local Jest runs.

---

### LL-016 — lwc-fontSize and lwc-fontWeight tokens are internal and rejected

**Phase:** A.5 — LWC Components

**Problem:** Used `var(--lwc-fontSize3)` and `var(--lwc-fontWeightBold)` in LWC CSS files. The org's LWC compiler rejected these tokens with a validation error on deploy.

**Root Cause:** Tokens prefixed with `--lwc-*` are internal Salesforce platform tokens not intended for use in custom components. They are not part of the public SLDS 2 token API.

**Solution:** Replace with literal CSS values: `0.875rem` instead of `var(--lwc-fontSize3)`, `700` instead of `var(--lwc-fontWeightBold)`. Use public `--slds-*` or `--dxp-*` tokens where available.

---

### LL-017 — Unused meta.xml property requires matching @api in JS

**Phase:** A.5 — LWC Components

**Problem:** Declared a `<property>` element in a component's `.js-meta.xml` `<targetConfigs>` block but did not add the corresponding `@api` property in the JavaScript file. Deploy failed with a metadata validation error.

**Root Cause:** Every `<property>` declared in the meta.xml must have a corresponding public `@api` property in the component's JavaScript. The platform validates this pairing on deploy.

**Solution:** Either add the matching `@api` property to the JS file, or remove the `<property>` from meta.xml entirely if it is not needed.

---

## A.6 — Reports & Dashboards

### LL-018 — Standard report type API names differ from display names

**Phase:** A.6 — Reports & Dashboards

**Problem:** Used display-name-style strings (e.g. `Accounts`, `Cases`, `Opportunities`) as the `<reportType>` value in report metadata. Deploy failed with "invalid report type" errors.

**Root Cause:** Report metadata requires the internal API name of the report type, which differs from the UI display name. These can only be reliably discovered via the REST analytics API.

**Solution:** Use the correct API names: `AccountList` (Accounts), `CaseList` (Cases), `Opportunity` (Opportunities), `Activity` (Activities), `LeadList` (Leads). Discover others via `GET /services/data/v62.0/analytics/reportTypes`.

---

### LL-019 — `scope=mine` is not a valid report metadata value

**Phase:** A.6 — Reports & Dashboards

**Problem:** Set `<scope>mine</scope>` in report metadata to limit the report to the running user's records. Deploy rejected the value.

**Root Cause:** `mine` is a UI concept, not a valid metadata scope value. The Metadata API does not support per-user scope filtering in report XML.

**Solution:** Use `<scope>organization</scope>` in metadata. Per-user filtering can be achieved at runtime via report filters or dashboard running user settings, but cannot be encoded in the report XML itself.

---

### LL-020 — UserDateInterval invalid values

**Phase:** A.6 — Reports & Dashboards

**Problem:** Used `INTERVAL_CURRENT_FY`, `INTERVAL_LAST_N_DAYS`, `INTERVAL_LAST_N_FY`, `INTERVAL_LAST7`, and `INTERVAL_LAST3MONTHS` as `UserDateInterval` values. All were rejected on deploy.

**Root Cause:** These strings are not valid enum values for the `UserDateInterval` type in the Salesforce Report Metadata API.

**Solution:** Valid values are: `INTERVAL_CUSTOM`, `INTERVAL_THISFY`, `INTERVAL_LASTFY`, `INTERVAL_LAST30DAYS`, `INTERVAL_LAST7DAYS`. Use only these values. For other ranges, use `INTERVAL_CUSTOM` with explicit start/end dates.

---

### LL-021 — Grouping fields cannot also appear in columns

**Phase:** A.6 — Reports & Dashboards

**Problem:** Included a field in both the `<groupingsDown>` section and the `<columns>` section of a Summary report. Deploy failed with a schema violation.

**Root Cause:** In Salesforce report metadata, a field used as a grouping key cannot simultaneously appear as a detail column. The platform enforces mutual exclusivity.

**Solution:** Remove any field from `<columns>` if it is also used in `<groupingsDown>` or `<groupingsAcross>`.

---

### LL-022 — sortColumn must not be a grouping field in Summary reports

**Phase:** A.6 — Reports & Dashboards

**Problem:** Set `<sortColumn>` to a field that was also used as a `<groupingsDown>` grouping key. Deploy failed.

**Root Cause:** Summary format reports cannot sort by a grouping field in the `<sortColumn>` element. Grouping-based sorting is controlled separately.

**Solution:** Set `<sortColumn>` to a measure/aggregate field (e.g. `Amount`) or a non-grouping column. Remove it entirely if no explicit sort order is needed.

---

### LL-023 — ReportSummaryType does not accept Count

**Phase:** A.6 — Reports & Dashboards

**Problem:** Used `<reportSummaryType>Count</reportSummaryType>` to get a record count aggregate. Deploy failed with an invalid enum value error.

**Root Cause:** `Count` is not a valid value for the `ReportSummaryType` enum in the Salesforce Metadata API, even though the UI exposes a Count aggregate.

**Solution:** Valid values are: `Sum`, `Average`, `Maximum`, `Minimum`, `Unique`. For record counts, use the built-in record count row that all summary reports include automatically, or use `Unique` on an ID field as a proxy.

---

### LL-024 — Report description field max length is 255 chars

**Phase:** A.6 — Reports & Dashboards

**Problem:** Set a `<description>` value longer than 255 characters. Deploy failed with a field length validation error.

**Root Cause:** The `description` field on Report metadata has a platform-enforced maximum of 255 characters.

**Solution:** Keep all report `<description>` values to 255 characters or fewer.

---

### LL-025 — Dashboard background colour fields are required

**Phase:** A.6 — Reports & Dashboards

**Problem:** Omitted `backgroundEndColor`, `backgroundFadeDirection`, and `backgroundStartColor` from dashboard metadata. Deploy failed with missing required field errors.

**Root Cause:** These three fields are required in the Salesforce Dashboard Metadata API regardless of whether a gradient background is desired.

**Solution:** Always include all three fields. For a flat background, set both colour values to the same hex value and use `Diagonal` or `TopToBottom` for the direction. Example: `#FFFFFF`, `TopToBottom`, `#FFFFFF`.

---

### LL-026 — dashboardColorScheme and componentChartTheme are invalid

**Phase:** A.6 — Reports & Dashboards

**Problem:** Included `<dashboardColorScheme>` in the dashboard root element and `<componentChartTheme>` in individual dashboard components. Both caused deploy failures with "unknown field" errors.

**Root Cause:** Neither of these fields exists in the Salesforce Dashboard Metadata API schema.

**Solution:** Remove both fields entirely. Chart colour schemes are managed through the org's analytics settings and the dashboard's palette, not via metadata fields.

---

### LL-027 — rowHeight is required and must be a positive integer

**Phase:** A.6 — Reports & Dashboards

**Problem:** Omitted `rowHeight` from the `dashboardGridLayout` element. Deploy failed with "rowHeight must be positive" error.

**Root Cause:** `rowHeight` is a required field in the `dashboardGridLayout` schema. Omitting it or setting a non-positive value causes a validation failure.

**Solution:** Always include `<rowHeight>100</rowHeight>` (or another positive integer) in the `dashboardGridLayout` element.

---

### LL-028 — Gauge/metric/table require all three indicator colour attributes

**Phase:** A.6 — Reports & Dashboards

**Problem:** Included only one or two of the three indicator colour attributes on a gauge dashboard component. Deploy failed with missing attribute errors.

**Root Cause:** The Salesforce Dashboard Metadata API requires all three of `indicatorLowColor`, `indicatorMiddleColor`, and `indicatorHighColor` to be present on gauge and metric components. They cannot be partially specified.

**Solution:** Always include all three colour attributes on gauge and metric components, even if thresholds are not being used. Example: `#E74C3C` (low), `#F39C12` (middle), `#2ECC71` (high).

---

### LL-029 — showValues is not valid on Metric or Table components

**Phase:** A.6 — Reports & Dashboards

**Problem:** Included `<showValues>true</showValues>` on both chart components and metric/table components. Deploy failed on the metric and table components.

**Root Cause:** `showValues` is only a valid attribute for chart and gauge component types. The schema does not permit it on Metric or Table.

**Solution:** Remove `<showValues>` from all Metric and Table dashboard components. Only use it on Chart and Gauge component types.

---

### LL-030 — chartAxisRange is not valid on Gauge, Metric, or Table

**Phase:** A.6 — Reports & Dashboards

**Problem:** Included `<chartAxisRange>Auto</chartAxisRange>` on a gauge dashboard component. Deploy failed.

**Root Cause:** `chartAxisRange` is only valid on Chart-type components. Gauge, Metric, and Table components do not support this attribute.

**Solution:** Remove `<chartAxisRange>` from all non-chart dashboard components.

---

### LL-031 — useReportChart:true avoids chart config validation errors

**Phase:** A.6 — Reports & Dashboards

**Problem:** When specifying `<chartSummary>` and `<groupingColumn>` on chart components, deploys failed because the values did not exactly match the report's saved grouping configuration. Debugging the exact expected values was time-consuming.

**Root Cause:** When `useReportChart` is false (or absent), the platform validates that `chartSummary` and `groupingColumn` exactly match the report's grouping definitions. Any mismatch fails deploy.

**Solution:** Set `<useReportChart>true</useReportChart>` on all chart components. This delegates chart rendering to the report's own saved chart configuration, bypassing the cross-validation. The report's chart must be configured, but the dashboard component no longer needs to duplicate the settings.

---

### LL-032 — folderShares with shareType=Role requires exact Role dev name

**Phase:** A.6 — Reports & Dashboards

**Problem:** Used `<shareType>Role</shareType>` in report folder metadata `<folderShares>` with a role developer name that did not exist in the target org. Deploy failed with "invalid role" error.

**Root Cause:** Role-based folder shares require the referenced Role's developer name to exist in the org. In a fresh Developer Edition org, only the default roles exist.

**Solution:** For dev/demo orgs, use `<accessType>Public</accessType>` with no `<folderShares>` entries. Public folders are visible to all internal users and avoid role validation entirely.

---

### LL-033 — runningUser must be a real org username

**Phase:** A.6 — Reports & Dashboards

**Problem:** Left the `<runningUser>` element on a dashboard as a placeholder string. Deploy failed with a user lookup error.

**Root Cause:** The `<runningUser>` field must reference an actual username that exists in the target org. Placeholder or generic values fail the lookup.

**Solution:** Use the exact org username: `josh.45ca40001658@agentforce.com` for the `sf-portfolio` org. This value must match the actual org's user record.

---

### LL-034 — CaseList field names differ from expected API names

**Phase:** A.6 — Reports & Dashboards

**Problem:** Used `ACCOUNT_NAME` and `ESCALATED` as column field names in a CaseList report. Deploy accepted the XML but the fields were invalid at runtime.

**Root Cause:** Report field names in the CaseList report type use a relationship-prefixed notation discovered from the REST analytics API, not simple field API names.

**Solution:** Use `ACCOUNT.NAME` (not `ACCOUNT_NAME`) for the related Account name. Use `ESCALATION_STATE` (not `ESCALATED`) for the escalation flag. Custom fields are prefixed with the object: `Case.SLA_Tier_at_Creation__c` (not `SLA_Tier_at_Creation__c`). Always verify field names via `GET /services/data/v62.0/analytics/report-types/CaseList`.

---

### LL-035 — Activity report grouping field is TASK_TYPE not ACTIVITY_TYPE

**Phase:** A.6 — Reports & Dashboards

**Problem:** Used `ACTIVITY_TYPE` as the grouping column in an Activity report. Deploy failed with an invalid field name error.

**Root Cause:** The Activity report type uses `TASK_TYPE` as the field name for the Activity Type picklist. `ACTIVITY_TYPE` does not exist in the Activity report type schema.

**Solution:** Use `TASK_TYPE` for the Activity Type grouping field. The date field is `DUE_DATE`. Related name fields are `WHO_NAME` and `WHAT_NAME`.

---

## A.7 — Experience Cloud

### LL-036 — Metadata type is DigitalExperienceBundle not ExperienceBundle

**Phase:** A.7 — Experience Cloud

**Problem:** Used `ExperienceBundle` as the metadata type when attempting to retrieve and deploy the Experience Cloud site. All retrieve and list commands returned empty results or "metadata not found" errors.

**Root Cause:** The metadata type for LWR Experience Cloud sites is `DigitalExperienceBundle`, not `ExperienceBundle`. `ExperienceBundle` is a legacy type for older Aura-based sites.

**Solution:** Use `--metadata-type DigitalExperienceBundle` in all `sf org list metadata` and `sf project retrieve start` commands. The fullName format is `site/SiteName`.

---

### LL-037 — DigitalExperience child fullName format

**Phase:** A.7 — Experience Cloud

**Problem:** Attempted to retrieve individual DigitalExperience child components using incorrect fullName formats. Commands returned no results.

**Root Cause:** DigitalExperience child components use a compound fullName format that includes the parent bundle name, the component type, and the component name separated by dots.

**Solution:** The correct format is: `site/Catalyst_Client_Portal1.sfdc_cms__route/Home` and `site/Catalyst_Client_Portal1.sfdc_cms__view/home`. Always retrieve the full bundle rather than individual children to avoid format issues.

---

### LL-038 — Valid CommunitiesSettings fields are limited

**Phase:** A.7 — Experience Cloud

**Problem:** Included `enableExperienceBundleMetadata` and `enableReputationEnabled` in `Communities.settings-meta.xml`. Both fields were rejected on deploy.

**Root Cause:** The `CommunitiesSettings` metadata type has a restricted set of valid fields. The two fields used are not part of the schema.

**Solution:** Only two fields are valid in `CommunitiesSettings`: `enableNetworksEnabled` and `enableCommunityWorkspaces`. Omit all others.

---

### LL-039 — sf community create requires explicit template name for LWR

**Phase:** A.7 — Experience Cloud

**Problem:** Ran `sf community create` without specifying a template name. The command created an Aura-based site instead of a Lightning Web Runtime site.

**Root Cause:** The default template for `sf community create` is not the LWR runtime. The template must be explicitly specified.

**Solution:** Always include `--template-name "Build Your Own (LWR)"` when creating an LWR site: `sf community create --name "Name" --template-name "Build Your Own (LWR)" --url-path-prefix path -o alias`.

---

### LL-040 — Community creation is asynchronous

**Phase:** A.7 — Experience Cloud

**Problem:** Ran `sf community create` and immediately attempted to retrieve the site metadata. The retrieve failed because the site did not yet exist.

**Root Cause:** Community provisioning is an asynchronous background operation. The CLI command returns a job ID but the site is not ready until the background job completes.

**Solution:** After `sf community create`, poll the `BackgroundOperation` object: `SELECT Status FROM BackgroundOperation WHERE Id = 'jobId'`. Wait for `Status = 'Complete'` before attempting any retrieve or metadata operations on the new site.

---

### LL-041 — pageAccess valid values

**Phase:** A.7 — Experience Cloud

**Problem:** Set `"pageAccess": "Authenticated"` on Experience Cloud route metadata. Deploy failed with an invalid value error.

**Root Cause:** `Authenticated` is not a valid value for the `pageAccess` field in the sfdc_cms__route schema.

**Solution:** Valid values are `UseParent`, `Public`, and `RequiresLogin`. Use `RequiresLogin` for pages that require authentication.

---

### LL-042 — routeType and viewType must match exactly

**Phase:** A.7 — Experience Cloud

**Problem:** Set `routeType` and `viewType` to different values on the same route, or used custom string values (e.g. `"custom"`, `"standard"`). Deploy failed with schema validation errors.

**Root Cause:** The LWR route schema requires `routeType` and `viewType` to use specific values that correspond to the type of page. Arbitrary strings are not valid.

**Solution:** Use only system-defined values that match between `routeType` and `viewType`: `home`/`home`, `login-main`/`login-main`, etc. For custom pages in the BYO LWR template, pages must be created in Experience Builder UI first before metadata can be managed.

---

### LL-043 — Branding BaseFont only accepts DXP token values

**Phase:** A.7 — Experience Cloud

**Problem:** Set the `BaseFont` branding property to `'Inter', var(--dxp-g-root-font-family)` to use a custom Google Font with a fallback. Deploy accepted it but the org rejected the value at runtime.

**Root Cause:** LWR Experience Cloud branding properties only accept DXP design token values. Custom font strings, Google Fonts URLs, and mixed values are rejected.

**Solution:** Set `BaseFont` to a valid DXP token value only, e.g. `var(--dxp-g-root-font-family)`. Custom fonts must be injected via the site's CSS override file (`sfdc_cms__styles`), not via branding properties.

---

### LL-044 — geoBotsAllowed is not a valid sfdc_cms__site property

**Phase:** A.7 — Experience Cloud

**Problem:** Included `geoBotsAllowed` in the site content JSON. Deploy failed because the schema has `additionalProperties: false`.

**Root Cause:** The `sfdc_cms__site` content schema is strict — it does not allow any properties beyond those explicitly defined in the schema. `geoBotsAllowed` is not in the schema.

**Solution:** Remove `geoBotsAllowed` and any other non-schema properties from the site content JSON. Only include properties that are part of the published sfdc_cms__site schema.

---

### LL-045 — Network profile names use display name, not API name

**Phase:** A.7 — Experience Cloud

**Problem:** Used `CustomerCommunityPlusUser` (API name format) in the Network metadata `<networkMemberGroups>` profile element. Deploy failed with a profile lookup error.

**Root Cause:** Network metadata `<profile>` elements require the exact profile display name as it appears in the Salesforce UI, including spaces. The API name format is not accepted.

**Solution:** Use `Customer Community Plus User` (with spaces). Query the org for the correct profile display name if uncertain: `SELECT Name FROM Profile WHERE Name LIKE '%Community%'`.

---

### LL-046 — New routes cannot be created via Metadata API in BYO LWR

**Phase:** A.7 — Experience Cloud

**Problem:** Created new `sfdc_cms__route` and `sfdc_cms__view` metadata files and attempted to deploy them to add new pages to the Experience Cloud site. Deploy returned error code `-2081040841` ("unexpected error") for all new routes.

**Root Cause:** The Build Your Own (LWR) Experience Cloud template does not support creating new routes via the Metadata API. This is a platform-enforced limitation. New pages must be created through the Experience Builder UI, after which the resulting metadata can be retrieved and managed via the Metadata API.

**Solution:** Create all new pages in Experience Builder UI first. Then retrieve the metadata (`sf project retrieve start --metadata "DigitalExperienceBundle:site/SiteName"`), commit the retrieved files, and manage subsequent updates via the Metadata API. Document page designs as repository artefacts so the UI creation step is guided.

---

## A.8 — Agentforce

### LL-047 — @InvocableMethod — only one per Apex class

**Phase:** A.8 — Agentforce

**Problem:** Initial design placed three `@InvocableMethod` methods (`getCaseStatus`, `getOnboardingProgress`, `escalateToAgent`) in a single `AriaActionController` class. Deploy failed: `Only one method per type can be defined with: InvocableMethod`.

**Root Cause:** Salesforce platform constraint — only one `@InvocableMethod` annotation is permitted per Apex class. Each `@InvocableMethod` must have distinct input/output types and cannot be co-located in the same class.

**Solution:** Split into three separate Apex classes: `AriaGetCaseStatus`, `AriaGetOnboardingProgress`, `AriaEscalateToAgent`. The original class was rewritten as a shared utility (`AriaActionController`) with helper methods only.

---

### LL-048 — GenAiFunction invocationTarget is class name only

**Phase:** A.8 — Agentforce

**Problem:** GenAiFunction XML files had `<invocationTarget>AriaGetCaseStatus.getCaseStatus</invocationTarget>` (ClassName.methodName format). Deploy failed: `InvocableTarget not found`.

**Root Cause:** The `invocationTarget` for Apex-backed GenAi functions is the **Apex class name only** — matching the value registered in the Actions API at `/services/data/v62.0/actions/custom/apex`. The method name is implicit.

**Solution:** Use just the class name: `<invocationTarget>AriaGetCaseStatus</invocationTarget>`. Confirm valid values via: `curl .../services/data/v62.0/actions/custom/apex | python3 -c "import json,sys; [print(a['name']) for a in json.load(sys.stdin)['actions']]"`.

---

### LL-049 — GenAiFunction requires bundle folder structure

**Phase:** A.8 — Agentforce

**Problem:** Placed GenAiFunction XML files as flat files (`genAiFunctions/GetCaseStatus.genAiFunction-meta.xml`). CLI returned `ExpectedSourceFilesError` — could not map files to type.

**Root Cause:** The SDR (Source Deploy Retrieve) registry marks `GenAiFunction` as `adapter: bundle` with `strictDirectoryName: true`. This requires each function to be in its own named subdirectory: `genAiFunctions/<DeveloperName>/<DeveloperName>.genAiFunction-meta.xml`. The org's SOAP `describeMetadata` response shows a suffix, but the local CLI registry takes precedence for source deploy.

**Solution:** Structure as: `force-app/main/default/genAiFunctions/GetCaseStatus/GetCaseStatus.genAiFunction-meta.xml`. This applies to `GenAiPlannerBundle` as well (though that type was not deployable via Metadata API — see LL-054).

---

### LL-050 — GenAiFunction deploy fails if Apex @InvocableMethod not yet in org

**Phase:** A.8 — Agentforce

**Problem:** Attempted to deploy GenAiFunctions before Apex classes were deployed. Deploy failed with `InvocableTarget not found` even though class names were correct.

**Root Cause:** GenAiFunction metadata references Apex `@InvocableMethod` actions by their registered name. If the Apex class has not been deployed, the action does not exist in the org's action registry and the reference fails at deploy time.

**Solution:** Always deploy Apex classes first, then deploy GenAiFunction metadata. Verify the action is registered: `curl .../services/data/v62.0/actions/custom/apex` — the class name must appear in the response before GenAiFunctions can reference it.

---

### LL-051 — GenAiPlugin requires developerName and language fields

**Phase:** A.8 — Agentforce

**Problem:** Initial GenAiPlugin XML omitted `developerName` and `language`. Two separate deploy failures: first `Required field is missing: developerName`, then `Required field is missing: language`.

**Root Cause:** `GenAiPlugin` metadata requires both `developerName` (the API name) and `language` (locale code) in addition to `masterLabel`, `pluginType`, `description`, and `scope`.

**Solution:** Include `<developerName>ClientSelfService</developerName>` and `<language>en_US</language>` in the XML. Element order: `description`, `developerName`, `language`, `masterLabel`, `pluginType`, `scope`, then `genAiFunctions`.

---

### LL-052 — GenAiPlugin genAiFunctions child element format

**Phase:** A.8 — Agentforce

**Problem:** Multiple incorrect element formats tried for function references in GenAiPlugin: `<genAiFunctions><genAiFunction>`, `<functions><functionName>`, `<genAiFunctions>DeveloperName</genAiFunctions>` (flat text). All produced schema parse errors or missing field errors.

**Root Cause:** The correct format is `<genAiFunctions>` as a repeating parent element with `<functionName>` as the child, referencing the GenAiFunction developer name. The Tooling API object `GenAiPluginFunctionDef` has a `Function` field — the XML maps this as `<functionName>`.

**Solution:**

```xml
<genAiFunctions>
    <functionName>GetCaseStatus</functionName>
</genAiFunctions>
<genAiFunctions>
    <functionName>GetOnboardingProgress</functionName>
</genAiFunctions>
<genAiFunctions>
    <functionName>EscalateToAgent</functionName>
</genAiFunctions>
```

---

### LL-053 — GenAiPlugin deploy fails if referenced GenAiFunctions not deployed first

**Phase:** A.8 — Agentforce

**Problem:** Deployed GenAiPlugin with `<functionName>` references before GenAiFunctions existed in the org. Deploy returned an "unexpected error" with error code `-2081102045` (no line number — server-side failure, not a parse error).

**Root Cause:** GenAiPlugin validates that the referenced `GenAiFunction` developer names exist in the org at deploy time. If they don't exist, the server-side validation fails with an opaque error.

**Solution:** Deploy GenAiFunctions first, verify they are in the org (`sf data query --use-tooling-api -q "SELECT DeveloperName FROM GenAiFunctionDefinition"`), then deploy GenAiPlugin.

---

### LL-054 — GenAiPlanner→GenAiPlugin link set via Agentforce Builder UI

**Phase:** A.8 — Agentforce

**Problem:** Attempted to link `GenAiPlanner` to `GenAiPlugin` via XML element `<genAiPlugins>`. Multiple element names tried (`<plugin>`, `<pluginName>`, `<genAiPlugin>`, flat text `ClientSelfService`). Each produced a different parse or reference error.

**Root Cause:** The `GenAiPlannerFunctionDef.Plugin` field is a **dynamic restricted picklist** populated from the `GenAiPluginDefinition` registry. Newly deployed plugins are not immediately available in this picklist due to caching. Additionally, the correct XML element structure for linking a planner to a plugin is not settable via Metadata API in API version 62.0 — this link is managed through the Agentforce Builder UI.

**Solution:** Deploy `GenAiPlanner` with only `masterLabel`, `description`, and `plannerType`. After deployment, navigate to Setup → Agents → select the planner → assign the plugin topic in Agentforce Builder. Do not attempt to set `genAiPlugins` in the Planner XML for API v62.0.

---

### LL-055 — GenAiPromptTemplate type is a restricted picklist requiring UI configuration

**Phase:** A.8 — Agentforce

**Problem:** GenAiPromptTemplate requires a `<type>` element referencing a `GenAiPromptTemplateType` record. Multiple values attempted (`einstein_gpt__default`, `AiCopilot__SystemPrompt`, etc.) — all rejected as `bad value for restricted picklist field`. `GenAiPromptTemplateType` records are not queryable via SOQL or Tooling API. No REST endpoint exposes valid type values.

**Root Cause:** The `GenAiPromptTemplate.Type` picklist is an internal lookup to `GenAiPromptTemplateType` platform records. These records are managed by Salesforce and the correct developer name values depend on what managed packages are installed in the org. They are not exposed through any queryable API.

**Solution:** Author the full prompt template content in the XML file (`<templateVersions><content>...</content><status>Published</status></templateVersions>`). Deploy without the `<type>` element (produces validation error about missing type). The `type` must be selected in the Agentforce Builder UI or Prompt Builder when creating the agent. Alternatively, retrieve the template after creating it in the UI to capture the correct type value for future deployments.

---

### LL-056 — PermissionSet fieldPermissions on required MasterDetail fields rejected

**Phase:** A.8 — Agentforce

**Problem:** Added a `fieldPermissions` entry for `Project__c.Account__c` in `Agentforce_Service_User.permissionset-meta.xml`. Deploy failed: `You cannot deploy to a required field: Project__c.Account__c`.

**Root Cause:** `Project__c.Account__c` is a required `MasterDetail` field — the platform does not allow modifying FLS grants on required fields. Required fields always have implicit read access regardless of FLS settings.

**Solution:** Remove all `fieldPermissions` entries for required fields (MasterDetail relationship fields, required custom fields). Only include FLS grants for optional/nullable fields.

---

## A.9 — MTF Stabilisation

### LL-057 — No deploy issues in A.9 — documentation and test verification only

**Phase:** A.9 — MTF Stabilisation

**Problem:** N/A — A.9 contained no new metadata deployments.

**Root Cause:** A.9's scope was: full test suite verification, documentation updates (CLAUDE.md, README.md), and tagging `develop` as `v1.0`. No new Salesforce metadata was authored or deployed.

**Solution:** A.9 closed clean. 77/77 Apex tests passing at phase gate (100% pass rate, Run ID: `707gL00000dTLNr`). `develop` tagged `v1.0` as the MTF baseline snapshot.

---

## B.3 — Vertical Configuration

### LL-058 — BillingState/BillingCountry fail in orgs with state/country picklists enabled

**Phase:** B.3 — Vertical Configuration / B.4 — Sample Data Load

**Problem:** Attempted to import Account records with `BillingState` values such as `"CA"`, `"NY"`, `"TX"`. The Bulk API 2.0 job returned validation errors for every record.

**Root Cause:** Developer Edition orgs have state and country picklists enabled by default. When this feature is on, `BillingState` and `BillingCountry` are restricted picklist fields — free-text ISO abbreviations are rejected. The platform expects the picklist's internal value (a specific string tied to the enabled picklist dataset).

**Solution:** Remove `BillingCity`, `BillingState`, and `BillingCountry` from both the CSV import file and the import script's field list. These fields are not essential for the portfolio's functional demonstrations and are safer to omit entirely.

---

## B.4 — Sample Data Load

### LL-059 — Bulk API 2.0 enforces FLS even for System Administrator

**Phase:** B.4 — Sample Data Load

**Problem:** Imported Account records via Bulk API 2.0 using the System Administrator profile. All records failed with `InvalidBatch: Field name not found` for every Catalyst custom Account field (`Subscription_Tier__c`, `Modules_Purchased__c`, etc.) despite the fields existing in the org.

**Root Cause:** Bulk API 2.0 enforces Field-Level Security (FLS) regardless of profile admin status. A custom field is invisible to the Bulk API unless the running user's profile has explicit `readable` and `editable` permissions granted via profile metadata. The System Administrator profile does not automatically receive FLS on custom fields deployed from metadata — they must be explicitly added.

**Solution:** Add `<fieldPermissions>` entries to `force-app/main/default/profiles/Admin.profile-meta.xml` for each custom Account field. For editable fields set both `<editable>true</editable>` and `<readable>true</readable>`. For roll-up summaries (`Open_Case_Count__c`) and formula fields (`Duplicate_Domain_Flag__c`) set `<editable>false</editable>`. Deploy the profile metadata, then re-run the import.

---

### LL-060 — sf project deploy returns "Unchanged" when org alias differs from source-tracked org

**Phase:** B.4 — Sample Data Load

**Problem:** Running `sf project deploy start --source-dir force-app/main/default/profiles/Admin.profile-meta.xml` returned status `Unchanged` immediately. The custom Account fields were not being deployed even though they were missing from the org.

**Root Cause:** The `sf-portfolio` alias points to org `00DgL00000MSWt7UAH`, but local SFDX source-tracking data in `.sf/orgs/` was for a different org (`00DAw00000CoHI9MAN`). SFDX compared the local source hash against the wrong org's tracking data, concluded nothing had changed, and skipped the deploy.

**Solution:** Add `--ignore-conflicts` to force a fresh deploy regardless of tracking state: `sf project deploy start --source-dir force-app/main/default/profiles/Admin.profile-meta.xml --ignore-conflicts`. Independently verify field existence using the Tooling API: `SELECT QualifiedApiName FROM FieldDefinition WHERE EntityDefinition.QualifiedApiName = 'Account'` — this bypasses any stale describe cache.

---

### LL-061 — Hardcoded RecordTypeIds are org-specific and fail in every other org

**Phase:** B.4 — Sample Data Load

**Problem:** Opportunity and Case CSV files contained RecordTypeId values like `012Aw000007f3HKIAY`. The import script passed these directly to the Bulk API, which rejected every record with `INVALID_CROSS_REFERENCE_KEY`.

**Root Cause:** Salesforce RecordType IDs are org-specific 18-character identifiers that differ between every org (scratch org, Developer Edition, sandbox, production). A CSV generated against one org will always fail in another org.

**Solution:** Replace hardcoded IDs in CSVs with the RecordType `DeveloperName` (e.g. `Technical_Support`, `New_Business`). In the import script, query `RecordType` by `DeveloperName` and `SobjectType` at runtime to build a lookup map, then resolve the ID before submitting to the Bulk API:

```python
rt_records = sf_query(
    "SELECT Id, DeveloperName, SobjectType FROM RecordType "
    "WHERE SobjectType IN ('Opportunity','Case') LIMIT 50"
)
rt_map = {(r['SobjectType'], r['DeveloperName']): r['Id'] for r in rt_records}
```

---

### LL-062 — MultiselectPicklist Bulk API import must use semicolon separators

**Phase:** B.4 — Sample Data Load

**Problem:** Initial drafts of the `Modules_Purchased__c` values used comma separators (e.g. `Campaign Intelligence,Attribution Engine`). The Bulk API accepted the records but stored the value as a single concatenated string rather than two selected picklist values.

**Root Cause:** Salesforce MultiselectPicklist fields use semicolons as the delimiter between selected values — both in the UI and in the API. The Bulk API respects this convention: a comma is treated as part of the value string, not as a separator.

**Solution:** Use semicolons in CSV data for MultiselectPicklist fields: `Campaign Intelligence;Attribution Engine`. Validate the import result by running a SOQL query with `INCLUDES()` to confirm each value resolves correctly.

---

### LL-063 — numberRecordsProcessed: None is a Bulk API 2.0 display quirk

**Phase:** B.4 — Sample Data Load

**Problem:** The Python import script printed `Leads: numberRecordsFailed=60` and `numberRecordsProcessed=None` after the Leads import step, suggesting all 60 records failed.

**Root Cause:** The Bulk API 2.0 `jobInfo` endpoint returns `null` for `numberRecordsProcessed` during and immediately after certain job states when the script uses a temp-file upload approach. The Python `simple_salesforce` library serialises `null` as Python `None`, which the script formatted as "failed". The actual record counts were not reflected in this field at query time.

**Solution:** Do not rely solely on the `jobInfo` response fields for import verification. After each step, run a SOQL count query with `WHERE CreatedDate = TODAY` to confirm actual record creation: `SELECT COUNT() FROM Lead WHERE CreatedDate = TODAY`. In the Leads case, 59 of 60 records were successfully created despite the misleading `numberRecordsFailed` display value.

---

## B.5 — Per-Vertical Agent

### LL-064 — Agentforce Builder rejects Apex invocable actions with collection outputs

**Phase:** B.5 — Per-Vertical Agent

**Problem:** Adding Apex invocable actions (GetCaseStatus, GetOnboardingProgress, SearchKnowledge) to a topic in Agentforce Builder via the Actions picker failed with internal server error `-1458072159`. The `EscalateToAgent` action added successfully. Selecting and clicking "Add to Agent" consistently produced the error regardless of whether `callout=true` was set or `@InvocableVariable` labels were added.

**Root Cause:** Agentforce Builder in Developer Edition orgs (Winter '26 / Spring '26) cannot add Apex invocable actions that return a `List<Result>` where `Result` contains multiple `@InvocableVariable` fields. The platform appears to require either: (a) a single output string, or (b) is affected by an unresolved platform bug specific to DE orgs. `EscalateToAgent` worked because its output shape is a single `Result` with two simple string fields (`caseId`, `caseNumber`), while the failing actions had 4+ output fields or returned data with no guaranteed single-record output.

Restructuring the three failing actions to return a single `Result` with one `String` field (the data serialised as plain text) did not resolve the error — it persists regardless of output shape.

**Solution:** Agent deployed with `EscalateToAgent` only for B.5. The other three actions (GetCaseStatus, GetOnboardingProgress, SearchKnowledge) remain deployed as Apex invocable actions and are verified via the REST API (`/actions/custom/apex`). They can be wired in Agentforce Builder when the platform bug is resolved or when tested in a non-DE org. Logged as a known platform limitation for Developer Edition.

**Workaround for future verticals:** Test action addition in a scratch org or sandbox rather than DE. Alternatively, expose actions via Flow instead of direct Apex to bypass the Builder UI restriction.

---

### LL-065 — GenAiPlanner metadata does not create an AIApplication in Agentforce Studio

**Phase:** B.5 — Per-Vertical Agent

**Problem:** After deploying `GenAiPlanner` metadata (Aria, `plannerType: AiCopilot__ReAct`), Agentforce Studio showed "0 agents". The `GenAiPlanner` was not visible anywhere in the UI.

**Root Cause:** The `GenAiPlanner` Metadata API type deploys a `GenAiPlannerDefinition` Tooling API record — but Agentforce Studio lists `AIApplication` records, which are a separate object. No `AIApplication` is created by deploying a `GenAiPlanner`. The two are not automatically linked.

**Solution:** Create the agent manually in Agentforce Studio (New Agent > describe purpose in the text prompt > agent is created with default topics). Then attach the deployed `ClientSelfService` `GenAiPlugin` topic via the Topics panel. The `GenAiPlannerDefinition` record created by the metadata deploy appears unused by the UI — it may be a legacy or internal record type. For all future agents, treat Agentforce Builder as the authoritative creation path; use metadata only for the `GenAiPlugin` (Topic) and `GenAiFunction` records.

---

## B.6 — SDLC Phase 3: Quality

### LL-066 — SDLC quality documents authored as living drafts in B.1 — close at B.6 gate

**Phase:** B.6 — SDLC Phase 3: Quality

**Problem:** The four B.6 quality documents (MKT-TPQA-1.0, MKT-BDD-1.0, MKT-DDT-1.0, MKT-PTS-1.0) were produced in full during B.1 (SDLC Phase 1: Business) to demonstrate documentation breadth early in the project. They were committed with status "DRAFT — In Progress" and a placeholder date of 2026. By B.6, these documents needed to be stamped Complete with real test evidence.

**Root Cause:** The project plan calls for SDLC documents to be produced per phase, but in practice the quality docs were drafted ahead of the build to front-load portfolio artefact production. This is a deliberate choice — it front-loads the documentation signal — but it means the B.6 gate is administrative (status update + test evidence) rather than a fresh authoring task.

**Solution:**

- Updated MKT-TPQA-1.0, MKT-BDD-1.0, MKT-DDT-1.0 status from "DRAFT — In Progress" → "COMPLETE"
- Added version 1.1 history entry referencing Run ID `707gL00000dWsJo` (83/83 Apex tests passing, 100% pass rate)
- MKT-PTS-1.0 was already marked Complete in a prior session
- B.6 gate ("All tests pass") formally met: 83 tests, 0 failures, Run ID `707gL00000dWsJo`

**For future verticals:** Continue the same pattern — author quality docs early, stamp Complete at B.6 with the actual test run ID as evidence. This preserves documentation breadth while maintaining audit traceability.

---

## B.7 — SDLC Phase 4: Delivery

### LL-067 — DRP authored ahead of deployment — confirm deploy date at B.7 gate

**Phase:** B.7 — SDLC Phase 4: Delivery

**Problem:** MKT-DRP-1.0 was produced in full during B.1 to front-load portfolio artefacts. The "Planned Deploy Date" field was left as "TBD — post scratch org build completion" since the build had not started. By B.7, all metadata had been deployed across B.2–B.5.

**Root Cause:** Same living-document pattern as B.6 quality docs. The DRP is authored as a planning document and stamped with actuals at the delivery gate.

**Solution:** Updated the Planned Deploy Date to `2026-03-08` with the note "all phases deployed to `sf-portfolio` org". No other TBD values remained in the document.

**For future verticals:** The DRP is the appropriate place to record: (1) the confirmed deploy date, (2) any deviations from the planned deployment sequence, (3) rollback decisions taken. Review all TBD fields before closing B.7.

---

## B.8 — Portfolio Publish

### LL-068 — Case study narrative is the B.8 core deliverable

**Phase:** B.8 — Portfolio Publish

**Problem:** The master plan defines B.8 as "Screenshots, case study narrative, Experience Cloud site updated." The portfolio site UI/UX (SF-PORTFOLIO-UX-1.0) and its public LWR build are pinned for a follow-up project (Figma + React/Next.js phase). The "Experience Cloud site updated" deliverable cannot be completed until the portfolio site design system is ready.

**Root Cause:** The portfolio site (meta-portfolio layer) is a separate build from the vertical client portals. The Catalyst Client Portal (Catalyst's own Experience Cloud site) is complete, but the recruiter-facing portfolio site — which would surface the case study — is deferred.

**Solution:** Scoped B.8 to what is deliverable now:

1. `MKT-CASESTUDY-1.0_Catalyst.md` — complete case study narrative capturing the fictional scenario, what was built, key technical decisions, test results, known limitations, and skills demonstrated
2. CLAUDE.md and LL updated to mark Track B complete
3. `vertical/marketing` PR raised to formally close the branch

The case study document serves as the source content for the portfolio site case study page when the SF-PORTFOLIO-UX-1.0 build begins.

**For future verticals:** Produce the case study at B.8 in the same format. The case study is the primary recruiter-facing artefact — write it for a technical hiring manager, not for an internal audience. Emphasise decisions, trade-offs, and what makes the build production-grade.

---

## Post-B.8 — CI/CD Recovery

### LL-069 — Connected App OAuth scope and token-mode drift can pass JWT login but break CI

**Phase:** Post-B.8 — CI/CD Recovery

**Problem:** JWT auth (`sf org login jwt`) succeeded for the CI Connected App, but scratch org creation failed with `RemoteOrgSignupFailed` / `C-1016`. In parallel, metadata/SOAP operations failed with: `SOAP API does not support JWT-based access tokens`.

**Root Cause:** Connected App settings drifted from CLI-safe defaults. Two high-impact misconfigurations:
1. Missing required OAuth scope `web` on the Connected App used by CLI.
2. `Issue JSON Web Token (JWT)-based access tokens for named users` enabled, causing token mode that breaks SOAP/metadata operations used by `sf` workflows.

**Solution:** Standardize CI Connected App settings:
- OAuth scopes: `api`, `refresh_token/offline_access`, `web`
- Callback URL: `http://localhost:1717/OauthRedirect`
- Upload matching `server.crt` for the private key used in `SF_SERVER_KEY`
- Policies: `Admin approved users are pre-authorized`, CI user included via profile/permission set
- IP Relaxation: `Relax IP restrictions`
- Keep `Issue JSON Web Token (JWT)-based access tokens for named users` **disabled**
- Use org login host (`https://<mydomain>.my.salesforce.com`) for `SF_INSTANCE_URL`, not Lightning/setup URLs
- Wait 5-10 minutes after policy changes before retest

**Validation commands:**
- `sf org login jwt --client-id "$SF_CLIENT_ID" --jwt-key-file /path/to/server.key --username "$SF_USERNAME" --instance-url "$SF_INSTANCE_URL" --alias ci-org-local`
- `sf org create scratch --definition-file config/project-scratch-def.json --alias ci-org-local-scratch --duration-days 1 --wait 15 --target-dev-hub ci-org-local`

---

### LL-070 — CI/Actions/Automation deferred as post-MKT pinned backlog

**Phase:** Post-B.8 — Delivery Governance

**Problem:** CI auth recovery work (`C-1016` path) became a schedule sink during MKT closeout. Continuing deep CI debugging in parallel would delay completion of higher-priority MKT artefacts and handoff tasks.

**Root Cause:** CI depends on Salesforce Connected App auth behavior in the newer UI, and the current failure mode is external/platform-policy sensitive rather than a straightforward metadata defect. This creates unpredictable iteration cost during phase close.

**Solution:** Formally defer CI/Actions/Automation hardening as a pinned first post-MKT action item. Treat it as non-blocking for MKT closeout while preserving all technical notes and runbooks (`CICD_ADDENDUM.md`, `CI_JWT_RESET_RUNBOOK.md`, LL-069) for deterministic re-entry.
