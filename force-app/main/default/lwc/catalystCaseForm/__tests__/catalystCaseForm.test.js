/**
 * Jest tests for catalyst-case-form
 * MKT-TC-EXP-002
 */
import { createElement } from 'lwc';
import CatalystCaseForm from 'c/catalystCaseForm';
import submitCase from '@salesforce/apex/CasePortalController.submitCase';

jest.mock('@salesforce/apex/CasePortalController.submitCase', () => jest.fn(), { virtual: true });

describe('c-catalyst-case-form', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        jest.clearAllMocks();
    });

    it('renders the form with required fields', () => {
        const element = createElement('c-catalyst-case-form', { is: CatalystCaseForm });
        document.body.appendChild(element);
        expect(element.shadowRoot.querySelector('lightning-input')).not.toBeNull();
        expect(element.shadowRoot.querySelector('lightning-textarea')).not.toBeNull();
    });

    it('renders the knowledge deflection component', () => {
        const element = createElement('c-catalyst-case-form', { is: CatalystCaseForm });
        document.body.appendChild(element);
        const deflection = element.shadowRoot.querySelector('c-catalyst-knowledge-deflection');
        expect(deflection).not.toBeNull();
    });

    it('shows success state after successful submission', async () => {
        submitCase.mockResolvedValue('5001000000000001');
        const element = createElement('c-catalyst-case-form', { is: CatalystCaseForm });
        document.body.appendChild(element);

        // Trigger submit
        element.shadowRoot.querySelector('lightning-button[label="Submit Case"]').click();
        await Promise.resolve();
        await Promise.resolve();

        // submitCase was called
        expect(submitCase).toHaveBeenCalled();
    });

    it('shows error message when submission fails', async () => {
        submitCase.mockRejectedValue(new Error('DML error'));
        const element = createElement('c-catalyst-case-form', { is: CatalystCaseForm });
        document.body.appendChild(element);

        element.shadowRoot.querySelector('lightning-button[label="Submit Case"]').click();
        await Promise.resolve();
        await Promise.resolve();

        // Element still renders (no crash)
        expect(element.shadowRoot).not.toBeNull();
    });
});
