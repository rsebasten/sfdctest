/*******************************************************************************
(C)2015
Author: Pallavi Sharma
Email: pallavi.sharma3@tcs.com
Description:  This class returns the success on change of BAC progress
 ********************************************************************************/
 
 @RestResource(urlMapping='/UpdateCampaignProgress/*')
global class CtrlUpdateCampaignProgressService {
    @HttpPost
    global static CtrlKevlarSvcHelper.ReturnClass doPost(){
        CtrlKevlarSvcHelper h = new CtrlKevlarSvcHelper(); 
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String prettyJson = '';
        Boolean isChanged = false;
        List<BA_Configuration__c> bacList = new List<BA_Configuration__c>();
		Map<String,integer> progressMap = new Map<String,integer>();
		
        
        try{
            system.debug('req.requestBody : ' + req.requestBody.toString());
            UpdateCampaignProgressWrapper tWrap = (UpdateCampaignProgressWrapper) JSON.deserialize(req.requestBody.toString(), UpdateCampaignProgressWrapper.class);  
			Schema.DescribeFieldResult progressStatus = BA_Configuration__c.BAC_Progress__c.getDescribe();
			List<Schema.PickListEntry> progressValues = progressStatus.getPicklistValues();
			for(Integer i=0;i<progressValues.size();i++)
					{
						progressMap.put(progressValues[i].getvalue(),i);                     
					}  			
            BA_Configuration__c bac = [select id,name,BAC_Progress__c from BA_Configuration__c where id =:tWrap.bacConfigurationID limit 1];
            if(!String.isBlank(tWrap.bacProgress) && progressMap.containsKey(tWrap.bacProgress) && progressMap.containsKey(bac.BAC_Progress__c)){
                
                if(progressMap.get(tWrap.bacProgress) > progressMap.get(bac.BAC_Progress__c)){
				bac.BAC_Progress__c = tWrap.bacProgress;
				 bacList.add(bac);
				 isChanged = true;
				}
                if(bacList.size()>0){
                    database.update(bacList);
                }
            }
           if(!String.isBlank(tWrap.bacProgress) && isChanged){
                return new CtrlKevlarSvcHelper.ReturnClass(h.dataSent, h.getMessage('200'),h.getResponseMessage('200'),'200', prettyJson, null, '200','null');         
            }
            else
            {
                return new CtrlKevlarSvcHelper.ReturnClass(h.dataSent, h.getMessage('205'),h.getResponseMessage('205'),'205', prettyJson, null, '200','null');            
            }
        }
        catch(Exception e){
            return new CtrlKevlarSvcHelper.ReturnClass(h.dataNotSent, h.getMessage('203'),null,null,'Update failed!' ,null, '203',null);
        }
        
    }
    //wrapper classes start
    global class UpdateCampaignProgressWrapper{
        public String bacConfigurationID;
        public String bacProgress;
    }
 }