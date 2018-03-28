/*******************************************************************************
Copyright © 2010 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Controller for page: script.page
********************************************************************************/
public with sharing class ctrlScript {

    public SiteScript script                    {set; get;}

    public PageReference init() {
        string scriptid=ApexPages.currentPage().getParameters().get('id');
        string headerid=ApexPages.currentPage().getParameters().get('sh');
        script = new SiteScript(scriptid, headerid);
        system.debug(script);
        return null;
    }

    public PageReference cancel() {
        return script.returnPageReference();
    }
    
    public PageReference Save() {
        if (script.validate()) {

            system.debug('script: '+script);
            //1.  WriteTo Object using with sharing to disallow writing
            //      to records/objects not in users scope
                    if (script.writeToType!=null) {
                        sobject so = script.getWriteToObject();
                        system.debug('getWriteToObject: '+so);
                        if (so!=null) {
                            script.writeTo(so,true);
                            system.debug('getWriteToObject.after_writeTo: '+so);
                            upsert so;

                            //add the writeToObject.Id back to the questions this is need to allows
                            // for script continuation on a newly created writeToObject
                            if (so.id !=null && script.WriteToIdQuestion !=null)
                                script.WriteToIdQuestion.answer=so.id;
                        }
                    }

            //2.  Save Header and Results
            script.SaveScriptAndHeader();
            return script.returnPageReference();
        }
        return null;

    }
    
public static testMethod void test_ctrlScript() {
    
        geoValidation.DisableGeoValidationOverride=true;
        SFDC_Script__c SFDCScript  = new SFDC_Script__c();
        SFDCScript.Name = 'Test';
        SFDCScript.WriteToObject__c = 'SFDC_Script__c';
        insert SFDCScript;
        
        Account acc = new Account(name='TestCo');
        insert acc;
        SFDC_Script_Header__c SFDCSH = new SFDC_Script_Header__c();
        SFDCSH.Account__c = acc.id;
        SFDCSH.Name = 'test';
        insert SFDCSH;
        Test.startTest();
        ApexPages.currentPage().getParameters().put('Id',SFDCScript.id);
        ApexPages.currentPage().getParameters().put('Sh',SFDCSH.id);
        ctrlScript controller = new ctrlScript();
        controller.init();
        controller.Save();
        controller.Cancel();
        Test.stopTest();
    
    }   
    
}