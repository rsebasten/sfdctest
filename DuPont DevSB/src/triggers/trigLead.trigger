/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Core trigger for Lead
NS20160303 - For PopulatePreferredLanguage in Lead Object

<VL20170428>
Modified By: Vijay Laxmi
Modification Date: 28-Apr-2017
Modification: Added if conition to not run the trigger for CPSF Project Lead creation
********************************************************************************/
trigger trigLead on Lead (before insert, before update, after insert, after update, after delete, after undelete) {
   //<VL20170428>start
   if( !BI_CPUtil.CPSF_leadTrigPass) { 
    //<VL20170428>End
    LeadHandler lh = new LeadHandler();
    //Modified on 3/3/2016 For PopulatePreferredLanguage in Lead Object NS20160303
    LeadHandler.PopulatePreferredLanguage(Trigger.new);
    lh.onTrigger();
}
}