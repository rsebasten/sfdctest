global class SandboxPostRefreshCleanup implements SandboxPostCopy {

    global void runApexClass(SandboxContext context) {
        try {
	        system.debug(
	            'SandboxPostRefreshCleanup::runApexClass, ' 
	            + ' orgId = ' + context.organizationId() 
	            + ' sandboxId = ' + context.sandboxId() 
	            + ' sandboxName ' + context.sandboxName()
	        );
	        if (isSandbox()) {
	            deleteObsoleteDocuments();            
	        }
        } catch (Exception e) {
            system.debug('SandboxPostRefreshCleanup::runApexClass, error = ' + e);
        }
    }
    
    private void deleteObsoleteDocuments(){
        Document[] docsToBeDeleted = [Select id From Document where Type='pdf' or Type='zip'];
        system.debug('Deleting ' + docsToBeDeleted.size() + ' documents: ' + docsToBeDeleted);
        delete docsToBeDeleted;
        
    }
    
    private boolean isSandbox(){
        boolean isSandbox = false;
        Organization org = [Select IsSandbox from Organization limit 1];
        isSandbox = org.isSandbox;
        return isSandbox;
    }
}