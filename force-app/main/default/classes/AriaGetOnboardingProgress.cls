/**
 * AriaGetOnboardingProgress
 * Invocable action: returns onboarding completion % and next step for the portal user.
 * Delegates to OnboardingPortalController for project lookup.
 * Aria agent action — MKT-REQ-EXP-012, MKT-REQ-EXP-013
 */
public with sharing class AriaGetOnboardingProgress {

    public class Request {
        @InvocableVariable public String placeholder;
    }

    public class Result {
        @InvocableVariable public Integer percentComplete;
        @InvocableVariable public String  nextStepLabel;
        @InvocableVariable public String  projectName;
    }

    @InvocableMethod(
        label='Get Onboarding Progress'
        description='Returns the authenticated Catalyst portal user\'s onboarding completion percentage and next incomplete setup step.'
    )
    public static List<Result> getOnboardingProgress(List<Request> requests) {
        List<Result> results = new List<Result>();
        Result r = new Result();

        OnboardingPortalController.OnboardingWrapper data =
            OnboardingPortalController.getOnboardingData();

        if (data == null || data.steps == null || data.steps.isEmpty()) {
            r.percentComplete = 0;
            r.nextStepLabel   = 'No onboarding project found.';
            r.projectName     = '';
            results.add(r);
            return results;
        }

        Integer total    = data.steps.size();
        Integer complete = 0;
        String  nextStep = null;

        for (OnboardingPortalController.OnboardingStep step : data.steps) {
            if (step.isComplete) {
                complete++;
            } else if (nextStep == null) {
                nextStep = step.label;
            }
        }

        r.percentComplete = (Integer) Math.round((Decimal) complete / total * 100);
        r.nextStepLabel   = nextStep != null ? nextStep : 'All steps complete!';
        r.projectName     = data.projectName;
        results.add(r);

        return results;
    }
}
