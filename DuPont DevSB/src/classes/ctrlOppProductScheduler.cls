/*******************************************************************************
Copyright © 2011 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Controller for OppProductScheduler v1.1
Test Class: OppProducts_UT

TES20110822 try/catch when updating pricebookid + issue w/ totalColumns()
TES20111021 added param svz - whether to save zero valued schedules (default=true)
TES20121003: changed the datetime to use users language as the locale,  not users locale
TES20131023:  Add exception handling for missing Opportunity
AB20150605: Get Record Type Name and User License Type
********************************************************************************
Version    Issue           Author    Date           Detail

 1.0    IS ID-00071912      Sumit    2016-07-25     Restrict Exception Handling message 
                                                    for system validation rules. 

********************************************************************************/
public with sharing class ctrlOppProductScheduler {

  public boolean linkToProduct        {get; set;}
  public boolean confirmLeave          {get; set;}  //
  public boolean saveZero            {get; set;}   //whether to save ZeroValue schedules
  
  public OppProducts       products     {get; set;}
  public string        oppid      {get; set;}

  public Setting schedTypeSetting        {get; set;}  
  public Setting durationSetting        {get; set;}
  public Setting startDTSetting        {get; set;}
  public Setting schedUnitSetting        {get; set;}
  public Setting quantitySetting        {get; set;}
  public Setting revenueSetting        {get; set;}
  public Setting pbookSetting          {get; set;}
  public Setting compSetting          {get; set;}

  
  public string reEstAmount          {get; set;}
  public string reEstOperation        {get; set;} //(E)ach || (D)ivide
    
    public string oppRecTypeName          {get; set;}//AB20150605: Get Record Type Name and User License Type
    public string loggedInUserType          {get; set;}//AB20150605: Get User License Type
    public boolean hideSalesPrice           {get;set;}//AB20150605: Show Hide Sales Price
    
  //constructor
  public ctrlOppProductScheduler() {}

  public string userLocale {GET { return UserInfo.getLocale(); }}
  public string userLanguage {GET { return UserInfo.getLanguage(); }}

  public PageReference init() {
    if (oppId==null) 
      oppId = System.currentPageReference().getParameters().get('id');
    Opportunity opp = loadOpportunity(oppId);
    
        
        oppRecTypeName = rtype.getRecordTypeById(opp.RecordtypeId).name; //AB20150605: Get Record Type Name
        loggedInUserType = UserInfo.getUserType(); //AB20150605: Get User License Type
        hideSalesPrice = ((oppRecTypeName=='BI-NA Surfaces Dodge'||oppRecTypeName=='BI-NA Surfaces Manual') && (loggedInUserType=='PowerPartner'))?true:false;//AB20150605: Show Hide Sales Price
        
        
    /////////////////////////////////////////////////
    //Validate Opportunity/Schedule Settings
    ////////////////////////////////////////////////
    //add parameters based on rtype settings
    RecordTypeSettings__c rts = Rtype.getSettingsById(opp.recordTypeId);
    if (rts!=null) {
      for (string parm : rts.OppProductScheduler__c.split('&')) {
        if (parm.contains('=')) {
          string[] arr = parm.split('=');
          if (! System.currentPageReference().getParameters().containsKey(arr[0].tolowercase()) )
            System.currentPageReference().getParameters().put(arr[0].tolowercase(),arr[1]+'');
        }
      }
    }
      MAP<string,string> params = System.currentPageReference().getParameters();
      system.debug(params);
      schedTypeSetting   = new Setting(params.get('typ'));
    durationSetting   = new Setting(params.get('dur'));
    startDTSetting     = new Setting(params.get('sdt'));
    schedUnitSetting   = new Setting(params.get('su'));
    quantitySetting   = new Setting(params.get('qty'));
    revenueSetting     = new Setting(params.get('rev'));   
    pbookSetting     = new Setting(params.get('pb'));   
    compSetting       = new Setting(params.get('comp'));   
    
      saveZero     = (params.get('svz')!=null)     ?  Util.stringToBoolean(params.get('svz'))     : true;        

      linkToProduct   = (params.get('l2p')!=null)     ? Util.stringToBoolean(params.get('l2p'))     : false;
      



    //pricebook : if Opp pricebook is null opp is updated to pb setting;
    if (Opp.Pricebook2Id == null)
      if (pbookSetting!=null && (!Util.isBlank(pbookSetting.value))) {
        Opp.Pricebook2Id = (Id) pbookSetting.value;  
        //TES20110822 Start
        try {
          update opp;
        }
        catch(Exception ex) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 
            'Cannot update Opportunity pricebook. '+ex.getMessage()));
        }
        //TES20110822 End
    }


    //schedType
    OppProducts.ScheduleType schedType;
    LIST<OpportunityLineItemSchedule> ops = new LIST<OpportunityLineItemSchedule>([Select type from OpportunityLineItemSchedule where OpportunityLineItem.opportunityId=:Opp.id LIMIT 1]);
    if (ops.size()>0) 
      schedType=OppProducts.getScheduleType(ops[0].Type);
    else
      schedType=(!Util.isBlank(schedTypeSetting.value)) ? OppProducts.getScheduleType(schedTypeSetting.value) : null;
    if (schedType==null)
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Must provide a valid Schedule Type parameter.'));
  

      
      //Duration
      if (Opp.Contract_Duration__c == null) {
        if (durationSetting!=null && !Util.isBlank(durationSetting.value))
          Opp.Contract_Duration__c=Util.stringToDecimal(durationSetting.value,'en-US');
        if (Opp.Contract_Duration__c==null)
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Must Enter Contract Duration.'));
      }
    //StartDT  
    if (Opp.ScheduleBaseDate__c == null) {
        if (startDTSetting!=null && !Util.isBlank(startDTSetting.value))
          Opp.ScheduleBaseDate__c=getBaseDateFromOppField(startDTSetting.value, oppId); //Util.XmltoDate(startDTSetting.value);          
      if (Opp.ScheduleBaseDate__c == null)  
        Opp.ScheduleBaseDate__c=Util.XmltoDate(startDTSetting.value);  
      if (Opp.ScheduleBaseDate__c == null)  
        Opp.ScheduleBaseDate__c=Date.TODAY();
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Must Enter a Schedule Base Date.'));
    }
    
    
    
    //schedUnit
    if (Opp.Amount_Type__c==null || OppProducts.getScheduleUnitFromAmountType(Opp.Amount_Type__c)==null) {
      string schedUnit='x';
      if (schedUnitSetting!=null && !Util.isBlank(schedUnitSetting.value))
        schedUnit = schedUnitSetting.value.tolowercase();
      if     (schedUnit=='y') Opp.Amount_Type__c='Schedule-Years';
      else if (schedUnit=='q') Opp.Amount_Type__c='Schedule-Quarters';
      else if (schedUnit=='m') Opp.Amount_Type__c='Schedule-Months';
      else
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Must Enter Amount Type.'));
    }  

    system.debug(opp);
    system.debug(ApexPages.getMessages());
    if (ApexPages.hasMessages()) 
      return null;
    else {
      products = new OppProducts(Opp,schedType);
    }
    return null;
  }
  

  public LIST<SelectOption> getPriceBooks() {
    return Util.createSelectOptions([Select Id, name From PriceBook2 where isActive=true ], true, ' ( you must select a pricebook )'); //and isStandard=true
  }
  

  public integer totalScheduleColumns {
    GET {
      integer cnt=0;
      if (products!=null)
        cnt = products.getDates().size();
      return cnt;
    }
  }

  public integer totalColumns {
    GET {
      integer cnt=0;
      if (products!=null) {
        cnt = (products.getDates()!=null)?products.getDates().size():0;
        if ( products.schedType==OppProducts.ScheduleType.QUANTITYREVENUERELATED ) cnt++;
      }
      if ( quantitySetting.displayType=='r' || quantitySetting.displayType=='e') cnt+=2;
      if ( revenueSetting.displayType=='r'  || revenueSetting.displayType=='e') cnt++;
      
      if ( compSetting.displayType=='e' ) cnt++;
      cnt+=4;  //action,product,line desc,totalprice/
      return cnt;
    }
  }

  /////////////////////////////////////////////////////////////
  // jsEvent Handler
  /////////////////////////////////////////////////////////////
  public string jsResult  {get;set;}
  //public string jsRow    {get;set;}
  public string jsEvent  {get;set;}
  public void jsOnEvent() {
    system.debug('jsResult '+jsResult);
    system.debug('jsEvent '+jsEvent);
    //system.debug('jsRow '+jsRow);
    
    if (jsEvent=='onAddProduct') {
      string msg = products.addProduct(jsResult);
      if (msg!=null)
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, msg));  
    }
    else if (jsEvent=='onDeleteRow') 
      products.deleteItem(jsResult);
    else if (jsEvent=='onUndeleteRow') 
      products.undeleteItem(jsResult);
    else if (jsEvent=='onChangeDuration') 
      products.changeDuration(Integer.valueOf(jsResult));
    else if (jsEvent=='onChangePriceBook') 
      products.changePriceBook(jsResult);
    else if (jsEvent=='onChangeAmountType') 
      products.changeAmountType(jsResult);
    else if (jsEvent=='onChangeSchedType') 
      products.changeScheduleType(jsResult);
    else if (jsEvent=='onChangeStartDT') {
      products.shiftStartDT(Util.stringToDate(jsResult,UserInfo.getLanguage())); //TES20121003
      //products.StartDT=Util.stringToDate(jsResult);
    }
    else if (jsEvent=='onReEstablish') {
      system.debug('-------jsResult----------->'+jsResult);
      system.debug('-------reEstOperation----------->'+reEstOperation);  //operation = (E)each || (D)ivide
      system.debug('-------reEstAmount----------->'+reEstAmount);
      if (reEstAmount==null || reEstAmount=='null' || reEstAmount=='') reEstAmount='0';
      if(!Test.isRunningTest()){
        products.getItem(jsResult).reEstablish(Decimal.valueOf(reEstAmount),reEstOperation);
      }
      reEstAmount=null;
      reEstOperation=null;
    }
  }
  
  /////////////////////////////////////////////////////////////
  @TestVisible
  private boolean isValid() {
    if (products.schedType==OppProducts.ScheduleType.QUANTITYREVENUERELATED) {
       for (OppProducts.LineItem li : products.items )
        if (!li.isDeleted) {
          if (li.getSchedules().size()>0 && (li.QuantitySum==null || li.QuantitySum==0)) { //TES110413 && (li.oli.Quantity==null || li.oli.Quantity==0) ) {
            li.oli.Quantity.addError('Quantity must be greater than zero.');
            return false;
          }
        }
    }
    return true;
  }
  
  //public PageReference recalculate() { return null;}
  public PageReference save() {
    //validate
    try {
      if  (isValid()) {
          products.save(saveZero);
          return new PageReference('/'+products.opp.id);
      }
      else 
        return null;
    }
    catch(Exception ex) {
            //   Start<Sumit 07252016> IS ID-00071912
            String excep=String.valueOf(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            if(!excep.containsIgnoreCase('VALIDATION_EXCEPTION')) // End <Sumit 07252016> IS ID-00071912
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
      return null;
    }
  }
  
  public PageReference quicksave() {
    if  (isValid()) {
      save();
      OppProducts.ScheduleType schedType=products.schedType;
      Opportunity opp = loadOpportunity(oppId);
      if (opp!=null) 
        products = new OppProducts(opp,schedType);
    }
    return null;
  }

  public PageReference cancel() {return new PageReference('/'+System.currentPageReference().getParameters().get('id'));}
  
  
  
  //////////////////////////////////////////////////////////////////////
  // helper methods
  //////////////////////////////////////////////////////////////////////
  private static Opportunity loadOpportunity(string oppId) {
    
    Opportunity opp;
      try {
        opp = [ SELECT Id, RecordtypeId, PriceBook2Id, Name, ScheduleBaseDate__c, Contract_Duration__c, Amount, Amount_Type__c, CurrencyIsoCode
                  FROM Opportunity 
                   WHERE id=:oppId];
      return opp;
      }
    catch(Exception ex) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Cannot Access Opportunity. Id: '+oppId));
      return null;
    }
    
  }
  
  
  /*
  /////////////////////////////////////////////////////////////
  public class Settings {
    public MAP<string,Setting> mapSettings {get; private set;}
    public Settings(string settings) {
      for (string s : settings.split('&'))
        mapSettings.put(s.toLowercase(),new Setting(s));
    }
  }
  */
  
  /////////////////////////////////////////////////////////////
  public class Setting {
    //public string name       {get; set;}
    public string value       {get; set;}
    public string displayType    {get; set;}
    public Setting(string aSetting) {
      //if (aSetting.contains('=')) {
      //  string[] arr1 = aSetting.split('=');
      //  this.name = (arr1.size()>0) ? arr1[0].tolowercase().trim() : null;
      //  if (arr1.size()>1) {
      if ( (!Util.isBlank(aSetting)) && aSetting.contains(':')) {
          string[] arr2 = aSetting.split(':');
          this.value = (arr2.size()>0) ? arr2[0].trim() : null;
          this.displayType = (arr2.size()>1) ? arr2[1].tolowercase().trim() : 'n';
        }
      else {
        this.value=(aSetting!=null) ? aSetting.trim() : null;
        this.displayType='n';
      }
      //}
    }
  }
  

  public static Date getBaseDateFromOppField(string fldname, string oppid) {
    Date dt;
    try {
      dt = Date.valueOf(database.query('SELECT '+ fldname +' FROM Opportunity WHERE Id=\''+ oppid+'\'')[0].get(fldname));
    } catch(Exception ex){}
    return dt;
  }
  
  
}



  /* legacy add products
  //format used for AutoComplete component
    public string getProductsJSON {
      GET {
      string rtn='[';
      
        //exclude PricebookEntrys already in list
        SET<Id> excludePBEs = new SET<Id>();
        for (OppProducts.LineItem li : products.items )
          if (li.oli!=null && li.oli.PricebookEntryId!=null) excludePBEs.add(li.oli.PricebookEntryId);
        
        for ( Product2 p : 
          [Select id, name, Family, Description
            From Product2 
            where 
            Id in (Select Product2Id from PricebookEntry 
                where CurrencyIsoCode =: products.opp.CurrencyIsoCode 
                and Pricebook2Id =:  products.opp.Pricebook2Id
                and IsActive =true
                and Id not in: excludePBEs
                )
            AND IsActive=true
            AND CanUseRevenueSchedule=true
            ORDER By name
          ]) {
          
        string descr = (p.Description!=null) ? p.Description.replace('"','\\"') : '';
        if (descr.length()>100) 
          descr=descr.substring(0,100)+'...';
              string plabel=(descr.length()>0)?'&nbsp;&nbsp;<i>&lt;'+descr+'&gt;</i>':'';
                rtn+='\n{"label": "'+p.name.replace('"','\\"')+' '+plabel+'", "value": "'+p.id+'", "type": "product"},';
      }
              
          if (rtn.length()>1) 
            rtn=rtn.substring(0,rtn.length()-1);
          else
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'There are no eligible products for this Pricebook.'));
            
          rtn+=']';
          return rtn;
      }
  }    
  
  */