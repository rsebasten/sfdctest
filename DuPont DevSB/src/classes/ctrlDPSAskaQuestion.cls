/*******************************************************************************
Copyright © 2016 DuPont. All rights reserved.
Author: Tabrez Ansari
Email: tabrez.ansari@tcs.com
Description:  This controller is used for capturing the Lead created as query on Ask a Question tab.
Created Date: 10/6/2016
Version: 1.0
********************************************************************************/

public with sharing class ctrlDPSAskaQuestion {
    // Initialize Variables
    public Lead objLead { get; set; }
    public String txtfName { get; set; }
    public String txtlName { get; set; }
    public String txtCompany { get; set; }
    public String txtEmail { get; set; }
    public String txtPhone { get; set; }
    public String txtMobile { get; set; }
    public String txtLeadCountry { get; set; }
    public String txttype { get; set; }
    public String txtDescription { get; set; }
    public boolean bolCheckbox { get; set; }
    
    public String successMsg;
    public String errorMsg;
    public Id srchCritId { get; set; }
    
    /* Function Description
    Name : ctrlDPSAskaQuestion
    Return Type: void
    Description: It is the constructor method     
    */
    public ctrlDPSAskaQuestion(ApexPages.StandardController controller) {
        txtLeadCountry ='--- None ---';
        blankValues();
        objLead = new Lead();
        
        successMsg = Label.LeadSuccessMsg;
        errorMsg = Label.LeadErrorMsg;
        srchCritId = apexpages.currentpage().getparameters().get('strId');
    }
    
    /* Function Description
    Name : blankValues
    Return Type: void
    Description: This function is used for autopopulating the values from the contact & user information.
    */ 
    public void blankValues(){
        try{
            txtfName = UserInfo.getFirstName();
            txtlName = UserInfo.getLastName();
            txtEmail = UserInfo.getUserEmail();
            User usr = [select id, ContactId, name from User where id =: UserInfo.getUserId()];
            List<Contact> lsobjcon = new List<Contact>();
            Contact objcon = new Contact();
            lsobjcon = [select id, name, MailingCountry, Contact_Country__c, Account.Name, Phone, MobilePhone from Contact where id =: usr.ContactId limit 1];
            if(lsobjcon.size() > 0){
                System.debug(lsobjcon[0].Contact_Country__c);
                map<String,String> mapexisting=new Map<String,String>();
                
                mapexisting.put(lsobjcon[0].Contact_Country__c,'Contact_Country__c');
                Map<String,String> convertedmapFieldVal=new Map<String,String>();
                convertedmapFieldVal=convertCountry(mapexisting); 
                txtLeadCountry =convertedmapFieldVal.get('Contact_Country__c');
                txtCompany = lsobjcon[0].Account.Name;
                txtPhone = lsobjcon[0].Phone;
                txtMobile = lsobjcon[0].MobilePhone;
            }
            
            System.debug(txtLeadCountry );
            txttype = '';
            txtDescription = '';
            bolCheckbox = false;
        }
        catch(Exception e){
            System.debug(e);
        }
    }

    /* Function Description
    Name : createLead
    Return Type: void
    Description: This function is used for creating Lead with the values provided & with few default values.
    */ 
    public void createLead(){
        try{
            if((txtfName == null || txtfName == '') || (txtlName == null || txtlName =='') || (txtCompany == null || txtCompany == '') || (txtemail == null || txtemail == '') ||
                (txtLeadCountry == null || txtLeadCountry == '') || (txttype == null || txttype == '')){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMsg));
            }
            else{
                objLead.FirstName = txtfName;
                objLead.LastName = txtlName;
                objLead.Company = txtCompany;
                objLead.Email = txtemail;
                objLead.Phone = txtPhone;
                objLead.MobilePhone = txtMobile;
                objLead.Lead_Country__c = txtLeadCountry;
                objLead.Type__c = txttype;
                objLead.Description = txtDescription;
                objLead.Opt_In__c = bolCheckbox;
                Id LeadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get(Label.DPS_Lead_Record_Type).getRecordTypeId();
                if(LeadRecordTypeId != null)
                    objLead.RecordTypeId = LeadRecordTypeId;
                objLead.Owning_Organization__c = Label.DPS_Owning_Organization;
                objLead.Owning_SBU__c = Label.DPS_Owning_SBU;
                objLead.KV_DPS_Segment__c = Label.DPS_Segment;
                objLead.KV_DPS_SubSegment__c = Label.DPS_Sub_Segment;
                objLead.Origin_Channel_Type__c = Label.DPS_Origin_Channel_Type;
                objLead.Origin_Name__c = Label.DPS_Origin_Name;
                if(srchCritId != null)
                    objLead.KV_Search_Criteria__c = srchCritId;
                
                Database.DMLOptions dmo = new Database.DMLOptions();
                dmo.assignmentRuleHeader.useDefaultRule = true;
                objLead.setOptions(dmo);
    
                insert objLead;
                
                if(objLead.Opt_In__c == true){
                    cls_AssignCampaignId.assignCampId(objLead.Id);
                }
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,successMsg));
                blankValues();
            }
        }
        catch(Exception e) {
            System.debug(e);
        }
    }

    /* Function Description
    Name : convertCountry
    Return Type: Map
    Description: This function is used for changing the country name from Capital to Camel Case.
    */ 
    public MAP<String,String> convertCountry(Map<String,String> mapFieldVal)
    {   Map<String,String> mapConvertedCountry=new Map<String,String>();
        String originalCountry='';
        for(String str: mapFieldVal.keyset()){
        String convertedStr='';
        String firstpart='';
        originalCountry=str;
        List<String> lsconverted=new List<String>();
        for(Integer i=0; i<str.length() ;i++){
                str=str.toLowercase();
                if(str.substring(i,i+1).isAlpha()){
                    if(i==0){
                        firstpart=str.substring(0,i+1).toUpperCase();
                        convertedStr=firstpart;
                    }
                    else if(!str.substring(i-1,i).isAlpha()){
                        firstpart=str.substring(i,i+1).toUpperCase();
                        convertedStr=convertedStr+firstpart;
                    }
                    else{
                        convertedStr=convertedStr +  str.substring(i,i+1);
                    }
                }
                else{
                    convertedStr=convertedStr +  str.substring(i,i+1);
                }
                
        }
        lsconverted.add(convertedStr);
        mapConvertedCountry.put(mapFieldVal.get(originalCountry),convertedStr);
        }
        return mapConvertedCountry;
    }
    
    /* Function Description
    Name : submitLead
    Return Type: PageReference
    Description: This function is used to redirect the ask a question page back on the same page.
    */ 
    public PageReference submitLead()
    {
        createLead();
        PageReference pg = new PageReference('/apex/panelDPSAskAQuestion');
        pg.setRedirect(true);
        objLead = new Lead();
        return null;
    }
    
    /* Function Description
    Name : getcountryOptions
    Return Type: List
    Description: This function is used to redirect the ask a question page back on the same page.
    */
    public List<SelectOption> getcountryOptions()    
    {   if(txtLeadCountry == null || txtLeadCountry == '')
            txtLeadCountry ='--- None ---';
        List<SelectOption> options =  new List<SelectOption>();    
        options.add(new selectOption(txtLeadCountry ,txtLeadCountry ));
        Schema.DescribeFieldResult fieldResult = Contact.Contact_Country__c.getDescribe();    
        List<Schema.picklistEntry> ple = fieldResult.getPicklistValues();  
        Map<String,String> mapFieldVal=new Map<String,String>();  
        Map<String,String> convertedmapFieldVal=new Map<String,String>();  
        for(Schema.picklistEntry f:ple)    
        {   
            mapFieldVal.put(f.getValue(),f.getLabel());
        } 
        convertedmapFieldVal=convertCountry(mapFieldVal); 
        for(String s: convertedmapFieldVal.keyset()){
            options.add(new selectOption(s,convertedmapFieldVal.get(s)));  
        }  
        return Options;    
    }      
}