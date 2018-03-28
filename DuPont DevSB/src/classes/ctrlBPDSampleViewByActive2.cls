public class ctrlBPDSampleViewByActive2
{

/*   
  public String searchtext { get; set; }
  public Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
  public List <SelectOption> objectNames{public get; private set;}
  public String selectedObject {get; set;}
  public List<SelectOption> fields {public get; private set;}
  public String selectedField {get; set;}
  public List<SelectOption> searchCriteria{get;set;}
  public String selectedCriteria{get; set;}
  public List<Case_Details__c> records1{get;set;}
  public List<Trademark_Abuse_Sample__c> records2{get;set;}
  public List<Trademark_Abuse_Sample_Analysis__c> records3{get;set;}
  
  public integer counter=1;
  //public string queryString='';
    //Pagination
  Public Integer noOfRecords{get; set;}
  Public Integer size{get;set;}
  
       
  Map<String, string> allObjectsApiNameToLabelMap=new Map<String, string>{'Case_Details__c'=>'Trademark Abuse Case   Details', 'Trademark_Abuse_Sample__c'=>'Samples/Trap Purchases', 'Trademark_Abuse_Sample_Analysis__c'=>'Sample   Analysis'};

  public PageReference searchRecords() {
        if(searchtext!=null && !String.isBlank(searchtext)){
        }else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Please enter search text');
            ApexPages.addMessage(myMsg);
            return null;
        }
        doQuery();
        
        return null;
    }
    
    public void doQuery(){ 
     setCon = null; 
       String queryString= generateQuery(selectedObject);
       
      system.debug('initial query*******'+queryString);
      
       if(queryString!=null && queryString!=''){
          if(selectedObject=='Case_Details__c'){
          try{
           records1=database.query(queryString);
           system.debug('records1 '+records1);
           if(!(records1.size()>0))
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'There are no records to be Displayed'));
          }
          catch(Exception ex){
            system.debug('exception is***'+queryString);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'There are no records to be Displayed'));
          }
           
       }else if(selectedObject=='Trademark_Abuse_Sample__c'){
       system.debug('strQuery is '+queryString);
           try{
              records2=database.query(queryString);
              if(!(records2.size()>0))
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'There are no records to be Displayed'));
           }
            catch(Exception ex){
              system.debug('exception is***'+queryString);
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'There are no records to be Displayed'));
          }
       }else if(selectedObject=='Trademark_Abuse_Sample_Analysis__c'){
       system.debug('strQuery is'+queryString);
           try{
              records3=database.query(queryString);
              if(!(records3.size()>0))
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'There are no records to be Displayed'));
              }
           catch(Exception ex){
              system.debug('exception is***'+queryString);
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'There are no records to be Displayed'));
          }
       }
       else if(selectedObject=='ALL'){
          try{
              records1=database.query(queryString);
              if(!(records1.size()>0))
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'There are no records to be Displayed'));
           }
           catch(Exception ex){
              system.debug('exception is***'+queryString);
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'There are no records to be Displayed'));
              
          }
       }
       }
         
    }
    
public string generateQuery(String objectname){
    string query='';
    string strWhereCondition ='';
    setCon = null; 
    selectedCriteria = selectedCriteria!=null ? selectedCriteria : '';
    if(selectedField.contains('Date')){
        if(selectedCriteria.equalsIgnoreCase('Equals'))
           strWhereCondition += ' where '+selectedField+' = '+searchtext;
        else if(selectedCriteria.equalsIgnoreCase('Does Not Equal')) 
           strWhereCondition += ' where '+selectedField+' != '+searchtext;  
       /* else
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Date formats supports only EQUALS and Not EQUALS functions,Please use the format as 2015-10-06')); 
         */ 
  /*  }
    else 
    { 
     if(selectedField.contains('Id')|| selectedField.contains('Related Case')||selectedField.contains('Lab Name')|| (objectname=='Trademark_Abuse_Sample__c' && selectedField.contains('Case'))){
        
        if(selectedCriteria.equalsIgnoreCase('Equals'))
           strWhereCondition += ' where '+selectedField+' = '+'\''+searchtext+'\'';
        else if(selectedCriteria.equalsIgnoreCase('Does Not Equal')) 
           strWhereCondition += ' where '+selectedField+' != '+'\''+searchtext+'\''; 
      /*  else 
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Id formats supports only EQUALS and Not EQUALS functions,Please use 15 or 18 digit value to search'));    
          */
 /*    }
     else {
        if(selectedCriteria.equalsIgnoreCase('Equals')) 
            strWhereCondition += ' where '+selectedField+' = '+'\''+searchtext+'\'';
        else if(selectedCriteria.equalsIgnoreCase('Ends With'))
        strWhereCondition += ' where '+selectedField+' like '+'\'%'+searchtext+'\'';
        else if(selectedCriteria.equalsIgnoreCase('Begins With'))
        strWhereCondition += ' where '+selectedField+' like '+'\''+searchtext+'%\'';
        else if(selectedCriteria.equalsIgnoreCase('Contains')){
        system.debug('contains*******');
        strWhereCondition += ' where '+selectedField+' like '+'\'%'+searchtext+'%\'';
        system.debug('search condition&&&&'+strWhereCondition);
        }
        else if(selectedCriteria.equalsIgnoreCase('Does Not Contain'))
        strWhereCondition += ' where (NOT '+selectedField+' like '+'\'%'+searchtext+'%\')';
        else if(selectedCriteria.equalsIgnoreCase('Does Not Equal'))
        strWhereCondition += ' where '+selectedField+' != '+'\''+searchtext+'\'';
        
        
     }
    }
            if(objectname=='Case_Details__c' ){
                query='select id, name, Company__c, Country_Text__c, Facts_of_the_Case__c, Date_Opened__c, Related_Case__c,Related_Case__r.CaseNumber from Case_Details__c'+strWhereCondition+ ' order by Date_Opened__c desc  LIMIT 1000';
                
            }else if(objectname=='Trademark_Abuse_Sample__c'){
                query='select id, name, Sample_Name__c, Active_Ingredients__c, Label_Name__c from Trademark_Abuse_Sample__c'+strWhereCondition+' order by Sample_Name__c desc  LIMIT 1000';
                
            }else if(objectname=='Trademark_Abuse_Sample_Analysis__c' ){
                query='select id, name, Lab_Name__c, Overall_Conclusion__c, Summary__c, Active_for_Brand_found_in_HPLC1__c, Compounds_found_in_FTIR__c from Trademark_Abuse_Sample_Analysis__c'+strWhereCondition +' order by Lab_Name__c desc  LIMIT 1000';
                
            }else if(objectname=='ALL' && selectedField!=''){
                query='select id, name, Company__c, Country_Text__c, Facts_of_the_Case__c, Date_Opened__c, Related_Case__c,Related_Case__r.CaseNumber from Case_Details__c'+strWhereCondition+ ' order by Date_Opened__c desc  LIMIT 1000';     
            }
        
            
         
    return query;
   
}

public ctrlBPDSampleViewByActive2() {
objectNames = initObjNames();
selectedObject='All';
showFields();
selectedField='All';
initSearchCriteria();
selectedCriteria='Contains';
        
}
// Populate SelectOption list -


public List<SelectOption> initObjNames() {
    List<SelectOption> objNames = new List<SelectOption>();
    objNames.add(new SelectOption('All','Table:All'));
    objNames.add(new SelectOption('Case_Details__c','Trademark Abuse Case Details'));
    objNames.add(new SelectOption('Trademark_Abuse_Sample__c','Samples/Trap Purchases'));
    objNames.add(new SelectOption('Trademark_Abuse_Sample_Analysis__c','Sample Analysis'));
    return objNames;
}

// Find the fields for the selected object

public void showFields() {
    fields=new List<SelectOption>();
    fields.add(new SelectOption('All','Field:All'));
    if(selectedObject!='All'){   
        Map <String, Schema.SObjectField> fieldMap = schemaMap.get(selectedObject).getDescribe().fields.getMap();
        for(Schema.SObjectField sfield : fieldMap.Values())
        {
            schema.describefieldresult dfield = sfield.getDescribe();
            system.debug('filterfield***'+dfield.getname()+'&&&'+dfield.isFilterable());
            if(dfield.isFilterable()){
                fields.add(new SelectOption(dfield.getname(),allObjectsApiNameToLabelMap.get(selectedObject)+' : '+dfield.getLabel ()));
            }
               
        }
    }else{
        for(String s:allObjectsApiNameToLabelMap.keyset() ){
          Map <String, Schema.SObjectField> fieldMap = schemaMap.get(s).getDescribe().fields.getMap();
            for(Schema.SObjectField sfield : fieldMap.Values())
            {
                system.debug('sfield8888'+sfield);
                schema.describefieldresult dfield = sfield.getDescribe();
                system.debug('dfield8888'+sfield);
               if(dfield.isFilterable()){ 
                fields.add(new SelectOption(dfield.getname(),allObjectsApiNameToLabelMap.get(s)+' : '+dfield.getLabel ())); 
               } 
            }
            
         }        
    
    }
}


public void initSearchCriteria() {
    searchCriteria = new List<SelectOption>();
    searchCriteria.add(new SelectOption('Equals','Equals'));
    searchCriteria.add(new SelectOption('Begins With','Begins With'));
    searchCriteria.add(new SelectOption('Ends With','Ends With'));
    searchCriteria.add(new SelectOption('Contains','Contains'));
    searchCriteria.add(new SelectOption('Does Not Contain','Does Not Contain'));
    searchCriteria.add(new SelectOption('Does Not Equal','Does Not Equal'));
}

//pagination code

 public ApexPages.StandardSetController setCon {get {
      if(setCon == null ) {
             size = 20;
                if(counter==1){
                string queryString='select id, name, Company__c, Country_Text__c, Facts_of_the_Case__c, Date_Opened__c, Related_Case__c,Related_Case__r.subject from Case_Details__c order by Date_Opened__c desc limit 1';
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
                 Counter++;
                 //setCon.setPageSize(size);
                 }else {
                 
                 String queryString= generateQuery(selectedObject);
                 setCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
                 system.debug('counter====='+Counter);
                 //setCon.setPageSize(size);
                 }
                 
                 setCon.setPageSize(size);
                 noOfRecords = setCon.getResultSize();
                 system.debug('noofrecorcds....'+noOfRecords );
                 return setCon; 
                 
             }
            
                 return setCon;
              
        }set;
    }
    
          
 public pageReference refresh() {
        setCon = null;
        
        if(selectedObject=='Case_Details__c' || selectedObject=='ALL'){
        getCaseDetails();
        }
        if(selectedObject=='Trademark_Abuse_Sample__c'){
        getSamplesPurchases();
        }
        if(selectedObject=='Trademark_Abuse_Sample_Analysis__c'){
        getSampleAnalysis();
        }
        
        setCon.setPageNumber(1);
               
        return null;
    }
     public Boolean hasNext {
        get {
            if(setCon!=null)
            return setCon.getHasNext();
            else
             return null;
        }
        set;
    }
    
    public Boolean hasPrev {
        get {
            if(setCon!=null)
            return setCon.getHasPrevious();
            else
               return null;
        }
        set;
    }
    
     public void next() {
         setCon.next();
     }
     
     public void prev() {
         setCon.previous();
     }

     public void first() {
         setCon.first();
     }
     public Integer pageNumber {
        get {
        if(setCon!=null)
            return setCon.getPageNumber();
            else
                return null;
        }
        set;
    }
   
     public void last() {
         setCon.last();
     }
     
   public list<Case_Details__c> getCaseDetails()
   {
       if(setCon!=null){
        return  (List<Case_Details__c>)setCon.getRecords();
       }
       else
        return null;
       
   }
   
   public list<Trademark_Abuse_Sample__c > getSamplesPurchases()
   {
       if(setCon!=null)
       return (List<Trademark_Abuse_Sample__c >)setCon.getRecords();
       else
        return null;
       
   }
   
   public list<Trademark_Abuse_Sample_Analysis__c> getSampleAnalysis()
   {
       if(setCon!=null)
       return (List<Trademark_Abuse_Sample_Analysis__c>)setCon.getRecords();
       else
        return null;
      
   }

*/
}