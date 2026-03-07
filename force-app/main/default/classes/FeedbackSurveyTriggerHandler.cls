/**
 * FeedbackSurveyTriggerHandler
 * Handles all trigger logic for the Feedback_Survey__c custom object.
 */
public with sharing class FeedbackSurveyTriggerHandler extends TriggerHandler {

    private List<Feedback_Survey__c> newList;
    private List<Feedback_Survey__c> oldList;
    private Map<Id, Feedback_Survey__c> newMap;
    private Map<Id, Feedback_Survey__c> oldMap;

    public FeedbackSurveyTriggerHandler() {
        this.newList = (List<Feedback_Survey__c>) Trigger.new;
        this.oldList = (List<Feedback_Survey__c>) Trigger.old;
        this.newMap  = (Map<Id, Feedback_Survey__c>) Trigger.newMap;
        this.oldMap  = (Map<Id, Feedback_Survey__c>) Trigger.oldMap;
    }

    protected override void afterInsert() {
        FeedbackSurveyService.flagLowScoreCases(newList);
    }
}
