/**
 * Jest tests for catalyst-knowledge-search
 * MKT-TC-EXP-010
 */
import { createElement } from 'lwc';
import CatalystKnowledgeSearch from 'c/catalystKnowledgeSearch';
import searchArticles from '@salesforce/apex/KnowledgePortalController.searchArticles';

jest.mock('@salesforce/apex/KnowledgePortalController.searchArticles', () => jest.fn(), { virtual: true });

const MOCK_ARTICLES = [
    { Id: 'ka001', Title: 'Getting Started', Summary: 'An intro guide.', UrlName: 'getting-started', LastPublishedDate: '2026-01-01T00:00:00.000Z' },
    { Id: 'ka002', Title: 'Advanced Configuration', Summary: 'Advanced setup tips.', UrlName: 'advanced-config', LastPublishedDate: '2026-01-05T00:00:00.000Z' }
];

describe('c-catalyst-knowledge-search', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        jest.clearAllMocks();
    });

    it('renders search input on load', () => {
        const element = createElement('c-catalyst-knowledge-search', { is: CatalystKnowledgeSearch });
        document.body.appendChild(element);
        expect(element.shadowRoot.querySelector('lightning-input[type="search"]')).not.toBeNull();
    });

    it('shows prompt text before any search', () => {
        const element = createElement('c-catalyst-knowledge-search', { is: CatalystKnowledgeSearch });
        document.body.appendChild(element);
        expect(element.shadowRoot.textContent).toContain('Enter at least 2 characters');
    });

    it('does not search when input has fewer than 2 characters', async () => {
        const element = createElement('c-catalyst-knowledge-search', { is: CatalystKnowledgeSearch });
        document.body.appendChild(element);
        const input = element.shadowRoot.querySelector('lightning-input[type="search"]');
        input.dispatchEvent(new CustomEvent('change', { detail: { value: 'a' } }));
        await Promise.resolve();
        expect(searchArticles).not.toHaveBeenCalled();
    });

    it('displays result count label when articles returned', async () => {
        jest.useFakeTimers();
        searchArticles.mockResolvedValue(MOCK_ARTICLES);
        const element = createElement('c-catalyst-knowledge-search', { is: CatalystKnowledgeSearch });
        document.body.appendChild(element);

        const input = element.shadowRoot.querySelector('lightning-input[type="search"]');
        input.dispatchEvent(new CustomEvent('change', { detail: { value: 'campaign' } }));
        jest.runAllTimers();
        await Promise.resolve();
        await Promise.resolve();
        jest.useRealTimers();

        expect(searchArticles).toHaveBeenCalledWith({ searchTerm: 'campaign' });
    });

    it('shows no-results message when search returns empty array', async () => {
        jest.useFakeTimers();
        searchArticles.mockResolvedValue([]);
        const element = createElement('c-catalyst-knowledge-search', { is: CatalystKnowledgeSearch });
        document.body.appendChild(element);

        const input = element.shadowRoot.querySelector('lightning-input[type="search"]');
        input.dispatchEvent(new CustomEvent('change', { detail: { value: 'xyzxyz' } }));
        jest.runAllTimers();
        await Promise.resolve();
        await Promise.resolve();
        jest.useRealTimers();

        expect(element.shadowRoot.textContent).toContain('No articles found');
    });
});
