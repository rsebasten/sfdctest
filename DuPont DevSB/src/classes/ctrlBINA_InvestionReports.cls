/////////////////////////////////////////////////////////////////////////////////////////////////////////
//Copyright © 2014 DuPont. All rights reserved. 
//Name :ctrlBINA_InvestionReports 
//Author :Rajiv Kumar Bhatter<Rajiv_Bhatter@infosys.com>, Sanjay Nandi<Sanjay_Nandi@infosys.com>
//Description: This class is getting used in BI_NA_WrapFieldInvestigationReport,BI_NA_FlashingFieldInvestigationReport,BI_NA_RoofLinerFieldInvestigationReport VF Page
//This class allows user to create a New Case record
//************************************<MG-20140827>***************************************************//

public with sharing class ctrlBINA_InvestionReports {
    public string CurrentCaseID;
    public String address {get;set;}
    public entitlement ent {get;set;}
    public case currentcase{get;set;}
    public string caldingType {get;set;}
    public string SheathingType {get;set;}
    public string framing{get;set;}

public ctrlBINA_InvestionReports(ApexPages.StandardController controller) {
    CurrentCaseID=ApexPages.currentPage().getParameters().get('id');
    system.debug('*********the current page id is '+CurrentCaseID);
    currentcase = [select CreatedDate,id,EntitlementId,Submitted_By_First_Name_Last_Name__c,CaseNumber,Case_Shipping_Address__c,Alt_Phone__c,Problem_Description__c,Description,Date_Entered__c,Site_Address__c from case where id = :CurrentCaseID ];
    system.debug('*******queried case'+currentcase);    
    address=currentcase.Case_Shipping_Address__c+'\n'+currentcase.Alt_Phone__c;
    system.debug('*****address'+address);    
    script();
    }
//////////////////////////////////////////
    /* Function Description
    Name :script 
    Return Type: void
    Description:This function returns the script Answers entered
    */    
public void script (){

    ent = [select id from entitlement where ID=:currentcase.EntitlementId];
    String entitlementid= ent.id;
    system.debug('the entitlement is '+ent);
    String scriptHeaderId= ([Select id from SFDC_Script_Header__c where Entitlement__r.id =:entitlementId  and (Script__r.name='Project Information - Product Only' or Script__r.name='Project Information')] ).id;
    system.debug('the current id is '+scriptHeaderId);
    list<SFDC_Script_Result__c> sr = new list<SFDC_Script_Result__c>([select Question__c, Answer__c, id from SFDC_Script_Result__c where Script_Result__c=:scriptHeaderId]);
    system.debug('the result is '+sr );
    for( SFDC_Script_Result__c s :sr){
        if(s.Question__c.contains('Wall Cladding Type'))
            caldingType = s.answer__c;
        if(s.Question__c.contains('Sheathing Type'))
            SheathingType =  s.answer__c;
        if(s.Question__c.contains('Framing Type'))
            framing=s.answer__c;
        }
    }
}