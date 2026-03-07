trigger FeedbackSurveyTrigger on Feedback_Survey__c (after insert) {
    new FeedbackSurveyTriggerHandler().run();
}
