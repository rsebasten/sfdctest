/*******************************************************************************
(C)2016
Author: krishnaveni duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  This class tests the CtrlSolutionPricingTriggerHandler
 ********************************************************************************/
@isTest
private class CtrlSolutionPricingTriggerHandler_UT {
    public static Profile p;
    public static User user1;
    public static BA_Configuration__c  bac;
    public static BA_Push_Notification_Log__c push;
    public static BAC_Team_Member__c btm1;
    public static Body_Armor_Solution__c bas;
    public static  Material_Master__c mm;
    public static Material_Type__c mtype;
    public static Solution_Pricing__c sp;
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
        String rdId1 = [Select Id From RecordType Where SobjectType = 'Body_Armor_Solution__c' and  Name = 'SAP Solution'].Id;
        
        bas = new Body_Armor_Solution__c();
        bas.BA_Configuration__c = bac.id;
        bas.name='hap solution1';
        bas.Body_Armor_Solution_ID_iOS__c = 'test123';
        bas.RecordTypeId=rdId1;
        bas.Comments__c = 'dfasdfa';
        insert bas; 
        mm = new Material_Master__c();
        mm.Material_Type__c = 'Dupont';
        mm.Material_Orign__c = 'Dupont';
        insert mm;
        mtype = new Material_Type__c();
        mtype.name = 'test';
        mtype.SAP_Material__c = mm.Id;
        mtype.Number_of_Layers__c = '2';
        mtype.Body_Armor_SAP_Solution__c = bas.id;
        mtype.Material_used__c = 'Dupont';
        mtype.GSM__c = 2;
        mtype.Comments__c= 'xxxxxxx';
        insert mtype;
        String rdIdsp = [Select Id From RecordType Where SobjectType = 'Solution_Pricing__c' and Name = 'SAP Solution Pricing'].Id; 
        
        sp = new Solution_Pricing__c();
        sp.name= 'sp price1';
        sp.Active__c= true;
        sp.RecordTypeId=rdIdsp;
        sp.BA_Configuration__c = bac.id;
        sp.Select_SAP_Solution__c = bas.id;
        sp.Total_cost_of_Body_Armour_for_size_XXL__c = 2;
        sp.Total_cost_of_Body_Armour_for_size_XL__c = 2;
        sp.Total_cost_of_Body_Armour_for_size_L__c = 2;
        sp.Total_cost_of_Body_Armour_for_size_XS__c = 2;
        sp.Total_cost_of_Body_Armour_for_size_S__c = 2;
        sp.Total_cost_of_Body_Armour_for_size_M__c = 2;
        sp.Material_Wastage_Comment__c = 'xxxxxx';
        sp.Cost_Of_Outer_Carrier__c = 2;
        sp.Cost_Of_SAP_Pouches__c = 3;
        sp.SAP_Material_Wastage__c = 2;
        sp.BAM_Margin__c = 3;
        sp.Cost_Comment__c = 'xxxx';
        insert sp; 
    }
    
}