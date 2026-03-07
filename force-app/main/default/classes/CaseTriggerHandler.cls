/**
 * CaseTriggerHandler
 * Handles all trigger logic for the Case standard object.
 * Delegates to CaseService for business logic — no logic in this class body.
 */
public with sharing class CaseTriggerHandler extends TriggerHandler {

    private List<Case> newList;
    private List<Case> oldList;
    private Map<Id, Case> newMap;
    private Map<Id, Case> oldMap;

    public CaseTriggerHandler() {
        this.newList = (List<Case>) Trigger.new;
        this.oldList = (List<Case>) Trigger.old;
        this.newMap  = (Map<Id, Case>) Trigger.newMap;
        this.oldMap  = (Map<Id, Case>) Trigger.oldMap;
    }

    protected override void beforeInsert() {
        CaseService.setEntitlementOnInsert(newList);
    }

    protected override void beforeUpdate() {
        CaseService.setEntitlementOnUpdate(newList, oldMap);
    }

    protected override void afterInsert() {
        CaseService.sendNewCaseNotification(newList);
    }
}
