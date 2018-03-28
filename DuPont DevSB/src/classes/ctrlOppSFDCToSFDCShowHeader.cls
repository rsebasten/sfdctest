/*******************************************************************************
Copyright © 2014 DuPont. All rights reserved. 
Author: Abhinav Bhatnagar
Email: abhinav.bhatnagar@dupont.com
Description:  
This controller class is created to give custom view as a VF page in the page layout.
********************************************************************************/
public with sharing class ctrlOppSFDCToSFDCShowHeader{    
    public pnrcShowHeader pnrcShowHeaderObj {get;set;}
    
   
    
    public ctrlOppSFDCToSFDCShowHeader(ApexPages.StandardController controller){//<AB20140903> Starts Constructor Method to fetch the current Account and then the Demand Object from the Account Object.
        pnrcShowHeaderObj = new pnrcShowHeader();
    }   
    
    
    public class pnrcShowHeader{
        private PartnerNetworkRecordConnection pnrcObj {get;set;}
        private PartnerNetworkConnection pncObj {get;set;}
        public boolean isShared{get;set;}
         
        public String pnrcObjId {get;set;}
        public String pnrcObjStartDate {get;set;}
        public String pnrcObjStatus {get;set;}
        public String pnrcObjEndDate {get;set;}        
        public String pncObjConnName {get;set;}
        public String pncObjConnOwner {get;set;} 
        
        
        //public String pnrcObjLocalRecordId {get;set;}
        //public String pnrcObjParentRecordId{get;set;}
        //public String pnrcObjPartnerRecordId {get;set;}
        
        public pnrcShowHeader(){
            setHeaderInfo();            
        }
        
        public void setHeaderInfo(){
            isShared = false;
            pnrcObj = getPNRCObj();
            
            if(pnrcObj!=null && pnrcObj.id!=null){
                pnrcObjId = pnrcObj.id;           
                pnrcObjStartDate = String.valueOf(pnrcObj.StartDate);
                pnrcObjStatus = getStatusLabel(pnrcObj.Status);
                pnrcObjEndDate = String.valueOf(pnrcObj.EndDate);
                
                //pnrcObjLocalRecordId = pnrcObj.LocalRecordId;
                //pnrcObjParentRecordId = pnrcObj.ParentRecordId;
                //pnrcObjPartnerRecordId = pnrcObj.PartnerRecordId;
                pncObj = getPNCObj(pnrcObj.ConnectionId);
                pncObjConnName = pncObj.ConnectionName;pncObjConnOwner = getUserName(pncObj.PrimaryContactId);
            	isShared = true;
            }
        }
        private PartnerNetworkRecordConnection getPNRCObj(){
            List<PartnerNetworkRecordConnection> obj = [SELECT ConnectionId, Id, StartDate, Status, EndDate FROM PartnerNetworkRecordConnection where localrecordid = : ApexPages.currentPage().getParameters().get('Id') ORDER BY id desc LIMIT 1];
        	return obj!=null && obj.size()>=1? obj.get(0):null;
        }
        
        private PartnerNetworkConnection getPNCObj(String pncId){
            return Database.query('SELECT ConnectionName,PrimaryContactId FROM PartnerNetworkConnection where id = \''+pncId+'\' LIMIT 1');
        }
        
        private String getUserName(String userId){
            User usr = Database.query('select name from user where id  = \''+userId+'\' LIMIT 1');
            return usr!=null? usr.Name : '';
        }
        
        private String getStatusLabel(String strStatusAPIName){
            String strStatusLabel = '';
            if(strStatusAPIName!=null){
                Map<String,String> mapStatusAPINameAndLabel = new Map<String,String>() ;
                
                mapStatusAPINameAndLabel.put('Received',  'Active (received)');
                mapStatusAPINameAndLabel.put('Sent',  'Active (sent)');
                mapStatusAPINameAndLabel.put('Connected',  'Connected');
                mapStatusAPINameAndLabel.put('Inactive',  'Inactive');
                mapStatusAPINameAndLabel.put('Converted',  'Inactive (converted)');
                mapStatusAPINameAndLabel.put('Deleted',  'Inactive (deleted)');
                mapStatusAPINameAndLabel.put('Invite',  'Pending (sent)');
                mapStatusAPINameAndLabel.put('InboundSuspended',  'Inbound Suspended');
                mapStatusAPINameAndLabel.put('OutboundSuspended',  'Outbound Suspended');
                
                strStatusLabel = mapStatusAPINameAndLabel.containsKey(strStatusAPIName)?mapStatusAPINameAndLabel.get(strStatusAPIName):'';
            }
            return strStatusLabel;
        }
    }
}