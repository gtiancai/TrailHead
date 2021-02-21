public inherited sharing class MaintenanceRequestHelper {
    public MaintenanceRequestHelper() {

    }

    public void handle() {
        if (Trigger.isAfter && Trigger.isUpdate) {
            List<Case> closedCaseList = new List<Case>();
            Map<Id, Case> oldCaseMap = (Map<Id, Case>)Trigger.oldMap;
            Set<Id> caseIdSet = new Set<Id>();

            for (Case c : (List<Case>)Trigger.New) {
                if ((c.Type == 'Repair' || c.Type == 'Routine Maintenance') 
                    && c.Status == 'Closed' && oldCaseMap.get(c.Id).Status != 'Closed') {
                    closedCaseList.add(c);
                    caseIdSet.add(c.Id);
                }
            }

            if (caseIdSet.isEmpty()) {
                return;
            }

            List<Equipment_Maintenance_Item__c> maintenanceItemList = [SELECT Equipment__c, Equipment__r.Maintenance_Cycle__c,
                    Maintenance_Request__c, Quantity__c
                FROM Equipment_Maintenance_Item__c
                WHERE Maintenance_Request__c IN :caseIdSet
                ORDER BY Maintenance_Request__c, Equipment__r.Maintenance_Cycle__c];

            Map<Id, Integer> caseId2MaintenanceDays = new Map<Id, Integer>();
            Map<Id, List<Equipment_Maintenance_Item__c>> caseId2MaintenanceItemsMap = new Map<Id, List<Equipment_Maintenance_Item__c>>();

            for (Equipment_Maintenance_Item__c item : maintenanceItemList) {
                if (!caseId2MaintenanceDays.containsKey(item.Maintenance_Request__c)) {
                    caseId2MaintenanceDays.put(item.Maintenance_Request__c, Integer.valueOf(item.Equipment__r.Maintenance_Cycle__c));
                    caseId2MaintenanceItemsMap.put(item.Maintenance_Request__c, new List<Equipment_Maintenance_Item__c>());
                }

                caseId2MaintenanceItemsMap.get(item.Maintenance_Request__c).add(item);
            }

            // if (caseId2MaintenanceDays.isEmpty()) {
            //     return;
            // }

            List<Case> newCaseList = new List<Case>();
            for (Case cc : closedCaseList) {
                Case newCase = cc.clone();
                if (caseId2MaintenanceDays.containsKey(cc.Id)) {
                    newCase.Date_Due__c = Date.today().addDays(caseId2MaintenanceDays.get(cc.Id));
                }
                newCase.ParentId = cc.Id;
                newCase.Status = 'New';
                newCase.Comments = null;
                newCase.Reason = 'New Maintenance Cycle';

                newCaseList.add(newCase);
            }

            insert newCaseList;

            List<Equipment_Maintenance_Item__c> newItemList = new List<Equipment_Maintenance_Item__c>();
            for (Case cc : newCaseList) {
                for (Equipment_Maintenance_Item__c item : caseId2MaintenanceItemsMap.get(cc.ParentId)) {
                    Equipment_Maintenance_Item__c tmp = item.clone();
                    tmp.Maintenance_Request__c = cc.Id;

                    newItemList.add(tmp);
                }
            }

            insert newItemList;
        }
    }
}
