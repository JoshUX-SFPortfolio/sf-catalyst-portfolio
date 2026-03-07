/**
 * CaseServiceTest
 * Tests for CaseService: entitlement stamping on insert and update,
 * SLA tier extraction, and notification placeholder.
 * MKT-TC-SRVC-002
 */
@IsTest
private class CaseServiceTest {

    // ─── Helpers ──────────────────────────────────────────────────────────────

    @TestSetup
    static void makeData() {
        Account acc = TestDataFactory.createAccount('Catalyst Test Co');
        TestDataFactory.createEntitlement(acc.Id, 'Enterprise - Catalyst Platform');
        TestDataFactory.createContact(acc.Id, 'Jane', 'Doe');
    }

    private static Account getAccount() {
        return [SELECT Id FROM Account LIMIT 1];
    }

    private static Entitlement getEntitlement() {
        return [SELECT Id, Name FROM Entitlement LIMIT 1];
    }

    // ─── setEntitlementOnInsert ───────────────────────────────────────────────

    @IsTest
    static void insert_withAccount_stampsEntitlementAndTier() {
        Account acc = getAccount();
        Entitlement ent = getEntitlement();

        Test.startTest();
        Case c = TestDataFactory.createCase(acc.Id, null, 'Test case entitlement');
        Test.stopTest();

        Case result = [SELECT Id, EntitlementId, SLA_Tier_at_Creation__c FROM Case WHERE Id = :c.Id];
        System.assertEquals(ent.Id, result.EntitlementId, 'Entitlement should be stamped on insert');
        System.assertEquals('Enterprise', result.SLA_Tier_at_Creation__c, 'SLA tier should be extracted from entitlement name');
    }

    @IsTest
    static void insert_withoutAccount_doesNotStampEntitlement() {
        Test.startTest();
        Case c = new Case(Subject = 'No account case', Status = 'New', Origin = 'Web');
        insert c;
        Test.stopTest();

        Case result = [SELECT Id, EntitlementId FROM Case WHERE Id = :c.Id];
        System.assertEquals(null, result.EntitlementId, 'Entitlement should not be set without an Account');
    }

    @IsTest
    static void insert_bulkCases_allGetEntitlement() {
        Account acc = getAccount();
        Entitlement ent = getEntitlement();

        Test.startTest();
        List<Case> cases = TestDataFactory.createCases(acc.Id, 10);
        Test.stopTest();

        List<Case> results = [SELECT Id, EntitlementId FROM Case WHERE AccountId = :acc.Id];
        for (Case c : results) {
            System.assertEquals(ent.Id, c.EntitlementId, 'All bulk cases should get entitlement');
        }
    }

    @IsTest
    static void insert_accountWithNoEntitlement_caseHasNoEntitlement() {
        Account acc2 = TestDataFactory.createAccount('No Entitlement Co');

        Test.startTest();
        Case c = TestDataFactory.createCase(acc2.Id, null, 'No entitlement case');
        Test.stopTest();

        Case result = [SELECT Id, EntitlementId FROM Case WHERE Id = :c.Id];
        System.assertEquals(null, result.EntitlementId, 'Case should have no entitlement when account has none');
    }

    // ─── setEntitlementOnUpdate ───────────────────────────────────────────────

    @IsTest
    static void update_accountChange_restampsEntitlement() {
        Account acc = getAccount();
        Account acc2 = TestDataFactory.createAccount('Second Account');
        TestDataFactory.createEntitlement(acc2.Id, 'Professional - Catalyst Platform');

        Case c = TestDataFactory.createCase(acc.Id, null, 'Account change test');

        Test.startTest();
        c.AccountId = acc2.Id;
        update c;
        Test.stopTest();

        Case result = [SELECT Id, SLA_Tier_at_Creation__c FROM Case WHERE Id = :c.Id];
        System.assertEquals('Professional', result.SLA_Tier_at_Creation__c, 'SLA tier should update when account changes');
    }

    // ─── extractTierFromEntitlementName ──────────────────────────────────────

    @IsTest
    static void extractTier_standardFormat_returnsTierPrefix() {
        String tier = CaseService.extractTierFromEntitlementName('Starter - Catalyst Platform');
        System.assertEquals('Starter', tier, 'Should extract tier prefix');
    }

    @IsTest
    static void extractTier_noDash_returnsFullName() {
        String tier = CaseService.extractTierFromEntitlementName('CustomEntitlement');
        System.assertEquals('CustomEntitlement', tier, 'Should return full name when no dash');
    }

    @IsTest
    static void extractTier_blank_returnsNull() {
        String tier = CaseService.extractTierFromEntitlementName('');
        System.assertEquals(null, tier, 'Should return null for blank name');
    }

    // ─── sendNewCaseNotification ──────────────────────────────────────────────

    @IsTest
    static void sendNewCaseNotification_doesNotThrow() {
        Account acc = getAccount();
        List<Case> cases = TestDataFactory.createCases(acc.Id, 3);

        Test.startTest();
        CaseService.sendNewCaseNotification(cases);
        Test.stopTest();

        // Notification is a no-op placeholder in this phase — assert no exception thrown
        System.assert(true, 'sendNewCaseNotification should complete without error');
    }
}
