/**
 * AriaActionController
 * Shared utility class for the Aria Agentforce agent actions.
 * Provides portal user context helpers reused by the three action classes:
 *   AriaGetCaseStatus, AriaGetOnboardingProgress, AriaEscalateToAgent.
 *
 * MKT-REQ-EXP-012, MKT-REQ-EXP-013, MKT-REQ-EXP-015
 */
public with sharing class AriaActionController {

    @TestVisible
    public static Id getPortalUserAccountId() {
        List<User> users = [
            SELECT AccountId FROM User
            WHERE Id = :UserInfo.getUserId()
            WITH USER_MODE
            LIMIT 1
        ];
        return (users.isEmpty() || users[0].AccountId == null) ? null : users[0].AccountId;
    }

    @TestVisible
    public static Id getPortalUserContactId() {
        List<User> users = [
            SELECT ContactId FROM User
            WHERE Id = :UserInfo.getUserId()
            WITH USER_MODE
            LIMIT 1
        ];
        return (users.isEmpty() || users[0].ContactId == null) ? null : users[0].ContactId;
    }
}
