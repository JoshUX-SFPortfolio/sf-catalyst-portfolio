/**
 * AriaActionControllerTest
 * Tests for all three Aria Agentforce action classes:
 *   AriaGetCaseStatus, AriaGetOnboardingProgress, AriaEscalateToAgent
 * Also covers AriaActionController (shared helper utility).
 * MKT-REQ-EXP-012, MKT-REQ-EXP-013, MKT-REQ-EXP-015
 */
@IsTest
private class AriaActionControllerTest {

    @TestSetup
    static void setup() {
        Account acct = TestDataFactory.createAccount('Aria Test Account');
        Contact con  = TestDataFactory.createContact(acct.Id, 'Aria', 'Tester');
        TestDataFactory.createCase(acct.Id, con.Id, 'Open Case 1');
        TestDataFactory.createCase(acct.Id, con.Id, 'Open Case 2');
        TestDataFactory.createProject(acct.Id, 'Onboarding Project');
    }

    // ── AriaActionController helper coverage ──────────────────────────────────

    @IsTest
    static void testHelpers_nullForSysAdmin() {
        // Sys admin has no AccountId/ContactId on the User record
        Test.startTest();
        Id acctId = AriaActionController.getPortalUserAccountId();
        Id conId  = AriaActionController.getPortalUserContactId();
        Test.stopTest();

        System.assertEquals(null, acctId, 'AccountId should be null for sys admin user');
        System.assertEquals(null, conId, 'ContactId should be null for sys admin user');
    }

    // ── AriaGetCaseStatus ─────────────────────────────────────────────────────

    @IsTest
    static void testGetCaseStatus_nullAccount() {
        // Sys admin has no AccountId — returns single result with graceful message
        Test.startTest();
        List<AriaGetCaseStatus.Request> reqs = new List<AriaGetCaseStatus.Request>{
            new AriaGetCaseStatus.Request()
        };
        List<AriaGetCaseStatus.Result> results = AriaGetCaseStatus.getCaseStatus(reqs);
        Test.stopTest();

        System.assertEquals(1, results.size(), 'Should return one result even when AccountId is null');
        System.assertNotEquals(null, results[0].casesSummary, 'casesSummary should not be null');
    }

    @IsTest
    static void testGetCaseStatus_returnsNonNull() {
        Test.startTest();
        List<AriaGetCaseStatus.Request> reqs = new List<AriaGetCaseStatus.Request>{
            new AriaGetCaseStatus.Request()
        };
        List<AriaGetCaseStatus.Result> results = AriaGetCaseStatus.getCaseStatus(reqs);
        Test.stopTest();

        System.assertNotEquals(null, results, 'getCaseStatus should never return null');
    }

    // ── AriaGetOnboardingProgress ─────────────────────────────────────────────

    @IsTest
    static void testGetOnboardingProgress_noProject() {
        // Sys admin has no AccountId → OnboardingPortalController returns null
        Test.startTest();
        List<AriaGetOnboardingProgress.Request> reqs = new List<AriaGetOnboardingProgress.Request>{
            new AriaGetOnboardingProgress.Request()
        };
        List<AriaGetOnboardingProgress.Result> results =
            AriaGetOnboardingProgress.getOnboardingProgress(reqs);
        Test.stopTest();

        System.assertEquals(1, results.size(), 'Should return one result even with no project');
        System.assertNotEquals(null, results[0].onboardingSummary, 'onboardingSummary should not be null');
        System.assert(results[0].onboardingSummary.contains('No onboarding'), 'Summary should indicate no project found');
    }

    // ── AriaEscalateToAgent ───────────────────────────────────────────────────

    @IsTest
    static void testEscalateToAgent_createCase() {
        Test.startTest();
        AriaEscalateToAgent.Request req = new AriaEscalateToAgent.Request();
        req.subject     = 'Escalated via Aria';
        req.description = 'Client could not resolve issue within 2 turns.';

        List<AriaEscalateToAgent.Result> results =
            AriaEscalateToAgent.escalateToAgent(
                new List<AriaEscalateToAgent.Request>{ req }
            );
        Test.stopTest();

        System.assertEquals(1, results.size(), 'Should return one escalation result');
        System.assertNotEquals(null, results[0].caseId, 'caseId should be populated');
        System.assertNotEquals('', results[0].caseId, 'caseId should not be empty');

        Id cId = (Id) results[0].caseId;
        List<Case> cases = [SELECT Origin, Subject FROM Case WHERE Id = :cId LIMIT 1];
        System.assertEquals(1, cases.size(), 'Case should exist in database');
        System.assertEquals('Chat', cases[0].Origin, 'Origin should be Chat for Aria escalations');
        System.assertEquals('Escalated via Aria', cases[0].Subject, 'Subject should match request');
    }

    @IsTest
    static void testEscalateToAgent_emptyRequests() {
        Test.startTest();
        List<AriaEscalateToAgent.Result> results =
            AriaEscalateToAgent.escalateToAgent(new List<AriaEscalateToAgent.Request>());
        Test.stopTest();

        System.assertEquals(0, results.size(), 'Empty request list should return empty results');
    }

    @IsTest
    static void testEscalateToAgent_nullRequests() {
        Test.startTest();
        List<AriaEscalateToAgent.Result> results = AriaEscalateToAgent.escalateToAgent(null);
        Test.stopTest();

        System.assertEquals(0, results.size(), 'Null request list should return empty results');
    }
}
