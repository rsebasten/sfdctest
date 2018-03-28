/*******************************************************************************
Copyright © 2011 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Used for prefilling field defaults on standard pagelayouts
Change History: <AK 20171214 12:10 PM EST  Change in calling the User_country__c field  CodeCoverage: 91% API version: 39.0
********************************************************************************/

public class DefaultFields {
  
  public  static PageReference onOverrideNew(SObject obj) {
    map<String,String> initParams = ApexPages.currentPage().getParameters();
    initParams.remove('save_new');
    initParams.remove('save');

    Util.Describe dobj;
    system.debug('@@obj'+obj);
    if ( obj!=null)
      dobj=new Util.Describe(obj);
    else
      dobj=new Util.Describe(ApexPages.currentPage().getParameters().get('sobjecttype'));
      
    Util.Describe dUser = new Util.Describe('User');
    User Me=(User) dUser.getObject(UserInfo.getUserId());


    FieldDefaults dfs = new FieldDefaults(dobj);
    PageReference page = new PageReference('/'+dobj.dsr.getKeyPrefix()+'/e');


    map<String,String> defaultParams = dfs.Parameters;
    for (string dp : defaultParams.keySet()) {
      string val=defaultParams.get(dp).tolowercase();
      if (val=='@user.user_country__c') 
        defaultParams.put(dp,String.valueOf('Me.user_country__c'));  // Change: <AK 20171214 12:10 PM EST  Change in calling the User_country__c field 
    
    }
  
    for (string p : initParams.keyset()) {
      system.debug('parameter: '+p+':'+initParams.get(p));
    }

    page.getParameters().putAll(defaultParams);
    page.getParameters().putAll(initParams);  
    
    page.getParameters().put('nooverride', '1');

        return page;
  }    

  
  
  ///////////////////////////////////////////////////////////////////////////////////////
  public class FieldDefaults {
    
    public MAP<string,DefaultField> mapDefaults  {get; private set;} //MAP<destAPIFieldName,DefaultField>
    
    public FieldDefaults(SObject sobj)       { this(new Util.Describe(sobj));     }
    public FieldDefaults(string SObjectType)   { this(new Util.Describe(SObjectType)); }
    public FieldDefaults(Util.Describe dNewObj) {

      FieldDefaults__c myDefaults = FieldDefaults__c.getInstance();
      Util.Describe dDefaults = new Util.Describe('FieldDefaults__c');
      
      //Filter the Default Fields for the correct SObjectType
      mapDefaults = new MAP<string, DefaultField>();
      for (SobjectField f : dDefaults.fieldMap.values()) {
        try {
          Schema.DescribeFieldResult dfr=f.getDescribe();
          LIST<String> splt = dfr.getLabel().tolowercase().split('\\.');
          if (splt.size()==2) {
            //Does Default field label match and existing field of the correct SObjectType
                
            if  ( splt[0]==dNewObj.dsr.getName().tolowercase() && dNewObj.FieldExist(splt[1]) )
                mapDefaults.put(splt[1],new DefaultField(dfr,myDefaults.get(dfr.getName()) ));
          }
        }
        catch(exception ex){}
        system.debug('LOOP:'+f);
      }
    }
///////////////////////////////////////////////////////////////////////////////////////    
    public MAP<string,string> Parameters {
      GET {
        MAP<string,string> rtn = new MAP<string,string>();
        for (DefaultField df : this.mapDefaults.values())
          try {

            if (df.value!=null) {            
              string val=String.valueOf(df.value);
              system.debug('@@val'+val);
              if (val.tolowercase()!='@null') {
                if (val.tolowercase()=='@blank') 
                  val='';
                rtn.put(df.paramName,val);
              }
            }
          }
          catch(exception ex){}
        return rtn;
      }
    }    
///////////////////////////////////////////////////////////////////////////////////////  
    public string UrlParams {
      GET {
        string rtn='';
        for (DefaultField df : this.mapDefaults.values())
          //try {
          if (df.value!=null)
            rtn+='&'+Encodingutil.urlEncode(df.paramName,'UTF-8')+'='+Encodingutil.urlEncode(String.valueOf(df.value),'UTF-8');
          //}
          //catch(exception ex){}
        return (rtn.length()>0) ? rtn.subString(1) : rtn;
      }
    }
///////////////////////////////////////////////////////////////////////////////////////    
    public object defaultFor(string fieldName) {
      return mapDefaults.get(fieldName.toLowercase());
    }
///////////////////////////////////////////////////////////////////////////////////////
  }  //FieldDefaults
    
    
  public class DefaultField {
    private Schema.DescribeFieldResult DFR         {get; private set;}
    public string paramName               {get; private set;}
    public object value                  {get; private set;}
    
    public DefaultField(Schema.DescribeFieldResult adfr, object avalue) {
      this.DFR = adfr;
      this.value = avalue;
      this.paramName = dfr.getName().trim();
      this.paramName=paramName.substring(0,paramName.length()-3);    //remove '__c' from end
      if (paramName.length()==17 && paramName.startswith('DF')) 
        this.paramName=paramName.substring(2);
    }
  }
///////////////////////////////////////////////////////////////////////////////////////
/*
PKH - TEST METHOD IN TEST CLASS

    public static testMethod void test_FieldDefaults() {  
    FieldDefaults dfs = new FieldDefaults('Account');
    system.debug('------------------->FieldDefaults:'+dfs);
    system.debug('------------------->urlParams:'+dfs.UrlParams);
    system.debug('------------------->urlParams:'+dfs.Parameters);  
    system.debug('defaultFor(type):'+dfs.defaultFor('Type'));
    system.debug('defaultFor(type):'+dfs.defaultFor('Country__c'));
    system.debug('defaultFor(nosuchthing):'+dfs.defaultFor('nosuchthing'));  
    
  }
  
  public static testMethod void test_PageInit() {  
      ctrlOverrideNew ctrl = new ctrlOverrideNew(new ApexPages.StandardController(new Account()));
      system.debug(ctrl.init());
  }
*/
}