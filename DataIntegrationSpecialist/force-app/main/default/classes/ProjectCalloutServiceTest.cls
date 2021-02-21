@IsTest
public without sharing class ProjectCalloutServiceTest {
    @TestSetup
    static void makeData(){
        Account acc = new Account(
            Name = 'Acc 01');
        insert acc;

        insert new List<Opportunity> {
            new Opportunity(
                Name = 'Opp 01',
                StageName = 'New',
                AccountId = acc.Id,
                Type = 'New Project',
                CloseDate = Date.today().addDays(2)
            ),
            new Opportunity(
                Name = 'Opp 02',
                StageName = 'New',
                AccountId = acc.Id,
                Type = 'New Project',
                CloseDate = Date.today().addDays(2)
            )
        };

        insert new ServiceTokens__c(Name = 'ProjectServiceToken', Token__c = '32f4fd4e-57bc-4993-97fa-30c9b0a302af');
    }

    @IsTest
    static void test(){
        Opportunity opp = [SELECT Name, Account.Name, CloseDate, Amount FROM Opportunity WHERE Name = 'Opp 01'];

        ProjectCalloutService.OppWrapper wrapper = new ProjectCalloutService.OppWrapper(opp);
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock(JSON.serialize(wrapper), Constants.HTTP_STATUS_OK, Constants.HTTP_STATUS_CODE_SUCCESS));
        Test.startTest();
        opp.StageName = 'Closed Won';
        // update opp;
        ProjectCalloutService.QueueablePMSCall queue = new ProjectCalloutService.QueueablePMSCall(new List<Id> {opp.Id});
        System.enqueueJob(queue);
        Test.stopTest();
        
        opp = [SELECT StageName FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals('Submitted Project', opp.StageName, 'Failed to send opportunity');
    }
}
