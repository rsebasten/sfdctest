/*******************************************************************************
(C)2015
Author: krishnaveni duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  This class contains the methods and the inner class that is used in the other classes


Change History:                                                                  Date:  
1. PS 1060931 - Modified code to add new fields and wrapper structure           6/30/2016 

********************************************************************************/

global class CtrlKevlarSvcHelper{
public final Boolean dataSent = true;
public final Boolean dataNotsent = false;
public String message;
public String responseMessage;
    
public String getMessage(String msg){
    Kevlar_Response_Messages__c kevlar_msg = Kevlar_Response_Messages__c.getInstance(msg);
    message = kevlar_msg.Message__c;
    return message;
}

public String getResponseMessage(String resmsg){
    Kevlar_Response_Messages__c kevlar_msg = Kevlar_Response_Messages__c.getInstance(resmsg);
    responseMessage = kevlar_msg.Response_Message__c;
    return responseMessage;
}


global class ReturnClass {
    global Boolean success;
    global String message;
    global String responseMessage;
    global String responseCode;
    global List<Sobject> records;
    global String prettyJSON;
    global String currentDateTime;
    global String ErrorCode;
    global ReturnClass(Boolean success, String message,String responseMessage,String responseCode,List<Sobject> records, String currentDateTime, String ErrorCode) {
        this.success = success;
        this.message = message;
        this.responseMessage = responseMessage;
        this.responseCode = responseCode;
        this.records = records;
        this.currentDateTime=currentDateTime;
        this.ErrorCode=ErrorCode;  
    }
    global ReturnClass(Boolean success, String message,String responseMessage,String responseCode,String prettyJSON, 
                       String currentDateTime, String ErrorCode,String temp){
        this.success = success;
        this.message = message;
        this.responseMessage = responseMessage;
        this.responseCode = responseCode;
        this.prettyJSON = prettyJSON;
        this.currentDateTime=currentDateTime;
        this.ErrorCode=ErrorCode;
    }
}

global class ReturnDropDownClass {
    global Boolean success;
    global String message;
    global String responseMessage;
    global String responseCode;
    global List<String> records;
    global String currentDateTime;
    global String ErrorCode;
    global ReturnDropDownClass (Boolean success, String message,String responseMessage,String responseCode,List<String> records, String currentDateTime, String ErrorCode) {
        this.success = success;
        this.message = message;
        this.responseMessage = responseMessage;
        this.responseCode = responseCode;
        this.records = records;
        this.currentDateTime=currentDateTime;
        this.ErrorCode=ErrorCode;
    }
}

global class ReturnBASolutionDropDownClass{
    global Boolean success;
    global String message;
    global String responseMessage;
    global String responseCode;
    global List<String> numberOfLayers;
    global String currentDateTime;
    global String ErrorCode;
    global ReturnBASolutionDropDownClass(Boolean success, String message,String responseMessage,String responseCode,List<String> numberOfLayers, String currentDateTime, String ErrorCode) {
        this.success = success;
        this.message = message;
        this.responseMessage = responseMessage;
        this.responseCode = responseCode;
        this.numberOfLayers = numberOfLayers;
        this.currentDateTime=currentDateTime;
        this.ErrorCode=ErrorCode;
    }
}

global class ReturnThreatDefaultDropDownClass {
    global Boolean success;
    global String message;
    global String responseMessage;
    global String responseCode;
    global List<String> shotLocation;
    global List<String> shootingMechnism;
    global List<String> numberOfShots;
    global List<String> angledShots;
    global List<String> energyLevel;
    global List<String> jouleList;
    global List<String> permissiblePenetrationList;
    global List<String> numberOfStabs;
    global List<String> stabLocations;
    global List<String> angleNBT;
    global List<String> VelocityV50;
    global List<String> FragmentV50; 
    global List<String> TestStandard;
    global List<String> threatLevel;
    global String currentDateTime;
    global String ErrorCode;
    global ReturnThreatDefaultDropDownClass (Boolean success, String message,String responseMessage,String responseCode,List<String> shotLocation,List<String> shootingMechnism,List<String> numberOfShots,List<String> angledShots,List<String> energyLevel,List<String> jouleList,List<String> permissiblePenetrationList,List<String> numberOfStabs,List<String> stabLocations,List<String> angleNBT,List<String> VelocityV50,List<String> FragmentV50,List<String> TestStandard, List<String> threatLevel,String currentDateTime, String ErrorCode) {
        this.success = success;
        this.message = message;
        this.responseMessage = responseMessage;
        this.responseCode = responseCode;
        this.shotLocation = shotLocation;
        this.shootingMechnism = shootingMechnism;
        this.numberOfShots = numberOfShots;
        this.angledShots = angledShots;
        this.energyLevel = energyLevel;
        this.jouleList = jouleList;
        this.permissiblePenetrationList = permissiblePenetrationList;
        this.numberOfStabs= numberOfStabs;
        this.stabLocations= stabLocations;
        this.angleNBT = angleNBT;
        this.VelocityV50 = VelocityV50;
        this.FragmentV50  = FragmentV50;
        this.TestStandard = TestStandard;
        this.threatLevel = threatLevel;
        this.currentDateTime=currentDateTime;
        this.ErrorCode=ErrorCode;
    }
}

global class ReturnColorDropDownClass {
    global Boolean success;
    global String message;
    global String responseMessage;
    global String responseCode;
    global Map<String, String> colorMap;
    global String currentDateTime;
    global String ErrorCode;
    global ReturnColorDropDownClass (Boolean success, String message,String responseMessage,String responseCode,Map<String, String> colorMap, String currentDateTime, String ErrorCode) {
        this.success = success;
        this.message = message;
        this.responseMessage = responseMessage;
        this.responseCode = responseCode;
        this.colorMap = colorMap;
        this.currentDateTime=currentDateTime;
        this.ErrorCode=ErrorCode;
    }
}

global class ReturnBACClass {
    global Boolean success;
    global String message;
    global String responseMessage;
    global String responseCode; 
    global List<Sobject> records;
    global Map<String,Integer> statusCount;
    global Map<String, Integer> progressCount;
    global String currentDateTime;
    global String ErrorCode;   
    global ReturnBACClass(Boolean success, String message,String responseMessage, String responseCode,List<Sobject> records,Map<String,Integer> progressCount,Map<String, Integer> statusCount,String currentDateTime, String ErrorCode) {
        this.success = success;
        this.message = message;
        this.responseMessage = responseMessage;
        this.responseCode = responseCode;
        this.records = records;
        this.statusCount = statusCount;
        this.progressCount = progressCount;
        this.currentDateTime=currentDateTime;
        this.ErrorCode=ErrorCode;
    }
}

global class ReturnDesignClass{
    global Boolean success;
    global String message;
    global String responseMessage;
    global String responseCode;
    global List<String> bpDesign;
    global List<String> fpDesign;
    global List<String> spDesign;
    global String currentDateTime;
    global String ErrorCode;
    global ReturnDesignClass(Boolean success, String message,String responseMessage,String responseCode,  List<String> bpDesign,List<String> fpDesign,List<String> spDesign, String currentDateTime, String ErrorCode) {
        this.success = success;
        this.message = message;
        this.responseMessage = responseMessage;
        this.responseCode = responseCode;
        this.bpDesign= bpDesign;
        this.fpDesign= fpDesign;
        this.spDesign= spDesign;
        this.currentDateTime=currentDateTime;
        this.ErrorCode=ErrorCode;
    }
}

global class ReturnThreatMasterClass {
    global Boolean success;
    global String message;
    global String responseMessage;
    global String responseCode;
    global String records;
    global String currentDateTime;
    global String ErrorCode;
    global ReturnThreatMasterClass(Boolean success, String message,String responseMessage,String responseCode,String records, String currentDateTime, String ErrorCode) {
        this.success = success;
        this.message = message;
        this.responseMessage = responseMessage;
        this.responseCode = responseCode;
        this.records = records;
        this.currentDateTime=currentDateTime;
        this.ErrorCode=ErrorCode;
    }
}
global class ReturnCountryRegionClass {
    global Boolean success;
    global String message;
    global String responseMessage;
    global String responseCode;
    global Map<String,List<String>> region_country;
    global String currentDateTime;
    global String ErrorCode;
    global ReturnCountryRegionClass (Boolean success, String message,String responseMessage,String responseCode, Map<String,List<String>> region_country,String currentDateTime, String ErrorCode) {
        this.success = success;
        this.message = message;
        this.responseMessage = responseMessage;
        this.responseCode = responseCode;
        this.region_country= region_country;
        this.currentDateTime=currentDateTime;
        this.ErrorCode=ErrorCode;
    }
} 
global class ReturnBASReturnClass {
    global Boolean success;
    global String message;
    global String responseMessage;
    global List<Sobject> HAP;
    global List<Sobject> SAP;
    global String currentDateTime;
    global String ErrorCode;
    global ReturnBASReturnClass(Boolean success, String message,String responseMessage, List<Sobject> HAP,List<Sobject> SAP,String currentDateTime, String ErrorCode) {
        this.success = success;
        this.message = message;
        this.responseMessage = responseMessage;
        this.HAP= HAP;
        this.SAP= SAP;
        this.currentDateTime=currentDateTime;
        this.ErrorCode=ErrorCode;
    }
}
global class ReturnFDRReturnClass{
    global Boolean success;
    global String message;
    global String responseMessage;
    global List<Sobject> records;
    global String currentDateTime;
    global String ErrorCode;
    global ReturnFDRReturnClass(Boolean success, String message,String responseMessage, List<Sobject> records,String currentDateTime, String ErrorCode) {
        this.success = success;
        this.message = message;
        this.responseMessage = responseMessage;
        this.records= records;
        this.currentDateTime=currentDateTime;
        this.ErrorCode=ErrorCode;
    }
}

global class ReturnGetFDRDetailsClass{
    global Boolean success;
    global String message;
    global String responseMessage;
    global String responseCode;
    global String records;
    global String currentDateTime;
    global String ErrorCode;
    global ReturnGetFDRDetailsClass(Boolean success, String message,String responseMessage,String responseCode, String records,String currentDateTime, String ErrorCode) {
        this.success = success;
        this.message = message;
        this.responseMessage = responseMessage;
        this.responseCode = responseCode;
        this.records= records;
        this.currentDateTime=currentDateTime;
        this.ErrorCode=ErrorCode;
    }
}

global class ReturnOtherDropDownClass{
    global Boolean success;
    global String message;
    global String responseMessage;
    global String responseCode;
    global List<String> flammabilityStandard;
    global List<String> panelFlexibility;
    global List<String> thirdpartyTesting;
    global List<String> testLaboratory;
    global List<String> informationTechList;
    global String currentDateTime;
    global String ErrorCode;   
    global ReturnOtherDropDownClass(Boolean success, String message,String responseMessage,String responseCode,List<String> flammabilityStandard,List<String> panelFlexibility,List<String> testLaboratory,List<String> thirdpartyTesting,List<String> informationTechList,String currentDateTime, String ErrorCode) {
        this.success = success;
        this.message = message;
        this.responseMessage = responseMessage;
        this.responseCode = responseCode;
        this.flammabilityStandard= flammabilityStandard;
        this.panelFlexibility= panelFlexibility;
        this.thirdpartyTesting= thirdpartyTesting;
        this.testLaboratory= testLaboratory;
        this.informationTechList = informationTechList;
        this.currentDateTime=currentDateTime;
        this.ErrorCode=ErrorCode;
    }
}
global class ReturnFDRDimensionsClass{
    global Boolean success;
    global String message;
    global String responseMessage;
    global String responseCode;
    global Map<String, String> sapLL;
    global Map<String, String> sapUL;
    global Map<String, String> sapFactor;
    global Map<String, String> sapMiddleValue_M;
    global Map<String, String> hapFPMiddleValue_M;
    global Map<String, String> hapBPMiddleValue_M;
    global Map<String, String> hapSPMiddleValue_M;
    global Map<String, String> hapBPLL;
    global Map<String, String> hapBPUL;
    global Map<String, String> hapBPFactor;
    global Map<String, String> hapFPLL;
    global Map<String, String> hapFPUL;
    global Map<String, String> hapFPFactor;
    global Map<String, String> hapSPLL;
    global Map<String, String> hapSPUL;
    global Map<String, String> hapSPFactor; 
    global Map<String, Decimal> outerCarrierweightMap; /* PS1060931 */
    global Map<String, Decimal> sapPouchweightMap; /* PS1060931 */
    global String currentDateTime;
    global String ErrorCode;
    /* PS1060931 start*/
    global ReturnFDRDimensionsClass(Boolean success, String message,String responseMessage,String responseCode, Map<String, String> sapLL,Map<String, String> sapUL,Map<String, String> sapFactor,Map<String, String> sapMiddleValue_M,Map<String, String> hapBPLL,Map<String, String> hapBPUL,Map<String, String> hapBPFactor,Map<String, String> hapBPMiddleValue_M,Map<String, String> hapFPLL,Map<String, String> hapFPUL,Map<String, String> hapFPFactor,Map<String, String> hapFPMiddleValue_M,Map<String, String> hapSPLL,Map<String, String> hapSPUL,Map<String, String> hapSPFactor,Map<String, String> hapSPMiddleValue_M,Map<String, Decimal> outerCarrierweightMap,Map<String, Decimal> sapPouchweightMap,String currentDateTime, String ErrorCode) {
        this.success = success;
        this.message = message;
        this.responseMessage = responseMessage;
        this.responseCode = responseCode;
        this.sapLL= sapLL;
        this.sapUL= sapUL;
        this.sapFactor= sapFactor;
        this.sapMiddleValue_M = sapMiddleValue_M;
        this.hapBPLL= hapBPLL;
        this.hapBPUL= hapBPUL;
        this.hapBPFactor= hapBPFactor;
        this.hapBPMiddleValue_M = hapFPMiddleValue_M;
        this.hapFPLL= hapFPLL;
        this.hapFPUL= hapFPUL;
        this.hapFPFactor= hapFPFactor;
        this.hapFPMiddleValue_M = hapFPMiddleValue_M;
        this.hapSPLL= hapSPLL;
        this.hapSPUL= hapSPUL;
        this.hapSPFactor= hapSPFactor;  
        this.hapSPMiddleValue_M = hapSPMiddleValue_M;
        this.outerCarrierweightMap = outerCarrierweightMap;
        this.sapPouchweightMap = sapPouchweightMap;
        this.currentDateTime=currentDateTime;
        this.ErrorCode=ErrorCode;
       /* PS1060931 End*/ 
        
        
     }
}
global class ReturnAttachmentClass{
    global Boolean success;
    global String message;
    global String responseMessage;
    global String responseCode;
    global String records;
    global String currentDateTime;
    global String ErrorCode;
    global ReturnAttachmentClass(Boolean success, String message,String responseMessage, String responseCode,String records,String currentDateTime, String ErrorCode) {
        this.success = success;
        this.message = message;
        this.responseMessage = responseMessage;
        this.responseCode= responseCode;
        this.records= records;
        this.currentDateTime=currentDateTime;
        this.ErrorCode=ErrorCode;
    }
}
global class ReturnDeleteBASClass{
    global Boolean success;
    global String message;
    global String responseMessage;
    global String responseCode;
    global String records;
    global String currentDateTime;
    global String ErrorCode;
    global ReturnDeleteBASClass(Boolean success, String message,String responseMessage, String responseCode,String records,String currentDateTime, String ErrorCode) {
        this.success = success;
        this.message = message;
        this.responseMessage = responseMessage;
        this.responseCode= responseCode;
        this.records= records;
        this.currentDateTime=currentDateTime;
        this.ErrorCode=ErrorCode;
    }
}
    public static void createPushNotificationLog(Set<Id> BACIds,List<BAC_Team_Member__c> tmList,Set<String> users){                  
        system.debug('logged in user : ' + UserInfo.getUserId() + UserInfo.getName());
        List<BA_Push_Notification_Log__c> bpnList=new List<BA_Push_Notification_Log__c>();
        Map<String,Boolean> pushMapFromUser=new Map<String,Boolean>();
        Map<String,Boolean> pushMapFromLog=new Map<String,Boolean>();
       	List<Id> tempIds=new List<Id>();
        tempIds.addAll(BACIds);
        if(users.size()>0){
            users.remove(UserInfo.getUserId());
        }
        for(String s : users){
            //String key=s+'/'+bacList[0].Id;
            String key=s+'/'+tempIds[0];  
            pushMapFromUser.put(key, true);
        }
        bpnList=[select BA_Configuration__c,Push_Notification_Receiver__c from BA_Push_Notification_Log__c where BA_Configuration__c IN: BACIds 
                 AND Push_Notification_Receiver__c IN: users];
        if(bpnList.size()>0){
            for(BA_Push_Notification_Log__c bpn : bpnList){
                pushMapFromLog.put(bpn.Push_Notification_Receiver__c+'/'+bpn.BA_Configuration__c, true);
            }
        }
        bpnList.clear();
        
        for(String s : pushMapFromUser.keySet()){ 
            if(!pushMapFromLog.containsKey(s)){
                BA_Push_Notification_Log__c bpn=new BA_Push_Notification_Log__c();
                List<String> temp=s.split('/');
                bpn.BA_Configuration__c=temp[1];
                bpn.Push_Notification_Receiver__c=temp[0];
                bpnList.add(bpn);
            }
        }
        if(bpnList.size()>0){
            insert bpnList;
        }
    }
}