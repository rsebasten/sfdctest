/////////////////////////////////////////////////////////////////////////////////////////////////////////
//Copyright © 2014 DuPont. All rights reserved. 
//Name :ctrlBINA_EnvelopesRegistration
//Author :Rajiv Kumar Bhatter<Rajiv_Bhatter@infosys.com>, Sanjay Nandi<Sanjay_Nandi@infosys.com>
//Description: This  UT class for controller  ctrlBINA_SurfaceProdVFPanel
//************************************<MG-20140827>***************************************************//
@isTest(SeeAllData=true)
private class ctrlBINA_SurfaceProdVFPanel_UT{
    static testMethod void testctrlBINA_SurfaceProdVFPanel() {
    final Id CASERECORDTYPEID=Rtype.getIdByDevName('Case','BI_NA_Surfaces_Case');
     Profile p1 = [select id from profile where Name='System Administrator' limit 1];
        UserRole r1= [Select id from UserRole where Name='PS CRM' limit 1];
        User user1 = new User(LastName='XYZ',UserRoleId=r1.Id,ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='sanjay_nandi@infosys.com',UserName='sanjay@infosys.com.t12', EPass_ID__c='NA0000',User_Owning_Org__c='AGCP-CPC',User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Latin America');
        insert user1;
        System.runas(user1){    
        
        Case cas=new case(product_selected__c='Materail1;Material2',status='new', recordtypeid=CASERECORDTYPEID, ownerId=user1.Id);
        insert cas;
        case cas1 = [SELECT id,product_selected__c From case LIMIT 1];
        
        Test.startTest();
        
        PageReference myVfPage = Page.BI_NA_SurfacesProdVFPanel;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('id', cas.id);
        ApexPAges.StandardController sc = new ApexPages.StandardController(cas1);
        ctrlBINA_SurfaceProdVFPanel c = new ctrlBINA_SurfaceProdVFPanel(sc);
        Test.stopTest();
          
        System.assertEquals(c.SelectedMaterials .size(), 2);}
        
  }
    }