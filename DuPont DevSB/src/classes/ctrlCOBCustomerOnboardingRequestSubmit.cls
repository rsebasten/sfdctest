/*******************************************************************************
Copyright © 2015 DuPont. All rights reserved. 
Author: Ankur Madaan
Email: ankur_madaan@infosys.com
Description:  Controller for Submit Button: This Controller will be called 
              when Submit is done from Customer data Request record Detail page.
 Change History :  Alvin Johnson (alvin_johnson@infosys.com) Added code for R02 Enhancement  
                     //<Alvin24082015>  
                : <Nishanth.H 15092015> Added for R02 enhancement-Updating selling company code value('1131 - DuPont (Shanghai) Sourcing Center Company, Ltd.')  
                : <Alvin20150929> Added for R02 enhancement to replace selling company codes with business Rules 
                : <BA15062016> Added Iscreditapproved condition to skip the credit if it is previously approved
                : <Santhosh 20160706> Added new country checks (IS ID-00070867)
                : <Bhargavi 20160919> Added new country Check (IS ID-00072470)
                : <Bhargavi 20161110> Bypasses Destination Credit Approval for all the countries (IS ID-00076243)
 ********************************************************************************/ 

global class ctrlCOBCustomerOnboardingRequestSubmit{

    //Declare Global Variable..
    global class InitVar{
        //Fetch RecordTypes...
        Webservice string Miscellaneous_COB_RTYPE = Rtype.getIdByDevName('Customer_Data_Request__c','Miscellaneous_customer_data_request'); 
        Webservice string Partner_COB_RTYPE = Rtype.getIdByDevName('Customer_Data_Request__c','Create_partner_function_Link_Contact_Link_Existing_Partner');
        Webservice string NewCustomerCreation_COB_RTYPE = Rtype.getIdByDevName('Customer_Data_Request__c','New_Customer_Creation'); 
        Webservice string ExtendExisting_COB_RTYPE = Rtype.getIdByDevName('Customer_Data_Request__c','Extend_Existing_Customer'); 
        Webservice string ModifyExisting_COB_RTYPE = Rtype.getIdByDevName('Customer_Data_Request__c','Modify_Existing_Customer_Data');
        Webservice string CompanyCodeCountry_Rule_Rtype = Rtype.getIdByDevName('Business_Rules__c','Country_Selling_Company_Code_Rules'); //<Alvin20150929> Added for R02 enhancement to replace selling company codes with business Rules 

    }   

    /**
     * Name: DirectSubmit
     * Params: ReqId-Id of the record, 
              RecordTypeId- RecordTypeId of the record.
              var- variable for global class InitVar
     * Description: Method will be called from the submit Button.  
     */

    Webservice static string DirectSubmit(String ReqId, String RecordTypeId,InitVar var){
        String result='';
        String Msg='';
        String accessMsg='';
        var = new InitVar();
        String ProfileName = currentUserProfile();
        if(ReqId!=null){
            Customer_Data_Request__c OnboardingReq = getRequestInformation(ReqId);
            if(OnboardingReq!=null){
                try{
                    Msg=RequestFlow(OnboardingReq,RecordTypeId,var);
                    accessMsg = accessCheck(ReqId,ProfileName);
                    if(Msg=='Success' && accessMsg == 'Success'){
                        update OnboardingReq;
                        result='Success';
                    }else if(Msg!='Success') {
                        result='Failed : ' + Msg;
                    }
                    else{
                        result='Failed : ' + accessMsg;
                    }
                }
                catch(exception e1){
                    result='Failed : '+ e1;
                    return result; 
                }
            }
            return result;      
        }
        return null;
    }

    /**
     * Name: RelatedlistItemsValidation
     * Params: OnboardingReq- Customer Data Request Record Id
     * Description: Method will be called for validation check on related list items of the record like Customer data Request Line Item,Contact.   
     */
    Webservice static String RelatedlistItemsValidation(Customer_Data_Request__c OnboardingReq){
        String ErrorMsg='Success';
        InitVar var = new InitVar() ;
        list<Attachment> Lst_Attachments= new List<Attachment>();
        list<Customer_Data_Request_Line_Item__c> lst_DataLineItem = new List<Customer_Data_Request_Line_Item__c>();
        if(String.ValueOf(OnboardingReq.RecordTypeId) == var.Partner_COB_RTYPE){
            lst_DataLineItem = [Select Id,Name from Customer_Data_Request_Line_Item__c Where Customer_Data_Request__c = : OnboardingReq.Id];
            if(lst_DataLineItem.size()==0)
                ErrorMsg='Please add atleast one Customer Data Request line Item before Submitting the Request.';
        }else if(String.ValueOf(OnboardingReq.RecordTypeId) == var.Miscellaneous_COB_RTYPE && (OnboardingReq.Miscellaneous_Type_Intent__c=='Mass load - finance data' || OnboardingReq.Miscellaneous_Type_Intent__c=='Mass load - non finance data')){
            Lst_Attachments = [SELECT name FROM Attachment WHERE ParentID =:OnboardingReq.Id ];
            if(Lst_Attachments.size()==0)
                ErrorMsg='Please Add atleast one Attachments Submitting the Request.';
        }
       
        return ErrorMsg;

    }

    /**
     * Name: requestFlow
     * Params: OnboardingReq- Customer Data Request Record Id
              selectedRecordTypeId-RecordTypeId of the record.
              var- variable for global class InitVar
     * Description: Method will be called for assigning record to queues for further action.   
     */
    Webservice static String requestFlow(Customer_Data_Request__c OnboardingReq, String selectedRecordTypeId, InitVar var){
        String RecordTypeName='';
        String CDRCountry='';
        String sellingCompanyCode =OnboardingReq.Company_Code__c;
        //<Alvin20150929> Added for R02 enhancement to replace selling company codes with business Rules    
        List<Business_Rules__c> busCompanyRules = new List<Business_Rules__c>();
        busCompanyRules = [select id, CDR_Sold_to_Country__c from Business_Rules__c where recordTypeId = : var.CompanyCodeCountry_Rule_Rtype and Selling_Company_Code__c = : sellingCompanyCode];
      try{
        CDRCountry = busCompanyRules[0].CDR_Sold_to_Country__c; 
         }
        catch(exception e)
        {
        }      
        //<Alvin20150929> end
        var = new InitVar();
        String ProfileName = currentUserProfile();
        String ErrorMsg='Success';
                     
        if(selectedRecordTypeId != null){
            RecordTypeName = [Select Id,Name from RecordType where SobjectType='Customer_Data_Request__c' and IsActive=true and Id=:selectedRecordTypeId ].Name;
        }

        Map<String,ID> QueueMap = new Map <String,Id>();
        list<Group> QueueList = [select Id,Name from Group Where Type = 'Queue'];
        for(Group q:QueueList){
            QueueMap.put(q.Name,q.Id);
        }



        map<Id,String> mapGrpIdNGrpName = new map<Id,String>();
        map<id,set<String>> mapUserIdNGrpName = new map<id,set<String>>();
        set<String> lst_GrpName = new set<String>();
        String CurrentUserId = userInfo.getUserId();
        List<Id> lst_Member = new List<Id>();
        for(GroupMember g : [Select UserOrGroupId, Id, GroupId From GroupMember  where UserOrGroupId =:CurrentUserId]){
            lst_Member.add(g.GroupId);
        }

        for(Group grp : [Select g.Type, g.Name, g.Id, g.DeveloperName From Group g where g.Id in :lst_Member]){
            mapGrpIdNGrpName.put(grp.Id,grp.Name);

        }

        if(mapGrpIdNGrpName.size()>0){

            for(GroupMember grpmem : [Select UserOrGroupId, Id, GroupId From GroupMember  where UserOrGroupId =:CurrentUserId]){
                if(mapUserIdNGrpName.containsKey(grpmem.UserOrGroupId))
                    mapUserIdNGrpName.get(grpmem.UserOrGroupId).add(mapGrpIdNGrpName.get(grpmem.GroupId));
                else
                    mapUserIdNGrpName.put(grpmem.UserOrGroupId,new set<String>{mapGrpIdNGrpName.get(grpmem.GroupId)});

            }

            if(mapUserIdNGrpName.size()>0 && mapUserIdNGrpName.get(CurrentUserId) !=null){
                lst_GrpName=mapUserIdNGrpName.get(CurrentUserId);
            }
        }

        ErrorMsg=RelatedlistItemsValidation(OnboardingReq);

        if(ErrorMsg == 'Success'){
            OnboardingReq.Last_Modified_Time__c =system.now();
            if(lst_GrpName.size()>0 || (ProfileName == 'System Administrator')){
                string selcompcode;
                if(CDRCountry == 'IN - India'){
                    selcompcode = 'IN';
                }
                else if(CDRCountry == 'HK - Hong Kong'){
                    selcompcode = 'HK';
                }
                //<Nishanth.H 15092015> Added for R02 enhancement-Updating selling company code value('1131 - DuPont (Shanghai) Sourcing Center Company, Ltd.')
                //<Alvin20150929> commented for R02 enhancement to replace selling company codes with business Rules
                //else if((sellingCompanyCode == '0078 - ELECT. MATLS DUP DONGGUAN') || (sellingCompanyCode == '0218 - DuPont Trading Shanghai') || (sellingCompanyCode == '0701 - DUP AGRIC CHEM LTD') ||
               //         (sellingCompanyCode == '1131 - DuPont (Shanghai) Sourcing Center Company, Ltd.') || (sellingCompanyCode == '1132 - DuPont(China) RD and Mgmt') || (sellingCompanyCode == '1142 - DUP SURFCE GUANGZHOU') ||
               //         (sellingCompanyCode == '1210 - DUP (SHENZHEN) INDUS') || (sellingCompanyCode == '2791 - Du Pont China Holding Co.') || (sellingCompanyCode == '1310 - DuPont Apollo (Shenzhen)')){//<Alvin24082015> Added 1310 selling company code for enhancement LE1310
                else if(CDRCountry == 'CN - China'){   
                    selcompcode = 'CN';

                }
                else if(CDRCountry == 'TH - Thailand'){
                    selcompcode = 'TH';
                }
                // Start of <Santhosh 20160706> 
                else if(CDRCountry == 'AU - Australia'){
                    selcompcode = 'AU';
                }
                else if(CDRCountry == 'NZ - New zealand'){
                    selcompcode = 'NZ';
                }
                // End of <Santhosh 20160706>
                // Start of <Bhargavi 20160919> 
                else if(CDRCountry == 'SG - Singapore'){
                    selcompcode = 'SG';
                }
                else if(CDRCountry == 'MY - Malaysia'){
                    selcompcode = 'MY';
                }
                else if(CDRCountry == 'PH - Philippines'){
                    selcompcode = 'PH';
                }
                else if(CDRCountry == 'VN - Vietnam'){
                    selcompcode = 'VN';
                }
                // End of <Bhargavi 20160919>
                map<String , Decimal> MapCreditTermNLimit = new map<String , Decimal>();

                for(Business_Rules__c br : [select id, CDR_Proposed_Credit_Term_Type__c,CDR_Delegation_Limit__c FROM Business_Rules__c WHERE CDR_Proposed_Credit_Term_Type__c != null AND CDR_Proposed_Credit_Term_Type__c != '' AND CDR_Delegation_Limit__c != null]){
                    MapCreditTermNLimit.put(br.CDR_Proposed_Credit_Term_Type__c, br.CDR_Delegation_Limit__c);
                }
                OnboardingReq.Last_Modified_Time__c =system.now();

                if(lst_GrpName.size()>0 && MapCreditTermNLimit.size()>0){
                        //<Bhargavi 20160919> added group 'Dupont CDR Users - ASEAN'
                    if((lst_GrpName.contains('DuPont CDR Users - Thailand') || lst_GrpName.contains('DuPont CDR Users - India') || lst_GrpName.contains('DuPont CDR Users - ANZ') || lst_GrpName.contains('Dupont CDR Users - ASEAN') || lst_GrpName.contains('DuPont CDR Users - Hong Kong')
                            ||lst_GrpName.contains('DPP Customer Service Reps') || lst_GrpName.contains('DPT Customer Service Reps')  || lst_GrpName.contains('DCP Customer Service Reps')
                            || lst_GrpName.contains('P&IP Customer Service Reps')  || lst_GrpName.contains('DSS Customer Service Reps') || lst_GrpName.contains('BI Customer Service Reps')
                            || lst_GrpName.contains('N&H Customer Service Reps') || lst_GrpName.contains('DEC Customer Service Reps') || lst_GrpName.contains('IB Customer Service Reps')
                            || lst_GrpName.contains('Customer On-boarding Levrg CSR - China') || lst_GrpName.contains('DuPont CDR Users - China')))
                    {

                        if(OnboardingReq.Leveraged_CSR__c == true && OnboardingReq.Assigned_to_Leverage_CSR__c == false && OnboardingReq.Request_Status__c !='Request Completed in SAP'){
                            OnboardingReq.Ownerid= QueueMap.get('Customer On-boarding Levrg CSR-China Que');
                            system.debug('status***1');
                            OnboardingReq.Request_Status__c= 'Draft/Data Gathering';
                            OnboardingReq.Send_To_Utility__c=false;
                            OnboardingReq.Sent_To_Utility__c=false;
                            OnboardingReq.Assigned_to_Leverage_CSR__c = true;
                        }else if(OnboardingReq.Account_Group__c == 'Z002 (Ship-to party)' && OnboardingReq.Request_Status__c !='Request Completed in SAP'){
                            OnboardingReq.Assigned_to_Leverage_CSR__c = false;
                            system.debug('status***2');
                            OnboardingReq.Request_Status__c='Awaiting Data Analyst (DMS Team) Approval';
                            OnboardingReq.Send_To_Utility__c=true;
                            OnboardingReq.Record_Locked__c=true;
                            OnboardingReq.Destination_Credit_Comments__c='This Request has by-passed the Destination Credit Approval.';
                            OnboardingReq.Country_Credit_Comments__c='This Request has by-passed the Country Credit Approval.';
                            onboardingReq.Data_Analyst_Comments__c='This request has pre-approved terms of payment and hence has by-passed the credit approval';
                            OnboardingReq=CopyProposedToApprovedCredit(OnboardingReq);
                        }
                        else{
                            OnboardingReq.Assigned_to_Leverage_CSR__c = false;
                            if(String.ValueOf(OnboardingReq.RecordTypeId) == var.NewCustomerCreation_COB_RTYPE ) {
                                OnboardingReq.Send_To_Utility__c=true;
                                OnboardingReq.Sent_To_Utility__c=false;
                                OnboardingReq.Record_Locked__c=true;
                                  system.debug('status***3');  
                                if(OnboardingReq.Request_Status__c !='Request Completed in SAP'){
                                    if((OnboardingReq.Proposed_Credit_Term_Type__c=='Cash In Advance')||((OnboardingReq.Proposed_Credit_Term_Type__c=='Letter Of Credit') && Decimal.ValueOf(OnboardingReq.Proposed_Credit_Limit_Est__c) < MapCreditTermNLimit.get(OnboardingReq.Proposed_Credit_Term_Type__c)) && (OnboardingReq.Preferred_Bank_Name__c!='Other' && OnboardingReq.Preferred_Bank_Name__c!=null))
                                    {
                                    system.debug('status***4');
                                        OnboardingReq.Request_Status__c='Awaiting Data Analyst (DMS Team) Approval';
                                        OnboardingReq.Destination_Credit_Comments__c='This Request has by-passed the Destination Credit Approval.';
                                        OnboardingReq.Country_Credit_Comments__c='This Request has by-passed the Country Credit Approval.';
                                        onboardingReq.Data_Analyst_Comments__c='This request has pre-approved terms of payment and hence has by-passed the credit approval';
                                        OnboardingReq=CopyProposedToApprovedCredit(OnboardingReq);
                                    }
                                    else if(OnboardingReq.Sold_to_Country__c.Substring(0,2) != selcompcode && ((OnboardingReq.Proposed_Credit_Term_Type__c=='Open Credit' || (OnboardingReq.Proposed_Credit_Term_Type__c=='DA (Delivery On Acceptance) or DP (Delivery on Payment)')) && (Decimal.ValueOf(OnboardingReq.Proposed_Credit_Limit_Est__c)>= MapCreditTermNLimit.get(OnboardingReq.Proposed_Credit_Term_Type__c)))){
                                       // Start of  <Bhargavi 20161110> Commneted the code to by pass Destination Credit Approval 
                                       /* OnboardingReq.Credit_Approval_Required__c = true;
                                        OnboardingReq.Request_Status__c='Awaiting Destination Credit Approval';
                                              system.debug('status***5'); 
                                        //Start of BA15062016
                                    if (OnboardingReq.isCreditApproved__c == true) {
                                            system.debug('insideif $$$$ 1 ');
                                            OnboardingReq.Request_Status__c ='Awaiting Data Analyst (DMS Team) Approval';
                                            OnboardingReq.Credit_Approval_Required__c = false;
                                            OnboardingReq.Send_To_Utility__c=true;
                                            OnboardingReq.Record_Locked__c=true;
                                        } //End of BA15062016 
                                        else if(selcompcode =='AU' || selcompcode =='NZ' || selcompcode == 'SG' || selcompcode == 'MY' || selcompcode == 'PH' || selcompcode == 'VN')  // <Bhargavi 20160919> added SG,MY,PH & VN conditions
                                        {
                                        OnboardingReq.Request_Status__c='Awaiting Credit Approval';
                                        OnboardingReq.Credit_Approval_Required__c = true;
                                        }  
                                        if(OnboardingReq.Sold_to_Country__c.Substring(0,2) !='IN' && OnboardingReq.Sold_to_Country__c.Substring(0,2) !='TH'&& OnboardingReq.Sold_to_Country__c.Substring(0,2) !='CN' && OnboardingReq.Sold_to_Country__c.Substring(0,2) !='HK' && OnboardingReq.Sold_to_Country__c.Substring(0,2) !='AU' && OnboardingReq.Sold_to_Country__c.Substring(0,2) !='NZ'
                                                && OnboardingReq.Sold_to_Country__c.Substring(0,2) !='SG' && OnboardingReq.Sold_to_Country__c.Substring(0,2) !='MY' && OnboardingReq.Sold_to_Country__c.Substring(0,2) !='PH' && OnboardingReq.Sold_to_Country__c.Substring(0,2) !='VN') //<Bhargavi 20160919> added SG,PH,MY and PH conditions
                                        { */ 
                                        // End of <Bhargavi 20161110>

                                             //Start of BA15062016
                                             if (OnboardingReq.isCreditApproved__c == true) {
                                                system.debug('insideif $$$$ 3');
                                                OnboardingReq.Request_Status__c ='Awaiting Data Analyst (DMS Team) Approval';
                                                OnboardingReq.Credit_Approval_Required__c = false;
                                                OnboardingReq.Send_To_Utility__c=true;
                                                OnboardingReq.Record_Locked__c=true;
                                            } 
                                            else {  //End of BA15062016
                                                system.debug('insideif $$$$ 4');
                                                OnboardingReq.Credit_Approval_Required__c = true;
                                                OnboardingReq.Request_Status__c='Awaiting Credit Approval';
                                                OnboardingReq.Destination_Credit_Comments__c='There is no Destination Credit Analyst available for' + OnboardingReq.Sold_to_Country__c + 'Country and hence request has by-passed destination credit analysis.';
                                            }  // BA15062016
                                       // }
                                    }
                                    else if(((((OnboardingReq.Proposed_Credit_Term_Type__c=='Letter Of Credit') && Decimal.ValueOf(OnboardingReq.Proposed_Credit_Limit_Est__c)< MapCreditTermNLimit.get(OnboardingReq.Proposed_Credit_Term_Type__c) && (OnboardingReq.Preferred_Bank_Name__c=='Other' || OnboardingReq.Preferred_Bank_Name__c==null)) || ((OnboardingReq.Proposed_Credit_Term_Type__c=='Letter Of Credit') && Decimal.ValueOf(OnboardingReq.Proposed_Credit_Limit_Est__c)>= MapCreditTermNLimit.get(OnboardingReq.Proposed_Credit_Term_Type__c)) || (OnboardingReq.Proposed_Credit_Term_Type__c=='Open Credit') || (OnboardingReq.Proposed_Credit_Term_Type__c=='DA (Delivery On Acceptance) or DP (Delivery on Payment)'))) || (OnboardingReq.Proposed_Terms_of_Payment__c=='Other' && OnboardingReq.Proposed_Non_Standard_Terms_of_Payment__c!=null) || (((OnboardingReq.Proposed_Credit_Term_Type__c=='Open Credit') && (Decimal.ValueOf(OnboardingReq.Proposed_Credit_Limit_Est__c)< MapCreditTermNLimit.get(OnboardingReq.Proposed_Credit_Term_Type__c)))))
                                    {
                                         //Start of BA15062016
                                        if (OnboardingReq.isCreditApproved__c == true) {
                                            OnboardingReq.Request_Status__c ='Awaiting Data Analyst (DMS Team) Approval';
                                            OnboardingReq.Credit_Approval_Required__c = false;
                                            OnboardingReq.Send_To_Utility__c=true;
                                            OnboardingReq.Record_Locked__c=true;
                                        } 
                                        else { //End of BA15062016
                                            OnboardingReq.Credit_Approval_Required__c = true;
                                            OnboardingReq.Request_Status__c='Awaiting Credit Approval';
                                        } // BA15062016
                                    } 
                                }else{
                                    OnboardingReq.Request_Status__c='Request Sent for Re-Work';
                                    OnboardingReq.Sent_To_Utility__c=false;
                                    OnboardingReq.Send_To_Utility__c=true;
                                    OnboardingReq.Record_Locked__c=true;
                                }
                            }else if((String.ValueOf(OnboardingReq.RecordTypeId) == var.Miscellaneous_COB_RTYPE ) ||(String.ValueOf(OnboardingReq.RecordTypeId) == var.Partner_COB_RTYPE)) {
                                OnboardingReq.Send_To_Utility__c=true;
                                OnboardingReq.Sent_To_Utility__c=false;
                                OnboardingReq.Record_Locked__c=true;
                                if(OnboardingReq.Request_Status__c !='Request Completed in SAP'){
                                    if(OnboardingReq.Credit_Approval_Required__c == true){
                                        OnboardingReq.Request_Status__c ='Awaiting Credit Approval';
                                    }else{
                                        OnboardingReq.Request_Status__c ='Awaiting Data Analyst (DMS Team) Approval';
                                        OnboardingReq.Country_Credit_Comments__c='This Request has by-passed the Country Credit Approval.';
                                        OnboardingReq.Destination_Credit_Comments__c='This Request has by-passed the Destination Credit Approval.';            
                                    }
                                }else{
                                    OnboardingReq.Request_Status__c='Request Sent for Re-Work';
                                    OnboardingReq.Sent_To_Utility__c=false;
                                    OnboardingReq.Send_To_Utility__c=true;
                                    OnboardingReq.Record_Locked__c=true;
                                }
                            }else
                            {   
                                String CountryCode = fetchCountryCode(OnboardingReq);
                                if(CountryCode != null)
                                {
                                    CountryCode=CountryCode.substring(0,2);
                                    OnboardingReq.Send_To_Utility__c=true;
                                    OnboardingReq.Sent_To_Utility__c=false;
                                    OnboardingReq.Record_Locked__c=true;

                                    if(OnboardingReq.Request_Status__c !='Request Completed in SAP'){

                                        if(((String.ValueOf(OnboardingReq.RecordTypeId) == var.ModifyExisting_COB_RTYPE ||String.ValueOf(OnboardingReq.RecordTypeId) == var.ExtendExisting_COB_RTYPE) & OnboardingReq.Credit_Approval_Required__c== false))
                                        {
                                            OnboardingReq.Request_Status__c = 'Awaiting Data Analyst (DMS Team) Approval';
                                            OnboardingReq.Destination_Credit_Comments__c='This Request has by-passed the Destination Credit Approval.';
                                            OnboardingReq.Country_Credit_Comments__c='This Request has by-passed the Country Credit Approval.';
                                        }
                                        else{
                                            if((OnboardingReq.Proposed_Credit_Term_Type__c=='Cash In Advance')||((OnboardingReq.Proposed_Credit_Term_Type__c=='Letter Of Credit') && Decimal.ValueOf(OnboardingReq.Proposed_Credit_Limit_Est__c)< MapCreditTermNLimit.get(OnboardingReq.Proposed_Credit_Term_Type__c) && (OnboardingReq.Preferred_Bank_Name__c!='Other' && OnboardingReq.Preferred_Bank_Name__c!=null))){
                                                OnboardingReq.Request_Status__c='Awaiting Data Analyst (DMS Team) Approval';
                                                OnboardingReq.Destination_Credit_Comments__c='This Request has by-passed the Destination Credit Approval.';
                                                OnboardingReq.Country_Credit_Comments__c='This Request has by-passed the Country Credit Approval.';
                                                onboardingReq.Data_Analyst_Comments__c='This request has pre-approved terms of payment and hence has by-passed the credit approval';
                                                OnboardingReq=CopyProposedToApprovedCredit(OnboardingReq);
               
                                            }
                                            else if(CountryCode != selcompcode && ((OnboardingReq.Proposed_Credit_Term_Type__c=='Open Credit' || (OnboardingReq.Proposed_Credit_Term_Type__c=='DA (Delivery On Acceptance) or DP (Delivery on Payment)')) && (Decimal.ValueOf(OnboardingReq.Proposed_Credit_Limit_Est__c)>= MapCreditTermNLimit.get(OnboardingReq.Proposed_Credit_Term_Type__c)))){
                                                // Start of  <Bhargavi 20161110> Commneted the code to by pass Destination Credit Approval 
                                                /*{ 

                                                     //Start of BA15062016
                                         
                                                     if (OnboardingReq.isCreditApproved__c == true) {
                                                        OnboardingReq.Request_Status__c ='Awaiting Data Analyst (DMS Team) Approval';
                                                        OnboardingReq.Credit_Approval_Required__c = false;
                                                        OnboardingReq.Send_To_Utility__c=true;
                                                        OnboardingReq.Record_Locked__c=true;
                                                    } 
                                                    //Start of <Santhosh 20160706>
                                                    else if(selcompcode =='AU' || selcompcode =='NZ' || selcompcode == 'SG' || selcompcode == 'MY' || selcompcode == 'PH' || selcompcode == 'VN')  // <Bhargavi 20160919> added SG,MY,PH & VN conditions
                                                    {
                                                    OnboardingReq.Request_Status__c='Awaiting Credit Approval';
                                                    OnboardingReq.Credit_Approval_Required__c = true;
                                                    }  //End of <Santhosh 20160706> 
                                                    else { //End of BA15062016
                                                         OnboardingReq.Credit_Approval_Required__c = true;
                                                            OnboardingReq.Request_Status__c='Awaiting Destination Credit Approval';
                                                    } //BA15062016
                                                }
                                                if((CountryCode !='CN') && (CountryCode !='TH') && (CountryCode !='HK')&& (CountryCode !='IN')&& (CountryCode !='AU') && (CountryCode !='NZ') 
                                                                && (CountryCode !='SG') && (CountryCode !='MY')&& (CountryCode !='PH')&& (CountryCode !='VN') ) //<Bhargavi 20160919> added SG,MY,PH and VN conditions
                                                { */
                                                 
                                                 // End of  <Bhargavi 20161110>
                                                    //Start of BA15062016
                                                    if (OnboardingReq.isCreditApproved__c == true) {
                                                    system.debug('insideif $$$$ 10');
                                                    OnboardingReq.Request_Status__c ='Awaiting Data Analyst (DMS Team) Approval';
                                                    OnboardingReq.Credit_Approval_Required__c = false;
                                                    OnboardingReq.Send_To_Utility__c=true;
                                                    OnboardingReq.Record_Locked__c=true;
                                                    } 
                                                    else {
                                                        OnboardingReq.Credit_Approval_Required__c= true;
                                                        OnboardingReq.Request_Status__c='Awaiting Credit Approval';
                                                        OnboardingReq.Destination_Credit_Comments__c='There is no Destination Credit Analyst available for' + OnboardingReq.Sold_to_Country__c + 'Country and hence request has by-passed destination credit analysis.';
                                                    }//BA15062016
                                                //}
                                            }
                                            else if(((((OnboardingReq.Proposed_Credit_Term_Type__c=='Letter Of Credit') && Decimal.ValueOf(OnboardingReq.Proposed_Credit_Limit_Est__c)< MapCreditTermNLimit.get(OnboardingReq.Proposed_Credit_Term_Type__c) && (OnboardingReq.Preferred_Bank_Name__c=='Other' || OnboardingReq.Preferred_Bank_Name__c==null)) || ((OnboardingReq.Proposed_Credit_Term_Type__c=='Letter Of Credit') && Decimal.ValueOf(OnboardingReq.Proposed_Credit_Limit_Est__c)>= MapCreditTermNLimit.get(OnboardingReq.Proposed_Credit_Term_Type__c)) || (OnboardingReq.Proposed_Credit_Term_Type__c=='Open Credit') || (OnboardingReq.Proposed_Credit_Term_Type__c=='DA (Delivery On Acceptance) or DP (Delivery on Payment)'))) || (OnboardingReq.Proposed_Terms_of_Payment__c=='Other' && OnboardingReq.Proposed_Non_Standard_Terms_of_Payment__c!=null) || (((OnboardingReq.Proposed_Credit_Term_Type__c=='Open Credit') && (Decimal.ValueOf(OnboardingReq.Proposed_Credit_Limit_Est__c)< MapCreditTermNLimit.get(OnboardingReq.Proposed_Credit_Term_Type__c)))))
                                            {
                                                             //Start of BA15062016
                                                    if (OnboardingReq.isCreditApproved__c == true) {
                                                        OnboardingReq.Request_Status__c ='Awaiting Data Analyst (DMS Team) Approval';
                                                        OnboardingReq.Credit_Approval_Required__c = false;
                                                        OnboardingReq.Send_To_Utility__c=true;
                                                        OnboardingReq.Record_Locked__c=true;
                                                    } 
                                                    else { //End of BA15062016
                                                        OnboardingReq.Credit_Approval_Required__c = true;
                                                        OnboardingReq.Request_Status__c='Awaiting Credit Approval';
                                                    } //BA15062016
                                            }
                                            else if((String.ValueOf(OnboardingReq.RecordTypeId) == var.ModifyExisting_COB_RTYPE & OnboardingReq.Credit_Approval_Required__c== false) && OnboardingReq.Request_Status__c =='Draft/Data Gathering'){
                                                OnboardingReq.Record_Locked__c=true;
                                                OnboardingReq.Send_To_Utility__c = true;
                                                OnboardingReq.Destination_Credit_Comments__c='This Request has by-passed the Destination Credit Approval.';
                                                OnboardingReq.Country_Credit_Comments__c='This Request has by-passed the Country Credit Approval.';
                                                OnboardingReq.Request_Status__c ='Awaiting Data Analyst (DMS Team) Approval';
                                            }                   

                                        }
                                    }
                                    else{
                                        OnboardingReq.Request_Status__c='Request Sent for Re-Work';
                                        OnboardingReq.Sent_To_Utility__c=false;
                                        OnboardingReq.Send_To_Utility__c=true;
                                        OnboardingReq.Record_Locked__c=true;
                                    }   


                                }   
                            }
                        }
                    } 
                }    
            }
        }
        return ErrorMsg;
    }


    /**
     * Name: CopyProposedToApprovedCredit
     * Params: OnboardingReq: Customer_Data_Request__c Id.
     * Description: Method to Copy Proposed Data To Approved Data.
     */ 
    Webservice static Customer_Data_Request__c CopyProposedToApprovedCredit(Customer_Data_Request__c OnboardingReq){

        if(OnboardingReq.Proposed_Cash_Management_Group__c!=null)OnboardingReq.Approved_Cash_Management_Group__c = OnboardingReq.Proposed_Cash_Management_Group__c;
        if(OnboardingReq.Proposed_Cred_rep_grp__c!=null)OnboardingReq.Approved_Cred_rep_grp__c = OnboardingReq.Proposed_Cred_rep_grp__c;
        if(OnboardingReq.Proposed_credit_information_number__c!=null)OnboardingReq.Approved_credit_information_number__c = OnboardingReq.Proposed_credit_information_number__c;
        if(OnboardingReq.Proposed_Credit_Limit__c!=null)OnboardingReq.Approved_Credit_Limit__c = OnboardingReq.Proposed_Credit_Limit__c;
        if(OnboardingReq.Proposed_Credit_Limit_Currency_Code__c!=null)OnboardingReq.Approved_Credit_Limit_Currency_Code__c = OnboardingReq.Proposed_Credit_Limit_Currency_Code__c;
        if(OnboardingReq.Proposed_Credit_Term_Type__c!=null)OnboardingReq.Approved_Credit_Term_Type__c = OnboardingReq.Proposed_Credit_Term_Type__c;
        if(OnboardingReq.Proposed_Customer_credit_group__c!=null)OnboardingReq.Approved_Customer_credit_group__c = OnboardingReq.Proposed_Customer_credit_group__c;
        if(OnboardingReq.Proposed_Customer_Group__c!=null)OnboardingReq.Approved_Customer_Group__c = OnboardingReq.Proposed_Customer_Group__c;
        if(OnboardingReq.Proposed_Non_Standard_Terms_of_Payment__c!=null)OnboardingReq.Approved_Non_Standard_Terms_of_Payment__c = OnboardingReq.Proposed_Non_Standard_Terms_of_Payment__c;
        if(OnboardingReq.Proposed_Payment_Index__c!=null)OnboardingReq.Approved_Payment_Index__c = OnboardingReq.Proposed_Payment_Index__c;
        if(OnboardingReq.Proposed_Rating__c!=null)OnboardingReq.Approved_Rating__c = OnboardingReq.Proposed_Rating__c;
        if(OnboardingReq.Proposed_Reference_date__c!=null)OnboardingReq.Approved_Reference_date__c = OnboardingReq.Proposed_Reference_date__c;
        if(OnboardingReq.Proposed_Risk_Category__c!=null)OnboardingReq.Approved_Risk_Category__c = OnboardingReq.Proposed_Risk_Category__c;
        if(OnboardingReq.Proposed_Terms_of_Payment__c!=null)OnboardingReq.Approved_Terms_of_Payment__c = OnboardingReq.Proposed_Terms_of_Payment__c;
        if(OnboardingReq.Estimated_Number_of_Orders_per_Month__c!=null)OnboardingReq.Approved_Number_of_Orders_per_Month__c = OnboardingReq.Estimated_Number_of_Orders_per_Month__c;
        if(OnboardingReq.Estimated_Average_Monthly_Purchases__c!=null)OnboardingReq.Approved_Average_Monthly_Purchases__c = OnboardingReq.Estimated_Average_Monthly_Purchases__c;
        return OnboardingReq;
    }


    /**
     * Name: fetchCountryCode
     * Params: OnboardingReq- Customer Data Request Record Id
     * Description: Method will be called If record RecordType is not New Customer Creation and We need Country code of existing ERP Customer.
                   will be called from RequestFlow Method..   
     */
    Webservice static String fetchCountryCode(Customer_Data_Request__c OnboardingReq){
        InitVar var = new InitVar() ;
        List <ERP_Relationship__c> soldToRelationship = new List<ERP_Relationship__c>();
        if(OnboardingReq.Account_Group__c.contains('Z001')){
            if(String.ValueOf(OnboardingReq.RecordTypeId)!=var.NewCustomerCreation_COB_RTYPE)
                OnboardingReq.Sold_to_Country__c = OnboardingReq.Existing_Country__c;
            return OnboardingReq.Existing_Country__c.substring(0,2);

        }

        else{
            soldToRelationship= [Select ERP_Customer__r.Country_Code__c,ERP_Customer__r.Country__c,Related_ERP_Customer__c,ERP_Customer__r.Account_Group__c from ERP_Relationship__c where Related_ERP_Customer__c=:OnboardingReq.Customer__c and ERP_Customer__r.Account_Group__c like 'Z001%' ];
            if(soldToRelationship.size()!=0){ 
                if(String.ValueOf(OnboardingReq.RecordTypeId)!=var.NewCustomerCreation_COB_RTYPE)
                    OnboardingReq.Sold_to_Country__c = soldToRelationship.get(0).ERP_Customer__r.Country_Code__c + ' - '+soldToRelationship.get(0).ERP_Customer__r.Country__c ;
                return soldToRelationship.get(0).ERP_Customer__r.Country_Code__c;
            }
            else return null;
        }
    }

    /**
     * Name: getRequestInformation
     * Params: reqId- Customer Data Request Record Id
     * Description: Method will be called From DirectSubmit Method and Query all the Fields of the Record in action.  
     */
    Webservice static Customer_Data_Request__c getRequestInformation(Id reqId){
        Customer_Data_Request__c req = new Customer_Data_Request__c();
        Map<String, Schema.SObjectField> fldObjMap = schema.SObjectType.Customer_Data_Request__c.fields.getMap();
        String querySearch= '';
        String query;
        for(String s :fldObjMap.KeySet()){
            querySearch = querySearch + s + ',';
        }
        querySearch = querySearch.removeEnd(',');
        query = 'Select '+  querySearch + ',RecordType.Name,CreatedBy.Id,Account__r.Id from Customer_Data_Request__c where Id=\''+reqId+'\'';
        req=database.query(query);
        return req;
    }

    /**
     * Name: accessCheck
     * Params: requestId- Customer Data Request Record Id
              ProfileName- Profile Name of the user
     * Description: Method will be called for validation check if the user has access to submit the request or not.   
     */
    Webservice static String accessCheck(Id requestId, String ProfileName){
        String ErrorMsg='Success';
        List<UserRecordAccess> custShareList = new List<UserRecordAccess>();   
        custShareList =[SELECT RecordId, HasEditAccess FROM UserRecordAccess WHERE UserId = :UserInfo.getUserId() AND RecordId = :requestId];
        if((custShareList.size()!=0 && custShareList.get(0).HasEditAccess == false) || ProfileName == 'Process Managers' ){
            ErrorMsg = 'Insufficient Privileges!! You do not have access to Submit this Request. Please contact your administrator';
        }
        return ErrorMsg;
    }

    /**
     * Name: currentUserProfile
     * Params: None
     * Description: Method will be called If record RecordType is not New Customer Creation and We need Country code of existing ERP Customer.
                   will be called from RequestFlow Method..   
     */
    Webservice static String currentUserProfile(){
        Id ProfileId = UserInfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:ProfileId].Name;
        return profileName;
    }
    
    

  
}