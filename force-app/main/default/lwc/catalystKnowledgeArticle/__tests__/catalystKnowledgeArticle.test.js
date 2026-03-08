/**
 * Jest tests for catalyst-knowledge-article
 * MKT-TC-EXP-011
 */
import { createElement } from 'lwc';
import CatalystKnowledgeArticle from 'c/catalystKnowledgeArticle';
import getArticleByUrlName from '@salesforce/apex/KnowledgePortalController.getArticleByUrlName';

jest.mock('@salesforce/apex/KnowledgePortalController.getArticleByUrlName', () => jest.fn(), { virtual: true });

const MOCK_ARTICLE = {
    Id: 'ka001',
    Title: 'Getting Started with Campaign Intelligence',
    Summary: 'Everything you need to set up your first campaign.',
    ArticleBody: '<p>Follow these steps to get started...</p>',
    ArticleNumber: '000001001',
    UrlName: 'getting-started',
    LastPublishedDate: '2026-01-01T00:00:00.000Z'
};

describe('c-catalyst-knowledge-article', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        jest.clearAllMocks();
    });

    it('renders article title when article returned', async () => {
        getArticleByUrlName.mockResolvedValue(MOCK_ARTICLE);
        const element = createElement('c-catalyst-knowledge-article', { is: CatalystKnowledgeArticle });
        element.urlName = 'getting-started';
        document.body.appendChild(element);
        await Promise.resolve();
        await Promise.resolve();
        expect(element.shadowRoot.textContent).toContain('Getting Started with Campaign Intelligence');
    });

    it('shows breadcrumb with Knowledge Base link', async () => {
        getArticleByUrlName.mockResolvedValue(MOCK_ARTICLE);
        const element = createElement('c-catalyst-knowledge-article', { is: CatalystKnowledgeArticle });
        element.urlName = 'getting-started';
        document.body.appendChild(element);
        await Promise.resolve();
        await Promise.resolve();
        const breadcrumb = element.shadowRoot.querySelector('a[href="/knowledge"]');
        expect(breadcrumb).not.toBeNull();
    });

    it('shows error when article is null', async () => {
        getArticleByUrlName.mockResolvedValue(null);
        const element = createElement('c-catalyst-knowledge-article', { is: CatalystKnowledgeArticle });
        element.urlName = 'not-found';
        document.body.appendChild(element);
        await Promise.resolve();
        await Promise.resolve();
        const errorEl = element.shadowRoot.querySelector('[role="alert"]');
        expect(errorEl).not.toBeNull();
    });

    it('does not load when no urlName provided', () => {
        const element = createElement('c-catalyst-knowledge-article', { is: CatalystKnowledgeArticle });
        document.body.appendChild(element);
        expect(getArticleByUrlName).not.toHaveBeenCalled();
    });

    it('renders feedback buttons', async () => {
        getArticleByUrlName.mockResolvedValue(MOCK_ARTICLE);
        const element = createElement('c-catalyst-knowledge-article', { is: CatalystKnowledgeArticle });
        element.urlName = 'getting-started';
        document.body.appendChild(element);
        await Promise.resolve();
        await Promise.resolve();
        const yesBtn = element.shadowRoot.querySelector('lightning-button[label="Yes"]');
        const noBtn = element.shadowRoot.querySelector('lightning-button[label="No"]');
        expect(yesBtn).not.toBeNull();
        expect(noBtn).not.toBeNull();
    });
});
