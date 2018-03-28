/*******************************************************************************
Copyright © 2014 DuPont. All rights reserved. 
Author: Abhinav Bhatnagar
Email: abhinav.bhatnagar@dupont.com
Description:  Helper Class for Salesforce To Salesforce Trigger and Batch. The
primary funtionality of the helper class is to-
1. Identify whether it is called from Trigger or Batch
2. If Trigger then Check Opportunity validity based on filters in custom settings
3. Transfer the Opportunity to Parksite if it is valid Opportunity
4. If Batch then take the opportunities and send them to Parksite
5. Check if Mail is to be sent (Currently disabled and not in bulk)

Updated
<AB20141111> updated End – Lost with End - Lost changed long hyphen with short hyphen in comments
<AB20141111> updated End – Won with End - Won changed long hyphen with short hyphen in comments
<AB20141211> replacing || with && to avoid nested statement becoming true everytime. This will work fine in Batch though
<AB20150223> updated --> status not in ('inactive','deleted') clause to reconsider unshared opportunities again, if they are updated
<AB20150430> updated for defect External Initiative Stage values like Pre-Planning, not being correctly filtered out
<AB20160416> updated for surfaces application type
<AB20160418> - Updated code to accommodate multiple accounts in the code for Surfaces
•   Parksite (FL) Surfaces
•   Parksite (IL) Surfaces - HQ
•   Parksite (NY) Surfaces
•   Parksite (OH) Surfaces
•   Parksite New England
//<AB20160511> Updated for Fixing App type for each opp and Filter Criteria
//<AB20160518> Updated for Fixing Filter Criteria From Custom Settings  for both Surfaces and Tyvek
//<AB20160601> Overriding filter criteria if opportunity description contains word Override
//<AB20160717> Refining the Override filter criteria for Dodge and & Manual Opportunities for Parksite

Updated
<AB20161205>
Author: Arjun Sharma
Email: arjun.sharma2@tcs.com
Description: Modified the logic to get valid opportunities for Parksite
********************************************************************************/


public without sharing class ctrlOppSFDCToSFDC {
    /* Global Private Constants used through out the class */
    public static Map<String, BINASFDCToSFDC__C> SFToSFCustomSettings { GET {return BINASFDCToSFDC__C.getAll(); }} //<AB20160416> updated for surfaces application type
    
    private static final String CUSTOMSETTINGSFDC2SFDC = 'BINASFDCToSFDC__C'; //Name of the custom settings from where filters needs to be fetched //<AB20160416> updated for surfaces application type
    private static final String CONNECTIONNAME = 'Parksite Inc'; //Name of the SFDC TO SFDC Connection
    private static final String CONNECTIONSTATUS = 'Accepted'; //Status of the connection should be Accepted
    private static final String CALLEDFROMTRIGGER = 'Trigger';
    private static final String CALLEDFROMBATCH = 'Batch';
    private static final String AFTERINSERTEVENT = 'After Insert';
    private static final String AFTERUPDATEEVENT = 'After Update';
    private static final boolean DOSENDMAIL = false; //Whether to send mail or not after the operation
    private static final String SOBJECTTYPE = 'Account'; 
    private static final String OVERRIDED = 'Override'; //<AB20160601> 
    
    private List<Opportunity> rawOppList {get;set;}//List of All Opportunities passed to this class by trigger whether valid or not
    private List<Opportunity> validOppList {get;set;}//List of Valid opportunities based on filter.
    
    /*Custom Settings Variables*/
    private Set<String> CustomSettingEISegmentL2 = new Set<String>();
    private Set<String> CustomSettingEISegmentL3 = new Set<String>();
    private Set<String> CustomSettingEIStage = new Set<String>();
    private Set<ID> CustomSettingsAccountIDs {get;set;} //<AB20160418>   
    private String CustomSettingOppRecordType {get;set;}
    private String CustomSettingApplicationType {get;set;}
    private String CustomSettingOppStageEndLost {get;set;} 
    private String CustomSettingOppStageEndWon {get;set;}  
    private Date CustomSettingCloseDate {get;set;}
    private Integer CustomSettingValue {get;set;} 
    
    /* Getter Setter to Send mail*/
    private boolean sendMail{get{
        if(Test.isRunningTest()) {
            return true;
        }else{
            return sendMail;
        }
    }
                             set;
                            } //Send mail property 
    
    //<AB20160416> updated for surfaces application type
    private void resetValues(){
        
       CustomSettingEISegmentL2.clear();
        CustomSettingEISegmentL3.clear();
        CustomSettingEIStage.clear();
        CustomSettingApplicationType ='';
        CustomSettingOppStageEndLost ='';
        CustomSettingOppStageEndWon ='';
        CustomSettingValue = 0;
    }    
    
    public ctrlOppSFDCToSFDC(List<Opportunity> oppList){ // Constructor to take Opportunity List and set Send Mail property
        this.rawOppList = oppList; 
    }
    
    public ctrlOppSFDCToSFDC(List<Opportunity> oppList, boolean sendMailOption){ // Constructor to take Opportunity List and set Send Mail property
        this.rawOppList = oppList; 
        sendMail = sendMailOption;
    }
    public LIST<Opportunity> callSFDCToSFDC(String strCalledFrom, String trigCriteria){ // Public facing method to call SFDC To SFDC functionality       
        
        //LoadCustomSettings();//<AB20160416> updated for surfaces application type
        pushOpportunityRecords(strCalledFrom, trigCriteria);
        
        return validOppList;
    }
    
    private void LoadCustomSettings(String strApplicationType){//<AB20160416> updated for surfaces application type
        try{
            //<AB20160416> updated for surfaces application type
            resetValues();
            String strPrefixCS = 'TS_'    ;
            if(strApplicationType!='' && strApplicationType.equalsIgnoreCase('CLT-Tyvek')){  
                strPrefixCS = 'T_';
            }else if(strApplicationType!='' && strApplicationType.equalsIgnoreCase('CLT-Surfaces')){ 
                strPrefixCS = 'S_';
            }
            
            for(String key:SFToSFCustomSettings.keySet()){
                if(key.contains(strPrefixCS+'EI_Segment_L2')){
                    CustomSettingEISegmentL2.add(SFToSFCustomSettings.get(key).Value__c);
                }else if(key.contains(strPrefixCS+'EI_Segment_L3')){
                    CustomSettingEISegmentL3.add(SFToSFCustomSettings.get(key).Value__c);
                }else if(key.contains('TS_EI_Stage')){
                    CustomSettingEIStage.add(SFToSFCustomSettings.get(key).Value__c); //<AB20150430> Defect CustomSettingEISegmentL2.add(mapOfCustomSettings.get(key).Value__c);
                }
            }
            //<AB20160418> Start
            List<String>accNames = SFToSFCustomSettings.get(strPrefixCS+'Account').value__c.split(',');
            
            CustomSettingsAccountIDs = new Set<Id>();
            For(Account acc : [Select id from Account where name in : accNames ]){
                CustomSettingsAccountIDs.add(acc.id);
            }//<AB20160418> End
            String oppRT = SFToSFCustomSettings.get(strPrefixCS+'Opportunity_Record_Type').value__c;
            RecordType OppRecType = [SELECT Name, Id FROM RecordType where name = : oppRT limit 1];
            
            
            CustomSettingOppRecordType = OppRecType.id;
            
            CustomSettingApplicationType = SFToSFCustomSettings.get(strPrefixCS+'Application_Type').value__c;                
            CustomSettingValue = Integer.valueOf(SFToSFCustomSettings.get(strPrefixCS+'EI_Value').value__c);
            CustomSettingOppStageEndLost= SFToSFCustomSettings.get('TS_Opportunity_Stage_End_Lost').value__c;
            CustomSettingOppStageEndWon = SFToSFCustomSettings.get('TS_Opportunity_Stage_End_Won').value__c;
            CustomSettingCloseDate =  Date.parse(SFToSFCustomSettings.get('TS_Close_Date').value__c);
            sendMail = SFToSFCustomSettings.get('TS_SendMail')!= null? (Boolean.valueOf(SFToSFCustomSettings.get('TS_Send_Mail').value__c)): DOSENDMAIL;       
            
            
        }Catch(Exception e)  {
            System.debug('Error Occured in Loading Custom Settings \n'+e.getStackTraceString());
        }    
        
    }
    /* Method to push opportunities from One DuPont to Other Org */
    private void pushOpportunityRecords(String strCalledFrom, String trigCriteria){
        if(strCalledFrom == CALLEDFROMTRIGGER){ // Check whether trigger has called the method 
            validOppList = getValidOpportunities(rawOppList,trigCriteria); // Get valid opportunities based on the raw list of opportunities provided
        }else if(strCalledFrom == CALLEDFROMBATCH){// Check whether batch has called the method
            validOppList = rawOppList; //Assign the raw list directly as the list is already validated through query fetching.
        }else{
            validOppList = new List<Opportunity>(); //Default exit statement
        } 
        if(validOppList!=null && validOppList.size()>0){//if There is any opportunity to be transffered
            PartnerNetworkConnection pncObject =  getPartnerNetworkConnection();//Get the Partner Network Connection 
            List<PartnerNetworkRecordConnection> pnrcObject = new List<PartnerNetworkRecordConnection>();
            for(Opportunity opp : validOppList) { // For each valid opportunity to be sent   
                PartnerNetworkRecordConnection newrecord = new PartnerNetworkRecordConnection();            
                newrecord.ConnectionId = pncObject.Id;
                newrecord.LocalRecordId = opp.id;  
                pnrcObject.add(newrecord);   
            }   
            
            sendMail = sendMail==null?false:sendmail;
            if(Test.isRunningTest()){// If mail is to be sent
                doSendMail(validOppList);
            }else{  
                try{
                    insert pnrcObject; //Send the opportunities if not a test
                }catch(Exception e){                    
                    System.debug(' In Method ---> pushOpportunityRecords Error occured '+e);
                }
                if(sendMail){
                    doSendMail(validOppList);
                }                
            }
        }
    }
    
    /* Method to return valid list of opportunities which are not sent yet to Parksite */
    private List<Opportunity> getValidOpportunities(List<Opportunity> rawOppList, String trigCriteria){
        List<Opportunity> validOppListByOppFilter = new  List<Opportunity>();
        List<Opportunity> validOppListByOverrideFilter = new  List<Opportunity>();
        List<Opportunity> validOppListByEIFilter = new  List<Opportunity>();
        /*Fetch UserRole for each user in opportunity Owner <AB20160717> starts*/
        List<Id> usersId = new List<Id>();
        for(Opportunity opp: rawOppList){
            usersId.add(opp.ownerId);
        }
        List<User> users =  [Select UserRole.Name from user where id in:usersId];
        Map<id,String> userRolesMap = new Map<id,String>();
        
        for(User usr: users){
            userRolesMap.put(usr.id, usr.UserRole.Name);
        }
        
        
        
        for(Opportunity opp: rawOppList){        
            if(opp.Application_Type__c != null && !opp.Application_Type__c.equalsIgnoreCase(CustomSettingApplicationType)){
                LoadCustomSettings(opp.Application_Type__c);
            }
  
          if(validateOpportunityByOpp(opp)){//<AB20160601>, <AB20160717>
                validOppListByOppFilter.add(opp);
              }else if(
               ((opp.Description!=NULL&&opp.AccountId!=null)?(((Account)Util.getRecord('Account', opp.AccountId)).Name.containsIgnoreCase('Parksite')&&opp.Description.containsIgnoreCase(OVERRIDED)):False) ||
               ((opp.Description!=NULL&&userRolesMap.get(opp.OwnerId)!=null)?(userRolesMap.get(opp.OwnerId).containsIgnoreCase('Parksite')&&opp.Description.containsIgnoreCase(OVERRIDED)):False)
              ){
                  validOppListByOverrideFilter.add(opp);
              }
        }
        validOppListByEIFilter =  validateOpportunityByEI(validOppListByOppFilter);//by passing EI filter for Override
        validOppListByEIFilter.addAll(validOppListByOverrideFilter);
        /*<AB20160717> Ends*/
        if(trigCriteria==AFTERINSERTEVENT){
            return validOppListByEIFilter;
        }else if(trigCriteria==AFTERUPDATEEVENT){
            return notSentValidOppList(validOppListByEIFilter);
        }else {
            return new List<Opportunity>();
        }
        
    }
    
    /*Method to validate Opportunities based on the filter criteria in the  custom settings*/
    private boolean validateOpportunityByOpp(Opportunity opp){
        try{
            MAP <String, Object> mp = prepareMAP(opp);
            boolean decision = compareValues(mp);
            return decision;
        }catch(Exception e){
            system.debug(e.getStackTraceString());
            return false;
        }
    }
    //<AB20160416> updated for surfaces application type
    //<AB20160511> Updated for Fixing App type for each opp and Filter Criteria
    private List<Opportunity> validateOpportunityByEI(LIST<Opportunity> validOppListByOppFilter){
        try{
            LIST<Opportunity> validOppListByEIFilter = new LIST<Opportunity>();
            LIST<Opportunity> OppListByEIFilterForTyvek = new LIST<Opportunity>();
            LIST<Opportunity> OppListByEIFilterForSurfaces = new LIST<Opportunity>();
            LIST<Opportunity> ValidOppListByEIFilterForTyvek = new LIST<Opportunity>();
            LIST<Opportunity> ValidOppListByEIFilterForSurfaces  = new LIST<Opportunity>();
            
            //<AB20161205> Start
            List<opportunity> lstOppEIValid = new List<opportunity>();
            List<opportunity> lstOppEI = new List<opportunity>();
            //<AB20161205> End
            
            For(Opportunity opp: validOppListByOppFilter){
                if(opp.Application_Type__c.equalsIgnoreCase('CLT-Tyvek')){
                    if(opp.Description!=NULL && opp.Description.containsIgnoreCase(OVERRIDED)){//<AB20160601>
                        ValidOppListByEIFilterForTyvek.add(opp);
                    }else{
                        OppListByEIFilterForTyvek.add(opp);
                    }
                    
                }else if(opp.Application_Type__c.equalsIgnoreCase('CLT-Surfaces')){
                    if(opp.Description!=NULL && opp.Description.containsIgnoreCase(OVERRIDED)){//<AB20160601>
                        ValidOppListByEIFilterForSurfaces.add(opp);
                    }else{
                        OppListByEIFilterForSurfaces.add(opp);
                    }
                }
            }
            
            //<AB20161205> Start
            LoadCustomSettings('CLT-Tyvek');//<AB20160518> Load Tyvek Custom Settings
            /*ValidOppListByEIFilterForTyvek.addAll((OppListByEIFilterForTyvek!=null && OppListByEIFilterForTyvek.size()>0)? [SELECT ID,Name,External_Initiative__c,External_Initiative__r.Segment_L2__c,External_Initiative__r.Segment_L3__c FROM Opportunity 
                                                                                                                            where id in : OppListByEIFilterForTyvek 
                                                                                                                            AND External_Initiative__r.Segment_L2__c not in : CustomSettingEISegmentL2 
                                                                                                                            AND External_Initiative__r.Value__c >= : CustomSettingValue
                                                                                                                            AND External_Initiative__r.Segment_L3__c in : CustomSettingEISegmentL3
                                                                                                                            AND External_Initiative__r.Stage__c not in : CustomSettingEIStage
                                                                                                                            LIMIT 1000]:new LIST<Opportunity>()
                                                 );*/
            
            
            if(OppListByEIFilterForTyvek!=null && OppListByEIFilterForTyvek.size()>0){
                lstOppEI = [SELECT ID,Name,External_Initiative__c,External_Initiative__r.Segment_L2__c,External_Initiative__r.Segment_L3__c FROM Opportunity 
                            where id in : OppListByEIFilterForTyvek 
                            AND External_Initiative__r.Value__c >= : CustomSettingValue
                            AND External_Initiative__r.Stage__c not in : CustomSettingEIStage
                            LIMIT 1000];
                if(lstOppEI != null){
                    lstOppEIValid = getValidEIFilterOpps(lstOppEI,'CLT-Tyvek');
                    System.debug(Logginglevel.error,'@@@@@@@@ValidOpp'+lstOppEIValid);
                }
            }else{
               lstOppEIValid = new LIST<Opportunity>();
            }                                             
            
            
            ValidOppListByEIFilterForTyvek.addAll(lstOppEIValid);
            
            LoadCustomSettings('CLT-Surfaces');//<AB20160518> Load Surfaces Custom Settings
            /*ValidOppListByEIFilterForSurfaces.addAll((OppListByEIFilterForSurfaces!=null && OppListByEIFilterForSurfaces.size()>0)? [SELECT ID,Name,External_Initiative__c FROM Opportunity 
                                                                                                                                     where id in : OppListByEIFilterForSurfaces 
                                                                                                                                     AND External_Initiative__r.Segment_L2__c in : CustomSettingEISegmentL2 
                                                                                                                                     AND External_Initiative__r.Value__c >= : CustomSettingValue
                                                                                                                                     AND External_Initiative__r.Stage__c not in : CustomSettingEIStage
                                                                                                                                     LIMIT 1000]:new LIST<Opportunity>()
                                                    );*/
            if(OppListByEIFilterForSurfaces!=null && OppListByEIFilterForSurfaces.size()>0){
                lstOppEI=null;
                lstOppEIValid=null;
                lstOppEI = [SELECT ID,Name,External_Initiative__c,External_Initiative__r.Segment_L2__c,External_Initiative__r.Segment_L3__c FROM Opportunity 
                            where id in : OppListByEIFilterForSurfaces
                            AND External_Initiative__r.Value__c >= : CustomSettingValue
                            AND External_Initiative__r.Stage__c not in : CustomSettingEIStage
                            LIMIT 1000];
                if(lstOppEI != null){
                    lstOppEIValid = getValidEIFilterOpps(lstOppEI,'CLT-Surfaces');
                    System.debug(Logginglevel.error,'@@@@@@@@ValidOpp'+lstOppEIValid);
                }
            }else{
               lstOppEIValid = new LIST<Opportunity>();
            }
            ValidOppListByEIFilterForSurfaces.addAll(lstOppEIValid);
            //<AB20161205> End
            
            validOppListByEIFilter.addAll(ValidOppListByEIFilterForTyvek);            
            validOppListByEIFilter.addAll(ValidOppListByEIFilterForSurfaces);
            Integer iCounter = 0;
            return validOppListByEIFilter;
        }Catch(Exception e){
            system.debug('Error Occured while validating filter External Initiative for opportunities '+e.getStackTraceString());
            return new LIST<Opportunity> ();
        }
    }
    
    /* Method to return Map for the Opportunity with all the assoicated metadata */    
    private MAP<String, Object> prepareMAP(Opportunity opp){
        MAP <String, Object> mapOfOpportunities = new MAP <String,Object>();
        try{
            mapOfOpportunities.put('Account', opp.accountid != null?opp.accountid : '');
            mapOfOpportunities.put('Opportunity Record Type', opp.recordtypeid);
            mapOfOpportunities.put('Application Type', opp.Application_Type__c != null ? opp.Application_Type__c : '');
            mapOfOpportunities.put('Stage', opp.StageName != null ? opp.StageName : '');
            mapOfOpportunities.put('Close Date', opp.CloseDate != null ?  opp.CloseDate : Date.newInstance(2013, 1, 1));
            
           }catch(Exception e){
               system.debug('Error Occured while fetching Opportunity Attribute '+e.getStackTraceString());
           }
        return mapOfOpportunities;
        
    }
    
    /*Filter Criteria -
Account  is Parksite (FL) Surfaces, Parksite (IL) Surfaces - HQ, Parksite (NY) Surfaces,    Parksite (OH) Surfaces, Parksite New England //<AB20160418>
Opportunity Record Type is ‘BI-NA MHC Opportunity’
Other Validation Criteria -
External Initiative Value greater or equal to "2,500,000"
AND Segment L2 does not contain Animal/Plant,Bath/Beach,Bowling,Communications,Custom House,Factories,Flood Dam,
Other Terminal, Parks/Playground, Prisons, Spec Houses, Special, Swim Pools, Warehouse Other, Warehouse Refrigerated, Water Treatment
AND Stage not equal to any of the Pre-Planning, Occupancy, Abandoned, Deferred
AND Segment L3 equal to Building Additions, New Construction
AND Application Type equal to  CLT-Tyvek
AND Stage not equal to End - Lost OR End - Won .<AB20141111> 
AND Close Date greater OR equal 1/1/2013
Method to compare values between each opportunity Metadata and fetched custom settings value to validate it */
    private boolean compareValues(MAP<String,Object> mapOfOpportunities){
        try{
            boolean isValidOpp = ( CustomSettingsAccountIDs.contains(((Id)mapOfOpportunities.get('Account'))) && //<AB20160418>
                                  mapOfOpportunities.get('Opportunity Record Type') == Id.valueOf(CustomSettingOppRecordType) &&
                                  mapOfOpportunities.get('Application Type') == CustomSettingApplicationType && 
                                  ( mapOfOpportunities.get('Stage') != CustomSettingOppStageEndLost && //<AB20141211> replacing || with && to avoid nested statement becoming true everytime. This will work fine in Batch though 
                                   mapOfOpportunities.get('Stage') != CustomSettingOppStageEndWon ) && 
                                  Date.valueOf(mapOfOpportunities.get('Close Date'))  >= CustomSettingCloseDate
                                  
                                 );             
            
           return isValidOpp;
        }catch(Exception e){
            system.debug(e.getMessage());
            return false;
        }
    }
    
    
    /* Method to check if the opportunties are not sent already to Parksite*/
    private List<Opportunity> notSentValidOppList(List<Opportunity> validOppList){//Valid Opportunities but yet to determine is sent already to Parksite or not
        
        List<Opportunity> notSentValidOpportunity = new List<Opportunity>();
        List<PartnerNetworkRecordConnection> existingRecordsList = [select Id, Status, ConnectionId, LocalRecordId from PartnerNetworkRecordConnection where LocalRecordId  IN : validOppList AND status not in ('inactive','deleted')];//<AB20152302> updated --> status not in ('inactive','deleted') clause to reconsider unshared opportunities again, if they are updated
        Set<ID> existingRecordsSet = new Set<ID>();
        for(PartnerNetworkRecordConnection ers:existingRecordsList){//Get List of all the Opportunities already sent
            existingRecordsSet.add(ers.LocalRecordId);
        }
        
        for(Opportunity opp: validOppList){
            if(!existingRecordsSet.contains(opp.id)){//If Opportunity does not exist in the existing RecordSet is not sent already
                notSentValidOpportunity.add(opp);
            }
        }
        
        return notSentValidOpportunity;
    }
    
    /* Method to fetch valid partner network connection */
    private PartnerNetworkConnection getPartnerNetworkConnection(){
        List<PartnerNetworkConnection> connMap = new List<PartnerNetworkConnection>(
            [select Id, ConnectionStatus, ConnectionName from PartnerNetworkConnection where ConnectionStatus = : CONNECTIONSTATUS and ConnectionName  = : CONNECTIONNAME LIMIT 1]
        );
        
        return connMap[0];
    } 
    
    /* Send the mail on the List of Opportunities */
    private void doSendMail(List<Opportunity> Opportunities){
        Messaging.reserveSingleEmailCapacity(2);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        String[] toAddresses = new String[] {'abhinav.bhatnagar@ind.dupont.com'}; 
            String[] ccAddresses = new String[] {'abhinav.bhatnagar@dupont.com'};
                
                mail.setToAddresses(toAddresses);
        mail.setCcAddresses(ccAddresses);
        mail.setReplyTo('abhinav.bhatnagar@dupont.com');
        mail.setSenderDisplayName('Salesforce Support');
        mail.setSubject('New Opportunity(s) Pushed ');
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.setHtmlBody(getHTMLBody(Opportunities));
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
    }
    
    /* Convert list of opportunities into more readable format */
    private String getHTMLBody(List <Opportunity> listOpportunities){
        String strHTMLBody ='';
        strHTMLBody = strHTMLBody +' <html>';
        for(Opportunity opp: listOpportunities){
            strHTMLBody = strHTMLBody +'Your Opportunity: '+opp.name;
            strHTMLBody = strHTMLBody +'<Table>';
            strHTMLBody = strHTMLBody +'<th>Attributes</th><th>Values</th>';
            strHTMLBody = strHTMLBody + '<tr><td> Name</td><td>'+opp.Name+'</td></tr>';
            strHTMLBody = strHTMLBody + '</table>';
        }
        strHTMLBody = strHTMLBody + ' has been created and pushed to Parksite (Pending for approval).';
        strHTMLBody = strHTMLBody + '</html>';
        
        return strHTMLBody;
    }
        
    /*<AB20161205> Start get valid opporunity filter by EI*/
    private List<Opportunity> getValidEIFilterOpps(List<Opportunity> lstOppEIs,String applicationType){
        List<Opportunity> lstOpp = new List<Opportunity>();
        boolean blnSegmentL2Check = false;
        boolean blnSegmentL3Check = false;
        boolean blnValidOpp = false;
        for(Opportunity opp : lstOppEIs){
            if(opp.External_Initiative__r.Segment_L2__c != null){
                for(String segmentL2Token : opp.External_Initiative__r.Segment_L2__c.split(',')){
                    if(CustomSettingEISegmentL2.contains(segmentL2Token)){
                        System.debug(Logginglevel.error,'############SegmentL2 '+segmentL2Token);
                        blnSegmentL2Check = true;
                        break;
                    }
                }
            }
            if(opp.External_Initiative__r.Segment_L3__c != null){
                for(String segmentL3Token : opp.External_Initiative__r.Segment_L3__c.split(',')){
                    if(CustomSettingEISegmentL3.contains(segmentL3Token)){
                        System.debug(Logginglevel.error,'############SegmentL3 '+segmentL3Token);
                        blnSegmentL3Check = true;
                        break;
                    }
                }
            }
            System.debug(Logginglevel.error,'############blnSegmentL2Check '+blnSegmentL2Check +'############blnSegmentL3Check '+blnSegmentL3Check);
            if(applicationType == 'CLT-Tyvek' && !blnSegmentL2Check && blnSegmentL3Check){
                lstOpp.add(opp);
            }else if(applicationType == 'CLT-Surfaces' && blnSegmentL2Check){
                lstOpp.add(opp);
            }
            blnSegmentL2Check = false;
            blnSegmentL3Check = false;
        }
        return lstOpp;
    }
    /*<AB20161205> End*/
}