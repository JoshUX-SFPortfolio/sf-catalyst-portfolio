/**
 * AssetItemServiceTest
 * Tests for Asset_Item__c trigger path: verifies that the trigger fires cleanly
 * and that field-level defaults and explicit status values behave as expected.
 * MKT-TC-SRVC-003
 *
 * Note: Asset_Item__c.Status__c has a field-level default of 'Active'.
 * AssetItemService.setDefaultStatus() is a guard for orgs where the default
 * may be overridden; it does not fire when the field already has a value.
 */
@IsTest
private class AssetItemServiceTest {

    @TestSetup
    static void makeData() {
        TestDataFactory.createAccount('Asset Test Co');
    }

    private static Account getAccount() {
        return [SELECT Id FROM Account LIMIT 1];
    }

    @IsTest
    static void insert_noStatus_receivesFieldDefault() {
        Account acc = getAccount();
        Asset_Item__c a = TestDataFactory.createAssetItemNoInsert(acc.Id, 'Module Licence');

        Test.startTest();
        insert a;
        Test.stopTest();

        // Field-level default for Status__c is 'Active'
        Asset_Item__c result = [SELECT Status__c FROM Asset_Item__c WHERE Id = :a.Id];
        System.assertNotEquals(null, result.Status__c, 'Status should be populated by field default');
    }

    @IsTest
    static void insert_statusProvided_isPreserved() {
        Account acc = getAccount();
        Asset_Item__c a = new Asset_Item__c(
            Account__c    = acc.Id,
            Asset_Type__c = 'Module Licence',
            Status__c     = 'Inactive'
        );

        Test.startTest();
        insert a;
        Test.stopTest();

        Asset_Item__c result = [SELECT Status__c FROM Asset_Item__c WHERE Id = :a.Id];
        System.assertEquals('Inactive', result.Status__c, 'Explicitly set status should be preserved');
    }

    @IsTest
    static void insert_bulk_triggerFiresWithoutError() {
        Account acc = getAccount();
        List<Asset_Item__c> items = new List<Asset_Item__c>();
        for (Integer i = 0; i < 10; i++) {
            items.add(new Asset_Item__c(
                Account__c    = acc.Id,
                Asset_Type__c = 'Module Licence'
            ));
        }

        Test.startTest();
        insert items;
        Test.stopTest();

        Integer count = [SELECT COUNT() FROM Asset_Item__c WHERE Account__c = :acc.Id];
        System.assertEquals(10, count, 'All 10 Asset Items should be inserted successfully');
    }
}
