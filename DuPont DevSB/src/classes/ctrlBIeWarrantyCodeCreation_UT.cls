///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Name :ctrlWarrantyCodeGeneration_UT
//Author :Manasa.R
//Description: This class is the test class for ctrlWarrantyCodeGeneration
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@isTest
private class ctrlBIeWarrantyCodeCreation_UT {

    static testMethod void createUser() {
	    ctrlBIeWarrantyCodeCreation warrantycode = new ctrlBIeWarrantyCodeCreation();
	    
	    /*null values set*/
	    warrantycode.startCode='';
	    warrantycode.endCode='';
	    warrantycode.owingOrg='BI';
	    warrantycode.generateWarCodes();
	     
	    
	   // Test.setCurrentPage(pref); 
	    
	    /*invalid values for start code*/
	    warrantycode.startCode='asd';
	    warrantycode.endCode='12';
	    warrantycode.owingOrg='BI';
	    warrantycode.generateWarCodes();
	    
	    /*invalid values for end code*/
	    warrantycode.startCode='123';
	    warrantycode.endCode='asa';
	    warrantycode.owingOrg='BI';
	    warrantycode.generateWarCodes();
	    
	    /*start code greater than end code*/
	    warrantycode.startCode='200';
	    warrantycode.endCode='100';
	    warrantycode.owingOrg='BI';
	    warrantycode.generateWarCodes();
	    
	     /*difference greater than 1000*/
	    warrantycode.startCode='1';
	    warrantycode.endCode='10002';
	    warrantycode.owingOrg='BI';
	    warrantycode.generateWarCodes();
	    
	    /*delete all the list records*/
	    List<List__c> allLists = new List<List__c>();
	    Id recType=Rtype.getIdByDevName('List__c','eWarranty');
	    allLists = [Select Id from List__c where RecordTypeId=:recType];
	    delete(allLists);
	    
	    /* Frist list to be inserted */   
	    warrantycode.startCode='500';
	    warrantycode.endCode='600';
	    warrantycode.owingOrg='BI';    
	    warrantycode.generateWarCodes(); 
	    
	    List__c listNew = new List__c(RecordTypeId=recType,Name='eWarranty Label Generation_100_200',Owning_Org__c='BI',Code_1__c='100',Code_2__c='200');
	    insert(listNew);
	    
	    /*start code already pressent*/
	    warrantycode.startCode='100';
	    warrantycode.endCode='650';
	    warrantycode.owingOrg='BI';
	    warrantycode.generateWarCodes();
	    
	     /*end code already pressent*/
	    warrantycode.startCode='10';
	    warrantycode.endCode='200';
	    warrantycode.owingOrg='BI';
	    warrantycode.generateWarCodes();
	    
	    /* correct values set*/   
	    warrantycode.startCode='300';
	    warrantycode.endCode='400';
	    warrantycode.owingOrg='BI';    
	    warrantycode.generateWarCodes(); 
	  
	    warrantycode.getCodesList();
	    
	    /* below are the test cases for padding and encoding of a string */
	    String warCode;
	    String encode;
	    
	    warCode = ctrlBIeWarrantyCodeCreation.leftPad('140',5,'0');
		system.assertEquals('00140', warCode);
		
		warCode = ctrlBIeWarrantyCodeCreation.leftPad('',5,'0');
		system.assertEquals(null, warCode);
		
		warCode = ctrlBIeWarrantyCodeCreation.leftPad('140',5,'00');
		system.assertEquals('00140', warCode);
		
		warCode = ctrlBIeWarrantyCodeCreation.leftPad('140',5,'000');
		system.assertEquals('00140', warCode);
		
		warCode = ctrlBIeWarrantyCodeCreation.leftPad('00140',5,'0');
		system.assertEquals('00140', warCode);
		
		warCode = ctrlBIeWarrantyCodeCreation.leftPad('00140',4,'0');
		system.assertEquals('00140', warCode);
		
		encode=ctrlBIeWarrantyCodeCreation.encode(warCode);
		system.assertEquals('MU4',encode);     
    }
}