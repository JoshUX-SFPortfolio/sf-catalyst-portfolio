/**
 * Jest tests for catalyst-client-dashboard
 * MKT-TC-EXP-009
 */
import { createElement } from 'lwc';
import CatalystClientDashboard from 'c/catalystClientDashboard';

describe('c-catalyst-client-dashboard', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('renders the dashboard container', () => {
        const element = createElement('c-catalyst-client-dashboard', { is: CatalystClientDashboard });
        document.body.appendChild(element);
        expect(element.shadowRoot.querySelector('.catalyst-client-dashboard')).not.toBeNull();
    });

    it('renders the open cases tile child component', () => {
        const element = createElement('c-catalyst-client-dashboard', { is: CatalystClientDashboard });
        document.body.appendChild(element);
        expect(element.shadowRoot.querySelector('c-catalyst-open-cases-tile')).not.toBeNull();
    });

    it('renders the subscription tile child component', () => {
        const element = createElement('c-catalyst-client-dashboard', { is: CatalystClientDashboard });
        document.body.appendChild(element);
        expect(element.shadowRoot.querySelector('c-catalyst-subscription-tile')).not.toBeNull();
    });

    it('renders the module list child component', () => {
        const element = createElement('c-catalyst-client-dashboard', { is: CatalystClientDashboard });
        document.body.appendChild(element);
        expect(element.shadowRoot.querySelector('c-catalyst-module-list')).not.toBeNull();
    });

    it('renders the onboarding checklist child component', () => {
        const element = createElement('c-catalyst-client-dashboard', { is: CatalystClientDashboard });
        document.body.appendChild(element);
        expect(element.shadowRoot.querySelector('c-catalyst-onboarding-checklist')).not.toBeNull();
    });

    it('renders the usage heatmap child component', () => {
        const element = createElement('c-catalyst-client-dashboard', { is: CatalystClientDashboard });
        document.body.appendChild(element);
        expect(element.shadowRoot.querySelector('c-catalyst-usage-heatmap')).not.toBeNull();
    });
});
