import { LightningElement, track } from 'lwc';
import getActiveModules from '@salesforce/apex/SubscriptionPortalController.getActiveModules';

const MODULE_ICONS = {
    'Campaign Intelligence': 'standard:campaign',
    'Audience Studio':       'standard:audience_targeting',
    'Attribution Engine':    'standard:metrics',
    'Content Hub':           'standard:document'
};

export default class CatalystModuleList extends LightningElement {
    @track modules = [];
    @track isLoading = false;

    connectedCallback() {
        this.loadModules();
    }

    loadModules() {
        this.isLoading = true;
        getActiveModules()
            .then(data => {
                this.modules = data.map(m => ({
                    ...m,
                    moduleIcon: MODULE_ICONS[m.Module__c] || 'standard:product',
                    activationDateIso: m.Activation_Date__c
                        ? new Date(m.Activation_Date__c).toISOString()
                        : null
                }));
            })
            .catch(err => {
                console.error('SubscriptionPortalController.getActiveModules error:', err);
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    get hasModules() {
        return !this.isLoading && this.modules.length > 0;
    }

    get isEmpty() {
        return !this.isLoading && this.modules.length === 0;
    }
}
