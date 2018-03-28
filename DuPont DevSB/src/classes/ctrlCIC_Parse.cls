/*************************************************************************************************
Copyright © 2013 DuPont. All rights reserved. 
Authors:        Vijay Laxmi
Email:          vijay.laxmi1@tcs.com
Description:    Create new External Initiative and Lead after reading xml for CIC Project 
                Created the " Custom Metadata Type" to store end point Urls
Date:           9/7/2016

<VL20161103>
Modified By: Vijay Laxmi
Modification Date: 03-Nov-2016
Modification: Added new field Latitude and Longitude on EI and removed <br> tag from Project Status

<VL20161109>
Modified By: Vijay Laxmi
Modification Date: 09-Nov-2016
Modification: Updated the Exception Handling Method

<VL20161216>
Modified By: Vijay Laxmi
Modification Date: 16-Dec-2016
Modification: China Locale user receiveing error due to name in query "DPS CIC Integrator"

<VL20171030>
Modified By: Vijay Laxmi
Modification Date: 30-Oct-2017
Modification: Duplicate Lead Management regarding project # CRM-2017-10-4383  


***************************************************************************************************/

public class ctrlCIC_Parse
{  //Method to get End Point URL
     public static boolean cic_related_Lead=false;
     public static final string EI_RTYPE = Rtype.getIdByDevName('External_Initiative__c','DPS_Surf_CIC');
     public static final string Lead_RTYPE = Rtype.getIdByDevName('Lead','BI_All');
     //<VL20171030> start
     static List<EI_Lead__c> listExtLead = new  List<EI_Lead__c>();
     static List<wrapper> listwrap = new List<wrapper>();
     static Map<String,string>  mapExtId_Lead_LegacyID = new Map<String,string>();
     static Map<String, Lead> mapLeadObj = new Map<String, Lead>();
     //<VL20171030>  end    

   
    
     //public static final Id CIC_UserId=[select id, name from user where name ='DPS CIC Integrator' limit 1].id;
    // <VL20161216>
      public static final Id CIC_UserId=[select id, name, username from user where Username =:Label.CIC_Construction_UserName limit 1].id;
  public void parseCICXML(CIC_End_Points__c urlPass) 
  {
    HttpRequest req = new HttpRequest();
    HttpResponse res = new HttpResponse();
    Http http = new Http();
    req.setEndpoint(urlPass.CIC_End_Point__c);
    req.setMethod('GET');
    transient string userName = system.label.CIC_UserName;
    transient  string password =system.label.CIC_Password;      
    transient Blob headerValue = Blob.valueOf(userName + ':' + password);
    transient String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue); 
    req.setHeader('Authorization', authorizationHeader); 
    req.setHeader('Accept','application/xml');
    try 
    {
      res = http.send(req);    
      ctrlCIC_Parse.parseResponseDom(res.getBody());
        }
    catch(Exception e) {}  
  }
  // Method to read XML and Create ExternalInitiative and Lead Records
  public static void parseResponseDom(String xmltoParse)
  {
    
    
    transient list<string> LstExternalId = new list<string>(); 
    transient list<string> LstLeadLegacyId = new list<string>();
    
    Dom.Document xmlDOC = new Dom.Document();
    xmlDOC.load(xmltoParse);
    //Retrieve the root element for ExternalInitiative
    Dom.XMLNode projects = xmlDOC.getRootElement();
    transient List<External_Initiative__c> externalInitiativeList = new List<External_Initiative__c>();
    transient  List<Lead> leadList = new List<Lead>();
    //<VL20171030> start
    List<EI_Lead__c> junctionlist = new List<EI_Lead__c>();  
    //<VL20171030> End  
    if(projects.getChildElements()!=null)
    {
      for(Dom.XMLNode project : projects.getChildElements()) 
      {
      External_Initiative__c ei = new External_Initiative__c();
      //<VL20171030> start Junction Object initialization
       EI_Lead__c el = new EI_Lead__c();
       //<VL20171030> End   
      ei.External_Search_Name__c=System.Label.CIC_External_Initiative_SearchName;
      ei.Data_Source__c=System.Label.CIC_External_Initiative_Data_Source;
      ei.Type__c=System.Label.External_Initiative_Type;
      ei.Ownerid=CIC_UserId;
      ei.RecordTypeid=EI_RTYPE;  
      ei.Owning_Organization__c=system.label.CIC_Owning_Org;
      if(project.getChildElements()!=null)
      {
        for(Dom.XMLNode externalInitiative_Element : project.getChildElements()) 
        {   
          if(externalInitiative_Element.getName()=='ProjectName' && externalInitiative_Element.getText()!=null)
          {
          String externalInitiative_ProjectName=externalInitiative_Element.getText();
          ei.name =externalInitiative_ProjectName.length()>80?externalInitiative_ProjectName.substring(0, 77)+'...':externalInitiative_ProjectName;
          ei.Full_External_Initiative_Name__c=externalInitiative_Element.getText();
          }
          else if(externalInitiative_Element.getName()=='ParentProjectId')
          ei.Parent_Project_Id__c=externalInitiative_Element.getText();
                    //<VL20161103>
                  else if(externalInitiative_Element.getName()=='Latitude')
          ei.Latitude__c=decimal.valueof(externalInitiative_Element.getText());
                  else if(externalInitiative_Element.getName()=='Longitude')
          ei.Longitude__c=decimal.valueof(externalInitiative_Element.getText());
          else if(externalInitiative_Element.getName()=='ProjectLevel')    
          ei.Project_Level__c=externalInitiative_Element.getText();       
          else if(externalInitiative_Element.getName()=='Region')      
          ei.EI_Region__c=externalInitiative_Element.getText();       
          else if(externalInitiative_Element.getName()=='ID') 
          ei.External_ID__c =externalInitiative_Element.getText();   
          else if(externalInitiative_Element.getName()=='Country')      
          ei.Country__c =externalInitiative_Element.getText();       
          else if(externalInitiative_Element.getName()=='City')      
          ei.City__c =externalInitiative_Element.getText(); 
                    //<VL20161103>
          else if(externalInitiative_Element.getName()=='ProjectOverview')
                  {  
                      String Description =externalInitiative_Element.getText(); 
                      String Description1=Description.replace('<br /><br />',' ');
                      String Description2=Description1.replace('<br />',' ');
            ei.Description__c = Description2;
                  }    
          else if(externalInitiative_Element.getName()=='LatestUpdate')
                  {   
                     String ProjectStatus =externalInitiative_Element.getText(); 
                     String ProjectStatus1=ProjectStatus.replace('<br /><br />','');
                    String ProjectStatus2=ProjectStatus1.replace('<br />',''); 
          ei.Project_Status__c =ProjectStatus2;
                  }    
          else if(externalInitiative_Element.getName()=='ProjectUrl')      
          ei.External_URL__c =externalInitiative_Element.getText();       
          else if(externalInitiative_Element.getName()=='PrimarySector')      
          ei.Primary_Sector__c=externalInitiative_Element.getText();       
          else if(externalInitiative_Element.getName()=='SecondarySector')      
          ei.Secondary_Sector__c=externalInitiative_Element.getText();       
          else if(externalInitiative_Element.getName()=='ProjectStage')      
          ei.Stage__c =externalInitiative_Element.getText();       
          else if(externalInitiative_Element.getName()=='LastUpdated')      
          ei.Last_Import_Date__c =date.valueof(externalInitiative_Element.getText());       
          else if(externalInitiative_Element.getName()=='ProjectValue')
          {
          String ei_ProjectValue = externalInitiative_Element.getText(); 
          String regex = '[a-zA-Z]{1,}|\\-';
          Integer stored_ei_ProjectValue = integer.ValueOf(ei_ProjectValue.replaceAll(regex, '').trim());
          ei.Value__c = double.valueof(string.valueof(stored_ei_ProjectValue)+'000000');
          }
          else if(externalInitiative_Element.getName()=='ProjectEndQuarter')      
          ei.Project_End_Quarter__c=externalInitiative_Element.getText();       
          else if(externalInitiative_Element.getName()=='ConstructionStartQuarter')      
          ei.Construction_Start_Quarter__c =externalInitiative_Element.getText();    
          // Retrieve the child element for Lead
          if(externalInitiative_Element.getName()=='ProjectKeyContacts')
          {
          if(externalInitiative_Element.getChildElements()!=null)
          {  
            for(Dom.XMLNode ProjectKeyContacts:externalInitiative_Element.getChildElements())
            {
              Lead lead = new Lead();
              String contactType;
              String CompanyID;  
              lead.Type__c=system.label.Lead_Type;
              lead.Ownerid=CIC_UserId;
              lead.Status=system.label.Lead_Status;
              lead.Origin_Channel_Type__c=system.label.Lead_Origin_Channel_Type;
              lead.Owning_SBU__c=system.label.Lead_Owning_SBU;
              lead.Owning_Organization__c=system.label.CIC_Owning_Org;
              lead.Preferred_Language__c=system.label.Lead_Preferred_Language;
              lead.RecordTypeid=Lead_RTYPE; 
              lead.Alternate_Privacy_Notification__c=system.label.CIC_Lead_Alternate_Privacy_Notification;
              if(ProjectKeyContacts.getChildElements()!=null)
              {
                for(Dom.XMLNode KeyContact:ProjectKeyContacts.getChildElements())
                {
                  if(KeyContact.getName()=='KeyContactId')          
                    lead.Name_ID__c =  KeyContact.getText();          
                  else if(KeyContact.getName()=='ContactDivision')          
                    lead.Role__c = KeyContact.getText();           
                  else if(KeyContact.getName()=='KeyContactType')          
                    contactType= KeyContact.getText();           
                  else if(KeyContact.getName()=='CompanyId')                     
                    CompanyID = KeyContact.getText();                       
                  else if(KeyContact.getName()=='Company')          
                    lead.Company= KeyContact.getText();           
                  else if(KeyContact.getName()=='LeadContact')          
                    lead.LastName = KeyContact.getText();              
                  else if(KeyContact.getName()=='Website')          
                    lead.Website = KeyContact.getText();           
                  else if(KeyContact.getName()=='Email') 
                                    {  
                                        String AllEmail=KeyContact.getText();
                                        String Email_New = AllEmail.substringBefore(',');
                                        lead.Email = Email_New;     
                                    }    
                  else if(KeyContact.getName()=='JobTitle')          
                    lead.Title = KeyContact.getText();                   
                  else if(KeyContact.getName()=='KeyContactCountry')          
                  {
                    lead.Lead_Country__c = KeyContact.getText();
                    lead.Country = KeyContact.getText(); 
                  }   
                  else if(KeyContact.getName()=='Address')          
                    lead.Street= KeyContact.getText();           
                  else if(KeyContact.getName()=='KeyContactCity')          
                    lead.City = KeyContact.getText();           
                  else if(KeyContact.getName()=='PostCode')          
                      lead.PostalCode = KeyContact.getText();                        
                  else if(KeyContact.getName()=='Telephone' && KeyContact.getText()!=null && KeyContact.getText()!='')
                  {
                  String Allphone=KeyContact.getText();
                  // lead.Phone =phone.length()>80?phone.substring(0,39):phone;
                                    String phone_New = Allphone.substringBefore(',');
                                    lead.Phone = phone_New;    
                  }
                  if(lead.LastName==null || lead.LastName=='')          
                    lead.LastName = System.Label.Lead_Default_Name;   
                    //<VL20171030> start  
                    // lead.Legacy_Lead_ID__c = 'CIC'+'^'+ei.External_ID__c+'^'+CompanyID+'^'+lead.Role__c+'-'+contactType+'^'+lead.Name_ID__c;
                    lead.Legacy_Lead_ID__c = 'CIC'+'^'+CompanyID+'^'+lead.Role__c+'-'+contactType+'^'+lead.Name_ID__c;  
                }  
                  String combination_EI_LeadID=ei.External_ID__c+lead.Legacy_Lead_ID__c;
                  wrapper wp = new wrapper(ei.External_ID__c,lead.Legacy_Lead_ID__c,combination_EI_LeadID);
                  listwrap.add(wp);
                  system.debug(LoggingLevel.error,'*********************listwrap  '+listwrap); 
                  ////<VL20171030>  End

              }
              
               
                
                if(lead.Legacy_Lead_ID__c!=null)
              {
                LstLeadLegacyId.add(lead.Legacy_Lead_ID__c); 
                leadList.add(lead);
                //<VL20171025>  start
                mapLeadObj.put(lead.Legacy_Lead_ID__c,lead);
                //<VL20171025>  End

              } 
            }
          }
          }
        
        }  
      }
      if(ei.External_ID__c!=null && (ei.Project_Level__c=='Parent' || ei.Project_Level__c=='Sub'))
      {
        LstExternalId.add(ei.External_ID__c);
        externalInitiativeList.add(ei);
      }  
      }
    }  
     
      
    // ExceptionHandlingClass_CIC_CP ExpClass = new ExceptionHandlingClass_CIC_CP();
    try
    {
      if(externalInitiativeList != null && externalInitiativeList.size()>0)
      {
          Schema.SObjectField externalInitiative_ExternalID = External_Initiative__c.Fields.External_ID__c;
        List<Database.UpsertResult> externalInitiative_Upsert_Records = Database.upsert(externalInitiativeList, externalInitiative_ExternalID, false);
        // 
        
                // Exception Handling for ExternalInitiative
        if(LstExternalId!=null && externalInitiative_Upsert_Records!=null && externalInitiative_Upsert_Records.size()==LstExternalId.size())
        {  
          /*Blob b = ExceptionHandlingClass_CIC_CP.MthdFetchErrors(LstExternalId , externalInitiative_Upsert_Records, '^');
          if(b!=null)
          {
            ExceptionHandlingClass_CIC_CP.autoCreateIssue(b,'CIC_EI','Data_Issue',xmltoParse);
            b = null;
          }*/
                    //<VL20161109>
                    ExceptionHandlingClass_CIC_CP.MthdFetchErrors(LstExternalId, externalInitiative_Upsert_Records , 'External_Initiative','CIC');
        }                        
      }
    }
      
    catch(Exception e)
    {
    ExceptionHandlingClass_CIC_CP.autoCreatedpsException(e,'External_Initiative','CIC');
    }        
    try
    {
            
     //<VL20171030> start           
     /* if(leadList!= null && leadList.size()>0)
      {
        System.debug('$$$$$$$$$$$$ leadList '+leadList);
        Schema.SObjectField lead_LegacyLeadID = lead.Fields.Legacy_Lead_ID__c;
        List<Database.UpsertResult> lead_Upsert_Records = Database.upsert(leadList, lead_LegacyLeadID, false);
          
          
        // Exception Handling for Lead
        
                ExceptionHandlingClass_CIC_CP.MthdFetchErrors(LstLeadLegacyId, lead_Upsert_Records , 'Lead','CIC');   
      }*/
        system.debug(LoggingLevel.error,'*********************list of Lead mapLeadObj '+mapLeadObj);  
        if(mapLeadObj.values()!= null && mapLeadObj.values().size()>0)


        {
            Schema.SObjectField lead_LegacyLeadID = lead.Fields.Legacy_Lead_ID__c;
            List<Database.UpsertResult> lead_Upsert_Records = Database.upsert(mapLeadObj.values(), lead_LegacyLeadID, false);
              
              
            // Exception Handling for Lead
        
            ExceptionHandlingClass_CIC_CP.MthdFetchErrors(LstLeadLegacyId, lead_Upsert_Records , 'Lead','CIC');   




      }
    } 
    //<VL20171030> End
    
    catch(Exception e)
    {
        //<VL20161109>
        ExceptionHandlingClass_CIC_CP.autoCreatedpsException(e,'Lead','CIC');
    }  
      
     //<VL20171030> Start
    map<String,id> mapEIID_EIRecordID =new  map<String,id>();
    map<String,id> mapLeadID_LeadRecordID =new  map<String,id>();
    map<id,id> mapLeadid_EIiD = new map<id,id>();
    List<string> leadLegacyID = new List<string>();
    List<string> extEID = new   List<string>();
    Map<String, EI_Lead__c> mapEILeadObj = new Map<String, EI_Lead__c>();
      
      
      for(External_Initiative__c ext :externalInitiativeList)
      {
          extEID.add(ext.External_ID__c);
      }
      
    List<External_Initiative__c> lstinsertedEIid = [select id,External_ID__c from External_Initiative__c where External_ID__c in :extEID ] ; 
    for(External_Initiative__c EId : lstinsertedEIid )
    {
        mapEIID_EIRecordID.put(EId.External_ID__c,EID.id);
    }   
    for(Lead leagcydata :mapLeadObj.values())
    {
        leadLegacyID.add(leagcydata.Legacy_Lead_ID__c);
    }
      
    List<Lead> lstinsertedLeadid = [select id,Legacy_Lead_ID__c from Lead where Legacy_Lead_ID__c in :leadLegacyID ] ;
    for(Lead leadLegacy : lstinsertedLeadid )
    {
       mapLeadID_LeadRecordID.put(leadLegacy.Legacy_Lead_ID__c,leadLegacy.id);    
    }    
    for(wrapper wrap :listwrap )
      {
         EI_Lead__c jun_EI_Lead = new EI_Lead__c();
          if((mapEIID_EIRecordID.containskey(wrap.ExtID)) && (mapLeadID_LeadRecordID.containskey(wrap.LegacyID)))
          {
              
              jun_EI_Lead.External_Initiative__c=mapEIID_EIRecordID.get(wrap.ExtID);
              jun_EI_Lead.Lead__c=mapLeadID_LeadRecordID.get(wrap.LegacyID);
              jun_EI_Lead.EIidLeadid__c=wrap.EILegacy_UniqueID;
               listExtLead.add(jun_EI_Lead);
               mapEILeadObj.put(jun_EI_Lead.EIidLeadid__c,jun_EI_Lead);
          }
          
      }
      if(mapEILeadObj.values()!= null && mapEILeadObj.values().size()>0)


        {
            Schema.SObjectField EIIDLeadID = EI_Lead__c.Fields.EIidLeadid__c;
            List<Database.UpsertResult> JunctionEIlead_Upsert_Records = Database.upsert(mapEILeadObj.values(), EIIDLeadID, false);
        }   
        
     
  }  
  
  public class wrapper
  {
  
      String ExtID;
      String LegacyID;
      String EILegacy_UniqueID;    
      public wrapper(String EID,String LeadID,String EIidLeadleagcyid)
      {
          this.ExtID=EID;
          this.LegacyID=LeadID; 
          this.EILegacy_UniqueID=EIidLeadleagcyid;
        }
  }
    //<VL20171030> End   

}