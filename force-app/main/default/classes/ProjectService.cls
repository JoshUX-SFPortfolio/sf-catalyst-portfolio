/**
 * ProjectService
 * Business logic for the Project__c custom object.
 */
public with sharing class ProjectService {

    /**
     * Defaults Status to 'Planning' on insert if not already set.
     */
    public static void setDefaultStatus(List<Project__c> newProjects) {
        for (Project__c p : newProjects) {
            if (String.isBlank(p.Status__c)) {
                p.Status__c = 'Planning';
            }
        }
    }

    /**
     * Prevents status from moving directly from 'Planning' to 'Completed'
     * without passing through 'Active'.
     */
    public static void validateStatusTransition(List<Project__c> newProjects, Map<Id, Project__c> oldMap) {
        for (Project__c p : newProjects) {
            Project__c old = oldMap.get(p.Id);
            if (old.Status__c == 'Planning' && p.Status__c == 'Completed') {
                p.Status__c.addError(
                    'A Project cannot move directly from Planning to Completed. Set it to Active first.'
                );
            }
        }
    }
}
