/**
 * OnboardingPortalController
 * Apex controller for the onboarding checklist component.
 * Returns Project__c records in Onboarding status for the portal user's Account.
 * MKT-REQ-EXP-010, MKT-REQ-EXP-011, MKT-REQ-NFR-003, MKT-REQ-NFR-004
 */
public with sharing class OnboardingPortalController {

    /**
     * Returns the onboarding project and a checklist of steps.
     * Steps are represented as structured data from the project description
     * for the portal phase; in a production implementation these would be
     * a dedicated child object. Returns a wrapper for easy LWC consumption.
     * MKT-REQ-EXP-010
     */
    @AuraEnabled(cacheable=true)
    public static OnboardingWrapper getOnboardingData() {
        Id accountId = getPortalUserAccountId();
        if (accountId == null) {
            return null;
        }

        List<Project__c> projects = [
            SELECT Id, Name, Status__c, Start_Date__c, End_Date__c, Description__c
            FROM Project__c
            WHERE Account__c = :accountId
              AND Status__c IN ('Planning', 'Active')
            WITH USER_MODE
            ORDER BY CreatedDate ASC
            LIMIT 1
        ];

        if (projects.isEmpty()) {
            return null;
        }

        OnboardingWrapper wrapper = new OnboardingWrapper();
        wrapper.projectId    = projects[0].Id;
        wrapper.projectName  = projects[0].Name;
        wrapper.status       = projects[0].Status__c;
        wrapper.startDate    = projects[0].Start_Date__c;
        wrapper.endDate      = projects[0].End_Date__c;
        wrapper.steps        = buildDefaultSteps();

        return wrapper;
    }

    // ── Wrapper ──────────────────────────────────────────────────────────────

    public class OnboardingWrapper {
        @AuraEnabled public Id      projectId;
        @AuraEnabled public String  projectName;
        @AuraEnabled public String  status;
        @AuraEnabled public Date    startDate;
        @AuraEnabled public Date    endDate;
        @AuraEnabled public List<OnboardingStep> steps;
    }

    public class OnboardingStep {
        @AuraEnabled public Integer stepNumber;
        @AuraEnabled public String  label;
        @AuraEnabled public String  description;
        @AuraEnabled public Boolean isComplete;
        @AuraEnabled public String  resourceUrl;
    }

    // ── Private helpers ──────────────────────────────────────────────────────

    @TestVisible
    private static Id getPortalUserAccountId() {
        List<User> users = [
            SELECT AccountId FROM User
            WHERE Id = :UserInfo.getUserId()
            WITH USER_MODE
            LIMIT 1
        ];
        return (users.isEmpty() || users[0].AccountId == null) ? null : users[0].AccountId;
    }

    /**
     * Returns the standard Catalyst onboarding checklist.
     * In a production build, completion state would be persisted on a child object.
     * For the portfolio, steps are returned with isComplete = false as a demonstration.
     */
    @TestVisible
    private static List<OnboardingStep> buildDefaultSteps() {
        List<OnboardingStep> steps = new List<OnboardingStep>();

        String[][] stepData = new String[][] {
            new String[] { '1', 'Activate your account', 'Complete your profile and set your password.', '/onboarding/step1' },
            new String[] { '2', 'Connect your data sources', 'Link your CRM and ad platforms to Campaign Intelligence.', '/onboarding/step2' },
            new String[] { '3', 'Configure audience segments', 'Build your first segment in Audience Studio.', '/onboarding/step3' },
            new String[] { '4', 'Set up attribution model', 'Choose your attribution window in the Attribution Engine.', '/onboarding/step4' },
            new String[] { '5', 'Upload brand assets', 'Add logos, colours, and templates to Content Hub.', '/onboarding/step5' },
            new String[] { '6', 'Launch first campaign', 'Create and publish your first campaign.', '/onboarding/step6' }
        };

        for (String[] row : stepData) {
            OnboardingStep step = new OnboardingStep();
            step.stepNumber  = Integer.valueOf(row[0]);
            step.label       = row[1];
            step.description = row[2];
            step.isComplete  = false;
            step.resourceUrl = row[3];
            steps.add(step);
        }

        return steps;
    }
}
