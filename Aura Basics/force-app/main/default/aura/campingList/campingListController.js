({
    doInit : function(component, event, helper) {
        var action = component.get("c.getItems");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                component.set("v.items", response.getReturnValue());
            } else {
                console.log("Error: " + state);
            }
        });

        $A.enqueueAction(action);
    },
    clickCreateItem : function (component, event, helper) {
        var validItem = component.find('itemForm').reduce(function (validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);

        // If we pass error checking, do some real work
        if(validItem){
            // Create the new item
            var newItem = component.get("v.newItem");
            console.log("New item: " + JSON.stringify(newItem));
            
            // var items = component.get("v.items");
            // var newItemJson = JSON.parse(JSON.stringify(newItem));

            // items.push(newItemJson);
            // component.set("v.items", items);

            helper.createItem(newItem);
            component.set("v.newItem", {'sobjectType':'Camping_Item__c'} );
        }
    },
    handleAddItem : function (component,event,helper){
        var action = component.get("c.saveItem");
        var Item = event.getParam("item");
        var lstItems = component.get("v.items");
        console.log("Before:"+lstItems);
        lstItems.push(Item);
        component.set("v.items",lstItems);
        console.log("After:"+lstItems);
        action.setParams({"CampingItem":Item});
        action.setCallback(this,function(response){
           var state = response.getState();
           if (component.isValid() && state === "SUCCESS") {
               console.log('save');
           }
        });
      $A.enqueueAction(action);   
   }
})