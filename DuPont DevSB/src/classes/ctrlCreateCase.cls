/*******************************************************************************
Copyright © 2014 DuPont. All rights reserved. 
Author: Sravanthi Lakkimsetty
Email: sai-sravanthhi.lakkimsetty@bra.dupont.com
Description:  Controller for page: CreateCase T
To redirect to a General Enquiry Case with certain fields autopopulated for Community Users
 ********************************************************************************/

public class ctrlCreateCase{

    public Pagereference redirect(){
        String conId = [select contactid from user where id = :UserInfo.getUserId() ].contactId;
        if(conId != null && conId != ''){
            String accId = [select accountId from contact where id =:conId ].accountId;
            String RtypeId = [select Id,Name from RecordType where Name='General Inquiry'].Id;
            Pagereference page  = new Pagereference('/DPTPartnerCommunity/500/e?RecordType='+RtypeId+'&cas3_lkid='+conId+'&cas4_lkid='+accId);
            return page;
        }
        else
            return null;
    }
}