/*******************************************************************************
Copyright © 2010 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Main class for sitescript

TES100521: writeTo only updates AllowChange fields on continuation (will not update nulls is this ok?)
TES100521: getWriteToObject() optimization
TES100525: only save continuation results that allowchange and IsDirty
TES100601: added magic parameter @header.n ( HTTP Header value ) (@header.all for all headers)
TES110106: added support for inline CSS Style on QA, Added new Ancor Object: Request__c
TES110204: fixed bug that would not change results that were emptied. (changed to null or blank)
TES110919: Added SET on QA.visible and added @user.n and @portalUser.n Magic Answers
SN20150209: added support for Project object, Added new Ancor Object: pse__Proj__c
********************************************************************************/
public virtual class SiteScript {
                    
        private MAP<string,QA>          mapQuestions            {set; get;} //<QuestionId,QA>
        private MAP<Double,Id>          mapOrder                {set; get;} //<Order,QuestionId>
        private MAP<string,Id>          mapShortName            {set; get;} //<string,QuestionId>
        private sObject                 writeToObject           {set; get;}
        public string                   scriptId                {set; get;}
        public SFDC_Script_Header__c    header                  {get; set; }    
        private SFDC_Script__c          script                  {set; get;} 
        private static boolean oddSwitch            = false;    
        
        
/*******************************************************************************
    Constructors
*******************************************************************************/
        public SiteScript(string scriptId)  {   this(scriptId,null);    }
        public SiteScript(string scriptId, string headerId) {
        
        getScriptAndHeader(scriptId,headerId);

        this.scriptId   = scriptId; 
        system.debug('FollowOnQuestions__r.size()='+script.FollowOnQuestions__r.size());
        //Map the correct order of the question
        mapOrder=new MAP<Double,Id>();
        for (SFDC_FollowOnQuestion__c foq : script.FollowOnQuestions__r) {
                mapOrder.put(foq.QuestionOrder__c,foq.Question__c);
            }
        system.debug('mapOrder.size()='+mapOrder.size());
        system.debug('mapOrder='+mapOrder); 
        // SN20150219 Added field AnswerHistory in the query of scriptResult    
        //Query Questions/Possible Answers and Results
        MAP<id,SFDC_Questions__c> mapQ = new MAP<id,SFDC_Questions__c>([
                Select Id, Name, Script__c, Question_Coach__c, Answer_Format__c, ShortName__c, WriteToField__c, IsVisible__c, 
                    IsRequired__c, datatype__c, ValidationRegEx__c, ValidationError__c, defaultAnswer__c, MaxNumber__c, MinNumber__c, 
                    //OutParameter__c, allowchange__c, SaveResult__c, IsReadOnly__c, Layout__c, LongText__c, LongHTML__c, CSSStyle__c,
                    OutParameter__c, allowchange__c, SaveResult__c, IsReadOnly__c, Layout__c, LongText__c, CSSStyle__c,
                    (   Select Id, Score__c, Order__c, Other__c, Answer__c, Answer_Coach__c
                        From Answers__r Order By Order__c
                        ),
                    (
                        Select Id, Answer__c, TextScore__c,AnswerHistory__c, Score__c 
                        From Script_Results__r
                        Where Script_Result__c =:headerId and Script_Result__c <> null
                        )
                From SFDC_Questions__c
                Where id in : mapOrder.values()
                ]);
                        
        mapQuestions = new MAP<string,QA>();
        mapShortName = new MAP<string,Id>();        
        for ( SFDC_Questions__c q : mapQ.values() ) {
            mapQuestions.put(q.id,new QA(q));   
            if (q.ShortName__c!=null) mapShortName.put(q.ShortName__c.tolowercase(), q.id);
        }
        //this will set the readonly property properly
        refreshQuestions_readonly();  
    } //end constructor

        
/*******************************************************************************
    Properties
*******************************************************************************/

//////////////////////////////////////////////////////////////////////
    public LIST<QA> visibleQuestions {
        get { 
            LIST<QA> rtn = new LIST<QA>();
            for (QA qa : this.questions )
                if (qa.visible) rtn.add(QA);
            return rtn;
        }
    }

//////////////////////////////////////////////////////////////////////
//  Returns List of questions in correct order
    public LIST<QA> questions {
        get { 
            //sort the keys
            LIST<double> sortkey = new List<double>();
            for (double d : mapOrder.keyset() ) 
            sortkey.add(d);
            sortkey.sort();
            
            LIST<QA> rtn = new LIST<QA>();
            for (double o : sortkey ) 
                rtn.add(mapQuestions.get(mapOrder.get(o)));
            return rtn;
        }
    }
//////////////////////////////////////////////////////////////////////
//  Returns QA by order number  
    public QA getQuestion(double ordinal) {
        return mapQuestions.get(mapOrder.get(ordinal));
    }
    
//////////////////////////////////////////////////////////////////////
//  Returns QA by order shortName
    public QA getQuestion(string shortName) {
        return (shortName!=null) ? mapQuestions.get(mapShortname.get(shortName.tolowercase())) : null;
    }

//////////////////////////////////////////////////////////////////////  
    public string writeToType {
        GET {
        return script.WriteToObject__c;
        }   
    }
//////////////////////////////////////////////////////////////////////  
    public string Name {
        GET {
        return script.Name;
        }   
    }   
//////////////////////////////////////////////////////////////////////  
    public boolean AllowChange {
        GET {
        return script.AllowContinuation__c;
        }   
    }   
//////////////////////////////////////////////////////////////////////  
    public double score {
        GET {
        double rtn=0;
        for (QA q : questions)
            if ( q.score!=null) rtn+=q.score;
        return rtn;     
        }   

    }
//////////////////////////////////////////////////////////////////////      
    public MAP<string,string> OutboundParameters {
            GET {
                MAP<string,string> rtn = new MAP<string,string>();
                for (QA q : questions) {
                    if ( q.outparam!=null )
                        rtn.put(q.outparam,q.answer);
                }
                system.debug('----SiteScript:OutboundParameters: '+rtn);
                return rtn;
            }
        }
        
//////////////////////////////////////////////////////////////////////      
    public string WriteToId {
        GET {
            QA qa=this.WriteToIdQuestion;
            if (qa!=null && (!Util.isBlank(qa.answer)))
                return qa.answer;
            return null;
        }
    }
//////////////////////////////////////////////////////////////////////  
    public QA WriteToIdQuestion {
        GET {
            for (QA qa : this.questions )
                if ( qa.WriteToField!=null && qa.WriteToField.toLowercase()=='id') 
                    return qa;
            return null;
        }
    }
//////////////////////////////////////////////////////////////////////
    public SET<string> WriteToFields {
        GET {
            SET<string> rtn = new SET<string>();
            sobject obj = Schema.getGlobalDescribe().get(script.WriteToObject__c).newSObject();
            Map<String, SObjectField> flds = obj.GetSObjectType().getDescribe().fields.getMap();
            for (QA q : questions) {
                    if (! Util.isBlank(q.WriteToField)) {
                        string fldname = q.WriteToField.tolowercase();
                        if (flds.containsKey(fldname)) 
                            rtn.add(String.valueof(flds.get(fldname)));  //get the case specific name
                    }
            }
        return rtn;
        }
    }
    
/*******************************************************************************
    Methods
*******************************************************************************/

//////////////////////////////////////////////////////////////////////
//  Apply the script validation
    public boolean validate() {
        boolean rtn=true;
        for (QA q : questions)
            if ( ! q.validate()) {
                system.debug('SiteScript.validationError:'+q.ValidationError+' for QuestionId: '+q.questionId);
                rtn=false;
            }
        return rtn;         
    }
    
//////////////////////////////////////////////////////////////////////
    public void WriteOutboundParameters() {
            if ( this.OutboundParameters.size()>0 ) {
                ApexPages.currentPage().getParameters().putAll(this.OutboundParameters);
            }   
        }       
//////////////////////////////////////////////////////////////////////  
    //Writes the answers to the Sobject argument
    //   checks WriteToField fieldname is a valid fieldname 
    public virtual void writeTo(sObject obj) { writeTo(obj,false); }
    public virtual void writeTo(sObject obj, boolean overwrite)  {
        LIST<QA> questions = mapQuestions.values();  //no need to sort.....was...this.questions;
        Map<String, SObjectField> flds = obj.GetSObjectType().getDescribe().fields.getMap();
        system.debug('writeTo():fields.getMap().keyset():'+Util.joint(flds.keyset(),','));
        for (QA q : questions) {
            //TES100521 if new result or question allows change
            if (header==null || q.allowChange) {

                system.debug('writeTo():question:'+q);
                //Add calculated writeTo magic variables/parameters here
                string defaultAnswer=q.objQuestion.defaultAnswer__c;
                    if (defaultAnswer!=null && defaultAnswer.startswith('@')) {
                         defaultAnswer=defaultAnswer.toLowercase();
                         if (defaultAnswer=='@totalscore')              q.answer=String.valueOf(this.score);
                         if (defaultAnswer=='@writetodate')             q.answer=String.valueOf(Date.Today());
                         if (defaultAnswer=='@writetodatetime')         q.answer=String.valueOf(DateTime.Now());
                    }
                
                if ( q.answer!=null) {
                    if (! Util.isBlank(q.WriteToField)) {
                        string fldname = q.WriteToField.tolowercase().trim();
                        system.debug('fldname:'+fldname+';containsKey:'+flds.containsKey(fldname));
                        ////////////////////////////////////////////////////////////////////////////////////////////////
                        //CASE: 03362041 : "fields.getMap() does not return standard fields in Sites". Workaround
                        // for just these fields 'id','name','recordtypeid'
                        // if (flds.containsKey(fldname)) {
                        if (flds.containsKey(fldname) || new SET<string>{'id','name','recordtypeid'}.contains(fldname) ) {
                        ////////////////////////////////////////////////////////////////////////////////////////////////
                            string a = q.answer;
                                                                        
                            if ( Util.isBlank(String.valueOf(obj.get(fldname))) || overwrite==true ) {
                                
                                //CASE: 03362041 
                                if (! flds.containskey(fldname) ) 
                                    obj.put(fldname,a);  // put 'id','name','recordtypeid' values verbitim
                                else
                                    Util.SobjectPutString(obj,flds.get(fldname),a);
                                    
                            }
                        }
                    }   
                }
            }
        } //next q  
        
    }
    
    
//////////////////////////////////////////////////////////////////////
    public void setReadOnly(boolean b) {
        for (QA qa : mapQuestions.values())
            qa.readonly=b;
        }
//////////////////////////////////////////////////////////////////////  
    public virtual void refreshQuestions_readonly() {
            /////////////////////////////////////////////////////                       
            // Need to do this on save and after fullyloading the questions 
            //(Readable Only When new or the script and qa allow change )                       
                for (QA qa : mapQuestions.values()) {
                    qa.readonly=(!( (!qa.objQuestion.IsReadonly__c) && ((this.AllowChange && qa.AllowChange) || (qa.resultId==null && this.header==null)) ));
                }
    }
//////////////////////////////////////////////////////////////////////      
    public virtual sobject getWriteToObject() {
        if (this.writeToType!=null) {
            if (writeToObject==null) {
                //dynamically create sobject
                if (this.WriteToId != null) {
                    try {
                        writeToObject = database.query('SELECT ' + Util.joint(this.WriteToFields,',')+' from '+script.WriteToObject__c+' WHERE id=\''+this.WriteToId+'\'');
                        //Fails when adding new fields System.SObjectException: SObject row was retrieved via SOQL without querying the requested field: Account.Total_Account_Score__c
                        //writeToObject = database.query('SELECT ID from '+script.WriteToObject__c+' WHERE id=\''+this.WriteToId+'\'');
                    }
                    catch(Exception ex) {
                        throw new SiteScriptException('Cannot read the WriteToObject (ID:'+this.WriteToId+'). This record does not exists or you no longer have access.');
                    }
                }
                else 
                    writeToObject = Schema.getGlobalDescribe().get(script.WriteToObject__c).newSObject();       
                    }
        }
        return writeToObject;
    }   
//////////////////////////////////////////////////////////////////////          
    public virtual void clearWriteToObject() {
        writeToObject=null;
    }               
//////////////////////////////////////////////////////////////////////
        public virtual void save() {
            
            //TODO: should i make this an atomic transation???
            try{
            //////////////////////////////////////////////////////
            //1.  WriteTo Object
            //////////////////////////////////////////////////////  
                getWriteToObject();
                    writeTo(writeToObject,true);
                    upsert writeToObject;

                    //add the writeToObject.Id back to the questions this is need to allows
                    // for script continuation on a newly created writeToObject
                    if (this.WriteToIdQuestion !=null)
                        this.WriteToIdQuestion.answer=writeToObject.id;
                                
                }

                catch(System.NullPointerException ex) {
                    //this typically happens when the writeToObject does not exist or was removed
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The system can not writeTo object of Type : '+ script.WriteToObject__c));
                }
            
            
            //////////////////////////////////////////////////////
            //2.  Save Header
            //////////////////////////////////////////////////////
            SaveScriptAndHeader();
            
        }


    public virtual SFDC_Script_Header__c getNewHeader(boolean includeAncors) { return getNewHeader(includeAncors,true); }
    public virtual SFDC_Script_Header__c getNewHeader(boolean includeAncors, boolean clearResultIds  ) {
        
        if (clearResultIds) clearResultIds();   //if you are creating a new header,  you will want to clear existing 
                                                //results Ids (if populated) beacuse they will still be tied to the orig header
        SFDC_Script_Header__c h = new SFDC_Script_Header__c(
                    Script__c=this.scriptid,
                    Score__c=this.Score
                    );
        
        if (!includeAncors ) return h;
        
        string qualPrefix = Qualification__c.sObjectType.getDescribe().getKeyPrefix();
        string requestPrefix = Request__c.sObjectType.getDescribe().getKeyPrefix();
        //SN20150209 added varible ProjPrefix to get the prefix header of the object
        string projPrefix = '';//pse__Proj__c.sObjectType.getDescribe().getKeyPrefix();
        
        MAP<string,string> params = ApexPages.currentPage().getParameters();
        //Attach header to Available_With__c object(s) via URL parameter(s)
        if ( script.Available_With__c.contains('Accounts')          && params.containskey('acc')        && params.get('acc').startswith('001'))                 h.Account__c=params.get('acc');
        if ( script.Available_With__c.contains('Contacts')          && params.containskey('contact')    && params.get('contact').startswith('003'))             h.Contact__c=params.get('contact');
        if ( script.Available_With__c.contains('Leads')             && params.containskey('lead')       && params.get('lead').startswith('00Q'))                h.Account__c=params.get('lead');
        if ( script.Available_With__c.contains('Opportunities')     && params.containskey('oop')        && params.get('oop').startswith('006'))                 h.Opportunity__c=params.get('oop');
        if ( script.Available_With__c.contains('Cases')             && params.containskey('case')       && params.get('case').startswith('500'))                h.Case__c=params.get('case');
        if ( script.Available_With__c.contains('Qualification__cs') && params.containskey('qual')       && params.get('qual').startswith(qualPrefix))           h.Qualification__c=params.get('qual');
        //if ( script.Available_With__c.contains('Request__cs')       && params.containskey('request')    && params.get('request').startswith(requestPrefix))     h.Request__c=params.get('request');
        if ( script.Available_With__c.contains('Entitlements')     && params.containskey('RegistrationID')        && params.get('RegistrationID').startswith('550'))  h.Entitlement__c=params.get('RegistrationID');
        //if ( script.Available_With__c.contains('Project')       && params.containskey('ProjectID')    && params.get('ProjectID').startswith(projPrefix ))          h.Project__c=params.get('ProjectID');
        //If no Ancor id(s) provided see if a corrisponding writeToObject exists
        if ( (!HasAncor(h)) && WriteToObject!=null && WriteToObject.id!=null ) {
            if      ( script.WriteToObject__c.toLowerCase()=='account'          && script.Available_With__c.contains('Accounts'))                   h.Account__c=WriteToObject.id;
            else if ( script.WriteToObject__c.toLowerCase()=='contact'          && script.Available_With__c.contains('Contacts'))                   h.Contact__c=WriteToObject.id;
            else if ( script.WriteToObject__c.toLowerCase()=='lead'             && script.Available_With__c.contains('Leads'))                      h.Lead__c=WriteToObject.id;
            else if ( script.WriteToObject__c.toLowerCase()=='opportunity'      && script.Available_With__c.contains('Opportunities'))              h.Opportunity__c=WriteToObject.id;
            else if ( script.WriteToObject__c.toLowerCase()=='case'             && script.Available_With__c.contains('Cases'))                      h.Case__c=WriteToObject.id;
            else if ( script.WriteToObject__c.toLowerCase()=='qualification__c' && script.Available_With__c.contains('Qualification__cs'))          h.Qualification__c=WriteToObject.id;
            //else if ( script.WriteToObject__c.toLowerCase()=='request__c'       && script.Available_With__c.contains('Request__cs'))                h.Request__c=WriteToObject.id;
            else if ( script.WriteToObject__c.toLowerCase()=='entitlement'      && script.Available_With__c.contains('Entitlements'))               h.Entitlement__c=WriteToObject.id;
            //else if ( script.WriteToObject__c.toLowerCase()=='pse__Proj__c'      && script.Available_With__c.contains('Project'))                   h.Project__c=WriteToObject.id; 
        }
        return h;
    }
//////////////////////////////////////////////////////////////////////      
    public virtual void SaveScriptAndHeader() { 
            //////////////////////////////////////////////////////
            // Save Header
            //////////////////////////////////////////////////////
            if (this.header!=null && this.header.id != null) {
                ////////////////////////////////////////////
                //header already exists just update score, and dirty allowChange results
                this.header.Score__c=this.Score;
                update this.header;
                saveResultsToHeader(this.header.id,true);
            }
            else {
                ////////////////////////
                //create a new header
                if(script.Available_With__c !=null) {
                    SFDC_Script_Header__c h = getNewHeader(true);
                    insert h;
                    //TODO:try/catch
                    this.header=h; 
                    saveResultsToHeader(this.header.id,false);
                }
            }
    }
//////////////////////////////////////////////////////////////////////////////////////////          
        //TODO: Drive from two fields on script returnToType(picklist:ReturnUrl,WriteToObject,AncorObject,Header) and returnToValue (freetext)
        public virtual PageReference returnPageReference() {
            PageReference p = null;
            
            try {
                if (script.ReturnToType__c.toLowerCase()=='returnurl') p = new PageReference(script.ReturnToValue__c);
                else if (script.ReturnToType__c.toLowerCase()=='available_with object' && header!=null) { 
                     if         ( script.ReturnToValue__c.tolowercase()=='account'          && header.Account__c!=null)         p = new PageReference('/'+header.Account__c);
                     else if    ( script.ReturnToValue__c.tolowercase()=='contact'          && header.Contact__c!=null)         p = new PageReference('/'+header.Contact__c);
                     else if    ( script.ReturnToValue__c.tolowercase()=='lead'             && header.Lead__c!=null)            p = new PageReference('/'+header.Lead__c);
                     else if    ( script.ReturnToValue__c.tolowercase()=='case'             && header.Contact__c!=null)         p = new PageReference('/'+header.Case__c);
                     else if    ( script.ReturnToValue__c.tolowercase()=='opportunity'      && header.opportunity__c!=null)     p = new PageReference('/'+header.opportunity__c);
                     else if    ( script.ReturnToValue__c.tolowercase()=='qualification__c' && header.Qualification__c!=null)   p = new PageReference('/'+header.Qualification__c);
                     //else if    ( script.ReturnToValue__c.tolowercase()=='request__c'       && header.Request__c!=null)         p = new PageReference('/'+header.Request__c);
                     else if    ( script.ReturnToValue__c.tolowercase()=='entitlement'      && header.Lead__c!=null)            p = new PageReference('/'+header.Entitlement__c);
                     //else if    ( script.ReturnToValue__c.tolowercase()=='pse__Proj__c'     && header.Project__c!=null)         p = new PageReference('/'+header.Project__c);
                }
                else if (script.ReturnToType__c.toLowerCase()=='writeto object')    p = new PageReference('/'+this.WriteToId);
                else if (script.ReturnToType__c.toLowerCase()=='script header')     p = new PageReference('/'+this.header.id);
                p.getParameters().putAll(this.OutboundParameters);
                p.setRedirect(true);
            }
            catch (Exception ex) {}
            return p;
        }
        
//////////////////////////////////////////////////////////////////////////////////////////              
        //Used for cloning a set of results to another header
        public virtual void clearResultIds() {
                for (QA q : questions ) 
                    q.resultId=null;
        }
        
        
//////////////////////////////////////////////////////////////////////////////////////////      
        public virtual void saveResultsToHeader(string headerid) {  saveResultsToHeader(headerid,false); }
        public virtual void saveResultsToHeader(string headerid, boolean onlyAllowChange) {

            if ( headerid!=null ) {         
                LIST<SFDC_Script_Result__c> scriptresults = new LIST<SFDC_Script_Result__c>();
                system.debug('saveResultsToHeader() headerid: '+headerid+' onlyAllowChange:'+onlyAllowChange);
                for (QA q : questions) {
                    system.debug('saveResultsToHeader() answer: '+q.answer+' originalAnswer: '+q.originalAnswer);
                    system.debug('saveResultsToHeader() question: '+q);
                    system.debug('saveResultsToHeader() isDirty: '+q.isDirty);
                    system.debug('saveResultsToHeader() allowChange: '+q.allowChange);
                    //TESII20100525 - only save allowchange and IsDirty
                    if ( (!onlyAllowChange) || ( q.isDirty && q.allowChange )) {
                        //skip the '@'s
                        //TESII20110204 would not change results that were emptied. (changed to null or blank)
                        //WAS: if (q.saveResult && (!Util.isBlank(q.answer)) && (!q.answer.startswith('@')) ) {
                        //SN20150209 Added a field AnswerHistory__c in the mapping of Script Result
                        if (  q.saveResult && ((!Util.isBlank(q.answer)) || q.isDirty) 
                                && ( (q.answer!=null) && (!q.answer.startswith('@')))  ) {
                            system.debug('saveResultsToHeader() question Added');
                            Id answerId = (q.objAnswers.containsKey(q.answer))? q.objAnswers.get(q.answer).id : null;
                            scriptresults.add(new SFDC_Script_Result__c(
                                id=q.resultId,
                                Script_Result__c=headerid, 
                                Score__c=q.score, 
                                QuestionId__c=q.questionId,
                                AnswerId__c=answerId,
                                Question__c=q.questionName,
                                Answer__c=q.answer,
                                TextScore__c=q.textScore,
                                AnswerHistory__c=q.AnswerHistory
                                ));
                        }
                    }
                }
                system.debug('scriptresults:'+scriptresults);
                upsert scriptresults;
                
                /////////////////////////////////////////////////////
                //set resultid for the new inserts
                // AND set the readonly flag where applicable
                for (SFDC_Script_Result__c sr : scriptresults ) {
                    if (sr.id!=null && sr.QuestionId__c != null &&
                        mapQuestions.containsKey(sr.QuestionId__c ))
                            mapQuestions.get(sr.QuestionId__c).resultId=sr.id;
                }
                        
                /////////////////////////////////////////////////////                       
                // NOW that we updated the results refresh the readonly flags                       
                refreshQuestions_readonly();

        }
            else
                throw new SiteScriptException('SiteScript.header cannot be null on save.');
    }
        


/*******************************************************************************
    Inner Classes
*******************************************************************************/

        public class QA {
    
            public string               questionId      {set; get;}
            public string               resultId        {set; get;}
            public string               question        {set; get;}
            public boolean              required        {set; get;}
            public string               answer          {set; get;}
            public string               answerType      {set; get;}
            public string               dataType        {set; get;}
            public string               ValidationError {set; get;}
            public string               textScore       {set; get;} 
            public string               AnswerHistory   {set; get;}
            public string               CSSstyle        {set; get;} 

            public string               helpText        {set; get;} 
            public string               outparam        {set; get;}     
            public boolean              readonly        {set; get;}         
            public boolean              saveResult      {set; get;} 

            protected SFDC_Questions__c                 objQuestion;
            protected MAP<string,SFDC_Answer__c>        objAnswers; 
            private double                              newscore;       
            
            /////////////////////////   
            //constructor
            ////////////////////////
            public QA(SFDC_Questions__c q) {
                this.objQuestion            = q;
                this.questionId             = q.Id;
                this.question               = Util.isBlank(q.LongText__c) ? q.name : q.LongText__c;
                this.helpText               = q.Question_Coach__c;
                this.required               = q.IsRequired__c;
                this.dataType               = ( q.dataType__c!=null ) ? q.dataType__c.tolowercase() : 'text';
                this.answer                 = q.defaultAnswer__c;
                this.outparam               = q.outParameter__c;
                this.saveResult             = q.saveResult__c;
                this.CSSstyle               = q.CSSStyle__c;
                
                //Add writeTo magic variables/parameters here
                if (q.defaultAnswer__c!=null && q.defaultAnswer__c.startswith('@'))
                    this.answer=ResolveMagicAnswer(q.defaultAnswer__c);
                /************************************************************
                TODO: If WriteToId Field takes a @Param be sure it is an encrypted
                ************************************************************/
                
                
                if (this.dataType.startswith('section')) {
                    this.answerType='SECTION';
                    this.saveResult=false;
                    return;
                }

                if ( q.Answers__r.size()==0 || 
                     (q.Answers__r.size()==1 && q.Answers__r[0].Other__c )
                    ) {
                    if (this.dataType=='date')
                        this.answerType='DATE';
                    else if (this.dataType=='textarea')
                        this.answerType='TEXTAREA';
                    else if (this.dataType=='checkbox')
                        this.answerType='CHECKBOX';
                    else
                        this.answerType='TEXT';
                }
                else if (this.dataType=='radiolist')
                    this.answerType='RADIO';
                else if (this.dataType=='picklist')
                    this.answerType='SELECT';
                else if (this.dataType=='multiselect picklist')
                    this.answerType='MULTISELECT';
                else if (this.dataType=='multiselect checkboxes')
                    this.answerType='MULTICHECK';
                
                //MAP Answers by value
                objAnswers = new MAP<string,SFDC_Answer__c>();
                for (SFDC_Answer__c a : objQuestion.Answers__r)
                    objAnswers.put(a.answer__c, a);     
                
                //Prepopulate Results if avail
                if (q.Script_Results__r!=null && q.Script_Results__r.size()>0) {
                    if (q.Script_Results__r[0].id           !=  null)   this.resultId   = q.Script_Results__r[0].Id;
                    if (q.Script_Results__r[0].Answer__c    !=  null)   this.answer     = q.Script_Results__r[0].Answer__c; 
                    //if (q.Script_Results__r[0].Score__c       !=  null)   this.Score__c   = q.Script_Results__r[0].Score__c;  
                    if (q.Script_Results__r[0].TextScore__c !=  null)   this.textScore  = q.Script_Results__r[0].TextScore__c;
                    if (q.Script_Results__r[0].AnswerHistory__c!=  null)   this.AnswerHistory  = q.Script_Results__r[0].AnswerHistory__c;
                }
                
                if ( ( this.AllowChange || this.resultId==null ) && (!objQuestion.isReadOnly__c) )
                    this.readonly=false;
                else
                    this.readonly=true;
            }
                        
            public string richText { 
                GET { 
                //return objQuestion.LongHTML__c; 
                return'';
                }
            }
    
            public string questionName { 
                GET { return objQuestion.name; }
            }       
            ////////////////////////////////////////////////
            public boolean isOdd {
                    GET {
                        oddSwitch=(!oddSwitch);
                        return oddswitch;
                    }
                }
            ///////////////////////////////////////////////
            public boolean isDirty {
                    GET {
                        try {
                        if (Util.isBlank(this.originalAnswer))
                            return (!Util.isBlank(this.answer));
                        else
                            return (this.originalAnswer!=this.answer);
                        }catch(exception ex) {}
                        return false;
                    }
            }
            ///////////////////////////////////////////////
            public string originalAnswer{
                    GET {
                        if (objQuestion.Script_Results__r!=null && objQuestion.Script_Results__r.size()>0)
                            return objQuestion.Script_Results__r[0].Answer__c;
                        return null;
                    }
            }
            ///////////////////////////////////////////////
            public void reapplyMagicAnswer() {
                //applied on construct,  this is useful if you need to reapply
                if (objQuestion.defaultAnswer__c!=null && objQuestion.defaultAnswer__c.startswith('@'))
                    this.answer=ResolveMagicAnswer(objQuestion.defaultAnswer__c);
            }
            //////////////////////////////////////////////
            public List<SelectOption> AnswerPicklist {
                
                GET {
                    //TODO: Check order, may need to apply order....
                    List<SelectOption> rtn=new List<SelectOption>();
                    if ( answerType=='SELECT' )  // Only add none to answerType=='SELECT'
                        rtn.add(new SelectOption('', '-- None --'));
                    for (SFDC_Answer__c a : objQuestion.Answers__r) {
                        if (Util.isBlank(a.Answer_Coach__c))
                            rtn.add(new SelectOption(a.answer__c, a.answer__c));
                        else
                            rtn.add(new SelectOption(a.answer__c, a.Answer_Coach__c));  
                    }
                    return rtn;
                }
            }
            
            public string componentLayout {
                GET { return this.objQuestion.Layout__c; }
            }
            //returns answerlabel (answer coach) if avail, otherwise returns answer
            //for picklist/muti-selects
            public string answerLabel {
                GET {
                    string rtn=this.answer;
                    try { 
                        SFDC_Answer__c ar = objAnswers.get(this.answer);
                        if (! Util.isBlank(ar.Answer_Coach__c))
                            return ar.Answer_Coach__c;
                    }
                    catch(exception ex) {}
                    return rtn; 
                }
            }
            
            public LIST<string> multiAnswer {
                GET { return (answer!=null) ? answer.split(';') : new LIST<string>(); }
                SET { answer=Util.joint(value, ';'); }
            }
            
            public boolean validate() {
                this.ValidationError=null;
                
                //LEVEL 1 VALIDATION REQUIRED
                if (this.required && Util.isBlank(answer) ) {
                    this.ValidationError='Validation Error: Value is required.';
                    return false;
                }
                
                
                //LEVEL 2 VALIDATION BY DATATYPE
                if ( (! Util.isBlank(answer)) && this.dataType!=null && (this.visible) 
                    && answer.tolowercase()!='@totalscore') {
                    
                    //string dtype = this.dataType.toLowercase();
                    
                    //2a TEXT/TEXTAREA VALIDATION
                    if (dataType=='text' || dataType=='textarea') {
                        if (objQuestion.MaxNumber__c!=null && objQuestion.MaxNumber__c>0 && (answer.length()>objQuestion.MaxNumber__c)) {
                            this.ValidationError='Validation Error: Text value too long. (Max chars:'+String.valueOf(objQuestion.MaxNumber__c.intValue())+')';
                            return false;
                        }
                    }
                    
                    //2b NUMBER VALIDATION
                    if (dataType=='decimal' || dataType=='integer') {
                        decimal num = Util.stringToDecimal(answer); 
                        if (num==null) {
                            this.ValidationError='Validation Error: Must be a valid ' + dataType + '.';
                            return false;
                        }
                        else {
                            if (objQuestion.MaxNumber__c!=null && num>objQuestion.MaxNumber__c) {
                                string maxnum = (dataType=='integer') ? String.valueOf(objQuestion.MaxNumber__c.intValue()) : String.valueOf(objQuestion.MaxNumber__c);
                                this.ValidationError='Validation Error: Exceeds the maximum number allowed. ('+maxnum+')'; 
                                return false;
                            }
                            if (objQuestion.MinNumber__c!=null && num<objQuestion.MinNumber__c) {
                                string minnum = (dataType=='integer') ? String.valueOf(objQuestion.MinNumber__c.intValue()) : String.valueOf(objQuestion.MinNumber__c);
                                this.ValidationError='Validation Error: Does not meet the minimum number allowed. ('+minnum+')'; 
                                return false;
                            }
                            //Round answer to Integer text if dtype = integer.
                            if (dataType=='integer')
                                answer=String.ValueOf(Util.StringToInteger(answer));
                        }
                    }
                    
                        
                    //2c RegEx validation           
                    if (objQuestion.ValidationRegEx__c!=null) {
                        if ( ! Pattern.matches(objQuestion.ValidationRegEx__c, this.answer) )
                            this.ValidationError='Validation Error: '+objQuestion.ValidationError__c;
                    }
                    
                    this.ValidationError=(this.ValidationError!=null && objQuestion.ValidationError__c!=null) ? objQuestion.ValidationError__c : null;  
                }

                return (this.ValidationError==null);
            }
            
                        
            public string WriteToField {
                GET {
                    return objQuestion.WriteToField__c;
                }
            }

            public integer mutiSelectSize {
                GET {
                    if ( objQuestion.MaxNumber__c!=null && objQuestion.MaxNumber__c>0 )
                        return objQuestion.MaxNumber__c.intValue();
                    else 
                        return objAnswers.size();
                }
            }
            
            public boolean visible {
                GET {
                    return objQuestion.IsVisible__c;
                }
                //TES110919
                SET {
                    objQuestion.IsVisible__c=value;
                }
            }
            
            public double score {
                GET {
                    if ( newscore==null && objAnswers!=null && objAnswers.containskey(this.answer) )
                        this.newscore = objAnswers.get(this.answer).score__c;
                    return newscore;
                }
                SET {
                    this.newscore = value;
                }
            }

            public Decimal answerAsNumber {
                GET {
                    return Util.stringToDecimal(answer);
                }
            }
                    
            public ID answerId {
                GET {
                    if ( objAnswers.containskey(this.answer) )
                        return objAnswers.get(this.answer).id;
                    else
                        return null;
                }
            }
            
            //developername (shortname)
            public string developerName {
                GET { return objQuestion.ShortName__c;   }
            }
            
            public boolean allowChange {
                GET { return objQuestion.AllowChange__c;   }
            }

        } //end class question
            
/*******************************************************************************
    Exceptions 
*******************************************************************************/    

    public class SiteScriptException extends Exception {}

/*******************************************************************************
    Helper Functions 
*******************************************************************************/
    
//////////////////////////////////////////////////////////////////////////////////////////      
    
    private boolean hasAncor(SFDC_Script_Header__c h) {
        return (!( h.Account__c==null && h.contact__c==null && h.lead__c==null && 
            //h.Opportunity__c==null && h.Qualification__c==null && h.case__c==null && h.Request__c==null && h.Entitlement__c==null ));
            h.Opportunity__c==null && h.Qualification__c==null && h.case__c==null && h.Entitlement__c==null ));
    }
//////////////////////////////////////////////////////////////////////////////////////////      


    private static string resolveMagicAnswer(string mAnswer) {
        string rtn;
        if (mAnswer==null) return null;
            
        mAnswer=mAnswer.toLowercase();
        if ( mAnswer.startswith('@param.') )
            rtn=ApexPages.currentPage().getParameters().get(mAnswer.substring(7));
        else if ( mAnswer.startswith('@header.all') ) {
            for (string h : System.currentPageReference().getHeaders().keySet())
                rtn+=h+':'+System.currentPageReference().getHeaders().get(h)+'\n';
        }   
        else if ( mAnswer.startswith('@header.') )
            rtn=ApexPages.currentPage().getParameters().get(mAnswer.substring(7));                  
        else if ( mAnswer.startswith('@memberportal.') ) {
            PageBase pb = PageBase.getInstance();
            if (pb.memberInfo!=null) {
                MemberPortal.Profile mprofile = pb.memberInfo.Profile;
                if (mprofile!=null) {
                    if ( mAnswer=='@memberportal.key')          rtn=pb.memberKey;
                    if ( mAnswer=='@memberportal.contactid')    rtn=mprofile.contactid;
                    if ( mAnswer=='@memberportal.accountid')    rtn=mprofile.accountid;
                    if ( mAnswer=='@memberportal.campaignid')   rtn=pb.memberInfo.campaignid;
                    if ( mAnswer=='@memberportal.memberid')     rtn=pb.memberInfo.memberid;
                    if ( mAnswer=='@memberportal.memberstatus') rtn=pb.memberInfo.memberstatus;
                    if ( mAnswer=='@memberportal.accountname')  rtn=mprofile.accountname;
                    if ( mAnswer=='@memberportal.firstname')    rtn=mprofile.firstname;
                    if ( mAnswer=='@memberportal.lastname')     rtn=mprofile.lastname;
                    if ( mAnswer=='@memberportal.email')        rtn=mprofile.email;
                    if ( mAnswer=='@memberportal.country')      rtn=mprofile.country;
                }
            }
        }
        else if ( mAnswer.startswith('@portaluser.') ) {
            PortalUser puser = PortalUser.getInstance();
            if (puser!=null) {
                if ( mAnswer=='@portaluser.contactid')      rtn=puser.contactid;
                if ( mAnswer=='@portaluser.accountid')      rtn=puser.accountid;
                if ( mAnswer=='@portaluser.accountname')    rtn=puser.accountname;
                if ( mAnswer=='@portaluser.firstname')      rtn=puser.firstname;
                if ( mAnswer=='@portaluser.lastname')       rtn=puser.lastname;
                if ( mAnswer=='@portaluser.email')          rtn=puser.email;
                if ( mAnswer=='@portaluser.country')        rtn=puser.country;
            }
        }
        else if ( mAnswer.startswith('@user.') ) {
                if ( mAnswer=='@user.firstname')        rtn=userInfo.getfirstname();
                if ( mAnswer=='@user.lastname')         rtn=userInfo.getlastname();
                try {
                    User u = [Select email, User_Country__c From User where id=:UserInfo.getUserId()];
                    if ( mAnswer=='@user.email')            rtn=u.email;
                    if ( mAnswer=='@user.country')          rtn=u.User_Country__c;
                }
                catch(Exception ex){}
        }
        else if (mAnswer=='@today')     rtn=String.valueOf(Date.Today());
        else if (mAnswer=='@now')       rtn=String.valueOf(DateTime.Now());
        system.debug('ResolveMagicAnswer:'+mAnswer+'='+rtn);        
                
        return rtn;
    }



//////////////////////////////////////////////////////////////////////////////////////////      
    private void getScriptAndHeader(string scriptId, string headerId) {
        try {
            
            if ( headerId!=null) {
                this.header = [ Select Id, script__c, account__r.name, contact__r.account.name from SFDC_Script_Header__c where id=: headerId ];
                if (scriptId==null) scriptId=this.header.script__c;
            }
            
            script = [Select Name, ReturnToValue__c, ReturnToType__c, Available_With__c, WriteToObject__c,
                            AllowContinuation__c,
                                (   Select Question__c, QuestionOrder__c
                                    FROM FollowOnQuestions__r
                                )
                    FROM SFDC_Script__c 
                    WHERE id=:scriptId ];
        }
        catch(exception ex) {
                throw new SiteScriptException('invalid scriptid or headerid.  '+ ex );
        }
        
        //if (this.header!=null && (!script.AllowContinuation__c))
        //      throw new SiteScriptException('This script does not allow for Continuation.');
    }
    

    
}