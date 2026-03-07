/**
 * Jest tests for catalyst-onboarding-checklist
 * MKT-TC-EXP-012
 */
import { createElement } from 'lwc';
import CatalystOnboardingChecklist from 'c/catalystOnboardingChecklist';
import getOnboardingData from '@salesforce/apex/OnboardingPortalController.getOnboardingData';

jest.mock('@salesforce/apex/OnboardingPortalController.getOnboardingData', () => jest.fn(), { virtual: true });

const MOCK_STEPS = [
    { stepNumber: 1, label: 'Activate your account', description: 'Complete your profile.', isComplete: false, resourceUrl: '/onboarding/step1' },
    { stepNumber: 2, label: 'Connect your data sources', description: 'Link your platforms.', isComplete: false, resourceUrl: '/onboarding/step2' }
];

const MOCK_ONBOARDING = {
    projectId: 'a001',
    projectName: 'Onboarding Project',
    status: 'Active',
    startDate: '2026-01-01',
    endDate: '2026-04-01',
    steps: MOCK_STEPS
};

describe('c-catalyst-onboarding-checklist', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        jest.clearAllMocks();
    });

    it('renders steps when onboarding data returned', async () => {
        getOnboardingData.mockResolvedValue(MOCK_ONBOARDING);
        const element = createElement('c-catalyst-onboarding-checklist', { is: CatalystOnboardingChecklist });
        document.body.appendChild(element);
        await Promise.resolve();
        await Promise.resolve();
        expect(element.shadowRoot.textContent).toContain('Activate your account');
    });

    it('shows no-data state when null returned', async () => {
        getOnboardingData.mockResolvedValue(null);
        const element = createElement('c-catalyst-onboarding-checklist', { is: CatalystOnboardingChecklist });
        document.body.appendChild(element);
        await Promise.resolve();
        await Promise.resolve();
        expect(element.shadowRoot.textContent).toContain('No active onboarding project');
    });

    it('shows progress bar', async () => {
        getOnboardingData.mockResolvedValue(MOCK_ONBOARDING);
        const element = createElement('c-catalyst-onboarding-checklist', { is: CatalystOnboardingChecklist });
        document.body.appendChild(element);
        await Promise.resolve();
        await Promise.resolve();
        const progressBar = element.shadowRoot.querySelector('lightning-progress-bar');
        expect(progressBar).not.toBeNull();
    });

    it('shows 0 of N complete initially', async () => {
        getOnboardingData.mockResolvedValue(MOCK_ONBOARDING);
        const element = createElement('c-catalyst-onboarding-checklist', { is: CatalystOnboardingChecklist });
        document.body.appendChild(element);
        await Promise.resolve();
        await Promise.resolve();
        expect(element.shadowRoot.textContent).toContain('0 of 2');
    });

    it('does not show completion banner when steps are incomplete', async () => {
        getOnboardingData.mockResolvedValue(MOCK_ONBOARDING);
        const element = createElement('c-catalyst-onboarding-checklist', { is: CatalystOnboardingChecklist });
        document.body.appendChild(element);
        await Promise.resolve();
        await Promise.resolve();
        expect(element.shadowRoot.textContent).not.toContain("You're all set");
    });
});
