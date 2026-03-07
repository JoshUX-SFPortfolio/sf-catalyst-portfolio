import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getArticleByUrlName from '@salesforce/apex/KnowledgePortalController.getArticleByUrlName';

export default class CatalystKnowledgeArticle extends LightningElement {
    @api urlName;
    @track article = null;
    @track isLoading = false;
    @track error = null;
    @track feedbackSent = false;

    connectedCallback() {
        if (this.urlName) {
            this.loadArticle();
        }
    }

    loadArticle() {
        this.isLoading = true;
        getArticleByUrlName({ urlName: this.urlName })
            .then(data => {
                this.article = data;
                if (!data) {
                    this.error = 'Article not found.';
                }
            })
            .catch(() => {
                this.error = 'Unable to load this article. Please try again.';
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    get lastPublishedIso() {
        return this.article?.LastPublishedDate
            ? new Date(this.article.LastPublishedDate).toISOString()
            : null;
    }

    handleHelpful() {
        this.feedbackSent = true;
    }

    handleNotHelpful() {
        this.feedbackSent = true;
        this.dispatchEvent(new ShowToastEvent({
            title: 'Need more help?',
            message: 'You can open a support case for further assistance.',
            variant: 'info'
        }));
    }
}
