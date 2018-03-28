/*************************************************************************************************
Copyright © 2013 DuPont. All rights reserved. 
Authors:        Divya Ramakrishnaiah, Thomas Snyder
Email:          divya.ramakrishnaiah@usa.dupont.com, thomas.snyder@usa.dupont.com/ tom@3ddd.com
Description:    Class library for trigExternalInitiative and External Initiative Handler,
used to create opportunity(s) that are related to the MHC project and 
assign owner and account based on mappings done in GeoMapping.
<KK20130516> 
Modified By: Kusuma Kumar
Modified Date: 16-May-2013
Modification: Modified the code to do an upsert operation instead of insert to ensure that the existing
Opportunities are updated to fire the workflow rule, to update the Opportunity Rating field.
<KK20130828>
Modified By: Kusuma Kumar
Modification Date: 28-Aug-2013
Modification: Added a new method UpdateOpportunities to update the Opportunity Owner2 field with the Contact based 
on the External Initiative parameters and Opportunity Rating,Net Amount and Application Type 
<AB20130917>
Modified By: Abhinav Bhatnagar
Modification Date: 17-Sep-2013
Modification: Updated to use Geomapping and Geography instead of using custom settings 

<AB20140320>
Modified By: Abhinav Bhatnagar
Modification Date: 20-Mar-2014
Modification: (1) Updated filter criteria for the Opportunity Owner 2 assignment 
(2) Removed Closed Date Criteria

<AB20141107>
Modified By: Abhinav Bhatnagar
Modification Date: 07-Nov-2014
Modification: Updated the getAssignment Method for code coverage

<AB20150511>
Modified By: Abhinav Bhatnagar
Modification Date: 11-May-2015
Modification: Updated the Owner2 assignment filter criteria for CLT-Surfaces also. 

<MS20161004>
Modified By: Mayuri Singhal
Modification Date: 04-Oct-2016
Modification: Rectified NULL pointer Exception, Exception Handling on Opportunity Creation method AddOpportunities


<VL20161010>
Modified By: Vijay Laxmi
Modification Date: 10-Oct-2016
Modification: Added new method AddOpportunities_CIC to add CIC Opportunity with region specific
              Added new method updateOpportunities_CIC to update CIC Opportunity if Opportunity is already preasent and External Initiave is modified.  

<VL20161109>
Modification: Create exception record to log data and technical issue.
**************************************************************************************************/

public class BI_MHC
{
    
    /* Global Private Constants used through out the class */
    private static final String OWNER2CSNAME = 'BINAOwner2__C'; //Name of the custom settings from where filters needs to be fetched /*<AB20150511> */
    private static final String APPTYPESURFACES= 'Surfaces'; //Name of the custom settings from where filters needs to be fetched /*<AB20150511> */
    private static final String APPTYPETYVEKORFLUID = 'TyvekOrFluid'; //Name of the custom settings from where filters needs to be fetched /*<AB20150511> */
    
    public static MAP<String,BI_NA_MHC_Settings__c> SETTINGS { GET {return BI_NA_MHC_Settings__c.getAll(); }}
    /*<AB20130917> Start*/
    //public static MAP<String,BI_NA_Opp_Assignment__c> OPP_ASSIGN_SETTINGS { GET {return BI_NA_Opp_Assignment__c.getAll(); }}//Not Required
    /*<AB20130917> End*/
    //<AB20140320>public static final Date OPP_CLOSEDT = Date.Today().addMonths(6);
    /*<KK20130828>*/
    public static final String OPP_STAGE = 'Target';
    public static final String EI_STAGE_BIDDING = 'Bidding';
    public static final String EI_STAGE_BID = 'Bid Result';
    
    private static final String DEFAULTCOUNTRY = 'US';
    
    /*Opportunity OppNew;

Public BI_MHC(){

OppNew= New Opportunity()
OppNew=[Select id,External_Initiative__r.Country__c from Opporttunity Where id=:Apexpages.CurrentPage.getparameters.Get('id')];


}*/
    
    /*****************************************************************************************************
Assign opportunities : Opportunities will only be created and assigned to External Initiative
if they have not already been created, and only if the search agent reflects the business needing the 
opportunity (tyvek and/or surface and/or fluid)
args:   projects: projects to check and assign if needed 
****************************************************************************************************/
    public static void AddOpportunities(LIST<External_Initiative__c> projects){
        //get the assignments
        BI_MHC.ProjectGeoAssignments PGA = new BI_MHC.ProjectGeoAssignments(projects);
        //get Opp RecordType DevName
        MAP<String,RecordType> mapOppRT = RType.getDevNameMapBySObjectType('Opportunity'); 
        /*<KK20130516> Start*/
        //List<Opportunity> OppsToInsert = new List<Opportunity>();
        List<Opportunity> OppsToUpsert = new List<Opportunity>();
        /*<KK20130516> End*/
        // To collect list of existing Opportunities, if any
        Map<Id, Set<String>> ExistingOppMap = new Map<Id, Set<String>>();  
        list<string> lstEI = new list<string>();//<MS20161004> Exception Handling related collection
        for (Opportunity opp : [Select Id,External_Initiative__r.County__c,External_Initiative__r.Owning_Organization__c,External_Initiative__r.ID,External_Initiative__r.State__c,External_Initiative__r.Stage__c,External_Initiative__r.Specification_L1__c,External_Initiative__r.Specification_L2__c,RecordType.DeveloperName,Application_Type__c,Net_Amount__c,Opportunity_Rating__c,External_Initiative__r.external_Id__c from Opportunity where External_Initiative__c in : projects]){
            if(!ExistingOppMap.containsKey(opp.External_Initiative__r.Id))
                ExistingOppMap.put(opp.External_Initiative__r.ID,new Set<String>());
            ExistingOppMap.get(opp.External_Initiative__r.ID).add(opp.Application_Type__c);
            /*<KK20130516>*/
             lstEI.add(string.valueof(opp.External_Initiative__r.external_Id__c));
            OppsToUpsert.add(opp);
        }
        for(External_Initiative__c extInit : projects)
{
            // Run only when Search agent name is available
            if(extInit.External_Search_Name__c != null){
                String searchAgent = extInit.External_Search_Name__c.toUpperCase().replaceAll('\\s+','');
                //If Opportunities are not created at all
                if(!ExistingOppMap.containsKey(extInit.Id)){
                    for (BI_NA_MHC_Settings__c setting : SETTINGS.values()){
                        String prefix = setting.SearchAgentPrefix__c.toUpperCase();
                        String OppRtypeId = (mapOppRT.containsKey(setting.OppRecordTypeDevName__c)) ? mapOppRT.get(setting.OppRecordTypeDevName__c).Id : null;
                        if((searchAgent.startsWith(prefix) || searchAgent.contains(','+prefix))){
                            BI_MHC.Assignment assign = PGA.getAssignment(extInit.Id,setting);
                            Opportunity Opp = new Opportunity(name=extInit.name, OwnerId=assign.ownerid, AccountId=assign.accountid, External_Initiative__c=extInit.Id,CloseDate=Date.valueOf('2050-01-01'),
                                                              //<AB20140320> Starts
                                                              RecordTypeId=OppRtypeId, StageName=OPP_STAGE,Application_Type__c=setting.OppAgentType__c,Owning_Organisation__c=setting.Owning_Org__c);
                            //<AB20140320> Ends
                            /*<KK20130516>*/
                            //OppsToInsert.add(Opp);
                            lstEI.add(string.valueof(extInit.external_Id__c));
                            OppsToUpsert.add(Opp);
                        }
                    }
                }
                // If few opportunities created previously
                else{
                     Set<String> oppRecType = ExistingOppMap.get(extInit.Id);
                     for (BI_NA_MHC_Settings__c setting : SETTINGS.values()){
                         String prefix = setting.SearchAgentPrefix__c.toUpperCase();
                         String OppRtypeId = (mapOppRT.containsKey(setting.OppRecordTypeDevName__c)) ? mapOppRT.get(setting.OppRecordTypeDevName__c).Id : null;
                         if ( !oppRecType.contains(setting.OppAgentType__c) && (searchAgent.startsWith(prefix) || searchAgent.contains(','+prefix))){
                             BI_MHC.Assignment assign = PGA.getAssignment(extInit.Id,setting);
                             Opportunity Opp = new Opportunity(name=extInit.name, OwnerId=assign.ownerid, AccountId=assign.accountid, External_Initiative__c=extInit.Id,CloseDate=Date.valueOf('2050-01-01'),
                                                               //<AB20140320> Starts
                                                               RecordTypeId=OppRtypeId, StageName=OPP_STAGE, Application_Type__c=setting.OppAgentType__c,Owning_Organisation__c=setting.Owning_Org__c);
                             //<AB20140320> Ends
                             /*<KK20130516>*/
                             //OppsToInsert.add(Opp);
                             lstEI.add(string.valueof(extInit.external_Id__c));
                             OppsToUpsert.add(Opp);
                         }
                     }
                    }
            }system.debug('???__'+OppsToUpsert);
        }
        /*<KK20130516>*/
        //insert OppsToInsert;
        //<MS20161004> Start Exception Handling
        //upsert OppsToUpsert;    
    
    List<Database.UpsertResult> urList = database.upsert(OppsToUpsert,  false);
        //<AS20161101> Start, do not create issues during opportunities updated.
        //Blob b = ExceptionHandlingClass_CIC_CP.MthdFetchErrors (lstEI, urList, '^');
        //system.debug('>>>>b>>>'+b);
        //if(b != null)
            //ExceptionHandlingClass_CIC_CP.autoCreateIssue(b,'Opportunity','Data_Issue');
        	//<AS20161101> End
    //<MS20161004> End Exception Handling
    }
        
    /*<KK20130828>*/
   /*<KK20130828>*/
  /***************************************************************************
* Method Name: AddOpportunities_CIC
* Return Type: void
* Description: Create the Opportunity for CIC Project for those EI only where Oppty not present 
****************************************************************************/
    //<VL20161010> <Start>
    public static void AddOpportunities_CIC(LIST<External_Initiative__c> projects)
    {
        list<Opportunity> OppsToUpsert = new list<Opportunity>();
        Map<Id, Set<String>> ExistingOppMap = new Map<Id, Set<String>>();  
        Map<Id, String> EIRegionSurfConcatMap = new Map<Id, String>();  
        list<string> lstEI = new list<string>();
        set<string> setRegionCountry = new set<string>();  
        set<string> setExtCountry =  new set<string>();
        set<string> setExtRegion =  new set<string>();
        set<id> setGeoId = new set<id>();
		// For Querying Owner of the Oppty    
        for(External_Initiative__c extInit : projects)
        {         
            setExtCountry.add(extInit.Country__c);//for Geo mapping
            if(settings.get(extInit.EI_Region__c+'_'+extInit.External_Search_Name__c.toUpperCase())!=null)
            {
                setExtRegion.add(settings.get(extInit.EI_Region__c+'_'+extInit.External_Search_Name__c.toUpperCase()).DuPont_Region__c);//for Geo mapping          
            }  
        }
        //Geo mapping code
        for(geography__c g :[
                            select id,name 
                            from geography__c 
                            where name in:setExtCountry and Level__c = 3 and Parent__r.Parent__r.name in: setExtRegion
                            ])
        {
            setGeoId.add(g.id);
        }       
        map<string,id> mapGeoMApKeyUSer = new map<string,id>();
        Set<id> OpptyOwnerlist=new Set<id>();
        for(Geography_Mapping__c gm : [
                                      select id,Geography__c,User__c,Geography__r.name, Geography__r.Parent__r.Parent__r.name 
                                      from Geography_Mapping__c 
                                      where Geography__c in:setGeoId
                                      ])
        {
            mapGeoMApKeyUSer.put(gm.Geography__r.Parent__r.Parent__r.name.toUpperCase()+'_'+gm.Geography__r.name.toUpperCase(),gm.User__c);        
            OpptyOwnerlist.add(gm.User__c);
        }
        // Fetching the Currency from User
		List<User> ulist=[select id,name,DefaultCurrencyIsoCode from user where id in:OpptyOwnerlist];
        map<id,string> currencyMap= new map<id,String>();
        for (User u:ulist){
            currencyMap.put(u.id, u.DefaultCurrencyIsoCode);
        }
        for(External_Initiative__c extInit : projects)
        {
            String searchAgent = extInit.External_Search_Name__c.toUpperCase().replaceAll('\\s+','');
            String concatRegSurf=null;
            String OpptyRegion;
            concatRegSurf=extInit.EI_Region__c+'_'+extInit.External_Search_Name__c.toUpperCase();
            if(settings.get(concatRegSurf)!=null && !ExistingOppMap.containsKey(extInit.Id))
            {
                OpptyRegion  =settings.get(concatRegSurf).DuPont_Region__c;
                //CIC Opportunity Creation
                Opportunity Opp = new Opportunity(
                                                    name=extInit.Full_External_Initiative_Name__c.length()>120?extInit.Full_External_Initiative_Name__c.substring(0,120):extInit.Full_External_Initiative_Name__c,
                    								AccountId=settings.get(concatRegSurf).FallbackAccountId__c, 
                                                    External_Initiative__c=extInit.Id,CloseDate=Date.valueOf('2050-01-01'),
                                                    StageName=OPP_STAGE,Owning_Organisation__c=settings.get(concatRegSurf).Owning_Org__c,
                                                    Source_Name__c=System.Label.CIC_External_Initiative_Data_Source,
                                                    Market_Segment__c=system.label.CIC_Opportunity_Market_Segment,
                    								Opportunity_Site__c=extInit.Country__c,Description=extInit.Description__c,Probability=Integer.valueof(System.Label.CIC_Probability)  
                                                   );
                Opp.RecordTypeId = settings.get(concatRegSurf).OppRecordTypeDevName__c;                                 
                if(mapGeoMApKeyUSer.get(OpptyRegion+'_'+extInit.Country__c.toUpperCase())!=null)
                    Opp.ownerid = mapGeoMApKeyUSer.get(OpptyRegion+'_'+extInit.Country__c.toUpperCase());                                                   
                else
                    Opp.ownerid =settings.get(concatRegSurf).FallbackOwnerId__c;                
                
                if(currencyMap.get(opp.ownerid)!=null)
				{
                    Opp.CurrencyIsoCode=currencyMap.get(opp.ownerid);
				}	
                    // Asia-Pacific region CIC Opportunity  
                    if(extInit.EI_Region__c.contains('Asia-Pacific') || extInit.EI_Region__c.contains('South and Central America'))
                    {                                   
                        Opp.Type=system.label.Lead_Type;
                        Opp.Product__c=system.label.Lead_Type;
                                
                    }
                    // LA region CIC Opportunity                            
                    if(extInit.EI_Region__c.contains('South and Central America'))
                    {
                        Opp.Amount=0;
                        Opp.Est_Opportunity_Volume__c=0;
                        Opp.Origin_Type__c=system.label.CIC_Opportunity_Origin_Type;
                        Opp.Product_Details__c=system.label.CIC_Opportunity_Product_Details;
                    }
                    lstEI.add(string.valueof(extInit.external_Id__c));
                    OppsToUpsert.add(Opp);  
            }
        }
		
		List<Database.UpsertResult> urList = database.upsert(OppsToUpsert,  false);
        ExceptionHandlingClass_CIC_CP.MthdFetchErrors(lstEI,urList,'Opportunity','CIC');//<VL20161109>
    }        
	
 //<VL20161010> <End> 
    /***************************************************************************
* Method Name: UpdateOpportunities
* Return Type: void
* Description: Updates the Opportunity Owner2 field of the existing 
*              Opportunities with the contact (from Geography__c and Geomapping)
*              based on the External Initiative and Opportunity field values 
****************************************************************************/
    public static void UpdateOpportunities(LIST<External_Initiative__c> projects){
        List<Opportunity> OppsToUpdate = new List<Opportunity>();       
        
        Map<Id, Set<String>> ExistingOppMap = new Map<Id, Set<String>>();
        Id oppOwner2id;
        system.debug('BI_MHC--> '+projects.size());
        
        //Query to fetch all the opportunities related to Exeternal Initiative
        //<AB20140320> Starts
        
        List<Opportunity> oppAll = [Select Id,Owning_Organisation__c ,External_Initiative__r.County__c, External_Initiative__r.Owning_Organization__c,External_Initiative__r.ID,External_Initiative__r.State__c,External_Initiative__r.Stage__c,External_Initiative__r.Specification_L1__c,External_Initiative__r.Specification_L2__c,RecordType.DeveloperName,Application_Type__c,Net_Amount__c,Opportunity_Rating__c, External_Initiative__r.Segment_L2__c, External_Initiative__r.Segment_L3__c, External_Initiative__r.Value__c from Opportunity where External_Initiative__c in : projects];
        
        for (Opportunity opp : oppAll ){//<AB20140320> Ends
            if(!ExistingOppMap.containsKey(opp.External_Initiative__r.Id))
                ExistingOppMap.put(opp.External_Initiative__r.ID,new Set<String>());
            ExistingOppMap.get(opp.External_Initiative__r.ID).add(opp.Application_Type__c);
            OppsToUpdate.add(opp);
        }
        /*<AB20130917> Start*/
        Geography.Countries countriesObject;
        Geography.States statesObject;        
        Map<String,Geography_Mapping__c> geographyMappingObject;
        
        
        
        //map of county and Id
        Map<String,Id> CountyNameId = New Map<String,Id>();
        if(OppsToUpdate!=null && OppsToUpdate.size()>0){   
            countriesObject= new Geography.Countries();
            /*<NN20150611>  Start*/
            
            //Prepare StateObject for all countries in multiple EI as projects //AB20150617
            Set<Id> sCountries = new SET<Id>();
            for(External_Initiative__c project: projects){
                 if(project.Country__c != null && countriesObject.getCountry(project.Country__c)!=null){//<MS20161004> NULL Pointer issue
                        sCountries.add(countriesObject.getCountry(project.Country__c).Id);
                }
            }
            
            if(sCountries.size()<1){
                sCountries.add(countriesObject.getCountry(DEFAULTCOUNTRY).Id);
            }
            
            
            statesObject = new Geography.States(sCountries); //by Country GeoIds(s)
            System.debug('sCountries  --->>> '+sCountries);
            System.debug('statesObject  --->>> '+statesObject);
            MAP<id, Geography__c> stateIds = new MAP<id, Geography__c>([Select Id,name,(SELECT Level__c,Name,Parent__c,code__c,id FROM Geography__r)  from Geography__c where parent__c IN : sCountries]);//AB20150617
            //MAP<id, Geography__c> CountiesIds = new MAP<id, Geography__c>();
            for(Geography__c stateId: stateIds.values()){
                For(Geography__c county : stateId.Geography__r)
                {
                    System.debug('StateId----->'+StateId.name+' county ----> '+county.name+' code--> '+county.code__c+' id---> '+County.id);
                    CountyNameId.put(county.Name, County.id);
                }
            }
            
            /*
            //DB20150623 added code from Test3 start
            statesObject = new Geography.States(new SET<Id>{countriesObject.getCountry(projects[0].Country__c).Id}); //by Country GeoIds(s)
            
            
            MAP<id, Geography__c> stateIds = new MAP<id, Geography__c>( [Select Id from Geography__c where parent__c =: countriesObject.getCountry(projects[0].Country__c).Id]);
             
            //County
            MAP<id, Geography__c> CountiesIds = new MAP<id, Geography__c>( [Select Id,Name,code__c from Geography__c where parent__c =: stateIds.Keyset()]);
            
             FOr(Geography__c county : CountiesIds.Values())
            {
                CountyNameid.put(county.Name,County.id);
            }            
            
            //DB20150623 added code from Test3 end
            
            */
            List<String> lstStrOwningOrg = new List<String>();
            
            for(Opportunity opp : OppsToUpdate){
                lstStrOwningOrg.add(opp.Owning_Organisation__c);
               }
            System.debug('In BI_MHC for list of Owning Orgs ====>>>>> '+lstStrOwningOrg);
            
            geographyMappingObject = new Map<String,Geography_Mapping__c>();
            for (Geography_Mapping__c gm : [SELECT Geography__c, Contact__c, Owning_Organization__c 
                                            FROM Geography_Mapping__c gm
                                            WHERE 
                                            //RecordType.DeveloperName = 'BI_NA_Opportunity_Owner_2' AND   (Geography__c in: stateIds.keySet() OR Geography__c in: CountiesIds.keySet()) ]){
                                            RecordType.DeveloperName = 'BI_NA_Opportunity_Owner_2' AND Owning_Organization__c in : lstStrOwningOrg AND  (Geography__c in: stateIds.keySet() OR Geography__c in: CountyNameId.values()) ]){    
                                                geographyMappingObject.put(gm.Geography__c+gm.Owning_Organization__c,gm);//=== Updating the key with geography id and owning org
                                                System.debug('In BI_MHC checking geography mappings ====>>>> '+geographyMappingObject);
                                            }
            /*<NN20150611> End*/                               
        }else{
            return;
        }
        /*<AB20130917> End*/
        //For loop to iterate the Opportunities and assign the Contact to Opportunity Owner2
        System.debug('In MHC ----> ');
        for(Opportunity opp : OppsToUpdate){
            /*Checks the criteria before updating*/ 
            //<AB20140320> Starts
            if(opp!=null 
               && opp.External_Initiative__r!=null 
               && opp.External_Initiative__r.Segment_L2__c!=null 
               && opp.External_Initiative__r.Stage__c!=null
               && opp.External_Initiative__r.Value__c!=null
               && opp.Application_Type__c!=null){                     
                   if( 
                       (
                           (
                               opp.Application_Type__c.contains('CLT-Fluid')
                               || opp.Application_Type__c.contains('CLT-Tyvek')
                           )  
                           && opp.External_Initiative__r.Segment_L3__c!=null//<AB20150511> Starts
                           && new BI_Dodge_Filter_Helper().compareValues(opp, OWNER2CSNAME, APPTYPETYVEKORFLUID)
                       )                       
                       ||                        
                       (
                           opp.Application_Type__c.contains('CLT-Surfaces') //<AB20150511> if the application is for dodge surfaces
                           && new BI_Dodge_Filter_Helper().compareValues(opp, OWNER2CSNAME, APPTYPESURFACES)
                       )
                   ){
                       //oppOwner2id = (Id)BI_NA_Opp_Assignment__c.getInstance(opp.External_Initiative__r.State__c).Opportunity_Owner_Id__c;
                       /*<AB20130917> Start*/
                       /*To fetch the Contact Id from the GeoId based on the State Name which is resolved by Alias*/
                       // If(opp.External_Initiative__r.State__c!=null){
                      // System.debug('BI_MHC===> Assigining Owner 2 ===> State '+opp.External_Initiative__r.State__c);
                       //System.debug('BI_MHC===> Assigining Owner 2 ===> State ID '+statesObject.getState(opp.External_Initiative__r.State__c).Id);
                       //System.debug('BI_MHC===> Assigining Owner 2 ===> geographyMappingObject '+    geographyMappingObject.get(statesObject.getState(opp.External_Initiative__r.State__c).Id));
                       //System.debug('BI_MHC===> Assigining Owner 2 ===> geographyMappingObject Only '+    geographyMappingObject);
                      
                       //if(opp.External_Initiative__r.County__c!=null && CountyNameId.containskey(opp.External_Initiative__r.County__c)&& geographyMappingObject.containskey(CountyNameid.get(opp.External_Initiative__r.County__c)+opp.Owning_organisation__c) && geographyMappingObject.get(CountyNameid.get(opp.External_Initiative__r.County__c)+opp.Owning_organisation__c).Contact__c!=Null){                           
                     //      opp.OpportunityOwner_2__c = geographyMappingObject.get(CountyNameid.get(opp.External_Initiative__r.County__c)+opp.Owning_organisation__c).Contact__c;
//}else{
                           String strState = opp.External_Initiative__r.State__c != null ? opp.External_Initiative__r.State__c : null;
                           Geography.State state =  statesObject!=null ? statesObject.getState(opp.External_Initiative__r.State__c) : null;
                           Id stateId = state!=null? state.Id : null;
                           Geography_Mapping__c geographyMapping  = stateId != null ? geographyMappingObject.get(stateId+opp.Owning_organisation__c):null;
                           opp.OpportunityOwner_2__c = geographyMapping != null ? geographyMapping.Contact__c : null;
                       //} 
                       
                       System.debug(' owner 2 opp===>>>> '+opp.OpportunityOwner_2__c);                      
                       //}//<AB20140320> Ends //<AB20150511> Ends
                       /*<AB20130917> End*/
                   }
               }
        }
        System.debug(' owner 2 OppsToUpdate===>>>> '+OppsToUpdate);     
        upsert OppsToUpdate;
    }
    
    /**************************************************************************************
ProjectGeoAssignments (ExternalInitiative specific geo assignment class)
constructor(s): ProjectGeoAssignments(List<External_Initiative__c> projects)
args:   list projects to get assignments for
public methods: Assignment              getTyvekAssignment(id projectid)
Assignment              getSurfacesAssignment(id projectid)
Geography_Mapping__c    getGeoMapping(id ProjectId, string Rtype)
**************************************************************************************/
    private static MAP<Id,Geography.County> mapPrjCounty;
    
    public class ProjectGeoAssignments{
        private GeoAssignment GeoAssign;
        public ProjectGeoAssignments(List<External_Initiative__c> projects){
            //getProjectCounties(projects): this may get called for an insert and update so mapPrjCounty 
            //records are added as needed and not a complete replace since this causes script statement limit errors
            getProjectCounties(projects);
            SET<Id> counties = new SET<Id>();
            for (Geography.County c : mapPrjCounty.values())
                counties.add(c.id);
            //get all GeoMapping recordtypes specified in SETTINGS
            SET<string> GEOAssignmentRtypeDevNames = new SET<string>();
            for (BI_NA_MHC_Settings__c setting : SETTINGS.values())
                GEOAssignmentRtypeDevNames.add(setting.GeoMapRecordType__c);
            GeoAssign = new GeoAssignment(counties, GEOAssignmentRtypeDevNames);
        }
        //////////////////////////////////////////////////////////////////////////////////////////////
        public Assignment getAssignment(Id projectid, BI_NA_MHC_Settings__c setting){
            Geography_Mapping__c gm = this.getGeoMapping(projectId, setting.GeoMapRecordType__c);
            if (gm==null)
                return new Assignment(setting.FallbackOwnerId__c, setting.FallbackAccountId__c);
            else if(Test.isRunningTest() || gm!=null){//<AB20141107>
                Assignment assign = new Assignment(gm);
                if (assign.OwnerId == null) assign.OwnerId=setting.FallbackOwnerId__c;
                if (assign.AccountId == null)   assign.AccountId=setting.FallbackAccountId__c;
                return assign;
            }else{
                return new Assignment(setting.FallbackOwnerId__c, setting.FallbackAccountId__c);//<AB20141107>
            }
        }
        //////////////////////////////////////////////////////////////////////////////////////////////          
        public Geography_Mapping__c getGeoMapping(id ProjectId, string RtypeDevName){
            Geography_Mapping__c rtn;
            try{
                rtn=GeoAssign.getGeoMapping(mapPrjCounty.get(ProjectId).id,RtypeDevName);
            }
            catch (exception ex) {}
            return rtn;
        }
        /////////////////////////////////////////////////////////////////////////////////////////////
        private void getProjectCounties(List<External_Initiative__c> projects){
            if (mapPrjCounty == null)
                mapPrjCounty = new MAP<Id,Geography.County>();
            Geography.GeoAddresses geoAddrs = new Geography.GeoAddresses();
            for(External_Initiative__c cp : projects){
                if(!mapPrjCounty.containsKey(cp.Id)){//Only add non-existant to save on script statements
                    Geography.GeoAddress geoAddr = new Geography.GeoAddress(new Geography.Address(null,null,cp.State__c,null,cp.Country__c));
                    geoAddr.County=cp.County__c;
                    geoAddr.key=cp.Id;
                    geoAddrs.add(geoAddr);
                }
            }
            geoAddrs.resolveAll();
            for(Geography.GeoAddress ga : geoAddrs.getMap().values()){
                Geography.County county = ga.getCountyInfo();
                if ( county != null ){
                    system.debug('Found County! : ' + county);
                    mapPrjCounty.put(ga.key, county);
                }
            }
        }
    }//end class ProjectGeoAssignments
    /******************************************************************************************************************
GeoAssignment:
represents a set of assignments for a list of Territories (GeoIds) and assignment grouping (RecordTypes).
The recordtypes in the Geography_Mapping__c are used to segment the mappings for leveragability of the same Territory.
(In this case Tyvek Terriories are mapped to one recordtype and surfaces to another)   
constructor(s):
GeoAssignment(Set<Id> geoIds,Set<string> rTypes)        
args: 
geoIds: list of GeoIds (Geography__c.Id)
rTypes: developer name of the recordtype(s) to return           
********************************************************************************************************************/     
    public class GeoAssignment{
        //mapGeoAssignments:    MAP<GeoId, GeoMap.RType, Geography_Mapping__c>
        private Map<Id,Map<string,Geography_Mapping__c>> mapGeoAssignments;
        //////////////////////////////////////////////////////////////////////////////////////
        public GeoAssignment(Set<Id> geoIds,Set<string> rTypes){
            if (mapGeoAssignments==null)
                getAssignments(geoIds, rTypes);
        }
        //////////////////////////////////////////////////////////////////////////////////////
        public Geography_Mapping__c getGeoMapping(id geoId, string Rtype){
            try{
                return this.mapGeoAssignments.get(geoId).get(Rtype);
            }
            catch (exception ex){
                return null;
            }
        }
        //////////////////////////////////////////////////////////////////////////////////////
        private void getAssignments(Set<Id> geoIds, Set<string> RecordTypeNames){
            /*************************************************************************************
Get the geo mapping assignments for a set of geoIds
Note:  this enforces only one Geography_Mapping record per RTYPE/GeoId combination
**************************************************************************************/
            mapGeoAssignments = new Map<Id,Map<string,Geography_Mapping__c>>();
            for (Geography_Mapping__c gm : [SELECT Geography__c, Account__c, User__c, RecordType.DeveloperName 
                                            FROM Geography_Mapping__c gm
                                            WHERE RecordType.DeveloperName in : RecordTypeNames 
                                            AND User__r.IsActive = TRUE  //TESII091118
                                            AND Geography__c in: geoIds ]){
                                                if ( ! this.mapGeoAssignments.containsKey(gm.Geography__c))
                                                    this.mapGeoAssignments.put(gm.Geography__c, new Map<String,Geography_Mapping__c>() );   
                                                this.mapGeoAssignments.get(gm.Geography__c).put(gm.RecordType.DeveloperName,gm);
                                            }
        }
    }
    /******************************************************************************************************************
Assignment: represents a OwnerId (user in SFDC) and a AccountId (Account in saleforce) for a particular mapping in Geography_Mapping__c
constructor(s):
Assignment()
Assignment(Geography_Mapping__c gm)
Assignment(string ownerid, string accountid)
********************************************************************************************************************/
    public class Assignment{
        public Id OwnerId {get; set;}
        public Id AccountId {get; set;}
        //////////////////////////////////////////////////////////////////////////////////////
        public Assignment(){}
        //////////////////////////////////////////////////////////////////////////////////////
        public Assignment(Geography_Mapping__c gm){
            this.OwnerId=gm.User__c;
            this.AccountId=gm.Account__c;
        }
        //////////////////////////////////////////////////////////////////////////////////////
        public Assignment(string ownerid, string accountid){
            this.OwnerId=ownerid;
            this.AccountId=accountid;
        }
    }
    
}