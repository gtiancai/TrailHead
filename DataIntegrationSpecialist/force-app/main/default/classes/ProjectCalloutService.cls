public with sharing class ProjectCalloutService {
    @InvocableMethod
    public static void PostOpportunityToPMS(List<Id> oppId) {
        Opportunity opp = [SELECT Name, Account.Name, CloseDate, Amount
            FROM Opportunity 
            WHERE Id = :oppId[0]];
        
        OppWrapper wrapper = new OppWrapper(opp);

        String strJSON = JSON.serialize(wrapper);

        HttpResponse response = sendData(strJSON);
        if (response.getStatusCode() == Constants.HTTP_STATUS_CODE_SUCCESS) {
            opp.StageName = 'Submitted Project';
        } else {
            opp.StageName = 'Resubmit Project';
        }

        update opp;
    }

    public static HttpResponse sendData(String data) {
        ServiceTokens__c svcToken = ServiceTokens__c.getInstance('ProjectServiceToken');
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint('callout:ProjectService');
        request.setHeader('Content-Type', 'application/json');
        // if (!Test.isRunningTest()) {
            request.setHeader('token', svcToken.Token__c);
        // }
        request.setBody(data);
        request.setTimeout(120 * 1000);
        return http.send(request);
    }


    public with sharing class QueueablePMSCall implements Queueable, Database.AllowsCallouts {
        private List<Id> oppIdList;
        public QueueablePMSCall(List<Id> opppIdList) {
            this.oppIdList = opppIdList;
        }

        public void execute(QueueableContext qc) {
            ProjectCalloutService.PostOpportunityToPMS(this.oppIdList);
        }
    }

    public without sharing class OppWrapper {
        public String opportunityId {get; set;}
        public String opportunityName {get; set;}
        public String accountName {get; set;}
        public Date closeDate {get; set;}
        public Integer amount {get; set;}

        public OppWrapper(Opportunity opp) {
            opportunityId = opp.Id;
            opportunityName = opp.Name;
            accountName = opp.Account.Name;
            closeDate = opp.CloseDate;
            amount = Integer.valueOf(opp.Amount);
        }
    }
}
