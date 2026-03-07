import { LightningElement, track } from 'lwc';

export default class CatalystAriaLauncher extends LightningElement {
    @track _isOpen = false;

    get isOpen() {
        return this._isOpen;
    }

    handleToggleChat() {
        this._isOpen = !this._isOpen;
    }
}
