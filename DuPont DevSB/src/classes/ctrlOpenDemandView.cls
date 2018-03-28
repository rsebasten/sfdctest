/*******************************************************************************
Copyright © 2014 DuPont. All rights reserved. 
Author: Abhinav Bhatnagar
Email: abhinav.bhatnagar@dupont.com
Description:  
This controller class is created to give custom view as a VF page in the page layout. The requirement is
•	The DuPont Internal users can see the Demand View as well as Related List view to Edit the Demands and corresponding objects
•	The Partner users should only be able to see the Demand View and they should not have any facility to view/edit internal details of Demand
•	To eliminate the Grey Static screen, if user don’t have access to any of the demand or no demand is created for the Account.

<AB20140903> - •	To eliminate the Grey Static screen, if user don’t have access to any of the demand or no demand is created for the Account.
********************************************************************************/
public with sharing class ctrlOpenDemandView{
    public List<Account> accountObj {get;set;}//Account object to hold the current account details in property. This is later used to fetch the demand object and check whether the user have access to the demand or the demand list is empty or not. This will help in eliminating the grey screen in the Visual Force Page.
    public List<demand__c> demandObj {get;set;}//Demand Object which is retrieved from the accountObj. If there is not a single demand object present, user is shown a custom error message.
    public boolean isDemandListEmpty{get;set;}//<AB20140903> To be used in VFP to determine if demand object list is empty.
    
    public boolean partner{//To identify if the current user is DuPont Internal User or Partner. This will help in showing the custom VFP. Either showing both the Demand View and Editing Demand Object Page or only Demand View Page (If the user is partner user)
        GET{
            if(userInfo.getUserType()=='PowerPartner')
                return true;
            else 
                return false;
        }
    }
    public ctrlOpenDemandView(){ //Default Constructor
    }
    
    public ctrlOpenDemandView(ApexPages.StandardController controller){//<AB20140903> Starts Constructor Method to fetch the current Account and then the Demand Object from the Account Object.
        getAccount obj = new getAccount();
        accountObj = obj.getAccountById(ApexPages.currentPage().getParameters().get('Id'));
        demandObj = accountObj.get(0).demand__r;
        if(demandObj.size()>0)
            isDemandListEmpty = false;
        else
            isDemandListEmpty = true;
    }
    //<AB20140903> Ends
    public  List<Demand__c>  getdemandObj(){//Fetch Demand Object
        return demandObj;
    }
    
    public class getAccount{
        public String getAccountQuery(Id AccountId){//To build SOQL  from the Account Id provided
            return 'SELECT Id, Name, (SELECT Account__c,fDemandViewLink__c,Type__c,Name,UserRecordAccess.HasReadAccess, UserRecordAccess.MaxAccessLevel FROM Demand__r order by Name) FROM Account where id=\''+AccountId+'\' LIMIT 1';
        }
        
        public List<Account> getAccountById(Id AccountId){
            return Database.query(getAccountQuery(AccountId));
        }
    }
}