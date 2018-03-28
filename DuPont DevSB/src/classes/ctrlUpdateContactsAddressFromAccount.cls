/*******************************************************************************
Copyright © 2010 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Controller for page: UpdateContactsAddressFromAccount

TES20131023:  unhandled exception when account is null/inaccessible
********************************************************************************/
public with sharing class ctrlUpdateContactsAddressFromAccount {

public  string                  addressType         {get; set;}
private MAP<ID,Contact>         contacts            {get; set;}
public  ContactRows             selectContacts      {get; set;}
@testvisible
public boolean useSecondary { GET {return (addressType=='shipping');} }
public Account account { GET { return (contacts!=null && contacts.size()>0) ? contacts.values()[0].account : null; } }


public string BillingAddress {
    GET { return (bAddress!=null) ? bAddress.address.blockformatHtml() : null; }
}
public string ShippingAddress {
    GET { return (sAddress!=null) ? sAddress.address.blockformatHtml() : null; }
}

public geography.geoAddress bAddress {
    GET { return (account!=null) ? new geography.geoAddress(account) : null; }
}
public geography.geoAddress sAddress {
    GET { return  (account!=null) ? new geography.geoAddress(account,true): null; }
}


public PageReference init() {
    addressType='billing';
    getContacts(ApexPages.currentPage().getParameters().get('id'));
    selectContacts = new ContactRows(contacts.values());
    return null;
}


public PageReference UpdateContacts() {
    
    List<Contact> contactsToUpdate = new List<Contact>();
    for (ContactRow c : selectContacts.allRows) {
        if (c.MailingOption!='current') {
            c.mAddress.writeTo(c.Contact,false);
            c.Contact.MailingCountry='';
        }
        if (c.OtherOption!='current')
            c.oAddress.writeTo(c.Contact,true); {
            c.Contact.OtherCountry='';
        }
            
        if (c.OtherOption!='current' || c.MailingOption!='current') 
            contactsToUpdate.add(c.contact);
    }
    if (contactsToUpdate.size()>0)
        update contactsToUpdate;
        
    return gotoAccount();
    
}


public PageReference Cancel() {
    //return gotoAccount();
    return gotoAccount();
}

private PageReference gotoAccount() {
    string accountid = (account!=null) ? account.id : ApexPages.currentPage().getParameters().get('id');
    PageReference p = new PageReference('/'+accountid);
    p.setredirect(true);
    return p;
}


    private void getContacts(String id) {
        try {
            contacts = new MAP<id,Contact>([
                Select a.Id, a.Name, a.Country__c, a.Region__c, a.SubRegion__c,
                    a.BillingStreet, a.BillingCity, a.BillingState, a.BillingPostalCode, a.BillingCountry, a.BillingStateName__c,
                    a.BillingCounty__c, a.BillingFIPS__c, a.BillingCityDistrict__c, a.BillingLongitude__c, a.BillingLatitude__c, a.BillingAddressAccuracy__c,
                    a.ShippingStreet, a.ShippingCity, a.ShippingState, a.ShippingPostalCode, a.ShippingCountry, a.ShippingStateName__c,
                    a.ShippingCounty__c, a.ShippingFIPS__c, a.ShippingCityDistrict__c, a.ShippingLongitude__c, a.ShippingLatitude__c, a.ShippingAddressAccuracy__c,
                    c.Id, c.Name, c.Role__c, c.Contact_Country__c, c.Region__c, c.SubRegion__c,
                    c.MailingStreet, c.MailingCity, c.MailingState, c.MailingPostalCode, c.MailingCountry, c.MailingStateName__c,
                    c.MailingCounty__c, c.MailingFIPS__c, c.MailingCityDistrict__c, c.MailingLongitude__c, MailingLatitude__c, c.MailingAddressAccuracy__c,
                    c.OtherStreet, c.OtherCity, c.OtherState, c.OtherPostalCode, c.OtherCountry //, OtherStateName__c
                From Contact c, c.Account a
                where a.id= : Id
                ]);
        }
        catch (Exception ex) {
            ApexPages.addMessages(ex);
        }   
    }


    public LIST<SelectOption> getListOfContacts() {
         LIST<SelectOption> rtn = new LIST<SelectOption>();
        for (Contact c : contacts.values() ) {
             string lbl = '<b>Name:</b> '+c.name+' <b>Mailing Address:</b> '+new geography.address(c).format()+' <b>Other Address:</b> '+new geography.address(c,true).format();
             SelectOption so  = new SelectOption(c.id, lbl);
             so.setEscapeItem(false);
             rtn.add(so);
             
        }
        return rtn;
    }
    
    public void refresh() {
        
    }
    public void toogleSelect() {
        
    }

    public class ContactRows {
        public List<ContactRow> allRows  {get; set;}
        public string MailingRadio       {get; set;}
        public string OtherRadio         {get; set;}    
        @testvisible
        ContactRows(LIST<Contact> cs) {
            MailingRadio = 'current';
            OtherRadio = 'current';
            allRows = new List<ContactRow>();   
            for (Contact c : cs)
                allRows.add(new ContactRow(c));
        }
        
        /*
        public List<ContactRow> getSelectedRows() {
            List<ContactRow> rtn = new List<ContactRow>();
            if (allRows!=null && allRows.size()>0) {
                for (ContactRow s : allRows)
                    if (s.selected) rtn.add(s);
                }
            return rtn;
        }*/
        public void AllMailing() {
            for (ContactRow s : allRows ) {
                s.MailingOption=MailingRadio;
            }
        }
        public void AllOther() {
            for (ContactRow s : allRows ) {
                s.OtherOption=OtherRadio;
            }
        }   
        private void SetAll(string setting) {
            for (ContactRow s : allRows ) {
                s.MailingOption=setting;
                s.OtherOption=setting;
            }
        }
        
        public void AllToBilling() {
            SetAll('billing');
        }
        public void AllToShipping() {
            SetAll('shipping');
        }
        public void AllToCurrent() {
            SetAll('current');
        }
    }
    
    
   
    public class ContactRow {
        public string MailingOption     {get; set;} 
        public string OtherOption       {get; set;} 
        public string name              {get; private set;}
        public Contact contact          {get; set;}
        @testvisible
        ContactRow(Contact c) {
            this.MailingOption='current';
            this.OtherOption='current';
            this.name=c.name;
            this.contact=c;
        } 
        
        private boolean useSecondary() {
            return true;
        }
        public Geography.geoAddress mAddress {
            GET {
            if (MailingOption=='shipping')
                return new geography.geoaddress(contact.account,true);  
            else if (MailingOption=='billing')
                return new geography.geoaddress(contact.account,false); 
            else
                return new geography.geoaddress(contact);
        } }
        
        public Geography.geoAddress oAddress {
            GET {
            if (OtherOption=='shipping')
                return new geography.geoaddress(contact.account,true);  
            else if (OtherOption=='billing')
                return new geography.geoaddress(contact.account,false); 
            else
                return new geography.geoaddress(contact,true);
        }}
        @testvisible
        public string selMailingAddress { GET { return mAddress.address.blockformatHtml(); }}
        @testvisible
        public string selotherAddress    { GET { return oAddress.address.blockformatHtml(); }}
        @testvisible
        public string MailingAddress { GET { return new geography.geoaddress(contact,false).address.blockformatHtml(); }}
        @testvisible
        public string otherAddress   { GET { return new geography.geoaddress(contact,true).address.blockformatHtml(); }}

    }
    

        

        
}