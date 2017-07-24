trigger tgrCalculatePilotFitScore on Validation_Score__c (before insert, before update) 

{



    for (Validation_Score__c vs : Trigger.new) 

    {

    vs.Calculated_Complexity_Score__c = 

 (((

        Utilities.returnScore( vs.Packaged_or_custom__c ) 

        + Utilities.returnScore( vs.System_Documentation_Availability__c ) 

        + Utilities.returnScore( vs.Mobile_Requirements__c ) 
        
        + Utilities.returnScore (vs.of_Business_Processes__c) * 3
        
        + Utilities.returnScore( vs.Offline_Requirements__c )  +
        
        Utilities.returnScore(vs.Content_Requirements__c) * 3 +
        
        Utilities.returnScore(vs.of_Custom_Pages__c) * 2 +
        
        Utilities.returnScore (vs.Unauthenticated_Access_Requirements__c) * 2 +
        
        Utilities.returnScore (vs.Branding_Requirements__c) * 4 +
        
        Utilities.returnScore (vs.Navigational_Requirements__c) * 2 +

        Utilities.returnScore( vs.Authentication_Requirements__c ) 

        + Utilities.returnScore( vs.Encryption_Requirements__c ) 

        + Utilities.returnScore( vs.Audit_Requirements__c ) 

        + Utilities.returnScore( vs.Interface_Timing__c ) 

        + Utilities.returnScore( vs.of_Integration_Points__c ) * 4

        + Utilities.returnScore( vs.Tools_for_Integration_Architecture__c ) * 2

        + Utilities.returnScore( vs.Integration_capabilities_of_other_system__c ) * 2

        + Utilities.returnScore( vs.Requires_cleansing__c ) 

        + Utilities.returnScore( vs.Ease_of_Data_Extraction__c ) 

        + Utilities.returnScore( vs.Structured_Data_Storage_Magnitude__c ) 

        + Utilities.returnScore( vs.File_Size__c ) 

        + Utilities.returnScore( vs.Requirements__c ) 

        + Utilities.returnScore( vs.Internal_or_External_Workflow__c ) 

        + Utilities.returnScore( vs.of_custom_Fields__c ) 

        + Utilities.returnScore( vs.of_custom_Objects_Tabs__c ) 

        + Utilities.returnScore( vs.Application_UI_integration_requirements__c ) 

        + Utilities.returnScore( vs.Multi_sourced_Reports_and_Dashboards__c ) * 2

        + Utilities.returnScore( vs.Synchronous_Reporting_on_Large_Results__c ) 

        + Utilities.returnScore( vs.Data_Warehousing_OLAP_Processing__c ) 

       /* + Utilities.returnScore( vs.Entitlement_Integration_Requirements__c ) 

        + Utilities.returnScore( vs.Entitlements_Requirements__c ) */
        
        + Utilities.returnScore (vs.of_Data_Migration_Sources__c)* 3

        )/235*70))/70*100;




     vs.Calculated_Usage_Risk_Score__c = 
     
      (((

        Utilities.returnScore( vs.Number_of_Internal_Users__c ) * 2 

        + Utilities.returnScore( vs.Number_of_External_Users__c ) * 3

        + Utilities.returnScore( vs.of_Divisions__c ) 

        + Utilities.returnScore( vs.of_Departments__c ) 

        + Utilities.returnScore( vs.of_Physical_Locations__c ) 

        + Utilities.returnScore( vs.Downtime_Impact__c )  

        )/45*20)/20)*100;


     vs.Calculated_Current_User_Perception__c =

       (((
     Utilities.returnScore( vs.Innovation_Growth_Speed_Market__c ) 

        + Utilities.returnScore( vs.Ease_of_Use__c ) 

        + Utilities.returnScore( vs.Application_Quality__c ) 

        + Utilities.returnScore( vs.Performance__c ) 

        + Utilities.returnScore( vs.User_Satisfaction__c ) 

        + Utilities.returnScore( vs.Cost_Effectiveness__c )

        )/30*10)/10)*100;
        
        

      vs.Calculated_Pilot_Score__c = 

        ((

        Utilities.returnScore( vs.Packaged_or_custom__c ) 

        + Utilities.returnScore( vs.System_Documentation_Availability__c ) 

        + Utilities.returnScore( vs.Mobile_Requirements__c )
        
        + Utilities.returnScore (vs.of_Business_Processes__c) * 3 
        
        + Utilities.returnScore( vs.Offline_Requirements__c ) +
        
        Utilities.returnScore(vs.Content_Requirements__c) * 3 +
        
        Utilities.returnScore(vs.of_Custom_Pages__c) * 2 +
         
         Utilities.returnScore (vs.Unauthenticated_Access_Requirements__c) * 2 +
        
        Utilities.returnScore (vs.Branding_Requirements__c) * 4 +
        
        Utilities.returnScore (vs.Navigational_Requirements__c) * 2 +

        Utilities.returnScore( vs.Authentication_Requirements__c ) 

        + Utilities.returnScore( vs.Encryption_Requirements__c ) 

        + Utilities.returnScore( vs.Audit_Requirements__c ) 

        + Utilities.returnScore( vs.Interface_Timing__c ) 

        + Utilities.returnScore( vs.of_Integration_Points__c ) * 4

        + Utilities.returnScore( vs.Tools_for_Integration_Architecture__c ) * 2

        + Utilities.returnScore( vs.Integration_capabilities_of_other_system__c ) * 2

        + Utilities.returnScore( vs.Requires_cleansing__c ) 

        + Utilities.returnScore( vs.Ease_of_Data_Extraction__c ) 

        + Utilities.returnScore( vs.Structured_Data_Storage_Magnitude__c ) 

        + Utilities.returnScore( vs.File_Size__c ) 

        + Utilities.returnScore( vs.Requirements__c ) 

        + Utilities.returnScore( vs.Internal_or_External_Workflow__c ) 

        + Utilities.returnScore( vs.of_custom_Fields__c ) 

        + Utilities.returnScore( vs.of_custom_Objects_Tabs__c ) 

        + Utilities.returnScore( vs.Application_UI_integration_requirements__c ) 

        + Utilities.returnScore( vs.Multi_sourced_Reports_and_Dashboards__c ) * 2

        + Utilities.returnScore( vs.Synchronous_Reporting_on_Large_Results__c ) 

        + Utilities.returnScore( vs.Data_Warehousing_OLAP_Processing__c ) 

       /* + Utilities.returnScore( vs.Entitlement_Integration_Requirements__c ) 

        + Utilities.returnScore( vs.Entitlements_Requirements__c ) */
        
        + Utilities.returnScore (vs.of_Data_Migration_Sources__c)* 3

        )/235*70)
        +

       

        ((

        Utilities.returnScore( vs.Number_of_Internal_Users__c ) * 2 

        + Utilities.returnScore( vs.Number_of_External_Users__c ) * 3

        + Utilities.returnScore( vs.of_Divisions__c ) 

        + Utilities.returnScore( vs.of_Departments__c ) 

        + Utilities.returnScore( vs.of_Physical_Locations__c ) 

        + Utilities.returnScore( vs.Downtime_Impact__c )  

        )/45*20)

        +

       

        ((
     Utilities.returnScore( vs.Innovation_Growth_Speed_Market__c ) 

        + Utilities.returnScore( vs.Ease_of_Use__c ) 

        + Utilities.returnScore( vs.Application_Quality__c ) 

        + Utilities.returnScore( vs.Performance__c ) 

        + Utilities.returnScore( vs.User_Satisfaction__c ) 

        + Utilities.returnScore( vs.Cost_Effectiveness__c )

        )/30*10);
         

                   

    }

}