/*******************************************************************************
Copyright © 2011 DuPont. All rights reserved. 
Author: Sreedhar Jagannath
Email: sreedhar.jagannath@ind.dupont.com
Description:  controller for the page DPT_NomexLeftNav
********************************************************************************/


public class ctrlDPT_NomexLeftNav{

    public Set<String> GroupNames ;
    public String FUserType {get ;  set;}
    public String GUserType {get ;  set;}
    public Boolean UserType {get ;  set;}

    public void getGroups(){
    
    Id UserId = UserInfo.getUserId();
    
    try{
    
        GroupNames = UtilGroup.getGroupMembers(UserId);
    
       }
       
    catch(Exception e) {}
    
    UserType = isInGroup(GroupNames);
  
   }
   
   
    public boolean isInGroup(Set<String> GroupNames){

       try{
            for (String GNames : GroupNames){
            
                     if (GNames.contains('Fabric')){
                     FUserType = 'Fabric';
                     }
             
                     if (GNames.equals('DPT Nomex Garment')){
                     GUserType = 'Garment';
                     }
                    
             } 
             return true;       
          }
             catch(Exception e){ return false; }
                
        }
    
     public List<DPT_Nomex_CertTypes__c> NewButtons {
        GET { 
            List<DPT_Nomex_CertTypes__c> rtn = new List<DPT_Nomex_CertTypes__c>();
                Map<string, DPT_Nomex_CertTypes__c> mapButtons = DPT_Nomex_CertTypes__c.getAll();
                LIST<string> order = new LIST<string>(mapButtons.KeySet());
                order.sort();
                for (string s : order)
                    rtn.add(mapButtons.get(s));
                return rtn;
            }
    }

    
 }