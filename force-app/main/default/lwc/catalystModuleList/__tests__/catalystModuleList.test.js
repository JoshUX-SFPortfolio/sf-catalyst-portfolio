/**
 * Jest tests for catalyst-module-list
 * MKT-TC-EXP-006
 */
import { createElement } from 'lwc';
import CatalystModuleList from 'c/catalystModuleList';
import getActiveModules from '@salesforce/apex/SubscriptionPortalController.getActiveModules';

jest.mock('@salesforce/apex/SubscriptionPortalController.getActiveModules', () => jest.fn(), { virtual: true });

const MOCK_MODULES = [
    { Id: 'a001', Name: 'ASSET-0001', Module__c: 'Campaign Intelligence', Asset_Type__c: 'Module Licence', Status__c: 'Active', Activation_Date__c: '2025-01-01' },
    { Id: 'a002', Name: 'ASSET-0002', Module__c: 'Audience Studio', Asset_Type__c: 'Module Licence', Status__c: 'Active', Activation_Date__c: '2025-01-01' }
];

describe('c-catalyst-module-list', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        jest.clearAllMocks();
    });

    it('renders module list when modules returned', async () => {
        getActiveModules.mockResolvedValue(MOCK_MODULES);
        const element = createElement('c-catalyst-module-list', { is: CatalystModuleList });
        document.body.appendChild(element);
        await Promise.resolve();
        await Promise.resolve();
        expect(element.shadowRoot.textContent).toContain('Campaign Intelligence');
        expect(element.shadowRoot.textContent).toContain('Audience Studio');
    });

    it('shows empty state when no modules returned', async () => {
        getActiveModules.mockResolvedValue([]);
        const element = createElement('c-catalyst-module-list', { is: CatalystModuleList });
        document.body.appendChild(element);
        await Promise.resolve();
        await Promise.resolve();
        expect(element.shadowRoot.textContent).toContain('No active module licences');
    });

    it('assigns correct icon for Campaign Intelligence module', async () => {
        getActiveModules.mockResolvedValue([MOCK_MODULES[0]]);
        const element = createElement('c-catalyst-module-list', { is: CatalystModuleList });
        document.body.appendChild(element);
        await Promise.resolve();
        await Promise.resolve();
        const icon = element.shadowRoot.querySelector('lightning-icon[icon-name="standard:campaign"]');
        expect(icon).not.toBeNull();
    });
});
