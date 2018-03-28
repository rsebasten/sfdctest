/////////////////////////////////////////////////////////////////////////////////////////////////////////
//Copyright © 2014 DuPont. All rights reserved. 
//Name :trigNominationContactCreation
//Author :Naga Neelam<Naga_Neelam@infosys.com>
//Description: : This trigger is used to create a contact automatically while creating a qualification with the details mentioned on the qualification record under a respective account.
//<Naga-20150402>:Changes made to remove a query which has an inner query in it to get the child records
/************************************<JS-20141226>***************************************************/

trigger trigNominationContactCreation on Qualification__c (after insert) {
Map<Id,Set<String>> AccountIDContacts=new Map<Id,Set<String>>();
List<Contact> contacts=new List<Contact>();
Map<Id,Qualification__c> QualMap=new Map<Id,Qualification__c>();

//Get Map of AccountId and its respective Qualification Records
if(System.Label.Trigger_On_Off  == 'On'){  
for(Qualification__c qualification:[Select Id,Account_Name__c, Primary_Contact_Name__c, Primary_Contact_Email__c  from Qualification__c where id =: trigger.newMap.keySet() and recordType.DeveloperName in ('BI_NA_Certification_Env','BI_NA_Certification_Surf')]){
QualMap.put(qualification.Account_Name__c,qualification);
}

//Get a Map of all contacts for each respective Account 
/*<Naga-20150402>:We have a query which has an inner query in it to get the child records and we are getting the error if we have more records. Inorder to get rid of this error added the below line and commented line#:24 */
List<Account> acct=[select id,(select id,LastName,Email from Contacts) from Account where id in:QualMap.keySet()];
for(Account acc:acct){
//for(Account acc:[select id,(select id,LastName,Email from Contacts) from Account where id in:QualMap.keySet()]){
Set<string> contactStr=new Set<string>();
   if(acc.Contacts.size()>0){
    for(Contact c:acc.Contacts){
    contactStr.add(c.LastName+c.Email);
    }
   }
   if(contactStr.size()>0){
    AccountIDContacts.put(acc.Id,contactStr);
   }
}
//Check the Qualification record last Name and FirstName whether it is is in the above Map of contacts for the respective account Id if not add the Contact details in the List to be added for the account.
if(QualMap.size()>0){
    for(Id acc:QualMap.keySet()){
        if(AccountIDContacts.get(acc)!=null){
        if(!AccountIDContacts.get(acc).contains(QualMap.get(acc).Primary_Contact_Name__c+QualMap.get(acc).Primary_Contact_Email__c)){
        Qualification__c qual=QualMap.get(acc);
        contacts.add(new Contact (lastname = qual.Primary_Contact_Name__c, accountId=qual.Account_Name__c, Email = qual.Primary_Contact_Email__c, RecordTypeId = [Select Id From RecordType  where Name =: 'BI-NA Contact' limit 1].id ));
        } 
            
   }  else{
          Qualification__c qual=QualMap.get(acc);
          contacts.add(new Contact (lastname = qual.Primary_Contact_Name__c, accountId=qual.Account_Name__c, Email = qual.Primary_Contact_Email__c, RecordTypeId = [Select Id From RecordType  where Name =: 'BI-NA Contact' limit 1].id ));
         }  
}
}
if(!contacts.IsEmpty()){
insert contacts;
}
}
}