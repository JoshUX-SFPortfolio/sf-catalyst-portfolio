trigger PortalUserGroupTrigger on Portal_User_Group__c (before insert) {
    new PortalUserGroupTriggerHandler().run();
}
