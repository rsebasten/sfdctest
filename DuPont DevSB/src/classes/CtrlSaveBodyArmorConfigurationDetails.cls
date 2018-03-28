/*******************************************************************************
(C)2015
Author: krishnaveni duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  This class insers the all BodyArmorConfiguration.



 ********************************************************************************/

@RestResource(urlMapping = '/SaveBAC/*')
global class CtrlSaveBodyArmorConfigurationDetails{

public class bacWrapperClass
{
    Public BA_Configuration__c bac;
    Public String Name;
    Public Boolean Active;
    Public String BAC_Progress;
    Public String BodyArmorConfigurationID;
    Public Integer Budget_for_Year_1;
    Public Integer Budget_for_Year_2;
    Public Integer  Budget_for_Year_3;
    Public String Closure_Reason;
    Public String Closure_Remark;
    Public String Created_by_IOS;
    Public DateTime Created_date_IOS;
    Public Date End_Date;
    Public String End_User_Country;
    Public String End_User_Region;
    Public String End_User_Name;
    Public DateTime last_modified_date_IOS;
    Public String last_modify_by_IOS;
    Public Integer No_of_Helmets;
    Public Integer Number_of_Plates;
    Public Integer Number_of_Helmets_Y1;
    Public Integer Number_of_Helmets_Y2;
    Public Integer Number_of_Helmets_Y3;
    Public Integer Number_of_Plates_Y1;
    Public Integer Number_of_Plates_Y2;
    Public Integer Number_of_Plates_Y3;
    Public Integer Number_of_Vest;
    Public Integer Number_of_Vest_Y1;
    Public Integer Number_of_Vest_Y2;
    Public Integer Number_of_Vest_Y3;
   // Public String Phase;
    Public Date Start_Date;
    Public String Status;
    Public Integer Total_Budget;
    Public String teamMemberUserId;
    Public Boolean Sensitive_country_flag;
    Public String Sensitive_country_Comment;
    Public String CurrencyIsoCode;
    Public DateTime tenderSubmissionDate;
    Public DateTime technicalOfferSubmissionDate;
}


    @HttpPost
    global static CtrlKevlarSvcHelper.ReturnDropDownClass doPost() {
        CtrlKevlarSvcHelper h = new CtrlKevlarSvcHelper();
        List<bacWrapperClass> bwcList = new List<bacWrapperClass>();
        List<string> teamMembers= null;
        String rJSON;
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        try{ 
            system.debug('req.requestBody : ' + req.requestBody.toString());
            List<bacWrapperClass> bacList= (List<bacWrapperClass>) JSON.deserialize(req.requestBody.toString(), List<bacWrapperClass>.class);
            List<BA_Configuration__c> newBAC = new List<BA_Configuration__c>();
            for(bacWrapperClass qt : bacList){        
                BA_Configuration__c bac = new BA_Configuration__c();
                bac.name= qt.name;
                bac.Active__c= qt.Active;
                bac.BAC_Progress__c = qt.BAC_Progress;
                bac.Body_Armor_Configuration_ID__c  = qt.BodyArmorConfigurationID;
                bac.Budget_for_Year_1__c= qt.Budget_for_Year_1;
                bac.Budget_for_Year_2__c= qt.Budget_for_Year_2;
                bac.Budget_for_Year_3__c= qt.Budget_for_Year_3;
                bac.Closure_Reason__c= qt.Closure_Reason;
                bac.Closure_Remark__c= qt.Closure_Remark;
                bac.Created_by_IOS__c= qt.Created_by_IOS;
                bac.Created_date_IOS__c= qt.Created_date_IOS;
                bac.End_Date__c= qt.End_Date;
                bac.End_User_Name__c= qt.End_User_Name;             
                bac.End_User_Country__c= qt.End_User_Country;
                bac.End_User_Region__c= qt.End_User_Region;
                bac.last_modified_date_IOS__c= qt.last_modified_date_IOS;
                bac.last_modify_by_IOS__c= qt.last_modify_by_IOS; 
                bac.No_of_Helmets__c= qt.No_of_Helmets;           
                bac.Number_of_Helmets_Y1__c= qt.Number_of_Helmets_Y1;
                bac.Number_of_Helmets_Y2__c= qt.Number_of_Helmets_Y2;
                bac.Number_of_Helmets_Y3__c= qt.Number_of_Helmets_Y3;
                bac.Number_of_Plates__c= qt.Number_of_Plates;
                bac.Number_of_Plates_Y1__c= qt.Number_of_Plates_Y1;
                bac.Number_of_Plates_Y2__c= qt.Number_of_Plates_Y2;
                bac.Number_of_Plates_Y3__c= qt.Number_of_Plates_Y3;
                bac.Number_of_Vest__c= qt.Number_of_Vest;
                bac.Number_of_Vest_Y1__c= qt.Number_of_Vest_Y1;
                bac.Number_of_Vest_Y2__c= qt.Number_of_Vest_Y2;
                bac.Number_of_Vest_Y3__c = qt.Number_of_Vest_Y3;         
                bac.Start_Date__c= qt.Start_Date;
                bac.Status__c= qt.Status;
                bac.Total_Budget__c = qt.Total_Budget;
                bac.Sensitive_Destination_Committee_Approv__c = qt.Sensitive_country_flag;
                bac.Comment__c= qt.Sensitive_country_Comment;
                bac.BAC_Currency__c = qt.CurrencyIsoCode;
                bac.tenderSubmissionDate__c = qt.tenderSubmissionDate;
                bac.technicalOfferSubmissionDate__c = qt.technicalOfferSubmissionDate;
                
                //start
                if(qt.teamMemberUserId != null){
                teamMembers = qt.teamMemberUserId.split(';');
                    for(String tm : teamMembers){
                        bacWrapperClass bwc = new bacWrapperClass();
                        bwc.bac = bac;
                        bwc.teamMemberUserId = tm;             
                        bwcList.add(bwc);
                    }
                }
                //end           
               newBAC.add(bac); 
            }
            upsert newBAC Body_Armor_Configuration_ID__c;
            //database.insert(newBAC);
            //starts TM code
            if(!bwcList.isEmpty()){
                List<BAC_Team_Member__c> tmList = new List<BAC_Team_Member__c>();
                for(bacWrapperClass bb : bwcList){
                    BAC_Team_Member__c bacTM = new BAC_Team_Member__c();
                    bacTM.BA_Configuration__c = bb.bac.Id;
                    bacTM.Team_Member_Name__c = bb.teamMemberUserId;
                    tmList.add(bacTM);
                }
                database.insert(tmList);
            }     
            List<String> result = new List<String>();
            result.add('Success');       
            system.debug('SaveBodyArmorConfiguration result : ' +newBAC );
            return new CtrlKevlarSvcHelper.ReturnDropDownClass(h.dataSent, h.getMessage('200'),h.getResponseMessage('508'),'508',result, null, 'No Error'); 
         }
         catch(Exception e){
         	system.debug('Error----------'+e.getMessage());
            return new CtrlKevlarSvcHelper.ReturnDropDownClass(h.dataNotSent, h.getMessage('203'),'Insert or Update failed!',null, null, null, '203');
         }
    }
}