import { createElement } from 'lwc';
import PortfolioLanding from 'c/portfolioLanding';

describe('c-portfolio-landing', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('renders primary hero title', () => {
        const element = createElement('c-portfolio-landing', { is: PortfolioLanding });
        document.body.appendChild(element);

        const title = element.shadowRoot.querySelector('.frontdoor__title');
        expect(title).not.toBeNull();
        expect(title.textContent).toContain('master org');
    });

    it('renders highlight cards and vertical cards', () => {
        const element = createElement('c-portfolio-landing', { is: PortfolioLanding });
        document.body.appendChild(element);

        const highlights = element.shadowRoot.querySelectorAll('.highlight');
        const verticalCards = element.shadowRoot.querySelectorAll('.vertical-card');

        expect(highlights.length).toBe(4);
        expect(verticalCards.length).toBe(3);
    });

    it('contains two CTA links', () => {
        const element = createElement('c-portfolio-landing', { is: PortfolioLanding });
        document.body.appendChild(element);

        const ctas = element.shadowRoot.querySelectorAll('.frontdoor__actions a');
        expect(ctas.length).toBe(2);
        expect(ctas[0].getAttribute('href')).toBe('/portfolio');
    });
});
