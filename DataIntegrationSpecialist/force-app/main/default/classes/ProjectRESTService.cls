@RestResource(urlMapping='/project/*')
global inherited sharing class ProjectRESTService {
    @httpPost
    // global static String postProjectData(String post) {
    global static String postProjectData(String ProjectRef, String ProjectName, String OpportunityId, Date StartDate, Date EndDate, Double Amount, String Status) {
        Savepoint sp = Database.setSavePoint();
        try {
            // Map<String, Object> keyValueMap = (Map<String, Object>)JSON.deserializeUntyped(post);
            // String  projectRef = String.valueOf(keyValueMap.get('ProjectRef'));
            // String	projectName = String.valueOf(keyValueMap.get('ProjectName'));
            // String	opportunityId = String.valueOf(keyValueMap.get('OpportunityId'));
            // Date	startDate = Date.valueOf(keyValueMap.get('StartDate'));
            // Date	endDate = Date.valueOf(keyValueMap.get('EndDate'));
            // Double	amount = Double.valueOf(keyValueMap.get('Amount'));
            // String	status = String.valueOf(keyValueMap.get('Status'));

            Project__c proj = new Project__c(
                ProjectRef__c = projectRef,
                Name = projectName,
                Opportunity__c = opportunityId,
                Start_Date__c = startDate,
                End_Date__c = endDate,
                Billable_Amount__c = amount,
                Status__c = status
            );

            upsert proj ProjectRef__c;

            Opportunity opp = [SELECT Id FROM Opportunity WHERE Id = :opportunityId];
            opp.DeliveryInstallationStatus__c = 'In progress ';
            update opp;
        } catch (Exception ex) {
            Database.rollback(sp);
            return ex.getMessage();
        }

        return Constants.HTTP_STATUS_OK;
    }
}
