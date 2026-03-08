/**
 * KnowledgePortalController
 * Apex controller for knowledge search and article components on the portal.
 * Uses dynamic SOSL/SOQL so the class compiles in orgs where the Salesforce
 * Knowledge add-on is not yet enabled.  When Knowledge is enabled, the
 * runtime queries execute against KnowledgeArticleVersion; until then the
 * guard logic (blank/short input, missing urlName) returns safe empty results.
 *
 * MKT-REQ-SRVC-010, MKT-REQ-NFR-003, MKT-REQ-NFR-004
 */
public with sharing class KnowledgePortalController {

    /** DTO returned to LWC components. Mirrors KnowledgeArticleVersion fields. */
    public class KnowledgeArticleWrapper {
        @AuraEnabled public String articleId         { get; set; }
        @AuraEnabled public String title             { get; set; }
        @AuraEnabled public String summary           { get; set; }
        @AuraEnabled public String articleBody       { get; set; }
        @AuraEnabled public String urlName           { get; set; }
        @AuraEnabled public String articleNumber     { get; set; }
        @AuraEnabled public String lastPublishedDate { get; set; }
    }

    /**
     * Searches published Knowledge articles using dynamic SOSL.
     * Returns up to 10 results matching the search term.
     * MKT-REQ-SRVC-010
     */
    @AuraEnabled(cacheable=true)
    public static List<KnowledgeArticleWrapper> searchArticles(String searchTerm) {
        if (String.isBlank(searchTerm) || searchTerm.trim().length() < 2) {
            return new List<KnowledgeArticleWrapper>();
        }

        String sanitised = String.escapeSingleQuotes(searchTerm.trim());
        String sosl =
            'FIND \'' + sanitised + '*\' IN ALL FIELDS ' +
            'RETURNING KnowledgeArticleVersion(' +
            '  Id, Title, Summary, UrlName, ArticleNumber, LastPublishedDate ' +
            '  WHERE PublishStatus = \'Online\' ' +
            '  ORDER BY LastPublishedDate DESC LIMIT 10) ' +
            'WITH USER_MODE';

        try {
            List<List<SObject>> results = Search.query(sosl);
            List<KnowledgeArticleWrapper> wrappers = new List<KnowledgeArticleWrapper>();
            for (SObject sobj : results[0]) {
                wrappers.add(toWrapper(sobj));
            }
            return wrappers;
        } catch (Exception ex) {
            // Knowledge not enabled in this org — return empty list gracefully
            return new List<KnowledgeArticleWrapper>();
        }
    }

    /**
     * Returns a single published article by URL name.
     * MKT-REQ-SRVC-010
     */
    @AuraEnabled(cacheable=true)
    public static KnowledgeArticleWrapper getArticleByUrlName(String urlName) {
        if (String.isBlank(urlName)) {
            return null;
        }

        String soql =
            'SELECT Id, Title, Summary, ArticleBody, UrlName, ArticleNumber, LastPublishedDate ' +
            'FROM KnowledgeArticleVersion ' +
            'WHERE UrlName = \'' + String.escapeSingleQuotes(urlName) + '\' ' +
            'AND PublishStatus = \'Online\' ' +
            'WITH USER_MODE ' +
            'LIMIT 1';

        try {
            List<SObject> articles = Database.query(soql);
            return articles.isEmpty() ? null : toWrapper(articles[0]);
        } catch (Exception ex) {
            // Knowledge not enabled in this org — return null gracefully
            return null;
        }
    }

    // ── private helpers ───────────────────────────────────────────────────────

    @TestVisible
    private static KnowledgeArticleWrapper toWrapper(SObject sobj) {
        KnowledgeArticleWrapper w = new KnowledgeArticleWrapper();
        w.articleId         = (String) sobj.get('Id');
        w.title             = (String) sobj.get('Title');
        w.summary           = (String) sobj.get('Summary');
        w.articleBody       = (String) sobj.get('ArticleBody');
        w.urlName           = (String) sobj.get('UrlName');
        w.articleNumber     = (String) sobj.get('ArticleNumber');
        Object lpd          = sobj.get('LastPublishedDate');
        w.lastPublishedDate = lpd != null ? String.valueOf(lpd) : null;
        return w;
    }
}
