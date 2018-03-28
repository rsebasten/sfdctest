/*******************************************************************************
(C)2015
Author: krishnaveni duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  This class returns the my BAC input is userid.

Change History:                                                                  Date:  
1. PS 1060931 - Modified code to add new fields in Query                        7/02/2016 

 ********************************************************************************/
@RestResource(urlMapping='/MyBAC/*')
global class CtrlMyBACService{

     global class userWrapper{
        public String userId;
    }
     /* PS1060931 - added 2 fields in query */
    global static String generateQuery(){
        String queryString='SELECT Id,Name,OwnerId,Active__c,Source_of_IT__c,Body_Armor_Configuration_ID__c,BAC_Currency__c,BAC_Progress__c,technicalOfferSubmissionDate__c,tenderSubmissionDate__c,'+
               'Budget_for_Year_1__c,Budget_for_Year_2__c,Budget_for_Year_3__c,Closure_Reason__c,Closure_Remark__c,Created_by_IOS__c,'+
               'Created_date_IOS__c,End_Date__c,End_User_Name__c,End_User_Country__c,End_User_Region__c,last_modified_date_IOS__c,'+
               'last_modify_by_IOS__c,No_of_Helmets__c,Number_of_Helmets_Y1__c,Number_of_Helmets_Y2__c,Number_of_Helmets_Y3__c,'+
               'Number_of_Plates_Y1__c,Number_of_Plates_Y2__c,Number_of_Plates_Y3__c,Number_of_Plates__c,Number_of_Vest__c,Number_of_Vest_Y1__c,'+
               'Number_of_Vest_Y2__c,Number_of_Vest_Y3__c,Start_Date__c,Status__c,Total_Budget__c,Comment__c,Sensitive_Destination_Committee_Approv__c,LastModifiedDate,'+
               '(SELECT Team_Member_Name__c,Team_Member_Name__r.name,Active__c,Region__c,Country__c,Team_member_Name__r.role_in_kevlar__c,'+
               'Contact__c,Email__c FROM BAC_Team_Members__r) FROM BA_Configuration__c';
        return queryString;
    }
    
    @HttpPost
    global static CtrlKevlarSvcHelper.ReturnBACClass doPost(){
        CtrlKevlarSvcHelper h = new CtrlKevlarSvcHelper(); 
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        List<BA_Configuration__c> listBAC = new List<BA_Configuration__c>();
        List<BA_Configuration__c> baConfigResult = new List<BA_Configuration__c>();
        List<BA_Configuration__c> baConfigResult1= new List<BA_Configuration__c>();
        String query='';
        String queryTemp='';
        Integer PTS_Status = 0,TIP_Status = 0,TBS_Status = 0,SE_Status = 0,TCA_Status = 0,CC_Status = 0,NC_Progress = 0,RC_Progress = 0,SG_Progress = 0,SS_Progress = 0,SC_Progress = 0,PC_Progress = 0,CG_Progress = 0;
        Map<String,Integer> statusMap = new Map<String,Integer>();
        Map<String,Integer> progressMap = new Map<String, Integer>();
        List<String> progressList=new List<String>();
        List<String> statusList=new List<String>();
        
        try{
            system.debug('req.requestBody : ' + req.requestBody.toString());
            userWrapper userWrap = (userWrapper) JSON.deserialize(req.requestBody.toString(), userWrapper.class);     
            User loggedInUser=[Select Role_in_Kevlar__c from User where Id=:userWrap.userId AND IsActive=true];
            if(loggedInUser<>null && loggedInUser.Role_in_Kevlar__c.equalsIgnoreCase('Admin')){
                query=generateQuery();
                baConfigResult=Database.query(query);
            }
            else{
                query=generateQuery();
                query=query + ' WHERE OwnerId ='+ '\'' + userWrap.userId + '\'' + ' limit 1000';
                system.debug('in non admin query: ' + query);
                baConfigResult=Database.query(query);
                queryTemp=generateQuery();
                queryTemp=queryTemp + ' WHERE Id IN (Select BA_Configuration__c from BAC_Team_Member__c where Team_Member_Name__c =' + '\'' + userWrap.userId + '\'' +' ) LIMIT 1000';
                baConfigResult1=Database.query(queryTemp);
            }
            listBAC.addAll(baConfigResult);
            listBAC.addAll(baConfigResult1);
            listBAC.sort();
            
            Schema.DescribeFieldResult progressSchema = BA_Configuration__c.BAC_Progress__c.getDescribe();    
            List<Schema.PicklistEntry> c = progressSchema.getPicklistValues();		
            for(Integer i=0;i<c.size();i++){
                 progressList.add(c[i].getvalue());   
            }  
            Schema.DescribeFieldResult statusSchema = BA_Configuration__c.status__c.getDescribe();    
            List<Schema.PicklistEntry> statusValues = statusSchema.getPicklistValues();		
            for(Integer i=0;i<statusValues.size();i++){
                 statusList.add(statusValues[i].getvalue());   
            }
            for(BA_Configuration__c BACs :listBAC){
                //map for campaign status
                Integer count;
                if(statusMap.containsKey(BACs.status__c)){
                    count =statusMap.get(BACs.status__c); 
                }
                else{
                    count = 0;
                }
                count = count + 1; 
                statusMap.put(BACs.status__c,count);
                //map for campaign progress
                Integer progressCount;
                if(progressMap.containsKey(BACs.BAC_Progress__c)){
                    progressCount =progressMap.get(BACs.BAC_Progress__c); 
                }
                else{
                    progressCount = 0;
                }
                progressCount = progressCount + 1; 
                progressMap.put(BACs.BAC_Progress__c,progressCount);
            }
            
            for(String statusKey : statusList){
                Integer statusCount;
                if(statusMap.containsKey(statusKey)){
                    statusCount =statusMap.get(statusKey); 
                }
                else{
                   statusCount=0; 
                }
                statusMap.put(statusKey,statusCount);
            }
            for(String progressKey : progressList){
                Integer progressCount;
                if(progressMap.containsKey(progressKey)){
                    progressCount =progressMap.get(progressKey); 
                }
                else{
                   progressCount=0; 
                }
                progressMap.put(progressKey,progressCount);
            }
            return new CtrlKevlarSvcHelper.ReturnBACClass(h.dataSent, h.getMessage('200'),h.getResponseMessage('510'),'510',listBAC,progressMap,statusMap, null,'No Error');
        }
        catch(Exception e){
            System.debug('Error----------'+e.getMessage());
            return new CtrlKevlarSvcHelper.ReturnBACClass(h.dataNotSent, h.getMessage('203'),e.getMessage(),null,null, null, null,null, '203');
        }
    }
}