/**
 * TriggerHandlerTest
 * Tests the TriggerHandler framework: bypass mechanism and exception path.
 * MKT-TC-SRVC-001
 */
@IsTest
private class TriggerHandlerTest {

    // ─── Bypass API ───────────────────────────────────────────────────────────

    @IsTest
    static void bypass_preventsHandlerFromRunning() {
        TriggerHandler.bypass('CaseTriggerHandler');
        System.assert(TriggerHandler.isBypassed('CaseTriggerHandler'), 'Handler should be bypassed');
    }

    @IsTest
    static void clearBypass_removesSpecificHandler() {
        TriggerHandler.bypass('CaseTriggerHandler');
        TriggerHandler.bypass('ProjectTriggerHandler');
        TriggerHandler.clearBypass('CaseTriggerHandler');

        System.assert(!TriggerHandler.isBypassed('CaseTriggerHandler'), 'CaseTriggerHandler should be cleared');
        System.assert(TriggerHandler.isBypassed('ProjectTriggerHandler'), 'ProjectTriggerHandler should still be bypassed');
    }

    @IsTest
    static void clearAllBypasses_removesAll() {
        TriggerHandler.bypass('CaseTriggerHandler');
        TriggerHandler.bypass('ProjectTriggerHandler');
        TriggerHandler.clearAllBypasses();

        System.assert(!TriggerHandler.isBypassed('CaseTriggerHandler'), 'All bypasses should be cleared');
        System.assert(!TriggerHandler.isBypassed('ProjectTriggerHandler'), 'All bypasses should be cleared');
    }

    @IsTest
    static void isBypassed_returnsFalse_forUnregisteredHandler() {
        TriggerHandler.clearAllBypasses();
        System.assert(!TriggerHandler.isBypassed('NonExistentHandler'), 'Should not be bypassed');
    }

    // ─── Exception path ───────────────────────────────────────────────────────

    @IsTest
    static void run_outsideTriggerContext_throwsException() {
        // TriggerHandler.run() is protected by Trigger.isExecuting — calling it
        // outside a trigger context raises TriggerHandlerException.
        // We verify the exception type via a concrete stub.
        Boolean exceptionThrown = false;
        try {
            new CaseTriggerHandler().run();
        } catch (TriggerHandler.TriggerHandlerException e) {
            exceptionThrown = true;
        }
        System.assert(exceptionThrown, 'TriggerHandlerException should be thrown outside trigger context');
    }
}
