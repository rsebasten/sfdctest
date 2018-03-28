/*******************************************************************************
Copyright © 2016 DuPont. All rights reserved. 
Author: Abhinav Bhatnagar
Email: abhinav.bhatnagar@dupont.com
Description:  Controller class for AUAReviewPage
//AB20160826 - Changes made to add Program as additional filter
//AB20161103 - 1. User should not be able to review his/her record
//        2. Search capability added
//AB20161129 - 1. Added Search capability for profiles and roles
//AB20161213 - Updated to avoid test failure
//AB20161227 - Updated for UAR enhancements
//1.  Text filters by Role, Profile (may actually be done with the name search that Abhinav is currently doing)
//2.  Grid Improvements - Keep the header in place when scrolling (Deferred)
//3.  Verify if Column Picker is used or if that could be removed to allow for more screen real estate.
//4.  Record Count improvements - have the count change based on the # of records returned with the filters (not just their overall total records to be reviewed)
//5.  Add Lookup to CRM IT Project on the UAR object.  TCS could then attach the yearly UAR CRM IT Project to the header record.  Then attach that CRM IT Project to all SFARs that are created from this process (this would make for an easy way to monitor all SFARs created from this process)
//6.  NOT REQUIRED NOW --- Add ability to re-assign Approving Business (this may not be needed when new Orgs are created as this will be easier to manage)
//7.  Deactivation email - show the correct Org (currently it always shows OneDuPont)

********************************************************************************/
public  class ctrlAUAReviewPage {
    List<schema.sobjecttype> sOname;
    private integer counter=0;  //keeps track of the offset
    private Map<String, AUA_PGABMapping__C> mapOfCustomSettings;  
    private LIST<String> approvingBusinesses{set;get;}  
    public  List<SelectOption> options;
    public  List<SelectOption> PageASOptionsFilter { get; set; }
    public  List<SelectOption> PageASOptionsSL { get; set; }
    public  List<SelectOption> PageCntryOptionsFilter { get; set; }
    public  List<SelectOption> PageOptions { get; set; }
    public  List<SelectOption> PageOwnOrgOptionsFilter { get; set; }
    public  List<SelectOption> PageOwnSBUOrgOptionsFilter { get; set; }
    public  List<SelectOption> PageRgnOptionsFilter { get; set; }
    public  List<SelectOption> PageSFDCInstOptionsFilter { get; set; }
    public  List<SelectOption> PageUsrOptionsFilter { get; set; }
    public  List<SelectOption> PageUsrLicenseOptionsFilter { get; set; }
    public  List<SelectOption> PageProgOptionsFilter { get; set; }//AB20160826 
    public  List<SelectOption> PageSearchFieldOptionsFilter { get; set; } //AB20161103
    public  List<SelectOption> PageSearchOprOptionsFilter { get; set; } //AB20161103
    public Id changedRecId { get; set; }
    
    public integer list_size{set;get;} //sets the page size or number of rows
    public Integer noOfRecords{set;get;}
    // public Integer total_size; //used to show user the total size of the list //AB20161227
    private Integer MAXROWS{set;get;}
    
    public List<columsdata> columnLabels{ get; set; }
    public List<sObject> ObjectList{get;set;}
    public List<String> regionList{set;get;}
    public List<User_Access_Review_Details__c> uards{get;set;}
    
    public Map<Id,User_Access_Review_Details__c> ChangedObjectMap{get;set;}
    public Map<String,LIST<String>> regionCountryMap;
    public Map<string,schema.sobjecttype> allobject;
    public Map<string,string> fieldsMap;
    public Map<string,string> finalmap;
    public Map<integer,List<String>> colsMasterList{get;set;}
    
    public SelectOption[] SizeOptions { get; set; }
    
    public Set<String> PageCntrySetFilter{ get; set; }
    public Set<String> PageOwnOrgSetFilter{ get; set; }
    public Set<String> PageOwnSBUOrgSetFilter{ get; set; }
    public Set<String> PageRgnSetFilter{ get; set; }
    public Set<String> PageSFDCInstSetFilter{ get; set; }
    public Set<String> PageUsrSetFilter{ get; set; }
    public Set<String> PageUsrLicenseSetFilter{ get; set; }
    public Set<String> PageProgSetFilter{ get; set; }//AB20160826 
    public Set<String> PageSearchFieldSetFilter{ get; set; }//AB20161103 
    public Set<String> PageSearchOprSetFilter{ get; set; }//AB20161103 
    
    public String apiname{get;set;}
    public String changedAS { get; set; }
    public String isDisabled { get; set; }
    public String isListShow { get; set; }
    public string oname{set;get;}
    public string pagevalueParam {set;get;}
    public string query{get;set;}
    public string rmode{get; set;}
    public String rmode2 { get; set; }
    public String showASpage { get; set; }
    public String showCntrypage { get; set; }
    public String showOwnOrgpage { get; set; }
    public String showOwnSBUOrgpage { get; set; }
    public String showpage { get; set; }
    public String showRgnpage { get; set; }
    public String showSFDCInstpage { get; set; }
    public String showUsrpage { get; set; }
    public String showUsrTypepage { get; set; }
    public String sortbyField { get; set; }
    public String sortDirection{ get; set; }
    public String showProgpage { get; set; }//AB20160826 
    public String showSearchFieldpage { get; set; }//AB20161103 
    public String showSearchOprpage { get; set; }//AB20161103 
    public String showSearchKeyWord { get; set; }//AB20161103 
    
    public string[] finalsFields{get;set;}
    public String[] sfields { get; set; }
    
    public User_Access_Review__c uar{set;get;}
    string fullquery = '';
    
    public Date Today { get { return Date.today(); }}
    
    private static final String COMMADELIMITER = ',';
    private static final String SEMICOLONDELIMITER = ';';
    private static final String BLANK = '';
    private static final String SPACE = ' ';
    private static final String DOUBLEQUOTES = '"';
    private static final integer LISTMAXSIZE = 50;
    private static final integer MAXRECORDS = 50;
    private static final String YES = 'true';
    private static final String NO = 'false';
    private static final String ASCENDING = 'ASC';
    private static final String DESCENDING = 'DESC';
    private static final String NOTREVIEWED = 'Not Reviewed';
    private static final String MODIFY = 'Modify';
    private static final String DEACTIVATE = 'De-Activate';
    private static final String APPROVED = 'Approved';
    private static final String ALL = 'All';
    private static final String UNDEFINED = 'Undefined';
    private static final String REVIEWOBJAPINAME = 'User_Access_Review__c';
    private static final String REVIEWOBJLABEL = 'User Access Review';
    private static final String DETAILOBJAPINAME = 'User_Access_Review_Details__c';
    private static final String DETAILOBJLABEL = 'User Access Review Details';
    private static final String RECORDSDELIMITER = ';;';//AB20161227
    private static final String FIELDSDELIMITER = '@@';//AB20161227
    
    public ctrlAUAReviewPage(){
        
        list_size = LISTMAXSIZE;
        MAXROWS = Limits.getLimitQueryRows();        
        fieldsMap = new Map<string,string>(); 
        approvingBusinesses = new List<String>();
        SizeOptions = new SelectOption[]{};
            for(integer pageSize = 10;pageSize<=LISTMAXSIZE; pageSize = pageSize+10){
                SizeOptions.add(new SelectOption(String.valueOf(pageSize) ,String.valueOf(pageSize)));
            }
        
        colsMasterList = new Map<integer, List<String>>();
        setMasterList();
        options = new List<SelectOption>();
        PageOptions  =  new List<SelectOption>();
        PageASOptionsFilter  =  new List<SelectOption>();
        PageASOptionsSL  =  new List<SelectOption>();
        PageCntryOptionsFilter  =  new List<SelectOption>();
        PageRgnOptionsFilter  =  new List<SelectOption>();
        PageUsrOptionsFilter  =  new List<SelectOption>();
        PageUsrLicenseOptionsFilter  =  new List<SelectOption>();
        PageOwnOrgOptionsFilter  =  new List<SelectOption>();
        PageOwnSBUOrgOptionsFilter  =  new List<SelectOption>();
        PageSFDCInstOptionsFilter  =  new List<SelectOption>();
        PageProgOptionsFilter  =  new List<SelectOption>();//AB20160826 
        PageSearchFieldOptionsFilter  =  new List<SelectOption>(); //AB20161103
        PageSearchOprOptionsFilter  =  new List<SelectOption>(); //AB20161103
        
        PageCntrySetFilter = new Set<String>();
        PageRgnSetFilter = new Set<String>();
        PageUsrSetFilter = new Set<String>();
        PageUsrLicenseSetFilter = new Set<String>();
        PageOwnOrgSetFilter = new Set<String>();
        PageOwnSBUOrgSetFilter = new Set<String>();
        PageSFDCInstSetFilter = new Set<String>();
        PageProgSetFilter = new Set<String>();//AB20160826 
        PageSearchFieldSetFilter = new Set<String>();//AB20161103
        PageSearchOprSetFilter = new Set<String>();//AB20161103
        
        isListShow =NO;
        isDisabled =NO;
        sortDirection=BLANK;
        sfields = new List<string>();
        columnLabels = new List<columsdata>();
        ObjectList = new List<sobject>();
        
        finalmap= new Map<string,string>();
        ChangedObjectMap = new Map<Id,User_Access_Review_Details__c>();
        finalmap.put(Schema.describeSObjects(new String[]{REVIEWOBJAPINAME})[0].getLabel(),Schema.describeSObjects(new String[]{REVIEWOBJAPINAME})[0].getName());
        finalmap.put(Schema.describeSObjects(new String[]{DETAILOBJAPINAME})[0].getLabel(),Schema.describeSObjects(new String[]{DETAILOBJAPINAME})[0].getName());
        regionCountryMap = new Map<String,List<string>>();
        getRegionCountry();
        
        regionList = new List<String>();
        
        uar = [Select CreatedById,CreatedDate,Id,Name,OwnerId,Process_Owner__c,Snapshot_Date__c,Snapshot_Status__c,Snapshot_Taken_By__c,Start_Date__c,End_Date__c from User_Access_Review__c where id=:apexpages.currentpage().getparameters().get('Id') LIMIT :MAXROWS];
        
        getUserType(); 
        getUserLicenseType(); 
        getOwningOrg();        
        getOwningSBUOrg();        
        getSFDCInst();
        getProgram();//AB20160826 
        getSearchableFields();//AB20161103 
        getSearchableOpr();//AB20161103
    }
    
    public void setMasterList(){
        colsMasterList.clear();
        colsMasterList.put(1, new List<String>{'Approval__c','Approval Status','M'});
        colsMasterList.put(2, new List<String>{'Approver__c','Approver','O'});
        colsMasterList.put(3, new List<String>{'Review_Date__c','Review Date','O'}); 
        colsMasterList.put(4, new List<String>{'Name','Name','M'});
        colsMasterList.put(5, new List<String>{'User_ePass_Id__c','ePass Id','O'});        
        colsMasterList.put(6, new List<String>{'User_Last_Login__c','Last Login','O'});
        colsMasterList.put(7, new List<String>{'User_Profile__c','Profile','M'});
        colsMasterList.put(8, new List<String>{'User_Roles__c','Role','M'});
        colsMasterList.put(9, new List<String>{'User_Permission_Sets__c','Permission Set','M'});
        colsMasterList.put(10, new List<String>{'User_Public_Group__c','Public Group','M'});
        colsMasterList.put(11, new List<String>{'Org__c','Org','M'});        
        colsMasterList.put(12, new List<String>{'User_Region__c','Region','O'});
        colsMasterList.put(13, new List<String>{'User_Country__c','Country','O'});
        colsMasterList.put(14, new List<String>{'CompanyName__c','Company Name','O'});
        colsMasterList.put(15, new List<String>{'User_Owning_SBU_Org__c','Owning SBU Org','O'});
        colsMasterList.put(16, new List<String>{'User_Owning_Org__c','Owning Org','O'});
        colsMasterList.put(17, new List<String>{'Program__c','Program','O'});
        colsMasterList.put(18, new List<String>{'User_Name__c','User Name','O'});
        colsMasterList.put(19, new List<String>{'User_Email_Id__c','Email','O'});
        colsMasterList.put(20, new List<String>{'Approving_Business__c','Approving Business','O'});
        colsMasterList.put(21, new List<String>{'User_Access_Type__c','Access Type','O'});
        colsMasterList.put(22, new List<String>{'User_Type__c','User Type','O'});
        colsMasterList.put(23, new List<String>{'Description__c','Description','O'});
        colsMasterList.put(24, new List<String>{'User_Id__c','User Id','O'}); 
        colsMasterList.put(25, new List<String>{'Id','Record Id','O'});
    }
    
    public void setColumnLabels(){
        //  columnLabels.add(new columsdata('Actions','Approval__c') );
        List<String> s = new List<String>();
        integer sfieldsCount  = 0;
        
        /*  for(string fieldname : sfields)  {

columnLabels.add(new columsdata(fieldsMap.get(fieldname),fieldname));
}*/    
        columnLabels.clear();
        integer iCount = 1;
        while( iCount<= colsMasterList.size()){
            List<String> masterlist = colsMasterList.get(iCount);
            if(masterList.get(2).equalsIgnorecase('M')){
                columnLabels.add(new columsdata(masterList.get(1),masterList.get(0)));
            }else if(sfieldsCount<sfields.size() && sfields[sfieldsCount].equalsIgnoreCase(masterList.get(0))){
                columnLabels.add(new columsdata(masterList.get(1),masterList.get(0)));
                sfieldsCount++;
            }
            
            iCount++;
        }
        
    }
    
    //method to generate table of selected object and selected field of this object
    public void ShowTable(){  
        
        if(sfields.size()>0 ) {
            
            setColumnLabels();// To handle selection and mandatory column order
            
            isDisabled = YES;
            query = 'Select Id ' ;  
            for(String field : sfields) {  
                if(field.toLowerCase() != 'id' && field.toLowerCase() != '--none--')  {
                    query += COMMADELIMITER + field + SPACE ;  
                }
            } 
            fullquery  = query+' from '+apiname;
            if(sortbyField !=null) {
                getUserAccessReviewDetails(sortbyField, sortDirection);
            }else {
                getUserAccessReviewDetails(BLANK, BLANK);
            }
            
            ObjectList = uards;
            //  total_size = [select count() from User_Access_Review_Details__c where Approving_Business__c in :approvingBusinesses AND  Audit_Process__c = :apexpages.currentpage().getparameters().get('Id')];//AB20161227
            Integer totalPages = getTotalPages();
            PageOptions.clear();
            PageASOptionsFilter.clear();
            
            PageASOptionsFilter.add(new SelectOption(ALL,ALL));
            PageASOptionsFilter.add(new SelectOption(NOTREVIEWED,NOTREVIEWED));            
            PageASOptionsFilter.add(new SelectOption(MODIFY,MODIFY));
            PageASOptionsFilter.add(new SelectOption(DEACTIVATE,DEACTIVATE)); 
            PageASOptionsFilter.add(new SelectOption(APPROVED,APPROVED));
            
            PageASOptionsSL.clear();
            
            PageASOptionsSL.add(new SelectOption(NOTREVIEWED,NOTREVIEWED));            
            PageASOptionsSL.add(new SelectOption(MODIFY,MODIFY));
            PageASOptionsSL.add(new SelectOption(DEACTIVATE,DEACTIVATE));
            PageASOptionsSL.add(new SelectOption(APPROVED,APPROVED));
            
            PageCntrySetFilter.clear();
            
            PageRgnSetFilter.addall(getRegion());
            PageCntrySetFilter.addall(getCountriesOfSelectedRegion());
            
            PageCntryOptionsFilter.clear();     
            PageCntryOptionsFilter.add(new SelectOption(ALL,ALL));
            for(String strCntrySetFilter:PageCntrySetFilter){
                if(strCntrySetFilter!=null && strCntrySetFilter!=''){
                    PageCntryOptionsFilter.add(new SelectOption(strCntrySetFilter,strCntrySetFilter));
                }
            }
            
            
            PageRgnOptionsFilter.clear();
            PageRgnOptionsFilter.add(new SelectOption(ALL,ALL));
            for(String strRgnSetFilter:PageRgnSetFilter) {
                if(strRgnSetFilter!=null && strRgnSetFilter!=''){
                    PageRgnOptionsFilter.add(new SelectOption(strRgnSetFilter,strRgnSetFilter));
                }
            }
            
            PageUsrOptionsFilter.clear();     
            PageUsrOptionsFilter.add(new SelectOption(ALL,ALL));            
            for(String strUsrSetFilter:PageUsrSetFilter) {                
                PageUsrOptionsFilter.add(new SelectOption(strUsrSetFilter==null?UNDEFINED:strUsrSetFilter,strUsrSetFilter==null?UNDEFINED:strUsrSetFilter));
            }
            
            PageUsrLicenseOptionsFilter.clear();     
            PageUsrLicenseOptionsFilter.add(new SelectOption(ALL,ALL));            
            for(String strUsrLicenseSetFilter:PageUsrLicenseSetFilter) {                
                PageUsrLicenseOptionsFilter.add(new SelectOption(strUsrLicenseSetFilter==null?UNDEFINED:strUsrLicenseSetFilter,strUsrLicenseSetFilter==null?UNDEFINED:strUsrLicenseSetFilter));
            }
            
            
            
            PageOwnOrgOptionsFilter.clear();     
            PageOwnOrgOptionsFilter.add(new SelectOption(ALL,ALL));
            for(String strOwnOrgSetFilter:PageOwnOrgSetFilter){                
                if(strOwnOrgSetFilter!=null && strOwnOrgSetFilter!=''){
                    PageOwnOrgOptionsFilter.add(new SelectOption(strOwnOrgSetFilter,strOwnOrgSetFilter));
                }
            }
            
            PageOwnSBUOrgOptionsFilter.clear();     
            PageOwnSBUOrgOptionsFilter.add(new SelectOption(ALL,ALL));
            for(String strOwnSBUOrgSetFilter:PageOwnSBUOrgSetFilter) {
                if(strOwnSBUOrgSetFilter!=null && strOwnSBUOrgSetFilter!=''){
                    PageOwnSBUOrgOptionsFilter.add(new SelectOption(strOwnSBUOrgSetFilter,strOwnSBUOrgSetFilter));
                }
            }            
            PageSFDCInstOptionsFilter.clear();     
            PageSFDCInstOptionsFilter.add(new SelectOption(ALL,ALL));
            for(String strSFDCInstSetFilter:PageSFDCInstSetFilter) {
                if(strSFDCInstSetFilter!=null && strSFDCInstSetFilter!=''){
                    PageSFDCInstOptionsFilter.add(new SelectOption(strSFDCInstSetFilter,strSFDCInstSetFilter));
                }
            }            
            //AB20160826  Start
            PageProgOptionsFilter.clear();     
            PageProgOptionsFilter.add(new SelectOption(ALL,ALL));
            for(String strProgSetFilter:PageProgSetFilter) {
                if(strProgSetFilter!=null && strProgSetFilter!=''){
                    PageProgOptionsFilter.add(new SelectOption(strProgSetFilter,strProgSetFilter));
                }    
            } 
            //AB20160826 End
            //AB20161103  Start
            PageSearchFieldOptionsFilter.clear();     
            //PageSearchOptionsFilter.add(new SelectOption(ALL,ALL));
            for(String strSearchFieldSetFilter:PageSearchFieldSetFilter) {
                if(strSearchFieldSetFilter!=null && strSearchFieldSetFilter!=''){
                    PageSearchFieldOptionsFilter.add(new SelectOption(strSearchFieldSetFilter,strSearchFieldSetFilter));
                }    
            } 
            //AB20161103 End
            //AB20161103  Start
            PageSearchOprOptionsFilter.clear();     
            //PageSearchOptionsFilter.add(new SelectOption(ALL,ALL));
            for(String strSearchOprSetFilter:PageSearchOprSetFilter) {
                if(strSearchOprSetFilter!=null && strSearchOprSetFilter!=''){
                    PageSearchOprOptionsFilter.add(new SelectOption(strSearchOprSetFilter,strSearchOprSetFilter));
                }    
            } 
            //AB20161103 End
            
            for(Integer i=1;i<=totalPages;i++) {
                PageOptions.add(new SelectOption(i+BLANK,i+BLANK));
            }
        }  else{
            isDisabled = NO;    
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'No Field selected');            
            ApexPages.addMessage(myMsg);
        } 
    }
    //methods to generate field list of selected object
    public void showfields() {
        
        isListShow = YES;
        isDisabled = NO;
        options.clear();
        apiname= finalmap.get(DETAILOBJLABEL); 
        // total_size =Database.countQuery('SELECT COUNT() FROM '+apiname+' where Approving_Business__c in ('+getApprovingBusiness()+')  AND Audit_Process__c =\''+apexpages.currentpage().getparameters().get('Id')+'\' AND User_Id__c !=\''+UserInfo.getUserId()+'\'' ); 
        
        // options.add(new SelectOption('Approval__c','Approval Status'));
        options.add(new SelectOption('Approver__c','Approver'));
        options.add(new SelectOption('Review_Date__c','Review Date')); 
        // options.add(new SelectOption('Name','Name'));
        options.add(new SelectOption('User_ePass_Id__c','ePass Id'));        
        options.add(new SelectOption('User_Last_Login__c','Last Login'));                
        //options.add(new SelectOption('User_Profile__c','Profile'));
        //  options.add(new SelectOption('User_Roles__c','Role'));
        //options.add(new SelectOption('User_Permission_Sets__c','Permission Set'));
        //options.add(new SelectOption('User_Public_Group__c','Public Group'));
        //options.add(new SelectOption('Org__c','Org'));        
        options.add(new SelectOption('User_Region__c','Region'));
        options.add(new SelectOption('User_Country__c','Country'));
        options.add(new SelectOption('CompanyName__c','Company Name'));
        options.add(new SelectOption('User_Owning_SBU_Org__c','Owning SBU Org'));
        options.add(new SelectOption('User_Owning_Org__c','Owning Org'));
        options.add(new SelectOption('Program__c','Program'));
        options.add(new SelectOption('User_Name__c','User Name'));
        options.add(new SelectOption('User_Email_Id__c','Email'));
        options.add(new SelectOption('Approving_Business__c','Approving Business'));
        options.add(new SelectOption('User_Access_Type__c','Access Type'));
        options.add(new SelectOption('User_Type__c','User Type'));
        options.add(new SelectOption('Description__c','Description'));        
        options.add(new SelectOption('User_Id__c','User Id')); 
        options.add(new SelectOption('Id','Record Id'));
        
        //options.add(new SelectOption('User_Type__c','Type'));
        //options.add(new SelectOption('User_Grouping__c','Grouping'));
        
        for(SelectOption so:options){
            fieldsMap.put(so.getValue(), so.getLabel());
        }
        
    }
    //method to get fields of selected object
    public List<SelectOption> getFields() {
        return options;
    }
    //property to get available object i organization
    public String myList { get{
        isDisabled = NO;
        sfields.clear();
        options.clear();
        objectList.clear();
        String mylist = BLANK;        
        
        for(string name : finalmap.keyset()){            
            mylist = mylist+DOUBLEQUOTES+name+DOUBLEQUOTES+COMMADELIMITER;
        }
        return mylist;
    } set; }
    
    public PageReference refreshTable() {
        try{
            String actionSource = Apexpages.Currentpage().getParameters().get('callingFrom');
            actionSource = actionSource!=null?actionSource:BLANK;
            
            if(actionSource.equalsIgnoreCase('Beginning')){
                counter = 0;               
            }else if(actionSource.equalsIgnoreCase('Previous')){
                counter -= list_size;
            }else if(actionSource.equalsIgnoreCase('Next')){
                ShowTable();
                counter += list_size;               
            }else if(actionSource.equalsIgnoreCase('End')){
                counter = noOfRecords - math.mod(noOfRecords, list_size);//AB20161227
            }else if(actionSource.equalsIgnoreCase('changePage')){
                counter = (integer.valueOf(showpage )-1)*list_size;
            }else if(actionSource.equalsIgnoreCase('showRecords')){
                sortbyField=null; 
                sfields = finalsFields.clone();
            } //No special handling required changelist_size, changeASPage, changeCntryPage, changeRgnPage, changeUserTypePage, changeUsrPage, changeOwnOrgPage, changeOwnSBUOrgPage, changeSFDCInstPage
            ShowTable();
            return null;
        }catch(Exception e){
            System.debug('Exception occured during table refresh.'+e.getStackTraceString());
            
        }
        return null;
    }
    
    //method to check and disable start and previous button according to counter value 
    public Boolean getDisablePrevious() {
        if (counter>0) return false; else return true;
    }
    //method to check and disable next and end button according to counter value 
    public Boolean getDisableNext() { 
        if (counter + list_size < noOfRecords) return false; else return true;//AB20161227
    }
    //method to get no of records
    public Integer getTotal_size() {
        return noOfRecords;//AB20161227
    }
    //method to get current visible page no  among all available pages of records
    public Integer getPageNumber() {
        return counter/list_size + 1;
    }
    //method to get total page of records according to preffered list size
    public Integer getTotalPages() {
        integer allowedLimit = MAXRECORDS;
        integer ts = noOfRecords>allowedLimit?allowedLimit:noOfRecords;//AB20161227
        if (math.mod(ts, list_size) > 0) {
            return ts/list_size + 1;
        }
        else {
            return (ts/list_size);
        }
    }
    
    
    //method to sort table by specified field
    public void sortTable() {
        if(sortbyField == null  || sortbyField != apexpages.currentpage().getparameters().get('sortfield') ){            
            sortDirection = ASCENDING;
        }else{
            if(sortDirection.equals(ASCENDING)){
                sortDirection = DESCENDING;
                
            }else{
                sortDirection = ASCENDING;
            }
        }
        sortbyField = apexpages.currentpage().getparameters().get('sortfield');
        ShowTable();
    }
    
    public PageReference save() {
        try{
            PageReference p = new PageReference ('/apex/AUAConfirmationPage');
            p.getParameters().put('changedAs',changedAs);  
            p.getParameters().put('uarid',uar.id);  
            p.setRedirect(true);        
            return p;
        }catch(Exception e){
            System.debug('Exception Occured while saving');
            e.getStackTraceString();
            return null;
        }
    }
    
    public PageReference cancel() {        
        return null;        
    }    
    
    //wrapper class having name and label of selected fields of selected object  
    public class columsdata{
        public string name;
        public string label;
        
        public columsdata(string label, string name){            
            this.name = name;
            this.label = label;
        }
        
        public string getName(){
            return name;
        }
        
        public string getLabel(){
            return label;
        }
    }
    
    public void getUserAccessReviewDetails(String orderByField, String orderDirection){
        mapOfCustomSettings = AUA_PGABMapping__C.getAll();
        List<GroupMember> UserMemOfGrps = [SELECT GroupId  FROM GroupMember where UserOrGroupId=: userinfo.getUserId() LIMIT :MAXROWS ];
        List<Id> grpIds = new List<Id> ();
        for(GroupMember grpId:UserMemofGrps){
            grpIds.add(grpId.GroupId);
        }
        
        List<Group> publicGroups = [SELECT CreatedById,CreatedDate,DeveloperName,DoesIncludeBosses,DoesSendEmailToMembers,Email,Id,LastModifiedById,LastModifiedDate,Name,OwnerId,RelatedId,SystemModstamp,Type FROM Group WHERE  Type ='Regular' AND id in : grpIds AND Name in :mapOfCustomSettings.keySet() LIMIT :MAXROWS];
        approvingBusinesses = new LIST<String>();
        for(Group pg: publicGroups){
            String ab = mapOfCustomSettings.get(pg.Name).Approving_Business__c;
            if(ab.contains(COMMADELIMITER)){
                String []abs = ab.split(COMMADELIMITER);
                for(String abtoken: abs){
                    approvingBusinesses.add(abtoken.trim());
                }
            }else{
                approvingBusinesses.add(ab.trim());
            }
            
        }
        
        
        uards = Database.query(getQuery(orderByField, orderDirection));
        noOfRecords = Database.countQuery(getCountQuery());     //AB20161227 
    }
    
    //AB20161227 Start
    public string getCountQuery(){
        String strQuery =BLANK;
        String strSelectCountClause = 'SELECT count()  FROM User_Access_Review_Details__c  ';
        String strWhereClause = getWhereClause();
        strQuery = strSelectCountClause + strWhereClause;
  return strQuery;
    }
    //AB20161227 End
    
    public String getQuery(String orderByField, String orderDirection ){
        String strSelectClause = 'SELECT CompanyName__c,User_Access_Type__c,User_Last_Login__c,Program__c,User_Owning_Org__c ,User_Owning_SBU_Org__c,Approval__c,Approver__c,Audit_Process__c,Review_Date__c,Id,Name,Org__c,User_Email_Id__c,User_ePass_Id__c,User_Id__c,User_Name__c,User_Permission_Sets__c,User_Profile__c,User_Public_Group__c,User_Roles__c,User_Type__c,User_Grouping__C,Approving_Business__c,User_Country__c, User_Region__c, Description__c FROM User_Access_Review_Details__c ';
        
        String strOrderByClause = 'ORDER BY ';
        String strLimitClause = ' LIMIT ';
        String strOffsetClause = ' OFFSET ';
        String strQuery =BLANK;
        
        strQuery = strSelectClause+getWhereClause();
        if(orderByField!=BLANK){
            strQuery = strQuery + strOrderByClause+orderByField+SPACE+orderDirection+' NULLS LAST ';
        }
        strQuery = strQuery + strLimitClause + list_size;
        strQuery = strQuery + strOffsetClause + counter;
        System.debug('strQuery====strQuery======>>>>>>>>. '+strQuery);
        return strQuery;
    }
    
    public String getWhereClause(){
        String strWhereClause = 'WHERE ';
        String strApprovingBusiness =getApprovingBusiness();//AB20161213
        strApprovingBusiness = (strApprovingBusiness!=null && strApprovingBusiness!='')?' Approving_Business__c in ('+strApprovingBusiness+') AND ':'';//AB20161213
        //AB20161103 Start
        strWhereClause = strWhereClause +strApprovingBusiness+' Audit_Process__c =\''+apexpages.currentpage().getparameters().get('Id')+ '\' ' ;//AB20161213
        strWhereClause = strWhereClause + ' AND User_Id__c != \''+UserInfo.getUserId()+'\''+ ' AND User_Email_Id__c != \''+UserInfo.getUserEmail()+'\''+ ' AND User_ePass_Id__c != \''+[Select EPass_ID__c from user where id=:Userinfo.getUserId() LIMIT 1].EPass_ID__c+'\' ';//Approver should not be able to view his/her data
        
        //AB20161103
        if(showASpage!=null && showASpage!=ALL){
            strWhereClause = strWhereClause + ' AND Approval__c=\''+showASpage+'\' ';
        }
        
        if(showCntrypage!=null && showCntrypage!=ALL){
            strWhereClause = strWhereClause + ' AND User_Country__c=\''+showCntrypage+'\' ';
        }
        
        if(showRgnpage!=null && showRgnpage!=ALL){
            strWhereClause = strWhereClause + ' AND User_Region__c=\''+showRgnpage+'\' ';
        }
        
        if(showUsrpage!=null && showUsrpage!=ALL){
            strWhereClause = (strWhereClause + ' AND User_Access_Type__c=\'')+(showUsrpage=='Undefined'?BLANK:showUsrpage)+'\' ';            
        }
        
        if(showUsrTypepage!=null && showUsrTypepage!=ALL){
            strWhereClause = (strWhereClause + ' AND User_Type__c=\'')+(showUsrTypepage=='Undefined'?BLANK:showUsrTypepage)+'\' ';            
        }
        
        if(showOwnOrgpage!=null && showOwnOrgpage!=ALL){
            strWhereClause = strWhereClause + ' AND User_Owning_Org__c=\''+showOwnOrgpage+'\' ';
        }
        
        if(showOwnSBUOrgpage!=null && showOwnSBUOrgpage!=ALL){
            strWhereClause = strWhereClause + ' AND User_Owning_SBU_Org__c=\''+showOwnSBUOrgpage+'\' ';
        }
        
        if(showSFDCInstpage!=null && showSFDCInstpage!=ALL){
            strWhereClause = strWhereClause + ' AND Org__c=\''+showSFDCInstpage+'\' ';
        }
        
        //AB20160826 Start
        if(showProgpage!=null && showProgpage!=ALL){
            strWhereClause = strWhereClause + ' AND Program__c=\''+showProgpage+'\' ';
        }
        //AB20160826 End
        strWhereClause = getSearchWhereClause(strWhereClause);
        
        return strWhereClause;
    }
    //AB20161103 Start
    public String getSearchWhereClause(String strWhereClause){
        String strSearchOperation = showSearchOprpage;
        String strSearchField = showSearchFieldpage;
        String strKeyword = showSearchKeyWord;
        string strQueryField = '';
        String strQueryOperation='';
        if(strKeyword!=null && strKeyword!=''){
            if(strSearchField.equalsIgnoreCase('Name')){
                strQueryField ='Name';
            }else if(strSearchField.equalsIgnoreCase('User Name')){
                strQueryField ='User_Name__c';
            }else if(strSearchField.equalsIgnoreCase('User ePass Id')){
                strQueryField ='User_ePass_Id__c';
            }else if(strSearchField.equalsIgnoreCase('User Email')){
                strQueryField ='User_Email_Id__c';
            }else if(strSearchField.equalsIgnoreCase('User Roles')){//AB20161129 Start
                strQueryField ='User_Roles__c';
            }else if(strSearchField.equalsIgnoreCase('User Profile')){
                strQueryField ='User_Profile__c';
            }//AB20161129 End
            
            //else if(strSearchField.equalsIgnoreCase('Approver Name')){
              //  strQueryField ='Approver__c.Name';
            //} 
                
            
            if(strSearchOperation.equalsIgnoreCase('Matches')){
                strQueryOperation =' = \'__Keyword__\'';
            }else if(strSearchOperation.equalsIgnoreCase('Contains')){
                strQueryOperation =' like \'%__Keyword__%\'';
            }else if(strSearchOperation.equalsIgnoreCase('Begins With')){
                strQueryOperation =' like \'__Keyword__%\'';
            }else if(strSearchOperation.equalsIgnoreCase('Ends With')){
                strQueryOperation =' like \'%__Keyword__\'';
            } 
            
            
            
            strWhereClause = strWhereClause + ' AND '+strQueryField+strQueryOperation.replaceAll('__Keyword__', strKeyword);
        
        }
        
        return strWhereClause;
    }
     //AB20161103 End
    public String getApprovingBusiness(){
        String csvAB = BLANK;
        for(String ab: approvingBusinesses){
            csvAB = (csvAB==BLANK)? '\''+ab+'\'': csvAB+',\''+ab+'\'';
        }
        return csvAB;
    }
    public void getRegionCountry(){        
        List<String> countries;
        for(AggregateResult rgncntry: [SELECT User_Region__c,User_Country__c FROM User_Access_Review_Details__c Group By User_region__C, User_Country__c LIMIT :MAXROWS]){
            
            if(regionCountryMap.get((String)rgncntry.get('User_Region__c'))!=NULL){
                countries = regionCountryMap.get((String)rgncntry.get('User_Region__c'));
                regionCountryMap.remove((String)rgncntry.get('User_Region__c'));                
            }else{
                countries = new LIST<String>();                
            }
            if((String)rgncntry.get('User_Country__c')!=null){
                countries.add((String)rgncntry.get('User_Country__c'));
            }
            regionCountryMap.put((String)rgncntry.get('User_Region__c'), countries);
        }
    }
    
    public List<String> getRegion(){
        regionList.addAll(regionCountryMap.keySet());
        return regionList;
    }
    
    public List<String> getCountriesOfSelectedRegion(){   
        List<String> countriesList = new List<String>();
        if(showRgnpage!=ALL && showRgnpage!=null){
            countriesList.addAll(regionCountryMap.get(showRgnpage));
        }else{
            for(String key:regionCountryMap.keySet()){
                countriesList.addAll(regionCountryMap.get(key));
            }            
        }
        countriesList.sort();
        return countriesList;
    }
    
    public void getUserType(){        
        for(AggregateResult usrtype: [SELECT User_Access_Type__c FROM User_Access_Review_Details__c Group By User_Access_Type__c LIMIT :MAXROWS]){
            PageUsrSetFilter.add((String)usrtype.get('User_Access_Type__c'));
        }
    }
    
    public void getUserLicenseType(){        
        for(AggregateResult usrtype: [SELECT User_Type__c FROM User_Access_Review_Details__c Group By User_Type__c LIMIT :MAXROWS]){
            PageUsrLicenseSetFilter.add((String)usrtype.get('User_Type__c'));
        }
    }
    
    public void getOwningOrg(){        
        for(AggregateResult OwningOrg: [SELECT User_Owning_Org__c FROM User_Access_Review_Details__c Group By User_Owning_Org__c LIMIT :MAXROWS]){
            PageOwnOrgSetFilter.add((String)OwningOrg.get('User_Owning_Org__c'));
        }
    }
    
    public void getOwningSBUOrg(){        
        for(AggregateResult OwnSBUOrg: [SELECT User_Owning_SBU_Org__c FROM User_Access_Review_Details__c Group By User_Owning_SBU_Org__c LIMIT :MAXROWS]){
            PageOwnSBUOrgSetFilter.add((String)OwnSBUOrg.get('User_Owning_SBU_Org__c'));
        }
    }
    
    public void getSFDCInst(){        
        for(AggregateResult SFDCInst: [SELECT Org__c FROM User_Access_Review_Details__c Group By Org__c LIMIT :MAXROWS]){
            PageSFDCInstSetFilter.add((String)SFDCInst.get('Org__c'));
        }
    }
    //AB20160826 Start
    public void getProgram(){        
        for(AggregateResult prog: [SELECT Program__c FROM User_Access_Review_Details__c Group By Program__c LIMIT :MAXROWS]){
            PageProgSetFilter.add((String)prog.get('Program__c'));
        }
    }
    //AB20160826 End
    //AB20161103 Start
    public void getSearchableFields(){   
        PageSearchFieldSetFilter.add('Name');
        PageSearchFieldSetFilter.add('User Name');
        PageSearchFieldSetFilter.add('User ePass Id');
        PageSearchFieldSetFilter.add('User Email');
        PageSearchFieldSetFilter.add('User Roles'); //AB20161129
        PageSearchFieldSetFilter.add('User Profile');//AB20161129
        //PageSearchFieldSetFilter.add('Approver Name');
    }
    //AB20161103 End
    //AB20161103 Start
    public void getSearchableOpr(){        
        PageSearchOprSetFilter.add('Matches');
        PageSearchOprSetFilter.add('Contains');
        PageSearchOprSetFilter.add('Begins With');
        PageSearchOprSetFilter.add('Ends With');
    }
    //AB20161103 End
    
}