@isTest
private class callReportingHandler_UT{

    static testMethod void callReportScoring(){
    List<Call_Report__c> callReportList=new List<Call_Report__c>();
    //[01022017] Merge&Spin: Removed Hard coding of record type Id
    //updated sObjectType to fix test failure
    string AGCP_CPC_LA_Simple_RType = RType.getIdByDevName('Account','AGCP_CPC_LA_Simple');
    string AGCP_CPC_LA_RType = RType.getIdByDevName('Call_Report__c','AGCP_CPC_LA');
    Account acc=new Account(Name='testAccount',recordtypeid= AGCP_CPC_LA_Simple_RType,Country__c='INDIA');
    insert acc;
    Geography__c grphy=new Geography__c(Name='Indiana',Code__c='SR_TMENA',Code2__c='TMENA',Level__c=2.00,CurrencyIsoCode='USD');
    insert grphy;
    Date myDate = date.newinstance(1960, 2, 17);
    Rule__c ruleObj=new Rule__c(Name='Call Report Scoring LA',IsActive__c=true,SObject_Type__c='Call_Report__c',Record_Type__c='AGCP_CPC_LA',Rule_Type__c='Scoring',Range__c='70=A&50=B&30=C&10=D&0=E');
    insert ruleObj;
    Rule_Item__c ruleItemObj=new Rule_Item__c(Name='TestRuleItem1',IsActive__c=true,Field_API__c='Topic__c',Rule__c=ruleObj.id,Operator__c='equals',Value__c='Logistics',Score__c=2);
    insert ruleItemObj;
    Rule_Item__c ruleItemObj1=new Rule_Item__c(Name='TestRuleItem2',IsActive__c=true,Field_API__c='Topic__c',Rule__c=ruleObj.id,Operator__c='equals',Value__c='Application',Score__c=2);
    insert ruleItemObj1;
    Rule_Item__c ruleItemObj2=new Rule_Item__c(Name='TestRuleItem3',IsActive__c=true,Field_API__c='Topic__c',Rule__c=ruleObj.id,Operator__c='equals',Value__c='Packaging Destination',Score__c=2);
    insert ruleItemObj2;
    Rule_Item__c ruleItemObj3=new Rule_Item__c(Name='TestRuleItem4',IsActive__c=true,Field_API__c='Topic__c',Rule__c=ruleObj.id,Operator__c='equals',Value__c='Illegal Products',Score__c=2);
    insert ruleItemObj3;
    Rule_Item__c ruleItemObj4=new Rule_Item__c(Name='TestRuleItem5',Field_API__c='Topic__c',Rule__c=ruleObj.id,Operator__c='equals',Value__c='Correct Use of PPE',Score__c=2);
    insert ruleItemObj4;
    Rule_Item__c ruleItemObj5=new Rule_Item__c(Name='TestRuleItem6',Field_API__c='Topic__c',Rule__c=ruleObj.id,Operator__c='equals',Value__c='DuPont School Project',Score__c=3.5);
    insert ruleItemObj5;
    
    Call_Report__c callRprtObj;
    Call_Report__c callRprtObj1;
    for(Integer k=0;k<1;k++){
        //KT [11072017]: To remove Level_of_Effort_hours__c=235,Distance_Traveled__c=45.00, reference
        callRprtObj=new Call_Report__c(Name='smplCallRprt',Topic__c='Application',recordTypeId=AGCP_CPC_LA_RType ,Account__c=acc.Id,Status__c='Planned',Call_Date__c=myDate ,
                             Channel__c='Phone',Type__c='Call Report Only',Attendees__c='testUser1',Geography__c=grphy.id);
        //KT [11072017]: To remove ,Level_of_Effort_hours__c=231,Distance_Traveled__c=234.00, reference
        callRprtObj1=new Call_Report__c(Name='smplCallRprt1',Topic__c='DuPont School Project',recordTypeId=AGCP_CPC_LA_RType, Account__c=acc.Id,Status__c='Planned',Call_Date__c=myDate ,
                             Type__c='Call Report Only', Channel__c='Phone',Attendees__c='testUser2',Geography__c=grphy.id);
    }
    callReportList.add(callRprtObj);
    callReportList.add(callRprtObj1);
    Insert callReportList;
    //assert the result of the ruleEngine
    // To remove score__c reference 
    //if(callReportList.get(0).score__c!=null)
    //    System.assertEquals(2.0, callReportList.get(0).score__c);        
     
    callReportList.get(0).Topic__c='Logistics';    
    update callReportList;           
    }
  }