/**
 * SubscriptionPortalController
 * Apex controller for subscription and module components on the portal.
 * Returns Account subscription data and Asset_Item__c (module licences).
 * MKT-REQ-EXP-004, MKT-REQ-EXP-005, MKT-REQ-NFR-003, MKT-REQ-NFR-004
 */
public with sharing class SubscriptionPortalController {

    /**
     * Returns subscription data for the portal user's Account.
     * Used by catalyst-subscription-tile.
     * MKT-REQ-EXP-005
     */
    @AuraEnabled(cacheable=true)
    public static Account getSubscriptionData() {
        Id accountId = getPortalUserAccountId();
        if (accountId == null) {
            return null;
        }

        List<Account> accounts = [
            SELECT Id, Name, Subscription_Tier__c, Annual_Contract_Value__c,
                   Contract_Renewal_Date__c, Health_Score__c,
                   Platform_Usage_Index__c, Open_Case_Count__c, CSAT_Average__c
            FROM Account
            WHERE Id = :accountId
            WITH USER_MODE
            LIMIT 1
        ];
        return accounts.isEmpty() ? null : accounts[0];
    }

    /**
     * Returns active Asset_Item__c records for the portal user's Account.
     * Used by catalyst-module-list and catalyst-usage-heatmap.
     * MKT-REQ-EXP-005
     */
    @AuraEnabled(cacheable=true)
    public static List<Asset_Item__c> getActiveModules() {
        Id accountId = getPortalUserAccountId();
        if (accountId == null) {
            return new List<Asset_Item__c>();
        }

        return [
            SELECT Id, Name, Module__c, Asset_Type__c, Status__c,
                   Activation_Date__c, Expiry_Date__c
            FROM Asset_Item__c
            WHERE Account__c = :accountId
              AND Status__c = 'Active'
              AND Asset_Type__c = 'Module Licence'
            WITH USER_MODE
            ORDER BY Module__c ASC
        ];
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
}
