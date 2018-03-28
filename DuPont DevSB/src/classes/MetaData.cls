/*******************************************************************************
Copyright © 2011 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Primary class for updating the metadata__c 

    system.schedule('MetadataLogic 3AM', '0 0 3 * * ?', new sched_RefreshMetaDataLogic());
    system.schedule('Metadata-DB 12AM', '0 0 0 * * ?', new sched_RefreshMetaData());

TES20110805  getMetadataLayoutsViaAPI() bug cannot specify '*' with Layout
TES20111103  enhanced describe layout
TES20111121 Using FileProperties to update fields now that 'CustomField' is filterable via MetadataAPI.metadatalist
TES20120614 Delete support for classes/trigger/pages and components
TES20120911 Add support for more metadata types (General) using listMetdata FileProperties
TES20130409 refinded the delete/soft deleteprocess to use scheduling/batch
TES20131022 exclude contact fields on account (personAccount) to avoid picklist limits
RS20160129  Rohit saini 12/29/2016 Fixed System.LimitException: Too many DML statements: 151.Moved DML outside loop at line 379. Issue issue IS ID-00064089.  
KS20170817 Sairam Kumar 08/17/2017 Removed EntitlementTemplate at line #33 from GENERAL_MTYPES variables.
KS20170817 Sairam Kumar 08/17/2017 Removed Portal at line #34 from GENERAL_MTYPES variables.
SA20170915  Created custom setting MetaDataSettings__c for all metadata components.
********************************************************************************
*/
global virtual class MetaData {

    //create workflow on create to do this...OWNING_QUEUE='00G30000001FGtl'; //datamodel
    public static final string RTYPE_SOBJECT                    = Rtype.getIdByName('Metadata__c','SObject');
    public static final string RTYPE_FIELD                      = Rtype.getIdByName('Metadata__c','Field'); 
    public static final string RTYPE_PICKLIST                   = Rtype.getIdByName('Metadata__c','Picklist');
    public static final string RTYPE_LAYOUT                     = Rtype.getIdByName('Metadata__c','Layout');    
    public static final string RTYPE_LOGIC                      = Rtype.getIdByName('Metadata__c','Logic'); 
    public static final string RTYPE_GENERAL                    = Rtype.getIdByName('Metadata__c','GeneralAsset');  

    public static final string DELETE_PREFIX = 'zzz__';
    
    // MetaDataSettings__c is custom setting for all metadata components.<AN20170912>
    
    //Start <SA20170915>
    
    public static SET<string> GENERAL_MTYPES = new Set<String>();
    Static {
        for(String s : MetaDataSettings__c.getAll().keySet())
        {
            GENERAL_MTYPES.add(s);
        }
        
           }

   /* public static final SET<string> GENERAL_MTYPES = new SET<string> { 'AnalyticSnapshot','CustomPageWebLink','CustomSite','CustomTab',
    'DashboardFolder', 'DataCategoryGroup','DocumentFolder','EmailFolder','Flow','Group',
    'HomePageComponent','HomePageLayout','Letterhead','PermissionSet','Profile','Queue','RemoteSiteSetting',
    'ReportFolder','ReportType','Role','Scontrol','StaticResource','Territory','Translations'} ;
    */
     //End <SA20170915>
     
     
    public static final SET<string> GENERAL_SOBJECT_MTYPES = new SET<string> { 'BusinessProcess','FieldSet','ListView','NamedFilter'
    ,'SharingReason','ValidationRule','WebLink'
    ,'WorkflowRule','WorkflowAlert','WorkflowFieldUpdate','WorkflowOutboundMessage','WorkflowTask'
    };
        
        
    public static final SET<string> EXCLUDEFIELDS = new SET<string>{}; //'createdbyid', 'createddate'};
    

    
    
/////////////////////////////////////////////////////////////////////////////////////////////////////////   

        
    //////////////////////////////////////////////////////
    // Update the API name changes where FieldId is populated
    // and Update the fieldId if null and Is Custom
    //////////////////////////////////////////////////////
    public static DmlResults refreshSObjectForceIds() { return refreshSObjectForceIds(null); }
    public static DmlResults refreshSObjectForceIds(string sess) {
        DmlResults unsuccessfuls = new DmlResults();    
        LIST<Metadata__c> MetadataToUpdate = new LIST<Metadata__c>();
        
        try {
            if (sess!=null) API.SESSION=sess;
            MAP<string,API.FileProperties> fprops = API.ListMetadataMap('', 'CustomObject'); //MAP<forceId,fullName>
            MAP<string,string> forceIdTofnameMap = new MAP<string,string>(); //will only map the custom fields as std fields do not have ids
            for (API.FileProperties fp : fprops.values()) {
                if (!Util.isBlank(fp.id)) //Ids are not supplied for std objects
                    forceIdTofnameMap.put(fp.id,fp.fullname);
            }   
        
            ////////////////////////////////////////////////
            // START- Repair APIName change (only applies to custom)
            // 
            ///////////////////////////////////////////////
            LIST<string> APINameChange = new LIST<string>();
                for ( Metadata__c md : [    Select Id, fullName__c, forceId__c, isCustom__c from Metadata__c 
                                            where forceId__c in :forceIdTofnameMap.keySet()] ) {
                    string fullname = forceIdTofnameMap.get(md.forceId__c);
                    if (md.fullName__c!=fullName && md.forceId__c!=null) {
                        API.FileProperties fprop=fprops.get(fullname); //get props based on new fullname
                        copyFilePropertiesToMetadata(fprop,md); 
                        MetadataToUpdate.add(md);
                        APINameChange.add(fullname);
                    }
                }

            //delete sobject where fullname is a APINameChange 
            //that already exists and forceId is null (newly added)
            //Note:  If these records are not deleted then the update to change to the new fullname
            //will not be allowed due to unique constraint on fullname__c
            if (APINameChange.size()>0) {
                LIST<Metadata__c> MetadataToDelete = new LIST<Metadata__c>();
                MetadataToDelete = [Select Id from Metadata__c 
                        where ( forceId__c=null OR forceId__c='') 
                        AND fullName__c in :APINameChange
                        AND type__c='SOBJECT'];
                if  (MetadataToDelete.size()>0) 
                    unsuccessfuls.add(new DmlResults(database.delete(metadataToDelete,false), metadataToDelete));       
            }       
                    
            unsuccessfuls.add(new DmlResults(database.update(metadataToUpdate,false), metadataToUpdate));
            metadataToUpdate.clear();
            ////////////////////////////////////////////////
            // End - Repair APIName change
            ///////////////////////////////////////////////
            

            //Update FileProp info
            for ( Metadata__c md : [    Select Id, fullName__c, forceId__c, namespace__c, isCustom__c,
                             CreatedBy__c, CreatedDT__c, LastModifiedBy__c, lastModifiedDT__c
                            from Metadata__c 
                                        where type__c='SOBJECT'] ) {
                API.FileProperties fprop=fprops.get(md.fullName__c);
                if (fprop!=null) {
                  ///  system.debug(fprop);
                    copyFilePropertiesToMetadata(fprop,md);                     
                    MetadataToUpdate.add(md);
                }
                else {
                    //check if SObject has been deleted and set to IsDeleted
                    //only apply this to custom objects since the std objects are not in the forceIdTofnameMap
                    if (md.forceId__c!=null && forceIdTofnameMap.size()>0 && (!forceIdTofnameMap.containsKey(md.forceId__c)) && md.isCustom__c) {
                        setMetadataToIsDeleted(md);
                        MetadataToUpdate.add(md);
                    }
                }   
            }           

        }
        catch(Exception ex) {system.debug(ex);} 
        
                    
        //Update
        if (MetadataToUpdate.size()>0) 
            unsuccessfuls.add(new DmlResults(database.update(metadataToUpdate,false),metadataToUpdate));

        return unsuccessfuls;   


    }
    
/////////////////////////////////////////////////////////////////////////////////////////////////////////   

        
    //////////////////////////////////////////////////////
    // Update the API name changes where FieldId is populated
    // and Update the fieldId if null and Is Custom
    // TES111121 Using FieldProperties 
    //////////////////////////////////////////////////////
    public static DmlResults refreshFieldFileProperties(string sobjectType) { return refreshFieldFileProperties(sobjectType ,null); }
    public static DmlResults refreshFieldFileProperties(string sobjectType, string sess) {
        
        DmlResults unsuccessfuls = new DmlResults();        
        LIST<Metadata__c> MetadataToUpdate = new LIST<Metadata__c>();
        if (sess!=null) API.SESSION=sess;


        //get the MetadataAPI FileProperties
        MAP<string,API.FileProperties> fprops = API.ListMetadataMap(sObjectType, 'CustomField');
        MAP<string,string> forceIdTofnameMap = new MAP<string,string>(); //will only map the custom fields as std fields do not have ids
        for (API.FileProperties fp : fprops.values()) {
            if (!Util.isBlank(fp.id))
                forceIdTofnameMap.put(fp.id,fp.fullname);
            //else
            //  TODO psudo forceIds for std fields?
        }


        ////////////////////////////////////////////////
        // START- Repair APIName change (only applies to custom)
        ///////////////////////////////////////////////
        LIST<string> APINameChange = new LIST<string>();
        for ( Metadata__c md : [    Select Id, fullName__c, forceId__c, namespace__c, 
                        CreatedBy__c, CreatedDT__c, LastModifiedBy__c, lastModifiedDT__c
                        from Metadata__c 
                                    where forceId__c in :forceIdTofnameMap.keySet()] ) {
            string fullname = forceIdTofnameMap.get(md.forceId__c);
            if (md.fullName__c!=fullName || md.forceId__c!=null) {
                API.FileProperties fprop=fprops.get(fullname); //get props based on new fullname
                copyFilePropertiesToMetadata(fprop,md,sObjectType);         
                MetadataToUpdate.add(md);
                APINameChange.add(fullname);
            }
        }
        
        //delete custom field records where fullname is a APINameChange 
        //that already exists and forceId is null (newly added)
        //Note:  If these records are not deleted then the update to change to the new fullname
        //will not be allowed due to unique constraint on fullname__c
        if (APINameChange.size()>0) {
            LIST<Metadata__c> MetadataToDelete = new LIST<Metadata__c>();
            MetadataToDelete = [Select Id from Metadata__c 
                    where ( forceId__c=null OR forceId__c='') 
                    AND fullName__c in :APINameChange
                    AND type__c='FIELD' 
                    AND Parent__r.fullName__c=:sobjectType];
            if  (MetadataToDelete.size()>0) 
                unsuccessfuls.add(new DmlResults(database.delete(metadataToDelete,false), metadataToDelete));       
        }       
                
        unsuccessfuls.add(new DmlResults(database.update(metadataToUpdate,false), metadataToUpdate));
        metadataToUpdate.clear();
        
        ////////////////////////////////////////////////
        // End - Repair APIName change
        ///////////////////////////////////////////////
        
        //Update custom fields and all standard field
        for ( Metadata__c md : [    Select Id, fullName__c, forceId__c, namespace__c, 
                         CreatedBy__c, CreatedDT__c, LastModifiedBy__c, lastModifiedDT__c
                        from Metadata__c 
                                    where type__c='FIELD' 
                                    AND Parent__r.fullName__c=:sobjectType] ) {
            API.FileProperties fprop=fprops.get(md.fullName__c);
            if (fprop==null) {
                FullNameFactory fnf = new FullNameFactory(md.fullName__c);
                fprop=fprops.get(fnf.devName); //lookup prop by just the field name (std field)
            }
            if (fprop!=null) {
            ///    system.debug(fprop);
                copyFilePropertiesToMetadata(fprop,md,sObjectType);                     
                MetadataToUpdate.add(md);
            }
            else if (md.fullName__c=='name') {  
                //no props for name fields,  just add a forceid?
            }
            else {
                //check if field has been deleted as flag as IsDeleted__c
                if (md.forceId__c!=null && forceIdTofnameMap.size()>0 && !forceIdTofnameMap.containsKey(md.forceId__c)) {
                    setMetadataToIsDeleted(md);
                    MetadataToUpdate.add(md);
                }
            }
        }

        /*
        for (API.FileProperties fprop : fprops ) {
            copyFilePropertiesToMetadata(fprop,md,sObjectType);
        }
        */

        //2.  Update
        if (MetadataToUpdate.size()>0)
            unsuccessfuls.add(new DmlResults(database.update(metadataToUpdate,false), metadataToUpdate));

        return unsuccessfuls;
                
    }
    
/////////////////////////////////////////////////////////////////////////////////////////////////////////   

        public static DmlResults refreshSObjectMetaDatabase(string sobjectType) {           
        DmlResults unsuccessfuls = new DmlResults();
        //unsuccessfuls.add(Metadata.refreshSObjectForceIds(null));
        unsuccessfuls.add(refreshFieldFileProperties(sobjectType));
        unsuccessfuls.add(refreshMetaDatabase(sobjectType));
        return unsuccessfuls;
    }
    
/////////////////////////////////////////////////////////////////////////////////////////////////////////   

        
    /////////////////////////////////////////////////////////////////////
    // Refresh the metadata__c records for database related assets
    // This uses the native Apex describe calls
    ////////////////////////////////////////////////////////////////////
    public static DmlResults refreshMetaDatabase(string sObjectType) {return RefreshMetaDatabase(Schema.getGlobalDescribe().get(sObjectType)); }
    public static DmlResults refreshMetaDatabase(Schema.SObjectType sObjectType) {
        
        DmlResults unsuccessfuls = new DmlResults();
        Schema.Describesobjectresult DSR = sObjectType.getDescribe(); 
    ///    system.debug('DSR: '+String.valueOf(DSR));
        
        //user getKeyPrefix to filter backend objects _History, _Sharing, etc...
        if (DSR.getKeyPrefix()!=null)  {
            
            string subtype;
            if (DSR.isCustomSetting())
                subtype='CUSTOM_SETTING';
            else if (DSR.IsCustom()) 
                subtype='CUSTOM_OBJECT';
            else    
                subtype='STANDARD_OBJECT';

            ///////////////////////////////////////                     
            //create Metadata record for: sobject 
            ///////////////////////////////////////
            metadata__c mO = new metadata__c(
                name                = DSR.getName(), 
                describe__c         = String.valueOf(DSR).replace(';','; '),  //to allow wrap in pagelayout
                recordTypeId        = RTYPE_SOBJECT,
                label__c            = DSR.getLabel(),
                type__c             = 'SOBJECT',
                subtype__c          = subtype,
                FullName__c         = DSR.getName(),
                KeyPrefix__c        = DSR.getKeyPrefix(),
                isCustom__c         = DSR.IsCustom()
            );
            
            //Upsert Sobject metadata
            LIST<Metadata__c> ups = new LIST<Metadata__c>{mO};
            unsuccessfuls.add(new DmlResults(database.upsert(ups,Metadata__c.FullName__c,false),ups));

            ///////////////////////////////////////
            //create Metadata records for: field
            ///////////////////////////////////////
            Map<String, SObjectField> fieldMap = DSR.fields.getMap();
            LIST<metadata__c> metadataToUpsert = new LIST<metadata__c>();
            for (String fn : fieldMap.keyset()) {   
                
                //TES20131022 exclude contact fields (personAccount fields)
                if (fn.endsWith('__pc'))
                    continue; //next;
                
                Schema.DescribeFieldResult DFR = fieldMap.get(fn).getDescribe();
      ///          system.debug('DFR: '+String.valueOf(DFR));
                
                metadata__c mF = new Metadata__c(
                    name                = DFR.getName(),
                    FullName__c         = mO.name+'.'+DFR.getName(),  //TODO: ?Consider Event/task as 'Activity.'+DFR.getName()
                    describe__c         = String.valueOf(DFR).replace(';','; '),  //to allow wrap in pagelayout
                    parent__c           = mO.Id,
                    recordTypeId        = RTYPE_FIELD,
                    label__c            = DFR.getLabel(),
                    type__c             = 'FIELD',
                    subtype__c          = String.valueOf(DFR.getType()).replace('Schema.DisplayType.',''),
                    size__c             = DFR.getLength(),
                    isCustom__c         = DFR.isCustom()
                );

                //add parent reference specific info
                if (mF.subtype__c=='REFERENCE') {
                    //get ReferenceTo
                    List <Schema.sObjectType> ReferenceTos = DFR.getReferenceTo();
                    if (ReferenceTos!=null && ReferenceTos.size()!=0) {
                        string RefTo=(ReferenceTos.size()==1) ? String.valueOf(ReferenceTos[0]) : 'polymorphic';
                        mf.ReferenceTo__c = RefTo;
                        string lwRefTo=RefTo.toLowercase();
                        //TESII20110215 exclude feed,history and share childrelationships
                        if ( !(lwRefTo.endsWith('feed') || lwRefTo.endsWith('history') || lwRefTo.endsWith('share') || lwRefTo.endsWith('noteandattachment')) ) {
                            mf.ReferenceToMetaData__r=(RefTo!='polymorphic') ? new Metadata__c(Fullname__c=refTo) : null;       
                        }       
                    }
                    mf.RelationshipName__c=DFR.getRelationshipName();
                }
                metadataToUpsert.add(mF);
                
            }  //next field
            
            
            //Upsert Field metadata
            if (metadataToUpsert.size()>0)
                unsuccessfuls.add(new DmlResults(database.upsert(metadataToUpsert,Metadata__c.FullName__c,false),metadataToUpsert));        

            /////////////////////////////////////////////////
            //create Metadata records for: picklists 
            /////////////////////////////////////////////////
            // Rohit saini 2016/01/27 initialization of variable outside loop issue IS ID-00064089
             LIST<metadata__c> metadataPicksToUpsert = new LIST<metadata__c>();
            for (Metadata__c mF : metadataToUpsert) {
                if (mF.subtype__c=='PICKLIST' || mF.subtype__c=='MULTIPICKLIST') {
                    // Rohit saini 2016/01/27 Commented initialization of variable outside loop issue IS ID-00064089
                    //LIST<metadata__c> metadataPicksToUpsert = new LIST<metadata__c>();
                    //Go get the picklist Items
                    Schema.DescribeFieldResult DFR = fieldMap.get(mF.name.toLowerCase()).getDescribe();
                    List <Schema.PicklistEntry> pickEntries = DFR.getPicklistValues();
                    for (Schema.PicklistEntry pick :  pickEntries) {
                        metadata__c mP = new Metadata__c(
                            name                = pick.getValue(),
                            FullName__c         = mO.name+'.'+mF.name+'.'+pick.getValue(),
                            describe__c         = String.valueOf(pick).replace(';','; '),  //to allow wrap in pagelayout
                            parent__c           = mF.Id,
                            recordTypeId        = RTYPE_PICKLIST,
                            label__c            = pick.getLabel(),
                            type__c             = 'PICKLISTENTRY'
                        );
                        if (mP.name.length()>80) mP.name=mP.name.substring(0,80);
                        if (mP.label__c!=null && mP.label__c.length()>255) mP.label__c=mP.label__c.substring(0,255);
                        if (mP.FullName__c.length()>255) mP.FullName__c=mP.FullName__c.substring(0,255);
             ///           system.debug('PicklistEntry: '+mP);
                        metadataPicksToUpsert.add(mP);
                    }
                    //upsert for each pickField,  bulking these could cause DML rowsize limits
                   /* Rohit saini 2016/01/27 removed DML from loop issue IS ID-00064089
                   if (metadataPicksToUpsert.size()>0 && Limits.getLimitDmlRows()>(Limits.getDmlRows()+metadataPicksToUpsert.size()) )
                        unsuccessfuls.add(new DmlResults(database.upsert(metadataPicksToUpsert,Metadata__c.FullName__c,false),metadataPicksToUpsert));*/
                }
            }
                   // Rohit saini 2016/01/27 Added DML here after removing from loop IS ID-00064089
            if (metadataPicksToUpsert.size()>0 && Limits.getLimitDmlRows()>(Limits.getDmlRows()+metadataPicksToUpsert.size()) )
                        unsuccessfuls.add(new DmlResults(database.upsert(metadataPicksToUpsert,Metadata__c.FullName__c,false),metadataPicksToUpsert));
                
            /////////////////////////////////////////////////
            //add childrelationship info  to parent fields if avail 
            // (ChildRelationName, cascadeDelete)
            /////////////////////////////////////////////////                   
            metadataToUpsert.clear();
            for ( Schema.ChildRelationship cr : DSR.getChildRelationships() ) {
        ///        system.debug(cr);
                //TES_20110420 filter some of the common child sfdc object
                SET<string> filterCrn = new SET<string>{'noteandattachment','openactivity'};
                string csobjType = String.valueOf(cr.getChildSObject()); 
                string crn=csobjType.tolowercase();
                string fieldName =  String.valueOf(cr.getField());
                if (! ( crn.endsWith('history') || crn.endsWith('feed') || crn.endsWith('share') || filterCrn.contains(crn)) ) {
                            metadata__c mF = new Metadata__c(
                            name                    = fieldName,
                            parent__r               = new Metadata__c(Fullname__c=csobjType),
                            FullName__c             = csobjType+'.'+fieldName,
                            ChildRelationshipName__c= cr.getRelationshipName(),
                            CascadeDelete__c        = cr.isCascadeDelete(),
                            recordTypeId            = RTYPE_FIELD
                        );      
                    metadataToUpsert.add(mF);
                }
            }
            //dont make this an atomic trans since some of these objects may not exists yet
            //using upsert to reduce this from happening
            //IGNORE Erro if missing parent..ERROR WHERE MSG LIKE Foreign key external ID:... not found
            if (metadataToUpsert.size()>0 && Limits.getLimitDmlRows()>(Limits.getDmlRows()+metadataToUpsert.size()) ) 
                unsuccessfuls.add(new DmlResults(database.upsert(metadataToUpsert,Metadata__c.FullName__c,false),metadataToUpsert));
        }
        else {}
          ///  system.debug('Skipped sObject: '+sobjectType+' due to missing Prefix.');
    
        return unsuccessfuls;
    }

        
        


    

////////////////////////////////////////////////////////////////////////////////////////////////////////////////    
//
//  METADATA LAYOUT METHODS
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////    
    
/////////////////////////////////////////////////////////////////////////////////////////////////////////   

    
    public static DMLResults RefreshSObjectLayout(string aSObjectType) {
        DmlResults rtn = new DmlResults();
        LIST<Metadata__c> metadata = new LIST<Metadata__c>();
        metadata.addAll(getMetadataLayoutsViaAPI(aSObjectType));
        metadata.addAll(getMetadataRecordtypes(aSObjectType));      
        
        if (metadata.size()>0 && metadata.size()<=10000) 
            rtn.add(new DmlResults(database.upsert(metadata,Metadata__c.ForceId__c,false),metadata));
        /*  NO NEED TO CHUNK DML
        else {
            //we need to chunk this (metadata.size()>10000) 
            LIST<Metadata__c> chunk = new LIST<Metadata__c>();
            for ( Metadata__c md : metadata ) {
                chunk.add(md);
                if (chunk.size()>=1000) {
                    rtn.add(new DmlResults(database.upsert(chunk,Metadata__c.ForceId__c,false),chunk));
                    chunk.clear();
                }
            }
            //flush
            if (chunk.size()>0)
                rtn.add(new DmlResults(database.upsert(chunk,Metadata__c.ForceId__c,false),chunk));
        }
        */
        return rtn;     
    }   
////////////////////////////////////////////////////////////////////////////////////////////////////////////////    

//Need to Create Layouts and Recordtypes prior to making this call (RefreshSObjectLayout)
        public static DmlResults refreshLayoutInfo(string aSObjectType) { return refreshLayoutInfo(aSObjectType,new SET<Id>()); }
        public static DmlResults refreshLayoutInfo(string aSObjectType, string recordtypeId) { return refreshLayoutInfo(aSObjectType, new SET<Id>{recordtypeId} ); }
        public static DmlResults refreshLayoutInfo(string aSObjectType, SET<Id> recordtypeIds) {
            DmlResults rtn = new DmlResults();
            DescribeLayout d;
            if (recordtypeIds==null || recordtypeIds.size()==0)
                d = new DescribeLayout(aSObjectType);
            else
                d = new DescribeLayout(aSObjectType,recordtypeIds);
            
            MAP<Id,SET<string>> layoutFields = d.getlayoutFields();
            if (layoutFields.size()>0) {
                //Add layouts
                MAP<string,MetadataItem__c> layoutsToUpsert = new MAP<string,MetadataItem__c>(); //<layoutId,Metadata__c>
                for (Id lid : layoutFields.keySet()) {
                    for (string fld : layoutFields.get(lid)) {
                        string fullname=aSObjectType+'.'+fld;
                        MetadataItem__c mdR = new MetadataItem__c(
                            Metadata__r         = new Metadata__c(ForceId__c=lid),
                            RelatedMetadata__r  = new Metadata__c(FullName__c=fullname),
                            type__c             = 'LayoutField',
                            ExternalId__c       = lid+'-'+fullname
                        );
                        layoutsToUpsert.put(mdR.ExternalId__c,mdR);
                        
                        //batch these updates to save on heap space.
                    if (layoutsToUpsert.size()>=1000) {
                        rtn.add(new DmlResults(database.upsert(layoutsToUpsert.values(),MetadataItem__c.ExternalId__c,false),layoutsToUpsert.values()));
                        layoutsToUpsert.clear();
                        }
                    }
                }
                if (layoutsToUpsert.size()>0)
                    rtn.add(new DmlResults(database.upsert(layoutsToUpsert.values(),MetadataItem__c.ExternalId__c,false),layoutsToUpsert.values()));
            }
            
            
            
            MAP<id,RecordTypeMapping> rtypeMappings = d.getRecordTypeMappings();
            if (rtypeMappings.size()>0) {
                MAP<string,Metadata__c> MetadataToUpsert = new MAP<string,Metadata__c>(); 
                MAP<string,MetadataItem__c> MetaRelationsToUpsert = new MAP<string,MetadataItem__c>();
                for (RecordTypeMapping rm : rtypeMappings.values()) {
                    
                    //Ignore master
                    //[12302016] Merge&Spin: Replaced Master Record type Hard Coded Id with custom Label
                    if (rm.recordTypeId!=System.Label.MasterRecordTypeId) {
                    
                        //relates a single recordtype to many layouts this is profile dependant
                        try {   
                                metadata__c m = new Metadata__c(
                                    ForceId__c              = rm.recordTypeId,
                                    ReferenceTo__c          = 'layout',
                                    ReferenceToMetaData__r  = new Metadata__c(ForceId__c=rm.layoutId)   
                                    );
                                MetadataToUpsert.put(m.ForceId__c,m);
                        }catch(exception ex) {}
                    
                        
                        //MAP<string,MAP<string,picklistValues>>
                        for ( string fld : rm.picklistsForRecordType.keyset()) {
                            for ( string pl : rm.picklistsForRecordType.get(fld).keyset() ) { 
                                string fullName=aSObjectType+'.'+fld+'.'+pl;
                                
                                MetadataItem__c mdR = new MetadataItem__c(
                                    Metadata__r         = new Metadata__c(ForceId__c=rm.recordTypeId),
                                    RelatedMetadata__r  = new Metadata__c(FullName__c=fullname),
                                    type__c             = 'RecordTypePickList',
                                    ExternalId__c       = rm.recordTypeId+'-'+fullname
                                );
                                
                                MetaRelationsToUpsert.put(mdR.ExternalId__c,mdR);       
                            
                                if (MetaRelationsToUpsert.size()>=1000) {
                                    rtn.add(new DmlResults(database.upsert(MetaRelationsToUpsert.values(),MetadataItem__c.ExternalId__c,false),MetaRelationsToUpsert.values()));
                                    MetaRelationsToUpsert.clear();
                                }
                            }
                        }
                    }
                } //NEXT rm
                //flush
                if (MetaRelationsToUpsert.size()>0)
                    rtn.add(new DmlResults(database.upsert(MetaRelationsToUpsert.values(),MetadataItem__c.ExternalId__c,false), MetaRelationsToUpsert.values()));
                
                
                //now update the Rtype/layout relations (this is profile dependant, maybe should not include)
                rtn.add(new DmlResults(database.upsert(MetadataToUpsert.values(),Metadata__c.ForceId__c,false)));
            }
            
        return rtn;
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////    

    public static LIST<Metadata__c> getMetadataRecordtypes() { return getMetadataRecordtypes(null); }   
    public static LIST<Metadata__c> getMetadataRecordtypes(string aSObjectType) {
        LIST<Metadata__c> rtn = new LIST<Metadata__c>();
        
        if  (String.IsBlank(aSObjectType))
            aSObjectType=null;
        
        if (aSObjectType!=null)
            for (RecordType rt : [  Select Id, Name, developerName, sobjecttype,
                                    NamespacePrefix,Description,BusinessProcessId,IsActive,CreatedById,CreatedDate,LastModifiedById, LastModifiedDate
                                    From RecordType
                                    where sobjecttype=:aSObjectType ]) {
                try {
                    metadata__c mL = new Metadata__c(
                        name                = rt.developerName, 
                        parent__r           = new Metadata__c(FullName__c=rt.sobjecttype),
                        recordTypeId        = RTYPE_LAYOUT,
                        label__c            = rt.name,
                        type__c             = 'RECORDTYPE',
                        FullName__c         = rt.sobjecttype+'.'+rt.developerName,
                        ForceId__c          = rt.id,
                        describe__c         = string.valueOf(rt),
                        description__c      = rt.description,
                        namespace__c        = rt.NamespacePrefix,
                        CreatedBy__c        = rt.CreatedById,
                        CreatedDT__c        = rt.CreatedDate,
                        LastModifiedBy__c   = rt.LastModifiedById,
                        LastModifiedDT__c   = rt.LastModifiedDate
                        );
                    rtn.add(mL);
                }
                catch(exception ex) {}
            }
        else
            for (RecordType rt : [  Select Id, Name, developerName, sobjecttype,
                                    NamespacePrefix,Description,BusinessProcessId,IsActive,CreatedById,CreatedDate,LastModifiedById, LastModifiedDate
                                    From RecordType ]) {
                try {
                    metadata__c mL = new Metadata__c(
                        name                = rt.developerName, 
                        parent__r           = new Metadata__c(FullName__c=rt.sobjecttype),
                        recordTypeId        = RTYPE_LAYOUT,
                        label__c            = rt.name,
                        type__c             = 'RECORDTYPE',
                        FullName__c         = rt.sobjecttype+'.'+rt.developerName,
                        ForceId__c          = rt.id,
                        describe__c         = string.valueOf(rt),
                        description__c      = rt.description,
                        namespace__c        = rt.NamespacePrefix,
                        CreatedBy__c        = rt.CreatedById,
                        CreatedDT__c        = rt.CreatedDate,
                        LastModifiedBy__c   = rt.LastModifiedById,
                        LastModifiedDT__c   = rt.LastModifiedDate
                        );
                    rtn.add(mL);
                }
                catch(exception ex) {}
            }
    return rtn;
    }
////////////////////////////////////////////////////////////////////////////////////////////////////////////////    
    
    
    
////////////////////////////////////////////////////////////////////////////////////////////////////////////////    
//
//  METADATA LOGIC METHODS
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    public static LIST<Metadata__c> getMetadataLogic() {
        LIST<Metadata__c> rtn = getMetadataApexClass();
        rtn.AddAll(getMetadataTriggers());
        rtn.AddAll(getMetadataVFPages());
        rtn.AddAll(getMetadataVFComponents());
        return rtn;
    }
    
////////////////////////////////////////////////////////////////////////////////////////////////////////////////    
    
    //TES20120828 - removed out VR/WR Fileproperties,  now included in FileProperties batch
    public static DMLResults RefreshLogic() {
        DmlResults rtn = new DmlResults();
        LIST<Metadata__c> metadata = new LIST<Metadata__c>();
        metadata.addAll(getMetadataLogic());

        if (metadata.size()>0 && metadata.size()<=1000) 
            rtn.add(new DmlResults(database.upsert(metadata,Metadata__c.ForceId__c,false),metadata));
        else {
            //we need to chunk this (metadata.size()>1000) 
            LIST<Metadata__c> chunk = new LIST<Metadata__c>();
            for ( Metadata__c md : metadata ) {
                chunk.add(md);
                if (chunk.size()>=1000) {
                    rtn.add(new DmlResults(database.upsert(chunk,Metadata__c.ForceId__c,false),chunk));
                    chunk.clear();
                }
            }
            //flush
            if (chunk.size()>0)
                rtn.add(new DmlResults(database.upsert(chunk,Metadata__c.ForceId__c,false),chunk));
        }
        //fire off the code back batch 
        Database.executeBatch(new batchRefreshMetadataLogic(),50);
        return rtn;     
    }   
    
    
////////////////////////////////////////////////////////////////////////////////////////////////////////////////    

    public static LIST<Metadata__c> getMetadataApexClass()  {
        LIST<Metadata__c> rtn = new LIST<Metadata__c>();
        
            for (ApexClass r : [    Select Status, NamespacePrefix, Name, LengthWithoutComments, 
                                        LastModifiedDate, LastModifiedById, IsValid, Id, CreatedDate, CreatedById, 
                                        BodyCrc, ApiVersion From ApexClass
                                ]) {
                try {
                    string fullname= (Util.isBlank(r.NamespacePrefix)) ? r.Name+'.class' : r.NamespacePrefix+'__'+r.Name+'.class';
                    metadata__c mL = new Metadata__c(
                        name                = r.Name, 
                        //parent__r         = new Metadata__c(FullName__c=r.TableEnumOrId),
                        recordTypeId        = RTYPE_LOGIC,
                        label__c            = r.Name,
                        type__c             = 'APEX_CODE',
                        subtype__c          = 'Class',
                        version__c          = r.ApiVersion,
                        FullName__c         = fullname,
                        ForceId__c          = r.id,
                        size__c             = r.LengthWithoutComments,
                        describe__c         = string.valueOf(r),
                        //description__c        = r.description,
                        namespace__c        = r.NamespacePrefix,
                        CreatedBy__c        = r.CreatedById,
                        CreatedDT__c        = r.CreatedDate,
                        LastModifiedBy__c   = r.LastModifiedById,
                        LastModifiedDT__c   = r.LastModifiedDate
                        );
                    rtn.add(mL);
                }
                catch(exception ex) {}
            }
    return rtn;
    }



    
////////////////////////////////////////////////////////////////////////////////////////////////////////////////    

    public static LIST<Metadata__c> getMetadataTriggers() { return getMetadataTriggers(null); } 
    public static LIST<Metadata__c> getMetadataTriggers(string aSObjectType) {
        LIST<Metadata__c> rtn = new LIST<Metadata__c>();
        
        if (aSObjectType!=null)
            for (ApexTrigger r : [  Select UsageIsBulk, UsageBeforeUpdate, UsageBeforeInsert, UsageBeforeDelete, UsageAfterUpdate, UsageAfterUndelete, UsageAfterInsert, UsageAfterDelete, 
                                    TableEnumOrId,  Status, NamespacePrefix, Name, LengthWithoutComments, LastModifiedDate, LastModifiedById, 
                                    IsValid, Id, CreatedDate, CreatedById, BodyCrc, ApiVersion 
                                    From ApexTrigger
                                    where TableEnumOrId=:aSObjectType ]) {
                try {
                    string fullname= (Util.isBlank(r.NamespacePrefix)) ? r.Name+'.trigger': r.NamespacePrefix+'__'+r.Name+'.trigger';
                    metadata__c mL = new Metadata__c(
                        name                = r.Name, 
                        parent__r           = new Metadata__c(FullName__c=r.TableEnumOrId),
                        recordTypeId        = RTYPE_LOGIC,
                        label__c            = r.Name,
                        type__c             = 'APEX_CODE',
                        subtype__c          = 'Trigger',
                        version__c          = r.ApiVersion,
                        FullName__c         = fullname,
                        ForceId__c          = r.id,
                        size__c             = r.LengthWithoutComments,
                        describe__c         = string.valueOf(r),
                        //description__c        = r.description,
                        namespace__c        = r.NamespacePrefix,
                        CreatedBy__c        = r.CreatedById,
                        CreatedDT__c        = r.CreatedDate,
                        LastModifiedBy__c   = r.LastModifiedById,
                        LastModifiedDT__c   = r.LastModifiedDate
                        );
                    rtn.add(mL);
                }
                catch(exception ex) {}
            }
        else
            for (ApexTrigger r : [  Select UsageIsBulk, UsageBeforeUpdate, UsageBeforeInsert, UsageBeforeDelete, UsageAfterUpdate, UsageAfterUndelete, UsageAfterInsert, UsageAfterDelete, 
                                    TableEnumOrId,  Status, NamespacePrefix, Name, LengthWithoutComments, LastModifiedDate, LastModifiedById, 
                                    IsValid, Id, CreatedDate, CreatedById, BodyCrc, ApiVersion 
                                    From ApexTrigger ]) {
                try {
                    string fullname= (Util.isBlank(r.NamespacePrefix)) ? r.Name+'.trigger': r.NamespacePrefix+'__'+r.Name+'.trigger';
                    metadata__c mL = new Metadata__c(
                        name                = r.Name, 
                        parent__r           = new Metadata__c(FullName__c=r.TableEnumOrId),
                        recordTypeId        = RTYPE_LOGIC,
                        label__c            = r.name,
                        type__c             = 'APEX_CODE',
                        subtype__c          = 'Trigger',
                        version__c          = r.ApiVersion,
                        FullName__c         = fullname,
                        ForceId__c          = r.id,
                        size__c             = r.LengthWithoutComments,
                        describe__c         = string.valueOf(r),
                        //description__c        = r.description,
                        namespace__c        = r.NamespacePrefix,
                        CreatedBy__c        = r.CreatedById,
                        CreatedDT__c        = r.CreatedDate,
                        LastModifiedBy__c   = r.LastModifiedById,
                        LastModifiedDT__c   = r.LastModifiedDate
                        );
                    rtn.add(mL);
                }
                catch(exception ex) {}
            }
    return rtn;
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////    

    public static LIST<Metadata__c> getMetadataVFPages() {
        LIST<Metadata__c> rtn = new LIST<Metadata__c>();
        
            for (ApexPage r : [ Select SystemModstamp, NamespacePrefix, Name, MasterLabel,  
                LastModifiedDate, LastModifiedById, Id, Description, CreatedDate, CreatedById, 
                ControllerType, ControllerKey, ApiVersion From ApexPage
            ]) {
                
                try {
                    string subtype='No Controller';
                    Metadata__c parent;
                    if  (r.ControllerType=='1') {
                        string parentFullName=((!Util.isBlank(r.NamespacePrefix)) && r.ControllerKey.endsWith('__c')) ? r.NamespacePrefix+'__'+r.ControllerKey : r.ControllerKey;
                        parent = new Metadata__c(FullName__c=parentFullName);
                        subtype = 'Standard Controller';  //SOBJECT
                    }
                    else if (r.ControllerType=='2') {
                        string parentFullName=(Util.isBlank(r.NamespacePrefix)) ? r.ControllerKey : r.NamespacePrefix+'__'+r.ControllerKey;
                        parent = new Metadata__c(FullName__c=parentFullName+'.class');
                        subtype = 'Custom Controller'; //APEX CLASS
                    }
                    string fullname = (Util.isBlank(r.NamespacePrefix)) ? r.Name+'.page': r.NamespacePrefix+'__'+r.Name+'.page';
                    metadata__c mL = new Metadata__c(
                        name                = r.Name, 
                        parent__r           = parent,
                        recordTypeId        = RTYPE_LOGIC,
                        label__c            = r.MasterLabel,
                        type__c             = 'VISUALFORCE',
                        subtype__c          = 'Page',
                        version__c          = r.ApiVersion,
                        FullName__c         = fullname,
                        ForceId__c          = r.id,
                        //size__c               = r.LengthWithoutComments,
                        describe__c         = string.valueOf(r),
                        description__c      = r.Description,
                        namespace__c        = r.NamespacePrefix,
                        CreatedBy__c        = r.CreatedById,
                        CreatedDT__c        = r.CreatedDate,
                        LastModifiedBy__c   = r.LastModifiedById,
                        LastModifiedDT__c   = r.LastModifiedDate
                        );
                    rtn.add(mL);
                }
                catch(exception ex) {}
            }
    return rtn;
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////    

    public static LIST<Metadata__c> getMetadataVFComponents() {
        LIST<Metadata__c> rtn = new LIST<Metadata__c>();
        
            for (ApexComponent r : [    Select SystemModstamp, NamespacePrefix, Name, MasterLabel,  
                LastModifiedDate, LastModifiedById, Id, Description, CreatedDate, CreatedById, 
                ControllerType, ControllerKey, ApiVersion From ApexComponent
            ]) {
                
                try {
                    string subtype='No Controller';
                    Metadata__c parent;
                    if          (r.ControllerType=='1') {
                        string parentFullName=((!Util.isBlank(r.NamespacePrefix)) && r.ControllerKey.endsWith('__c')) ? r.NamespacePrefix+'__'+r.ControllerKey : r.ControllerKey;
                        parent = new Metadata__c(FullName__c=parentFullName);
                        subtype = 'Standard Controller';
                    }
                    else if     (r.ControllerType=='2') {
                        string parentFullName=(Util.isBlank(r.NamespacePrefix)) ? r.ControllerKey : r.NamespacePrefix+'__'+r.ControllerKey;
                        parent = new Metadata__c(FullName__c=parentFullName+'.class');
                        subtype = 'Custom Controller';
                    }
                    string fullname= (Util.isBlank(r.NamespacePrefix)) ? r.Name+'.component': r.NamespacePrefix+'__'+r.Name+'.component';
                    metadata__c mL = new Metadata__c(
                        name                = r.Name, 
                        parent__r           = parent,
                        recordTypeId        = RTYPE_LOGIC,
                        label__c            = r.MasterLabel,
                        type__c             = 'VISUALFORCE',
                        subtype__c          = 'Component',
                        version__c          = r.ApiVersion,
                        FullName__c         = fullname,
                        ForceId__c          = r.id,
                        //size__c               = r.LengthWithoutComments,
                        describe__c         = string.valueOf(r),
                        description__c      = r.Description,
                        namespace__c        = r.NamespacePrefix,
                        CreatedBy__c        = r.CreatedById,
                        CreatedDT__c        = r.CreatedDate,
                        LastModifiedBy__c   = r.LastModifiedById,
                        LastModifiedDT__c   = r.LastModifiedDate
                        );
                    rtn.add(mL);
                }
                catch(exception ex) {}
            }
    return rtn;
    }   
////////////////////////////////////////////////////////////////////////////////////////////////////////////////    

    public static LIST<Metadata__c> getMetadataLayoutsViaAPI() { return getMetadataLayoutsViaAPI(null); }   
    public static LIST<Metadata__c> getMetadataLayoutsViaAPI(string sobjectType) {
        
        if  (String.IsBlank(sobjectType))
            sobjectType='';
        
        return Metadata.listMetadata('Layout',sobjectType);
    
        /*  Old Way
        
        LIST<Metadata__c> rtn = new LIST<Metadata__c>();
        
        //TES20110805 bug cannot specify '*' with Layout
        //MAP<string,String> md = API.listMetadataCompact('*', 'Layout',sobjectType);   
        MAP<string,String> md = API.listMetadataCompact('', 'Layout',sobjectType);
        
        for (Id id : md.KeySet()) {
            try {
                string[] arrFullName = md.get(id).split('-',2);
                string name=EncodingUtil.urlDecode(arrFullName[1],'UTF-8');
                metadata__c mL = new Metadata__c(
                    name                = name, 
                    parent__r           = new Metadata__c(FullName__c=arrFullname[0]),
                    recordTypeId        = RTYPE_LAYOUT,
                    label__c            = name,
                    type__c             = 'Layout',
                    FullName__c         = md.get(id),
                    ForceId__c          = id
                    );
                rtn.add(mL);
            }
            catch(exception ex) {}
        }
        return  rtn;
        
        */
    }
    

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
public static LIST<Metadata__c> listMetadata(Metadata.ListMetadataInstruction instr) { return listMetadata(instr.metadataType, instr.folder, null); }   
public static LIST<Metadata__c> listMetadata(string mtype) { return listMetadata(mtype, null, null); }
public static LIST<Metadata__c> listMetadata(string mtype, string folder) { return listMetadata(mtype, folder, null); }
public static LIST<Metadata__c> listMetadata(string mtype, string folder, string rtypeId) {
    
        LIST<Metadata__c> rtn = new LIST<Metadata__c>();
        LIST<API.FileProperties> md = API.listMetadata(folder, mtype);
        for (API.FileProperties fp : md) {
            try {
                Metadata__c mL = new Metadata__c();
                copyFilePropertiesToMetadata(fp,mL, folder);  //TES20130326 added folder
                if (rtypeid!=null) mL.recordtypeId=rtypeid;
                rtn.add(mL);
            }
            catch(exception ex) { system.debug('ERR.Metadata.listMetadata: '+ex);}
        }
        return  rtn;
}
    
    public static void copyFilePropertiesToMetadata(API.FileProperties fprop, Metadata__c md) {copyFilePropertiesToMetadata(fprop,md,null);}
    public static void copyFilePropertiesToMetadata(API.FileProperties fprop, Metadata__c md, string folder) {

        string mtype=fprop.resultType;
        if (fprop.resultType=='CustomObject') {
            //CURRENTLY JUST UPDATES TO METADATA NOT INSERTS (see refreshFieldFileProperties())
            //  md.recordtypeId         =RTYPE_SOBJECT;
                md.forceId__c           = fprop.id;
                md.fullName__c          = fprop.fullName;   
                md.type__c              = 'SOBJECT';        
        }
        else if (fprop.resultType=='CustomField') {
            //CURRENTLY JUST UPDATES TO METADATA NOT INSERTS (see refreshFieldFileProperties())
            //string[] arrFullName = fp.fullName.split(delimeter,2);
            string fname=(fprop.fullName.contains('.')) ? fprop.fullName : folder+'.'+fprop.fullName;
            //md.recordtypeId           = RTYPE_FIELD;
            //md.type__c                ='FIELD';
            md.forceId__c           = fprop.id;
            md.fullName__c          = fname;
            //md.parent__r          = new Metadata__c(FullName__c=parentFullName);  
        }
        else if (fprop.resultType=='Layout') {
            string[] arrFullName = fprop.fullName.split('-',2);
            string name=EncodingUtil.urlDecode(arrFullName[1],'UTF-8');
            md.recordTypeId     = RTYPE_LAYOUT;
            md.name             = name;
            md.label__c         = name;
            md.fullName__c      = fprop.fullName;
            md.type__c          = 'LAYOUT';
            md.forceId__c       = fprop.id;
            md.parent__r        = new Metadata__c(FullName__c=arrFullname[0]);
            md.fullName__c      = fprop.fullName;
        }
        else {
            string name=EncodingUtil.urlDecode(fprop.fullName,'UTF-8');
            
            if (fprop.fullName.contains('.')) {
                //SOBJECT MDTYPE
                string[] arrFullName = fprop.fullName.split('\\.',2);
                name=EncodingUtil.urlDecode(arrFullName[1],'UTF-8');
                md.fullName__c      = fprop.fullName+'.'+mtype.toLowercase();
                md.parent__r        = new Metadata__c(FullName__c=arrFullName[0]);
            }
            else if (folder!=null) {
                //SOBJECT MDTYPE
                string fname=(fprop.fullName.contains('.')) ? fprop.fullName : folder+'.'+fprop.fullName;
                name=EncodingUtil.urlDecode(fprop.fullName,'UTF-8');
                md.fullName__c      = fname+'.'+mtype.toLowercase();
                md.parent__r        = new Metadata__c(FullName__c=folder);
            }
            else {
                //ROOT MDTYPE
                md.fullName__c      = fprop.fullName+'.'+mtype.toLowercase();       
            }
            md.forceId__c       = fprop.id;
            md.recordTypeId     = RTYPE_GENERAL;
            md.name             = (name.length()>80)?name.substring(0,80):name;
            md.label__c         = name; 
            md.type__c          = mtype;    
            
        }//END GENERAL TYPES
        
        //ALL TYPES GET THESE UPDATES
        md.FileName__c          = fprop.fileName;
        md.namespace__c         = fprop.namespacePrefix;
        md.CreatedBy__c         = fprop.CreatedById;
        md.CreatedDT__c         = fprop.CreatedDate;
        md.LastModifiedBy__c    = fprop.lastModifiedById;
        md.lastModifiedDT__c    = fprop.lastModifiedDate;   
        
        
            /*  NOT SURE IF THIS WAS EVER NEEDED
                else {
                    //STANDARD OBJECTS AND FIELDS
                    if (fprop.resultType=='CustomField') {
                        //std field
                        string fname=(fprop.fullName.contains('.')) ? fprop.fullName : sObjectType+'.'+fprop.fullName;
                        md.forceId__c           = fname;
                        md.fullName__c          = fname;
                    }
                    else if (fprop.resultType=='CustomObject') {
                        //std Object
                        md.forceId__c           = fprop.fullName;
                        md.fullName__c          = fprop.fullName;
                    }
                }
                */
                            
    }   
    

////////////////////////////////////////////////////////////////////////////////////////////////////////////////    

/*  TES20120828
    public static LIST<Metadata__c> getMetadataWebLinkViaAPI() { return getMetadataValidationRulesViaAPI(null); }   
    public static LIST<Metadata__c> getMetadataWebLinkViaAPI(string sobjectType) {

        LIST<Metadata__c> rtn = new LIST<Metadata__c>();
        LIST<API.FileProperties> md = API.listMetadata('', 'WebLink',sobjectType);
        for (API.FileProperties fp : md) {
            try {

                Metadata__c mL = FilePropertiesToMetadata(fp);
                string[] arrFullName = fp.fullName.split('\\.',2);
                string name=EncodingUtil.urlDecode(arrFullName[1],'UTF-8');
                mL.name             = (name.length()>80)?name.substring(0,80):name; 
                mL.parent__r        = new Metadata__c(FullName__c=arrFullname[0]);
                mL.recordTypeId     = RTYPE_LOGIC;
                mL.label__c         = name;
                mL.type__c          = fp.resultType;
                mL.FullName__c      = fp.fullName+'.'+fp.resultType;
                rtn.add(mL);
            }
            catch(exception ex) {}
        }
        return  rtn;
    }
*/  
    

    
////////////////////////////////////////////////////////////////////////////////////////////////////////////////    
    
    /*  REPLACED TES20120828 batchRefreshMetadataFileProperties
    
    public static LIST<Metadata__c> getMetadataWorkflowViaAPI() { return getMetadataWorkflowViaAPI(null); } 
    public static LIST<Metadata__c> getMetadataWorkflowViaAPI(string sobjectType) {

        LIST<Metadata__c> rtn = new LIST<Metadata__c>();
        LIST<API.FileProperties> md = API.listMetadata('', 'WorkflowRule', sobjectType);
        md.AddAll(API.listMetadata('', 'WorkflowFieldUpdate', sobjectType));
        md.AddAll(API.listMetadata('', 'WorkflowAlert', sobjectType));
        md.AddAll(API.listMetadata('', 'WorkflowOutboundMessage', sobjectType));
        md.AddAll(API.listMetadata('', 'WorkflowTask', sobjectType));       
        for (API.FileProperties fp : md) {
            try {
                string fullname;
                string[] arrFullName = fp.fullName.split('\\.',2);                  
                string name=EncodingUtil.urlDecode(arrFullName[1],'UTF-8');
                metadata__c mL = new Metadata__c(
                    name                = (name.length()>80)?name.substring(0,80):name, 
                    parent__r           = new Metadata__c(FullName__c=arrFullname[0]),
                    recordTypeId        = RTYPE_LOGIC,
                    label__c            = name,
                    type__c             = 'WORKFLOW',
                    subtype__c          = fp.resultType,
                    FullName__c         = fp.fullName+'.'+fp.resultType,
                    ForceId__c          = fp.id,
                    Namespace__c        = fp.namespacePrefix,
                    LastModifiedBy__c   = fp.lastModifiedById,
                    lastModifiedDT__c   = fp.lastModifiedDate,
                    CreatedBy__c        = fp.CreatedById,
                    CreatedDT__c        = fp.CreatedDate
                    );
                rtn.add(mL);
            }
            catch(exception ex) {}
        }
        return  rtn;
    }
    
    */


global class ListMetadataInstruction {
    public string metadataType              {get; set;}     //metadata type
    public string folder                    {get; set;}     //folder / sobject used in metadata API listMetadata    
    public string delimeter                 {get; set;}     //if metadata type is a child object what symbol is used as a symbol
    
    
    //public string hasParent                   {get; set;}     //does this type have a parent
        //public boolean isFolderRequired
    //public boolean isFolderSupported
    //public boolean parentType
    //public integer parentArr  
    public ListMetadataInstruction(string mtype, string folder){
        this.metadataType=mtype;
        this.folder=folder;
        
        if (metadataType.EndsWith('Folder'))
            delimeter='/';
        else if (metadataType=='Layout')
            delimeter='-';
        else
            delimeter='.';
    }
}

public static LIST<ListMetadataInstruction> buildListMetadataInstructions() {
    LIST<ListMetadataInstruction> rtn = new LIST<ListMetadataInstruction>();
    boolean includeSharingRules = true;
    
    
    //test SET<string> GENERAL_MTYPES = new SET<string> { 'AnalyticSnapshot', 'ReportType'};
    
    for (string stdT : GENERAL_MTYPES) {
        rtn.add(new ListMetadataInstruction(stdT,null));
    }
    
    //SET<string> byObjectTypes = new SET<string>(); // { 'Weblink','FieldSet'};
    
    SET<string> stdObjectSharing = new SET<string> {'Account', 'Case', 'Opportunity', 'Contact', 'Campaign', 'Lead'};
    
    Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
    for (Schema.SObjectType sot : gd.values()) {
        Schema.Describesobjectresult DSR = sot.getDescribe(); 
        
        //user getKeyPrefix to filter backend objects _History, _Sharing, etc...
        if (DSR.getKeyPrefix()!=null) {
            string soname = DSR.getName();
            for (string boT : GENERAL_SOBJECT_MTYPES) {
                rtn.add(new ListMetadataInstruction(boT,soname ));
            }   
            
            
            //Sharing Rules...
            if (includeSharingRules) {
                if (DSR.isCustom()) {
                    //Only Custom Objects
                    rtn.add(new ListMetadataInstruction('CustomObjectCriteriaBasedSharingRule',soname));
                    rtn.add(new ListMetadataInstruction('CustomObjectOwnerSharingRule',soname));
                }
                else if (stdObjectSharing.contains(soname)) {
                    rtn.add(new ListMetadataInstruction(soname+'CriteriaBasedSharingRule',soname));
                    rtn.add(new ListMetadataInstruction(soname+'OwnerSharingRule',soname));         
                }
            }
            
        }
    }
 //[01172017] Merge&Spin: Added Test.isRunningTest() condition to avoid multiple executeBatch invocation in test run.   
    if(Test.isRunningTest()){
        LIST<ListMetadataInstruction> rtn1 = new LIST<ListMetadataInstruction>();
        rtn1.add(rtn[0]);
        return rtn1;
    }
    else
    return rtn;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////    
// inner classes  
////////////////////////////////////////////////////////////////////////////////////////////////////////////////    



public virtual class DescribeLayout {
        
        private dom.XmlNode root;

        //constructors
        public describeLayout(string aSObjectType) { this(aSObjectType, new SET<Id>{}); }
        public describeLayout(string aSObjectType, Id recordtypeId) { this(aSObjectType, new SET<Id>{ Util.IsBlank(recordtypeId) ? null : recordtypeId }); }
        public describeLayout(string aSObjectType, SET<Id> recordtypeIds) {
            root = api.describeLayout(aSObjectType,recordtypeIds).getRootElement().getChildElement('Body', API.NS_SOAP).getChildElement('describeLayoutResponse',API.NS_PARTNER);
        }
        
        
        public string XmlString {
            GET {
                return utilXmlNode.toXmlString(root);
            }
        }
        
        public MAP<id,RecordTypeMapping> getRecordTypeMappings() {
            MAP<id,RecordTypeMapping> rtn = new MAP<id,RecordTypeMapping>();
            if (root!=null) {
                dom.XmlNode rslt=root.getChildElement('result',API.NS_PARTNER);
                if (rslt!=null)
                for(dom.XmlNode e : rslt.getChildElements()) {
                    if (e.getName()=='recordTypeMappings') {
                        RecordTypeMapping rtm = new RecordTypeMapping(e);
                        //TES20110211 - be sure we got an Invalid id error
                        //TODO: determine if need to change id to MASTER RTYPE id if null
                        if (rtm.recordTypeId!=null) rtn.put(rtm.recordTypeId,rtm);
                    }   
                }
            }
            return rtn;
        }

        public MAP<Id,SET<string>> getlayoutFields()  {
            MAP<Id,SET<string>> rtn = new MAP<Id,SET<string>>();
            try {
                for(dom.XmlNode e : root.getChildElement('result',API.NS_PARTNER).getChildElements()) {
                    if (e.getName()=='layouts') {
                        string lid = e.getChildElement('id',API.NS_PARTNER).getText();
                        if (!rtn.containsKey(lid))
                            rtn.put(lid,new SET<string>());
                        for(utilXmlNode lce : new utilXmlNode(e).getElementsByTagName('layoutComponents')) {
                            if (lce.getValue('type')=='field')
                            rtn.get(lid).add(lce.getValue('value'));
                        }
                    }
                }
            } catch(exception ex) {}
            return rtn;
        }
        
        
        public MAP<Id,SET<string>> getlayoutFieldInfo()  {
            MAP<Id,SET<string>> rtn = new MAP<Id,SET<string>>();
            try {
                for(dom.XmlNode e : root.getChildElement('result',API.NS_PARTNER).getChildElements()) {
                    if (e.getName()=='layouts') {
                        string lid = e.getChildElement('id',API.NS_PARTNER).getText();
                        if (!rtn.containsKey(lid))
                            rtn.put(lid,new SET<string>());
                        for(utilXmlNode lce : new utilXmlNode(e).getElementsByTagName('layoutComponents')) {
                            if (lce.getValue('type')=='field')
                            rtn.get(lid).add(lce.getValue('value'));
                        }
                    }
                }
            } catch(exception ex) {}
            return rtn;
        }       


    //MAP<string,LIST<layoutSection>> (MAP<LayoutId,LIST<layoutSection>> )
    public MAP<string,LIST<layoutSection>> EditLayoutSections {
        GET{
            MAP<string,LIST<layoutSection>> rtn = new MAP<string,LIST<layoutSection>>(); //MAP<LayoutId,LIST<layoutSection>>
            try {
                for(dom.XmlNode e : root.getChildElement('result',API.NS_PARTNER).getChildElements()) {
                    if (e.getName()=='layouts') {
                        string lid = e.getChildElement('id',API.NS_PARTNER).getText();
                        if (!rtn.containsKey(lid))
                            rtn.put(lid,new LIST<layoutSection>());
                        integer sectionNum = 1;
                        for(dom.XmlNode els : e.getChildElements()) {
                            if (els.getName()=='editLayoutSections')
                                rtn.get(lid).add( new layoutSection(sectionNum++,els));
                        }
                    }
                }
            } catch(exception ex) {}
            return rtn;
        }   
    }   
}
    
////////////////////////////////////////////////////////////////////////////////////////////////////////////////    
    //node = single editLayoutSections or detailLayoutSections  
    public virtual class LayoutSection {
        public integer  index           {get; set;}
        public string   header          {get; set;}
        public LIST<LayoutItem> items   {get; set;}
        
        public layoutSection(integer idx, dom.XmlNode node) {
            index=idx;
            header = node.getChildElement('heading',API.NS_PARTNER).getText();
            integer row=1;
            items = new LIST<LayoutItem>();
            for(dom.XmlNode lr : node.getChildElements()) {
                if (lr.getName()=='layoutRows') {
                    integer col=1;
                    for(dom.XmlNode si : lr.getChildElements()) {
                        if (si.getName()=='layoutItems')
                            items.add(new LayoutItem(this,row,col++,si));
                    }
                    row++;
                }
            }       
        }
    }


    //node = single layoutComponents element
    public virtual class LayoutItem {
        public layoutSection        section     {get; set;}
        public integer              row         {get; set;}
        public integer              col         {get; set;}
        public integer              tabOrder    {get; set;}
        public string               name        {get; set;}
        public string               label       {get; set;}
        public string               itemType    {get; set;}
        public boolean              required    {get; set;}
        public boolean              editable    {get; set;}
        
        public LayoutItem(){}
        public LayoutItem(layoutSection s, integer r, integer c, dom.XmlNode node) {
            row=r;
            col=c;
            section=s;
            editable = Boolean.valueOf(node.getChildElement('editable',API.NS_PARTNER).getText());
            required = Boolean.valueOf(node.getChildElement('required',API.NS_PARTNER).getText());
            label = node.getChildElement('label',API.NS_PARTNER).getText();
            //TODO: now it just grab the first layoutComponents, detemine if we need to pull all
            // ex. ModifiedBy has three components {LastModifiedById, Seperator, LastModifedDate}
            for(dom.XmlNode lc : node.getChildElements()) {
                if (lc.getName()=='layoutComponents') {
                    name        = lc.getChildElement('value',API.NS_PARTNER).getText();
                    itemType    = lc.getChildElement('type',API.NS_PARTNER).getText();
                    tabOrder    = Integer.valueOf(lc.getChildElement('tabOrder',API.NS_PARTNER).getText());
                    break;
                }
            }
        }

    }       
////////////////////////////////////////////////////////////////////////////////////////////////////////////////    
        
    public virtual class RecordTypeMapping {
        public boolean available                                                {get; set;}
        public boolean defaultRecordTypeMapping                                 {get; set;}
        public Id layoutId                                                      {get; set;}
        public string name                                                      {get; set;}
        public MAP<string,MAP<string,picklistValues>> picklistsForRecordType    {get; set;}//<fieldname,Map<pickval,picklistValues>>        
        public Id recordTypeId                                                  {get; set;}

        //constructors
        public RecordTypeMapping() {}
        public RecordTypeMapping(dom.XmlNode node) {
            available = Boolean.valueOf(node.getChildElement('available',API.NS_PARTNER).getText());
            defaultRecordTypeMapping = Boolean.valueOf(node.getChildElement('defaultRecordTypeMapping',API.NS_PARTNER).getText());
            try {
                layoutId = node.getChildElement('layoutId',API.NS_PARTNER).getText();
            }catch(exception ex){system.debug(ex);}
            name = node.getChildElement('name',API.NS_PARTNER).getText();
            parsePickListValues(node);
            try {
                recordTypeId = node.getChildElement('recordTypeId',API.NS_PARTNER).getText();
            }catch(exception ex){system.debug(ex);}
        }
        
        private void parsePickListValues(dom.XmlNode node) {
            picklistsForRecordType = new MAP<string,MAP<string,picklistValues>>();
            for (dom.XmlNode fn : node.getChildElements()) {
                if (fn.getName()=='picklistsForRecordType') {
                    try {
                        string plname = fn.getChildElement('picklistName',API.NS_PARTNER).getText();
                        if (!picklistsForRecordType.containsKey(plname))
                            picklistsForRecordType.put(plname,new MAP<string,picklistValues>());
                        for (dom.XmlNode pln : fn.getChildElements()) {
                            if (pln.getName()=='picklistValues') {
                                PicklistValues pv = new PicklistValues(pln);
                                picklistsForRecordType.get(plname).put(pv.value,pv);
                            }
                        }
                    }
                    catch(Exception ex) {} //sometimes there are no picklists
                }
            }
        }
    }
    
////////////////////////////////////////////////////////////////////////////////////////////////////////////////    
    
    public class PicklistValues {
        public boolean active           {get; set;}
        public boolean defaultValue     {get; set;}
        public string label             {get; set;}
        public string value             {get; set;}
        
        //constructors
        public picklistValues() {}
        public picklistValues(dom.XmlNode node) {
            active = Boolean.valueOf(node.getChildElement('active',API.NS_PARTNER).getText());
            defaultValue = Boolean.valueOf(node.getChildElement('defaultValue',API.NS_PARTNER).getText());
            label = node.getChildElement('label',API.NS_PARTNER).getText();
            value = node.getChildElement('value',API.NS_PARTNER).getText(); 
            }
    }
////////////////////////////////////////////////////////////////////////////////////////////////////////////////    


    //Create exception handling for invalid fullnames
    public virtual class FullNameFactory {
        public string sobjectType       {get; private set;}
        public string DevName           {get; private set;}
    
        public FullNameFactory(string fname) {
            string[] arrFn = fname.split('\\.');
            sobjectType =(arrFn.size()>0) ? arrFn[0] : null;
            DevName     =(arrFn.size()>1) ? arrFn[1] : null;
        }
        public FullNameFactory(string obj, string devnm) {
            sobjectType=obj;
            DevName=devnm;
        }   
        public string FullName {GET{return sobjectType+'.'+DevName;}} 
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////    



    public static DMLResults RefreshConfig(string aSObjectType) {
        DmlResults rtn = new DmlResults();
        LIST<Metadata__c> metadata = new LIST<Metadata__c>();   
        //metadata.addAll(getMetadataValidationRulesViaAPI(aSObjectType));
        
        if (metadata.size()>0 && metadata.size()<=1000) 
            rtn.add(new DmlResults(database.upsert(metadata,Metadata__c.ForceId__c,false),metadata));
        else {
            //we need to chunk this (metadata.size()>1000) 
            LIST<Metadata__c> chunk = new LIST<Metadata__c>();
            for ( Metadata__c md : metadata ) {
                chunk.add(md);
                if (chunk.size()>=1000) {
                    rtn.add(new DmlResults(database.upsert(chunk,Metadata__c.ForceId__c,false),chunk));
                    chunk.clear();
                }
            }
            //flush
            if (chunk.size()>0)
                rtn.add(new DmlResults(database.upsert(chunk,Metadata__c.ForceId__c,false),chunk));
        }
        return rtn;     
    }


////////////////////////////////////////////////////////////////////////////////////////////////
// Metadata Deletion Logic
///////////////////////////////////////////////////////////////////////////////////////////////

    public static DmlResults processDeleteLayout() {
        DmlResults rtn = new DmlResults();
        LIST<Metadata__c> metadataToDelete = new LIST<Metadata__c>();
        metadataToDelete.addAll(ProcessDeletedMetadata(getMetadataRecordTypes(),'RECORDTYPE',null));    
        metadataToDelete.addAll(ProcessDeletedMetadata(getMetadataLayoutsViaAPI(),'LAYOUT',null));  
        rtn.add(new DmlResults(database.update(metadataToDelete,false),metadataToDelete));
        deleteMetadataItems();
        return rtn;
    }
    
    
    public static DmlResults processDeleteLogic() {
        DmlResults rtn = new DmlResults();
        LIST<Metadata__c> metadataToDelete = new LIST<Metadata__c>();
        metadataToDelete.addAll(ProcessDeletedMetadata(getMetadataApexClass(),'APEX_CODE','Class'));
        metadataToDelete.addAll(ProcessDeletedMetadata(getMetadataTriggers(),'APEX_CODE','Trigger'));
        metadataToDelete.addAll(ProcessDeletedMetadata(getMetadataVFPages(),'VISUALFORCE','Page'));
        metadataToDelete.addAll(ProcessDeletedMetadata(getMetadataVFComponents(),'VISUALFORCE','Component'));   
        rtn.add(new DmlResults(database.update(metadataToDelete,false),metadataToDelete));
        return rtn;
    }
    
    //SoftDelete child items to a deleted Sobject.
    //TODO:  have table (custom settings drive this logic 1 record for each metadata type)
    //Fields,  Trigger = do we softDelete all others (GENERAL_SOBJECT_MTYPES)?
    public static void processDeleteOrphanMetadataRecords() {
        try {
            string soql='SELECT Id, FullName__c, ForceId__c, IsDeleted__c from Metadata__c'; 
            soql+=' WHERE parent__r.type__c=\'SOBJECT\' AND parent__r.isDeleted__c=true AND isDeleted__c=false';
            system.schedule('Delete Orphan Metadata Records',utilSchedule.getSchedExprByDate(Datetime.Now().addSeconds(10)),new schedDeleteMetadata(soql,true));
        } catch(exception e){} //may already exist      
    }


    //deletes metadata items related to a soft (Isdeleted__c) metadata record
    // DONE - TODO: consider moving to batch as this has a limit of 10K per execution
    //@future  took this off since its now executed in the finish of the bacth job and throws an error
    public static void deleteMetadataItems() {
        try {
        system.schedule('Delete MetadataItems',utilSchedule.getSchedExprByDate(Datetime.Now().addSeconds(10)),new schedDeleteMetadata());
        } catch(exception e){}//may already exist
    }


    //fires job to deletes orphan picklists (no parent fields and marked missing picklist entries.
    public static void removeDeletedPicklists() {
        try {
            string soql='Select Id, Name, fActiveStatus__c, parent__r.name from Metadata__c where type__c=\'PICKLISTENTRY\' AND'; 
            soql+=' ((parent__c=null OR parent__r.isDeleted__c=true) OR (fActiveStatus__c=\'missing\'))';
            system.schedule('Delete Picklists',utilSchedule.getSchedExprByDate(Datetime.Now().addSeconds(10)),new schedDeleteMetadata(soql));
        } catch(exception e){} //may already exist
    }

    //This is Executed via batchRefreshMetadataFileProperties
    public static LIST<Metadata__c> ProcessDeletedMetadataByInstruction(LIST<Metadata__c> currMetadata,Metadata.ListMetadataInstruction instr) {
        LIST<Metadata__c> metadataToDelete = new LIST<Metadata__c>();
        if (currMetadata!=null && currMetadata.size()>0) {
            SET<String> forceIds = new SET<String>();
            for (Metadata__c m : currMetadata)
                forceIds.add(m.ForceId__c);
        
            if (Util.isBlank(instr.folder)==null) {
                metadataToDelete = [
                    Select Id, FullName__c, ForceId__c, IsDeleted__c 
                    from Metadata__c 
                    Where Type__c=:instr.metadataType AND IsDeleted__c=false
                        AND ForceId__c not in: forceIds];
            }
            else {
                metadataToDelete = [
                    Select Id, FullName__c, ForceId__c, IsDeleted__c 
                    from Metadata__c 
                    Where Type__c=:instr.metadataType AND Parent__r.Fullname__c=:instr.folder  AND IsDeleted__c=false
                        AND ForceId__c not in: forceIds];
            }
            
            Database.DMLOptions dml = new Database.DMLOptions();
            dml.allowFieldTruncation = true;
            for (Metadata__c m : metadataToDelete) {
                setMetadataToIsDeleted(m);
                m.setOptions(dml);
            }
        }
        return metadataToDelete;
    }

    public static LIST<Metadata__c> ProcessDeletedMetadata(LIST<Metadata__c> currMetadata,string mtype,string msubtype) {
        LIST<Metadata__c> metadataToDelete = new LIST<Metadata__c>();
        if (currMetadata!=null && currMetadata.size()>0) {
            SET<String> forceIds = new SET<String>();
            for (Metadata__c m : currMetadata)
                forceIds.add(m.ForceId__c);
        
            if (msubtype==null) {
                metadataToDelete = [
                    Select Id, FullName__c, ForceId__c, IsDeleted__c 
                    from Metadata__c 
                    Where Type__c=:mtype AND IsDeleted__c=false
                        AND ForceId__c not in: forceIds];
            }
            else {
                metadataToDelete = [
                    Select Id, FullName__c, ForceId__c, IsDeleted__c 
                    from Metadata__c 
                    Where Type__c=:mtype AND subtype__c=:msubtype  AND IsDeleted__c=false
                        AND ForceId__c not in: forceIds];
            }
            
            Database.DMLOptions dml = new Database.DMLOptions();
            dml.allowFieldTruncation = true;
            for (Metadata__c m : metadataToDelete) {
                setMetadataToIsDeleted(m);
                m.setOptions(dml);
            }
        }
        return metadataToDelete;
    }

    public static void setMetadataToIsDeleted(Metadata__c m) {
        if (m.FullName__c!=null && !m.FullName__c.startsWith(DELETE_PREFIX))
            m.FullName__c=DELETE_PREFIX+m.FullName__c;
        if (m.ForceId__c!=null && !m.ForceId__c.startsWith(DELETE_PREFIX))
            m.ForceId__c=DELETE_PREFIX+m.ForceId__c;
        m.IsDeleted__c=true;
    }


////////////////////////////////////////////////////////////////////////////////////////////////

}