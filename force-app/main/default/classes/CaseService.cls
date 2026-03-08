/**
 * CaseService
 * Business logic for the Case object.
 *
 * Entitlement assignment: queries the active Entitlement for the Case's Account,
 * stamps it on the Case record, and captures the SLA tier at case creation time.
 *
 * The SLA tier is sourced from the Entitlement name, which follows the convention:
 *   "<Tier> - <Product>" e.g. "Enterprise - Catalyst Platform"
 * The tier prefix (before the first dash) is written to SLA_Tier_at_Creation__c.
 */
public with sharing class CaseService {

    // ─── Before Insert ────────────────────────────────────────────────────────

    public static void setEntitlementOnInsert(List<Case> newCases) {
        Set<Id> accountIds = new Set<Id>();
        for (Case c : newCases) {
            if (c.AccountId != null && c.EntitlementId == null) {
                accountIds.add(c.AccountId);
            }
        }

        if (accountIds.isEmpty()) {
            return;
        }

        Map<Id, Entitlement> entitlementByAccount = getActiveEntitlementsByAccount(accountIds);

        for (Case c : newCases) {
            if (c.AccountId != null && c.EntitlementId == null) {
                Entitlement ent = entitlementByAccount.get(c.AccountId);
                if (ent != null) {
                    c.EntitlementId = ent.Id;
                    c.SLA_Tier_at_Creation__c = extractTierFromEntitlementName(ent.Name);
                }
            }
        }
    }

    // ─── Before Update ────────────────────────────────────────────────────────

    public static void setEntitlementOnUpdate(List<Case> newCases, Map<Id, Case> oldMap) {
        Set<Id> accountIds = new Set<Id>();
        for (Case c : newCases) {
            Case old = oldMap.get(c.Id);
            Boolean accountChanged = c.AccountId != old.AccountId;
            Boolean noEntitlement  = c.EntitlementId == null;
            if (c.AccountId != null && (accountChanged || noEntitlement)) {
                accountIds.add(c.AccountId);
            }
        }

        if (accountIds.isEmpty()) {
            return;
        }

        Map<Id, Entitlement> entitlementByAccount = getActiveEntitlementsByAccount(accountIds);

        for (Case c : newCases) {
            Case old = oldMap.get(c.Id);
            Boolean accountChanged = c.AccountId != old.AccountId;
            Boolean noEntitlement  = c.EntitlementId == null;
            if (c.AccountId != null && (accountChanged || noEntitlement)) {
                Entitlement ent = entitlementByAccount.get(c.AccountId);
                if (ent != null) {
                    c.EntitlementId = ent.Id;
                    c.SLA_Tier_at_Creation__c = extractTierFromEntitlementName(ent.Name);
                }
            }
        }
    }

    // ─── After Insert ─────────────────────────────────────────────────────────

    /**
     * Placeholder: sends an internal new-case notification.
     * Full implementation (EmailMessage or platform event) added in A.4 flows phase.
     */
    public static void sendNewCaseNotification(List<Case> newCases) {
        // Intentionally empty — notification logic delivered via Flow in this phase
    }

    // ─── Private helpers ──────────────────────────────────────────────────────

    @TestVisible
    private static Map<Id, Entitlement> getActiveEntitlementsByAccount(Set<Id> accountIds) {
        Map<Id, Entitlement> result = new Map<Id, Entitlement>();
        for (Entitlement ent : [
            SELECT Id, Name, AccountId
            FROM Entitlement
            WHERE AccountId IN :accountIds
              AND Status = 'Active'
            ORDER BY CreatedDate DESC
        ]) {
            // Keep the most-recently-created active entitlement per account
            if (!result.containsKey(ent.AccountId)) {
                result.put(ent.AccountId, ent);
            }
        }
        return result;
    }

    @TestVisible
    private static String extractTierFromEntitlementName(String entitlementName) {
        if (String.isBlank(entitlementName)) {
            return null;
        }
        Integer dashIdx = entitlementName.indexOf(' - ');
        if (dashIdx > 0) {
            return entitlementName.substring(0, dashIdx).trim();
        }
        return entitlementName.trim();
    }
}
