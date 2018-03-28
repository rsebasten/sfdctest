/*******************************************************************************
Copyright © 2011 DuPont. All rights reserved. 
Author: Thomas Snyder,Sreedhar Jagannath
Email: thomas.snyder@usa.dupont.com, sreedhar.jagannath@ind.dupont.com
Description:  Controller for page: DPT_NomexCert
<SL20130625> : Modified the method activeCerts() to sort the active certifictations
(Qualifications) by reference Id.
********************************************************************************/
public without sharing class ctrlDPT_NomexCert {
    
    public static final string COLOR_Q_PREFIX       =   'DPP_FabricColor';
    public static final string REFERENCE_Q_NAME     =   'DPP_FabricReference';
    public static final string COLOR_Q_PREFIX_Garment = 'DPP_GarmentType'; 
    private static final string DEFAULT_PAGEWIDTH   =   '732px';  //'732px';
    public static final string INTERNAL_ONLY_PREFIX =   'INTERNAL_ONLY_';            
    public static final string EXTERNAL_RONLY_PREFIX =  'EXTERNAL_READONLY_';
    public string QualifyId;
    
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
    public String SubmittedQualId;
    public String scriptid                              {set; get;}
    public Qualification__c qualify; 
     
    
///////////////////////////////////////////////////////////////////////////////////////////////////////
// Constructors
///////////////////////////////////////////////////////////////////////////////////////////////////////
    public ctrlDPT_NomexCert() {
        init();
    }

///////////////////////////////////////////////////////////////////////////////////////////////////////
// init
///////////////////////////////////////////////////////////////////////////////////////////////////////
      public void init() {
      scriptid = ApexPages.currentPage().getParameters().get('Id');
              if (Qualification_Base.hasVisibility(scriptid)){
                      string gtyp=ApexPages.currentPage().getParameters().get('gtyp');
                         if(gtyp!=null && gtyp.tolowercase() == 'gtype'){
                              addgarmenttype();
                            }
                        else{
                          addcolor();
                        }
                      }
              else {
                      newCert();
              }
      }
///////////////////////////////////////////////////////////////////////////////////////////////////////
//  init for DPP_Certification__PDF
///////////////////////////////////////////////////////////////////////////////////////////////////////
    public PageReference initpdf() {

        selectedCertId = ApexPages.currentPage().getParameters().get('Id');
        System.debug('selectedCertId'+selectedCertId);
         
            refreshCerts();
            if (selectedCertId!=null && Qualification_Base.hasVisibility(selectedCertId)) {         
                Cert cert=getSelectedCert();
                string vw=ApexPages.currentPage().getParameters().get('vw');
                if (cert!=null) {
                System.debug('I am here');
                    if (vw!=null && vw.tolowercase()=='acert')
                        stage='activecert';
                    else
                        stage='cert';
                        System.debug('Stage is '+ stage);
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
                    return null;
                } 
            }
            printOrientation='landscape';
            stage='list';   
            script=null;                                                                                                                                                                                              
           
                
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
            Set <String> certOrderSet = new Set<String>();//SL20130625 - start of modification
            for (string id: CertOrder.values()) {
                if ( mapCerts.containsKey(id) && mapCerts.get(id).stage!=null &&
                        mapCerts.get(id).stage.tolowercase()=='active')
                    //c.add(mapCerts.get(id));
                    certOrderSet.add(id);
                }
                for (Qualification__c q : [SELECT Id from Qualification__c q where Id IN :certOrderSet ORDER BY q.Reference_Id__c])
                {
                String qId=q.Id;
                c.add(mapCerts.get(qId.Substring(0,15)));
                } //SL20130625 - end tag              
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
    
    }
///////////////////////////////////////////////////////////////////////////////////////////////////////  
    public void NewCert() {
    scriptid = ApexPages.currentPage().getParameters().get('Id');
    
        if (scriptid!=null) {
            stage='new';
            script=new SiteScript(scriptid);
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
    public PageReference Save() {
        if (script.validate()) {
            //update the score prior to writing
            DPPFabricCert_Score(script);    
            script.save();
            selectedCertId=script.WriteToId;
            QualifyId = selectedCertId;
            refreshCerts();
            showResult();
            PageReference pageRef = new PageReference('/'+selectedCertId);            
            pageRef.setRedirect(true);            
            return pageRef;
        }
        
       return null;
    }
/////////////////////////////////////////////////////////////////////////////////////////////////////// 
    public void AddColor() {
    selectedCertId = ApexPages.currentPage().getParameters().get('Id');
       System.debug('SelectedId'+selectedCertId);
       refreshCerts();
       if (selectedCertId!=null && Qualification_Base.hasVisibility(selectedCertId)) {         
                Cert cert=getSelectedCert();
         if (cert!=null){
            //paint the page to only allow edit for color values
            script=new SiteScript(cert.scriptid, cert.headerid);
                for (SiteScript.QA qa : script.questions) {
            
                    //TESII20100525 - updates the MagicAnswer for this clone
                    qa.reapplyMagicAnswer();
            
                    if (qa.developerName!=null && qa.developerName.contains(EXTERNAL_RONLY_PREFIX)) {
                        qa.readonly=true;                                
                    }                
                    else if (qa.developerName!=null && qa.developerName.contains(INTERNAL_ONLY_PREFIX)) {                                
                        qa.visible=false;
                    }
                
                    else if (qa.developerName!=null && qa.developerName.contains(COLOR_Q_PREFIX)) {
                        qa.readonly=false;
                        qa.answer='';
                    }
                    else if (qa.developerName==REFERENCE_Q_NAME) {
                        qa.readonly=false;
                    } 
                    else 
                        qa.readonly=true;
                    }       
        stage='addcolor';
    }    
  }
 }
 
/////////////////////////////////////////////////////////////////////////////////////////////////////// 
    public void AddGarmentType() {
    selectedCertId = ApexPages.currentPage().getParameters().get('Id');
       System.debug('SelectedId'+selectedCertId);
       refreshCerts();
       if (selectedCertId!=null && Qualification_Base.hasVisibility(selectedCertId)) {         
                Cert cert=getSelectedCert();
         if (cert!=null){
            //paint the page to only allow edit for color values
            script=new SiteScript(cert.scriptid, cert.headerid);
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
        stage='addtype';
    }    
  }
 }
/////////////////////////////////////////////////////////////////////////////////////////////////////// 
    public PageReference SaveColor() {
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
            
            PageReference pageRefaddcolor = new PageReference('/'+parentQual);            
            pageRefaddcolor.setRedirect(true);            
            return pageRefaddcolor;
        }
        
        return null;

    }
    
/////////////////////////////////////////////////////////////////////////////////////////////////////// 
    
    public PageReference SaveGarmentType() {
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
            
            PageReference pageRefaddtype = new PageReference('/'+parentQual);            
            pageRefaddtype.setRedirect(true);            
            return pageRefaddtype;
        }
        
        return null;

    }
/////////////////////////////////////////////////////////////////////////////////////////////////////// 
    public PageReference goHome() {
            stage='home';
            refreshCerts();
            selectedCertId=ApexPages.currentPage().getParameters().get('Id');
            script=null;
            PageReference pageRef = new PageReference('/'+selectedCertId);            
            pageRef.setRedirect(true);            
            return pageRef;
        }
       
///////////////////////////////////////////////////////////////////////////////////////////////////////     
        public PageReference goBack() {            
            stage='home';            
            refreshCerts();            
            selectedCertId=null;            
            script=null;                     
            PageReference pageRef = new PageReference('/home/home.jsp');            
            pageRef.setRedirect(true);            
            return pageRef;        
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
    
        if(PortalUser.getInstance().accountId != null){
            Qualification__c[] qs = [ 
                    SELECT Id, q.SubType__c, q.Reference_Id__c, q.CreatedDate, Colour_Comments__c, q.status__c,
                         q.Colour__c, q.Colour_Reference__c, q.Stage__c, q.Start_Date__c, q.End_Date__c, finish__c, q.Weight__c,
                          q.Qualification_Program__r.name, q.Certification_Result__c, q.Brand__r.name, q.Construction__c,
                         q.Account_Name__r.Name, Owner__r.Name,
                        ( SELECT Id, Script__c, Date_Taken__c, Score__c FROM Script_Header__r LIMIT 1),
                        ( SELECT Parent_Qualification__r.Id, Parent_Qualification__r.Reference_Id__c FROM Qualification_Relations1__r LIMIT 1)
                    FROM Qualification__c q
                    WHERE (Account_Name__c=:PortalUser.getInstance().accountId)
                    AND q.Type__c='Certification'
                    ORDER BY q.CreatedDate desc
                    ];
                    
            mapCerts = new MAP<string,Cert>();
            CertOrder = new MAP<integer,string>();
            integer order=0;
            for (Qualification__c q : qs ) {            
            String qId=q.id;                
            CertOrder.put(order++,qId.Substring(0,15));                
            mapCerts.put(qId.Substring(0,15), new Cert(q));            
            }
        
       }
       
       else if(PortalUser.getInstance().accountId == null){
          qualify = [select Account_name__c from Qualification__c where id=:selectedCertId];
            Qualification__c[] qs = [ 
                    SELECT Id, q.SubType__c, q.Reference_Id__c, q.CreatedDate, Colour_Comments__c, q.status__c,
                         q.Colour__c, q.Colour_Reference__c, q.Stage__c, q.Start_Date__c, q.End_Date__c, finish__c, q.Weight__c,
                          q.Qualification_Program__r.name, q.Certification_Result__c, q.Brand__r.name, q.Construction__c,
                         q.Account_Name__r.Name, Owner__r.Name,
                        ( SELECT Id, Script__c, Date_Taken__c, Score__c FROM Script_Header__r LIMIT 1),
                        ( SELECT Parent_Qualification__r.Id, Parent_Qualification__r.Reference_Id__c FROM Qualification_Relations1__r LIMIT 1)
                    FROM Qualification__c q
                    WHERE (Account_Name__c=:qualify.Account_name__c)
                    AND q.Type__c='Certification'
                    ORDER BY q.CreatedDate desc
                    ];
                    
            mapCerts = new MAP<string,Cert>();
            CertOrder = new MAP<integer,string>();
            integer order=0;
            for (Qualification__c q : qs ) {            
            String qId=q.id;                
            CertOrder.put(order++,qId.Substring(0,15));                
            mapCerts.put(qId.Substring(0,15), new Cert(q));            
            }
        
       }
    }

    private static void DPPFabricCert_Score(SiteScript ascript) {
            
            decimal weight = (ascript.getQuestion('DPP_FabricWeight')!=null) ? ascript.getQuestion('DPP_FabricWeight').answerAsNumber : 0;
            decimal ATPV = (ascript.getQuestion('DPP_PerformanceATPV')!=null) ? ascript.getQuestion('DPP_PerformanceATPV').answerAsNumber : 0;

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