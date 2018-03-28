/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 

Modifications:
TES20120312 : Added DMLOption to email queue after lead creation
********************************************************************************/
public class ctrlWebToLead
{

private Boolean flagLead=false; //FLAGGED LEADS SENT TO TRASH QUEUE
private Boolean validLead=true; //INVALID LEADS ARE NOT INSERTED

private String redirect_page;
private SiteObject__c siteobject;
private ID lead_id;
private String log_message;

private String DEFAULT_COMPANY='Undefined';
private String DEFAULT_RETURN_URL='http://www.dupont.com';
private String TRASH_LEAD_QUEUE='Trash';
private String REDIRECT_PARAMETER='redirect_page';
private String CAPTCHA_ERROR_RETURN_URL_PARAMETER='form_url';
private String CAPTCHA_ERROR_RETURN_FIELDS_PARAMETER='c_fields';
private String BLANK_REFERER_PARAMETER='url';

public PageReference init(){
    log_message='';
    redirect_page=getText(REDIRECT_PARAMETER);
    if ((redirect_page==null)||(redirect_page=='')){redirect_page=DEFAULT_RETURN_URL;}
    
    if (lookupSiteObject()==true)
    {
        if(siteobject.captcha__c==true){checkCAPTCHA();}
    }
    else
    {
        log_message+='Cannot find corresponding SiteObject\n';
        validLead=false;
    }
    
    //INSERT LEAD
    if (validLead==true) {insertLead();}
    
    logActivity();
        
    PageReference pageRef = new PageReference(redirect_page);
    pageRef.setRedirect(true);
    return pageRef;
}

public void checkCAPTCHA()
{
    reCAPTCHA rc = new reCAPTCHA();
    rc.challenge=getText('recaptcha_challenge_field');
    rc.response=getText('recaptcha_response_field');
    rc.verify();
    System.debug('Checking CAPTCHA value: ' + rc.correctResponse);
    if (rc.correctResponse==false){
        log_message+='CAPTCHA failure\n';
        validLead=false;
        redirect_page=getText(CAPTCHA_ERROR_RETURN_URL_PARAMETER);
        if ((redirect_page==null)||(redirect_page=='')){redirect_page=DEFAULT_RETURN_URL;}
        if (redirect_page!=DEFAULT_RETURN_URL){redirect_page+='?'+fieldsToQueryString(getText(CAPTCHA_ERROR_RETURN_FIELDS_PARAMETER));}
    }
}

public void insertLead()
{
    //Create Lead
    Spam spm = new Spam();
    Map<String,String> lead_values = new Map<String,String>();
    Map<string,string> params = ApexPages.currentPage().getParameters();
    Map<string, WebToLeadMap__c> leadmap = WebToLeadMap__c.getAll();
    Map<string,string> modleadmap = new Map<String,String>();
    for (string mid : leadmap.keySet())
    {
        String k=mid.toLowerCase();
        if (k.length()>15){k=k.substring(0,15);}
        modleadmap.put(k,leadmap.get(mid).fieldName__c);
        System.debug('modleadmap key is: ' + k + ' has value= ' + leadmap.get(mid).fieldName__c);
    }
    for (string fid : params.keySet()) {
        //if (leadmap.containsKey(fid)) {
            //lead_values.put(leadmap.get(fid).fieldName__c,params.get(fid));
            //if (spm.isSpam(params.get(fid))==true){flagLead=true;System.debug('SPAM DETECTED!');}
        //}
        if (modleadmap.containsKey(fid.toLowerCase())) {
            System.debug('saving ' + fid);
            lead_values.put(modleadmap.get(fid.toLowerCase()),params.get(fid));
            if (spm.isSpam(params.get(fid))==true){flagLead=true;System.debug('SPAM DETECTED!');}
        }
    }
    boolean lead_creation_success=false;
    Lead l = new Lead();
    lead_creation_success=Util.SobjectPutMap(l,lead_values,new Util.Describe(l));
    System.debug('lead_creation_success is: ' + lead_creation_success);

    database.DMLOptions dmo = new database.DMLOptions();
    dmo.AssignmentRuleHeader.UseDefaultRule=true;
    dmo.EmailHeader.triggerAutoResponseEmail = true;
    dmo.EmailHeader.triggerUserEmail = true;	//TES20120312
    l.setOptions(dmo);

    if (flagLead==true){l.lead_queue__c=TRASH_LEAD_QUEUE;}
    if (l.company==null){l.company=DEFAULT_COMPANY;}
        
    try
    {
        Database.SaveResult sr = Database.insert(l);
        if(sr.isSuccess()==true){lead_id=sr.getId();System.debug('Lead Insertion Successful');}
    }
    catch (Exception e)
    {
        System.debug('Lead save failure: ' + e);
    }
    
    //INSERT CAMPAIGN
    String campaign_id=params.get('Campaign_ID');
    if ((lead_id!=null)&&(campaign_id!='')) {addCampaign(lead_id,campaign_id);}
    
}

public void addCampaign(ID lead_id,String c_id)
{
    CampaignMember member = new CampaignMember();
    member.CampaignId=c_id;
    member.leadid=lead_id;
    try{
        Database.SaveResult csr = Database.insert(member);
    }
    catch (Exception e)
    {
        System.debug('Campaign insertion failure: ' + e);
    }
}

public Boolean getBoolean(String fieldname)
{
    Boolean b=false;
    String t=ApexPages.currentPage().getParameters().get(fieldname);
    if (t==null) {b=false;}
    if (t=='1') {b=true;}
    if (t=='0') {b=false;}
    return b;
}

private String getText(String fieldname)
{
    String t=ApexPages.currentPage().getParameters().get(fieldname);
    if (t==null) {t='';}
    return t;
}

   
  public String fieldsToQueryString(String t){

    String qs='';
    if (t!=null){

        String mt = EncodingUtil.urlDecode(t,'UTF-8');        
        List<String> formfields=mt.split(':');
        for (String i : formfields)
        {
            qs+=i+'='+getText(i)+'&';
        }
    }
    return qs;
}

private void logActivity()
{
    String request_header='';
    String request_parameters='';
    Map<string,string> headermap=ApexPages.currentPage().getHeaders();
    for (String i : headermap.keySet()){
        request_header+=i + '=' + headermap.get(i) + ';';
    }
    Map<string,string> parametermap=ApexPages.currentPage().getParameters();
    for (String i : parametermap.keySet()){
        request_parameters+=i + '=' + parametermap.get(i) + ';';
    }
    
    boolean log_success=false;
    Map<String,String> log_values = new Map<String,String>();
    
    try{
        log_values.put('messages__c',log_message);
        log_values.put('Origin_URL__c',headermap.get('referer'));
        log_values.put('Header__c',request_header);
        log_values.put('Parameters__c',request_parameters);
        if(lead_id!=null) {log_values.put('Lead__c',lead_id);}
        log_values.put('Messages__c','');
        if(siteobject!=null) {log_values.put('Site_Object__c',siteobject.id);}
    }
    catch (Exception e)
    {
        System.debug('Cannot create log: ' + e);
    }
    
    SiteActivityLog__c log = new SiteActivityLog__c();
    log_success=Util.SobjectPutMap(log,log_values,new Util.Describe(log));
    if (log_success==true) {
        try{
            Database.SaveResult logsave = Database.insert(log);
        }catch (Exception e){
            System.debug('Log save failure: ' + e);
        }
    }
}

public boolean lookupSiteObject()
{
    boolean foundsiteobject=false;
    String referer=getReferer();
    if ((referer!=null)&&(referer!='')) 
    {
        List<SiteObject__c> siteobjects= [select id, name, externalId__c, captcha__c from SiteObject__c where ExternalId__c =: referer];
        if (!siteobjects.isEmpty()) 
            {
            siteobject=siteobjects[0];
            foundsiteobject=true;
            }
    }
    return foundsiteobject;
}

public String getReferer()
{
    String referer='';
    referer=ApexPages.currentPage().getHeaders().get('Referer');
    if (referer!=null) 
    {
        
        String[] urlparts = referer.split('\\?');
        referer = urlparts[0]; 
        urlparts = referer.split('\\#');
        referer = urlparts[0];
    }
    if ((referer==null)||(referer=='')) {referer=ApexPages.currentPage().getParameters().get(BLANK_REFERER_PARAMETER);}
    try
        {referer=referer.toLowerCase();}
    catch (Exception e)
        {
        System.debug('Cannot find referer:' + e);
        referer='';
        }
    return referer;
}
   
/*public static testMethod void testCtrlWebToLead(){
    ctrlWebToLead cwtl = new ctrlWebToLead();
    cwtl.init();
    String test='one:two:three';
    String testqs=cwtl.fieldsToQueryString(test);
    cwtl.insertLead();
    cwtl.checkCAPTCHA();
    cwtl.getReferer();
    cwtl.lookupSiteObject();
    cwtl.getBoolean('test');
} */

}