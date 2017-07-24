@isTest
private class ValidationScoreTestSuite {

   static testMethod void runPositiveTestCases() { 
   
        Application__c ap = new Application__c();
        ap.Name = 'TestApp';
        insert ap;
   
   
   
        Validation_Score__c vs = new Validation_Score__c();  
        
        vs.Application__c = ap.id;     
    
        vs.Packaged_or_custom__c  = '3';

        vs.System_Documentation_Availability__c  = '3'; 

        vs.Mobile_Requirements__c  = '3'; 
        
        vs.of_Business_Processes__c  = '3';
        
        vs.Offline_Requirements__c  = '3';  
        
        vs.Content_Requirements__c  = '3';
        
        vs.of_Custom_Pages__c  = '3';
        
        vs.Unauthenticated_Access_Requirements__c  = '3';
        
        vs.Branding_Requirements__c  = '3';
        
        vs.Navigational_Requirements__c  = '3';

        vs.Authentication_Requirements__c  = '3'; 

        vs.Encryption_Requirements__c  = '3'; 

        vs.Audit_Requirements__c  = '3'; 

        vs.Interface_Timing__c  = '3'; 

        vs.of_Integration_Points__c  = '3'; 

        vs.Tools_for_Integration_Architecture__c  = '3'; 

        vs.Integration_capabilities_of_other_system__c  = '3'; 

        vs.Requires_cleansing__c  = '3'; 

        vs.Ease_of_Data_Extraction__c  = '3'; 

        vs.Structured_Data_Storage_Magnitude__c  = '3'; 

        vs.File_Size__c  = '3'; 

        vs.Requirements__c  = '3'; 

        vs.Internal_or_External_Workflow__c  = '3'; 

        vs.of_custom_Fields__c  = '3'; 

        vs.of_custom_Objects_Tabs__c  = '3'; 

        vs.Application_UI_integration_requirements__c  = '3'; 

        vs.Multi_sourced_Reports_and_Dashboards__c  = '3'; 

        vs.Synchronous_Reporting_on_Large_Results__c  = '3'; 

        vs.Data_Warehousing_OLAP_Processing__c  = '3'; 

        vs.of_Data_Migration_Sources__c  = '3';

        vs.Number_of_Internal_Users__c  = '3'; 

        vs.Number_of_External_Users__c  = '3'; 

        vs.of_Divisions__c  = '3'; 

        vs.of_Departments__c  = '3'; 

        vs.of_Physical_Locations__c  = '3'; 

        vs.Downtime_Impact__c  = '3';  

        vs.Calculated_Current_User_Perception__c  = 3.0; 

        vs.Innovation_Growth_Speed_Market__c  = '3'; 

        vs.Ease_of_Use__c  = '3'; 

        vs.Application_Quality__c  = '3'; 

        vs.Performance__c  = '3'; 

        vs.User_Satisfaction__c  = '3'; 

        vs.Cost_Effectiveness__c  = '3';
        
        insert vs;
      }
 }