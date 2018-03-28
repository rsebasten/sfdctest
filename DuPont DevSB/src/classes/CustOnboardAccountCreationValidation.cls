/*******************************************************************************
Copyright © 2014 DuPont. All rights reserved. 
Author: Sravanthi Lakkimsetty
Email: Sai_Lakkimsetty@infosys.com
Description:  Validation for Account Creation in customer Onboarding Application. 
Used in TrigAccount
 ********************************************************************************/ 

Public Class CustOnboardAccountCreationValidation{
    Public Static List<COB_User_AccountCreationSettings__c > custsettingsRecords = new List<COB_User_AccountCreationSettings__c >();

    //Validation to allow or not allow Account creation for CSRs and Sales Reps
    Public static void AccountCreationAccessValidation(List<Account> accList){
        Boolean MatchFound;
        custsettingsRecords = COB_User_AccountCreationSettings__c.getALL().values();
        for(Account acc: accList){
            for(COB_User_AccountCreationSettings__c  uac :custsettingsRecords){
                if(uac.Company_Code__c==acc.Company_Code__c && uac.SBU__c==acc.SBU__c && uac.Region__c==acc.Region__c){
                    if(uac.New_Account_Creation_Permit__c==false){
                        MatchFound = true;
                        acc.addError('SBU doesn’t allow you to create an account. Please reach out to sales team for account creation');
                    }
                }
            }
        }
    }

    //This class will insert sharing rules based on the SBU and owning org of the account being inserted
    public static void insertAccSharingRules(Map<Id,Account> mapAccnts){
        //<AlvinJohnson6/9/2015>
        //Description : commented in phase 2 no longer needed
        /*try{
            List<Account_Share_Matrix__c> accMatrixSettings = Account_Share_Matrix__c.getALL().values();
            Map<Id,SET<String>> mapAccSharingRules = new Map<Id,SET<String>>();

            for(Account acc : mapAccnts.values()){
                SET<String> setTemp = new SET<String>();
                for(Account_Share_Matrix__c  uac :accMatrixSettings){
                    if(uac.SBU__c <> null && uac.SBU__c !=''){
                        if(uac.SBU__c == acc.SBU__c){
                            setTemp.add(uac.public_group_id__c);
                        }
                    }
                    if(uac.Owning_Organization__c <> null && uac.Owning_Organization__c !=''){   
                        if(acc.Owning_Organization__c  == uac.Owning_Organization__c){
                            setTemp.add(uac.public_group_id__c);
                        }  
                    } 
                }
                mapAccSharingRules.put(acc.id, setTemp);
            }
            List<AccountShare> AccountShareList = new List<AccountShare>();
            if(mapAccSharingRules.size() <> 0){
                for(Id accId : mapAccSharingRules.keySet()){
                    for(String pblGrpId : mapAccSharingRules.get(accId)){
                        AccountShare accShare=new AccountShare();
                        accShare.AccountID=accId;
                        accShare.AccountAccessLevel='Read';
                        accShare.OpportunityAccessLevel='None';
                        accShare.CaseAccessLevel='None';
                        accShare.UserOrGroupId=pblGrpId;
                        AccountShareList.add(accShare);  
                    }           
                }
            }
            if(!AccountShareList.isEmpty())
                insert AccountShareList;
        }catch(Exception e){   //Exception Handling
            System.debug(e.getMessage());
        }*/
         //<--ChangesFinished-->
    }
}