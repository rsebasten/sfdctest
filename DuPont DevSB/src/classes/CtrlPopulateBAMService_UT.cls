/*******************************************************************************
(C)2015
Author: Pallavi Sharma
Email: Pallavi.sharma3@tcs.com
Description:  This class tests the CtrlPopulateBAMService.
 ********************************************************************************/
@isTest
private class CtrlPopulateBAMService_UT {   
    public static Kevlar_Response_Messages__c m1,m2,m3,m4,m5;
    public static List<Kevlar_Response_Messages__c> respMsgList = new List<Kevlar_Response_Messages__c>(); 
    public static Body_Armor_Solution__c bas,bs,bs2,bs1;
    public static User user1;
    public static BA_Configuration__c dat1;
    public static  Material_Master__c mm,mm1 ;
    public static List<Material_Master__c> mmList = new List<Material_Master__c>();
    public static Material_Type__c mtype,mtype1;
    public static List<Material_Type__c> mtypeList = new List<Material_Type__c>();
    public static Profile p;
    static{
        m1 = testData_Kevlar_UT.getMessage1(); 
        respMsgList.add(m1);       
        m4 = testData_Kevlar_UT.getMessage38();
        respMsgList.add(m4); 
        m3 = testData_Kevlar_UT.getMessage3();
        respMsgList.add(m3);  
        insert respMsgList;
    p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
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
    
    dat1=new BA_Configuration__c ();
    dat1.Name='abcd';
    dat1.Active__c= true;
    dat1.status__c='Tender in progress';
    dat1.BAC_Progress__c='New Campaigns';
    dat1.ownerid = user1.id;
    insert dat1;
     
    String rdId1 = [Select Id From RecordType Where SobjectType = 'Body_Armor_Solution__c' and  Name = 'SAP Solution'].Id;
    String rdId2 = [Select Id From RecordType Where SobjectType = 'Body_Armor_Solution__c' and  Name = 'HAP Solution'].Id;
    bs = new Body_Armor_Solution__c();
    bs.BA_Configuration__c = dat1.id;
    bs.name='hap solution1';
    bs.Body_Armor_Solution_ID_iOS__c = 'test123';
    bs.RecordTypeId=rdId2;
    bs.Comments__c = 'dfasdfa';
    insert bs; 
    bs1 = new Body_Armor_Solution__c();
    bs1.BA_Configuration__c = dat1.id;
    bs1.name='hap solution1';
    bs1.Body_Armor_Solution_ID_iOS__c = 'test123';
    bs1.RecordTypeId=rdId2;
    bs1.Comments__c = 'dfasdfa';
    insert bs1;
     bs2 = new Body_Armor_Solution__c();
    bs2.BA_Configuration__c = dat1.id;
    bs2.name='hap solution1';
    bs2.Body_Armor_Solution_ID_iOS__c = 'test123';
    bs2.RecordTypeId=rdId2;
    bs2.Comments__c = 'dfasdfa';
    insert bs2;
    bas = new Body_Armor_Solution__c();
    bas.BA_Configuration__c = dat1.id;
    bas.name='Sap solution1';
    bas.Body_Armor_Solution_ID_iOS__c = 'test123';
    bas.RecordTypeId=rdId1;
    bas.Related_To_BAM_HAP_1__c = bs.id;
    bas.Related_To_BAM_HAP_2__c = bs1.id;
    bas.Related_To_BAM_HAP_3__c = bs1.id;
    bas.Comments__c = 'dfasdfa';
    bas.IsSelectedBAM__c = true;
    insert bas; 
    
    System.debug('Inserted bas: '+ bas.Id);
    mm = new Material_Master__c();
    mm.Material_Type__c = 'Dupont';
    mm.Material_Orign__c = 'Dupont';
    mmList.add(mm);
    mm1 = new Material_Master__c();
    mm1.Material_Type__c = 'Partner';
    mm1.Material_Orign__c = 'Partner';
    mmList.add(mm1);
    insert mmList;
    mtype = new Material_Type__c();
    mtype.name = 'test';
    mtype.SAP_Material__c = mm.Id;
    mtype.Number_of_Layers__c = '2';
    mtype.Body_Armor_SAP_Solution__c = bas.id;
    mtype.Material_used__c = 'Dupont';
    mtype.GSM__c = 2;
    mtype.Comments__c= 'xxxxxxx';
    mtypeList.add(mtype);
    mtype1 = new Material_Type__c();
    mtype1.name = 'test';
    mtype1.SAP_Material__c = mm1.Id;
    mtype1.Number_of_Layers__c = '2';
    mtype1.Body_Armor_SAP_Solution__c = bas.id;
    mtype1.Material_used__c = 'Partner';
    mtype1.GSM__c = 2;
    mtype1.Comments__c= 'xxxxxxx';
    mtypeList.add(mtype1);
    insert mtypeList;
    
    }
   static testMethod void testDoPost_BAFD() { 
        String JsonMsg= '{'+  
        '"bacConfigurationID" : "'+dat1.id+'"'+ 
        '}';
 
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/PopulateBAM';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;
        CtrlPopulateBAMService testFDR=new CtrlPopulateBAMService();   
        CtrlPopulateBAMService.doPost(); 
        Test.stopTest();
    }
}