import { LightningElement, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getSubscriptionData from '@salesforce/apex/SubscriptionPortalController.getSubscriptionData';

const NINETY_DAYS_MS = 90 * 24 * 60 * 60 * 1000;

export default class CatalystSubscriptionTile extends NavigationMixin(LightningElement) {
    @track account = null;
    @track isLoading = false;
    @track error = null;

    connectedCallback() {
        this.loadSubscription();
    }

    loadSubscription() {
        this.isLoading = true;
        getSubscriptionData()
            .then(data => {
                this.account = data;
            })
            .catch(err => {
                console.error('SubscriptionPortalController.getSubscriptionData error:', err);
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    get renewalDateIso() {
        return this.account?.Contract_Renewal_Date__c
            ? new Date(this.account.Contract_Renewal_Date__c).toISOString()
            : null;
    }

    get isRenewalSoon() {
        if (!this.account?.Contract_Renewal_Date__c) return false;
        const renewal = new Date(this.account.Contract_Renewal_Date__c);
        return (renewal - Date.now()) < NINETY_DAYS_MS;
    }

    get tierBadgeClass() {
        const tier = this.account?.Subscription_Tier__c;
        const base = 'slds-badge tier-badge';
        if (tier === 'Enterprise') return `${base} tier-badge_enterprise`;
        if (tier === 'Professional') return `${base} tier-badge_professional`;
        return `${base} tier-badge_starter`;
    }

    get healthScoreClass() {
        const score = this.account?.Health_Score__c ?? 0;
        if (score >= 70) return 'slds-text-color_success';
        if (score >= 40) return 'slds-text-color_weak';
        return 'slds-text-color_error';
    }

    get noData() {
        return !this.isLoading && !this.account;
    }

    handleViewSubscription() {
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: { url: '/subscription' }
        });
    }
}
