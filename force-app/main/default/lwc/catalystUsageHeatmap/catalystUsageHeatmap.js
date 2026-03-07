import { LightningElement, track } from 'lwc';
import getSubscriptionData from '@salesforce/apex/SubscriptionPortalController.getSubscriptionData';
import getActiveModules from '@salesforce/apex/SubscriptionPortalController.getActiveModules';

// Simulated per-module usage percentages (would come from UsageAPIService stub in a full impl)
const MODULE_USAGE_MOCK = {
    'Campaign Intelligence': 85,
    'Audience Studio':       72,
    'Attribution Engine':    60,
    'Content Hub':           45
};

export default class CatalystUsageHeatmap extends LightningElement {
    @track account = null;
    @track modules = [];
    @track isLoading = false;

    connectedCallback() {
        this.loadData();
    }

    loadData() {
        this.isLoading = true;
        Promise.all([
            getSubscriptionData(),
            getActiveModules()
        ])
            .then(([account, modules]) => {
                this.account = account;
                this.modules = modules.map(m => ({
                    ...m,
                    simulatedUsage: MODULE_USAGE_MOCK[m.Module__c] ?? 50
                }));
            })
            .catch(err => {
                console.error('CatalystUsageHeatmap load error:', err);
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    get usageIndex() {
        return Math.round(this.account?.Platform_Usage_Index__c ?? 0);
    }

    get usageIndexClass() {
        const idx = this.usageIndex;
        if (idx >= 70) return 'slds-text-color_success slds-text-heading_small';
        if (idx >= 40) return 'slds-text-color_weak slds-text-heading_small';
        return 'slds-text-color_error slds-text-heading_small';
    }

    get progressVariant() {
        return this.usageIndex >= 70 ? 'base' : 'base';
    }

    get hasData() {
        return !this.isLoading && this.account !== null;
    }

    get noData() {
        return !this.isLoading && this.account === null;
    }
}
