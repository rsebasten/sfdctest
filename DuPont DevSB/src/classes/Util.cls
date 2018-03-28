/**
* @file
* @author  Thomas E. Snyder II <thomas.snyder@usa.dupont.com>
* @version 1.0
* Copyright © 2010 DuPont. All rights reserved.
* @details Utility Class

TES20110201 added override for createSelectOptions(LIST<sobject> lst, boolean AddNone, string NoneLabel)
    used to apply a custom label for the unseelected value in the dropdown options
TES20110420  changed TypeById() to use a case-sensitive comparison
TES20110519  added try/catch to Util.xmlToDate(), and Util.xmlToDateTime() methods.
TES20110621 Added two new methods (POD, isProduction) Thanks to new URL class (v22.0)
TES20120415 Added getNameField(sobjectType), getRecord(Id), createHash(string)
    Describe.getChildRelationship(string), IsId(string)
TES20120925 Added Describe.primaryRelationship property
TES20121019  Added mapUrlVars(string str)
TES20130307  Updated mapUrlVars to urlDecode (was urlEncode)
TES20130312 Added describe cache methods:  getDescribe(), cacheDescribe, clearDescribeCache();
TES20130411 Updated POD for use with myDomain (try using an OrgId mapping instead of URL.getSalesforceBaseUrl().getHost())
TES20131008 Updated POD logic to use OrgId mapping when request comes from a sites page.
*/

public class Util {
    
/******************************************************************************************************
    Properties
*****************************************************************************************************/  

    ///TES20130411
    /// Name of salesforce pod of current instance
    public static string POD {
        GET { 
        string host=URL.getSalesforceBaseUrl().getHost();
        system.debug('host:'+host);
        string[] arrHost=host.split('\\.');
        string pod=null;
        PageReference page=null;
        if (host.endsWith('my.salesforce.com')) {
            //using MyDomain
            
            if (arrHost.size()==4) {
                //isPROD
                pod=GeneralSettings__c.getOrgDefaults().POD__c;
                if (pod==null)
                    pod=OrgIdToPOD(UserInfo.getOrganizationId());
                if (pod!=null) {
                    pod=pod.toLowercase();
                }
            }
            else if (arrHost.size()>=5) { //one-dupont--QA.cs15.my.salesforce.com
                //isSandBox
                pod=arrHost[arrHost.size()-4];
            }
            else
                pod=OrgIdToPOD(UserInfo.getOrganizationId());
        }
        else if (host.endswith('visual.force.com')){
            //when execution originates from VF the FQN is different (c.na13.visual.force.com, https://one-dupont--qa--c.cs15.visual.force.com)
            pod=arrHost[arrHost.size()-4];
        }
        else if (host.endswith('force.com')) {
            //sites
            // JS20140625
            // Added condition for case ApexPages.CurrentPage() method returning null value
            page=ApexPages.currentPage();
            system.debug('Current page is:'+page);
            if(page==null){
            host=URL.getSalesforceBaseUrl().getHost();
            system.debug('host:'+host);
            system.debug('arrHost[0] is: '+arrHost[0]);
            }
            else{
            host = ApexPages.currentPage().getHeaders().get('X-Salesforce-Forwarded-To');
            system.debug('host:'+host);
            }
            if (arrHost[0]=='dupont')
                pod='NA13';
            else if (host==null) {
                system.debug('host:'+host);
                arrHost=host.split('\\.');
                pod=arrHost[0];
            }
            else 
                pod=OrgIdToPOD(UserInfo.getOrganizationId());
                system.debug('pod is:' +pod);
        }
        else {
            //cs15.salesforce.com, cs15-api.salesforce.com
            pod=arrHost[0];
        }
        system.debug('pod before replace is:' +pod);
        pod=pod.replace('-api','');
        system.debug('pod is:' +pod);
        if (pod=='cs0') 
            pod='tapp0';
        
        return pod;
       }
    }
    
    
    //not always accurate (orgs can move to new pod)
    public static string OrgIdToPOD(string orgid) {
        MAP<string,string> mp = new MAP<string,string> {'0'=>'NA0','3'=>'NA1','4'=>'NA2','5'=>'NA3','6'=>'NA4',
            '7'=>'NA5','8'=>'NA6','A'=>'NA7','C'=>'NA8','E'=>'NA9','9'=>'AP1','2'=>'EU0','D'=>'EU1','b'=>'EU2','T'=>'CSO',
            'S'=>'CS1','R'=>'CS2','Q'=>'CS3','P'=>'CS4','O'=>'CS5','N'=>'CS6','M'=>'CS7','L'=>'CS8','K'=>'CS9','J'=>'CS10',     
            'Z'=>'CS11','V'=>'CS12','W'=>'CS13','c'=>'CS14','e'=>'CS15','f'=>'CS16','g'=>'CS17','t'=>'NA1','1'=>'CS24'};
        return mp.get(orgid.mid(3,1));
    }

/* 
api subdomain [name, Char(4) in OrgId]
"login" => array("Login: Production/Developer",""),
"test"  => array("Login: Sandbox (test)",""),
"prerellogin.pre" => array("Login: Pre-Release", ""),
"na0-api" => array("NA0 (ssl)","0"),
"na1-api" => array("NA1","3"),
"na2-api" => array("NA2","4"),
"na3-api" => array("NA3","5"),
"na4-api" => array("NA4","6"),
"na5-api" => array("NA5","7"),
"na6-api" => array("NA6","8"),
"na7-api" => array("NA7","A"),
"na8-api" => array("NA8","C"),
"na9-api" => array("NA9","E"),
"na10-api" => array("NA10","F"),
"na11-api" => array("NA11","G"),
"na12-api" => array("NA12","U"),
"na14-api" => array("NA14","d"),
"ap0-api" => array("AP0 (ap)","1"),
"ap1-api" => array("AP1","9"),
"eu0-api" => array("EU0 (emea)","2"),
"eu1-api" => array("EU1","D"),
"eu2-api" => array("EU2","b"),
"tapp0-api" => array("Sandbox: CS0 (tapp0)","T"),   
 "cs1-api" => array("Sandbox: CS1","S"),
"cs2-api" => array("Sandbox: CS2","R"),
"cs3-api" => array("Sandbox: CS3","Q"),
"cs4-api" => array("Sandbox: CS4","P"),
"cs5-api" => array("Sandbox: CS5","O"),
"cs6-api" => array("Sandbox: CS6","N"),
"cs7-api" => array("Sandbox: CS7","M"),
"cs8-api" => array("Sandbox: CS8","L"),
"cs9-api" => array("Sandbox: CS9","K"),
"cs10-api" => array("Sandbox: CS10","J"),
"cs11-api" => array("Sandbox: CS11","Z"),
"cs12-api" => array("Sandbox: CS12","V"),
"cs13-api" => array("Sandbox: CS13","W"),
"cs14-api" => array("Sandbox: CS14","c"),
"cs15-api" => array("Sandbox: CS15","e"),
"cs16-api" => array("Sandbox: CS16","f"),
"cs17-api" => array("Sandbox: CS17","g"),
"prerelna1.pre" => array("Pre-Release: NA1","t")
*/  
   


    
    
    
    
    
    
    
     /// Is Current instance production?
    public static boolean isProduction {
    GET { 
    Organization currOrg = [select id, name, isSandbox, instanceName from Organization limit 1];
    system.debug('Current Org = ' + currOrg);
    boolean isProd = false;
    if (currOrg != null && currOrg.isSandbox != null) 
    isProd = !currOrg.isSandbox;
    system.debug('isProd = ' + isProd);
    return isProd;
    }
}

    /////////////////////////////////////////////////////////////////////////////////////////////
    //  genID() generate a psudo id used for indexing  Inserts since the ids 
    //          do not exist yet when working with trigger
    /////////////////////////////////////////////////////////////////////////////////////////////
        public static Id genID(integer i) {
            string s = '000000000000'+string.valueOf(i);
            return (ID) ('gen'+s.substring(s.length()-12));
      }
/******************************************************************************************************

     Describe / Dynamic APEX helpers
******************************************************************************************************/

/**
calls Schema.getGlobalDescribe(),  there is no limits on this call so local caching to a map is unneeded.
*/
public static Map<String, Schema.SObjectType> globalDescribe {
    GET { return Schema.getGlobalDescribe(); }
}



    //gets the name field based on sobjectType
    public static string getNameField(string sobjectType) {
        if (sobjectType.toLowercase()=='case')              return 'CaseNumber';
        else if (sobjectType.toLowercase()=='solution')     return 'SolutionName';
        else return 'Name';
    }

    //gets the name field based on sobjectType
    public static string getNameField_Slow (string sobjectType) {
        string rtn;
        for (SObjectField f : new util.Describe(sobjectType).fieldMap.values()) {
            Schema.DescribeFieldResult dfr=f.getDescribe();
            if (dfr.isNameField())
                rtn=dfr.getName();
        }
        return rtn;
    }
        
        

/**
Gets the sobjectType as a string from an Id or 3 char KeyPrefix
*/
public static string TypeById(string id) {
    try {
        Map<String, Schema.SObjectType> gd = globalDescribe;
        string prefix=id.substring(0,3);
        for (string t : gd.keyset()) {
            //TES20110420  change to case-sensitive comparison
            string objPrefix = gd.get(t).getDescribe().getKeyPrefix();
            if (objPrefix!=null && objPrefix.equals(prefix))
                return t;
        }
    } catch(Exception ex){ system.debug(ex); }
    return null;
}


//getGlobalPrefixMap: Returns Map<Prefix, SObjectTypeName (case-sensitive)> for all SObjects 
public static Map<String, String> getGlobalPrefixMap() {
        MAP<string,Schema.Sobjecttype> gdescr = globalDescribe;
        Map<String, String> rtn = new Map<String, String>();
        for(String sObj : gdescr.keySet()) {
            Schema.Describesobjectresult dsr = gdescr.get(sObj).getDescribe();
            String pre = dsr.getKeyPrefix();
            if (pre!=null && dsr.isAccessible()) 
                rtn.put(pre,String.valueOf(gdescr.get(sObj)));
        }
        return rtn;
    }

public static LIST<SObject> getRecords(LIST<sObject> sos) {
    return new Util.Describe(sos[0]).getObjects(sos);
}
public static LIST<SObject> getRecords(LIST<string> ids) {
    return new Util.Describe(TypeById(ids[0])).getObjects(ids);
}
public static SObject getRecord(string id) {
    return new Util.Describe(TypeById(id)).getObject(id);
}
public static SObject getRecord(string sobjectType, string Id) {
    return new Util.Describe(sobjectType).getObject(id);
}

public static string createHash(string longstring) {
        return EncodingUtil.base64Encode(Crypto.GenerateDigest('MD5',Blob.valueOf(longstring)));
    }

/**
Describe object/fields helper class
*/  

    //TES20130312
    private static MAP<string,Util.Describe> cacheDescribe = new MAP<string,Util.Describe>();   
    // get/cache describe data for an sobject
    public static Util.Describe getDescribe(sobject so) {
        string sot = String.valueof(so.getSobjectType());
        Util.Describe rtn=cacheDescribe.get(sot);
        if (rtn==null) {
            rtn = new Util.Describe(sot);
            cacheDescribe.put(sot,rtn);
        }
        return rtn;
    }

    public static void clearDescribeCache() {
        cacheDescribe.clear();
    }

public virtual class Describe {
    public Schema.Describesobjectresult DSR {get; private set;}
    private Map<String, SObjectField> mapFields;
    
    /** constructor */
    public Describe(string sObjectType) {
        try {
            Schema.SObjectType sot = Schema.getGlobalDescribe().get(sObjectType);
            DSR = sot.getDescribe(); 
        }
        catch(exception ex){}
    }  
         
    public Describe(sobject obj) {
        DSR = obj.GetSObjectType().getDescribe(); 
    }
    

    public Schema.DescribeFieldResult primaryRelationship {
        get {
             for (SObjectField sf : fieldMap.values()) {
                Schema.DescribeFieldResult dfr = sf.getDescribe();
                if (dfr.getRelationshipOrder()==0) 
                    return dfr;
            }       
            return null;
        }
    }
    
    /** 
    get the field map.  
    Simliar to fields.getMap() but will cache the calls.
    */
    public Map<String, SObjectField> fieldMap {
        get {
            try {
                if (mapFields==null)
                    mapFields=DSR.fields.getMap();
                return mapFields;
            }
            catch(exception ex){ return null; }
        }
    }   
    
    /*
        public SET<SObjectField> fields {
        GET {
            try {
            return fieldMap.values();
        }
        catch(exception ex){ return null; }
        }
    }
    
        */
    /** 
    checks weither the fieldname exists (case insenstive)
    */  
    
    public boolean FieldExist(string fieldName) {
        boolean rtn;
        try {rtn=fieldMap.keyset().contains(fieldName.tolowercase());}catch(exception ex){}
        return rtn; 
    }

    /** 
    Describe field
    */      
    public Schema.DescribeFieldResult fieldInfo(string fieldname) {
        Schema.DescribeFieldResult rtn;
        try { rtn=fieldMap.get(fieldname.toLowercase()).getDescribe();}catch(exception ex){}
        return rtn; 
    }
    
    /** 
    returns all the accessible field values from a sobject by record id
    */  
    public sObject getObject(ID id) {
        try {
            sObject so = database.query('SELECT ' + Util.joint(this.AccessibleFieldMap.values(),',')+' from '+DSR.getName()+' WHERE id=\''+id+'\'');
            return so;
        }
        catch(exception Ex) {
            return null;
        }
    }
    public LIST<sObject> getObjects(LIST<string> ids) {
        try {
            LIST<sObject> sos = database.query('SELECT ' + Util.joint(this.AccessibleFieldMap.values(),',')+' from '+DSR.getName()+' WHERE id in :ids');
            return sos;
        }
        catch(exception Ex) {
            return null;
        }
    }
     public LIST<sObject> getObjects(LIST<sObject> sos) {
        try {
            LIST<sObject> rtn = database.query('SELECT ' + Util.joint(this.AccessibleFieldMap.values(),',')+' from '+DSR.getName()+' WHERE id in :sos');
            return rtn;
        }
        catch(exception Ex) {
            return null;
        }
    }   
        
    //MAP<'lowercase fldname', fldname>
    public MAP<string,string> AccessibleFieldMap { 
        GET {
            MAP<string,string> qflds = new MAP<string,string>(); //queryable field
            for (SObjectField sf : fieldMap.values()) {
                Schema.DescribeFieldResult dfr = sf.getDescribe();
                if (dfr.isAccessible()) 
                    qflds.put(String.valueof(sf).tolowercase(),String.valueof(sf));  //get the case specific name
            }
        return qflds;
        }   
    }
    
            
        
    public sObject getObjectStub(ID id) {
        try {
            return database.query('SELECT Id from '+Util.TypeById(id)+' WHERE id=\''+id+'\'');
        }
        catch(exception Ex) {
                return null;
            }
    }
    
    public Schema.ChildRelationship getChildRelationship(string relationshipName) {
        try {
            for ( Schema.ChildRelationship r : DSR.getChildRelationships())
                if (r.getRelationshipName()!=null && r.getRelationshipName().toLowerCase()==relationshipName.toLowercase())
                    return r;
        } catch (Exception ex){}
        return null;
    }   
}
    

///////////////////////////////////////////////////////////////////////////////


    //DescribeField:  works well for singles but if you need to describe field info from multiple fields
    //off the same object use Describe class with describeField.
    public static Schema.DescribeFieldResult describeField(string fullname) {
        try {
            LIST<string> arr = fullname.split('\\.');
            return new describe(arr[0]).fieldInfo(arr[1]);
        }
        catch(exception ex){ return null; }
    }
    public static Schema.DescribeFieldResult describeField(string SobjectType, string FieldName) {
        try {
            return new describe(SobjectType).fieldInfo(FieldName);
        }
        catch(exception ex){ return null; }
    }               

//////////////////////////////////////////////////////////////////////////////////////////
    public static boolean SobjectPutString(sobject obj, Schema.SObjectField fieldToken, String value ) { return SobjectPutString(obj,fieldToken,value,null); }
    public static boolean SobjectPutString(sobject obj, Schema.SObjectField fieldToken, String value, string locale ) {
        Schema.DescribeFieldResult dfr;
        string fldName;
        try {
                dfr = fieldToken.getdescribe(); 
                Schema.Soaptype soapType=dfr.getSOAPType();
                fldName=dfr.getName();
                if      (soapType == Schema.Soaptype.DOUBLE   ) obj.put(fldName,Util.StringToDouble(value,locale));
                else if (soapType == Schema.Soaptype.INTEGER  ) obj.put(fldName,Util.StringToInteger(value,locale));
                else if (soapType == Schema.Soaptype.DATETIME ) obj.put(fldName,Util.stringtoDateTime(value,locale));
                else if (soapType == Schema.Soaptype.DATE     ) obj.put(fldName,Util.stringtoDate(value,locale));
                else if (soapType == Schema.Soaptype.BOOLEAN  ) obj.put(fldName,Util.stringToBoolean(value));
                else {
                    //truncate the string to maxlen
                    if (dfr.getLength()<value.length()) 
                        value=value.substring(0,dfr.getLength()-1);
                              
                    Schema.DisplayType displayType=dfr.getType();
                    if      (displayType == Schema.DisplayType.EMAIL  )     obj.put(fldName,Util.stringToEmail(value));
                    //else if (displayType == Schema.DisplayType.       )   obj.put(fldName,Util.stringToEmail(value));
                    else obj.put(fldName,value);
                }
                system.debug('SobjectPutString: '+fldName+' value: '+value);
                return true;
                }
            catch( Exception ex ) {
                system.debug('!!SobjectPutString:Exception!!! (FieldName: '+fldName+' value: '+value+' DFR: '+dfr+') : '+ex);
                return false;
                }
    }
//////////////////////////////////////////////////////////////////////////////////////////
//  TODO: empty value handler--- blanksAsNulls?  NullsAsBlanks? what about Numbers and dates?
//  Currently will not try to populate a null.
    public static boolean SobjectPutMap(sobject obj, MAP<string,string> fieldData, Describe adescribe) { return SobjectPutMap(obj,fieldData,adescribe,null); }
    public static boolean SobjectPutMap(sobject obj, MAP<string,string> fieldData, Describe adescribe, string locale) {
        try {
            Map<String, SObjectField> flds = adescribe.fieldMap;
            for (string f : fieldData.keySet()) {
                if ( fieldData.get(f)!=null ) { 
                    if (flds.containskey(f.tolowercase()) ) 
                        SobjectPutString(obj,flds.get(f.tolowercase()),fieldData.get(f),locale);
                                
                }
            }
            return true;
        }   
        catch( Exception ex ) {
                system.debug('!!SobjectPutMap:Exception!!! (FieldData: '+fieldData+' Object: '+obj+') : '+ex);
                return false;
                }
    }   
//////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////  

/******************************************************************************************************
Container Methods
******************************************************************************************************/ 
//////////////////////////////////////////////////////////////////////////////////////////  
    //Example  'this=foo&that=bar'
    public static MAP<string,string> mapUrlVars(string str) {
        MAP<string,string> rtn = new MAP<string,string>();
        try {
            for (string pair : str.split('&')) {
                string[] arr=pair.split('=');
                    rtn.put(EncodingUtil.urldecode(arr[0], 'UTF-8'),EncodingUtil.urldecode(arr[1], 'UTF-8'));
            }
        }catch(Exception ex){}
        return rtn;
    }

//////////////////////////////////////////////////////////////////////////////////////////  
    public static MAP<string,string> invertMap(MAP<string,string> amap) {
        MAP<string,string> rtn = new MAP<string,string>();
        for (string m : amap.keyset()) 
            rtn.put(amap.get(m),m);
        return rtn;
    }
 //////////////////////////////////////////////////////////////////////////////////////////    
    public static List<SelectOption> createSelectOptions(LIST<sobject> lst) { return createSelectOptions(lst, true); }
    public static List<SelectOption> createSelectOptions(LIST<sobject> lst, boolean AddNone) { return createSelectOptions(lst, true,' --None-- '); }
    public static List<SelectOption> createSelectOptions(LIST<sobject> lst, boolean AddNone, string NoneLabel) {
        List<SelectOption> rtn = new List<SelectOption>();
        if (AddNone) rtn.add(new SelectOption('',NoneLabel));
        for (sobject so : lst) rtn.add(new SelectOption((string) so.get('Id'),(string) so.get('Name')));
        return rtn;
    }
//////////////////////////////////////////////////////////////////////////////////////////  
    public static List<SelectOption> createSelectOptions(LIST<string> lst) { return createSelectOptions(lst, true); }
    public static List<SelectOption> createSelectOptions(LIST<string> lst, boolean AddNone) { return createSelectOptions(lst, true,' --None-- '); }
    public static List<SelectOption> createSelectOptions(LIST<string> lst, boolean AddNone, string NoneLabel) {
        List<SelectOption> rtn = new List<SelectOption>();
        if (AddNone) rtn.add(new SelectOption('',NoneLabel));
        for (string s : lst) rtn.add(new SelectOption(s,s));
        return rtn;
    }
//////////////////////////////////////////////////////////////////////////////////////////      
   public static string joint(LIST<String> alist, String delim) {
        String out='';
        for (String s :alist) out+=s+delim;
        return (out.length()>0) ? out.substring(0,out.length()-(delim.length())) : out;
    }
//////////////////////////////////////////////////////////////////////////////////////////      
   public static string joint(SET<String> alist, String delim) {
        String out='';
        for (String s :alist) out+=s+delim;
        return (out.length()>0) ? out.substring(0,out.length()-(delim.length())) : out;
    }
//////////////////////////////////////////////////////////////////////////////////////////      
    public static string inClause(LIST<Id> alist) { return inClause(new SET<Id>(alist)); }
    public static string inClause(SET<Id> alist) {
        String out='(';
        for (Id s :alist) out+='\''+s+'\',';
        return (out.length()>1) ? out.substring(0,out.length()-1)+')' : out+')';
    }
//////////////////////////////////////////////////////////////////////////////////////////       
    //Creates in Clause from SET, used for dynamic SOQL statement creation
    public static string inClause(LIST<string> alist) { return inClause(new SET<string>(alist)); }
    public static string inClause(SET<string> alist) {
        String out='(';
        for (string s :alist){
            s=s.replace('\'','\\\''); 
            out+='\''+s+'\',';
        }
        return (out.length()>1) ? out.substring(0,out.length()-1)+')' : out+')';
    }
/******************************************************************************************************
String Methods
******************************************************************************************************/ 
//////////////////////////////////////////////////////////////////////////////////////////
/**
stringToEmail: scrubs and validates returns null if not valid
**/

    public static boolean stringToBoolean(string v) {   
        return new SET<string>{'1','y','yes','t','true','checked'}.contains(v.toLowerCase());
    }

//////////////////////////////////////////////////////////////////////////////////////////  

    public static string stringToEmail(string v) {
        //fat finger scrub (commas to period, space to blank)
        string rtn=v.trim().replace(',','.').replace(' ','');
        //local part allowable characters: _!%&~/?()|*$^'.-+
        return ( Pattern.matches('([a-zA-Z0-9_!#%&~/\\=\\?\\(\\)\\|\\*\\$\\^\'\\.\\-\\+]+)@(([a-zA-Z0-9\\-\\.]+)([a-zA-Z]{2,6})+)', rtn) ) ? rtn : null;    
        return rtn;
    }

//////////////////////////////////////////////////////////////////////////////////////////  
    public static SET<string> splitToSet(string s, string regEx) {
        SET<string> rtn = new SET<string>();
        for (string i : s.split(regEx)) rtn.add(i);
        return rtn;
    }
//////////////////////////////////////////////////////////////////////////////////////////
    public static Double stringToDouble(string v) { return stringToDouble(v, null); }
    public static Double stringToDouble(string v,string locale) {   
        Decimal d = StringToDecimal(v, locale);
        return (d!=null) ? d.DoubleValue() : null;
    }
//////////////////////////////////////////////////////////////////////////////////////////          
    public static integer stringToInteger(string v) { return stringToInteger(v, null);  }
    public static integer stringToInteger(string v,string locale) {
        Decimal d = StringToDecimal(v, locale);
        return (d!=null) ? d.IntValue() : null;
    }
//////////////////////////////////////////////////////////////////////////////////////////          
    public static Decimal stringToDecimal(string v) { return stringToDecimal(v,null);  }                
    public static Decimal stringToDecimal(string v,string locale) {
        Decimal d;
        if (locale==null) locale=Userinfo.getLocale();
        SET<string> euro = new SET<string>{'ca','ca_ES','ca_ES_EURO','da','da_DK','de','de_AT','de_AT_EURO','de_DE','de_DE_EURO','de_LU','de_LU_EURO','el','el_GR','es','es_AR','es_BO','es_CL','es_CO','es_EC','es_ES','es_ES_EURO','es_PE','es_PY','es_UY','es_VE','fr_BE','hr_HR','in','is_IS','it','it_IT','nl','nl_BE','nl_NL','nl_SR','pt','pt_AO','pt_BR','pt_PT','ro','ro_RO','sl_SI','tr','uk','uk_UA','vi','vi_VN'};
        try { 
            string dv=v.replaceAll('[^0-9,\\.]',''); //remove all no numeric chars
            if ( euro.contains(locale) ) {
                dv=dv.replace('.','');  //remove the '.' if any exist
                dv=dv.replace(',','.'); //euro decimal delimiter is ','
                d=Decimal.valueOf(dv);  
            }
                    
            else {
                dv=dv.replace(',','');  //remove the ',' if any exist
                d=Decimal.valueOf(dv);
            }
            }
        catch(Exception ex) { d=null; }
        return d;
    }
//////////////////////////////////////////////////////////////////////////////////////////              
    public static DateTime stringToDateTime(string s) { return stringtoDateTime(s, null); }
    public static DateTime stringToDateTime(string s, string locale) {
        DateTime rtn;
        try { rtn=datetime.valueOf(s); return rtn;} catch(exception ex) {}
        if (rtn==null) rtn=new DateTimeString(s,locale).getDateTime();
        return rtn;     
    }
//////////////////////////////////////////////////////////////////////////////////////////      

    public static Date stringToDate(string s) { return stringtoDate(s, null); } 
    public static Date stringToDate(string s, string locale) {
        Date rtn;
        try { rtn=date.valueOf(s); return rtn;} catch(exception ex) {}
        if (rtn==null) rtn=new DateTimeString(s,locale).getDate(); 
        return rtn;
    }

//////////////////////////////////////////////////////////////////////////////////////////         
    public static boolean isBlank(string v) {
        return ( v==null || v.trim()=='');
    }
//////////////////////////////////////////////////////////////////////////////////////////      
    public static string createGuid(){ return createGuid(null); }
    public static string createGuid(string seed) { 
            String canonical = (seed!=null) ? seed+DateTimetoXml(DateTime.now()) : String.valueOf(Math.random())+DateTimetoXml(DateTime.now());                        
            Blob bsig = Crypto.generateDigest('MD5', Blob.valueOf(canonical));         
            String token =  EncodingUtil.base64Encode(bsig);                 
            if(token.length() > 255) { token =  token.substring(0,254); }  
            return token;   
    }
//////////////////////////////////////////////////////////////////////////////////////////  
     public static boolean isId(string strId) {
        try {
            Id Id = strId;
            return true;
        } catch(Exception ex) {}
        return false;
    }   
    
    
/******************************************************************************************************
DATE/DATE TIME Methods
******************************************************************************************************/ 
//////////////////////////////////////////////////////////////////////////////////////////          
    public static string DateTimetoXml(datetime dt) {
        return (dt==null) ? null : dt.formatGmt('yyyy-MM-dd')+'T'+ dt.formatGmt('HH:mm:ss')+'.'+dt.formatGMT('SSS')+'Z';  
    }
//////////////////////////////////////////////////////////////////////////////////////////  
    public static string DatetoXml(date dt) {
        return (dt==null) ? null : formatDate(dt,'yyyy-MM-dd');  
    }
//////////////////////////////////////////////////////////////////////////////////////////  
    public static DateTime XmltoDateTime(string s) {
        dateTime dt;
        try {
            s=s.replace('T', ' ');
            s=s.replace('Z', '');
            s=s.substring(0,19);
            dt=DateTime.valueOf(s);
        } catch(Exception ex){}
        return dt;
    }
    
//////////////////////////////////////////////////////////////////////////////////////////////
    public static Date XmltoDate(string s) {
        date dt;
        try {
            s=s.substring(0,10);
            dt = Date.valueOf(s);
        } catch(Exception ex){}
        return dt;
    }   
//////////////////////////////////////////////////////////////////////////////////////////      
    /** 
    formats a data using java standard date formatting string
    */  
    public static string formatDate(Date dt, string fmt) {
        return (dt==null) ? null : DateTime.newInstance(dt,Time.newInstance(0,0,0,0)).format(fmt);
    }
    
    
/***************************************************************************************************    
    Private Helper Classes
    
****************************************************************************************************/   

//////////////////////////////////////////////////////////////////////////////////////////      
//reference: https://na13.salesforce.com/help/doc/user_ed.jsp?section=help&target=admin_supported_locales.htm&loc=help&hash=topic-title
    private class DateTimeString {
        private string locale;
        public string datePart  {get; set;}
        public string timePart  {get; set;}
        
        public DateTimeString(string s, string l) {
            if (l==null) l=Userinfo.getLocale();
            this.locale = l;
            string ns = (locale!='hu' && locale!='hr_HR') ? s.replace('. ','.') : s; //ko, ko_KR
            String[] splitDateTime = ns.split(' ',2);
            if ( splitDateTime.size()==2 && new SET<string>{'iw','iw_IL','vi','vi_VN'}.contains(locale) ) {
                timePart=splitDateTime[0];
                datePart=splitDateTime[1];
            }
        else if (splitDateTime.size()>0) {
            datePart=splitDateTime[0];
            timePart=(splitDateTime.size()>1) ? splitDateTime[1] : '';
            }
        }
        
        public Time getTime() {
            return parseTimePart(timePart);
        }
            
        public Date getDate() {
            return parseDatePart(datePart,locale);
        }       
        
        public DateTime getDateTime() {
            Date dt=parseDatePart(datePart,locale);
            Time tm=parseTimePart(timePart);
            return DateTime.newInstanceGMT(dt.year(),dt.month(),dt.day(),tm.hour(),tm.minute(),tm.second());
        }

        private Time parseTimePart(string timePart) {
            boolean isPM = timePart.contains('PM');
            boolean isAM = timePart.contains('AM');
            LIST<Integer> lstTime = new LIST<Integer>();
            for (string s : timePart.split('\\D')) {
                try { lstTime.add(Integer.valueof(s)); }
                catch (exception ex) {}
            }
            for (integer i=lstTime.size(); lstTime.size()<5; i++)  //(4 {hr, min, sec, msec})
                lstTime.add(0); //pad results
            integer hr=(isPM && lstTime[0]<12) ? lstTime[0]+12 : (isAM && lstTime[0]==12) ? 0: lstTime[0];
            return Time.newInstance(hr,lstTime[1],lstTime[2],lstTime[3]);
        }   
        
        private Date parseDatePart(string datePart,string locale) {
            SET<string> ymd = new SET<string>{'ko','ko_KR','hu','lt_LT','in','ja','ja_JP','en_ZA','zh_TW','zh_HK','fr_CA','pl','sv','sv_SE','bg_BG','zh','zh_CN'};
            SET<string> ydm = new SET<string>{'lv_LV'};
            SET<string> mdy = new SET<string>{'en_BB','en_BM','en_GH','en_ID','en_SG','en_US','hy_AM','kk_KZ','km_KH','ur_PK','es_HN','es_PR','es_SV'};     
            date dt;
            String[] stringDate = datePart.split('\\D'); //split by '-','.','/'  '(/|-|\\.)'
            if (stringDate!=null && stringDate.size()>=3) {
                Integer d1 =  Integer.valueOf(stringDate[0]);
                Integer d2 = Integer.valueOf(stringDate[1]);
                Integer d3 = Integer.valueOf(stringDate[2]);
                system.debug(d1+'|'+d2+'|'+d3);
                
                //Buddhist calendar yr
                if (locale=='th_TH') d3-=543;
                
                if (mdy.contains(locale))
                    dt=date.newInstance(d3,d1,d2);
                else if (ymd.contains(locale))
                    dt=date.newInstance(d1,d2,d3);
                else if (ydm.contains(locale))
                    dt=date.newInstance(d1,d3,d2);
                else 
                    dt=date.newInstance(d3,d2,d1);  // most locales fall in this format
            }
            else
                dt=date.valueOf(datePart);
            
            //handle 2-digit years  (1970 is cutoff to be consistent with newInstance(Long i))
            if (dt.year()>0 && dt.year()<70) dt=dt.addYears(2000);
            else if (dt.year()>=70 && dt.year()<100) dt=dt.addYears(1900);
                
            return dt;
        }
    }

    
        
}