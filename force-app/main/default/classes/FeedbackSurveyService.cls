/**
 * FeedbackSurveyService
 * Business logic for the Feedback_Survey__c custom object.
 *
 * Low-score flagging: when a survey with CSAT ≤ 2 or NPS ≤ 3 is inserted,
 * the linked Case is flagged for manager review via the Auto_Link_Status__c field.
 */
public with sharing class FeedbackSurveyService {

    private static final Integer CSAT_LOW_THRESHOLD = 2;
    private static final Integer NPS_LOW_THRESHOLD  = 3;

    public static void flagLowScoreCases(List<Feedback_Survey__c> newSurveys) {
        Set<Id> caseIdsToFlag = new Set<Id>();

        for (Feedback_Survey__c s : newSurveys) {
            Boolean lowCsat = s.CSAT_Score__c != null && s.CSAT_Score__c <= CSAT_LOW_THRESHOLD;
            Boolean lowNps  = s.NPS_Score__c  != null && s.NPS_Score__c  <= NPS_LOW_THRESHOLD;
            if (s.Case__c != null && (lowCsat || lowNps)) {
                caseIdsToFlag.add(s.Case__c);
            }
        }

        if (caseIdsToFlag.isEmpty()) {
            return;
        }

        List<Case> casesToUpdate = new List<Case>();
        for (Id caseId : caseIdsToFlag) {
            casesToUpdate.add(new Case(
                Id = caseId,
                Auto_Link_Status__c = 'Pending Manual Review'
            ));
        }

        update casesToUpdate;
    }
}
