/**
 * AriaGetCaseStatus
 * Invocable action: returns open cases for the authenticated Catalyst portal user.
 * Returns a single Result with a plain-text summary string — Agentforce Builder
 * requires actions to return a single output object, not a collection.
 * Aria agent action — MKT-REQ-EXP-012, MKT-REQ-EXP-013
 */
public with sharing class AriaGetCaseStatus {

    public class Request {
        @InvocableVariable(label='Placeholder' description='Not used — pass any string.' required=false)
        public String placeholder;
    }

    public class Result {
        @InvocableVariable(label='Cases Summary' description='Plain-text summary of open support cases.')
        public String casesSummary;
    }

    @InvocableMethod(
        label='Get Case Status'
        description='Returns a summary of the authenticated Catalyst portal user\'s open support cases including case number, subject, status, and last modified date.'
        callout=true
    )
    public static List<Result> getCaseStatus(List<Request> requests) {
        Result r = new Result();
        Id accountId = AriaActionController.getPortalUserAccountId();
        if (accountId == null) {
            r.casesSummary = 'No open cases found.';
            return new List<Result>{ r };
        }

        List<Case> cases = [
            SELECT CaseNumber, Subject, Status, LastModifiedDate
            FROM Case
            WHERE AccountId = :accountId
              AND IsClosed = false
            WITH USER_MODE
            ORDER BY LastModifiedDate DESC
            LIMIT 5
        ];

        if (cases.isEmpty()) {
            r.casesSummary = 'You have no open support cases.';
            return new List<Result>{ r };
        }

        List<String> lines = new List<String>();
        for (Case c : cases) {
            lines.add(
                c.CaseNumber + ' | ' + c.Subject +
                ' | Status: ' + c.Status +
                ' | Last updated: ' + String.valueOf(c.LastModifiedDate.date())
            );
        }
        r.casesSummary = String.join(lines, '\n');
        return new List<Result>{ r };
    }
}
