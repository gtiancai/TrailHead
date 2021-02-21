trigger ProjectTrigger on Project__c (after update) {
    //Call the Billing Service callout logic here
    BillingCalloutService.callBillingService((List<Project__c>)Trigger.old, (List<Project__c>)Trigger.new);
}