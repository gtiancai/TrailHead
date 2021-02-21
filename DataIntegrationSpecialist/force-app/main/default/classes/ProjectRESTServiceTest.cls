@IsTest
public without sharing class ProjectRESTServiceTest {
    @IsTest
    static void test(){
        Opportunity opp = new Opportunity(
            Name = 'Opp 01',
            StageName = 'New',
            // AccountId = acc.Id,
            Type = 'New Project',
            CloseDate = Date.today().addDays(2)
        );

        insert opp;

        String status = ProjectRESTService.postProjectData('abc', 'name', opp.Id, Date.today(), Date.today().addDays(10), 100, 'Running');

        System.assertEquals(Constants.HTTP_STATUS_OK, status, 'Incorrect status');
    }

    @IsTest
    static void test2(){
        String status = ProjectRESTService.postProjectData('abc', 'name', 'opp.Id', Date.today(), Date.today().addDays(10), 100, 'Running');

        System.assertNotEquals(Constants.HTTP_STATUS_OK, status, 'Incorrect status');
    }
}
