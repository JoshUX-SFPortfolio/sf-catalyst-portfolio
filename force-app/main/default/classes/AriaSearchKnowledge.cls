/**
 * AriaSearchKnowledge
 * Invocable action: searches published Knowledge articles for the Aria agent.
 * Returns a single Result with a plain-text summary string — Agentforce Builder
 * requires actions to return a single output object, not a collection.
 * Uses dynamic SOSL so the class compiles in orgs without the Knowledge add-on.
 * When Knowledge is not enabled, returns a graceful empty response.
 * Aria agent action — MKT-REQ-EXP-012, MKT-REQ-EXP-013
 */
public with sharing class AriaSearchKnowledge {

    public class Request {
        @InvocableVariable(label='Search Term' description='The keyword or phrase to search for in the knowledge base.' required=true)
        public String searchTerm;
    }

    public class Result {
        @InvocableVariable(label='Articles Summary' description='Plain-text summary of matching Knowledge articles including title, summary, and URL name.')
        public String articlesSummary;
    }

    @InvocableMethod(
        label='Search Knowledge'
        description='Searches published Catalyst Knowledge articles for the given search term. Returns matching article titles and summaries. Use this when a client asks a product, setup, or how-to question that may be answered by a knowledge article.'
        callout=true
    )
    public static List<Result> searchKnowledge(List<Request> requests) {
        Result r = new Result();

        if (requests == null || requests.isEmpty()) {
            r.articlesSummary = 'No search term provided.';
            return new List<Result>{ r };
        }

        String rawTerm = requests[0].searchTerm;
        if (String.isBlank(rawTerm) || rawTerm.trim().length() < 2) {
            r.articlesSummary = 'Please provide a more specific search term.';
            return new List<Result>{ r };
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
            if (soslResults[0].isEmpty()) {
                r.articlesSummary = 'No knowledge articles found for "' + rawTerm.trim() + '".';
                return new List<Result>{ r };
            }

            List<String> lines = new List<String>();
            for (SObject sobj : soslResults[0]) {
                String title   = (String) sobj.get('Title');
                String summary = (String) sobj.get('Summary');
                String urlName = (String) sobj.get('UrlName');
                lines.add(title + ': ' + (String.isBlank(summary) ? '(no summary)' : summary) + ' [' + urlName + ']');
            }
            r.articlesSummary = String.join(lines, '\n');
        } catch (Exception ex) {
            r.articlesSummary = 'Knowledge base search is not available at this time.';
        }

        return new List<Result>{ r };
    }
}
