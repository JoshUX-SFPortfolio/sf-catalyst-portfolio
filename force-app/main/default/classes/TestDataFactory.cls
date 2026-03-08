/**
 * TestDataFactory
 * Centralised test data creation for all Apex test classes.
 * Never create data inline in test classes — always use this factory.
 *
 * All methods return the inserted SObject(s) unless the method name ends in
 * "NoInsert", in which case only the object is built and NOT inserted.
 */
@IsTest
public class TestDataFactory {

    // ─── Account ──────────────────────────────────────────────────────────────

    public static Account createAccount(String name) {
        Account a = new Account(
            Name = name,
            Type = 'Customer'
        );
        insert a;
        return a;
    }

    public static List<Account> createAccounts(Integer count) {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < count; i++) {
            accounts.add(new Account(
                Name = 'Test Account ' + i,
                Type = 'Customer'
            ));
        }
        insert accounts;
        return accounts;
    }

    // ─── Contact ──────────────────────────────────────────────────────────────

    public static Contact createContact(Id accountId, String firstName, String lastName) {
        Contact c = new Contact(
            AccountId = accountId,
            FirstName = firstName,
            LastName  = lastName,
            Email     = firstName.toLowerCase() + '.' + lastName.toLowerCase() + '@example.com'
        );
        insert c;
        return c;
    }

    // ─── Opportunity ──────────────────────────────────────────────────────────

    public static Opportunity createOpportunity(Id accountId, String name, String stage, Date closeDate) {
        Opportunity o = new Opportunity(
            AccountId   = accountId,
            Name        = name,
            StageName   = stage,
            CloseDate   = closeDate
        );
        insert o;
        return o;
    }

    // ─── Case ─────────────────────────────────────────────────────────────────

    public static Case createCase(Id accountId, Id contactId, String subject) {
        Case c = new Case(
            AccountId = accountId,
            ContactId = contactId,
            Subject   = subject,
            Status    = 'New',
            Origin    = 'Web'
        );
        insert c;
        return c;
    }

    public static List<Case> createCases(Id accountId, Integer count) {
        List<Case> cases = new List<Case>();
        for (Integer i = 0; i < count; i++) {
            cases.add(new Case(
                AccountId = accountId,
                Subject   = 'Test Case ' + i,
                Status    = 'New',
                Origin    = 'Web'
            ));
        }
        insert cases;
        return cases;
    }

    // ─── Entitlement ──────────────────────────────────────────────────────────

    public static Entitlement createEntitlement(Id accountId, String name) {
        Entitlement e = new Entitlement(
            AccountId = accountId,
            Name      = name,
            StartDate = Date.today(),
            EndDate   = Date.today().addYears(1)
        );
        insert e;
        return e;
    }

    // ─── Project__c ───────────────────────────────────────────────────────────

    public static Project__c createProject(Id accountId, String name) {
        Project__c p = new Project__c(
            Account__c  = accountId,
            Name        = name,
            Status__c   = 'Planning',
            Start_Date__c = Date.today()
        );
        insert p;
        return p;
    }

    public static Project__c createProjectNoInsert(Id accountId, String name, String status) {
        return new Project__c(
            Account__c  = accountId,
            Name        = name,
            Status__c   = status,
            Start_Date__c = Date.today()
        );
    }

    // ─── Asset_Item__c ────────────────────────────────────────────────────────

    public static Asset_Item__c createAssetItem(Id accountId, String assetType) {
        Asset_Item__c a = new Asset_Item__c(
            Account__c    = accountId,
            Asset_Type__c = assetType
        );
        insert a;
        return a;
    }

    public static Asset_Item__c createAssetItemNoInsert(Id accountId, String assetType) {
        return new Asset_Item__c(
            Account__c    = accountId,
            Asset_Type__c = assetType
        );
    }

    // ─── Feedback_Survey__c ───────────────────────────────────────────────────

    public static Feedback_Survey__c createFeedbackSurvey(Id contactId, Id caseId, Integer csat, Integer nps) {
        Feedback_Survey__c s = new Feedback_Survey__c(
            Contact__c    = contactId,
            Case__c       = caseId,
            CSAT_Score__c = csat,
            NPS_Score__c  = nps,
            Status__c     = 'Sent',
            Survey_Type__c = 'CSAT'
        );
        insert s;
        return s;
    }

    // ─── Portal_User_Group__c ─────────────────────────────────────────────────

    public static Portal_User_Group__c createPortalUserGroup(Id accountId, Id contactId, String role) {
        Portal_User_Group__c g = new Portal_User_Group__c(
            Account__c   = accountId,
            Contact__c   = contactId,
            Portal_Role__c = role,
            Is_Active__c = true
        );
        insert g;
        return g;
    }

    // ─── Service_Region__c ────────────────────────────────────────────────────

    public static Service_Region__c createServiceRegion(Id accountId, String region) {
        Service_Region__c r = new Service_Region__c(
            Account__c = accountId,
            Region__c  = region
        );
        insert r;
        return r;
    }
}
