/*******************************************************************************
Copyright © 2010 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Controller for page: DPP_Certification

TESII20100525 - AddColor() updates the MagicAnswer to fix the old date from getting cloned
SJAGA20110819 - Retrieving the Account Name from the Qualification Map

********************************************************************************/
public class ctrlDPP_Certification {
    
    public static final string COLOR_Q_PREFIX       =   'DPP_FabricColor';
    public static final string MEMBERPORTAL_NAME    =   'DPP Certification';
    public static final string REFERENCE_Q_NAME     =   'DPP_FabricReference';
    private static final string DEFAULT_PAGEWIDTH   =   '732px';  //'732px';
    public static final string COLOR_Q_PREFIX_Garment = 'DPP_GarmentType'; 
    //public MemberPortal.Key cpKey                     {set; get;}
    public MemberPortal.Profile profile                 {set; get;}
    public string stage                                 {set; get;}
    public string selectedCertId                        {set; get;} 
    public string newScriptId                           {set; get;} 
    public SiteScript script                            {set; get;} 
    public string uploadMsg                             {set; get;} 
    public string errorMsg                              {set; get;} 
    public string printOrientation                      {set; get;} 
    public string AccName                               {set; get;}
    private MAP<string,Cert> mapCerts;      
    private MAP<integer,string> CertOrder;      
    private string parentQual                           {set; get;} 
    public string qualsubtype                           {set; get;} 
    public Pagebase page {set; get;}    
    public static final string INTERNAL_ONLY_PREFIX =   'INTERNAL_ONLY_';                
    public static final string EXTERNAL_RONLY_PREFIX =  'EXTERNAL_READONLY_';

///////////////////////////////////////////////////////////////////////////////////////////////////////
// Constructors
///////////////////////////////////////////////////////////////////////////////////////////////////////
    public ctrlDPP_Certification() {
        PageBase.getInstance().addEvent('ctrlDPP_Certification.constructor():Apexpages.currentPage():'+String.valueOf(Apexpages.currentPage()));
        init();
    }
    public ctrlDPP_Certification(object controller) {
        PageBase.getInstance().addEvent('ctrlDPP_Certification.constructor(ctrlPageBase controller)' );
        init();
        }

///////////////////////////////////////////////////////////////////////////////////////////////////////
// init
///////////////////////////////////////////////////////////////////////////////////////////////////////
    public void init() {

        PageBase pb = PageBase.getInstance();
        pb.addEvent('ctrlDPP_Certification.init()' );
        profile = pb.getValidProfile(MEMBERPORTAL_NAME);
       
        if (profile!=null) {
            goHome();
        }
        else {
            //THROW INVALID PROFILE
            stage='error';
            errorMsg='Access Denied.';
        }       
    }
///////////////////////////////////////////////////////////////////////////////////////////////////////
//  init for DPP_Certification__PDF
///////////////////////////////////////////////////////////////////////////////////////////////////////
    public PageReference initpdf() {

        selectedCertId = ApexPages.currentPage().getParameters().get('cid');
        profile = PageBase.getInstance().getValidProfile(MEMBERPORTAL_NAME);
        if (profile!=null) {
            refreshCerts();
            if (selectedCertId!=null) {         
                Cert cert=getSelectedCert();
                string vw=ApexPages.currentPage().getParameters().get('vw');
                if (cert!=null) {
                    if (vw!=null && vw.tolowercase()=='acert')
                        stage='activecert';
                    else
                        stage='cert';
                    script=new SiteScript(cert.scriptid, cert.headerid);
                    
                     for (SiteScript.QA qa : script.questions) {                                                  
                           if (qa.developerName!=null && qa.developerName.contains(EXTERNAL_RONLY_PREFIX)) {
                               qa.readonly=true;                                                        
                           }                                        
                           else if (qa.developerName!=null && qa.developerName.contains(INTERNAL_ONLY_PREFIX)) {
                             qa.visible=false;                        
                           }                    
                     }
                    
                    qualsubtype = cert.subtype;
                    printOrientation='portrait';
                    PageBase.getInstance().pageWidth='720px';
                    return null;
                } 
            }
            printOrientation='landscape';
            PageBase.getInstance().pageWidth='960px';
            stage='list';   
            script=null;                                                                                                                                                                                        
        }
        else {
            //throw new memberPortal.MemberPortalException('Access Denied.');
            stage='error';
            errorMsg='Access Denied.';
        }       
                
        return null;

    }


///////////////////////////////////////////////////////////////////////////////////////////////////////
//  Data Methods
/////////////////////////////////////////////////////////////////////////////////////////////////////// 

    ////////////////////////////////////////////
    //returns all Certs for MemberPortal.Account
    public LIST<Cert> Certs {
        GET { 
            //return mapCerts.values(); 
            LIST<Cert> c = new LIST<Cert>();
            for (string id: CertOrder.values()) {
                c.add(mapCerts.get(id));
                }
            return c;
            }
    }
    ////////////////////////////////////////////
    //returns list of Certs for MemberPortal.Account where stage='Active' 
    public LIST<Cert> activeCerts {
        GET { 
            //return mapCerts.values(); 
            LIST<Cert> c = new LIST<Cert>();
            for (string id: CertOrder.values()) {
                if ( mapCerts.containsKey(id) && mapCerts.get(id).stage!=null &&
                        mapCerts.get(id).stage.tolowercase()=='active')
                    c.add(mapCerts.get(id));
                }
            if(c.size() > 0) AccName = c[0].account;  //trace
            return c;
            }
    }
    
    ////////////////////////////////////////////
    //returns the currently selected cert
    public Cert getSelectedCert() {
        return (selectedCertId==null) ? null : mapCerts.get(selectedCertId);
    }   
    
    //used on the Certificate   
    public string lightFastness {
        GET {
            if (script!=null && script.getQuestion('DPP_FabricColorLightfastness')!=null )
                return script.getQuestion('DPP_FabricColorLightfastness').answer;
            else return '';
        }
    }   
        
///////////////////////////////////////////////////////////////////////////////////////////////////////
//  Action Methods
/////////////////////////////////////////////////////////////////////////////////////////////////////// 

    public void SelectCert() {
        Cert cert=getSelectedCert();
        if (cert!=null) {
            script=new SiteScript(cert.scriptid, cert.headerid);
            DPPFabricCert_Score(script);
            showResult();
        }
    }
///////////////////////////////////////////////////////////////////////////////////////////////////////     
    private void showResult() {
        stage='results';
        script.setReadOnly(true);
        page.lnavWidth='50px';
        page.pageWidth=DEFAULT_PAGEWIDTH;
    }
/////////////////////////////////////////////////////////////////////////////////////////////////////// 
    
    public List<DPT_Nomex_CertTypes__c> NewButtons {
        GET { 
            List<DPT_Nomex_CertTypes__c> rtn = new List<DPT_Nomex_CertTypes__c>();
                Map<string, DPT_Nomex_CertTypes__c> mapButtons = DPT_Nomex_CertTypes__c.getAll();
                LIST<string> order = new LIST<string>(mapButtons.KeySet());
                order.sort();
                for (string s : order)
                    rtn.add(mapButtons.get(s));
                return rtn;
            }
    }
    
/////////////////////////////////////////////////////////////////////////////////////////////////////// 
    public void NewCert() {
        if (newScriptId!=null) {
            page.lnavWidth='10px';
            page.pageWidth=DEFAULT_PAGEWIDTH;
            stage='new';
            script=new SiteScript(newScriptId); 
            
            for (SiteScript.QA qa : script.questions) {                          
            if (qa.developerName!=null && qa.developerName.contains(EXTERNAL_RONLY_PREFIX)) {
                    qa.readonly=true;                                
            }                
            else if (qa.developerName!=null && qa.developerName.contains(INTERNAL_ONLY_PREFIX)) {                                
                    qa.visible=false;
            }
          }
       }
    }
    
    
/////////////////////////////////////////////////////////////////////////////////////////////////////// 
    public void Save() {
        if (script.validate()) {
            //update the score prior to writing
            DPPFabricCert_Score(script);    
            script.save();
            selectedCertId=script.WriteToId;
            refreshCerts();
            showResult();
        }
    }
/////////////////////////////////////////////////////////////////////////////////////////////////////// 
    public void AddColor() {

        //paint the page to only allow edit for color values
        for (SiteScript.QA qa : script.questions) {
            
            //TESII20100525 - updates the MagicAnswer for this clone
            qa.reapplyMagicAnswer();
            
            if (qa.developerName!=null && qa.developerName.contains(EXTERNAL_RONLY_PREFIX)) {
                 qa.readonly=true;                                                        
            }  
                                                  
            else if (qa.developerName!=null && qa.developerName.contains(INTERNAL_ONLY_PREFIX)) {
                    qa.visible=false;                        
            }
            
            else if (qa.developerName!=null && qa.developerName.startsWith(COLOR_Q_PREFIX)) {
                qa.readonly=false;
                qa.answer='';
            }
            else if (qa.developerName==REFERENCE_Q_NAME) {
                qa.readonly=false;
            } 
            else 
                qa.readonly=true;
        }       
        page.lnavWidth='10px';
        page.pageWidth=DEFAULT_PAGEWIDTH;
        stage='addcolor';
    }

/////////////////////////////////////////////////////////////////////////////////////////////////////// 
    public void AddGarmentType() {
    
                for (SiteScript.QA qa : script.questions) {
            
                    //TESII20100525 - updates the MagicAnswer for this clone
                    qa.reapplyMagicAnswer();
            
                    if (qa.developerName!=null && qa.developerName.contains(EXTERNAL_RONLY_PREFIX)) {
                        qa.readonly=true;                                
                    }                
                    else if (qa.developerName!=null && qa.developerName.contains(INTERNAL_ONLY_PREFIX)) {                                
                        qa.visible=false;
                    }
                
                    else if (qa.developerName!=null && qa.developerName.contains(COLOR_Q_PREFIX_Garment)) {
                        qa.readonly=false;
                        qa.answer='';
                    }
                    else if (qa.developerName==REFERENCE_Q_NAME) {
                        qa.readonly=false;
                    } 
                    else 
                        qa.readonly=true;
                    }
        page.lnavWidth='10px';
        page.pageWidth=DEFAULT_PAGEWIDTH;       
        stage='addtype';
    }    
  
/////////////////////////////////////////////////////////////////////////////////////////////////////// 
    public void SaveColor() {
        if (script.validate()) {

            //clear out the write to Question Id, so it does not write to the 
            //same qual
            string parentQual=script.WriteToId;
            script.WriteToIdQuestion.answer=null;
            script.clearWriteToObject();
            script.header=null;
            
            script.save();
            selectedCertId=script.WriteToId;
            
            Qualification_Item__c qr = new Qualification_Item__c(
                Parent_Qualification__c = parentQual,
                Qualification_Item__c = script.WriteToId,
                Type__c='Additional Colour');   
            insert qr;  

            refreshCerts();
            showResult();
        }

    }

/////////////////////////////////////////////////////////////////////////////////////////////////////// 
    public void SaveGarmentType() {
        if (script.validate()) {

            //clear out the write to Question Id, so it does not write to the 
            //same qual
            string parentQual=script.WriteToId;
            script.WriteToIdQuestion.answer=null;
            script.clearWriteToObject();
            script.header=null;
            
            script.save();
            selectedCertId=script.WriteToId;
            
            Qualification_Item__c qi = new Qualification_Item__c(
                Parent_Qualification__c = parentQual,
                Qualification_Item__c = script.WriteToId,
                Type__c='Additional Type');   
            insert qi;  

            refreshCerts();
            showResult();
        }

    }
/////////////////////////////////////////////////////////////////////////////////////////////////////// 
    public PageReference goHome() {
            PageBase.getInstance().lnavWidth='10px';
            PageBase.getInstance().pageWidth='1300px';
            PageBase.getInstance().showLNAV=false;
            stage='home';
            refreshCerts();
            selectedCertId=null;
            script=null;
            return null;
        }
        
/////////////////////////////////////////////////////////////////////////////////////////////////////// 

///////////////////////////////////////////////////////////////////////////////////////////////////////
//  Inner Classes
///////////////////////////////////////////////////////////////////////////////////////////////////////     
    public class Cert {
        private Qualification__c qual;
        public Cert(Qualification__c q) { 
            qual=q; 
        }
        
        //public integer  index                     { get; set; }
        public string   qualificationId         { GET {return qual.id;} }
        public string   referenceId             { GET {return qual.Reference_Id__c;} }
        public string   certtype                { GET {return qual.subtype__c;} }
        public date     datetaken               { GET {return qual.Script_Header__r[0].Date_Taken__c;} }
        public string   status                  { GET {return qual.status__c;} }
        public string   scriptId                { GET {return qual.Script_Header__r[0].Script__c;} }
        public string   headerId                { GET {return qual.Script_Header__r[0].id;} }
        public double   score                   { GET {return qual.Script_Header__r[0].Score__c;} } 
        public datetime createddate             { GET {return qual.createddate;} }
        public string   colorReference          { GET {return qual.Colour_Reference__c;}  }
        public string   color                   { GET {return (qual.Colour__c!=null && (!qual.Colour__c.tolowercase().endswith('other'))) ? qual.Colour__c : qual.Colour_Comments__c; } }
        public string   startDate               { GET {return Util.formatDate(qual.Start_Date__c, 'MMM dd yyyy');} }
        public string   endDate                 { GET {return Util.formatDate(qual.End_Date__c, 'MMM dd yyyy');} }
        public integer  weight                  { GET {return (qual.Weight__c!=null) ? qual.Weight__c.intvalue() : null ;} }
        public string   result                  { GET {return (qual.Qualification_Program__r!=null) ? qual.Qualification_Program__r.name : null;} }
        public string   brand                   { GET {return qual.Brand__r.name;} }
        public string   construction            { GET {return qual.Construction__c;} }
        public string   stage                   { GET {return qual.Stage__c;} }
        public string   finish                  { GET {return qual.finish__c; } } 
        public string   parentReferenceId       { GET {return (qual.Qualification_Relations1__r.size()>0) ? qual.Qualification_Relations1__r[0].Parent_Qualification__r.Reference_Id__c : null;} }
        public string   parentId                { GET {return (qual.Qualification_Relations1__r.size()>0) ? qual.Qualification_Relations1__r[0].Parent_Qualification__r.Id : null;} }
        public string   account                 { GET {return qual.Account_Name__r.Name; } }
        public string   owner                   { GET {return qual.Owner__r.Name; } } 
        public string   subtype                 { GET {return qual.SubType__c; } }           
    }       
    
        
        
///////////////////////////////////////////////////////////////////////////////////////////////////////
//  Helper functions
///////////////////////////////////////////////////////////////////////////////////////////////////////
    private void refreshCerts() {
        if (profile!=null) {
            Qualification__c[] qs = [ 
                    SELECT Id, q.SubType__c, q.Reference_Id__c, q.CreatedDate, Colour_Comments__c, q.status__c,
                         q.Colour__c, q.Colour_Reference__c, q.Stage__c, q.Start_Date__c, q.End_Date__c, finish__c, q.Weight__c,
                          q.Qualification_Program__r.name, q.Certification_Result__c, q.Brand__r.name, q.Construction__c,
                         q.Account_Name__r.Name, Owner__r.Name,
                        ( SELECT Id, Script__c, Date_Taken__c, Score__c FROM Script_Header__r LIMIT 1),
                        ( SELECT Parent_Qualification__r.Id, Parent_Qualification__r.Reference_Id__c FROM Qualification_Relations1__r LIMIT 1)
                    FROM Qualification__c q
                    WHERE Account_Name__c=:profile.accountid
                    AND q.Type__c='Certification'
                    ORDER BY q.CreatedDate desc
                    ];
                    
            mapCerts = new MAP<string,Cert>();
            CertOrder = new MAP<integer,string>();
            integer order=0;
            for (Qualification__c q : qs ) {
                CertOrder.put(order++,q.id);
                mapCerts.put(q.id, new Cert(q));
            }
        }
    }

    private static void DPPFabricCert_Score(SiteScript ascript) {
            
            decimal weight = (ascript.getQuestion('DPP_FabricWeight')!=null) ? ascript.getQuestion('DPP_FabricWeight').answerAsNumber : 0;

            if (weight>=150) {
                //Tensel Strength +150
                TextScore_StrengthCal(ascript,'DPP_PerformanceISO_13934_Warp',weight,new LIST<decimal>{6.25,6.25},new LIST<decimal>{408,642});
                TextScore_StrengthCal(ascript,'DPP_PerformanceISO_13934_Weft',weight,new LIST<decimal>{6.25,6.25},new LIST<decimal>{408,642});
                //Tear Strength +150
                TextScore_StrengthCal(ascript,'DPP_PerformanceISO_13937_Warp',weight,new LIST<decimal>{0.35,0.31},new LIST<decimal>{32.5,32.1});
                TextScore_StrengthCal(ascript,'DPP_PerformanceISO_13937_Weft',weight,new LIST<decimal>{0.35,0.31},new LIST<decimal>{32.5,32.1});
                
                //Abrasion resistance +150
                TextScore_SimpleGreaterThan(ascript.getQuestion('DPP_PerformanceISO_12947'), new LIST<decimal>{60000,40000});
                
                 TextScore_NAR(ascript,'DPP_PerformanceATPV','EXTERNAL_READONLY_DPP_PerformanceNAR',weight);
            }
            else {
                //Tensel Strength N/A

                //Tear Strength -150
                //TextScore_SimpleGreaterThan(ascript.getQuestion('DPP_PerformanceISO_13937_Warp'), new LIST<decimal>{20,19.999});
                //TextScore_SimpleGreaterThan(ascript.getQuestion('DPP_PerformanceISO_13937_Weft'), new LIST<decimal>{20,19.999});
                //Abrasion resistance -150
                //TextScore_SimpleGreaterThan(ascript.getQuestion('DPP_PerformanceISO_12947'), new LIST<decimal>{20000,10000});             
            }


            //Tear Strength (Inner liner, weight independant)
            TextScore_SimpleGreaterThan(ascript.getQuestion('DPP_Inner_PerformanceISO_13937_Warp'), new LIST<decimal>{20,19.999});
            TextScore_SimpleGreaterThan(ascript.getQuestion('DPP_Inner_PerformanceISO_13937_Weft'), new LIST<decimal>{20,19.999});
            
            //Abrasion resistance (Inner liner, weight independant)
            TextScore_SimpleGreaterThan(ascript.getQuestion('DPP_Inner_PerformanceISO_12947'), new LIST<decimal>{20000,10000});         
            
            //Tensel Strength   (Racing, weight independant)
            TextScore_SimpleGreaterThan(ascript.getQuestion('DPP_Racing_PerformanceISO_13934_Warp'), new LIST<decimal>{600,599.999});
            TextScore_SimpleGreaterThan(ascript.getQuestion('DPP_Racing_PerformanceISO_13934_Weft'), new LIST<decimal>{600,599.999});           
            
            //Tear Strength     (Racing, weight independant)
            TextScore_SimpleGreaterThan(ascript.getQuestion('DPP_Racing_PerformanceISO_13937_Warp'), new LIST<decimal>{25,24.999});
            TextScore_SimpleGreaterThan(ascript.getQuestion('DPP_Racing_PerformanceISO_13937_Weft'), new LIST<decimal>{25,24.999});         
                                        
            //Dimension Change (weight independant)
            TextScore_SimpleLessThan(ascript.getQuestion('DPP_PerformanceISO_5077_Warp'), new LIST<decimal>{3,3.000001});
            TextScore_SimpleLessThan(ascript.getQuestion('DPP_PerformanceISO_5077_Weft'), new LIST<decimal>{3,3.000001});   
            
            //Dimension Change for Knit (weight independant)
            TextScore_SimpleLessThan(ascript.getQuestion('DPP_Knit_PerformanceISO_5077_Warp'), new LIST<decimal>{-999999999999.0,5.0});
            TextScore_SimpleLessThan(ascript.getQuestion('DPP_Knit_PerformanceISO_5077_Weft'), new LIST<decimal>{-999999999999.0,5.0}); 
            
        }
    
    private static void TextScore_SimpleGreaterThan(SiteScript.QA q, LIST<decimal> var1) {
            if (q!=null) {
                decimal val = (q.answerAsNumber!=null) ? q.answerAsNumber : 0;
                if  ( val >= var1[0] )      {   q.textScore=String.valueOf(val);    q.score=2;}
                else if ( val >= var1[1] )  {   q.textScore=String.valueOf(val);    q.score=1;}
                else                        {   q.textScore=String.valueOf(val);    q.score=0;}     
            }
        }   
            
    private static void TextScore_SimpleLessThan(SiteScript.QA q, LIST<decimal> var1) {
            if (q!=null) {
                decimal val = (q.answerAsNumber!=null) ? q.answerAsNumber : 0;
                val=Math.abs(val);  //TES20100706 - allow neg values (use abs per bernd)
                if  ( val <= var1[0] )      {   q.textScore=String.valueOf(val);    q.score=2;}
                else if ( val <= var1[1] )  {   q.textScore=String.valueOf(val);    q.score=1;}
                else                        {   q.textScore=String.valueOf(val);    q.score=0;} 
            }
        }
        
    private static void TextScore_StrengthCal(SiteScript ascript, string qname, decimal weight, LIST<decimal> var1, LIST<decimal> var2) {
                SiteScript.QA q = ascript.getQuestion(qname);
                if (q!=null) {
                    decimal strength = (q.answerAsNumber!=null) ? q.answerAsNumber : 0;
                    if  ( strength>=(var1[0]*weight-var2[0]))   {
                        q.textScore=String.valueOf(strength-(var1[0]*weight-var2[0]));
                        q.score=2;
                    }
                    else if ( strength>=(var1[1]*weight-var2[1]))   {
                        q.textScore=String.valueOf(strength-(var1[1]*weight-var2[1]));
                        q.score=1;
                    }
                    else {
                        q.textScore=String.valueOf(strength-(var1[1]*weight-var2[1]));
                        q.score=0;
                    }   
                }
        }
        
    private static void TextScore_NAR(SiteScript ascript,string qname,string tqname,decimal weight) {
                SiteScript.QA q = ascript.getQuestion(qname);
                if (q!=null) {
                   decimal ATPV = (q.answerAsNumber!=null) ? q.answerAsNumber : 0;
                   Decimal NAR = (ATPV.divide(weight,4,System.RoundingMode.UP)*100);
                   
                   SiteScript.QA tq = ascript.getQuestion(tqname);
                      if(NAR>4.30){
                        tq.answer=String.valueOf(NAR);
                        tq.score=2;
                      }
                      else{
                        tq.answer=String.valueOf(NAR);
                        tq.score=0;
                     }
                    
                 }
             }

    
}