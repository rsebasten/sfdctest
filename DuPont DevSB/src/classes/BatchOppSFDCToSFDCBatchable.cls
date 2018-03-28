global class BatchOppSFDCToSFDCBatchable implements Database.Batchable <sObject> { 
    
    private String strSoql;
    Opp_ParkSite_Batch_Assertion__c dataSOQL = Opp_ParkSite_Batch_Assertion__c.getOrgDefaults();
    private static final String CALLEDFROMBATCH = 'Batch';
    private static final String CONNECTIONNAME = 'Parksite Inc'; //Name of the SFDC TO SFDC Connection
    private static final String CONNECTIONSTATUS = 'Accepted'; //Status of the connection should be Accepted
    
    // constructor, which sets up our initial soql
    public BatchOppSFDCToSFDCBatchable() {
        strSoql = 'SELECT ';
        string strComma = '';
        for (string strF : listStrOppFields) {
            strSoql += strComma + strF;
            strComma = ', ';
        }
        strSoql += ' FROM ' + Schema.SobjectType.Opportunity.Name;
        strSoql += ' WHERE Id <> null ';
        
        if (dataSOQL <> Null){
           if (dataSOQL.Parksite_Batch_Assertion__c <> null) {
               String parkSiteBatch = dataSOQL.Parksite_Batch_Assertion__c;
               strSoql += ' AND Parksite_Batch_Assertion__c=\'' + parkSiteBatch+ '\'';
               if (dataSOQL.Additional_SOQL__c <> null) {
                   String additionalSOQL = dataSOQL.Additional_SOQL__c;
                   strSoql += ' AND ' + additionalSOQL;
               }
            }
        }
        System.debug('strSoql is '+ strSoql);
    }
    
    global Database.QueryLocator start(Database.BatchableContext batchableContext) {
        return Database.getQueryLocator(strSoql);     
    }
    
    global void execute(Database.BatchableContext batchableContext, Opportunity[] records) {
        List<Opportunity> validOppList = new List<Opportunity>();
        
        for (Opportunity opp : records) {
            validOppList.add(opp);
        }
        
        if (!validOppList.isEmpty()) {
            //ctrlOppSFDCToSFDC cos2s = new ctrloppSFDCToSFDC(validOppList);
            //validOppList = cos2s.callSFDCToSFDC(CALLEDFROMBATCH,null);
            pushOpportunityRecords(CALLEDFROMBATCH,null,validOppList);
        }
    }
    
    global void finish(Database.BatchableContext batchableContext) {
    }
    
    // utility to return all fields from the Opportunity object
    private static list<string> listStrOppFields { 
        get {
            if (listStrOppFields == null) {
                Map<String, Schema.SObjectField> mapS = Schema.SObjectType.Opportunity.fields.getMap();
                listStrOppFields = new list<string>();
                listStrOppFields.addAll(mapS.keySet());                         
            }
            return listStrOppFields;
        }
        set;
    } 
    
    private void pushOpportunityRecords(String strCalledFrom, String trigCriteria, List<Opportunity> validOpps){
       List<Opportunity> validOppList = new List<Opportunity>();
       if(strCalledFrom == CALLEDFROMBATCH){// Check whether batch has called the method
            validOppList = validOpps; //Assign the raw list directly as the list is already validated through query fetching.
        }else{
            validOppList = new List<Opportunity>(); //Default exit statement
        } 
        if(validOppList!=null && validOppList.size()>0){//if There is any opportunity to be transffered
            PartnerNetworkConnection pncObject =  getPartnerNetworkConnection();//Get the Partner Network Connection 
            List<PartnerNetworkRecordConnection> pnrcObject = new List<PartnerNetworkRecordConnection>();
            for(Opportunity opp : validOppList) { // For each valid opportunity to be sent   
                PartnerNetworkRecordConnection newrecord = new PartnerNetworkRecordConnection();            
                newrecord.ConnectionId = pncObject.Id;
                newrecord.LocalRecordId = opp.id;  
                pnrcObject.add(newrecord);   
            }   
            
            try{
                insert pnrcObject; //Send the opportunities if not a test
            }catch(Exception e){                    
                 System.debug(' In Method ---> pushOpportunityRecords Error occured '+e);
            }
                               
        }
    }
    
     /* Method to fetch valid partner network connection */
    private PartnerNetworkConnection getPartnerNetworkConnection(){
        List<PartnerNetworkConnection> connMap = new List<PartnerNetworkConnection>(
            [select Id, ConnectionStatus, ConnectionName from PartnerNetworkConnection where ConnectionStatus = : CONNECTIONSTATUS and ConnectionName  = : CONNECTIONNAME LIMIT 1]
        );
        
        return connMap[0];
    } 

}