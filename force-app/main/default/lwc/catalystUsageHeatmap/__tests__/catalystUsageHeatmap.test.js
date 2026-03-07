/**
 * Jest tests for catalyst-usage-heatmap
 * MKT-TC-EXP-008
 */
import { createElement } from 'lwc';
import CatalystUsageHeatmap from 'c/catalystUsageHeatmap';
import getSubscriptionData from '@salesforce/apex/SubscriptionPortalController.getSubscriptionData';
import getActiveModules from '@salesforce/apex/SubscriptionPortalController.getActiveModules';

jest.mock('@salesforce/apex/SubscriptionPortalController.getSubscriptionData', () => jest.fn(), { virtual: true });
jest.mock('@salesforce/apex/SubscriptionPortalController.getActiveModules', () => jest.fn(), { virtual: true });

const MOCK_ACCOUNT = { Id: '0011', Platform_Usage_Index__c: 72.4 };
const MOCK_MODULES = [{ Id: 'a001', Module__c: 'Campaign Intelligence', Status__c: 'Active' }];

describe('c-catalyst-usage-heatmap', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        jest.clearAllMocks();
    });

    it('renders usage index when data is returned', async () => {
        getSubscriptionData.mockResolvedValue(MOCK_ACCOUNT);
        getActiveModules.mockResolvedValue(MOCK_MODULES);
        const element = createElement('c-catalyst-usage-heatmap', { is: CatalystUsageHeatmap });
        document.body.appendChild(element);
        await Promise.resolve();
        await Promise.resolve();
        expect(element.shadowRoot.textContent).toContain('72');
    });

    it('shows no-data state when account is null', async () => {
        getSubscriptionData.mockResolvedValue(null);
        getActiveModules.mockResolvedValue([]);
        const element = createElement('c-catalyst-usage-heatmap', { is: CatalystUsageHeatmap });
        document.body.appendChild(element);
        await Promise.resolve();
        await Promise.resolve();
        expect(element.shadowRoot.textContent).toContain('unavailable');
    });

    it('renders progress bar for usage index', async () => {
        getSubscriptionData.mockResolvedValue(MOCK_ACCOUNT);
        getActiveModules.mockResolvedValue(MOCK_MODULES);
        const element = createElement('c-catalyst-usage-heatmap', { is: CatalystUsageHeatmap });
        document.body.appendChild(element);
        await Promise.resolve();
        await Promise.resolve();
        const progressBar = element.shadowRoot.querySelector('lightning-progress-bar');
        expect(progressBar).not.toBeNull();
    });
});
