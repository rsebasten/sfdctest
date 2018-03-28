/*******************************************************************************
Copyright © 2011 DuPont. All rights reserved. 
Author: Smita Kadian
Email: smita.kadian@usa.dupont.com
Date: 15 July 2011
Description:  test scripts for trigLeadContactMapping
********************************************************************************/
@isTest
private class leadContactMapping_UT { 
    
    
        
    
    /*TES20131104 -  commented out
        this does not represent a proper trigger execution and causes recursion and limit issues.
        please bulkify your loads of same objects or create seperate UT in seperate tests by goal.*/
        
        
    //public static final Id RecordTypeIdLead =Rtype.getIdByDevName('Lead','Level2DPPEMEA');
    public static final Id RecordTypeIdLead =Rtype.getIdByDevName('Lead','Level_2_DPS_BE_AP');
    


    static testMethod void trigLeadContactMapping_UT() {
        RecordType recType=[Select id,Name from RecordType where SobjectType='Contact' AND isActive=true limit 1];
        Profile p1 = [select id from profile where Name='System Administrator' limit 1];
        //commented for dps
        //UserRole r2= [Select id from UserRole where Name='DuPont Fully Owned' limit 1];
        UserRole r2= [Select id from UserRole where Name='PS CRM' limit 1];
        User thisUser1= [Select id from User where Id=:UserInfo.getUserId()];
        User thisUser = new User(LastName='XYZ',UserRoleId=r2.Id,ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Smita.Kadian@infosys.com',UserName='Smita.Kadian.test@usa.dupont.com.t12', EPass_ID__c='NA0000',User_Owning_Org__c='AGCP-CPC',User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Asia Pacific');
        insert thisUser;
        List<Lead> newLeadList = new List<Lead>();
        List<Contact> newContactList = new List<Contact>();
        List<Campaign> newCampaignList = new List<Campaign>();
        List<CampaignMember> newCampaignMemberList = new List<CampaignMember>();
        List<Lead_Contact_Mapping__c> newLeadContactMappingList = new List<Lead_Contact_Mapping__c>();
        System.runAs ( thisUser1 ){
            Account Acc2 = new Account(name='test Account1', country__c ='UNITED STATES', ERP_Customer_Sold_To__c='ABC123',ownerId=thisUser.Id);
            insert Acc2;
            Contact con3=new Contact(lastName='sample',Status__c='New',Account=Acc2,Contact_Country__c='INDIA',Program__c='TBD',Region__c='ASIA PACIFIC',Email='smita.sample11@usa.dupont.com');
            newContactList.add(con3);
            /*
            Contact con2=new Contact(RecordTypeId=recType.id,lastName='sample1',Status__c='New',Account=Acc2,Contact_Country__c='INDIA',Program__c='TBD3',Region__c='ASIA PACIFIC',Email='smita.sample@usa.dupont.com');
            newContactList.add(con2);
            Contact con8=new Contact(RecordTypeId=recType.id,lastName='sample1',Status__c='New',Account=Acc2,Contact_Country__c='INDIA',Program__c='TBD3',Region__c='ASIA PACIFIC',Email='smita.sample@usa.dupont.com');
            newContactList.add(con8);
            Contact con5=new Contact(lastName='sample21',Status__c='New',Account=Acc2,Contact_Country__c='INDIA',Program__c='TBD',Region__c='ASIA PACIFIC',Email='smita.sampleUn@usa.dupont.com');
            newContactList.add(con5);
            Contact con6=new Contact(lastName='sample21',Status__c='New',Account=Acc2,Contact_Country__c='INDIA',Program__c='TB',Region__c='ASIA PACIFIC',Email='smita.sampleU@usa.dupont.com');
            newContactList.add(con6);
            Contact con1=new Contact(lastName='sample',Status__c='New',Account=Acc2,Contact_Country__c='INDIA',Program__c='TBD',Region__c='ASIA PACIFIC',Email='smita.sample@usa.dupont.com');
            newContactList.add(con1);
            Contact con7=new Contact(lastName='sample22',Status__c='New',Account=Acc2,Contact_Country__c='INDIA',Program__c='TB',Region__c='ASIA PACIFIC',Email='smita.sampleU@usa.dupont.com');
            newContactList.add(con7);
            */
            insert newContactList;
            Campaign c=new Campaign(Name='campaign1',List_Type__c='Campaign',Status='Not Started',Owning_Org__c='ABS',  CurrencyIsoCode='USD',Segment_Group__c='Multiple',  Geography__c='AP');
            newCampaignList.add(c);
            /*
            Campaign c1=new Campaign(Name='campaign11',List_Type__c='Campaign',Status='Not Started',Owning_Org__c='ABS',CurrencyIsoCode='USD',Segment_Group__c='Multiple',  Geography__c='AP');
            newCampaignList.add(c1);
            Campaign c2=new Campaign(Name='campaign2',List_Type__c='Campaign',Status='Not Started',Owning_Org__c='ABS', CurrencyIsoCode='USD',Segment_Group__c='Multiple',  Geography__c='AP');
            newCampaignList.add(c2);
            */
            insert newCampaignList;

            Lead_Contact_Mapping__c leadContactMapping1=new Lead_Contact_Mapping__c(Name='first11',Campaign_Id__c=c.id,Contact_Geo_Region__c='ASIA PACIFIC',Contact_Program__c='TBD3',Contact_Record_Type__c=recType.Name,Lead_Origin_Name__c='www.dupont.com/teflon/sample');
            newLeadContactMappingList.add(leadContactMapping1);
            /*
            Lead_Contact_Mapping__c leadContactMapping3=new Lead_Contact_Mapping__c(Name='first13',Contact_Geo_Region__c='ASIA PACIFIC',Contact_Program__c='TB',Contact_Record_Type__c=recType.Name,Campaign_Id__c=c1.id,Lead_Origin_Name__c='www.dupont.com/teflon/sample');
            newLeadContactMappingList.add(leadContactMapping3);
            Lead_Contact_Mapping__c leadContactMapping4=new Lead_Contact_Mapping__c(Name='first14',Contact_Geo_Region__c='ASIA PACIFIC',Contact_Program__c='TKB',Contact_Record_Type__c=recType.Name,Campaign_Id__c=c2.id,Lead_Origin_Name__c='www.dupont.com/teflon/sample');
            newLeadContactMappingList.add(leadContactMapping4);
            */
            insert newLeadContactMappingList; 
            Lead lead2=new Lead(Owning_SBU__c='Chemicals & Fluoroproducts',Owning_Organization__c='DCF FLCH-Fluoromonomer Intermediates',LastName='sample1',Email='smita.sample@usa.dupont.com',Company='XYZ',Lead_Country__c='INDIA',Region__c='ASIA PACIFIC',Origin_Channel_Type__c='Phone',Origin_Name__c='www.dupont.com/teflon/sample',Type__c='Literature',Status='Capture',LeadSource='Website' ,RecordTypeId=RecordTypeIdLead,Lead_Queue__c='DPP Level 2 EMEA');
            newLeadList.add(lead2);
            /*
            Lead lead7=new Lead(Owning_SBU__c='Chemicals & Fluoroproducts',Owning_Organization__c='DCF FLCH-Fluoromonomer Intermediates',LastName='sample1',Email='smita.sample@usa.dupont.com',Company='XYZ',Lead_Country__c='INDIA',Region__c='ASIA PACIFIC',Origin_Channel_Type__c='Phone',Origin_Name__c='www.dupont.com/teflon/sample',Type__c='Literature',Status='Capture',LeadSource='Website' ,RecordTypeId=RecordTypeIdLead,Lead_Queue__c='DPP Level 2 EMEA');
            newLeadList.add(lead7);
            Lead lead5=new Lead(LeadSource='Website' ,RecordTypeId=RecordTypeIdLead,Lead_Queue__c='DPP Level 2 EMEA',Owning_SBU__c='Chemicals & Fluoroproducts',Owning_Organization__c='DCF FLCH-Fluoromonomer Intermediates',LastName='sample1',Email='smita.sampleUn@usa.dupont.com',Company='XYZ',Lead_Country__c='INDIA',Region__c='Asia Pacific',Origin_Channel_Type__c='Phone',Origin_Name__c='www.dupont.com/teflon/sample2',Type__c='Literature',Status='Capture');
            newLeadList.add(lead5);
            Lead lead6=new Lead(LeadSource='Website' ,RecordTypeId=RecordTypeIdLead,Lead_Queue__c='DPP Level 2 EMEA',Owning_SBU__c='Chemicals & Fluoroproducts',Owning_Organization__c='DCF FLCH-Fluoromonomer Intermediates',LastName='sample1',Email='smita.sampleU@usa.dupont.com',Company='XYZ',Lead_Country__c='INDIA',Region__c='Asia Pacific',Origin_Channel_Type__c='Phone',Origin_Name__c='www.dupont.com/teflon/sample3',Type__c='Literature',Status='Capture');
            newLeadList.add(lead6);
            Lead lead1=new Lead(RecordTypeId=RecordTypeIdLead,Lead_Queue__c='DPP Level 2 EMEA',Owning_SBU__c='Chemicals & Fluoroproducts',LeadSource='Website',Owning_Organization__c='DCF FLCH-Fluoromonomer Intermediates',LastName='sample',Email='smita.sample@usa.dupont.com',Company='XYZ',Lead_Country__c='INDIA',Region__c='Asia Pacific',Origin_Channel_Type__c='Phone',Origin_Name__c='www.dupont.com/teflon/sample',Type__c='Literature',Status='Capture');
            newLeadList.add(lead1);
            */
            insert newLeadList;
            CampaignMember campMember = new CampaignMember(Status='Sent', Campaignid=c.id , Contactid=con3.id);
            newCampaignMemberList.add(campMember);
            /*
            CampaignMember campMember2 = new CampaignMember(Status='Sent', Campaignid=c1.id , Contactid=con5.id);
            newCampaignMemberList.add(campMember2);
            CampaignMember campMember3 = new CampaignMember(Status='Sent', Campaignid=c2.id , Contactid=con6.id);
            newCampaignMemberList.add(campMember3);
            CampaignMember campMember4= new CampaignMember(Status='Sent', Campaignid=c2.id , Contactid=con7.id);
            newCampaignMemberList.add(campMember4);
            */
            insert newCampaignMemberList;
                  
        }
    }
    
    
/*******************************************************************************
Copyright © 2011 DuPont. All rights reserved. 
Author: Smita Kadian
Email: smita.kadian@usa.dupont.com
Date: 14 July, 2011
Description:  test scripts for ctrlLeadExtDataTransform
********************************************************************************/
    static testMethod void ctrlLeadExtDataTransform_UT() {
        PageReference page;
        PageReference page1;
        PageReference page2;
        ApexPages.StandardController ct;
        ctrlLeadExtDataTransform c;
        ApexPages.StandardController ct1;
        ctrlLeadExtDataTransform c1;
        ApexPages.StandardController ct2;
        ctrlLeadExtDataTransform c2;
        ctrlLeadExtDataTransform c3;
        Profile p1 = [select id from profile where Name='System Administrator' limit 1];
        //commented for dps
        //UserRole r2= [Select id from UserRole where Name='DuPont Fully Owned' limit 1];
        UserRole r2= [Select id from UserRole where Name='PS CRM' limit 1];
        User thisUser1= [Select id from User where Id=:UserInfo.getUserId()];
        User thisUser = new User(LastName='XYZ',UserRoleId=r2.Id,ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Smita.Kadian@infosys.com',UserName='Smita.Kadian.test@usa.dupont.com.t12', EPass_ID__c='NA0000',User_Owning_Org__c='AGCP-CPC',User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Asia Pacific');
        insert thisUser;
        System.runAs ( thisUser1 ){
            String data='<book id="bk101"><!--<author>Gambardella, Matthew</author>  -->  <price>49.5</price>  <title></title>    </book>';
            Lead lead2=new Lead(Owning_SBU__c='Chemicals & Fluoroproducts',Owning_Organization__c='DCF FLCH-Fluoromonomer Intermediates',LastName='sample1',Email='smita.sample@usa.dupont.com',Company='XYZ',Lead_Country__c='INDIA',Region__c='Asia Pacific',Origin_Channel_Type__c='Phone',Type__c='Literature',Status='Capture',Extended_Data__c=data);
            insert lead2;
            page=new PageReference('/apex/panelLeadExtDataTransform');
            Test.setCurrentPage(page);
            page.getParameters().put('id',lead2.id);
            ct=new ApexPages.StandardController(lead2);
            c=new ctrlLeadExtDataTransform(ct);

            String data1='<salesforce Date="2011-07-13" IncidentEnergy="11"><!--hi--><author>Sample</author><price>44.95</price></salesforce';
            Lead lead3=new Lead(Owning_SBU__c='Chemicals & Fluoroproducts',Owning_Organization__c='DCF FLCH-Fluoromonomer Intermediates',LastName='sample1',Email='smita.sample@usa.dupont.com',Company='XYZ',Lead_Country__c='INDIA',Region__c='Asia Pacific',Origin_Channel_Type__c='Phone',Type__c='Literature',Status='Capture',Extended_Data__c=data1);
            insert lead3;
            page1=new PageReference('/apex/panelLeadExtDataTransform');
            Test.setCurrentPage(page1);
            page1.getParameters().put('id',lead3.id);
            ct1=new ApexPages.StandardController(lead3);
            c1=new ctrlLeadExtDataTransform(ct1);
            c3=new ctrlLeadExtDataTransform();
        }
    }   
}