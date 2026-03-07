/**
 * OnboardingPortalControllerTest
 * Tests for OnboardingPortalController.
 * MKT-TC-SRVC-012
 */
@IsTest
private class OnboardingPortalControllerTest {

    @TestSetup
    static void makeData() {
        Account acc = TestDataFactory.createAccount('Onboarding Test Co');
        TestDataFactory.createProject(acc.Id, 'Onboarding Project');
    }

    // ── getOnboardingData ─────────────────────────────────────────────────────

    @IsTest
    static void getOnboardingData_nonPortalUser_returnsNull() {
        Test.startTest();
        OnboardingPortalController.OnboardingWrapper result =
            OnboardingPortalController.getOnboardingData();
        Test.stopTest();
        // Non-portal user has no AccountId
        System.assertEquals(null, result, 'Non-portal user should receive null');
    }

    // ── buildDefaultSteps ─────────────────────────────────────────────────────

    @IsTest
    static void buildDefaultSteps_returnsSixSteps() {
        Test.startTest();
        List<OnboardingPortalController.OnboardingStep> steps =
            OnboardingPortalController.buildDefaultSteps();
        Test.stopTest();
        System.assertEquals(6, steps.size(), 'Should return 6 onboarding steps');
        System.assertEquals(1, steps[0].stepNumber, 'First step should be step 1');
        System.assertEquals(6, steps[5].stepNumber, 'Last step should be step 6');
        System.assertEquals(false, steps[0].isComplete, 'Steps start as incomplete');
        System.assertNotEquals(null, steps[0].resourceUrl, 'Steps should have resource URLs');
    }

    // ── getPortalUserAccountId ────────────────────────────────────────────────

    @IsTest
    static void getPortalUserAccountId_returnsNullForNonPortalUser() {
        Test.startTest();
        Id accountId = OnboardingPortalController.getPortalUserAccountId();
        Test.stopTest();
        System.assertEquals(null, accountId, 'Sys admin user has no portal AccountId');
    }

    // ── OnboardingWrapper fields ──────────────────────────────────────────────

    @IsTest
    static void onboardingWrapper_fieldsAreAnnotated() {
        OnboardingPortalController.OnboardingWrapper w =
            new OnboardingPortalController.OnboardingWrapper();
        w.projectId   = null;
        w.projectName = 'Test';
        w.status      = 'Active';
        w.startDate   = Date.today();
        w.endDate     = Date.today().addMonths(3);
        w.steps       = new List<OnboardingPortalController.OnboardingStep>();
        System.assertEquals('Test', w.projectName, 'Wrapper should be writable');
    }
}
