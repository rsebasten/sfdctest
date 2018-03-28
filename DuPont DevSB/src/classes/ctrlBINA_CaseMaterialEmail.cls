/////////////////////////////////////////////////////////////////////////////////////////////////////////
//Copyright © 2014 DuPont. All rights reserved. 
//Name :ctrlBINA_CaseMaterialEmail 
//Author :Rajiv Kumar Bhatter<Rajiv_Bhatter@infosys.com>, Sanjay Nandi<Sanjay_Nandi@infosys.com>
//Description: This class is getting used in BI_NA_CreateMaterialsRequest VF Page
//This class allows user to chose Select Materials and chose the Distributor to send an Email to the Contact seled.
//JYOTHSNA20150612 - Added the regions in the criteria for Product L2 for selecting materials 
//SAI MAMILLAPALLI <MS20171213> - Changed the filter as Brand names were changed Product_L4__c='Corian® Solid Surface' or Product_L4__c='Corian® Quartz'
//************************************<MG-20140827>***************************************************//
public class ctrlBINA_CaseMaterialEmail {
     public Case c{ get; set; }
     public String accId;
     public String owner; 
     public String selectedAccId{get;set;}
     public String selectedConId{get;set;}
     public string searchproduct{get;set;}
     public SelectOption[] selectedMaterials { get; set; }  
     public SelectOption[] allMaterials  { get; set; }
     public SelectOption[] contactForSelectedAcc  { get; set; }
     public Account acc{ get; set; }
     public list<Product2> Materialvalue; 
     public string shippingInformation{get;set;}
     public Boolean noProduct {get;set;}
     public static final Id BINACase_MaterialRecordType=RType.getIdByDevName('Case_Material__C','BI_NA_Surfaces_Material');
     public static final Id BINAContactRecordType=RType.getIdByDevName('contact','BI_NA_Contact');
    
public ctrlBINA_CaseMaterialEmail(ApexPages.StandardController controller) {
       c = [SELECT AccountId,
                   Account.name,
                   Contact.name,
                   Contact.email,
                   Alt_Contact_Email__c, 
                   Alt_Contact__c,
                   Related_Account__r.name,
                   owner.name,Entitlement.name,
                   Entitlement.Primary_Contact__r.phone,
                   Entitlement.Primary_Contact__r.firstname,
                   Entitlement.Primary_Contact__r.lastname,
                   Entitlement.Primary_Contact__r.mailingStreet,
                   Entitlement.Primary_Contact__r.mailingcity,
                   Entitlement.Primary_Contact__r.mailingstate,
                   Entitlement.Primary_Contact__r.mailingCountry,
                   Entitlement.Primary_Contact__r.mailingPostalCode,
                   Case_Shipping_Address__c,
                   CaseNumber,
                   OwnerId from Case where Id =:String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id'))];
       accId =c.AccountId;
       //KT [11072017]: To remove Distributor_Contact__c reference
       acc = [Select id, name,Distributor__c,OwnerId  from Account where id = :accid ];
       selectedAccId=acc.Distributor__c;
       owner = c.OwnerId;
       SelectedMaterials = new List<SelectOption>();
       AllMaterials= new List<SelectOption>();
       //JYOTHSNA20150612 :START
       //<MS20171213> : START
       Materialvalue = new list<Product2>([select name from Product2 where (Product_L4__c='Corian® Solid Surface' or Product_L4__c='Corian® Quartz') and Product_L1__c='BI' and (Product_L2__c='North America' or Product_L2__c='EMEA' or Product_L2__c='Asia Pacific' or Product_L2__c='Latin America' or Product_L2__c='Worldwide' ) and Family='BI' and Owning_Org__c='BI' order by name LIMIT 500]);
       //<MS20171213> : END
       //JYOTHSNA20150612 :END
       for(integer j=0 ;j<Materialvalue.SIZE();j++ )
            {AllMaterials.add(new SelectOption(Materialvalue[j].name,Materialvalue[j].name,true));
       }
       getContacts();
       c.Case_Shipping_Address__c=shippingInformation;
   }
    //////////////////////////////////////////
    /* Function Description
    Name :getContacts
    Return Type: void
    Description: This method is used to get the Contacts
    
    */
public void getContacts(){

       if(acc.Distributor__c != null)  
       {
       List<Contact> con1 =[Select id,name from Contact where accountId = :acc.Distributor__c And contact.Role__c != 'Consumer' limit 500];
       System.debug('the account id is --------------'+con1); 
       contactForSelectedAcc= new List<SelectOption>();
       for(Contact c: con1 ){
           contactForSelectedAcc.add(new SelectOption(c.id, c.Name));
          }
       }
       }
      //////////////////////////////////////////
    /* Function Description
    Name :searchProductValue
    Return Type: void
    Description: This method is used to search and display the Materials    
    */
    
public void searchProductValue(){
      noProduct=false;
      Allmaterials.clear();
      string search='%'+searchproduct+'%';
      //JYOTHSNA20150612 :START
      //<MS20171213> : START
      Materialvalue =  ([select name from Product2 where (Product_L4__c='Corian® Solid Surface' or Product_L4__c='Corian® Quartz') and Product_L1__c='BI' and (Product_L2__c='North America' or Product_L2__c='EMEA' or Product_L2__c='Asia Pacific' or Product_L2__c='Latin America' or Product_L2__c='Worldwide') and Family='BI' and Owning_Org__c='BI' and name like :search order by name LIMIT 500]);
      //<MS20171213> : END
      //JYOTHSNA20150612 :END
      system.debug('Size is========='+materialvalue);
      Set<String> tSet=new Set<String>();
      if(SelectedMaterials.size()!=0){
      String[] tempSelected=new List<String>();
      for (integer i=0;i<SelectedMaterials.size();i++){ 
      if(SelectedMaterials[i].getlabel().toLowerCase().contains(searchProduct.toLowerCase())){
           tempSelected.add(SelectedMaterials[i].getlabel());}
         }
      if(tempselected.size()>0){
        tSet.addAll(tempSelected);}
        }
      for (integer i=0;i<materialvalue.size()&& allmaterials.size()<500;i++){ 
       if(tSet.size()>0){
          if(((Materialvalue[i].name.toLowerCase().contains(searchProduct.toLowerCase())) ) && (!tSet.contains((Materialvalue[i].name)))){
              AllMaterials.add(new SelectOption(Materialvalue[i].name,Materialvalue[i].name));}
        }
       else{
            if((Materialvalue [i].name.toLowerCase().contains(searchProduct.toLowerCase())))
               AllMaterials.add(new SelectOption(Materialvalue [i].name,Materialvalue[i].name));
           }   
        }
       //  system.debug('The size of all material is '+ none);
        if(AllMaterials.size()==0){ 
            noProduct =true;
            system.debug('The size of all material is '+ noProduct );
        }
   }
   
   //////////////////////////////////////////
    /* Function Description
    Name :SendEmail
    Return Type: PageReference 
    Description: This method is used to Send Email to the Contact with the Materials,Distributor and ShippinG Instructions    
    */
    
public PageReference SendEmail(){
       integer flag=1;
       try 
        {
        if(productAnswer()==''){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select atleast one Material'));
        flag=0;
        }
        if(selectedConId==null){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select different Distributor and Related Contact of the Distributor'));
        flag=0;
        }
        
        if(flag==1){
            String[] Product=productAnswer().split('\\;');
            LIST<case_material__c> cs= new LIST<case_material__c>();
            //<MS20171213> : START
            LIST<Product2> m= new LIST <Product2>([SELECT id,name FROM Product2 WHERE (Product_L4__c='Corian® Solid Surface' or Product_L4__c='Corian® Quartz') and Product_L1__c='BI' and (Product_L2__c='North America' or Product_L2__c='EMEA') and Family='BI' and Owning_Org__c='BI'] );
           //<MS20171213> : END
            LIST<ID> nm=new LIST<ID>();
            for(Product2 m1:m){
                for(integer i=0;i<Product.size();i++){
                     if(m1.name==product[i]){
                         nm.add(m1.id);
                       }
                }
            }
            for( Integer i=0; i<nm.size();i++){ 
                case_material__c cm= new case_material__c (Case__c=c.id,Product__c=nm.get(i),recordtypeid=BINACase_MaterialRecordType);
                cs.add(cm);
            }
            insert cs;
            system.debug('the case material id are'+cs);
            Contact con = [SELECT Id,Name,email,Account.Name from Contact where Id =: selectedConId];
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setSubject('Material Request for the case '+c.CaseNumber);
            string msg;
            List<String> emails = new List<String>(); 
            string ssUserName;
            if(c.contact.email !=NULL ){
               emails.add(c.contact.email);    
            }
            if(c.Alt_Contact_Email__c!=NULL) {
               emails.add(c.Alt_Contact_Email__c);
            }
           
            if(c.Related_Account__c !=NULL){
            ssUserName=c.Related_Account__r.name; 
           }
           else
           ssUserName='';
           
           //String AccountName=c.Account.name;
           String Address=c.Entitlement.Primary_Contact__r.firstname+' '+c.Entitlement.Primary_Contact__r.lastname+'\n'+c.Entitlement.Primary_Contact__r.mailingStreet+', '+'\n'+c.Entitlement.Primary_Contact__r.MailingCity+' - '+c.Entitlement.Primary_Contact__r.MailingPostalCode+ '\n'+c.Entitlement.Primary_Contact__r.MailingState+', '+c.Entitlement.Primary_Contact__r.MailingCountry;
           String body = 'Dear ' + con.Name + ', '+'\n'+'\n';
           body+='The Surfaces Warranty Center has approved a Material Request for '+ C.Entitlement.name +'. This Material Request is related to DuPont Claim # '+C.CaseNumber+' initiated by '+C.owner.name+'.';
           body+='\n'+'The Shipping Instruction given is: '+shippingInformation+'.'+' ';
           body+='\n\n'+'This Claim is being serviced by '+ssUserName+'.'+'\n';
          // body+='\n'+'The Shipping Address is:'+'\n'+Address;
          // body+='\n'+'Phone Number :  '+c.Entitlement.Primary_Contact__r.phone+'\n';
           body+='\n'+'The Material(s) requested are: '+'\n';
           for (integer i=0;i<product.size();i++){
               body+=SelectedMaterials[i].getlabel()+'\n';
           }
           body+='\n'+ 'Thank you for processing this request at your earliest convenience.';
           mail.setPlainTextBody(body);
           mail.setSaveAsActivity(true);
           mail.setTargetObjectId(selectedConId);
           mail.setCcAddresses(emails);
           Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
           CaseComment cc = new CaseComment();
           cc.parentId= String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id'));
           cc.CommentBody = 'The mail has been sent to '+con.Name +' with email '+con.email +' associated to Account '+con.Account.Name+'.';
           insert cc;
           task ah= new task();
           ah.WhatId= String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id'));
           ah.whoid=Con.id;
           ah.Subject='Material Request for the Case '+c.CaseNumber;
           ah.Description='The mail has been sent to '+con.Name +' with email '+con.email +' associated to Account '+con.Account.Name+'.'+'\n\n\n'+body;
           ah.OwnerId=c.ownerId;
           ah.status='Completed';
           insert ah;
           PageReference pr1=new PageReference('/'+c.id);
           c.Case_Shipping_Address__c=shippingInformation;
           update c;
           return pr1;
           
          }    
         else {
             return Null;
         }
     
     }
     Catch(Exception e){
     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please '+e));
     system.debug('The exception '+ e);
     return Null;
     } 
   }
   
   //////////////////////////////////////////
    /* Function Description
    Name :productAnswer
    Return Type: String
    Description: This method to store the Products in the product Answer field
    
    */
    
public string productAnswer(){

     String message;                                  
     Boolean first = true;
    try{
     message ='';
     for(SelectOption so : SelectedMaterials) {
         if (!first) {
            message += ';';
         }
      message += so.getvalue();
      first = false;
      }
    return message;
    }
    
   catch(Exception ex){
      return message;
     }
  }
}