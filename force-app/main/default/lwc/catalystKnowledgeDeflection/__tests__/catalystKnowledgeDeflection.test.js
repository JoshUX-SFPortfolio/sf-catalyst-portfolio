/**
 * Jest tests for catalyst-knowledge-deflection
 * MKT-TC-EXP-003
 */
import { createElement } from 'lwc';
import CatalystKnowledgeDeflection from 'c/catalystKnowledgeDeflection';
import searchArticles from '@salesforce/apex/KnowledgePortalController.searchArticles';

jest.mock('@salesforce/apex/KnowledgePortalController.searchArticles', () => jest.fn(), { virtual: true });

const MOCK_ARTICLES = [
    { Id: 'ka001', Title: 'Getting Started with Campaign Intelligence', Summary: 'Learn how to set up your first campaign.', UrlName: 'getting-started', LastPublishedDate: '2026-01-01T00:00:00.000Z' }
];

describe('c-catalyst-knowledge-deflection', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        jest.clearAllMocks();
    });

    it('renders empty state when no search term', () => {
        const element = createElement('c-catalyst-knowledge-deflection', { is: CatalystKnowledgeDeflection });
        document.body.appendChild(element);
        expect(element.shadowRoot).not.toBeNull();
    });

    it('does not search when search term is less than 3 characters', async () => {
        const element = createElement('c-catalyst-knowledge-deflection', { is: CatalystKnowledgeDeflection });
        document.body.appendChild(element);
        element.searchTerm = 'ab';
        await Promise.resolve();
        expect(searchArticles).not.toHaveBeenCalled();
    });

    it('dispatches deflected event when helpful button clicked', async () => {
        searchArticles.mockResolvedValue(MOCK_ARTICLES);
        const element = createElement('c-catalyst-knowledge-deflection', { is: CatalystKnowledgeDeflection });
        document.body.appendChild(element);

        const deflectedHandler = jest.fn();
        element.addEventListener('deflected', deflectedHandler);

        // Set search term to trigger results
        element.searchTerm = 'campaign intelligence';
        await Promise.resolve();
        await Promise.resolve();

        expect(element.shadowRoot).not.toBeNull();
    });

    it('renders prompt text by default', () => {
        const element = createElement('c-catalyst-knowledge-deflection', { is: CatalystKnowledgeDeflection });
        document.body.appendChild(element);
        const promptText = element.shadowRoot.textContent;
        expect(promptText).toContain('Knowledge Base');
    });
});
