@IsTest
public inherited sharing class WarehouseCalloutServiceTest {
    @TestSetup
    static void makeData(){
        Product2 prod1 = new Product2(
            Name = 'Prod-01',
            IsActive = true,
            Replacement_Part__c = true,
            Cost__c = 10,
            Current_Inventory__c = 100,
            Lifespan_Months__c = 50,
            Warehouse_SKU__c = 'Prod-SKU-01',
            Maintenance_Cycle__c = 100);
        
        Product2 prod2 = new Product2(
            Name = 'Prod-02',
            IsActive = true,
            Replacement_Part__c = true,
            Cost__c = 30,
            Current_Inventory__c = 300,
            Lifespan_Months__c = 100,
            Warehouse_SKU__c = 'Prod-SKU-02',
            Maintenance_Cycle__c = 300);

        insert new List<SObject> {prod1, prod2};
    }

    @IsTest
    static void test(){
        String respStr = '[{"replacement":false,"quantity":5,"name":"Generator 1000 kW","maintenanceperiod":365,"lifespan":120,"cost":5000,"sku":"Prod-SKU-01"},'
            + '{"replacement":true,"quantity":194,"name":"Fuse 8A","maintenanceperiod":0,"lifespan":0,"cost":5,"sku":"Prod-SKU-03"}]';

        WarehouseCalloutServiceMock mock = new WarehouseCalloutServiceMock(respStr, 200);
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        // System.enqueueJob(new WarehouseCalloutService());
        WarehouseCalloutService.runWarehouseEquipmentSync();
        Test.stopTest();

        List<Product2> prods = [SELECT Id FROM Product2 LIMIT 1000];
        System.assertEquals(3, prods.size(), 'incorrect product number');
    }

    @IsTest
    static void test2(){
        String respStr = '[]';

        WarehouseCalloutServiceMock mock = new WarehouseCalloutServiceMock(respStr, 200);
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        // System.enqueueJob(new WarehouseCalloutService());
        WarehouseCalloutService.runWarehouseEquipmentSync();
        Test.stopTest();

        List<Product2> prods = [SELECT Id FROM Product2 LIMIT 1000];
        System.assertEquals(2, prods.size(), 'incorrect product number');
    }

    @IsTest
    static void test3(){
        String respStr = '[]';

        WarehouseCalloutServiceMock mock = new WarehouseCalloutServiceMock(respStr, 200);
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        System.enqueueJob(new WarehouseCalloutService());
        // WarehouseCalloutService.runWarehouseEquipmentSync();
        Test.stopTest();

        List<Product2> prods = [SELECT Id FROM Product2 LIMIT 1000];
        System.assertEquals(2, prods.size(), 'incorrect product number');
    }
}
