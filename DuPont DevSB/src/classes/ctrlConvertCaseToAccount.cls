//<SA20180310> Removed the hardoced references as part of the issue IS ID-00084379 
public class ctrlConvertCaseToAccount {
     List<Case_Details__c> lstCaseDetails{get;set;}
     public String selectedChoice { get; set; }
     public String searchText  {get; set;}
     public List<Account> accList { get; set; }
     public List<Case> caseList { get; set; }
     public boolean showNoRecords{get;set;}
    
       public ctrlConvertCaseToAccount(){
           caseList = [Select id,account.name, Country__c from case where id =:ApexPages.currentPage().getParameters().get('id') limit 1];
           if(!caseList.isEmpty()&& caseList.size()>0){
              lstCaseDetails=[select id, name, Company__c, Email__c, Address__c, City__c, State__c, Zip_Postal_Code__c, Target_Country__c, Website__c, Phone__c, Fax__c from Case_Details__c WHERE Related_Case__c =:caseList[0].id limit 1]; 
              if(lstCaseDetails!=null && lstCaseDetails.size()>0)
              searchText = lstCaseDetails[0].Company__c;
     
           }
       }
       public PageReference redirect() {
        String id = ApexPages.currentPage().getParameters().get('id');
        boolean flag = true;
        PageReference newocp;
        if(selectedChoice!='' && selectedChoice=='Create new Account' ){
            String BaseURL= URL.getSalesforceBaseUrl().toExternalForm(); // <SA20180310> deleted the commented HardCoded URL
            String PageURL = ApexPages.currentPage().getUrl();
            String ActualURL= BaseURL + PageURL.subString(0,PageURL.indexOf('?')+1) +'id='+ id;
           
            system.debug('ConvertCaseToAccount==='+ActualURL);
            //[20170102] Merge&Spin: Used custom settings to store field ID and remove hardcoding
            Object_Field_ID_Mapping__c objectFieldID = Object_Field_ID_Mapping__c.getInstance('Account_Country');     
        
            string urlstring='/setup/ui/recordtypeselect.jsp?ent=Account&save_new_url=/001/e&retURL='+ActualURL;
            if(lstCaseDetails!=null && lstCaseDetails.size()>0){
                if(lstCaseDetails[0].Company__c!=null && !String.Isblank(lstCaseDetails[0].Company__c))   
                    urlstring+='&acc2='+lstCaseDetails[0].Company__c;
                if(lstCaseDetails[0].Address__c!=null && !String.Isblank(lstCaseDetails[0].Address__c))   
                    urlstring+='&acc17street='+lstCaseDetails[0].Address__c;
                if(lstCaseDetails[0].City__c!=null && !String.Isblank(lstCaseDetails[0].City__c))   
                    urlstring+='&acc17city='+lstCaseDetails[0].City__c;
                if(lstCaseDetails[0].State__c!=null && !String.Isblank(lstCaseDetails[0].State__c))   
                    urlstring+='&acc17state='+lstCaseDetails[0].State__c;
                if(lstCaseDetails[0].Zip_Postal_Code__c!=null && !String.Isblank(lstCaseDetails[0].Zip_Postal_Code__c))   
                    urlstring+='&acc17zip='+lstCaseDetails[0].Zip_Postal_Code__c;
                if(lstCaseDetails[0].Target_Country__c!=null && !String.Isblank(lstCaseDetails[0].Target_Country__c))   
                    urlstring+='&'+objectFieldID.Field_ID__c+'='+lstCaseDetails[0].Target_Country__c;
                if(lstCaseDetails[0].Website__c!=null && !String.Isblank(lstCaseDetails[0].Website__c))   
                    urlstring+='&acc12='+lstCaseDetails[0].Website__c;
                if(lstCaseDetails[0].Phone__c!=null && !String.Isblank(lstCaseDetails[0].Phone__c))   
                    urlstring+='&acc10='+lstCaseDetails[0].Phone__c;
                if(lstCaseDetails[0].Fax__c!=null && !String.Isblank(lstCaseDetails[0].Fax__c))   
                    urlstring+='&acc11='+lstCaseDetails[0].Fax__c;
            
            }
            newocp= new PageReference(urlstring);
            newocp.setRedirect(true);
            return newocp;
         }else if(selectedChoice!='' && selectedChoice=='Use existing Account'){

          if(searchText!=null && !String.IsBlank(searchText)){
              searchAccount();
              showNoRecords=true;
          }else{
              showNoRecords=false;
          }

        }
        
        return null;
    }
    public PageReference searchAccount() {
        accList=new List<Account>();
        if(searchText!=null && searchText!='')
          {
              string queryString = searchText+'%';
              accList = [Select id, name, ERP_Company_Code__c, ShippingStreet, ShippingCity, ShippingState, ShippingCountry from Account where name like :queryString limit 1000];
          }
        return null;
    }

    
    
    
}