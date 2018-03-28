/*******************************************************************************
Copyright © 2014 DuPont. All rights reserved. 
Author: Abhinav Bhatnagar
Email: abhinav.bhatnagar@dupont.com
Description:  Salesforce To Salesforce Trigger. This trigger will execute after
each insert or update operation and call helper class to filter and send Opportunity
to Parksite if applicable.

<AB20150511>
Modified By: Abhinav Bhatnagar
Modification Date: 11-May-2015
Modification: Updated the for CLT-Surfaces Application Type also. 

<AB20160717>
Modified By: Abhinav Bhatnagar
Modification Date: 17-July-2016
Modification:Refining the Override filter criteria for Dodge and & Manual Opportunities for Parksite. 

<HN09122016>  
Modified By: Haider Naseem
Modification Date: 12-Sept-2016
Modification:Updated if condition as per IS ID-00073734 to fetch IDs based on API names

<PK20170123>
Modified By: Priya Kuntamukkala
Modification Date: 23-Jan-2017
Modification:Refining the Override filter for Dodge and & Manual Opportunities for Parksite. 
********************************************************************************/
trigger trigOppSFDCToSFDC on Opportunity (after insert, after update) {
    List<Opportunity> oppList = new List<Opportunity>();
    LIST<Opportunity> validOppList = new List<Opportunity>();
    private static final String CALLEDFROMTRIGGER = 'Trigger';
    private static final String AFTERINSERTEVENT = 'After Insert';
    private static final String AFTERUPDATEEVENT = 'After Update';
    private boolean forSFDC2SFDCPublishing = false;
    //Start <PK20170123> Using Map to query on the opportunity record type
    Map<String, Id> OpptyRecordTypesNameToIdMap=new Map<String,Id>();
    List<RecordType> OppRecordTypes=[SELECT Id, DeveloperName FROM RecordType WHERE SObjectType = 'Opportunity'];
    
    if(System.Label.Trigger_On_Off  == 'On'){  
    for(RecordType RecType:OppRecordTypes){
        OpptyRecordTypesNameToIdMap.put(RecType.DeveloperName,RecType.Id);
    }
    //End <PK20170123>
    
    for(Opportunity opp: Trigger.New){  
    
    if( Trigger.isUpdate && !String.isBlank(opp.Legacy_One_DuPont_SFID__c) && 
        ('End - Won'.equals(opp.StageName) || 
        'End - Lost'.equals(opp.StageName) || 
        'End-Lost'.equals(opp.StageName))){
       
         System.debug('#Do Not Migrate:');  
         // Code Added by SF Split Team. Should skip all Opportunities that meet below condition
         // Trigger is Update and legacy ID is not blank and Status in  End - Won, End - Lost, End-Lost
        
     }else{

    //<HN09122016>  Updated if condition as per IS ID-00073734 to fetch IDs based on API names
        if((opp.Application_Type__c!=null && opp.Application_Type__c!='' && ( opp.Application_Type__c=='CLT-Tyvek'
               || opp.Application_Type__c=='CLT-Surfaces')//<AB20150511>
          ) //Start <PK20170123> Modified If condition to reduce the count of SQL Queries
           ||(opp.RecordTypeId==OpptyRecordTypesNameToIdMap.get('BI_Canada_Tyvek_Opportunity') || opp.RecordTypeId==OpptyRecordTypesNameToIdMap.get('BI_EMEA_Surfaces') || opp.RecordTypeId==OpptyRecordTypesNameToIdMap.get('BI_EMEA_Typar')
               || opp.RecordTypeId==OpptyRecordTypesNameToIdMap.get('BI_NA_MHC_Opportunity') || opp.RecordTypeId==OpptyRecordTypesNameToIdMap.get('BI_NA_Opportunity')|| opp.RecordTypeId==OpptyRecordTypesNameToIdMap.get('BI_NA_Surfaces_Dodge')
               || opp.RecordTypeId==OpptyRecordTypesNameToIdMap.get('BI_NA_Surfaces_Manual'))
           /* (opp.RecordTypeId==RType.getIdByDevName('opportunity','BI_Canada_Tyvek_Opportunity') || opp.RecordTypeId==RType.getIdByDevName('opportunity','   BI_EMEA_Surfaces') || opp.RecordTypeId==RType.getIdByDevName('opportunity','BI_EMEA_Typar')
               || opp.RecordTypeId==RType.getIdByDevName('opportunity','BI_NA_MHC_Opportunity') || opp.RecordTypeId==RType.getIdByDevName('opportunity','BI_NA_Opportunity')|| opp.RecordTypeId==RType.getIdByDevName('opportunity','BI_NA_Surfaces_Dodge')
               || opp.RecordTypeId==RType.getIdByDevName('opportunity','BI_NA_Surfaces_Manual'))*/){//<AB20160717>
             //End <PK20170123>
            oppList.add(opp);      
            forSFDC2SFDCPublishing = true;
        }     
     
     }   
        
    }
    if(forSFDC2SFDCPublishing){
        
        ctrlOppSFDCToSFDC cos2s = new ctrloppSFDCToSFDC(oppList);

        if(Trigger.isAfter && Trigger.isUpdate){
            validOppList = cos2s.callSFDCToSFDC(CALLEDFROMTRIGGER,AFTERUPDATEEVENT);
        }else if(Trigger.isAfter && Trigger.isInsert){
            cos2s.callSFDCToSFDC(CALLEDFROMTRIGGER,AFTERINSERTEVENT);
        }
    }
    }
}