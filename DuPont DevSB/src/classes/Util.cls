public with sharing class Util {

    public static String instanceName {
        GET {
            if (instanceName == null)
                initializeOrgDetails();
            return instanceName;
        }
    }

    public static boolean isSandbox {
        GET { 
            if (isSandbox == null) 
                initializeOrgDetails();
            return isSandbox;     
       }
    }
       
    public static void initializeOrgDetails() {
        Organization currOrg = [select id, name, isSandbox, instanceName from Organization limit 1];
        system.debug('Current Org = ' + currOrg);
        isSandbox = false;
        if (currOrg != null) {
            instanceName = currOrg.instanceName;
            isSandbox = currOrg.isSandbox;
        }
        system.debug('instanceName = ' + instanceName + ', isSandbox = ' + isSandbox);
    }
}