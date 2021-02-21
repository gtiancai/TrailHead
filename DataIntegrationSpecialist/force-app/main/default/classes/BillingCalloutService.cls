public with sharing class BillingCalloutService {
    public static void callBillingService(List<Project__c> oldProjs, List<Project__c> newProjs) {
        if (Trigger.isAfter && Trigger.isUpdate) {
            List<Project__c> projList = new List<Project__c>();
            Map<Id, Project__c> oldMap = (Map<Id, Project__c>)Trigger.OldMap;
            for (Project__c proj : (List<Project__c>)Trigger.New) {
                if (proj.Status__c == 'Billable' && proj.Status__c != oldMap.get(proj.Id).Status__c) {
                    projList.add(proj);
                }
            }

            if (!projList.isEmpty()) {
                // BillingServiceProxy.InvoicesPortSoap11 proxy = new BillingServiceProxy.InvoicesPortSoap11();
                ServiceCredentials__c credential = ServiceCredentials__c.getInstance('BillingServiceCredential');
                for (Project__c proj : projList) {
                //     BillingServiceProxy.project project = new BillingServiceProxy.project();
                //     project.billAmount = proj.Billable_Amount__c;
                //     project.projectid = proj.ProjectRef__c;
                //     project.username = credential.Username__c;
                //     Project.password = credential.Password__c;

                //     String ret = proxy.billProject(project);

                //     if (ret == Constants.HTTP_STATUS_OK) {
                //         proj.Status__c = 'Billed';
                //     }
                    BillingCalloutService.billProject(proj.ProjectRef__c, proj.Billable_Amount__c, credential.Username__c, credential.Password__c);
                }

                // update projList;
            }
        }
    }

    @future(callout = true)
    public static void billProject(String projRef, Decimal amount, String userName, String pwd) {
        BillingServiceProxy.InvoicesPortSoap11 proxy = new BillingServiceProxy.InvoicesPortSoap11();
        
        BillingServiceProxy.project project = new BillingServiceProxy.project();
        project.billAmount = amount;
        project.projectid = projRef;
        project.username = userName;
        Project.password = pwd;

        String ret = proxy.billProject(project);

        if (ret == Constants.HTTP_STATUS_OK) {
            Project__c proj = [SELECT Id FROM Project__c WHERE ProjectRef__c = :projRef];
            proj.Status__c = 'Billed';

            update proj;
        }
    }
}
