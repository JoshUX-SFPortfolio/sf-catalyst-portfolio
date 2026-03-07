/**
 * SubscriptionPortalControllerTest
 * Tests for SubscriptionPortalController.
 * Portal user context cannot be fully simulated without a live Community;
 * all paths are exercised through the System Administrator context.
 * MKT-TC-SRVC-011
 */
@IsTest
private class SubscriptionPortalControllerTest {

    @TestSetup
    static void makeData() {
        Account acc = TestDataFactory.createAccount('Subscription Test Co');
        TestDataFactory.createAssetItem(acc.Id, 'Module Licence');
    }

    // ── getSubscriptionData ───────────────────────────────────────────────────

    @IsTest
    static void getSubscriptionData_nonPortalUser_returnsNull() {
        Test.startTest();
        Account result = SubscriptionPortalController.getSubscriptionData();
        Test.stopTest();
        // Non-portal user has no AccountId → returns null
        System.assertEquals(null, result, 'Non-portal user should receive null subscription data');
    }

    // ── getActiveModules ──────────────────────────────────────────────────────

    @IsTest
    static void getActiveModules_nonPortalUser_returnsEmpty() {
        Test.startTest();
        List<Asset_Item__c> modules = SubscriptionPortalController.getActiveModules();
        Test.stopTest();
        System.assertNotEquals(null, modules, 'Should return empty list, not null');
        System.assertEquals(0, modules.size(), 'Non-portal user should get empty list');
    }

    // ── getPortalUserAccountId ────────────────────────────────────────────────

    @IsTest
    static void getPortalUserAccountId_returnsNullForNonPortalUser() {
        Test.startTest();
        Id accountId = SubscriptionPortalController.getPortalUserAccountId();
        Test.stopTest();
        System.assertEquals(null, accountId, 'Sys admin user has no portal AccountId');
    }
}
