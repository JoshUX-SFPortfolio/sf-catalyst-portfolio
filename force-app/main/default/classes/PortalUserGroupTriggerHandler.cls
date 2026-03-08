/**
 * PortalUserGroupTriggerHandler
 * Handles all trigger logic for the Portal_User_Group__c custom object.
 */
public with sharing class PortalUserGroupTriggerHandler extends TriggerHandler {

    private List<Portal_User_Group__c> newList;
    private List<Portal_User_Group__c> oldList;
    private Map<Id, Portal_User_Group__c> newMap;
    private Map<Id, Portal_User_Group__c> oldMap;

    public PortalUserGroupTriggerHandler() {
        this.newList = (List<Portal_User_Group__c>) Trigger.new;
        this.oldList = (List<Portal_User_Group__c>) Trigger.old;
        this.newMap  = (Map<Id, Portal_User_Group__c>) Trigger.newMap;
        this.oldMap  = (Map<Id, Portal_User_Group__c>) Trigger.oldMap;
    }

    // Placeholder — portal group logic added in A.7 Experience Cloud phase
    protected override void beforeInsert() {}
}
