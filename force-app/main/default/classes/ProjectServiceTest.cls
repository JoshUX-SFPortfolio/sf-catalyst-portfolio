/**
 * ProjectServiceTest
 * Tests for ProjectService: default status on insert and status transition validation.
 * MKT-TC-SALES-010
 */
@IsTest
private class ProjectServiceTest {

    @TestSetup
    static void makeData() {
        TestDataFactory.createAccount('Project Test Co');
    }

    private static Account getAccount() {
        return [SELECT Id FROM Account LIMIT 1];
    }

    // ─── setDefaultStatus ─────────────────────────────────────────────────────

    @IsTest
    static void insert_noStatus_defaultsToPlan() {
        Account acc = getAccount();
        Project__c p = new Project__c(
            Account__c    = acc.Id,
            Name          = 'New Project',
            Start_Date__c = Date.today()
        );

        Test.startTest();
        insert p;
        Test.stopTest();

        Project__c result = [SELECT Status__c FROM Project__c WHERE Id = :p.Id];
        System.assertEquals('Planning', result.Status__c, 'Default status should be Planning');
    }

    @IsTest
    static void insert_statusProvided_isPreserved() {
        Account acc = getAccount();
        Project__c p = new Project__c(
            Account__c    = acc.Id,
            Name          = 'Active Project',
            Status__c     = 'Active',
            Start_Date__c = Date.today()
        );

        Test.startTest();
        insert p;
        Test.stopTest();

        Project__c result = [SELECT Status__c FROM Project__c WHERE Id = :p.Id];
        System.assertEquals('Active', result.Status__c, 'Provided status should not be overwritten');
    }

    // ─── validateStatusTransition ─────────────────────────────────────────────

    @IsTest
    static void update_planningToCompleted_addError() {
        Account acc = getAccount();
        Project__c p = TestDataFactory.createProject(acc.Id, 'Transition Test Project');

        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            p.Status__c = 'Completed';
            update p;
        } catch (DmlException e) {
            exceptionThrown = true;
            System.assert(
                e.getMessage().contains('Active'),
                'Error message should mention Active state requirement'
            );
        }
        Test.stopTest();

        System.assert(exceptionThrown, 'DmlException should be thrown for invalid transition');
    }

    @IsTest
    static void update_planningToActive_succeeds() {
        Account acc = getAccount();
        Project__c p = TestDataFactory.createProject(acc.Id, 'Valid Transition Project');

        Test.startTest();
        p.Status__c = 'Active';
        update p;
        Test.stopTest();

        Project__c result = [SELECT Status__c FROM Project__c WHERE Id = :p.Id];
        System.assertEquals('Active', result.Status__c, 'Planning to Active should succeed');
    }

    @IsTest
    static void update_activeToCompleted_succeeds() {
        Account acc = getAccount();
        Project__c p = TestDataFactory.createProjectNoInsert(acc.Id, 'Active to Completed', 'Active');
        insert p;

        Test.startTest();
        p.Status__c = 'Completed';
        update p;
        Test.stopTest();

        Project__c result = [SELECT Status__c FROM Project__c WHERE Id = :p.Id];
        System.assertEquals('Completed', result.Status__c, 'Active to Completed should succeed');
    }
}
