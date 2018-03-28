public with sharing class ServiceContractHandler extends TriggerHandlerBase {
    
    public override void afterInsert(SObject so){
        addEntitlement();
    }
        
    public void addEntitlement(){   
        LIST<Entitlement> insertEntitle = new LIST<Entitlement>();
        String warrantyCode;
        String owingOrg;
        List<Material__c> matList = new list<Material__c>();        
        // create a set of all the unique material ids for SOQL below
        Set<id> matIds = new Set<id>();
        for (Sobject so  : Trigger.new){
            servicecontract  servcon = (servicecontract)so;
            matIds .add(servcon.Material__c);
        }       
        // create a map so that material is locatable by its Id (key)
        matList =[SELECT id,Owning_Org__c FROM Material__c WHERE Id IN :matIds];
        Map<id, String> matsMap = new Map<id, String>();        
        matsMap.put(matList[0].id,matList[0].Owning_Org__c);    
        Id entRecTypeId=ctrlBIeWarrantyInput.ENTRECTYPEID;
        for(Sobject so  : this.getRecordsByRT('BI_EMEA_Service_Contract').values()){
            servicecontract  servcon = (servicecontract)so;
            for (Integer i=Integer.valueOf(servcon.Entitlement_Start_Code__c); i<=Integer.valueOf(servcon.Entitlement_End_Code__c); i++) {
                string s=ctrlBIeWarrantyCodeCreation.leftPad(String.valueOf(i),7,'0');
                string chkcode=ctrlBIeWarrantyCodeCreation.encode(s);
                owingOrg=matsMap.get(servcon.Material__c);
                warrantyCode = owingOrg+s+chkcode;
                insertEntitle.add(new Entitlement(RecordTypeId=entRecTypeId,AccountId=servcon.AccountId,Name='BI EMEA ewarranty'+i,Entitlement_Code__c=warrantyCode,ServiceContractId=servcon.Id));    
            }       
        }       
        if(insertEntitle.size() > 0){
            system.debug('insert entitle');
            insert insertEntitle;
        }
    }
}