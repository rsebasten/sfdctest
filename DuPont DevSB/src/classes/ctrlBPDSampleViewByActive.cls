/*******************************************************************************
Copyright © 2015 DuPont. All rights reserved. 
Description:  Controller for page BPDSampleViewbyActive to generate list of records filtered by Actives
for each country for which records exist
<SRM20150602> Implemented Pagination by using Standard set controller
<SRM201506019> Sorted the list by Sample Name in desc order
<SAI20150209>  Intialized the StandardSetController setcon=null in lines 60 77
 *****************************************************************************/
public class ctrlBPDSampleViewByActive {

    public string selectedItemValue{get;set;}
    public String country{get;set;}
    public String samplePurchase{get;set;}
    public Id recId{get;set;}
    public List<selectOption> countrylist{get{
     if(countrylist ==null)
        {
            countrylist = new List<selectOption>();
            countrylist.add(new selectOption('--None--','--None--'));
        }
        return countrylist;
    }set;}
    public List<selectOption> recordlist{get;set;}
    public Set<selectOption> countrylistset{get;set;}
    public List<Trademark_Abuse_Sample__c> samplelist1 = new List<Trademark_Abuse_Sample__c>();
    public List<Trademark_Abuse_Sample__c> samplelist2{get;set;}
    public List<Id> Idlist = new List<Id>();
    private final Trademark_Abuse_Sample__c sample_object;
    
    Public Integer noOfRecords{get; set;}
    Public Integer size{get;set;}
    
    
   public ctrlBPDSampleViewByActive(ApexPages.StandardController stdController) {
        this.sample_object = (Trademark_Abuse_Sample__c)stdController.getRecord();
          system.debug('Hellooo2');
        
    }
    
    public List<selectOption> getPickValues(Sobject object_name, String field_name) {
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        
        Schema.sObjectType sobject_type = object_name.getSObjectType(); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List<Schema.PicklistEntry> pick_list_values = field_map.get(field_name).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        options.add(new selectOption('--None--','--None--'));
        for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
            options.add(new selectOption(a.getLabel(), a.getValue()));  //add the value and label to our final list 
        }
           return options; //return the List
    }
    
    //return the picklist options for Active Ingredients
    public List<selectOption> getActiveIngredients() {
       return getPickValues(sample_object, 'Active_Ingredients__c');
    }

    public PageReference methodone(){
         setCon = null;            /*Sai Mamillapalli 20150209 Added intialization to Standard Set Controller */
         countrylist = new List<selectOption>();
         countrylistset = new Set<selectOption>();         
         samplelist2 = new List<Trademark_Abuse_Sample__c>();
         recordlist = new List<selectOption>();
         samplelist1 = [Select Id, Country__c from Trademark_Abuse_Sample__c where Active_Ingredients__c =:selectedItemValue];     
         countrylist.add(new selectOption('--None--','--None--'));
         for(Trademark_Abuse_Sample__c sample: samplelist1){
            countrylistset.add(new selectOption(sample.Country__c,sample.Country__c));
         }
         for(SelectOption sample11: countrylistset){
            countrylist.add(sample11);
            countrylist.sort();
         }
         return null;
    } 
    public PageReference nimsinow(){
       setCon = null;/*Sai Mamillapalli 20150209 Added intialization to Standard Set Controller */
       samplelist2 = new List<Trademark_Abuse_Sample__c>();
       //samplelist2 = [Select id,Name, Sample_Name__c, CreatedDate, Legacy_Sample_Name__C, Case__c, Case__r.Company__c, Case__r.CreatedById from Trademark_Abuse_Sample__c where country__c =:Country and Active_Ingredients__c = :selectedItemValue]; 
        return null;
    }
    
    /* Changes Start <SRM20150602> 
    using standard methods of standard set controller
     <!--<SRM201506019> Sorted by Sample Name in desc order-->*/
      public ApexPages.StandardSetController setCon {
      
        get{
        
            system.debug('Calling stand set controller'+setCon+'-'+country+'-'+selectedItemValue);
         if(setCon == null && country!=null && country!='--None--' && selectedItemValue!=null  && selectedItemValue!='--None--') {        
                size = 1000;
                string queryString = 'Select id,Name, Sample_Name__c, CreatedDate, Legacy_Sample_Name__C, Case__c, Case__r.Company__c, Case__r.CreatedById from Trademark_Abuse_Sample__c where country__c =\''+Country +'\' and Active_Ingredients__c = \''+selectedItemValue+'\' order by Sample_Name__c desc';
                System.debug('queryString:'+queryString);
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
                setCon.setPageSize(size);
                noOfRecords = setCon.getResultSize();
            return setCon;
          }
          else 
              return setCon;
          
        }set;
    }
     Public List<Trademark_Abuse_Sample__c> getTrademarkAbuseSample(){
        List<Trademark_Abuse_Sample__c> tasList = new List<Trademark_Abuse_Sample__c>();
        for(Trademark_Abuse_Sample__c a : (List<Trademark_Abuse_Sample__c>)setCon.getRecords())
            tasList.add(a);
        return tasList;
    }
  
  
    public pageReference refresh() {
        setCon = null;
        getTrademarkAbuseSample();
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
     
   public list<Trademark_Abuse_Sample__c > getRecords()
   {
       if(setCon!=null)
       return (List<Trademark_Abuse_Sample__c >)setCon.getRecords();
       else
        return null;
       
   }
   /* Changes Start <SRM20150602> */
}