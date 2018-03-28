({
    clearServices : function(component) {
        component.set("v.standardScheduledDdp", false);
        component.set("v.businessScheduledDdp", false);
        component.set("v.workflowDdp", false);
        component.set("v.componentLibrary", false);
        component.set("v.massDdp", false);
    },
    parseQueryString : function(qstr) {
        var query = {};
        qstr = qstr[0] === '?' ? qstr.substr(1) : qstr
        var a = qstr.split('&');
        for (var i = 0; i < a.length; i++) {
            var b = a[i].split('=');
            query[decodeURIComponent(b[0])] = decodeURIComponent(b[1] || '');
        }
        return query;
    },
    load : function(component) {
        var orgSettings = component.get('v.orgSettings');
        if (orgSettings.isSuccess) {
            component.set('v.isTrial', orgSettings.isTrial);
            component.set('v.isSandbox', orgSettings.isSandbox);
            component.set('v.hasContract', orgSettings.hasContract);
        } else {
            this.fireErrorEvent(component, orgSettings.errorMessage);
        }

        var services = component.get('v.services');
        if (services.isSuccess) {
            this.clearServices(component);
            
            if (component.get('v.isStandard')) {
                component.set('v.standardScheduledDdp', services.scheduledDdp);
            }
            else {
                component.set('v.businessScheduledDdp', services.scheduledDdp);
                component.set('v.workflowDdp', services.workflowApexDdp);
                component.set('v.componentLibrary', services.componentLibrary);
                component.set('v.massDdp', services.massDdp);
            }
        }
        else {
            this.fireErrorEvent(component, services.errorMessage);
        }
        
        if (orgSettings.hasContract && !orgSettings.isSandbox) {
            this.disableAll(component);
        }
    },
    disableAll : function(component) {
        component.set("v.disableAll", true);
        component.getEvent("disableSave").fire();
    },
    fireErrorEvent : function(component, message) {
        component.getEvent('showError').setParams({
            message: message
        }).fire();
    }
})