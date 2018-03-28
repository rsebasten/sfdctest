/*******************************************************************************
Copyright © 2011 DuPont. All rights reserved. 
Author: Sreedhar Jagannath
Email: sreedhar.jagannath@ind.dupont.com
Description:  Utility class to check whether user has access on Qualification Record
********************************************************************************/


public with sharing class Qualification_Base {        
    public static boolean hasVisibility(Id qualificationId){          
        boolean rtn=false; 

       try {           
            Qualification__c q=[Select name,account_name__c from Qualification__c where id=:qualificationId];                  
            return true;     
        }  catch(Exception ex){
            return rtn; 
                
        }          
                       
    }  
    
}