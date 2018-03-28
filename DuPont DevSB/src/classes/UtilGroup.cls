/*******************************************************************************
Copyright © 2011 DuPont. All rights reserved. 
Author: Sreedhar Jagannath
Email: sreedhar.jagannath@ind.dupont.com
Description:  Utility class to get all the Public Groups in which user is a groupmember 
********************************************************************************/

public without sharing class UtilGroup {

     
    public static Set<String> getGroupMembers(Id UserId){
    
      Set<String> GroupIds = new Set<String> ();
      Set<String> GroupNames = new Set<String> ();
      
      
          try{
          
           //getting users directly assosciated with Groups
           for (GroupMember gmp : [Select GroupId from Groupmember where UserorGroupId =: UserId]){
           GroupIds.add(gmp.GroupId);
           }

           
           //getting GroupIds assosciated with Groups where in particular user is present
           for(Integer i = 0;i<=5;i++){
           for(GroupMember gmp1 : [Select GroupId from Groupmember where UserorGroupId IN:GroupIds]){
           GroupIds.add(gmp1.GroupId);
           }
           }
           
          // getting Group Names assosciated with Groupids
           for (Group gp : [Select Name from Group where Id In : GroupIds]){
               GroupNames.add(gp.Name);
              
           } 
             
             return GroupNames;
           
           }
          catch(Exception e){return null ;}
            
        }
        
        
}