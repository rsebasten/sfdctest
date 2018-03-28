/*******************************************************************************
Copyright © 2009 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Controller for page: subcenter
********************************************************************************/
public class ctrlSubCenter {


    //form details
    public boolean err                  {set; get;}
    public string errMsg                {set; get;}
    public boolean showValidationError  {set; get;}
    public string validationError       {set; get;}
    public boolean showThankYou         {set; get;}
    public boolean showForm             {set; get;}
        
    public Subform frm                  {set; get;}
    public SubscriptionCenter.SubCenter center      {set; get;}             //Holds all the Subscription Center data
    
    //params
    public string email                 {set; get;}
    public string SiteObjId             {set; get;}
    public string isoLang               {set; get;}
    public string newLeadForm           {set; get;}
    public string HeaderFooter          {set; get;}
                            
    private string                          lastUpdatedLocation;
    

    //////////////////////////////////////////////////////////////////////////////////////
    public pageReference init() {
        
        err=false;
        showForm=true;
        showValidationError=false;
        
        email = ApexPages.currentPage().getParameters().get('em');
        SiteObjId = ApexPages.currentPage().getParameters().get('cid');
        isoLang = ApexPages.currentPage().getParameters().get('l');
        lastUpdatedLocation = ApexPages.currentPage().getParameters().get('src');
        newLeadForm = ApexPages.currentPage().getParameters().get('nlf');
        HeaderFooter= ApexPages.currentPage().getParameters().get('hf');
            
        //decode email if encoded
        if ( email!=null && (! email.contains('@'))) {
            email=System.Encodingutil.base64Decode(email).toString();
        }
        //set lang=en if not provided   
        if (isoLang==null) isoLang = 'en';
        

        ///////////////////////////////////////////////////
        //Center Operation
        ///////////////////////////////////////////////////
        if (SiteObjId==null) {
            errMsg=Label.Site_InvalidSubscription;
            err=true;
            showForm=false;
            return null;
        }
        
        center = new SubscriptionCenter.SubCenter(SiteObjId, email, isolang);
        system.debug('center------------>'+center);
        if (center==null || center.getItemMap()==null || center.getItemMap().size()==0 ) {
            errMsg=Label.Site_InvalidSubscription;
            err=true;
            showForm=false;
            return null;
            }
            
        ///////////////////////////////////////////////////
        //Add a subform to page to collect new lead data    
        /////////////////////////////////////////////////// 
        if ( (email==null && newLeadForm==null) || newLeadForm!=null ) {
            if (newLeadForm==null && center.SubformId !=null)   
            newLeadForm=center.SubformId;
            frm = new SubForm(newLeadForm,isoLang);
            frm.title=null; //dont show a subform title in the center
            if (email!=null) 
                frm.newlead.Email=email;
        }
        ///////////////////////////////////////////////////

        return null;
    }
    //////////////////////////////////////////////////////////////////////////////////////


    
/*******************************************************************************************
    EVENTS
*********************************************************************************************/

    //////////////////////////////////////////////////////////////////////////////////////  
    public string moreSubscriptionsUrl {
        get {
            pageReference pg = Page.subcenters;
            string rtn  = 'http://'+ApexPages.CurrentPage().getHeaders().get('Host')+pg.getUrl()+'?';
            if (isoLang!=null)              rtn += '&l='+isoLang;
            if (email!=null)                rtn += '&em='+SubscriptionCenter.hash(email);
            if (lastUpdatedLocation!=null)  rtn += '&src='+lastUpdatedLocation;
            if (headerfooter!=null)         rtn += '&hf='+headerfooter;
            return rtn;
        }
    }   
    //////////////////////////////////////////////////////////////////////////////////////      
    public string myProfileUrl {
        get {
            pageReference pg = Page.myprofile;
            string rtn  = 'http://'+ApexPages.CurrentPage().getHeaders().get('Host')+pg.getUrl()+'?';
            if (SiteObjId!=null)            rtn += '&cid='+SiteObjId;
            if (isoLang!=null)              rtn += '&l='+isoLang;
            if (email!=null)                rtn += '&em='+SubscriptionCenter.hash(email);
            if (headerfooter!=null)         rtn += '&hf='+headerfooter;
            if (lastUpdatedLocation!=null)  rtn += '&src='+lastUpdatedLocation;
            return rtn;
        }
    }
    //////////////////////////////////////////////////////////////////////////////////////
    public pageReference notme() {
        pageReference pg = Page.subcenter;
        PageReference p = new PageReference('http://'+ApexPages.CurrentPage().getHeaders().get('Host')+pg.getUrl());
        if (SiteObjId!=null)            p.getParameters().put('cid',SiteObjId);
        if (isoLang!=null)              p.getParameters().put('l',isoLang);
        if (lastUpdatedLocation!=null)  p.getParameters().put('src',lastUpdatedLocation);
        p.setRedirect(true);
        return p;
    }   
    
    //////////////////////////////////////////////////////////////////////////////////////
    public PageReference Save() {
        
        showValidationError = false;
        if (frm!=null) {
            
            if (center.isDirty==false && center.numChecked==0) {
                showValidationError=true;
                validationError=Label.Site_MustSelectAList;
                return null;
            }
            
            Lead newLead = frm.toLead();
            newLead.Origin_Channel_Type__c=SubscriptionCenter.NEW_LEAD_ORIGINTYPE;
            newLead.Origin_Name__c=center.name;
            newLead.Origin_Tracking_Code__c=lastUpdatedLocation;

            //Override Owner/Recortype if populated at center
            if (center != null && 
                (   center.SiteObject.NewRecordOwnerId__c !=null || 
                    center.SiteObject.NewRecordTypeId__c  !=null
                )) {
                    newLead.RecordTypeId = center.SiteObject.NewRecordTypeId__c;
                    newLead.OwnerId = center.SiteObject.NewRecordOwnerId__c;
                }
                
                //TESII_20091111 Trigger assignmentRule (floris)
                Database.DMLOptions dmo = new Database.DMLOptions();
                dmo.assignmentRuleHeader.useDefaultRule = true;
                newLead.setOptions(dmo);
                //END TESII_20091111
                if (!Test.isRunningTest()) {
                    upsert newLead;
                    email=newLead.email;
                }
        }


        if (center != null) {
                 center.save(email, lastUpdatedLocation);
            }
            
        ////////////////////////////////////////////////////
        // ReturnUrl handler
        ///////////////////////////////////////////////////
        if (center.returnUrl!=null) {
            string url = SubscriptionCenter.mergefieldUrl(center.returnUrl, email, isoLang, lastUpdatedLocation);
            PageReference p = new PageReference(url);
            p.setRedirect(true);
            return p;
        }
    

        showForm=false;
        showThankYou=true;
    
        
    return null;    
    }


////////////////////////////////////////////////////////////////////////////////////
//      Test script(s)
////////////////////////////////////////////////////////////////////////////////////

public static testMethod void test_ctrlSubCenter1() {
        SubscriptionCenter.TESTMODE=true;
        
        string subformId = Sitebuilder.testAddSubForm();
        string CenterId = SubscriptionCenter.testAddSubCenter('Center1');
        
        Lead lead1 = new Lead(lastname='test', Company='test', email='tester1@tester.com');
        insert lead1;
        Lead lead2 = new Lead(lastname='test', Company='test', email='tester2@tester.com');
        insert lead2;
        Account a = new Account(name='test', Country__c='United States');
        insert a;
        Contact contact1 = new Contact(lastname='test', email='tester1@tester.com', Account=a, Contact_Country__c='United States');
        insert contact1;
                
        Test.startTest();
        PageReference pageRef = Page.SubCenter;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('cid', CenterId);
        ApexPages.currentPage().getParameters().put('em', lead1.email);
        ApexPages.currentPage().getParameters().put('src', 'testMethod');
        ApexPages.currentPage().getParameters().put('hf', '0');
        ApexPages.currentPage().getParameters().put('nlf',subformId);
        
        ctrlSubCenter controller = new ctrlSubCenter();
        controller.init();
        SubscriptionCenter.SubCenter center = controller.center;
        controller.notme();
        controller.Save();  //should err that nothing checked
        system.debug(controller.myProfileUrl);
        system.debug(controller.moreSubscriptionsUrl);
        center.getItems()[0].checked=true;
        center.getItems()[1].checked=true;
        controller.Save();
    
        //add a contact w/ same email
        ApexPages.currentPage().getParameters().put('l', 'fr');
        ApexPages.currentPage().getParameters().put('cid', CenterId);
        ApexPages.currentPage().getParameters().put('em', contact1.email);
        ApexPages.currentPage().getParameters().put('src', 'testMethod2');
        ApexPages.currentPage().getParameters().put('hf', '1');
        controller.init();
        center = controller.center;
        center.getItems()[0].checked=true;
        center.getItems()[1].checked=true;
        controller.Save();
        
        
        //open as contact w/ same email and make change wo/ return url
        ApexPages.currentPage().getParameters().put('cid', CenterId);
        ApexPages.currentPage().getParameters().put('em', contact1.email);
        controller.init();
        center = controller.center;
        center.getItems()[0].checked=false;
        center.getItems()[1].checked=true;
        center.returnUrl=null; 
        controller.Save();
        
        //No Center Id
        ApexPages.currentPage().getParameters().put('cid', null);
        controller.init();
        ApexPages.currentPage().getParameters().put('cid', 'xxx');
        controller.init();
        
        
        Test.stopTest();
    
    }   



}