import { LightningElement, track } from 'lwc';
import getOnboardingData from '@salesforce/apex/OnboardingPortalController.getOnboardingData';

export default class CatalystOnboardingChecklist extends LightningElement {
    @track onboarding = null;
    @track steps = [];
    @track isLoading = false;

    connectedCallback() {
        this.loadOnboarding();
    }

    loadOnboarding() {
        this.isLoading = true;
        getOnboardingData()
            .then(data => {
                if (data) {
                    this.onboarding = data;
                    this.steps = data.steps.map(s => ({
                        ...s,
                        labelClass: s.isComplete
                            ? 'slds-text-body_regular slds-text-color_weak catalyst-step_complete'
                            : 'slds-text-body_regular',
                        resourceLabel: `Guide for step: ${s.label}`
                    }));
                }
            })
            .catch(err => {
                console.error('OnboardingPortalController.getOnboardingData error:', err);
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    handleStepToggle(event) {
        const stepNumber = parseInt(event.target.dataset.step, 10);
        const isNowChecked = event.detail.checked;
        this.steps = this.steps.map(s => {
            if (s.stepNumber === stepNumber) {
                return {
                    ...s,
                    isComplete: isNowChecked,
                    labelClass: isNowChecked
                        ? 'slds-text-body_regular slds-text-color_weak catalyst-step_complete'
                        : 'slds-text-body_regular'
                };
            }
            return s;
        });
    }

    get completedCount() {
        return this.steps.filter(s => s.isComplete).length;
    }

    get totalSteps() {
        return this.steps.length;
    }

    get progressPct() {
        if (this.totalSteps === 0) return 0;
        return Math.round((this.completedCount / this.totalSteps) * 100);
    }

    get isComplete() {
        return this.totalSteps > 0 && this.completedCount === this.totalSteps;
    }

    get noData() {
        return !this.isLoading && !this.onboarding;
    }
}
