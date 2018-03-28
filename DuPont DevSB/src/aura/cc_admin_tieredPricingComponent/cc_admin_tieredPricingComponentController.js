({
	doInit: function (component, event, helper) {
		helper.getPriceListItem(component, helper);
	},
	createNewRow: function (component, event, helper) {
		helper.createRow(component, event, helper);
	},
	handleSaveTiers: function (component, event, helper) {
		helper.saveToRecord(component, event, helper, "Your pricing tiers have been saved", "Please set all values to save", true);
	},
	handleClearClick: function(component, event, helper) {
		$A.util.removeClass(component.find("clearConfirm"), 'slds-hide');
		$A.util.addClass(component.find("mainButtons"), 'slds-hide');
	},
	handleCancelClear: function(component, event, helper) {
		$A.util.removeClass(component.find("mainButtons"), 'slds-hide');
		$A.util.addClass(component.find("clearConfirm"), 'slds-hide');
	},
	handleClearTiers: function (component, event, helper) {
		helper.clearRows(component, event, helper);
		$A.util.removeClass(component.find("mainButtons"), 'slds-hide');
		$A.util.addClass(component.find("clearConfirm"), 'slds-hide');
	},
	handleQuantityBlur: function (component, event, helper) {
		helper.updateRows(component, helper);
	},
	handlePriceChange: function (component, event, helper) {
		helper.updateRows(component, helper);
	},
	handleTypeChange: function (component, event, helper) {
		helper.changeType(component, event, helper);
	},
	handleDeleteClick: function (component, event, helper) {
		var button = event.getSource ? event.getSource().getElement() : event.target;
		var deleteRow = button.parentElement.parentElement.getElementsByClassName('deleteConfirm')[0];
		var buttonRow = button.parentElement.parentElement.getElementsByClassName('buttonRow')[0];
		deleteRow.classList.remove('slds-hide');
		buttonRow.classList.add('slds-hide');
	},
	handleConfirmDelete: function (component, event, helper) {
		var index = (event.getSource ? event.getSource().getElement() : event.target).getAttribute('data-index');
		helper.deleteRow(component, index);
	},
	handleCancelDelete: function (component, event, helper) {
		var button = event.getSource ? event.getSource().getElement() : event.target;
		var deleteRow = button.parentElement.parentElement.getElementsByClassName('deleteConfirm')[0];
		var buttonRow = button.parentElement.parentElement.getElementsByClassName('buttonRow')[0];
		deleteRow.classList.add('slds-hide');
		buttonRow.classList.remove('slds-hide');
	},
})