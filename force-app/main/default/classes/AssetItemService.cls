/**
 * AssetItemService
 * Business logic for the Asset_Item__c custom object.
 */
public with sharing class AssetItemService {

    /**
     * Defaults Status to 'Pending Activation' on insert if not already set.
     */
    public static void setDefaultStatus(List<Asset_Item__c> newItems) {
        for (Asset_Item__c a : newItems) {
            if (String.isBlank(a.Status__c)) {
                a.Status__c = 'Pending Activation';
            }
        }
    }
}
