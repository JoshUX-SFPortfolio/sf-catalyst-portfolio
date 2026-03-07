/**
 * AssetItemTriggerHandler
 * Handles all trigger logic for the Asset_Item__c custom object.
 */
public with sharing class AssetItemTriggerHandler extends TriggerHandler {

    private List<Asset_Item__c> newList;
    private List<Asset_Item__c> oldList;
    private Map<Id, Asset_Item__c> newMap;
    private Map<Id, Asset_Item__c> oldMap;

    public AssetItemTriggerHandler() {
        this.newList = (List<Asset_Item__c>) Trigger.new;
        this.oldList = (List<Asset_Item__c>) Trigger.old;
        this.newMap  = (Map<Id, Asset_Item__c>) Trigger.newMap;
        this.oldMap  = (Map<Id, Asset_Item__c>) Trigger.oldMap;
    }

    protected override void beforeInsert() {
        AssetItemService.setDefaultStatus(newList);
    }
}
