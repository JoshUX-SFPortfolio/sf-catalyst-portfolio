/**
 * FeedbackSurveyServiceTest
 * Tests for FeedbackSurveyService: low-score flagging on Case.
 * MKT-TC-SRVC-004
 */
@IsTest
private class FeedbackSurveyServiceTest {

    @TestSetup
    static void makeData() {
        Account acc = TestDataFactory.createAccount('Survey Test Co');
        Contact con = TestDataFactory.createContact(acc.Id, 'Alex', 'Smith');
        TestDataFactory.createCase(acc.Id, con.Id, 'Survey Test Case');
    }

    private static Account getAccount() {
        return [SELECT Id FROM Account LIMIT 1];
    }

    private static Contact getContact() {
        return [SELECT Id FROM Contact LIMIT 1];
    }

    private static Case getCase() {
        return [SELECT Id FROM Case LIMIT 1];
    }

    // ─── flagLowScoreCases ────────────────────────────────────────────────────

    @IsTest
    static void lowCsat_flagsCase() {
        Contact con = getContact();
        Case c = getCase();

        Test.startTest();
        TestDataFactory.createFeedbackSurvey(con.Id, c.Id, 1, 7); // CSAT=1 (low), NPS=7 (ok)
        Test.stopTest();

        Case result = [SELECT Auto_Link_Status__c FROM Case WHERE Id = :c.Id];
        System.assertEquals('Pending Manual Review', result.Auto_Link_Status__c, 'Low CSAT should flag case');
    }

    @IsTest
    static void lowNps_flagsCase() {
        Contact con = getContact();
        Case c = getCase();

        Test.startTest();
        TestDataFactory.createFeedbackSurvey(con.Id, c.Id, 4, 2); // CSAT=4 (ok), NPS=2 (low)
        Test.stopTest();

        Case result = [SELECT Auto_Link_Status__c FROM Case WHERE Id = :c.Id];
        System.assertEquals('Pending Manual Review', result.Auto_Link_Status__c, 'Low NPS should flag case');
    }

    @IsTest
    static void highScores_doesNotFlagCase() {
        Contact con = getContact();
        Case c = getCase();

        Test.startTest();
        TestDataFactory.createFeedbackSurvey(con.Id, c.Id, 5, 9); // Both high
        Test.stopTest();

        Case result = [SELECT Auto_Link_Status__c FROM Case WHERE Id = :c.Id];
        System.assertNotEquals('Pending Manual Review', result.Auto_Link_Status__c, 'High scores should not flag case');
    }

    @IsTest
    static void surveyWithNoCaseLink_doesNotFail() {
        Contact con = getContact();

        Test.startTest();
        Feedback_Survey__c s = new Feedback_Survey__c(
            Contact__c     = con.Id,
            CSAT_Score__c  = 1,
            NPS_Score__c   = 1,
            Status__c      = 'Sent',
            Survey_Type__c = 'CSAT'
        );
        insert s;
        Test.stopTest();

        // No exception means success — no case to flag
        System.assert(true, 'Survey without Case link should not throw');
    }

    @IsTest
    static void boundaryScore_csatExactlyTwo_flagsCase() {
        Contact con = getContact();
        Case c = getCase();

        Test.startTest();
        TestDataFactory.createFeedbackSurvey(con.Id, c.Id, 2, 9); // CSAT exactly at threshold
        Test.stopTest();

        Case result = [SELECT Auto_Link_Status__c FROM Case WHERE Id = :c.Id];
        System.assertEquals('Pending Manual Review', result.Auto_Link_Status__c, 'CSAT of 2 should flag case');
    }

    @IsTest
    static void boundaryScore_csatThree_doesNotFlag() {
        Contact con = getContact();
        Case c = getCase();

        Test.startTest();
        TestDataFactory.createFeedbackSurvey(con.Id, c.Id, 3, 9); // CSAT one above threshold
        Test.stopTest();

        Case result = [SELECT Auto_Link_Status__c FROM Case WHERE Id = :c.Id];
        System.assertNotEquals('Pending Manual Review', result.Auto_Link_Status__c, 'CSAT of 3 should not flag case');
    }
}
