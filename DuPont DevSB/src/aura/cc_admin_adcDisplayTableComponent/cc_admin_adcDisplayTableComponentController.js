({
    doInit : function(component, event, helper) {
        helper.getPriceListItem(component, helper);
    },
    handleSaveNewRow: function(component, event, helper) {
        var attributes = component.get("v.currentAttributes");
        var primaryAttribute, primaryAttributeName, secondaryAttribute, secondaryAttributeName, tertiaryAttribute, tertiaryAttributeName, price;

        primaryAttributeName = component.get("v.primaryAttribute");
        secondaryAttributeName = component.get("v.secondaryAttribute");
        tertiaryAttributeName = component.get("v.tertiaryAttribute");

        var primaryAttributeOptions = component.get("v.primaryAttributeOptions");
        var secondaryAttributeOptions = component.get("v.secondaryAttributeOptions");
        var tertiaryAttributeOptions = component.get("v.tertiaryAttributeOptions");
        var primaryAttrLookup = helper.getLookupList(primaryAttributeOptions);
        var secondaryAttrLookup = helper.getLookupList(secondaryAttributeOptions);
        var tertiaryAttrLookup = helper.getLookupList(tertiaryAttributeOptions);

        var newRow = {};

        var hasErrors = false;
        var primaryAttributeEl = component.find("primarySelect");
        if(primaryAttributeEl) {
            primaryAttribute = primaryAttributeEl.get("v.value");
            if(primaryAttribute === "" || primaryAttribute == null)
            {
                primaryAttributeEl.showHelpMessageIfInvalid();
                hasErrors = true;
            } else {
                newRow.primary = {name: primaryAttrLookup[primaryAttribute], ID: primaryAttribute};
            }
        }
        var secondaryAttributeEl = component.find("secondarySelect");
        if(secondaryAttributeEl) {
            secondaryAttribute = secondaryAttributeEl.get("v.value");
            if(secondaryAttribute === "" || secondaryAttribute == null)
            {
                secondaryAttributeEl.showHelpMessageIfInvalid();
                hasErrors = true;
            } else {
                newRow.secondary = {name: secondaryAttrLookup[secondaryAttribute], ID: secondaryAttribute};
            }
        }
        var tertiaryAttributeEl = component.find("tertiarySelect");
        if(tertiaryAttributeEl) {
            tertiaryAttribute = tertiaryAttributeEl.get("v.value");
            if(tertiaryAttribute === "" || tertiaryAttribute == null)
            {
                tertiaryAttributeEl.showHelpMessageIfInvalid();
                hasErrors = true;
            } else {
                newRow.tertiary = {name: tertiaryAttrLookup[tertiaryAttribute], ID: tertiaryAttribute};
            }
        }
        if(!hasErrors) {
            if(helper.checkIfRowExists(component, helper, newRow)) {
				component.set("v.errors", ["This combination of attributes already exists"]);
            } else {
                component.set("v.errors", null);

                var price = component.find("price").get("v.value");
                newRow.price = price;

                attributes.unshift(newRow);
                component.set("v.currentAttributes", attributes);

                helper.clearInputs(component, helper);
                helper.saveToObject(component, helper);
            }
        }
    },
    handleClearNewRow: function(component, event, helper) {
        helper.clearInputs(component, helper);
    },
    handleEditClick: function(component, event, helper) {
        helper.setRowToEditMode(component, event, helper);

        var button = event.getSource ? event.getSource().getElement() : event.target;
        var priceDisplay = button.parentElement.parentElement.getElementsByClassName('priceDisplay')[0];
        priceDisplay.setAttribute('data-originalValue', priceDisplay.innerText);
    },
    handleSaveRow: function(component, event, helper) {
        helper.setRowToViewMode(component, event, helper);
        helper.saveToObject(component, helper);

        // The attribute updates automatically thanks to data binding, but we need to update our "original" if someone saves and updates again.
        var button = event.getSource ? event.getSource().getElement() : event.target;
        var priceDisplay = button.parentElement.parentElement.getElementsByClassName('priceDisplay')[0];
        priceDisplay.setAttribute('data-originalValue', priceDisplay.innerText);
    },
    handleCancelRow: function(component, event, helper) {
        helper.setRowToViewMode(component, event, helper);

        var button = event.getSource ? event.getSource().getElement() : event.target;
        var priceDisplay = button.parentElement.parentElement.getElementsByClassName('priceDisplay')[0];
        var index = button.parentElement.parentElement.getElementsByClassName('priceEditWrapper')[0].getAttribute('data-index');

        // we only need to update the underlying data, because data binding
        var attributes = component.get("v.currentAttributes");
        attributes[index].price = priceDisplay.getAttribute('data-originalValue');
        component.set("v.currentAttributes", attributes);
    },
    handleDeleteClick: function(component, event, helper) {
        var button = event.getSource ? event.getSource().getElement() : event.target;
        var deleteRow = button.parentElement.parentElement.getElementsByClassName('deleteConfirm')[0];
        var buttonRow = button.parentElement.parentElement.getElementsByClassName('buttonRow')[0];
        deleteRow.classList.remove('slds-hide');
        buttonRow.classList.add('slds-hide');
    },
    handleConfirmDelete: function(component, event, helper) {
        var attributes = component.get("v.currentAttributes");
        var index = (event.getSource ? event.getSource().getElement() : event.target).getAttribute('data-index');
        attributes.splice(index, 1);
        component.set("v.currentAttributes", attributes);
        helper.saveToObject(component, helper);
    },
    handleCancelDelete: function(component, event, helper) {
        var button = event.getSource ? event.getSource().getElement() : event.target;
        var deleteRow = button.parentElement.parentElement.getElementsByClassName('deleteConfirm')[0];
        var buttonRow = button.parentElement.parentElement.getElementsByClassName('buttonRow')[0];
        deleteRow.classList.add('slds-hide');
        buttonRow.classList.remove('slds-hide');
    },
    selectText: function(component, event, helper) {
        var element = event.getSource ? event.getSource().getElement() : event.target;
        element.select();
    }
})