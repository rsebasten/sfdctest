/*******************************************************************************
Copyright © 2011 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Controller for component  autoComplete_Products
	will need to grant acess to this controller, as this uses a global @RemoteAction
********************************************************************************/
global class ctrlAutoComplete_Products {
    @RemoteAction
    global static SObject[] search(string searchString, string pricebookId, string currencyIsoCode) {	
    	system.debug(pricebookId);
    	system.debug(currencyIsoCode);
		return [Select id, name, Family, Description
	    				From Product2 
	    				where 
	    				Id in (Select Product2Id from PricebookEntry 
	    						where CurrencyIsoCode =: currencyIsoCode 
	    						and Pricebook2Id =:  pricebookId
	    						and IsActive =true
	    						//and Id not in: excludePBEs
	    						)
	    				AND IsActive=true
	    				AND CanUseRevenueSchedule=true
	    				AND ( Name like :'%'+searchString+'%' OR description like :'%'+searchString+'%')
	    				ORDER By name
	    				LIMIT 20
						];

    }
    
	@RemoteAction
	global static SObject[] getProducts(string searchString, string pricebookId, string currencyIsoCode, string schedTypeCode, string max) {	
    	system.debug(pricebookId);
    	system.debug(currencyIsoCode);
    	
    	string liketerm='%'+searchString+'%';
    	string soql='SELECT id, name, Family, Description From Product2';
    	soql+=' WHERE Id in (Select Product2Id from PricebookEntry where CurrencyIsoCode =:currencyIsoCode and Pricebook2Id =:pricebookId and IsActive=true)';
		soql+=' AND IsActive=true';
		if (schedTypeCode=='R' || schedTypeCode=='B')
			soql+=' AND CanUseRevenueSchedule=true';
		if (schedTypeCode=='Q' || schedTypeCode=='B' || schedTypeCode=='Z')
			soql+=' AND CanUseQuantitySchedule=true';
		soql+=' AND ( Name like :liketerm OR description like :liketerm)';		
	    soql+=' ORDER By name LIMIT '+max;
		
        List<sObject> sos = new List<sObject>();
        try {
        	system.debug('SOQL:'+soql);
            sos = Database.query(soql);
            
            //Cleans the data (SF issue relecting sobject list to JSON)
            for ( Sobject so : sos) {
            	 
            	if (so.get('Name')!=null)
            		so.put('Name',String.valueOf(so.get('Name')).replace('™',''));
            	if (so.get('Family')!=null)
            		so.put('Family',String.valueOf(so.get('Family')).replace('™',''));
            	if (so.get('Description')!=null)	
            		so.put('Description',String.valueOf(so.get('Description')).replace('™',''));
            }

        }
        catch (QueryException e) {
            return new List<sObject>();
        }
        return sos;

    }
    
    
    
    
}