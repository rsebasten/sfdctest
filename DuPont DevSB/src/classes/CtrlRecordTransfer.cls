/*******************************************************************************
(C)2016
Author: krishnaveni duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  This class VF page to transfer ownership of records
 ********************************************************************************/

public without sharing class CtrlRecordTransfer {

   
    public Issue__c u {get;set;}
    public String TransferFrom {get;set;}
    public string query;
    public string test;
    public String userName;
    public Integer SuccCount;
    public Integer ErrorCount;
    Public List<User> result;
    public List<messageWrapper> lstMsgWrapperSuccess{get;set;}
    public List<messageWrapper> lstMsgWrapperError{get;set;}
    
    public String xlsHeader{
        get{
            String strHeader = '';
            strHeader += '<?xml version="1.0"?>';
            strHeader += '<?mso-application progid="Excel.Sheet"?>';
            return strHeader;
        } 
    }
    
    //public Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
    public String selectedObject { get; set; }
    
    
     public CtrlRecordTransfer() {
         u=new Issue__c();
         lstMsgWrapperError=new List<messageWrapper>(); 
          lstMsgWrapperSuccess=new List<messageWrapper>();           
              getObjectNames();
    }

    public List<SelectOption> getObjectNames() {
        List<SelectOption> options = new List<SelectOption>();        
       
        for(Record_Transfer_Objects__c setting : Record_Transfer_Objects__c.getAll().values()){
            options.add(new SelectOption(setting.API_Name__c, setting.name));         
        } 
        options.add(new SelectOption('--None--','--None--'));
        options.sort();
        system.debug('options::'+options);
        return options;
    }

  
    public pagereference TransferOfRecords(){
         
        if(string.isBlank(TransferFrom)){
            String message = 'Current Record Owner userName should not be blank';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,message));
            return null;
        }
        String  s = '\'%'+TransferFrom.trim()+'%\'';
        test = 'select Id from User where username like '+s;
        result = Database.query(test);
        if(selectedObject == '--None--'){
            String message = 'Please Select the Applicable Object from dropdown.';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,message));return null;
        }
        
        if(result==null|| result.size()==0){
            String message = 'No user with userName: '+TransferFrom;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,message));return null;
        }
        if(result.size()>1){
            String message = 'There are more than one users with this username: '+TransferFrom;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,message));
            return null;
        }
        
        lstMsgWrapperError=new List<messageWrapper>(); 
          lstMsgWrapperSuccess=new List<messageWrapper>();
          
        query = 'select ownerId from '+selectedObject+' where ownerId='+'\''+result[0].id+'\'';        
        List<sObject> records = recordsOwnedByUser(query);
        if(records.size()>0 && u.RelatedUser__c != null){
            changeOwnerShip(records);
        }        
        else if (u.RelatedUser__c == null){
            String message = 'New Record Owner user should not be blank.';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,message));
        }
        else if(records.size() == 0){
             String message = 'No Records found for selected object for the given User.';
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,message));
         }
        return null;
    }       
    public list<sObject> recordsOwnedByUser(String query){
        List<sObject> newrecords = new list<sObject>();
        try{
            newrecords= Database.query(query);  
        }
        catch(exception e){
            String message = 'No Records Found';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,message));
        }
        return newrecords;
    }                   
    
    public void changeOwnerShip(List<sObject> records){ 
         List<sObject> sobListfin = new List<sObject>();             
         
         for(sObject sob: records){
             sob.put('ownerid',u.RelatedUser__c);
             sobListfin.add(sob);
         }
         if(result[0].Id == u.RelatedUser__c){
             String message = 'New Record Owner and Current Record Owner should not be same';
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,message));
         }
        if(sobListfin.size()>0&&(result[0].Id!=u.RelatedUser__c)){
            List<Database.SaveResult> updateResults = Database.update(sobListfin, false);
            SuccCount=0;
            ErrorCount=0;
            String message,message1 ='';
            list<string> ErorRecIds = new list<string>();                           
            for(Integer i=0;i<updateResults.size();i++){
                messageWrapper m;
                if (updateResults.get(i).isSuccess()){
                    SuccCount++;
                    m=new messageWrapper(updateResults.get(i).getId(), 'Item updated' );
                    lstMsgWrapperSuccess.add(m);
                }
                else if (!updateResults.get(i).isSuccess()){
                    ErrorCount++;  
                    Database.Error error = updateResults.get(i).getErrors()[0];
                    ErorRecIds.add(sobListfin.get(i).Id+' --->'+error.getMessage()+'<br/>');
                    m=new messageWrapper(sobListfin.get(i).Id, error.getMessage() );
                    lstMsgWrapperError.add(m);
                } 
                           
            }
            if (ErrorCount > 0){
                message1= 'Total <b>'+ ErrorCount +'</b> records out of <b>'+updateResults.size()+'</b> are not transferred due to some error. Please click on <b>Export Results</b> button to download Result details. <br/>';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,message1));
            }
            if(SuccCount > 0){
                     message='Total <b>'+ SuccCount +'</b> records out of <b>'+updateResults.size()+'</b> are transferred successfully. Please click on <b>Export Results</b> button to download Result details.';
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,message));
            }
        }
        if(sobListfin.size()== 0){
            String message = 'No Records found for the selected User.';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,message));
        }          
    } 
    
    public class messageWrapper{
        public string id {get;set;}
        public string msg{get;set;}
        
        public messageWrapper(string id, string msg){
            this.id=id;
            this.msg=msg;
        }
    
    }
    
    public Pagereference exportResults(){
    return new Pagereference('/apex/dataloadSuccessError');
 
 
}
    
    
}