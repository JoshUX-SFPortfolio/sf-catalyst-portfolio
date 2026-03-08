/**
 * CasePortalController
 * Apex controller for portal case components. All methods enforce sharing
 * and filter by the authenticated user's Account via WITH USER_MODE.
 * MKT-REQ-EXP-007, MKT-REQ-EXP-008, MKT-REQ-NFR-003, MKT-REQ-NFR-004
 */
public with sharing class CasePortalController {

    /**
     * Returns cases for the authenticated portal user's Account.
     * Pass status = 'all' for all cases, or a specific Status value to filter.
     * MKT-REQ-EXP-008
     */
    @AuraEnabled(cacheable=true)
    public static List<Case> getPortalCases(String status) {
        Id accountId = getPortalUserAccountId();
        if (accountId == null) {
            return new List<Case>();
        }

        if (String.isBlank(status) || status == 'all') {
            return [
                SELECT Id, CaseNumber, Subject, Status, Priority,
                       Affected_Module__c, CreatedDate, LastModifiedDate,
                       SLA_Tier_at_Creation__c
                FROM Case
                WHERE AccountId = :accountId
                WITH USER_MODE
                ORDER BY LastModifiedDate DESC
                LIMIT 50
            ];
        }

        return [
            SELECT Id, CaseNumber, Subject, Status, Priority,
                   Affected_Module__c, CreatedDate, LastModifiedDate,
                   SLA_Tier_at_Creation__c
            FROM Case
            WHERE AccountId = :accountId
              AND Status = :status
            WITH USER_MODE
            ORDER BY LastModifiedDate DESC
            LIMIT 50
        ];
    }

    /**
     * Returns a single case with comments (FeedComments) for the detail view.
     * MKT-REQ-EXP-008
     */
    @AuraEnabled(cacheable=true)
    public static Case getCaseDetail(Id caseId) {
        List<Case> cases = [
            SELECT Id, CaseNumber, Subject, Status, Priority, Description,
                   Affected_Module__c, Urgency__c, Resolution_Summary__c,
                   SLA_Tier_at_Creation__c, CreatedDate, LastModifiedDate,
                   AccountId, ContactId
            FROM Case
            WHERE Id = :caseId
            WITH USER_MODE
            LIMIT 1
        ];
        return cases.isEmpty() ? null : cases[0];
    }

    /**
     * Returns the count of open cases for the portal user's Account.
     * Used by catalyst-open-cases-tile.
     * MKT-REQ-EXP-004
     */
    @AuraEnabled(cacheable=true)
    public static Integer getOpenCaseCount() {
        Id accountId = getPortalUserAccountId();
        if (accountId == null) {
            return 0;
        }
        return [
            SELECT COUNT()
            FROM Case
            WHERE AccountId = :accountId
              AND IsClosed = false
            WITH USER_MODE
        ];
    }

    /**
     * Submits a new case from the portal.
     * Returns the new Case Id on success.
     * MKT-REQ-EXP-007
     */
    @AuraEnabled
    public static Id submitCase(String subject, String description,
                                String affectedModule, String urgency) {
        Id accountId = getPortalUserAccountId();
        Id contactId = getPortalUserContactId();

        Case c = new Case(
            Subject          = subject,
            Description      = description,
            Affected_Module__c = affectedModule,
            Urgency__c       = urgency,
            AccountId        = accountId,
            ContactId        = contactId,
            Origin           = 'Web'
        );

        insert as user c;
        return c.Id;
    }

    // ── Private helpers ──────────────────────────────────────────────────────

    @TestVisible
    private static Id getPortalUserAccountId() {
        List<User> users = [
            SELECT AccountId FROM User
            WHERE Id = :UserInfo.getUserId()
            WITH USER_MODE
            LIMIT 1
        ];
        return (users.isEmpty() || users[0].AccountId == null) ? null : users[0].AccountId;
    }

    @TestVisible
    private static Id getPortalUserContactId() {
        List<User> users = [
            SELECT ContactId FROM User
            WHERE Id = :UserInfo.getUserId()
            WITH USER_MODE
            LIMIT 1
        ];
        return (users.isEmpty() || users[0].ContactId == null) ? null : users[0].ContactId;
    }
}
