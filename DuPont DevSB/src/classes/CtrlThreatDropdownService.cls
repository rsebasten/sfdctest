/*******************************************************************************
(C)2016
Author: krishnaveni duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  This class returns the Threatsdropdown values for BA Threats Master.
 ********************************************************************************/
@RestResource(urlMapping = '/ThreatDefaultDropdowns/*')
global class CtrlThreatDropdownService{
 
@HttpPost
global static CtrlKevlarSvcHelper.ReturnThreatDefaultDropDownClass doPost(){
    CtrlKevlarSvcHelper h = new CtrlKevlarSvcHelper();
    List<String> shotLocation = new List<String>();
    List<String> shootingMechnism = new List<String>();
    List<String> numberOfShots = new List<String>();
    List<String> angledShots = new List<String>();
    List<String> energyLevel = new List<String>();
    List<String> jouleList = new List<String>();
    List<String> permissiblePenetrationList = new List<String>();
    List<String> numberOfStabs = new List<String>();
    List<String> stabLocation = new List<String>();
    List<String> VelocityV50= new List<String>();
    List<String> angleNBT= new List<String>();
    List<String> FragmentV50= new List<String>();
    List<String> TestStandard= new List<String>();
    List<String> threatLevel = new List<String>();
       
    List<List<String>> defaultDropdownList = new List<List<String>>();
    RestRequest req = RestContext.request;
    try{   
        system.debug('req.requestBody : ' + req.requestBody.toString());   
        Schema.DescribeFieldResult sl = Threat_Master__c.Shot_Locations__c.getDescribe();    
        List<Schema.PicklistEntry> s = sl.getPicklistValues(); 
        for(Integer i=0;i<s.size();i++)
        {
             shotLocation.add(s[i].getvalue());   
        }
        defaultDropdownList.add(shotLocation);   
        Schema.DescribeFieldResult sm= Threat_Master__c.Shooting_Mechnism__c.getDescribe();    
        List<Schema.PicklistEntry> smValues = sm.getPicklistValues(); 
        for(Integer i=0;i<smValues .size();i++)
        {
             shootingMechnism.add(smValues [i].getvalue());   
        }
        defaultDropdownList.add(shootingMechnism);

        Schema.DescribeFieldResult noOfShots= Threat_Master__c.Number_of_shots__c.getDescribe();    
        List<Schema.PicklistEntry> shotValues = noOfShots.getPicklistValues(); 
        for(Integer i=0;i<shotValues.size();i++)
        {
             numberOfShots.add(shotValues[i].getvalue());   
        }
        
        defaultDropdownList.add(numberOfShots);
        Schema.DescribeFieldResult aShots= Threat_Master__c.Angled_Shot__c.getDescribe();    
        List<Schema.PicklistEntry> asValues = aShots.getPicklistValues(); 
        for(Integer i=0;i<asValues.size();i++)
        {
             angledShots.add(asValues[i].getvalue());   
        }
        
        Schema.DescribeFieldResult eLevel = Threat_Master__c.Energy_Level_NBT__c.getDescribe();    
        List<Schema.PicklistEntry> el = eLevel.getPicklistValues(); 
        for(Integer i=0;i<el.size();i++)
        {
             energyLevel.add(el[i].getvalue());   
        }
        defaultDropdownList.add(energyLevel);   
        Schema.DescribeFieldResult eJoule= Threat_Master__c.Energy_Level_Joule_NBT__c.getDescribe();    
        List<Schema.PicklistEntry> eJouleValues = eJoule.getPicklistValues(); 
        for(Integer i=0;i<eJouleValues .size();i++)
        {
             jouleList.add(eJouleValues[i].getvalue());   
        }
        defaultDropdownList.add(jouleList);

        Schema.DescribeFieldResult penetrationsAllow= Threat_Master__c.Penetration_Allowed__c.getDescribe();    
        List<Schema.PicklistEntry> paValues = penetrationsAllow.getPicklistValues(); 
        for(Integer i=0;i<paValues.size();i++)
        {
             permissiblePenetrationList.add(paValues[i].getvalue());   
        }
        
        defaultDropdownList.add(permissiblePenetrationList);
        
        Schema.DescribeFieldResult noOfStabs= Threat_Master__c.No_Of_Stabs__c.getDescribe();    
        List<Schema.PicklistEntry> nStabs = noOfStabs.getPicklistValues(); 
        for(Integer i=0;i<nStabs.size();i++)
        {
             numberOfStabs.add(nStabs[i].getvalue());   
        }
        
        defaultDropdownList.add(numberOfStabs);
     
     
        Schema.DescribeFieldResult stabLocations= Threat_Master__c.Stab_Location__c.getDescribe();    
        List<Schema.PicklistEntry> stabLoc = stabLocations.getPicklistValues(); 
        for(Integer i=0;i<stabLoc.size();i++)
        {
             stabLocation.add(stabLoc[i].getvalue()); 
        }
        
        defaultDropdownList.add(stabLocation);
        
        Schema.DescribeFieldResult angle_NBT= Threat_Master__c.Angle_NBT__c.getDescribe();    
        List<Schema.PicklistEntry> an = angle_NBT.getPicklistValues(); 
        for(Integer i=0;i<an.size();i++)
        {
             angleNBT.add(an[i].getvalue());   
        }
        defaultDropdownList.add(angleNBT);

       Schema.DescribeFieldResult Velocity_V50= Threat_Master__c.Velocity_V50__c.getDescribe();    
        List<Schema.PicklistEntry> vv = Velocity_V50.getPicklistValues(); 
        for(Integer i=0;i<vv.size();i++)
        {
             VelocityV50.add(vv[i].getvalue());   
        }
        defaultDropdownList.add(VelocityV50);
         
       /*  Schema.DescribeFieldResult Fragment_V50= Threat_Master__c.V50__c.getDescribe();    
        List<Schema.PicklistEntry> fv = Fragment_V50.getPicklistValues(); 
        for(Integer i=0;i<fv.size();i++)
        {
             FragmentV50.add(fv[i].getvalue());   
        }
        defaultDropdownList.add(FragmentV50);
        */
        
        Schema.DescribeFieldResult Test_Standard= Threat_Master__c.Test_Standard__c.getDescribe();    
        List<Schema.PicklistEntry> test = Test_Standard.getPicklistValues(); 
        for(Integer i=0;i<test.size();i++)
        {
             TestStandard.add(test[i].getvalue());   
        }
        defaultDropdownList.add(TestStandard);
        
        
         Schema.DescribeFieldResult threat_Level= Threat_Master__c.Threat_level__c.getDescribe();    
        List<Schema.PicklistEntry> tl = threat_Level.getPicklistValues(); 
        for(Integer i=0;i<tl.size();i++)
        {
             threatLevel.add(tl[i].getvalue());   
        }
        
         if(!defaultDropdownList.isEmpty()){
            return new CtrlKevlarSvcHelper.ReturnThreatDefaultDropDownClass(h.dataSent, h.getMessage('200'),h.getResponseMessage('541'),'541',shotLocation, shootingMechnism, numberOfShots,angledShots,energyLevel, jouleList, permissiblePenetrationList,numberOfStabs,stabLocation,angleNBT,VelocityV50,FragmentV50 ,TestStandard,threatLevel,null, 'No Error');
        }
        else{       
            return new CtrlKevlarSvcHelper.ReturnThreatDefaultDropDownClass(h.dataNotSent, h.getMessage('201'),null,null,null,null,null, null,null,null, null,null,null,null,null,null,null,null,null, '201');
        }   
            
    }
    catch(Exception e){
        System.debug('Error----------'+e.getMessage());
        return new CtrlKevlarSvcHelper.ReturnThreatDefaultDropDownClass(h.dataNotSent, h.getMessage('203'),'Data loading failed!',null,null,null,null,null,null,null,null, null,null,null,null,null,null,null,null, '203');
       
    }           
}
}