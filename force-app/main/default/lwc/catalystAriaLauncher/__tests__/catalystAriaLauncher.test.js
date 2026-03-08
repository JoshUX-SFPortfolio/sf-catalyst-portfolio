/**
 * Jest tests for catalyst-aria-launcher
 * MKT-TC-EXP-013
 */
import { createElement } from 'lwc';
import CatalystAriaLauncher from 'c/catalystAriaLauncher';

describe('c-catalyst-aria-launcher', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('renders the FAB button on load', () => {
        const element = createElement('c-catalyst-aria-launcher', { is: CatalystAriaLauncher });
        document.body.appendChild(element);
        const button = element.shadowRoot.querySelector('.aria-fab__button');
        expect(button).not.toBeNull();
    });

    it('renders Aria label text when closed', () => {
        const element = createElement('c-catalyst-aria-launcher', { is: CatalystAriaLauncher });
        document.body.appendChild(element);
        expect(element.shadowRoot.textContent).toContain('Aria');
    });

    it('opens chat panel when button is clicked', async () => {
        const element = createElement('c-catalyst-aria-launcher', { is: CatalystAriaLauncher });
        document.body.appendChild(element);
        const button = element.shadowRoot.querySelector('.aria-fab__button');
        button.click();
        await Promise.resolve();
        const panel = element.shadowRoot.querySelector('.aria-chat-panel');
        expect(panel).not.toBeNull();
    });

    it('closes chat panel on second click (toggle)', async () => {
        const element = createElement('c-catalyst-aria-launcher', { is: CatalystAriaLauncher });
        document.body.appendChild(element);
        const button = element.shadowRoot.querySelector('.aria-fab__button');
        button.click();
        await Promise.resolve();
        button.click();
        await Promise.resolve();
        const panel = element.shadowRoot.querySelector('.aria-chat-panel');
        expect(panel).toBeNull();
    });

    it('chat panel has correct aria attributes', async () => {
        const element = createElement('c-catalyst-aria-launcher', { is: CatalystAriaLauncher });
        document.body.appendChild(element);
        const button = element.shadowRoot.querySelector('.aria-fab__button');
        button.click();
        await Promise.resolve();
        const panel = element.shadowRoot.querySelector('[role="dialog"]');
        expect(panel).not.toBeNull();
        expect(panel.getAttribute('aria-label')).toContain('Aria');
    });
});
