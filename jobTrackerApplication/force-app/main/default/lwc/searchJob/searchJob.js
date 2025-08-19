import { LightningElement, track } from 'lwc';

export default class SearchJob extends LightningElement {
    @track searchValue = '';

    handleChange(event) {
        this.searchValue = event.target.value;
        const searchEvent = new CustomEvent('search', {
            detail: this.searchValue
        });
        this.dispatchEvent(searchEvent);
    }
}