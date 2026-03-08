/**
 * AriaSearchKnowledge
 * Invocable action: searches published Knowledge articles for the Aria agent.
 * Returns up to 5 matching articles (title, summary, URL name) for the search term.
 * Uses dynamic SOSL so the class compiles in orgs without the Knowledge add-on.
 * When Knowledge is not enabled, returns an empty list gracefully.
 * Aria agent action — MKT-REQ-EXP-012, MKT-REQ-EXP-013
 */
public with sharing class AriaSearchKnowledge {

    public class Request {
        @InvocableVariable(label='Search Term' description='The keyword or phrase to search for in the knowledge base.' required=true)
        public String searchTerm;
    }

    public class Result {
        @InvocableVariable public String title;
        @InvocableVariable public String summary;
        @InvocableVariable public String urlName;
        @InvocableVariable public String articleNumber;
    }

    @InvocableMethod(
        label='Search Knowledge'
        description='Searches published Catalyst Knowledge articles for the given search term. Returns up to 5 matching articles with title, summary, URL name, and article number. Use this when a client asks a product, setup, or how-to question that may be answered by a knowledge article.'
    )
    public static List<Result> searchKnowledge(List<Request> requests) {
        List<Result> results = new List<Result>();
        if (requests == null || requests.isEmpty()) {
            return results;
        }

        String rawTerm = requests[0].searchTerm;
        if (String.isBlank(rawTerm) || rawTerm.trim().length() < 2) {
            return results;
        }

        String sanitised = String.escapeSingleQuotes(rawTerm.trim());
        String sosl =
            'FIND \'' + sanitised + '*\' IN ALL FIELDS ' +
            'RETURNING KnowledgeArticleVersion(' +
            '  Id, Title, Summary, UrlName, ArticleNumber ' +
            '  WHERE PublishStatus = \'Online\' ' +
            '  ORDER BY LastPublishedDate DESC LIMIT 5) ' +
            'WITH USER_MODE';

        try {
            List<List<SObject>> soslResults = Search.query(sosl);
            for (SObject sobj : soslResults[0]) {
                Result r      = new Result();
                r.title         = (String) sobj.get('Title');
                r.summary       = (String) sobj.get('Summary');
                r.urlName       = (String) sobj.get('UrlName');
                r.articleNumber = (String) sobj.get('ArticleNumber');
                results.add(r);
            }
        } catch (Exception ex) {
            // Knowledge not enabled in this org — return empty list gracefully
        }

        return results;
    }
}
