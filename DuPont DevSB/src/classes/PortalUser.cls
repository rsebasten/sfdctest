/*******************************************************************************
Copyright © 2011 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  PortalUser helper class
SJAGA 14-Aug-2012 -- Retrieving the Contact Mailing address Info for Portal User 
********************************************************************************/
public virtual without sharing class PortalUser {
 
    private static PortalUser           instance = null;
    private static Contact              c;

    public id       contactId               {GET { return ( c!=null) ? c.id                     : null; } }
    public id       accountId               {GET { return ( c!=null) ? c.accountid              : null; } }
    public string   accountName             {GET { return ( c!=null) ? c.account.name           : null; } }
    public string   firstName               {GET { return ( c!=null) ? c.firstName              : null; } }
    public string   lastName                {GET { return ( c!=null) ? c.lastName               : null; } }
    public string   mailingcity             {GET { return ( c!=null) ? c.MailingCity            : null; } } //SJAGA 14-Aug-2012
    public string   mailingstate            {GET { return ( c!=null) ? c.MailingState           : null; } } //SJAGA 14-Aug-2012
    public string   mailingstreet           {GET { return ( c!=null) ? c.MailingStreet          : null; } } //SJAGA 14-Aug-2012
    public string   mailingcountry          {GET { return ( c!=null) ? c.MailingCountry         : null; } } //SJAGA 14-Aug-2012
    public string   mailingpostalcode       {GET { return ( c!=null) ? c.MailingPostalCode      : null; } } //SJAGA 14-Aug-2012
    public string   email                   {GET { return ( c!=null) ? c.email                  : null; } }
    public string   Country                 {GET { return ( c!=null) ? c.account.Country__c     : null; } } 
    public string   userType                {GET { return UserInfo.getUserType(); } }   
            
    protected PortalUser() {
        
        if (UserInfo.getUserType().toLowerCase()=='guest')
            //check to see if a MemberPortal 
            try {
                PageBase pb = PageBase.getInstance();
                if (pb.memberInfo!=null) {
                    MemberPortal.Profile mprofile = pb.memberInfo.Profile;
                    if (mprofile!=null)
                    //SJAGA 14-Aug-2012
                        c = [Select id, firstname, lastname, MailingCity,MailingCountry,MailingState,MailingStreet,MailingPostalCode,email, AccountId, Account.Name,Account.Country__c  
                                From Contact where id=:mprofile.contactid];
                }
            }catch(Exception ex){}
        else {
            //Check if partner/customer portal user
            User u = [Select Contactid, Contact.id, Contact.firstname, Contact.MailingCity,Contact.MailingCountry,Contact.MailingState,Contact.MailingStreet,Contact.MailingPostalCode,Contact.lastname, Contact.email, Contact.AccountId, Contact.Account.Name, Contact.Account.Country__c  
                From User where id=:UserInfo.getUserId()];
            if (u.Contactid!=null)
                c=u.Contact;
        }
    }
    
    public static PortalUser getInstance() {
      if(instance == null) {
         c=null;
         instance = new PortalUser();
      }
      return instance;
   }

    public static Account getAccount() {
        if (getInstance().accountId!=null) {
            Util.Describe descr  = new Util.Describe('Account');
            return (Account) descr.getObject(instance.accountId);
        }
        else return null;
    }
    
    public static Contact getContact() {
        if (getInstance().contactId!=null) {
            Util.Describe descr = new Util.Describe('Contact');
            return (Contact) descr.getObject(getInstance().contactId);
        }
        else return null;
    }   
    
}