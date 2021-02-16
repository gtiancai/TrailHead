public with sharing class ContactController {
    public ContactController() {

    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts() {
        throw new AuraHandledException('Test Exception');
        // return [SELECT FirstName, LastName, Email FROM Contact];
    }
}
