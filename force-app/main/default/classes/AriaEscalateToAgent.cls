/**
 * AriaEscalateToAgent
 * Invocable action: creates a Case pre-populated from the Aria conversation,
 * routed to the service queue with Origin = 'Chat'.
 * Aria agent action — MKT-REQ-EXP-013, MKT-REQ-EXP-015
 */
public with sharing class AriaEscalateToAgent {

    public class Request {
        @InvocableVariable(required=true) public String subject;
        @InvocableVariable public String description;
    }

    public class Result {
        @InvocableVariable public String caseId;
        @InvocableVariable public String caseNumber;
    }

    @InvocableMethod(
        label='Escalate To Agent'
        description='Creates a support case pre-populated from the Aria conversation and routes it to the service queue. Use this when the client\'s issue cannot be resolved by self-service or when they ask to speak to a person.'
    )
    public static List<Result> escalateToAgent(List<Request> requests) {
        List<Result> results = new List<Result>();
        if (requests == null || requests.isEmpty()) {
            return results;
        }

        Request req = requests[0];
        Id accountId = AriaActionController.getPortalUserAccountId();
        Id contactId = AriaActionController.getPortalUserContactId();

        Case c = new Case(
            Subject     = req.subject,
            Description = req.description,
            AccountId   = accountId,
            ContactId   = contactId,
            Origin      = 'Chat',
            Status      = 'New'
        );

        insert as user c;

        List<Case> inserted = [
            SELECT Id, CaseNumber FROM Case WHERE Id = :c.Id WITH USER_MODE LIMIT 1
        ];

        Result r     = new Result();
        r.caseId     = String.valueOf(c.Id);
        r.caseNumber = inserted.isEmpty() ? '' : inserted[0].CaseNumber;
        results.add(r);

        return results;
    }
}
