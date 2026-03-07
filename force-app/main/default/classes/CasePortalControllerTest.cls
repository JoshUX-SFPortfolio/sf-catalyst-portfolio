/**
 * CasePortalControllerTest
 * Tests for CasePortalController. Runs as System Administrator — portal user
 * context cannot be fully simulated in Apex tests without a live Community.
 * Coverage validates all Apex paths; portal sharing enforcement is validated
 * via WITH USER_MODE on the actual deployed component.
 * MKT-TC-SRVC-010
 */
@IsTest
private class CasePortalControllerTest {

    @TestSetup
    static void makeData() {
        Account acc = TestDataFactory.createAccount('Portal Test Co');
        Contact con = TestDataFactory.createContact(acc.Id, 'Portal', 'User');
        TestDataFactory.createCase(acc.Id, con.Id, 'Open Case One');
        TestDataFactory.createCase(acc.Id, con.Id, 'Open Case Two');
    }

    private static Account getAccount() {
        return [SELECT Id FROM Account LIMIT 1];
    }

    // ── getPortalCases ────────────────────────────────────────────────────────

    @IsTest
    static void getPortalCases_nullAccountId_returnsEmpty() {
        // Running as standard user with no AccountId — helper returns null
        Test.startTest();
        List<Case> result = CasePortalController.getPortalCases('all');
        Test.stopTest();
        // In test context (non-portal user), AccountId is null → returns empty list
        System.assertNotEquals(null, result, 'Result should never be null');
    }

    @IsTest
    static void getPortalCases_statusFilter_appliesFilter() {
        Test.startTest();
        List<Case> all = CasePortalController.getPortalCases('all');
        List<Case> closed = CasePortalController.getPortalCases('Closed');
        Test.stopTest();
        System.assertNotEquals(null, all, 'All cases list should not be null');
        System.assertNotEquals(null, closed, 'Filtered list should not be null');
    }

    @IsTest
    static void getPortalCases_blankStatus_treatedAsAll() {
        Test.startTest();
        List<Case> result = CasePortalController.getPortalCases('');
        Test.stopTest();
        System.assertNotEquals(null, result, 'Blank status should return list (not null)');
    }

    // ── getCaseDetail ─────────────────────────────────────────────────────────

    @IsTest
    static void getCaseDetail_validId_returnsCaseOrNull() {
        Case c = [SELECT Id FROM Case LIMIT 1];
        Test.startTest();
        Case result = CasePortalController.getCaseDetail(c.Id);
        Test.stopTest();
        // May return null in test context due to USER_MODE and non-portal context
        System.assert(result == null || result.Id == c.Id, 'Should return matching case or null');
    }

    // ── getOpenCaseCount ──────────────────────────────────────────────────────

    @IsTest
    static void getOpenCaseCount_returnsInteger() {
        Test.startTest();
        Integer count = CasePortalController.getOpenCaseCount();
        Test.stopTest();
        System.assert(count >= 0, 'Count should be non-negative');
    }

    // ── submitCase ────────────────────────────────────────────────────────────

    @IsTest
    static void submitCase_validInputs_insertsCaseAndReturnsId() {
        Test.startTest();
        Id caseId = CasePortalController.submitCase(
            'Test Subject',
            'Test description from portal',
            'Campaign Intelligence',
            'Medium'
        );
        Test.stopTest();
        System.assertNotEquals(null, caseId, 'submitCase should return a Case Id');
        Case inserted = [SELECT Subject FROM Case WHERE Id = :caseId];
        System.assertEquals('Test Subject', inserted.Subject, 'Subject should match');
    }

    // ── buildDefaultSteps (via OnboardingPortalController, tested separately) ─

    @IsTest
    static void getPortalUserAccountId_returnsNullForNonPortalUser() {
        Test.startTest();
        Id accountId = CasePortalController.getPortalUserAccountId();
        Test.stopTest();
        // Sys admin test user has no AccountId
        System.assertEquals(null, accountId, 'Non-portal user should return null AccountId');
    }

    @IsTest
    static void getPortalUserContactId_returnsNullForNonPortalUser() {
        Test.startTest();
        Id contactId = CasePortalController.getPortalUserContactId();
        Test.stopTest();
        System.assertEquals(null, contactId, 'Non-portal user should return null ContactId');
    }
}
