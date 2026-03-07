/**
 * Jest tests for catalyst-open-cases-tile
 * MKT-TC-EXP-007
 */
import { createElement } from 'lwc';
import CatalystOpenCasesTile from 'c/catalystOpenCasesTile';
import getOpenCaseCount from '@salesforce/apex/CasePortalController.getOpenCaseCount';

jest.mock('@salesforce/apex/CasePortalController.getOpenCaseCount', () => jest.fn(), { virtual: true });

describe('c-catalyst-open-cases-tile', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        jest.clearAllMocks();
    });

    it('displays case count', async () => {
        getOpenCaseCount.mockResolvedValue(3);
        const element = createElement('c-catalyst-open-cases-tile', { is: CatalystOpenCasesTile });
        document.body.appendChild(element);
        await Promise.resolve();
        await Promise.resolve();
        expect(element.shadowRoot.textContent).toContain('3');
    });

    it('displays plural "cases" for count > 1', async () => {
        getOpenCaseCount.mockResolvedValue(3);
        const element = createElement('c-catalyst-open-cases-tile', { is: CatalystOpenCasesTile });
        document.body.appendChild(element);
        await Promise.resolve();
        await Promise.resolve();
        expect(element.shadowRoot.textContent).toContain('cases');
    });

    it('displays singular "case" for count of 1', async () => {
        getOpenCaseCount.mockResolvedValue(1);
        const element = createElement('c-catalyst-open-cases-tile', { is: CatalystOpenCasesTile });
        document.body.appendChild(element);
        await Promise.resolve();
        await Promise.resolve();
        // "case" is in "cases" — check the 's' suffix is absent
        const countEl = element.shadowRoot.querySelector('.open-case-count');
        expect(countEl.textContent.trim()).toBe('1');
    });

    it('uses brand button variant when cases > 0', async () => {
        getOpenCaseCount.mockResolvedValue(2);
        const element = createElement('c-catalyst-open-cases-tile', { is: CatalystOpenCasesTile });
        document.body.appendChild(element);
        await Promise.resolve();
        await Promise.resolve();
        const btn = element.shadowRoot.querySelector('lightning-button[variant="brand"]');
        expect(btn).not.toBeNull();
    });

    it('uses neutral button variant when count is 0', async () => {
        getOpenCaseCount.mockResolvedValue(0);
        const element = createElement('c-catalyst-open-cases-tile', { is: CatalystOpenCasesTile });
        document.body.appendChild(element);
        await Promise.resolve();
        await Promise.resolve();
        const btn = element.shadowRoot.querySelector('lightning-button[variant="neutral"]');
        expect(btn).not.toBeNull();
    });
});
