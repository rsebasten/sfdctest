/******************************************************************
Modified by <Anup08-05-2015>
Modification: Passing the CRM It Record ID in The URL, This Id helps in Retriving the name of the CRM IT Project,
which indeed is mapped with the corresponding Field id to prepopulate the field "Related Project" of SFAR Object
*******************************************************************/
public class ctrlResetPassword {
    public String retURL{get;set;}
    ////////<Anup08-05-15>New fields for getting CRM IT Project details/////////////////
    Public String currentCRMId{get;set;}
    Public String currentCRMProjectName{get;set;}
    Public CRM_IT_Project__c crm{get;set;}
    Public String currentIssueId{get;set;}
    Public String currentIssueName{get;set;}
    Public Issue__c issue{get;set;}
    
    public String SFARRecordType{
                    get{return String.valueOf(Schema.Sobjecttype.SFDC_Access_Request__c.getRecordTypeInfosByName().get('SFAR - Password Reset').getRecordTypeId()).substring(0,18);
                        }}
    public String RTypeSelected{get;set;}
    
    SFDC_Access_Request__c t;
    ApexPages.StandardController controller;
    
    public ctrlResetPassword(ApexPages.StandardController controller) {
        this.controller = controller;
        t = (SFDC_Access_Request__c) Controller.getRecord();
        
    }
    public list<SelectOption> getRecordTypes() {
        list<SelectOption> options = new list<SelectOption>();
        for (list<RecordType> rts : [SELECT ID, name FROM RecordType WHERE SObjectType = 'SFDC_Access_Request__c' ORDER BY name]) {
            for (RecordType rt : rts) {
                options.add(new SelectOption(rt.ID, rt.Name));
            } 
        }
        return options;
    }
   
   /*  @RemoteAction
    global static pageReference redirect1(string ab){
    pagereference pg = new PageReference('/a3C/e'); 
    pg.setRedirect(true);
    return pg ;
    }*/

    public pageReference redirect(){
    
        retURL = '/apex/resetPassword';
        PageReference pageRef = new PageReference('/a3C/e');
        
        //[20170102] Merge&Spin: Used custom settings to store field ID and remove hardcoding
        Object_Field_ID_Mapping__c objectFieldID = Object_Field_ID_Mapping__c.getInstance('SFDC Access Request_Related_Project');     
        
        ////////////////////////////// Start of Modification <Anup08-05-15>//////////////////////
        if(ApexPages.currentPage().getParameters().get(objectFieldID.Field_ID__c+'_lkid')!=null){ //Here 'CF00N3000000669QX_lkid' is a value which represents id of CRM record in URL
        currentCRMId=String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(objectFieldID.Field_ID__c+'_lkid')); // Assigning the Id
        if(currentCRMId!=null){
        crm=[SELECT name FROM CRM_IT_Project__c where id=:currentCRMId];
        currentCRMProjectName=crm.name;
        pageRef.getParameters().put(objectFieldID.Field_ID__c,currentCRMProjectName); // Here 'CF00N3000000669QX' represents the field  "Related Project" in URL, Passing the value via URL
        }
        }
        
        //[20170102] Merge&Spin: Used custom settings to store field ID and remove hardcoding
        Object_Field_ID_Mapping__c objectFieldID2 = Object_Field_ID_Mapping__c.getInstance('SFDC Access Request_Related_Issue'); 
        
        //////////////for Issues/////////////////
        if(ApexPages.currentPage().getParameters().get(objectFieldID2.Field_ID__c+'_lkid')!=null){ //Here 'CF00Na000000B3Idr_lkid' is a value which represents id of Issue record in URL
        currentCRMId=String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(objectFieldID2.Field_ID__c+'_lkid')); // Assigning the Id
        if(currentCRMId!=null){
        issue=[SELECT name FROM issue__c where id=:currentCRMId];
        currentIssueName=issue.name;
        pageRef.getParameters().put(objectFieldID2.Field_ID__c,currentIssueName); // Here 'CF00Na000000B3Idr' represents the field  "Related Issue" in URL, Passing the value via URL
        }
        }
        ////////////////////////////////End of modifications <Anup08-05-15>////////////////////////////////
        pageRef.getParameters().put('nooverride','1');
        pageRef.getParameters().put('RecordType',RTypeSelected);
        pageRef.getParameters().put('retURL',retURL);
        pageRef.setRedirect(true);
        return pageRef;
    }
}