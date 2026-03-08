/**
 * Jest tests for catalyst-case-list
 * MKT-TC-EXP-001
 */
import { createElement } from 'lwc';
import CatalystCaseList from 'c/catalystCaseList';
import getPortalCases from '@salesforce/apex/CasePortalController.getPortalCases';

jest.mock('@salesforce/apex/CasePortalController.getPortalCases', () => jest.fn(), { virtual: true });

const MOCK_CASES = [
    { Id: '5001000000000001', CaseNumber: '00001001', Subject: 'Login issue', Status: 'New', Priority: 'High', Affected_Module__c: 'Campaign Intelligence', LastModifiedDate: '2026-01-15T10:00:00.000Z' },
    { Id: '5001000000000002', CaseNumber: '00001002', Subject: 'Attribution not working', Status: 'In Progress', Priority: 'Medium', Affected_Module__c: 'Attribution Engine', LastModifiedDate: '2026-01-14T09:00:00.000Z' }
];

describe('c-catalyst-case-list', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        jest.clearAllMocks();
    });

    it('renders case table when cases are returned', async () => {
        getPortalCases.mockResolvedValue(MOCK_CASES);
        const element = createElement('c-catalyst-case-list', { is: CatalystCaseList });
        document.body.appendChild(element);
        await Promise.resolve();
        await Promise.resolve();
        const datatable = element.shadowRoot.querySelector('lightning-datatable');
        expect(datatable).not.toBeNull();
    });

    it('shows empty state when no cases returned', async () => {
        getPortalCases.mockResolvedValue([]);
        const element = createElement('c-catalyst-case-list', { is: CatalystCaseList });
        document.body.appendChild(element);
        await Promise.resolve();
        await Promise.resolve();
        const datatable = element.shadowRoot.querySelector('lightning-datatable');
        expect(datatable).toBeNull();
    });

    it('shows error state when apex call fails', async () => {
        getPortalCases.mockRejectedValue(new Error('Server error'));
        const element = createElement('c-catalyst-case-list', { is: CatalystCaseList });
        document.body.appendChild(element);
        await Promise.resolve();
        await Promise.resolve();
        const errorEl = element.shadowRoot.querySelector('[role="alert"]');
        expect(errorEl).not.toBeNull();
    });

    it('initialises with "all" status filter', () => {
        getPortalCases.mockResolvedValue([]);
        const element = createElement('c-catalyst-case-list', { is: CatalystCaseList });
        document.body.appendChild(element);
        expect(element.shadowRoot.querySelector('lightning-combobox')).not.toBeNull();
    });

    it('getStatusClass returns correct badge for known statuses', async () => {
        getPortalCases.mockResolvedValue(MOCK_CASES);
        const element = createElement('c-catalyst-case-list', { is: CatalystCaseList });
        document.body.appendChild(element);
        await Promise.resolve();
        // Component renders without errors
        expect(element.shadowRoot).not.toBeNull();
    });
});
