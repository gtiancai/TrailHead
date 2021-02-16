import { LightningElement, api, wire } from 'lwc';
import getContacts from '@salesforce/apex/ContactController.getContacts';

import FIRST_FIELD from '@salesforce/schema/Contact.FirstName';
import LASTNAME_FIELD from '@salesforce/schema/Contact.LastName';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';

import { reduceErrors } from 'c/ldsUtils';

const COLUMNS = [
    { label: 'First Name', fieldName: FIRST_FIELD.fieldApiName, type: 'text' },
    { label: 'Last Revenue', fieldName: LASTNAME_FIELD.fieldApiName, type: 'text' },
    { label: 'Email', fieldName: EMAIL_FIELD.fieldApiName, type: 'text' }
];

export default class ContactList extends LightningElement {
    @api
    contacts
    conlumns = COLUMNS;
    @wire(getContacts)
    wiredContacts({error, data}) {
        if (data) {
            console.log("data: " + data);
            this.contacts = data;
        } else {
            console.log("error: " + error);
        }
    }

    get errors() {
        return reduceErrors(this.wiredContacts.error);
    }
}