public with sharing class WarehouseCalloutService implements queueable {
    public WarehouseCalloutService() {
        
    }

    public void execute(QueueableContext qc) {
        WarehouseCalloutService.runWarehouseEquipmentSync();
    }

    @Future(callout = true)
    public static void runWarehouseEquipmentSync() {
        List<Equipment> equipments = WarehouseCalloutService.getEquipments();

        if (equipments == null || equipments.isEmpty()) {
            return;
        }

        Set<String> skuSet = new Set<String>();
        // Map<String, Equipment> mapSku2Equipment = new Map<String, Equipment>();
        for (Equipment item : equipments) {
            skuSet.add(item.sku);
            // mapSku2Equipment.put(item.sku, item);
        }

        List<Product2> prodList = [SELECT Replacement_Part__c, Cost__c, Current_Inventory__c, Lifespan_Months__c, Warehouse_SKU__c
            FROM Product2
            WHERE Warehouse_SKU__c IN :skuSet];

        List<Product2> prod2Upsert = new List<Product2>();
        Map<String, Product2> sku2ProdMap = new Map<String, Product2>();
        for (Product2 prod : prodList) {
            sku2ProdMap.put(prod.Warehouse_SKU__c, prod);
        }

        for (Equipment item : equipments) {
            Product2 prod;
            if (sku2ProdMap.containsKey(item.sku)) {
                prod = sku2ProdMap.get(item.sku);
                prod.Replacement_Part__c = item.replacement;
            } else {
                prod = new Product2();
                prod.Name = item.name;
                prod.IsActive = true;
                prod.Replacement_Part__c = true;
            }            

            prod.Cost__c = item.cost;
            prod.Current_Inventory__c = item.quantity;
            prod.Lifespan_Months__c = item.lifespan;
            prod.Maintenance_Cycle__c = item.maintenanceperiod;

            prod2Upsert.add(prod);
        }

        upsert prod2Upsert;
    }

    private static List<Equipment> getEquipments() {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://th-superbadge-apex.herokuapp.com/equipment');
        req.setMethod('GET');
        HttpResponse res = http.send(req);
     
        // Log the XML content
        System.debug(res.getBody());
     
        // Map<String, SObject> responseMap = (Map<String, SObject>)JSON.deserializeUntyped(res.getBody());
        List<Equipment> equipmentList = (List<Equipment>)JSON.deserialize(res.getBody(), List<Equipment>.class);

        return equipmentList;
    }

    public without sharing class Equipment {
        // public String _id {get; set;}
        public Boolean replacement {get; set;}
        public Integer quantity {get; set;}
        public String name {get; set;}
        public Integer maintenanceperiod {get; set;}
        public Integer lifespan {get; set;}
        public Decimal cost {get; set;}
        public String sku {get; set;}
    }
}
