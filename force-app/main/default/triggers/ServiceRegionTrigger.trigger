trigger ServiceRegionTrigger on Service_Region__c (before insert) {
    new ServiceRegionTriggerHandler().run();
}
