trigger ProjectTrigger on Project__c (before insert, before update) {
    new ProjectTriggerHandler().run();
}
