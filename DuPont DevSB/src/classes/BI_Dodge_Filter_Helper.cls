/*************************************************************************************************
Copyright © 2015 DuPont. All rights reserved. 
Authors:        Abhinav Bhatnagar
Email:          abhinav.bhatnagar@dupont.com
Description:    Helper class to fetch the custom settings based on filter criteria and compare with existing values. 
This class majorly works for BI_MHC, ctrlOppSFDCToSFDC and batchOppSFDCToSFDC
*************************************************************************************************/
public class BI_Dodge_Filter_Helper {
    
    public static Map<String, BINAOwner2__C> Owner2CustomSettings { GET {return BINAOwner2__C.getAll(); }}
    
    private static final String CUSTOMSETTINGOWNER2 = 'BINAOwner2__C'; //Name of the custom settings from where filters needs to be fetched for Owner 2 assigment
    /*Custom Settings Variables*/
    
    private static Set<String> CustomSettingEISegmentL2 = new Set<String>();
    private static Set<String> CustomSettingEISegmentL3 = new Set<String>();
    private static Set<String> CustomSettingEIStage = new Set<String>();
    private static String CustomSettingSurfacesApplicationType {get;set;}
    private static String CustomSettingTyvekApplicationType {get;set;}
    private static String CustomSettingFluidApplicationType {get;set;}
    private static String CustomSettingOppStageEndLost {get;set;} 
    private static String CustomSettingOppStageEndWon {get;set;}  
    private static Integer CustomSettingValue {get;set;} 
    
    private void resetValues(){
        CustomSettingEISegmentL2.clear();
        CustomSettingEISegmentL3.clear();
        CustomSettingEIStage.clear();
        CustomSettingSurfacesApplicationType='';
        CustomSettingTyvekApplicationType ='';
        CustomSettingFluidApplicationType  ='';
        CustomSettingOppStageEndLost ='';
        CustomSettingOppStageEndWon ='';
       CustomSettingValue = 0;
    }    
    
    
      
    public boolean compareValues(Opportunity opp, String strCustomSettingsName, String strApplicationType){
        try{
            System.debug('In Helper Class, Compare Values Method ----> ');
            resetValues();
            LoadCustomSettings(strCustomSettingsName, strApplicationType);
            
            if(strCustomSettingsName.equalsIgnoreCase(CUSTOMSETTINGOWNER2)){
                return compareOwner2Values(opp,strApplicationType);                
            }else{
                return false;
            }           
        }catch(Exception e){
            system.debug(e.getMessage());
            return false;
        }
    }
    
     
    private boolean compareOwner2Values(Opportunity Opp, String strApplicationType){        
        boolean isValidOpp = true;
        isValidOpp = opp.Application_Type__c != null && (opp.Application_Type__c.equalsIgnoreCase(CustomSettingTyvekApplicationType) || opp.Application_Type__c.equalsIgnoreCase(CustomSettingFluidApplicationType) || opp.Application_Type__c.equalsIgnoreCase(CustomSettingSurfacesApplicationType))? true : false;
        System.debug('In Helper Class, Compare Values Method, opp.Application_Type__c ----> '+opp.Application_Type__c+'  '+isValidOpp);
        isValidOpp = isValidOpp && opp.External_Initiative__r.Value__c != null && opp.External_Initiative__r.Value__c >= CustomSettingValue? true : false;
        System.debug('In Helper Class, Compare Values Method, opp.External_Initiative__r.Value__c  ----> '+opp.External_Initiative__r.Value__c+'  '+isValidOpp);
        
        if(isValidOpp!=false && opp.External_Initiative__r.Segment_L2__c!=null ){
            boolean contains = false;
            for(String strSegmentL2Token : opp.External_Initiative__r.Segment_L2__c.split(',')){
                if(CustomSettingEISegmentL2.contains(strSegmentL2Token)){
                    contains = true;
                    break;
                }
                System.debug('In Helper Class, Compare Values Method, opp.External_Initiative__r.Segment_L2__c  ----> '+opp.External_Initiative__r.Segment_L2__c+'  '+isValidOpp);
            }
            isValidOpp = opp.Application_Type__c.equalsIgnoreCase(CustomSettingSurfacesApplicationType)? (isValidOpp  && contains) : (isValidOpp  && !contains);
        }else{
            isValidOpp = false;
        }
        
        ////
        if(isValidOpp!=false && opp.External_Initiative__r.Segment_L3__c!=null && strApplicationType.equalsIgnoreCase('TyvekOrFluid')){
            boolean contains = false;
            for(String strSegmentL3Token : opp.External_Initiative__r.Segment_L3__c.split(',')){
                if(CustomSettingEISegmentL3.contains(strSegmentL3Token)){
                    contains = true;
                    break;
                }
                System.debug('In Helper Class, Compare Values Method, opp.External_Initiative__r.Segment_L3__c  ----> '+opp.External_Initiative__r.Segment_L3__c+' CustomSettingEISegmentL3--->' + CustomSettingEISegmentL3+' contains---> '+contains+' isValidOpp---> '+isValidOpp);
            }
            isValidOpp = isValidOpp  && contains;
        }
        
        System.debug('In Helper Class, Compare Values Method, opp.External_Initiative__r.Stage__c pre ----> '+CustomSettingEIStage+opp.External_Initiative__r.Stage__c+'  '+isValidOpp);
        
        isValidOpp = opp.Application_Type__c.equalsIgnoreCase(CustomSettingSurfacesApplicationType)?(isValidOpp && opp.External_Initiative__r.Stage__c != null && !CustomSettingEIStage.contains(opp.External_Initiative__r.Stage__c)):(isValidOpp && opp.External_Initiative__r.Stage__c != null && CustomSettingEIStage.contains(opp.External_Initiative__r.Stage__c));
        System.debug('In Helper Class, Compare Values Method, opp.External_Initiative__r.Stage__c  ----> '+CustomSettingEIStage.contains(opp.External_Initiative__r.Stage__c)+opp.External_Initiative__r.Stage__c+'  '+isValidOpp);
        
        return isValidOpp;
    }
        
    private  void LoadCustomSettings(String strCustomSettingsName, String strApplicationType){
        try{
            System.debug('In Helper Class, LoadCustomSettings Method,   --->');
           if (strCustomSettingsName!=null && strCustomSettingsName.equals(CUSTOMSETTINGOWNER2)){
                System.debug('In Helper Class, LoadCustomSettings Method, Surfaces common  --->');
                loadOwner2CommonCS(strApplicationType);
                if(strApplicationType.equalsIgnoreCase('Surfaces')){
                    CustomSettingSurfacesApplicationType = Owner2CustomSettings.get('S_ApplicationType').value__c;
                    System.debug('In Helper Class, loadOwner2CommonCS Method, ,Application Type   --->'+CustomSettingSurfacesApplicationType);
                    
                }else if(strApplicationType.equalsIgnoreCase('TyvekOrFluid')){
                    CustomSettingTyvekApplicationType = Owner2CustomSettings.get('TF_ApplicationType_CLTTyvek').value__c;
                    CustomSettingFluidApplicationType = Owner2CustomSettings.get('TF_ApplicationType_CLTFluid').value__c;
                    System.debug('In Helper Class, loadOwner2CommonCS Method, ,Application Type   --->'+CustomSettingTyvekApplicationType+' '+CustomSettingTyvekApplicationType);
                    
                    for(String key:Owner2CustomSettings.keySet()){
                        if(key.contains('TF_EISegmentL3')){
                            System.debug('In Helper Class, LoadCustomSettings Method, TyvekOrFluid CS Called,Segment L3  --->'+key);
                            CustomSettingEISegmentL3.add(Owner2CustomSettings.get(key).Value__c);
                        }
                    }
                }
            }
       }Catch(Exception e)  {
            System.debug('Error Occured in Loading Custom Settings \n'+e.getStackTraceString());
        }    
        
    }
    
    private void loadOwner2CommonCS(String strApplicationType){
        String strCSAppTypePrefix='';
        if(strApplicationType.equalsIgnoreCase('Surfaces')){
            strCSAppTypePrefix = 'S_';
        }else if(strApplicationType.equalsIgnoreCase('TyvekOrFluid')){
            strCSAppTypePrefix = 'TF_';
        }
        System.debug('In Helper Class, loadOwner2CommonCS Method,   --->');
        for(String key:Owner2CustomSettings.keySet()){
            if(key.contains(strCSAppTypePrefix+'EISegmentL2')){
                System.debug('In Helper Class, loadOwner2CommonCS Method, ,Segment L2  --->'+key);
                CustomSettingEISegmentL2.add(Owner2CustomSettings.get(key).Value__c);
            }else if(key.contains(strCSAppTypePrefix+'EIStage')){
                System.debug('In Helper Class, loadOwner2CommonCS Method, ,Stage  ---> '+key);
                CustomSettingEIStage.add(Owner2CustomSettings.get(key).Value__c);
            }
        }
        CustomSettingValue = Integer.valueOf(Owner2CustomSettings.get(strCSAppTypePrefix+'EIValue').value__c);
        System.debug('In Helper Class, loadOwner2CommonCS Method, ,CustomSettingValue --->  '+CustomSettingValue);
    }
  
  
    
}