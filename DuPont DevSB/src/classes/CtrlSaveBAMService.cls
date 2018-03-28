/*******************************************************************************
(C)2016
Author: Pallavi Sharma
Email: pallavi.sharma3@tcs.com
Description:  This class will save SAP&HAP combination selected by the customer as a part of solution package
 ********************************************************************************/

@RestResource(urlMapping='/SaveBAM/*')
global class CtrlSaveBAMService {
	
    //wrapper class
    public class BamWrapper{
        public String bacConfigurationID;
    	public List<cls_solutions> solutions;
    }
    public class cls_solutions{
        public String sapSolutionID;
        public String hapSolutionID;
    }
    
    @HttpPost
    global static CtrlKevlarSvcHelper.ReturnClass doPost(){
        CtrlKevlarSvcHelper h = new CtrlKevlarSvcHelper(); 
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        Map<String,List<String>> sapToHapSolIdMap=new Map<String,List<String>>();
        List<Body_Armor_Solution__c> sapSolList=new List<Body_Armor_Solution__c>();
        List<Body_Armor_Solution__c> sapSolListDB=new List<Body_Armor_Solution__c>();
        Boolean IsHAPEmpty=false;
        
        try{
           	BamWrapper tWrap = (BamWrapper) JSON.deserialize(req.requestBody.toString(), BamWrapper.class);
            sapSolListDB=[select Related_To_BAM_HAP_1__c,Related_To_BAM_HAP_2__c,Related_To_BAM_HAP_3__c,IsSelectedBAM__c
                         from Body_Armor_Solution__c where BA_Configuration__c=:tWrap.bacConfigurationID AND 
                         RecordType.DeveloperName='SAP_Solution'];
            Map<String,Body_Armor_Solution__c> allSapSolMap=new Map<String,Body_Armor_Solution__c>();
            for(Body_Armor_Solution__c bs : sapSolListDB){
                allSapSolMap.put(bs.Id, bs);
            }
            system.debug('allSapSolMap : ' + allSapSolMap);
            for(cls_solutions cs : tWrap.solutions){
                if(String.isBlank(cs.hapSolutionID)){
                    IsHAPEmpty=true;
                    break;
                }
            }
            for(cls_solutions cs : tWrap.solutions){
                List<String> temp;
                if(sapToHapSolIdMap.containsKey(cs.sapSolutionID)){
                    temp=sapToHapSolIdMap.get(cs.sapSolutionID);
                }
                else{
                    temp=new List<String>();
                }
                temp.add(cs.hapSolutionID);
                sapToHapSolIdMap.put(cs.sapSolutionID, temp);
            }
            system.debug('sapToHapSolIdMap : ' + sapToHapSolIdMap);
            for(String sapSolId : allSapSolMap.keySet()){
                system.debug('sapSolId : ' + sapSolId);
                Body_Armor_Solution__c sapBas=new Body_Armor_Solution__c(Id=sapSolId);
                sapBas.Related_To_BAM_HAP_1__c=null;
                sapBas.Related_To_BAM_HAP_2__c=null;
                sapBas.Related_To_BAM_HAP_3__c=null;
                sapBas.IsSelectedBAM__c=false;
                if(sapToHapSolIdMap.containsKey(sapSolId)){
                    sapBas.IsSelectedBAM__c=true;
                    if(IsHAPEmpty!=true){
                        if(sapToHapSolIdMap.get(sapSolId).size()==1){
                            for(String hapSolId:sapToHapSolIdMap.get(sapSolId)){
                                sapBas.Related_To_BAM_HAP_1__c=hapSolId;
                            }
                        }
                        else if(sapToHapSolIdMap.get(sapSolId).size()==2){
                            sapBas.Related_To_BAM_HAP_1__c=sapToHapSolIdMap.get(sapSolId)[0];
                            sapBas.Related_To_BAM_HAP_2__c=sapToHapSolIdMap.get(sapSolId)[1];
                        }
                        else if(sapToHapSolIdMap.get(sapSolId).size()==3){
                            sapBas.Related_To_BAM_HAP_1__c=sapToHapSolIdMap.get(sapSolId)[0];
                            sapBas.Related_To_BAM_HAP_2__c=sapToHapSolIdMap.get(sapSolId)[1];
                            sapBas.Related_To_BAM_HAP_3__c=sapToHapSolIdMap.get(sapSolId)[2];                                                
                        } 
                    }
                }
                sapSolList.add(sapBas);  
            }
            if(sapSolList.size()>0){
                update sapSolList;
            }
            return new CtrlKevlarSvcHelper.ReturnClass(h.dataSent, h.getMessage('200'),h.getResponseMessage('544'),'544', null, null, '544','null');         
        }
        catch(Exception e){
            System.debug('Error----------'+e.getMessage());
            return new CtrlKevlarSvcHelper.ReturnClass(h.dataNotSent, h.getMessage('203'),e.getMessage(),null,null,null, '203',null);
        }
    }
}