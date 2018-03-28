({	
    onInit : function(component, event, helper) {
        var init = component.get('c.init');
        init.setParams({
            passedSessionId: component.get('v.sessionId'),
            domain: component.get('v.loopUrl')
        });
        init.setCallback(this, function(response) {
            if (response.getState() === 'SUCCESS') {
                var parsedResponse = JSON.parse(response.getReturnValue());
                //Don't check for isSuccess, because even if certain parts of the callout failed, we still want to load/initialize the parts that did succeed
                
                var services = parsedResponse.services;
                component.set('v.salesforceBaseUrl', parsedResponse.salesforceBaseUrl);
                component.set('v.isCustomizeApplication', parsedResponse.isCustomizeApplication);
                component.set('v.oAuthSettings', parsedResponse.oAuthSettings);
                component.set('v.services', services);
                component.set('v.orgSettings', parsedResponse.orgSettings);
                
                if (parsedResponse.orgSettings.hasContract) {
                    component.set('v.purchaseLabel', 'Upgrade');
                }
                
                if (!services.isSuccess) {
                    var errorEvent = component.getEvent('showError');
                    errorEvent.setParams({
                        message: services.errorMessage
                    });
                    errorEvent.fire();
                }
            }
            else {
                component.getEvent('showError').setParams({
                    message: 'An unexpected error has occurred. Please contact Drawloop Support if this error persists.'
                }).fire();
            }
            
            component.set('v.isLoading', false);
        });
        
        $A.enqueueAction(init);
    },
    toggle : function(component, event, helper) {
        var label = event.currentTarget.getAttribute('id');
        var iconDiv;
        var element = component.find(label + '-Node');
        if (label !== null && label.indexOf('-icon') > -1) {
            iconDiv = label;
        } else {
            iconDiv = label + '-icon'
        }
        var icon = component.find(iconDiv);
        $A.util.toggleClass(element, 'slds-collapsed');
        !$A.util.hasClass(element, 'slds-collapsed') ? $A.util.addClass(icon, 'icon-on') : $A.util.removeClass(icon, 'icon-on');
        component.set('v.onClickRenderDummy', !component.get('v.onClickRenderDummy'));
    },
    focused : function(component, event) {
    	var label = event.target.getAttribute('id');
    	$A.util.addClass(component.find(label), 'section-header');
	},
    blur : function(component, event) {
    	var label = event.target.getAttribute('id');
    	$A.util.removeClass(component.find(label), 'section-header');
	},
    click : function(component, event, helper) {
        component.set('v.alertText', '');
        component.set('v.disableSave', false);
        var id = event.currentTarget.id;
        var label = event.currentTarget.title;
        
        helper.changeStep(component, id);
        
        switch(id) {
            case 'basicButtons':
            case 'editionSection':
            case 'purchaseForm':
            case 'settings':
            case 'testUserConfiguration':
            case 'userPermissions':
            case 'sampleDdps':
                component.set('v.saveVisible', true);
                break;
            case 'ddpAdmin':
                component.set('v.saveVisible', false);
                helper.loadDdpAdminSplash(component, component.get('v.orgSettings'));
                break;
            default:
                component.set('v.saveVisible', false);
                break;
        }
        
        helper.updateSaveButtonText(component, id);
        helper.isSelected(component, id);
        helper.updateBreadcrumb(component, id, label);
    },
    search : function(component, event, helper) {
        helper.searchHelper(component);
    },
    save : function(component, event, helper) {
        component.set('v.alertText', '');
        component.set('v.busy', true);
        if (component.get('v.step') === 'editionSection') {
            var edition = component.find('editionComponent');
            edition.save();
        }
        else if (component.get('v.step') === 'testUserConfiguration') {
            var testUsers = component.find('setupTestUsers');
            testUsers.save();
        }
        else if (component.get('v.step') === 'userPermissions') {
            var setupUsers = component.find('setupUsers');
            setupUsers.save();
        }
        else if (component.get('v.step') === 'settings') {
            var settings = component.find('settingsStep');
            settings.save();
        }
        else if (component.get('v.step') === 'basicButtons') {
            var classicButtons = component.find('classicButtons');
            classicButtons.save();
        }
        else if (component.get('v.step') === 'sampleDdps') {
            var sampleDdps = component.find('sampleDdpsComponent');
            sampleDdps.save();
        }
        else if (component.get('v.step') === 'purchaseForm') {
            var purchaseForm = component.find('purchaseFormComponent');
            purchaseForm.submit();
        }
    },
    redirectButtons : function(component, event, helper) {
        var id = event.getParam('buttonName');

        helper.toggleBranch(component, id);
        component.set('v.step', id);
        helper.isSelected(component, id);

        component.set('v.saveVisible', id === 'basicButtons' || id === 'purchaseForm');

        helper.updateSaveButtonText(component, id);
        var label = component.find(id).getElement().title;
        helper.updateBreadcrumb(component, id, label);
    },
    actionComplete : function(component, event) {
        if (event.getParam('success')) {
            var successMessage = event.getParam('successMessage') ? event.getParam('successMessage') : 'Save successful!';
            component.set('v.alertText', successMessage);
        }
        component.set('v.busy', false);
    },
    showError : function(component, event, helper) {
        var errorPrompt = component.find('errorPrompt');
        var title = event.getParam('title');
        var message = event.getParam('message');
        
        if (errorPrompt.getElement().hidden) {
        	errorPrompt.showError(title, message);
        }
    },
    disableSave : function(component, event) {
        component.set('v.disableSave', true);
    },
    enableSave : function(component, event) {
        component.set('v.disableSave', false);
    },
    updateIsStandard : function(component, event) {
        component.set('v.services.isStandard', event.getParam('isStandard'));
    },
    handleActionEvent : function(component, event, helper) {
        var action = event.getParam('action');
        var serializedParams = event.getParam('params');
        
        switch (action) {
            case 'isLoading':
                component.set('v.isNavItemLoading', true);
                component.set('v.disableSave', false);
                break;
            case 'doneLoading':
                component.set('v.isNavItemLoading', false);
                if (serializedParams) {
                    var params = JSON.parse(serializedParams);
                    if (params.isAuthorized != null) {
                        component.set('v.disableSave', !params.isAuthorized);
                    }
                } else {
                    component.set('v.disableSave', false);
                }
                break;
            case 'authorized':
                //This case is only being used by ConfigureIntegrationsHelper. Anything related to OAuth should be using the AuthorizeLoopServices component
                component.set('v.disableSave', false);
                component.set('v.oAuthSettings.isAuthorized', true);
                break;
            case 'connectedAppsChanged':
                if (serializedParams) {
                    var params = JSON.parse(serializedParams);
                    component.set('v.orgSettings.isConnectedAppsEnabled', params.connectedAppsEnabled);
                }
                break;
            default:
                break;
        }
    }
})