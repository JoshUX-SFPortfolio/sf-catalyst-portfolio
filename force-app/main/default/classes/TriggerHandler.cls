/**
 * TriggerHandler
 * Abstract base class for the trigger handler framework.
 * One trigger per object delegates to a concrete handler that extends this class.
 *
 * Usage:
 *   trigger CaseTrigger on Case (before insert, before update, after insert, after update) {
 *       new CaseTriggerHandler().run();
 *   }
 *
 * Supports bypass via TriggerHandler.bypass('CaseTriggerHandler') in tests.
 */
public abstract class TriggerHandler {

    private static Set<String> bypassedHandlers = new Set<String>();

    private String handlerName;

    public TriggerHandler() {
        this.handlerName = getHandlerName();
    }

    // ─── Public entry point ───────────────────────────────────────────────────

    public void run() {
        if (isBypassed(handlerName)) {
            return;
        }

        if (!Trigger.isExecuting) {
            throw new TriggerHandlerException('TriggerHandler.run() called outside of a trigger context.');
        }

        dispatch();
    }

    // ─── Bypass API ───────────────────────────────────────────────────────────

    public static void bypass(String handlerName) {
        bypassedHandlers.add(handlerName);
    }

    public static void clearBypass(String handlerName) {
        bypassedHandlers.remove(handlerName);
    }

    public static void clearAllBypasses() {
        bypassedHandlers.clear();
    }

    public static Boolean isBypassed(String handlerName) {
        return bypassedHandlers.contains(handlerName);
    }

    // ─── Override hooks ───────────────────────────────────────────────────────

    @TestVisible protected virtual void beforeInsert() {}
    @TestVisible protected virtual void beforeUpdate() {}
    @TestVisible protected virtual void beforeDelete() {}
    @TestVisible protected virtual void afterInsert() {}
    @TestVisible protected virtual void afterUpdate() {}
    @TestVisible protected virtual void afterDelete() {}
    @TestVisible protected virtual void afterUndelete() {}

    // ─── Private ──────────────────────────────────────────────────────────────

    private void dispatch() {
        if (Trigger.isBefore) {
            if (Trigger.isInsert)  { beforeInsert(); }
            if (Trigger.isUpdate)  { beforeUpdate(); }
            if (Trigger.isDelete)  { beforeDelete(); }
        } else {
            if (Trigger.isInsert)  { afterInsert(); }
            if (Trigger.isUpdate)  { afterUpdate(); }
            if (Trigger.isDelete)  { afterDelete(); }
            if (Trigger.isUndelete){ afterUndelete(); }
        }
    }

    private String getHandlerName() {
        return String.valueOf(this).substringBefore(':');
    }

    // ─── Exception ────────────────────────────────────────────────────────────

    public class TriggerHandlerException extends Exception {}
}
