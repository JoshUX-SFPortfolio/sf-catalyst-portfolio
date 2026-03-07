/**
 * ProjectTriggerHandler
 * Handles all trigger logic for the Project__c custom object.
 * Extend with business logic methods as the project grows.
 */
public with sharing class ProjectTriggerHandler extends TriggerHandler {

    private List<Project__c> newList;
    private List<Project__c> oldList;
    private Map<Id, Project__c> newMap;
    private Map<Id, Project__c> oldMap;

    public ProjectTriggerHandler() {
        this.newList = (List<Project__c>) Trigger.new;
        this.oldList = (List<Project__c>) Trigger.old;
        this.newMap  = (Map<Id, Project__c>) Trigger.newMap;
        this.oldMap  = (Map<Id, Project__c>) Trigger.oldMap;
    }

    protected override void beforeInsert() {
        ProjectService.setDefaultStatus(newList);
    }

    protected override void beforeUpdate() {
        ProjectService.validateStatusTransition(newList, oldMap);
    }
}
