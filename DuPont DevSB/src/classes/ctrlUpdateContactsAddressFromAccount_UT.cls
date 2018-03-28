/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author:Rajiv Kumar Bhatter
Email:rajiv.bhatter@usa.dupont.com
Description:  Unit test for ctrlUpdateContactsAddressFromAccount
********************************************************************************/

@isTest
public class ctrlUpdateContactsAddressFromAccount_UT
{

    static testMethod void testMethod1()
    {
        //Test Account
        Account acc = new Account();
        acc.Name='test Account';
        insert acc;
        
        //Test contact
        Contact con = new contact();
        con.LastName='test';
        con.firstname='FirstName';
        con.accountId = acc.id;
        insert con;
        
        List<Contact> List_contact = new List<Contact>();
        List_contact.add(con);
        
        Pagereference pg = page.UpdateContactsAddressFromAccount;
        pg.getParameters().put('id',acc.id);
        Test.setCurrentPage(Pg);
        
        ctrlUpdateContactsAddressFromAccount controller = new ctrlUpdateContactsAddressFromAccount ();
        controller.init();
        controller.useSecondary = true;
        String BillingAddress = controller.BillingAddress;
        string ShippingAddress = controller.ShippingAddress;
        controller.UpdateContacts();
        controller.getListOfContacts();
        controller.refresh();
        controller.toogleSelect();
        ctrlUpdateContactsAddressFromAccount.ContactRow cntct= new ctrlUpdateContactsAddressFromAccount.ContactRow(con);
        cntct.MailingOption = 'current';
        cntct.selMailingAddress = 'Current';
        cntct.selotherAddress = 'current';
        cntct.MailingAddress = 'current';
        cntct.otherAddress = 'current';
        ctrlUpdateContactsAddressFromAccount.ContactRows cntcts= new ctrlUpdateContactsAddressFromAccount.ContactRows(List_contact);
        cntcts.AllMailing();
        cntcts.AllOther();
        cntcts.AllToBilling();
        cntcts.AllToShipping();
        cntcts.AllToCurrent();
        //controller.AllOther();
        //controller.AllToBilling();
        geography.geoAddress bAddress = controller.bAddress;
        geography.geoAddress sAddress = controller.sAddress;
        controller.Cancel();
        
    }

}