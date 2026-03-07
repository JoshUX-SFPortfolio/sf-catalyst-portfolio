import { LightningElement, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import submitCase from '@salesforce/apex/CasePortalController.submitCase';

const MODULE_OPTIONS = [
    { label: 'Campaign Intelligence', value: 'Campaign Intelligence' },
    { label: 'Audience Studio', value: 'Audience Studio' },
    { label: 'Attribution Engine', value: 'Attribution Engine' },
    { label: 'Content Hub', value: 'Content Hub' }
];

const URGENCY_OPTIONS = [
    { label: 'Low', value: 'Low' },
    { label: 'Medium', value: 'Medium' },
    { label: 'High', value: 'High' },
    { label: 'Critical', value: 'Critical' }
];

export default class CatalystCaseForm extends NavigationMixin(LightningElement) {
    @track subject = '';
    @track affectedModule = '';
    @track urgency = 'Medium';
    @track description = '';
    @track isSubmitting = false;
    @track isSubmitted = false;
    @track submitError = null;
    @track submittedCaseId = null;

    moduleOptions = MODULE_OPTIONS;
    urgencyOptions = URGENCY_OPTIONS;

    handleSubjectChange(event)      { this.subject = event.detail.value; }
    handleModuleChange(event)       { this.affectedModule = event.detail.value; }
    handleUrgencyChange(event)      { this.urgency = event.detail.value; }
    handleDescriptionChange(event)  { this.description = event.detail.value; }

    handleDeflected() {
        // User found an article via deflection — no need to submit
        this.dispatchEvent(new ShowToastEvent({
            title: 'Great!',
            message: 'We hope that article resolved your issue.',
            variant: 'success'
        }));
    }

    handleSubmit() {
        if (!this.validateForm()) return;

        this.isSubmitting = true;
        this.submitError = null;

        submitCase({
            subject: this.subject,
            description: this.description,
            affectedModule: this.affectedModule,
            urgency: this.urgency
        })
            .then(caseId => {
                this.submittedCaseId = caseId;
                this.isSubmitted = true;
            })
            .catch(err => {
                this.submitError = 'Unable to submit case. Please try again.';
                console.error('CasePortalController.submitCase error:', err);
            })
            .finally(() => {
                this.isSubmitting = false;
            });
    }

    handleViewCases() {
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: { url: '/cases' }
        });
    }

    validateForm() {
        const inputs = this.template.querySelectorAll('lightning-input, lightning-textarea, lightning-combobox');
        let valid = true;
        inputs.forEach(input => {
            if (!input.reportValidity()) valid = false;
        });
        return valid;
    }
}
