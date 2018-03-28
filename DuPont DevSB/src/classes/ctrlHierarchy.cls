/*  
      File Name  :  ctrlHierarchy
    /*******************************************************************************
    Copyright © 2010 DuPont. All rights reserved. 
    Author: Sreedhar T Jagannath
    Email: Sreedhar.Jagannath@ind.dupont.com
    Description:  This class provides the logic for displaying the partners assosciated with the particular account based on the selected role
    ********************************************************************************/
 
 
    /* Ver   Date        Author        Modification 
 * ---   ---------   ----------- ----------------------------------------------- 
 * 1.0   07-Oct-10   Sreedhar    Initial Code

    */
 
public class  ctrlHierarchy
    {
    

        public String AccountName ;//Contains the account name selected by the user
        public List <Partner> part{get;set;}//Contains the list of partners to be displayed
        public List <Account> Accnt1{get;set;}
        public List <Account> Accnt{get;set;}
        public String PartnerRole;//Contains the role selected by the user
        public Account Acc{get;set;} 
        public ApexPages.StandardController controller{get; set;}
        public List<Partner> results;
         

                public String getAccountName() 
                    {
                        return this.AccountName;
                    }

                public void setAccountName(String AccountName) 
                    {
                        this.AccountName = AccountName;
                    }
                
                public String getPartnerRole() 
                    {
                        return this.PartnerRole;
                    }

                public void setPartnerRole(String PartnerRole) 
                    {
                        this.PartnerRole = PartnerRole;
                    }


                    public ctrlHierarchy(ApexPages.StandardController stdController)
                        {
                            controller = stdController;
                            this.Acc = (Account)stdController.getRecord();
                             //retrieving the account name from the current account
                            AccountName= ApexPages.currentPage().getParameters().get('AccountName');
     
                        }

     
                   public List<SelectOption> getRoles()
                        {
                            List<SelectOption> options = new List<SelectOption>();
                            Schema.DescribeFieldResult fieldResult = Partner.Role.getDescribe();
                            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                            //populating the drop down for the partner roles   
                                for(Schema.PicklistEntry f : ple)
                                    {
                                        options.add(new SelectOption(f.getLabel(), f.getValue()));
                                    }       
                                return options;
                        }

                    public PageReference searchPartner() 
                        {
                            Part = new List <Partner>();
                            List<Partner> Part1 = new List<Partner>();
                            Accnt = new List<Account>();
                            Accnt1 = new List<Account>();
                            
                            List<Account> Accnt2 = new List<Account>();

                        //retrieving the  id assosciated with the account based on the account name being populated
                            Account acc= [select Id,Name from Account where Name =:AccountName limit 1];
                            String VarId = acc.Id;
                            Partner[] results = [select Id,Role from Partner where AccountFromId =: VarId and  Role =: PartnerRole limit 1];
                                  
                                  for(integer i=0;i<99;i++)
                                    {
                                        //retrieving the partnerid from partner based on the account id
                                        Partner[] Partnerid = [select Id,Role from Partner where AccountFromId =: VarId and  Role =: PartnerRole  ];

                                        if(Partnerid.size()== 0)
                                        {
                                         i=99;
                                        }
                                else 
                                    { 
                                        for (integer inumber=0;inumber<Partnerid.size();inumber++)
                                             {
    
                                                Part.add(Partnerid[inumber]);
                                                VarId = Partnerid[inumber].Id; 
                                                //retrieving the accountToId from partner based on the partnerId
                                                Partner partner = [Select AccountToId,Role from Partner where id =:VarId];
                                                Part.add(partner);
                                                //retrieving the account name based on the accountToId 
                                                Account Acc1 = [select Id, Name,Member_of_Association__c, Site,Fax,Industry,Account_Name_2__c,Rating,ERP_Company_Code__c,ERP_Customer_Ship_To__c,Legacy_Account_ID__c,Owning_Organization__c,Account_Sub_Type__c,BillingStreet,Description,Phone,ShippingStreet,Type,Website,Account_Stage__c,Shipping_Tax_Code_1__c,Country__c,Geo_Area__c,Region__c,ERP_Customer_Sold_To__c,ERP_FRB4_Code__c,ERP_FRB5_Code__c,Global_Sales_Area__c,Program__c,Shipping_Tax_Code_3__c from Account where id =:partner.AccountToId limit 1];
                                                Accnt.add(Acc1);
                                                VarId = partner.AccountToId;
                                            }
                                    }
                            }
  
     
                            System.debug('############Before Reversal:'+Accnt);
                            //Code for List reversal
                                    for(integer inum=Accnt.size()-1;inum>=0;inum--)
                                        {
                                            System.debug('#######:'+Accnt[inum]);
                                            if(Accnt[inum]!=null)
                                            Accnt1.add(Accnt[inum]);
                                        }
                            System.debug('############After Reversal:'+Accnt1);


                            return Page.PartnerHierarchy;
                        }
    }