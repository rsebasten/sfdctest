/*******************************************************************************
(C)2016
Author: krishnaveni duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  This class returns the Threatsdropdown values for BA Threats Master.
 ********************************************************************************/
@RestResource(urlMapping = '/OthersDropdowns/*')
global class CtrlOthersDropdownsService{
 
@HttpPost
global static CtrlKevlarSvcHelper.ReturnOtherDropDownClass doPost() {
    CtrlKevlarSvcHelper h = new CtrlKevlarSvcHelper();
     RestRequest req = RestContext.request;
    List<String> flammabilityStandard= new List<String>();
    List<String> panelFlexibilityReference = new List<String>();
    List<String> testLaboratory = new List<String>();
    List<String> standardNames= new List<String>();
    List<List<String>> defaultDropdownList = new List<List<String>>();
    List<String> informationTechList = new List<String>();
    
    try{
        system.debug('req.requestBody : ' + req.requestBody.toString());    
        Schema.DescribeFieldResult ft = Functional_Design_Requirement__c.Flammability_Tests__c.getDescribe();    
        List<Schema.PicklistEntry> f = ft.getPicklistValues(); 
        for(Integer i=0;i<f.size();i++)
        {
             flammabilityStandard.add(f[i].getvalue());   
        }
        defaultDropdownList.add(flammabilityStandard);     
        
        Schema.DescribeFieldResult pfr = Functional_Design_Requirement__c.Panel_Flexibility_Reference__c.getDescribe();    
        List<Schema.PicklistEntry> pr = pfr.getPicklistValues(); 
        for(Integer i=0;i<pr.size();i++)
        {
             panelFlexibilityReference.add(pr[i].getvalue());   
        }
        defaultDropdownList.add(panelFlexibilityReference);  
        
         Schema.DescribeFieldResult tpts = Functional_Design_Requirement__c.Third_party_testing_standards__c.getDescribe();    
        List<Schema.PicklistEntry> ts = tpts.getPicklistValues(); 
        for(Integer i=0;i<ts.size();i++)
        {
             testLaboratory.add(ts[i].getvalue());   
        }
        defaultDropdownList.add(testLaboratory);  
        
         Schema.DescribeFieldResult nlabs = Functional_Design_Requirement__c.StandardName__c.getDescribe();    
        List<Schema.PicklistEntry> nl = nlabs.getPicklistValues(); 
        for(Integer i=0;i<nl.size();i++)
        {
             standardNames.add(nl[i].getvalue());   
        }
        defaultDropdownList.add(standardNames);  
        
        Schema.DescribeFieldResult sourceOfIT = BA_Configuration__c.Source_of_IT__c.getDescribe();    
        List<Schema.PicklistEntry> informationTechnology = sourceOfIT.getPicklistValues(); 
        for(Integer i=0;i<informationTechnology.size();i++)
        {
             informationTechList.add(informationTechnology[i].getvalue());   
        }
        
     
       if(!defaultDropdownList.isEmpty()){
           return new CtrlKevlarSvcHelper.ReturnOtherDropDownClass(h.dataSent, h.getMessage('200'),h.getResponseMessage('523'),'523',flammabilityStandard, panelFlexibilityReference,testLaboratory,standardNames,informationTechList, null, 'No Error');
        }
        else{       
            return new CtrlKevlarSvcHelper.ReturnOtherDropDownClass(h.dataNotSent, h.getMessage('201'),null,null,null,null,null,null,null,null, '201');
        }   
            
    }
    catch(Exception e){
        System.debug('Error----------'+e.getMessage());
        return new CtrlKevlarSvcHelper.ReturnOtherDropDownClass(h.dataNotSent, h.getMessage('203'),'Data loading failed!',null,null, null,null,null,null,null, '201');
       
    }           
     
    }
    
}