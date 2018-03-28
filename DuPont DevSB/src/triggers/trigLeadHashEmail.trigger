/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 

<VL20170428>
Modified By: Vijay Laxmi
Modification Date: 28-Apr-2017
Modification: Added if conition to not run the trigger for CPSF Project Lead creation

********************************************************************************/

trigger trigLeadHashEmail on Lead (before insert, before update) {
 //<VL20170428>start
if( !BI_CPUtil.CPSF_leadTrigPass){
//<VL20170428>End
    for (Lead l : Trigger.new) {
        if (l.email!=null) 
            l.EmailHash__c = System.Encodingutil.base64Encode(Blob.valueof(l.email));
    }
}
}