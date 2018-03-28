public class ProductsChanged {

   Qualification__c listQualification  = new Qualification__c(); 
    boolean isProductButtonDisabled = false;
    string urlForTriggeringDDPSchedule = '/apex/loop__looplus?eid={Qualification.id}';
    private final Qualification__c Qualification;
    String DDPName=null;
    Map<string,string> TypeID=new Map<string,string>();
    string DDPID=null;
    

    public ProductsChanged(ApexPages.StandardController controller) {
        Qualification=  (Qualification__c)Controller.getRecord();
        listQualification  = [select id, Products_Changed__c, BI_Product_Changed_DDP_Name__c, Certified_In_Area__c from Qualification__c where id = :Qualification.id  ];
        
        system.debug('id: '+ Qualification.Id);
        system.debug('Products_Changed: '+ listQualification  );
            if(listQualification.Products_Changed__c == true){
                isProductButtonDisabled = false;
                DDPName=listQualification.BI_Product_Changed_DDP_Name__c;
                for(Loop__DDP_Integration_Option__c  loopOption:[select id,RecordType.Name,RecordTypeId,Loop__DDP__r.ID from Loop__DDP_Integration_Option__c where Loop__DDP__r.Loop__Filter__c=:DDPName]){
                TypeID.put(loopOption.RecordType.Name,loopOption.id);
                 if(DDPID!=null){
                 DDPID=loopOption.Loop__DDP__r.ID;
                 }
                }
            }
            else 
                isProductButtonDisabled = true;
        }
  
    
    public boolean getisProductButtonDisabled () {
          return isProductButtonDisabled;  
    }

    public string geturlForTriggeringDDP () {
          return urlForTriggeringDDPSchedule;  
    }


    public PageReference urlForTriggeringDDP() {
        String OpenPageUrl = '/apex/loop__looplus?eid='+Qualification.id+'&filter='+DDPName+'&autorun=true';
        
        
        PageReference newPage = new PageReference(OpenPageUrl);
        newPage.setRedirect(true);
        
        string drawloopNextField = null;
        
        drawloopNextField='SFQualification__c:'+Qualification.id+';Deploy:'+TypeID.get('Email')+';DDPId:'+DDPID+';DeployType:autoemail';
        
        listQualification.Drawloop_Next_Schedule_1A_Email__c = drawloopNextField; 
        update listQualification;
        return newPage;
        
    }

}