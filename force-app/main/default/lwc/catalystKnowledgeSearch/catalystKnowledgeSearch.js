import { LightningElement, track } from 'lwc';
import searchArticles from '@salesforce/apex/KnowledgePortalController.searchArticles';

const DEBOUNCE_DELAY = 400;

export default class CatalystKnowledgeSearch extends LightningElement {
    @track searchTerm = '';
    @track articles = [];
    @track isSearching = false;
    @track hasSearched = false;

    _debounceTimer = null;

    handleSearchChange(event) {
        this.searchTerm = event.detail.value;
        clearTimeout(this._debounceTimer);

        if (this.searchTerm.length < 2) {
            this.articles = [];
            this.hasSearched = false;
            return;
        }

        this._debounceTimer = setTimeout(() => {
            this.performSearch();
        }, DEBOUNCE_DELAY);
    }

    performSearch() {
        this.isSearching = true;
        searchArticles({ searchTerm: this.searchTerm })
            .then(data => {
                this.articles = data.map(a => ({
                    ...a,
                    articleUrl: `/knowledge/${a.UrlName}`,
                    lastPublishedIso: a.LastPublishedDate
                        ? new Date(a.LastPublishedDate).toISOString()
                        : null
                }));
                this.hasSearched = true;
            })
            .catch(err => {
                console.error('KnowledgePortalController.searchArticles error:', err);
            })
            .finally(() => {
                this.isSearching = false;
            });
    }

    get hasResults() {
        return !this.isSearching && this.articles.length > 0;
    }

    get showNoResults() {
        return !this.isSearching && this.hasSearched && this.articles.length === 0;
    }

    get showPrompt() {
        return !this.isSearching && !this.hasSearched;
    }

    get resultCount() {
        return this.articles.length;
    }

    get isPlural() {
        return this.resultCount !== 1 ? 's' : '';
    }
}
