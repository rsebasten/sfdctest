/*******************************************************************************
(C)2016
Author: Pallavi Sharma
Email: pallavi.sharma3@tcs.com
Description:  This class returns the Region based Countries dropdown values for BAC.
 ********************************************************************************/
@RestResource(urlMapping = '/Region_Country/*')
global class CtrlRegionCountryDropdownService{
    @HttpPost
    global static CtrlKevlarSvcHelper.ReturnCountryRegionClass doPost(){
        CtrlKevlarSvcHelper h = new CtrlKevlarSvcHelper();
        RestRequest req = RestContext.request;
        try{
            system.debug('req.requestBody : ' + req.requestBody.toString()); 
            Map<String,List<String>> regionCountryMap = new Map<String,List<String>>();
            List<Kevlar_RegionCountry_Mapping__c> mapping_query=Kevlar_RegionCountry_Mapping__c.getAll().values();
            for(Kevlar_RegionCountry_Mapping__c rc : mapping_query)
            {
                List<String> temp;
                if(regionCountryMap.containsKey(rc.Region__c)){
                    temp=regionCountryMap.get(rc.Region__c) ;
                }
                else{
                    temp=new List<String>();
                }
                temp.add(rc.Country__c);
                regionCountryMap.put(rc.Region__c, temp);
            }
            Set<String> mapKeys=regionCountryMap.keySet();
            List<String> sortedKeys=new List<String>();
            sortedKeys.addAll(mapKeys);
            sortedKeys.sort();
 
            for(String key : sortedKeys){
                List<String> sortedCountries=regionCountryMap.get(key);
                regionCountryMap.remove(key);
                sortedCountries.sort();
                regionCountryMap.put(key, sortedCountries);
            }
             system.debug('RegionCountryDropdown result: ' + regionCountryMap); 
            if(!regionCountryMap.isEmpty()){
                return new CtrlKevlarSvcHelper.ReturnCountryRegionClass(h.dataSent, h.getMessage('200'),h.getResponseMessage('505'),'505', regionCountryMap, null, 'No Error');
            }
            else{
                return new CtrlKevlarSvcHelper.ReturnCountryRegionClass(h.dataNotSent, h.getMessage('201'), null,null, null, null, '201');
            } 
        }
        catch(Exception e){
            System.debug('Error----------'+e.getMessage());
            return new CtrlKevlarSvcHelper.ReturnCountryRegionClass(h.dataNotSent, h.getMessage('203'),'Data loading failed!',null, null, null, '203');
        }   
    }
}