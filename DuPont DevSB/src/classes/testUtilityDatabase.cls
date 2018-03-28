/*************************************************************************************************
Copyright © 2013 DuPont. All rights reserved. 
Authors:        Vijay Laxmi
Email:          vijay.laxmi1@tcs.com
Description:    Class to create test data for CIC Project
Date:           10/17/2016

***************************************************************************************************/

public class testUtilityDatabase 
{
  public static External_Initiative__c createExtInitative(Boolean withOppty) 
  { 
  // Creating  ExternalInitiative
  List<External_Initiative__c> testExtIniativeList =new List<External_Initiative__c>();
  External_Initiative__c testExtIniative1 =new External_Initiative__c(
                                    name='TestExtInit2',
                                        Full_External_Initiative_Name__c='TestExtInit2rrrr',
                                    External_ID__c='999888888',
                                    Country__c='DALLAS',
                                    EI_Region__c='United States',
                                    External_Search_Name__c='Surfaces',
      								Stage__c='completed',
                                    City__c='BEVERLY',
                                        Project_Level__c='Parent',
                                    Data_Source__c='CIC - Construction'
                                    );    
  insert testExtIniative1;
  External_Initiative__c testExtIniative2 =new External_Initiative__c(
                                    name='TestExtInit',
                                        Full_External_Initiative_Name__c='TestExtInitrrrr',
                                    External_ID__c='999999999',
                                    Country__c='DALLAS',
                                    EI_Region__c='United States',
                                    External_Search_Name__c='Surfaces',
                                    City__c='BEVERLY',
      								Stage__c='On-Hold',
                                    Data_Source__c='CIC - Construction',
                                    Project_Level__c='Sub',
                                    Parent_Project_Id__c=testExtIniative1.External_ID__c,
                                    Parent_External_Initiative__c=null
                                    );    
  insert testExtIniative2; 
  External_Initiative__c testExtIniative3 = [select id,Stage__c from External_Initiative__c where External_ID__c='999888888'];
  testExtIniative2.Parent_External_Initiative__c= testExtIniative3.id;  
  testExtIniative2.Stage__c='completed';
  update testExtIniative2;        
    if (withOppty == true)
    {
    // Create a Opportunity with External Initiative
    Opportunity o = createOppty(testExtIniative1);
    createOppty(testExtIniative1);
    }                   
  return testExtIniative1;
  return  testExtIniative2;    
      
  }            

  //<LeadUpdate><Start>
  public static External_Initiative__c createEIforLead(Boolean withLead)
  { 
    // Create Lead   
    External_Initiative__c testExtIniativeLead =new External_Initiative__c(
                                        name='TestExtInit',
                                        External_ID__c='999',
                                        Country__c='DALLAS',
                                        EI_Region__c='United States',
                                        External_Search_Name__c='Surfaces',
                                        City__c='BEVERLY',
                                              Project_Level__c='Parent',
                                        Data_Source__c='CIC - Construction'
                                        );    
    insert testExtIniativeLead;
    if (withLead == true)
    {
      Lead le = updateLead(testExtIniativeLead);
    }  
      return testExtIniativeLead; 
  }
  // Create Lead on  External Initiative
  private static Lead updateLead(External_Initiative__c extEI) 
  {
    Lead lead1 = new Lead(
                Lastname='TestLead',
                External_Initiative__c=null,                
                Legacy_Lead_ID__c='CIC^999^abcs^1233',
                //updated for dps
                Company = 'TestLead'
               ); 
    insert lead1;
    lead1.External_Initiative__c=extEI.id;
    update lead1;
    return lead1;
  }
  //<LeadUpdate><End>
  // Create Opportunity On External Initiative
  private static Opportunity createOppty(External_Initiative__c ei) 
  {
     String RTYPE_ISSUE = Rtype.getIdByDevName('Opportunity','Construction_AP'); 
    Opportunity o = new Opportunity(
                    Name='TestOppty',
                    External_Initiative__c=ei.id,
                    Last_Ship_Date__c=System.today(),
                    StageName='Target 5%',
                    CloseDate=System.today(),
                          RecordTypeid=RTYPE_ISSUE 
                    );
        system.debug(Logginglevel.ERROR,'@@@@@@@@@@@@@@@@'+o);
    insert o;
    return o;
  }
    // Custom setting data
    public static CIC_End_Points__c createCustomsett_Data() 
  {
     
    CIC_End_Points__c cic = new CIC_End_Points__c(
                          name='test',
                    CIC_End_Point__c='https://www.crm-integration.construction-ic.com/CrmFeed/PullDownload/125 ',
                    Job_Time_Stamp__c=System.today()
                    );
    insert cic;
        return cic;

  }
    public static CIC_End_Points__c createCustomsett_Data1() 
  {
     
    CIC_End_Points__c cic = new CIC_End_Points__c(
                          name='test',
                    CIC_End_Point__c='https://www.crm-integration.construction-ic.com/CrmFeed/PullDownload/125 '
                    
                    );
    insert cic;
        return cic;

  }
    public static DPS_CIC_Expire_Project_End_Point__c createCustomsett_Data_Expire() 
  {
     
    DPS_CIC_Expire_Project_End_Point__c cic_Expire_URL = new DPS_CIC_Expire_Project_End_Point__c(
                          name='test',
                    CIC_Expire_Project_End_Point__c='https://www.crm-integration.construction-ic.com/CrmFeed/PullDownload/125 ',
                    CIC_Expire_Project_Job_Time_Stamp__c=System.today()
                    );
    insert cic_Expire_URL;
    return cic_Expire_URL;

  }
  public static DPS_CIC_Expire_Project_End_Point__c createCustomsett_Data_Expire1() 
  {
     
    DPS_CIC_Expire_Project_End_Point__c cic_Expire_URL1 = new DPS_CIC_Expire_Project_End_Point__c(
                          name='test1',
                    CIC_Expire_Project_End_Point__c='https://www.crm-integration.construction-ic.com/CrmFeed/PullDownload/125 '
                   
                    );
    insert cic_Expire_URL1;
    return cic_Expire_URL1;

  }  
}