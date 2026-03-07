import { LightningElement, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getPortalCases from '@salesforce/apex/CasePortalController.getPortalCases';

const PAGE_SIZE = 10;

const COLUMNS = [
    { label: 'Case Number', fieldName: 'caseUrl', type: 'url',
      typeAttributes: { label: { fieldName: 'CaseNumber' }, target: '_self' },
      sortable: true },
    { label: 'Subject', fieldName: 'Subject', sortable: true },
    { label: 'Status', fieldName: 'Status', sortable: true,
      cellAttributes: { class: { fieldName: 'statusClass' } } },
    { label: 'Priority', fieldName: 'Priority', sortable: true },
    { label: 'Module', fieldName: 'Affected_Module__c' },
    { label: 'Last Updated', fieldName: 'LastModifiedDate', type: 'date',
      typeAttributes: { year: 'numeric', month: 'short', day: '2-digit' },
      sortable: true },
    { type: 'action', typeAttributes: { rowActions: [{ label: 'View', name: 'view' }] } }
];

const STATUS_OPTIONS = [
    { label: 'All Cases', value: 'all' },
    { label: 'New', value: 'New' },
    { label: 'In Progress', value: 'In Progress' },
    { label: 'Awaiting Customer', value: 'Awaiting Customer' },
    { label: 'On Hold', value: 'On Hold' },
    { label: 'Resolved', value: 'Resolved' },
    { label: 'Closed', value: 'Closed' }
];

export default class CatalystCaseList extends NavigationMixin(LightningElement) {
    @track selectedStatus = 'all';
    @track currentPage = 1;
    @track sortedBy = 'LastModifiedDate';
    @track sortDirection = 'desc';
    @track allCases = [];
    @track error = null;
    @track isLoading = false;

    columns = COLUMNS;
    statusOptions = STATUS_OPTIONS;

    connectedCallback() {
        this.loadCases();
    }

    loadCases() {
        this.isLoading = true;
        this.error = null;
        getPortalCases({ status: this.selectedStatus })
            .then(data => {
                this.allCases = this.enrichCases(data);
                this.currentPage = 1;
            })
            .catch(err => {
                this.error = 'Unable to load cases. Please try again.';
                console.error('CasePortalController.getPortalCases error:', err);
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    enrichCases(cases) {
        return cases.map(c => ({
            ...c,
            caseUrl: `/cases/${c.Id}`,
            statusClass: this.getStatusClass(c.Status)
        }));
    }

    getStatusClass(status) {
        const map = {
            'New': 'slds-badge slds-badge_lightest',
            'In Progress': 'slds-badge slds-theme_warning',
            'Resolved': 'slds-badge slds-theme_success',
            'Closed': 'slds-badge'
        };
        return map[status] || 'slds-badge slds-badge_lightest';
    }

    // ── Computed properties ──────────────────────────────────────────────────

    get totalCases() {
        return this.allCases.length;
    }

    get pagedCases() {
        const start = (this.currentPage - 1) * PAGE_SIZE;
        return this.sortedCases.slice(start, start + PAGE_SIZE);
    }

    get sortedCases() {
        if (!this.sortedBy) return this.allCases;
        const dir = this.sortDirection === 'asc' ? 1 : -1;
        const field = this.sortedBy;
        return [...this.allCases].sort((a, b) => {
            const av = a[field] ?? '';
            const bv = b[field] ?? '';
            return av < bv ? -dir : av > bv ? dir : 0;
        });
    }

    get pageStart() {
        return this.totalCases === 0 ? 0 : (this.currentPage - 1) * PAGE_SIZE + 1;
    }

    get pageEnd() {
        return Math.min(this.currentPage * PAGE_SIZE, this.totalCases);
    }

    get isFirstPage() {
        return this.currentPage === 1;
    }

    get isLastPage() {
        return this.currentPage * PAGE_SIZE >= this.totalCases;
    }

    get hasCases() {
        return !this.isLoading && this.allCases.length > 0;
    }

    get isEmpty() {
        return !this.isLoading && !this.error && this.allCases.length === 0;
    }

    // ── Event handlers ───────────────────────────────────────────────────────

    handleStatusChange(event) {
        this.selectedStatus = event.detail.value;
        this.loadCases();
    }

    handleSort(event) {
        this.sortedBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
    }

    handlePrevPage() {
        if (!this.isFirstPage) this.currentPage--;
    }

    handleNextPage() {
        if (!this.isLastPage) this.currentPage++;
    }

    handleRowAction(event) {
        const action = event.detail.action.name;
        const row = event.detail.row;
        if (action === 'view') {
            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: { url: `/cases/${row.Id}` }
            });
        }
    }

    handleNewCase() {
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: { url: '/cases/new' }
        });
    }
}
