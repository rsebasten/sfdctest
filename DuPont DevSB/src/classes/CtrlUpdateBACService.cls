/*******************************************************************************
(C)2015
Author: krishnaveni duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  This class update the all BodyArmorConfiguration.

Change History:                                                                  Date:  
1. PS 1060931 - Modified code to add new fields in Wrapper class and Query       07/02/2016 
 ********************************************************************************/


@RestResource(urlMapping = '/UpdateBAC/*')
global class CtrlUpdateBACService{

    public class bacWrapperClass{
      	public BA_Configuration__c bac;
        public String Id;
        public Boolean Active;
        public String BAC_Progress;
        public String BodyArmorConfigurationID;
        public Integer Budget_for_Year_1;
        public Integer Budget_for_Year_2;
        public Integer  Budget_for_Year_3;
        public String Closure_Reason;
        public String Closure_Remark;
        public String Created_by_IOS;
        public DateTime Created_date_IOS;
        public Date End_Date;
        public String End_User_Country;
        public String End_User_Region;
        public String End_User_Name;
        public DateTime last_modified_date_IOS;
        public String last_modify_by_IOS;
        public Integer No_of_Helmets;
        public Integer Number_of_Plates;
        public Integer Number_of_Helmets_Y1;
        public Integer Number_of_Helmets_Y2;
        public Integer Number_of_Helmets_Y3;
        public Integer Number_of_Plates_Y1;
        public Integer Number_of_Plates_Y2;
        public Integer Number_of_Plates_Y3;
        public Integer Number_of_Vest;
        public Integer Number_of_Vest_Y1;
        public Integer Number_of_Vest_Y2;
        public Integer Number_of_Vest_Y3;
        public Date Start_Date;
        public String Status;
        public Integer Total_Budget;
        public String teamMemberUserId;
        public Boolean Sensitive_country_flag;
        public String Sensitive_country_Comment;
        public String CurrencyIsoCode;
        public DateTime lastSync;
        //to change the owner of campaign by admin
        public String newOwner;
      
        Public DateTime tenderSubmissionDate;   /* PS1060931 */
    	public DateTime technicalOfferSubmissionDate;  /* PS1060931 */
    }
    
    @HttpPost
    global static CtrlKevlarSvcHelper.ReturnDropDownClass doPost(){
        CtrlKevlarSvcHelper h = new CtrlKevlarSvcHelper();
        List<bacWrapperClass> bwcList = new List<bacWrapperClass>();
        List<String> result = new List<String>();
        Map<Id, BA_Configuration__c> bacIdMap = new Map<Id, BA_Configuration__c>();
        List<string> teamMembers= null;
        Boolean updateSuccess = false;
        String responseCode = null;
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        try{          
            system.debug('req.requestBody.toString()---'+req.requestBody.toString());
            List<bacWrapperClass> bacList= (List<bacWrapperClass>) JSON.deserialize(req.requestBody.toString(), List<bacWrapperClass>.class);
            List<BA_Configuration__c> updateBAC = new List<BA_Configuration__c>();
            List<Id> bacId = new List<Id>();
            for(bacWrapperClass bacL : bacList){   
                bacId.add(bacL.Id);
            }
            List<BA_Configuration__c> baConfiguration = [SELECT Id,OwnerId,BAC_Currency__c,Name,Active__c,Body_Armor_Configuration_ID__c,
                                                         Budget_for_Year_1__c,Budget_for_Year_2__c,Budget_for_Year_3__c,Closure_Reason__c,
                                                         Closure_Remark__c,Created_by_IOS__c,Created_date_IOS__c,End_Date__c,End_User_Name__c,
                                                         End_User_Country__c,End_User_Region__c,last_modified_date_IOS__c,last_modify_by_IOS__c,
                                                         No_of_Helmets__c,No_of_Vests_for_Year_1__c,No_of_Vests_for_Year_2__c,No_of_Vests_for_Year_3__c,
                                                         Number_of_Plates_Y1__c,Number_of_Plates_Y2__c,Number_of_Plates_Y3__c,Number_of_Helmets_Y1__c, 
                                                         Number_of_Helmets_Y2__c,Number_of_Helmets_Y3__c,Number_of_Plates__c,Number_of_Vest__c,Start_Date__c,
                                                         Status__c,Total_Budget__c,LastModifiedDate,Sensitive_Destination_Committee_Approv__c,CurrencyIsoCode,
                                                         Comment__c,tenderSubmissionDate__c,technicalOfferSubmissionDate__c FROM BA_Configuration__c Where Id  in :(bacId)]; 
            List<BAC_Team_Member__c> tml=[SELECT Id FROM BAC_Team_Member__c where BA_Configuration__c in :(bacId)];
            if(tml.size()> 0){
                database.delete(tml);
            }
            for(BA_Configuration__c baConfig : baConfiguration){
                bacIdMap.put(baConfig.Id,baConfig);
            }
            for(bacWrapperClass qt : bacList){
                if(bacIdMap.containsKey(qt.id) && !bacIdMap.isEmpty() &&  null !=qt.lastSync && 
                   qt.lastSync > bacIdMap.get(qt.id).LastModifiedDate){
                    system.debug('inside if map');
                    BA_Configuration__c bac = bacIdMap.get(qt.Id);
                    bac.Active__c= qt.Active;
                    //bac.BAC_Progress__c = qt.BAC_Progress;
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
                         /* PS1060931 start */
                    bac.tenderSubmissionDate__c = qt.tenderSubmissionDate;
                    bac.technicalOfferSubmissionDate__c = qt.technicalOfferSubmissionDate;
                         /* PS1060931 end */
                       
                    //to change the owner of campaign by admin
                    if(!String.isBlank(qt.newOwner)){
                        bac.OwnerId=qt.newOwner;
                    }
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
                    updateBAC.add(bac);
                    if(!bwcList.isEmpty()){
                        List<BAC_Team_Member__c> tmList = new List<BAC_Team_Member__c>();
                        for(bacWrapperClass bb : bwcList){
                            BAC_Team_Member__c bacTM = new BAC_Team_Member__c();
                            bacTM.BA_Configuration__c = bb.bac.Id;
                            bacTM.Team_Member_Name__c = bb.teamMemberUserId;
                            tmList.add(bacTM);
                        }
                        if(tmList.size()>0){
                            database.insert(tmList);
                        }
                 	} 
                 	result.add('Success');
                 	updateSuccess = true;
                }   
                    else{
                        result.add('The data is already updated!');
                        updateSuccess  = false;
                    }
            }
            if(updateBAC.size()>0){
            	database.update(updateBAC);
            }
            //Ends TM Code
            system.debug('updateBAC result'+ result);
            if(updateSuccess){
                return new CtrlKevlarSvcHelper.ReturnDropDownClass(h.dataSent, h.getMessage('200'),h.getResponseMessage('509'),'509',result, null, 'No Error');         
            }
            else{
                return new CtrlKevlarSvcHelper.ReturnDropDownClass(h.dataSent, h.getMessage('204'),null,null,null, null, 'No Error');          
            }
        }
        catch(Exception e){
            System.debug('Error----------'+e.getMessage());
            return new CtrlKevlarSvcHelper.ReturnDropDownClass(h.dataNotSent, h.getMessage('203'),'Update failed!',null, null, null, '203');
        }
    }
}