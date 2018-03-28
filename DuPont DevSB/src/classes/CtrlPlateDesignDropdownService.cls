/*******************************************************************************
(C)2015
Author: krishnaveni duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  This class returns the Plate Design for Back Front and Side dropdown values for BAC.
 ********************************************************************************/

@RestResource(urlMapping = '/PlateDesign/*')
global class CtrlPlateDesignDropdownService{

@HttpPost
global static CtrlKevlarSvcHelper.ReturnDesignClass doPost() {
    CtrlKevlarSvcHelper h = new CtrlKevlarSvcHelper();
    List<String> bpList = new List<String>();
    List<String> fpList = new List<String>();
    List<String> spList = new List<String>();
    List<List<String>> pList = new List<List<String>>();
    RestRequest req = RestContext.request;
    try{
        system.debug('req.requestBody : ' + req.requestBody.toString());
        Schema.DescribeFieldResult bpPlates = Functional_Design_Requirement__c.Plate_Design_of_BP__c.getDescribe();    
        List<Schema.PicklistEntry> bp = bpPlates.getPicklistValues(); 
        Schema.DescribeFieldResult ftPlates = Functional_Design_Requirement__c.Plate_Design_of_front_plate__c.getDescribe();    
        List<Schema.PicklistEntry> ft = ftPlates.getPicklistValues(); 
        Schema.DescribeFieldResult spPlates = Functional_Design_Requirement__c.Plate_Design_of_SP__c.getDescribe();    
        List<Schema.PicklistEntry> sp = spPlates.getPicklistValues();  
        for(Integer i=0;i<bp.size();i++)
        {
            bpList.add(bp[i].getvalue());   
        }  
        pList.add(bpList);       
        for(Integer i=0;i<ft.size();i++)
        {
            fpList.add(ft[i].getvalue());   
        } 
        pList.add(fpList);   
        for(Integer i=0;i<sp.size();i++)
        {
            spList.add(sp[i].getvalue());   
        }
        pList.add(spList);  

        if(!pList.isEmpty()){
            return new CtrlKevlarSvcHelper.ReturnDesignClass(h.dataSent, h.getMessage('200'),h.getResponseMessage('516'),'516',bpList, fpList, spList, null, 'No Error');
        }
        else{       
            return new CtrlKevlarSvcHelper.ReturnDesignClass(h.dataNotSent, h.getMessage('201'),null,null, null,null,null, null, '201');
        }   
    }
    catch(Exception e){
        System.debug('Error----------'+e.getMessage());
        //return e.getMessage();
        return new CtrlKevlarSvcHelper.ReturnDesignClass(h.dataNotSent, h.getMessage('203'),'Data loading failed!',null, null,null,null, null, '203');
    }  
} 
}