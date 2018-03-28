/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Trigger Handler for ERPCustomer__c 
********************************************************************************/
public class ERPCustomerHandler extends TriggerHandlerBase {

public static final string RTYPE_ERP_ACCOUNT = Rtype.getIdByDevName('Account','ERP_Account');

  public override void bulkafter(){
        if ( Trigger.IsUpdate || Trigger.IsInsert ) {
            processAccountSync();
             /*<SravanthiLakkimsetty20140918>
            Description: call the class method for Attaching the ERP customer with Account...
            <--ChangesStarted-->*/
            ctrlLinkERPCustToAccount ctrlLinkERPCustToAccountinstance = new ctrlLinkERPCustToAccount();
            ctrlLinkERPCustToAccountinstance.onTrigger();
             //<--ChangesFinished-->  
        }
    }


//*****************************************************************************************
// helper Methods
//*****************************************************************************************

   public static void processAccountSync() {
    
        LIST<Account> accountsToUpsert = new LIST<Account>();
        for( ERP_Customer__c cust : [ SELECT Id, Name, Customer_Code__c, Account_Group__c, DUNS_Number__c, Terms_of_Payment__c,
                        ZIP_Postal_Code__c, Street__c, State_Province__c, PO_Box__c, Country__c, Country_Code__c, City__c,
                        OrgGroup__r.OwnerId, OrgGroup__r.Account_Rule__c, External_ERP_ID__c,
                        (Select Id from Accounts__r)
                        FROM ERP_Customer__c 
                        WHERE Id in: Trigger.new] ) {
            
            //Does this SalesArea subscribe to this Customer's Account group?
            system.debug('------cust.Account_Group__c:'+cust.Account_Group__c);
            system.debug('------cust.OrgGroup__r.Account_Rule__c:'+cust.OrgGroup__r);
            if ( cust.OrgGroup__r.Account_Rule__c!=null && ( cust.OrgGroup__r.Account_Rule__c.contains(cust.Account_Group__c)) ) {
                
                if (cust.Accounts__r.size()==0) {
                    //No accounts related, create one...
                    Account acc = new Account(name=cust.Name, 
                        ownerid         =cust.OrgGroup__r.OwnerId,
                        recordtypeid    =RTYPE_ERP_ACCOUNT
                        //muti-currency not setup yet ,CurrencyIsoCode  =cust.CurrencyIsoCode
                        );
                    customerToAccount(cust,acc);
                    accountsToUpsert.add(acc);
                }
                else {
                    //loop through accounts and update the ERP fields
                    for ( Account acc : cust.Accounts__r ) {
                        customerToAccount(cust,acc);
                        accountsToUpsert.add(acc);
                    }
                }
            }   
        } //next cust
        
        //save accounts
        if (accountsToUpsert.size()>0) {
            system.debug('upsert: '+accountsToUpsert);
            LIST<Database.Upsertresult> res = database.upsert(accountsToUpsert, false);
            system.debug(res);
        }
        
    }
    
    
    
    //used for both inserts and updates to copy the master data from customer to account
    public static void customerToAccount(ERP_Customer__c cust, Account acc) {
        acc.ERP_Customer__c             =cust.id;
        acc.ERP_Account_Name__c         =cust.Name;
        acc.country__c                  =cust.Country__c;
        acc.Terms_Of_Payment__c         =cust.Terms_of_Payment__c;
        acc.ERP_Account_Code__c         =cust.Customer_Code__c;
        acc.Non_unique_External_ID__c   =cust.External_ERP_ID__c;
        //acc.ERP_Account_Group__c      =cust.Account_Group__c; //does not match
        acc.ERPAccountType__c           =cust.Account_Group__c;
        acc.DUNS_Number__c              =Util.StringToDecimal(cust.DUNS_Number__c);
        //TODO: determine if we need to blockformat, and/or country specific lauout
        acc.ERPAddress__c               = formatAddress(cust.Street__c,cust.City__c,cust.State_Province__c, cust.ZIP_Postal_Code__c, cust.Country__c);
    }
    

    private static string formatAddress(string street, string city, string state, string postalCode, string country) {
            string s='';
            if (Street != null)         s += Street + '\n';
            if (City != null )          s += City + ', ';
            if (State != null )         s += State + ' ';
            if (PostalCode!= null )     s += PostalCode;
            if (Country != null )       s += '\n'+ Country;
            return s;
        }
}

/*
public with sharing class ERPCustomerHander {
    
    /*
    
public static MAP<id, ERP_Customer__c>  filterERPCustomersWithoutAccount(MAP<id, ERP_Customer__c> custs);  //returns: MAP<id, ERP_Customer__c>
    //Get set of ERPCustomersWithAccount
    SET<id>  erpWithAcc = (for .. [Select distinct ERP_Customer__c from Account where ERP_Customer__c in custs.keyset();]
    return custs.remove(erpWithAcc);
}
    
    
    
    
public static MAP<id, Program__c>  getBusinessRules(MAP<id, ERP_Customer__c> custs) {
     //returns: MAP<ERP Customer.id, Program>
    1.  MAP<id,id>  mapProgram = //MAP<Program.id,ERP_Customer.id> loop through and get a set of all Programs;
    2.  SELECT all the business rule fields in program__c where program id=mapProgram.keyset();
    3.return MAP<ERP_Customer__c.id, Program__c>

}

public Account createAccountFromERPCustomer(ERP_Customer__c cust) {
...
}


public void override AfterUpdate(MAP<id, ERP_Customer__c> custs) {
    MAP<id, ERP_Customer__c> filteredCusts = filterERPCustomersWithoutAccount(custs);
    MAP<id, Program__c> rules = getBusinessRules(filteredCusts);
    
    LIST<Account> AccountsToInsert = new LIST<Account>();
    for (ERP_Customer__c c: filteredCusts) {
        rule=rules.get(c.id);
        if (rule....)
            AccountsToInsert.add(createAccountFromERPCustomer(c));
    }
}


*/