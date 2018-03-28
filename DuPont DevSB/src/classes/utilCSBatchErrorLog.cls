/**
 * @author sanchit.dua@accenture.com
 *
 */
public with sharing class utilCSBatchErrorLog {
    public Map<Id, String> erpIdWithMsg {get;set;}
    public Set<Id> erpIds {get;set;}
    public Set<String> commonMessages {get;set;}
    public List<InsertReporter> consolidatedMsgs {get;set;}
    private static final String INITIAL_VAL = '';
    
    /**
     * Default CONSTRUCTOR 
     */
    public utilCSBatchErrorLog(){
        this.erpIdWithMsg = new Map<Id, String>();
        this.erpIds = new Set<Id>();
        this.commonMessages = new Set<String>();
        this.consolidatedMsgs = new List<InsertReporter>();  
    } // END init()

    /**
     * @author sanchit.dua
     *
     */
    public with sharing class InsertReporter{
        public String erpId;
        public String errMsg;
        
        /**
         * Parameterized CONSTRUCTOR
         * @param erpId - The customer ERP ID
         * @param errMsg - The error message we got during the DML operation is initialized in this String
         */
        public InsertReporter(String erpId, String errMsg) {
            this.erpId = erpId;
            this.errMsg = errMsg;            
        } // END init(String erpId, String errMsg)

    }

}