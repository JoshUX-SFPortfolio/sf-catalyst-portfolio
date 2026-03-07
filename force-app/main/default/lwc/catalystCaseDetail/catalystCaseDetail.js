import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getCaseDetail from '@salesforce/apex/CasePortalController.getCaseDetail';

export default class CatalystCaseDetail extends NavigationMixin(LightningElement) {
    @api caseId;
    @track caseRecord = null;
    @track isLoading = false;
    @track error = null;

    connectedCallback() {
        if (this.caseId) {
            this.loadCase();
        }
    }

    loadCase() {
        this.isLoading = true;
        this.error = null;
        getCaseDetail({ caseId: this.caseId })
            .then(data => {
                this.caseRecord = data;
                if (!data) {
                    this.error = 'Case not found or you do not have access to this case.';
                }
            })
            .catch(() => {
                this.error = 'Unable to load case details. Please try again.';
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    handleBack() {
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: { url: '/cases' }
        });
    }

    handleNewCase() {
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: { url: '/cases/new' }
        });
    }

    handleContactSupport() {
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: { url: '/cases/new' }
        });
    }
}
