/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Controller for page: DemandView

TES20130410 Support for saveURL and retURL;  Support for post Fieldset

********************************************************************************/
public with sharing class ctrlDemandView {
    
    public string				id				{get; private set;}	
    public Demand		 		ds  			{get; set;}
    public boolean 				saveZero		{get; set;}	 			//whether to save ZeroValue schedules
    public integer 				duration		{get; set;}	 			//whether to save ZeroValue schedules	
    public string				dsType			{get; set;}	 			//Purchase, Sales, Inventory, etc...
    public string				infoType		{get; set;}	 			//(b)oth (q)uantity, (r)evenue, (n)one
    public integer				offset			{get; private set;}	 	//offset months  (negitives allowed)
    public string				main_fs			{get; private set;}	 	//forecast FieldSet
    public string				post_fs			{get; private set;}	 	//Post Period FieldSet
    public Demand__c			demandInfo		{get; private set;}		//demand Object	
    public MAP<string,string>	params			{get; private set;}		//url initial parameters	
    
    public ctrlDemandView() {
        
        //todo try...
        params = ApexPages.currentPage().getParameters();
        id = params.get('id');
        
        demandInfo = [Select name, duration__c, fieldset__c, postfieldset__c, offset__c, type__c, information__c from Demand__c where id=:id];
        dsType 		= demandInfo.type__c;
        duration 	= demandInfo.duration__c.IntValue();
        offset 		= demandInfo.offset__c.IntValue();
        main_fs 	= demandInfo.FieldSet__c;
        post_fs 	= demandInfo.postfieldset__c;
        if (demandInfo.Information__c!=null) 
            infoType=demandInfo.Information__c.substring(0,1);	
        else 
            infoType='n';
        
        
        //dsType 		= params.get('typ');
        //duration 	= (params.get('dur')!=null) 		?  Util.stringToInteger(params.get('dur')) : 1;
        saveZero 	= (params.get('svz')!=null) 		?  Util.stringToBoolean(params.get('svz')) : false;
        //infoType   = (params.get('info')!=null) 		?  params.get('styp').substring(0, 1).tolowercase() : 'b';
        //offset   	= (params.get('offset')!=null) 		?  Util.stringToInteger(params.get('offset')) : 0;
        //main_fs   	= params.get('main_fs');	
        //TODO add validation for params
        //max/min duration
        //valid dstypes and infoType	
        
        ds=new Demand(id,dsType,duration);
        ds.baseDT = Date.TODAY().addMonths(offset);
        if (main_fs!=null) 
            ds.DS_fieldSet =main_fs;
        if (post_fs!=null) 
            ds.Post_fieldSet =post_fs;			
        
        ds.load();
    }
    
    public PageReference cancel() {
        if (params.containsKey('retURL'))
            return new PageReference(params.get('retURL'));
        else
            return new PageReference('/'+id);
    }
    
    
    public void refresh(){}
    
    public void quicksave() {
        try {
            ds.save(saveZero);
        } catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
        }
    }
    
    
    public PageReference save() {
        
        ds.save();
        if (params.containsKey('saveURL'))
            return new PageReference(params.get('saveURL'));
        else if (params.containsKey('retURL'))
            return new PageReference(params.get('retURL'));
        else
            return new PageReference('/'+id);
        
    }
}