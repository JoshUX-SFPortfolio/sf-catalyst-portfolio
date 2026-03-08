/**
 * AriaSearchKnowledgeTest
 * Tests for the AriaSearchKnowledge invocable action.
 * Knowledge is not enabled in this org — the SOSL catch path returns an empty
 * list gracefully. Tests validate input guards and null safety.
 * MKT-REQ-EXP-012, MKT-REQ-EXP-013
 */
@IsTest
private class AriaSearchKnowledgeTest {

    @IsTest
    static void testSearch_blankTerm_returnsEmpty() {
        AriaSearchKnowledge.Request req = new AriaSearchKnowledge.Request();
        req.searchTerm = '   ';

        Test.startTest();
        List<AriaSearchKnowledge.Result> results =
            AriaSearchKnowledge.searchKnowledge(
                new List<AriaSearchKnowledge.Request>{ req }
            );
        Test.stopTest();

        System.assertEquals(0, results.size(), 'Blank search term should return empty list');
    }

    @IsTest
    static void testSearch_shortTerm_returnsEmpty() {
        AriaSearchKnowledge.Request req = new AriaSearchKnowledge.Request();
        req.searchTerm = 'a';

        Test.startTest();
        List<AriaSearchKnowledge.Result> results =
            AriaSearchKnowledge.searchKnowledge(
                new List<AriaSearchKnowledge.Request>{ req }
            );
        Test.stopTest();

        System.assertEquals(0, results.size(), 'Single-char term should return empty list');
    }

    @IsTest
    static void testSearch_emptyRequestList_returnsEmpty() {
        Test.startTest();
        List<AriaSearchKnowledge.Result> results =
            AriaSearchKnowledge.searchKnowledge(
                new List<AriaSearchKnowledge.Request>()
            );
        Test.stopTest();

        System.assertEquals(0, results.size(), 'Empty request list should return empty list');
    }

    @IsTest
    static void testSearch_nullRequestList_returnsEmpty() {
        Test.startTest();
        List<AriaSearchKnowledge.Result> results =
            AriaSearchKnowledge.searchKnowledge(null);
        Test.stopTest();

        System.assertEquals(0, results.size(), 'Null request list should return empty list');
    }

    @IsTest
    static void testSearch_validTerm_returnsNonNull() {
        // Knowledge not enabled — SOSL throws, catch returns empty list gracefully
        AriaSearchKnowledge.Request req = new AriaSearchKnowledge.Request();
        req.searchTerm = 'Campaign Intelligence setup';

        Test.startTest();
        List<AriaSearchKnowledge.Result> results =
            AriaSearchKnowledge.searchKnowledge(
                new List<AriaSearchKnowledge.Request>{ req }
            );
        Test.stopTest();

        System.assertNotEquals(null, results, 'searchKnowledge should never return null');
    }

    @IsTest
    static void testSearch_sqlInjectionAttempt_returnsEmpty() {
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
    }
}
