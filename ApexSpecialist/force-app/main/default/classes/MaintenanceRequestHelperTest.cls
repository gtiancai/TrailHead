@IsTest
public without sharing class MaintenanceRequestHelperTest {
    @TestSetup
    static void makeData(){
        Product2 prod1 = new Product2(
            Name = 'Prod-01',
            IsActive = true,
            Replacement_Part__c = true,
            Cost__c = 10,
            Current_Inventory__c = 100,
            Lifespan_Months__c = 50,
            Maintenance_Cycle__c = 100);
        
        Product2 prod2 = new Product2(
            Name = 'Prod-02',
            IsActive = true,
            Replacement_Part__c = true,
            Cost__c = 30,
            Current_Inventory__c = 300,
            Lifespan_Months__c = 100,
            Maintenance_Cycle__c = 300);
        
        Case case1 = new Case(
            Subject = 'Case-01',
            Type = 'Repair',
            Status = 'New');

        Case case2= new Case(
            Subject = 'Case-02',
            Type = 'Routine Maintenance',
            Status = 'New');

        Case case3 = new Case(
            Subject = 'Case-03',
            Type = 'Electrical',
            Status = 'New');

        insert new List<SObject> {prod1, prod2, case1, case2, case3};

        insert new List<Equipment_Maintenance_Item__c> {
            new Equipment_Maintenance_Item__c(
                Equipment__c = prod1.Id,
                Maintenance_Request__c = case1.Id,
                Quantity__c = 10
            ),
            new Equipment_Maintenance_Item__c(
                Equipment__c = prod2.Id,
                Maintenance_Request__c = case1.Id,
                Quantity__c = 20
            ),
            new Equipment_Maintenance_Item__c(
                Equipment__c = prod1.Id,
                Maintenance_Request__c = case3.Id,
                Quantity__c = 30
            ),
            new Equipment_Maintenance_Item__c(
                Equipment__c = prod2.Id,
                Maintenance_Request__c = case3.Id,
                Quantity__c = 40
            )};
    }

    @IsTest
    static void test1(){
        Case c1 = [SELECT Id FROM Case wHERE Subject = 'Case-01'];
        c1.Status = 'Closed';

        update c1;

        c1 = [SELECT Status FROM Case WHERE Subject = 'Case-01' AND Id != :c1.Id];

        System.assertEquals('New', c1.Status, 'incorrect status');
    }

    @IsTest
    static void test2(){
        Case c1 = [SELECT Id FROM Case wHERE Subject = 'Case-03'];
        c1.Status = 'Closed';

        update c1;

        List<Case> cases = [SELECT Id FROM Case WHERE Subject = 'Case-03' AND Id != :c1.Id];

        System.assertEquals(0, cases.size(), 'No case should be created');
    }
}
