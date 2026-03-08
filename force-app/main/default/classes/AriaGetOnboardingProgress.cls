/**
 * AriaGetOnboardingProgress
 * Invocable action: returns onboarding completion % and next step for the portal user.
 * Returns a single Result with a plain-text summary string — Agentforce Builder
 * requires actions to return a single output object, not a collection.
 * Delegates to OnboardingPortalController for project lookup.
 * Aria agent action — MKT-REQ-EXP-012, MKT-REQ-EXP-013
 */
public with sharing class AriaGetOnboardingProgress {

    public class Request {
        @InvocableVariable(label='Placeholder' description='Not used — pass any string.' required=false)
        public String placeholder;
    }

    public class Result {
        @InvocableVariable(label='Onboarding Summary' description='Plain-text summary of onboarding progress including completion percentage and next step.')
        public String onboardingSummary;
    }

    @InvocableMethod(
        label='Get Onboarding Progress'
        description='Returns the authenticated Catalyst portal user\'s onboarding completion percentage, next incomplete setup step, and project name.'
        callout=true
    )
    public static List<Result> getOnboardingProgress(List<Request> requests) {
        Result r = new Result();

        OnboardingPortalController.OnboardingWrapper data =
            OnboardingPortalController.getOnboardingData();

        if (data == null || data.steps == null || data.steps.isEmpty()) {
            r.onboardingSummary = 'No onboarding project found for your account.';
            return new List<Result>{ r };
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

        Integer pct = (Integer) Math.round((Decimal) complete / total * 100);
        String next = nextStep != null ? nextStep : 'All steps complete!';

        r.onboardingSummary =
            'Project: ' + data.projectName + '\n' +
            'Completion: ' + pct + '%\n' +
            'Next step: ' + next;

        return new List<Result>{ r };
    }
}
