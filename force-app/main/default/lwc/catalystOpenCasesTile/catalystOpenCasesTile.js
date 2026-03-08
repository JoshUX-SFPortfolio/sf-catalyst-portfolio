import { LightningElement, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getOpenCaseCount from '@salesforce/apex/CasePortalController.getOpenCaseCount';

export default class CatalystOpenCasesTile extends NavigationMixin(LightningElement) {
    @track caseCount = 0;
    @track isLoading = false;

    connectedCallback() {
        this.loadCount();
    }

    loadCount() {
        this.isLoading = true;
        getOpenCaseCount()
            .then(count => {
                this.caseCount = count;
            })
            .catch(err => {
                console.error('CasePortalController.getOpenCaseCount error:', err);
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    get isPlural() {
        return this.caseCount !== 1 ? 's' : '';
    }

    get buttonVariant() {
        return this.caseCount > 0 ? 'brand' : 'neutral';
    }

    handleViewCases() {
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: { url: '/cases' }
        });
    }
}
