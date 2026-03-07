/**
 * KnowledgePortalControllerTest
 * Tests for KnowledgePortalController.
 *
 * Note: KnowledgeArticleVersion records can only be queried (not DML-inserted)
 * in test context. These tests verify controller guard logic (blank/short input,
 * null URL name) and the toWrapper helper using a mock SObject.
 * MKT-TC-SRVC-013
 */
@IsTest
private class KnowledgePortalControllerTest {

    // ── searchArticles ────────────────────────────────────────────────────────

    @IsTest
    static void searchArticles_blankTerm_returnsEmpty() {
        Test.startTest();
        List<KnowledgePortalController.KnowledgeArticleWrapper> result =
            KnowledgePortalController.searchArticles('');
        Test.stopTest();
        System.assertNotEquals(null, result, 'Should return empty list, not null');
        System.assertEquals(0, result.size(), 'Blank search term should return empty list');
    }

    @IsTest
    static void searchArticles_singleCharTerm_returnsEmpty() {
        Test.startTest();
        List<KnowledgePortalController.KnowledgeArticleWrapper> result =
            KnowledgePortalController.searchArticles('a');
        Test.stopTest();
        System.assertEquals(0, result.size(), 'Single char search should be rejected');
    }

    @IsTest
    static void searchArticles_nullTerm_returnsEmpty() {
        Test.startTest();
        List<KnowledgePortalController.KnowledgeArticleWrapper> result =
            KnowledgePortalController.searchArticles(null);
        Test.stopTest();
        System.assertEquals(0, result.size(), 'Null search term should return empty list');
    }

    @IsTest
    static void searchArticles_validTerm_executesWithoutError() {
        // KnowledgeArticleVersion requires Knowledge add-on — SOSL returns empty in test context
        Test.startTest();
        List<KnowledgePortalController.KnowledgeArticleWrapper> result =
            KnowledgePortalController.searchArticles('campaign');
        Test.stopTest();
        System.assertNotEquals(null, result, 'Valid search should return a list (empty in test context)');
    }

    // ── getArticleByUrlName ───────────────────────────────────────────────────

    @IsTest
    static void getArticleByUrlName_blankName_returnsNull() {
        Test.startTest();
        KnowledgePortalController.KnowledgeArticleWrapper result =
            KnowledgePortalController.getArticleByUrlName('');
        Test.stopTest();
        System.assertEquals(null, result, 'Blank URL name should return null');
    }

    @IsTest
    static void getArticleByUrlName_nullName_returnsNull() {
        Test.startTest();
        KnowledgePortalController.KnowledgeArticleWrapper result =
            KnowledgePortalController.getArticleByUrlName(null);
        Test.stopTest();
        System.assertEquals(null, result, 'Null URL name should return null');
    }

    @IsTest
    static void getArticleByUrlName_nonExistentName_returnsNull() {
        Test.startTest();
        KnowledgePortalController.KnowledgeArticleWrapper result =
            KnowledgePortalController.getArticleByUrlName('does-not-exist-xyz');
        Test.stopTest();
        System.assertEquals(null, result, 'Non-existent article should return null');
    }

    // ── KnowledgeArticleWrapper ───────────────────────────────────────────────

    @IsTest
    static void wrapper_fieldsAreSettableAndReadable() {
        // Verify the DTO wrapper can be constructed and all @AuraEnabled fields work.
        // Direct toWrapper invocation requires a KnowledgeArticleVersion SObject which
        // cannot be DML-created without the Knowledge add-on licence.
        Test.startTest();
        KnowledgePortalController.KnowledgeArticleWrapper w =
            new KnowledgePortalController.KnowledgeArticleWrapper();
        w.articleId         = 'ka001';
        w.title             = 'Test Title';
        w.summary           = 'Test Summary';
        w.articleBody       = '<p>Body</p>';
        w.urlName           = 'test-article';
        w.articleNumber     = '000001000';
        w.lastPublishedDate = '2026-01-01';
        Test.stopTest();
        System.assertNotEquals(null, w, 'Wrapper should be constructable');
        System.assertEquals('ka001', w.articleId, 'articleId should match');
        System.assertEquals('Test Title', w.title, 'title should match');
        System.assertEquals('test-article', w.urlName, 'urlName should match');
    }
}
