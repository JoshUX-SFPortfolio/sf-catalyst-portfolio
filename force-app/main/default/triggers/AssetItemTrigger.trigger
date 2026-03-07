trigger AssetItemTrigger on Asset_Item__c (before insert) {
    new AssetItemTriggerHandler().run();
}
