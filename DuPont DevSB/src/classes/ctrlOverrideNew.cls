public class ctrlOverrideNew {

    private static sobject so;
    
    
    //constructor
    public ctrlOverrideNew(ApexPages.StandardController controller) {
        so=controller.getRecord();
        }
    
    public ctrlOverrideNew() {}

        
    public PageReference init() {
        PageReference returnURL;
        
        //if (returnURL==null) CLS.redirectCLSMember(so);
                 
        if (returnURL==null){ 
            System.debug('so is '+so);
        //returnURl=CUPS.redirectNewCUPSRequest(so);
        }

        //Return to standard Page
        if (returnURL==null && !ApexPages.hasMessages(ApexPages.SEVERITY.ERROR)) 
            returnURL=defaultFields.onOverrideNew(so);        
        return returnURL;  
        
    }
    
}