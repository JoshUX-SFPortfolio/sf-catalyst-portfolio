/**
 * AriaGetCaseStatus
 * Invocable action: returns open cases for the authenticated Catalyst portal user.
 * Aria agent action — MKT-REQ-EXP-012, MKT-REQ-EXP-013
 */
public with sharing class AriaGetCaseStatus {

    public class Request {
        @InvocableVariable public String placeholder;
    }

    public class Result {
        @InvocableVariable public String caseNumber;
        @InvocableVariable public String subject;
        @InvocableVariable public String status;
        @InvocableVariable public String lastModified;
    }

    @InvocableMethod(
        label='Get Case Status'
        description='Returns up to 5 open support cases for the authenticated Catalyst portal user, including case number, subject, status, and last modified date.'
    )
    public static List<Result> getCaseStatus(List<Request> requests) {
        List<Result> results = new List<Result>();
        Id accountId = AriaActionController.getPortalUserAccountId();
        if (accountId == null) {
            return results;
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

        for (Case c : cases) {
            Result r      = new Result();
            r.caseNumber  = c.CaseNumber;
            r.subject     = c.Subject;
            r.status      = c.Status;
            r.lastModified = String.valueOf(c.LastModifiedDate.date());
            results.add(r);
        }

        return results;
    }
}
