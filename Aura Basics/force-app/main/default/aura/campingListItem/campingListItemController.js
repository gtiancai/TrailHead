({
	packItem : function(component, event, helper) {
		var btn = event.getSource();
		// component.get("v.item").packed = true;
		component.set("v.item.Packed__c", true);
		btn.set("disabled", true);
	}
})