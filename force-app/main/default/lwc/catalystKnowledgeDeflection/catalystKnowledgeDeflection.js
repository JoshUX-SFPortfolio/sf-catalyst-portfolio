import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import searchArticles from '@salesforce/apex/KnowledgePortalController.searchArticles';

const DEBOUNCE_DELAY = 500;

export default class CatalystKnowledgeDeflection extends NavigationMixin(LightningElement) {
    @api
    get searchTerm() {
        return this._searchTerm;
    }
    set searchTerm(value) {
        this._searchTerm = value;
        this.debounceSearch(value);
    }

    @track articles = [];
    @track isSearching = false;

    _searchTerm = '';
    _debounceTimer = null;

    debounceSearch(term) {
        clearTimeout(this._debounceTimer);
        if (!term || term.length < 3) {
            this.articles = [];
            return;
        }
        this._debounceTimer = setTimeout(() => {
            this.performSearch(term);
        }, DEBOUNCE_DELAY);
    }

    performSearch(term) {
        this.isSearching = true;
        searchArticles({ searchTerm: term })
            .then(data => {
                this.articles = data.map(a => ({
                    ...a,
                    articleUrl: `/knowledge/${a.UrlName}`
                }));
            })
            .catch(err => {
                console.error('KnowledgePortalController.searchArticles error:', err);
                this.articles = [];
            })
            .finally(() => {
                this.isSearching = false;
            });
    }

    get hasResults() {
        return !this.isSearching && this.articles.length > 0;
    }

    get isEmpty() {
        return !this.isSearching && this.articles.length === 0;
    }

    handleArticleClick() {
        // Navigation handled by the anchor href
    }

    handleDeflected() {
        this.dispatchEvent(new CustomEvent('deflected'));
    }

    handleNotDeflected() {
        // User still wants to submit — no-op, form remains visible
    }

    handleBrowseKnowledge() {
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: { url: '/knowledge' }
        });
    }
}
