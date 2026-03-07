/**
 * Jest tests for catalyst-case-detail
 * MKT-TC-EXP-004
 */
import { createElement } from 'lwc';
import CatalystCaseDetail from 'c/catalystCaseDetail';
import getCaseDetail from '@salesforce/apex/CasePortalController.getCaseDetail';

jest.mock('@salesforce/apex/CasePortalController.getCaseDetail', () => jest.fn(), { virtual: true });

const MOCK_CASE = {
    Id: '5001000000000001',
    CaseNumber: '00001001',
    Subject: 'Login issue',
    Status: 'In Progress',
    Priority: 'High',
    Description: 'Cannot login after password reset.',
    Affected_Module__c: 'Campaign Intelligence',
    Urgency__c: 'High',
    SLA_Tier_at_Creation__c: 'Enterprise',
    CreatedDate: '2026-01-10T09:00:00.000Z',
    Resolution_Summary__c: null
};

describe('c-catalyst-case-detail', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        jest.clearAllMocks();
    });

    it('renders case details when case is returned', async () => {
        getCaseDetail.mockResolvedValue(MOCK_CASE);
        const element = createElement('c-catalyst-case-detail', { is: CatalystCaseDetail });
        element.caseId = MOCK_CASE.Id;
        document.body.appendChild(element);
        await Promise.resolve();
        await Promise.resolve();
        expect(element.shadowRoot.textContent).toContain('Login issue');
    });

    it('shows error when case not found (null returned)', async () => {
        getCaseDetail.mockResolvedValue(null);
        const element = createElement('c-catalyst-case-detail', { is: CatalystCaseDetail });
        element.caseId = '5001000000000099';
        document.body.appendChild(element);
        await Promise.resolve();
        await Promise.resolve();
        const errorEl = element.shadowRoot.querySelector('[role="alert"]');
        expect(errorEl).not.toBeNull();
    });

    it('shows error when apex call fails', async () => {
        getCaseDetail.mockRejectedValue(new Error('Access denied'));
        const element = createElement('c-catalyst-case-detail', { is: CatalystCaseDetail });
        element.caseId = MOCK_CASE.Id;
        document.body.appendChild(element);
        await Promise.resolve();
        await Promise.resolve();
        const errorEl = element.shadowRoot.querySelector('[role="alert"]');
        expect(errorEl).not.toBeNull();
    });

    it('does not load when no caseId provided', () => {
        getCaseDetail.mockResolvedValue(MOCK_CASE);
        const element = createElement('c-catalyst-case-detail', { is: CatalystCaseDetail });
        document.body.appendChild(element);
        expect(getCaseDetail).not.toHaveBeenCalled();
    });
});
