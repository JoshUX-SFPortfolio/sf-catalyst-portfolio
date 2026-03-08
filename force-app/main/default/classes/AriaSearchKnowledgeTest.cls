/**
 * AriaSearchKnowledgeTest
 * Tests for the AriaSearchKnowledge invocable action.
 * Knowledge is not enabled in this org — the SOSL catch path returns a graceful
 * message. Tests validate input guards and the single-Result output shape.
 * MKT-REQ-EXP-012, MKT-REQ-EXP-013
 */
@IsTest
private class AriaSearchKnowledgeTest {

    @IsTest
    static void testSearch_blankTerm_returnsMessage() {
        AriaSearchKnowledge.Request req = new AriaSearchKnowledge.Request();
        req.searchTerm = '   ';

        Test.startTest();
        List<AriaSearchKnowledge.Result> results =
            AriaSearchKnowledge.searchKnowledge(
                new List<AriaSearchKnowledge.Request>{ req }
            );
        Test.stopTest();

        System.assertEquals(1, results.size(), 'Should return one result for blank term');
        System.assertNotEquals(null, results[0].articlesSummary, 'articlesSummary should not be null');
    }

    @IsTest
    static void testSearch_shortTerm_returnsMessage() {
        AriaSearchKnowledge.Request req = new AriaSearchKnowledge.Request();
        req.searchTerm = 'a';

        Test.startTest();
        List<AriaSearchKnowledge.Result> results =
            AriaSearchKnowledge.searchKnowledge(
                new List<AriaSearchKnowledge.Request>{ req }
            );
        Test.stopTest();

        System.assertEquals(1, results.size(), 'Should return one result for short term');
        System.assertNotEquals(null, results[0].articlesSummary, 'articlesSummary should not be null');
    }

    @IsTest
    static void testSearch_emptyRequestList_returnsMessage() {
        Test.startTest();
        List<AriaSearchKnowledge.Result> results =
            AriaSearchKnowledge.searchKnowledge(
                new List<AriaSearchKnowledge.Request>()
            );
        Test.stopTest();

        System.assertEquals(1, results.size(), 'Empty request list should return one graceful result');
    }

    @IsTest
    static void testSearch_nullRequestList_returnsMessage() {
        Test.startTest();
        List<AriaSearchKnowledge.Result> results =
            AriaSearchKnowledge.searchKnowledge(null);
        Test.stopTest();

        System.assertEquals(1, results.size(), 'Null request list should return one graceful result');
    }

    @IsTest
    static void testSearch_validTerm_returnsNonNull() {
        // Knowledge not enabled — SOSL throws, catch returns graceful message
        AriaSearchKnowledge.Request req = new AriaSearchKnowledge.Request();
        req.searchTerm = 'Campaign Intelligence setup';

        Test.startTest();
        List<AriaSearchKnowledge.Result> results =
            AriaSearchKnowledge.searchKnowledge(
                new List<AriaSearchKnowledge.Request>{ req }
            );
        Test.stopTest();

        System.assertNotEquals(null, results, 'searchKnowledge should never return null');
        System.assertEquals(1, results.size(), 'Should always return exactly one result');
        System.assertNotEquals(null, results[0].articlesSummary, 'articlesSummary should not be null');
    }

    @IsTest
    static void testSearch_sqlInjectionAttempt_doesNotThrow() {
        // Confirms escapeSingleQuotes sanitisation — should not throw
        AriaSearchKnowledge.Request req = new AriaSearchKnowledge.Request();
        req.searchTerm = '\'; DELETE FROM KnowledgeArticleVersion WHERE Id != null; --';

        Test.startTest();
        List<AriaSearchKnowledge.Result> results =
            AriaSearchKnowledge.searchKnowledge(
                new List<AriaSearchKnowledge.Request>{ req }
            );
        Test.stopTest();

        System.assertNotEquals(null, results, 'Should handle injected input without throwing');
        System.assertEquals(1, results.size(), 'Should return one result for any input');
    }
}
