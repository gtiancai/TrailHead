@IsTest
public without sharing class BillingCalloutServiceTest {
    @TestSetup
    static void makeData(){
        Opportunity opp = new Opportunity(
            Name = 'Opp-01',
            StageName = 'New',
            CloseDate = Date.today().addDays(100)
        );
        insert opp;
        insert new Project__c(
            ProjectRef__c = 'Proj-01',
            Billable_Amount__c = 100, 
            Status__c = 'Running',
            Opportunity__c = opp.Id
        );

        insert new ServiceCredentials__c(Name = 'BillingServiceCredential', Username__c = 'u', Password__c = 'p');
    }

    @IsTest
    static void test(){
        Project__c proj = [SELECT Id FROM Project__c WHERE ProjectRef__c = 'Proj-01'];
        proj.Status__c = 'Billable';

        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock('', 'OK', Constants.HTTP_STATUS_CODE_SUCCESS));

        Test.startTest();
        update proj;
        Test.stopTest();

        proj = [SELECT Status__c FROM Project__c WHERE ProjectRef__c = 'Proj-01'];
        System.assertEquals('Billed', proj.Status__c, 'Incorrect status');
    }

    @IsTest
    static void test2(){
        Project__c proj = [SELECT Id FROM Project__c WHERE ProjectRef__c = 'Proj-01'];
        proj.Status__c = 'Billable';

        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMockFailure('', 'xx', Constants.HTTP_STATUS_CODE_FAIL));

        Test.startTest();
        update proj;
        Test.stopTest();

        proj = [SELECT Status__c FROM Project__c WHERE ProjectRef__c = 'Proj-01'];
        System.assertNotEquals('Billed', proj.Status__c, 'Incorrect status');
    }
}
