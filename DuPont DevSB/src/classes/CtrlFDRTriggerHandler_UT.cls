/*******************************************************************************
(C)2016
Author: krishnaveni duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  This class tests the CtrlFDRTriggerHandler
 ********************************************************************************/
@isTest
private class CtrlFDRTriggerHandler_UT {
    public static Profile p;
    public static User user1;
    public static BA_Configuration__c  bac;
    public static BA_Push_Notification_Log__c push;
    public static BAC_Team_Member__c btm1;
    public static Functional_Design_Requirement__c fdr1,fdr2,fdr3;
    public static Map<String,Id> rTNameToIDMap;
    static testMethod void testDoPost() {
    
    p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
    List<User> userList = new List<User>();
    user1 = new User();     
    user1.Username = 'testName1@abc.com';
    user1.LastName = 'name';
    user1.Alias = 'tn';
    user1.CommunityNickname = 'test';
    user1.TimeZoneSidKey = 'America/Chicago';
    user1.LocaleSidKey = 'en_US';
    user1.EmailEncodingKey = 'UTF-8';
    user1.ProfileId = p.id;
    user1.LanguageLocaleKey = 'en_US';
    user1.email = 'testName1@abc.com';
    user1.isActive = true;    
    insert user1;
    
    bac= new BA_Configuration__c();
    bac.name='test';     
    bac.Body_Armor_Configuration_ID__c='ABCD123456';
    bac.Active__c = true; 
    bac.Status__c = 'Tender in progress';
    bac.BAC_Progress__c = 'New Campaigns';
    bac.Sensitive_Destination_Committee_Approv__c = true;
    bac.ownerid = user1.id;
    insert bac;
    
    push = new BA_Push_Notification_Log__c();
    push.BA_Configuration__c = bac.id;
    push.IsNotificationRead__c = true;
    push.Push_Notification_Receiver__c = user1.id;
    insert push;
    
    btm1 = new BAC_Team_Member__c();
    btm1.Active__c = true;
    btm1.BA_Configuration__c = bac.id;
    btm1.Team_Member_Name__c = user1.id;   
    insert btm1;  
    
     List<RecordType> fdrRTList=new List<RecordType>();
    List<Functional_Design_Requirement__c> fdrList = new List<Functional_Design_Requirement__c>();
    rTNameToIDMap=new Map<String,Id>();
    
    fdrRTList=[Select Id,developerName From RecordType Where SobjectType = 'Functional_Design_Requirement__c' AND (developerName = 'Body_Armor_Functional_Design' OR 
              developerName='HAP_Functional_Design' OR developerName='Other_Requirement')];
    for(RecordType rt :fdrRTList){
        rTNameToIDMap.put(rt.developerName,rt.id);
    }
        
    fdr1= new Functional_Design_Requirement__c();
    fdr2= new Functional_Design_Requirement__c();
    fdr3= new Functional_Design_Requirement__c();
    
    fdr1.name='FDR123';
    fdr1.RecordTypeId=rTNameToIDMap.get('HAP_Functional_Design');
    fdr1.Active__c=true;
    fdr1.BA_Configuration__c=bac.id;
    fdr1.Keep_FP_dimensions_same_for_all_the_size__c=false;
    fdr1.Keep_BP_dimensions_same_for_all_the_size__c=false;
    fdr1.Keep_SP_dimensions_same_for_all_the_size__c=false;
    fdrList.add(fdr1);
    fdr2.name='FDR456';
    fdr2.RecordTypeId=rTNameToIDMap.get('Other_Requirement');
    fdr2.Active__c=true;
    fdr2.BA_Configuration__c=bac.id;
    fdr2.Flammability_Protection_Needed__c=false;
    fdrList.add(fdr2);
    fdr3.name='FDR789';
    fdr3.RecordTypeId=rTNameToIDMap.get('Body_Armor_Functional_Design');
    fdr3.Active__c=true;
    fdr3.BA_Configuration__c=bac.id;
    fdrList.add(fdr3);
    
    insert fdrList;     
    }
    
}