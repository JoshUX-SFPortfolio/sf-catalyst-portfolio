/**
 * Jest tests for catalyst-subscription-tile
 * MKT-TC-EXP-005
 */
import { createElement } from 'lwc';
import CatalystSubscriptionTile from 'c/catalystSubscriptionTile';
import getSubscriptionData from '@salesforce/apex/SubscriptionPortalController.getSubscriptionData';

jest.mock('@salesforce/apex/SubscriptionPortalController.getSubscriptionData', () => jest.fn(), { virtual: true });

const MOCK_ACCOUNT_ENTERPRISE = {
    Id: '0011000000000001',
    Name: 'Acme Corp',
    Subscription_Tier__c: 'Enterprise',
    Annual_Contract_Value__c: 120000,
    Contract_Renewal_Date__c: '2027-01-01',
    Health_Score__c: 82,
    Platform_Usage_Index__c: 75
};

const MOCK_ACCOUNT_STARTER = {
    ...MOCK_ACCOUNT_ENTERPRISE,
    Subscription_Tier__c: 'Starter',
    Health_Score__c: 35,
    Contract_Renewal_Date__c: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString().split('T')[0]
};

describe('c-catalyst-subscription-tile', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        jest.clearAllMocks();
    });

    it('renders subscription data when returned', async () => {
        getSubscriptionData.mockResolvedValue(MOCK_ACCOUNT_ENTERPRISE);
        const element = createElement('c-catalyst-subscription-tile', { is: CatalystSubscriptionTile });
        document.body.appendChild(element);
        await Promise.resolve();
        await Promise.resolve();
        expect(element.shadowRoot.textContent).toContain('Enterprise');
    });

    it('shows no-data state when account is null', async () => {
        getSubscriptionData.mockResolvedValue(null);
        const element = createElement('c-catalyst-subscription-tile', { is: CatalystSubscriptionTile });
        document.body.appendChild(element);
        await Promise.resolve();
        await Promise.resolve();
        expect(element.shadowRoot.textContent).toContain('unavailable');
    });

    it('applies enterprise tier badge class for Enterprise tier', async () => {
        getSubscriptionData.mockResolvedValue(MOCK_ACCOUNT_ENTERPRISE);
        const element = createElement('c-catalyst-subscription-tile', { is: CatalystSubscriptionTile });
        document.body.appendChild(element);
        await Promise.resolve();
        await Promise.resolve();
        const badge = element.shadowRoot.querySelector('.tier-badge_enterprise');
        expect(badge).not.toBeNull();
    });

    it('shows renewal warning icon when renewal is within 90 days', async () => {
        getSubscriptionData.mockResolvedValue(MOCK_ACCOUNT_STARTER);
        const element = createElement('c-catalyst-subscription-tile', { is: CatalystSubscriptionTile });
        document.body.appendChild(element);
        await Promise.resolve();
        await Promise.resolve();
        const icon = element.shadowRoot.querySelector('lightning-icon[alternative-text="Renewal within 90 days"]');
        expect(icon).not.toBeNull();
    });

    it('applies error class for health score below 40', async () => {
        getSubscriptionData.mockResolvedValue(MOCK_ACCOUNT_STARTER);
        const element = createElement('c-catalyst-subscription-tile', { is: CatalystSubscriptionTile });
        document.body.appendChild(element);
        await Promise.resolve();
        await Promise.resolve();
        const errorScore = element.shadowRoot.querySelector('.slds-text-color_error');
        expect(errorScore).not.toBeNull();
    });
});
