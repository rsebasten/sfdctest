/***********************************************************************************************************************
(C)2015
Author: krishnaveni duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  This class update records of Bullet,Fragment and NBT selected into Testing requirement for threats object..
 ***********************************************************************************************************************/
 
@RestResource(urlMapping='/UpdateTRThreat/*')
global class CtrlUpdateTRforThreatService{
   
@HttpPost
global static CtrlKevlarSvcHelper.ReturnClass doPost(){
 CtrlKevlarSvcHelper h = new CtrlKevlarSvcHelper(); 
    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
  
    Set<String> threatTypeSet = new Set<String>();
    Set<Id> testId = new Set<Id>();
    List<Threat_Master__c> threatforTR= new List<Threat_Master__c>();
    List<Testing_Req_for_Threat__c> threatCustom= new List<Testing_Req_for_Threat__c>();
    List<Testing_Req_for_Threat__c> tReqForThreat= new List<Testing_Req_for_Threat__c>();
    Set<Id> threatSet = new Set<Id>();
    Map<Id,String> commentMap = new Map<Id,String>();
    String bacId = '';
    String TRCommonComment = '';
    Set<Id> threatIds = new Set<Id>();
    try{
        system.debug('req.requestBody : ' + req.requestBody.toString()); 
        List<TRWrapper> jsonWrapper = (List<TRWrapper>) JSON.deserialize(req.requestBody.toString(), List<TRWrapper>.class); 
        
        for(TRWrapper wrp : jsonWrapper)
        {
            if(wrp.bullets !=null)
            {
                cls_bullets bulletsObj=wrp.bullets;
            
                if(bulletsObj.records !=null)
                {
                     for(cls_records rec : bulletsObj.records)
                      { 
                        threatIds.add(rec.bulletId);       
                      }
                }
            }
          if(wrp.fragments !=null)
          {
            cls_fragments fragmentsObj=wrp.fragments;
          
              if(fragmentsObj.records !=null)
              {
                  for(cls_records rec : fragmentsObj.records)
                  {
                    if(rec.fragmentId !=null)
                    {
                        threatIds.add(rec.fragmentId);
                    }
                  }
              }
           }
            if(wrp.nonBallistic !=null)
            {
                cls_nonBallistic nonBallisticObj=wrp.nonBallistic;
            
                if(nonBallisticObj.records !=null)
                {
                    for(cls_records rec : nonBallisticObj.records)
                    {
                        if(rec.nbtId !=null)
                        {
                            threatIds.add(rec.nbtId);
                        }
                    }
                }
            }
        }
         
        for(TRWrapper wrp : jsonWrapper)
        {
           
                    bacId = wrp.bacConfigurationID;
                  Map <Id,Testing_Req_for_Threat__c> testmap = new Map <Id,Testing_Req_for_Threat__c>();                                
                  if(threatIds.size()>0)
                  {
                      List<Testing_Req_for_Threat__c> testNeed = [SELECT Id,Name,CommonTestingReqComment__c,Common_Comment__c,Threat_Type__c,BA_Configuration__c,Stab_Location__c,No_Of_Stabs__c,Energy_Level_NBT__c,v50__c,velocity_V50__c,
                                                       Active__c,Angled_Shot__c,Number_of_shots__c,Manual_Testing__c,Contact_Shot__c,BFD_Needed__c,Energy_Level_Joule_NBT__c,
                                                       Penetration_Allowed__c,Clay__c,Environmental_Testing__c,ICW__c,Velocity__c,Wet_Testing__c,Weapon__c,Shooting_Mechnism__c,
                                                       Shooting_Mechanism_Weapon__c, Testing_ID_iOS__c,Test_Standard_Other_Details__c,Type__c,Threat_Level__c,Threat_Selection__c,Test_Standard__c,Shot_Location__c,
                                                       Shooting_Distance__c,Indoor_Outdoor__c,Mass__c,Comments__c,lastmodifieddate,Velocity_Tolerance_m_s__c,Weight__c 
                                                       FROM Testing_Req_for_Threat__c where Threat_Selection__c in :(threatIds) and 
                                                       BA_Configuration__c = : wrp.bacConfigurationID and Active__c = :true limit 1000];                    
                      if(testNeed.size()>0)
                      {
                          for(Testing_Req_for_Threat__c testRecord : testNeed)
                          {
                            testMap.put(testRecord.Threat_Selection__c, testRecord);                          
                          }
                          
                      }
                  }
                 if(wrp.bullets !=null && null !=wrp.lastSync)
                  {
                    cls_bullets bulletsObj=wrp.bullets;
                    threatTypeSet.add(bulletsObj.threatType.toLowerCase());
                  
                  if(bulletsObj.records !=null)
                  {
                      for(cls_records rec : bulletsObj.records)
                      {
                            if(testMap.containsKey(rec.bulletId) && !testMap.isEmpty() && wrp.lastSync > testMap.get(rec.bulletId).LastModifiedDate)
                            {
                                Testing_Req_for_Threat__c trt = testMap.get(rec.bulletId);
                                trt.Name=rec.name;
                                trt.Threat_Type__c=bulletsObj.threatType;
                                trt.Threat_Selection__c = rec.bulletId;
                                trt.ICW__c = bulletsObj.icw;
                                trt.Clay__c = bulletsObj.clay;
                                trt.Indoor_Outdoor__c = bulletsObj.indoorOutdoor;
                                trt.Wet_Testing__c = bulletsObj.wetTesting;
                                trt.Environmental_Testing__c = bulletsObj.environmentalTesting;
                                trt.Manual_Testing__c = false;
                                //trt.Test_Standard__c = bulletsObj.testStandard;
                                if(bulletsObj.testStandard.size()>0)
                                {
                                    trt.Test_Standard__c = String.valueOf(bulletsObj.testStandard);
                                }
                                else{
                                    trt.Test_Standard__c=null;
                                }
                                trt.CommonTestingReqComment__c = bulletsObj.comments;//comment in common testing req section
                                trt.Common_Comment__c = bulletsObj.commonComment;//comment field at the bottom of the testing need screen
                                trt.Type__c = rec.bulletType;
                                trt.Shooting_Distance__c = rec.shootingDistance;
                                trt.V50__c = rec.v50; // changed from picklist to Number field
                                trt.Velocity__c = rec.velocity;
                                trt.Velocity_Tolerance_m_s__c = rec.velocityRange;
                                trt.Shooting_Mechnism__c = rec.weapon;
                                trt.Shot_Location__c = rec.shotLocation;
                                trt.Number_of_shots__c = rec.numberOfShots;
                                if(rec.angledShot.size()>0)
                                {
                                    trt.Angled_Shot__c = String.valueOf(rec.angledShot);
                                }
                                else{
                                    trt.Angled_Shot__c=null;
                                }
                                trt.BFD_Needed__c = rec.bfd; 
                                trt.Contact_Shot__c = rec.contactShot;
                                trt.Comments__c=rec.comment;//comment field for each bullet on threat screen
                             //   system.debug('----trt1---'+trt);
                                tReqForThreat.add(trt);
                            }
                        }
                    }
                }
                if(wrp.fragments !=null && null !=wrp.lastSync)
                {
                    cls_fragments fragmentsObj=wrp.fragments;
                    threatTypeSet.add(fragmentsObj.threatType.toLowerCase());
                  
                     if(fragmentsObj.records !=null)
                     {
                        for(cls_records rec : fragmentsObj.records)
                        {
                           if(testMap.containsKey(rec.fragmentId) && !testMap.isEmpty() && wrp.lastSync > testMap.get(rec.fragmentId).LastModifiedDate){
                                Testing_Req_for_Threat__c trt = testMap.get(rec.fragmentId);
                                trt.Name=rec.name;
                                trt.Threat_Type__c=fragmentsObj.threatType;
                                trt.Threat_Selection__c = rec.fragmentId;
                                trt.ICW__c = fragmentsObj.icw;
                                trt.Clay__c = fragmentsObj.clay;
                                trt.Indoor_Outdoor__c = fragmentsObj.indoorOutdoor;
                                trt.Wet_Testing__c = fragmentsObj.wetTesting;
                                trt.Environmental_Testing__c = fragmentsObj.environmentalTesting;
                                trt.Manual_Testing__c = false;
                                if(fragmentsObj.testStandard.size()>0){                                
                                    trt.Test_Standard__c = String.valueOf(fragmentsObj.testStandard);
                                }
                                else{
                                    trt.Test_Standard__c=null;
                                }
                                trt.CommonTestingReqComment__c = fragmentsObj.comments;//comment in common testing req section 
                                trt.Common_Comment__c = fragmentsObj.commonComment; //comment field at the bottom of the testing need screen
                                trt.Type__c = rec.fragmentType;
                                trt.Velocity__c = rec.velocity;
                                trt.Velocity_Tolerance_m_s__c = rec.velocityRange;
                                trt.Shooting_Mechnism__c = rec.weapon;
                                trt.V50__c = rec.v50;
                                trt.Comments__c=rec.comment; // comment field for each bullet on threat screen
                           //     system.debug('----trt fragment---'+trt);
                                tReqForThreat.add(trt);     
                            }
                        }
                     }
                }
                  if(wrp.nonBallistic !=null && wrp.lastSync !=null)
                   {
                        cls_nonBallistic nonBallisticObj=wrp.nonBallistic;
                        threatTypeSet.add(nonBallisticObj.threatType.toLowerCase());
                        
                    if(nonBallisticObj.records !=null){
                        for(cls_records rec : nonBallisticObj.records)
                        {
                                               
                         	if(testMap.containsKey(rec.nbtId) && !testMap.isEmpty() && wrp.lastSync > testMap.get(rec.nbtId).LastModifiedDate)
                          	{
                                Testing_Req_for_Threat__c trt = testMap.get(rec.nbtId);
                                trt.Name=rec.name;
                                trt.Threat_Type__c=nonBallisticObj.threatType;
                                trt.Threat_Selection__c = rec.nbtId;
                                trt.ICW__c = nonBallisticObj.icw;
                                trt.Clay__c = nonBallisticObj.clay;
                                trt.Indoor_Outdoor__c = nonBallisticObj.indoorOutdoor;
                                trt.Wet_Testing__c = nonBallisticObj.wetTesting;
                                trt.Environmental_Testing__c = nonBallisticObj.environmentalTesting;
                                if(nonBallisticObj.testStandard.size()>0)
                                {
                                    trt.Test_Standard__c = String.valueOf(nonBallisticObj.testStandard);
                                }
                                else{
                                    trt.Test_Standard__c=null;
                                }
                                trt.CommonTestingReqComment__c = nonBallisticObj.comments;//comment in common testing req section
                                trt.Common_Comment__c = nonBallisticObj.commonComment;//comment field at the bottom of the testing need screen
                                trt.Type__c = rec.nonBallisticType;
                                trt.Manual_Testing__c = nonBallisticObj.manualTesting;
                                trt.Energy_Level_Joule_NBT__c  = rec.joules ;   
                                trt.Energy_Level_NBT__c = rec.energyLevel;
                                trt.Penetration_Allowed__c =rec.permissiblePenetration;     
                                trt.Threat_Level__c = rec.threatLevel;
                                if(rec.angledShot.size()>0 && !rec.angledShot.isEmpty())
                                {
                                    trt.Angled_Shot__c = String.valueOf(rec.angledShot);
                                }
                                trt.Stab_Location__c=rec.stabLocations;
                                trt.No_Of_Stabs__c=rec.numberOfStabs;
                                if(rec.mass != null)
                                {
                                  trt.Mass__c=rec.mass;   
                                }
                                trt.Comments__c=rec.comment;// comment for each bullet on threat screen
                           //     system.debug('----trt nbt---'+trt);
                                tReqForThreat.add(trt); 
                           }
                       }
                    }
                }
           }
             
        if(tReqForThreat.size()>0){
           database.update(tReqForThreat);
        }
            for(Testing_Req_for_Threat__c test : tReqForThreat){
                testId.add(test.Id);
                threatSet.add(test.Threat_Selection__c);
            }
              List<Testing_Req_for_Threat__c> testingList =[SELECT Id,Name,Threat_Type__c,CommonTestingReqComment__c,Common_Comment__c,BA_Configuration__c,Stab_Location__c,No_Of_Stabs__c,Energy_Level_NBT__c,v50__c,velocity_V50__c,
                                                       Active__c,Angled_Shot__c,Number_of_shots__c,Contact_Shot__c,BFD_Needed__c,Energy_Level_Joule_NBT__c,
                                                       Penetration_Allowed__c,Clay__c,Manual_Testing__c,Environmental_Testing__c,ICW__c,Velocity__c,Wet_Testing__c,Weapon__c,Shooting_Mechnism__c,
                                                       Shooting_Mechanism_Weapon__c,Testing_ID_iOS__c,Test_Standard_Other_Details__c,Type__c,Threat_Level__c,Threat_Selection__c,Test_Standard__c,Shot_Location__c,
                                                       Shooting_Distance__c,Indoor_Outdoor__c,Mass__c,Comments__c,lastmodifieddate,Velocity_Tolerance_m_s__c,Weight__c 
                                                       FROM Testing_Req_for_Threat__c WHERE Threat_Selection__c in:(threatSet) and BA_Configuration__c = : bacId and Active__c = true limit 1000];
            if(!testingList.isEmpty()){ 
                JSONGenerator gen = JSON.createGenerator(true);
                Integer flagBullet=0,flagFrag=0,flagNBT=0;
                gen.writeStartObject();//json starts
                  gen.writeStringField('bacConfigurationID',testingList[0].BA_Configuration__c);
                        if(threatTypeSet.contains('bullet')){
                            system.debug('entered bullet');
                            gen.writeFieldName('bullets');
                            gen.writeStartObject();
                                for(Testing_Req_for_Threat__c tr : testingList){
                                    if(tr.Threat_Type__c.equalsIgnoreCase('Bullet')){
                                        if(flagBullet==0){
                                            flagBullet=1;
                                            gen.writeBooleanField('icw', tr.ICW__c);
                                            gen.writeStringField('threatType', tr.Threat_Type__c);
                                            if(!String.isBlank(tr.Clay__c)){
                                              gen.writeStringField('clay', tr.Clay__c);
                                            }
                                            else{
                                                gen.writeStringField('clay', '');
                                            }
                                            if(!String.isBlank(tr.Indoor_Outdoor__c)){
                                                gen.writeStringField('indoorOutdoor', tr.Indoor_Outdoor__c);
                                            }
                                            else{
                                                gen.writeStringField('indoorOutdoor', '');
                                            }
                                            gen.writeBooleanField('wetTesting', tr.Wet_Testing__c);
                                            gen.writeBooleanField('environmentalTesting', tr.Environmental_Testing__c);
                                            if(!String.isBlank(tr.Test_Standard__c)){
                                                List<String> tempInt=new List<String>();
                                                if(tr.Test_Standard__c.contains(';')){
                                                    for(String s : tr.Test_Standard__c.replace('[','').replace(']','').split(';')){
                                                        tempInt.add(s.trim());
                                                    }
                                                }
                                                else{
                                                    for(String s : tr.Test_Standard__c.replace('(','').replace(')','').split(',')){
                                                        tempInt.add(s.trim());
                                                    } 
                                                }
                                                
                                                gen.writeObjectField('testStandard', tempInt);
                                            }
                                            else{
                                                List<String> tempInt=new List<String>();
                                                gen.writeObjectField('testStandard', tempInt);
                                            }
                                            if(!String.isBlank(tr.CommonTestingReqComment__c)){
                                                gen.writeStringField('comments', tr.CommonTestingReqComment__c);
                                            }
                                            else{
                                                gen.writeStringField('comments', '');
                                            }
                                            if(!String.isBlank(tr.Common_Comment__c)){
                                                gen.writeStringField('commonComment', tr.Common_Comment__c);
                                            }
                                            else{
                                                gen.writeStringField('commonComment', '');
                                            }
                                            gen.writeFieldName('records');
                                            gen.writeStartArray();//bullet array starts
                                            
                                        }
                                                gen.writeStartObject();
                                                    gen.writeStringField('name', tr.Name);
                                                    gen.writeStringField('bulletId', tr.Threat_Selection__c);//send testing need id
                                                    if(!String.isBlank(tr.Type__c)){
                                                        gen.writeStringField('bulletType', tr.Type__c);
                                                    }
                                                    else{
                                                        gen.writeStringField('bulletType', '');
                                                    }
                                                    if(tr.Shooting_Distance__c<>null){
                                                      gen.writeNumberField('shootingDistance', tr.Shooting_Distance__c);
                                                    }
                                                    else{
                                                        gen.writeNumberField('shootingDistance', 0);
                                                    }
                                                    if(tr.Velocity__c<>null){
                                                      gen.writeNumberField('velocity', tr.Velocity__c);
                                                    }
                                                    else{
                                                        gen.writeNumberField('velocity', 0);
                                                    }
                                                    if(tr.Velocity_Tolerance_m_s__c<>null){
                                                      gen.writeNumberField('velocityRange', tr.Velocity_Tolerance_m_s__c);
                                                    }
                                                    else{
                                                        gen.writeNumberField('velocityRange', 0);
                                                    }
                                                    if(tr.V50__c <> null){
                                                        gen.writeNumberField('v50', tr.V50__c);
                                                    } 
                                                    else{
                                                        gen.writeNumberField('v50', 0);
                                                    }
                                                    if(!String.isBlank(tr.Shooting_Mechnism__c)){
                                                        gen.writeStringField('weapon', tr.Shooting_Mechnism__c);
                                                    }
                                                    else{
                                                        gen.writeStringField('weapon', '');
                                                    }
                                                    if(!String.isBlank(tr.Shot_Location__c)){
                                                        gen.writeStringField('shotLocation', tr.Shot_Location__c);
                                                    }
                                                    else{
                                                        gen.writeStringField('shotLocation', '');
                                                    }
                                                    if(!String.isBlank(tr.Number_of_shots__c)){
                                                        gen.writeStringField('numberOfShots', tr.Number_of_shots__c);
                                                    }
                                                    else{
                                                        gen.writeStringField('numberOfShots', '');
                                                    }
                                                    if(!String.isBlank(tr.Angled_Shot__c)){
                                                       List<Integer> tempInt=new List<Integer>();
                                                        if(tr.Angled_Shot__c.contains(';')){
                                                            for(String s : tr.Angled_Shot__c.replace('[','').replace(']','').split(';')){
                                                                tempInt.add(Integer.valueOf(s.trim()));
                                                            }
                                                        }
                                                        else{
                                                           for(String s : tr.Angled_Shot__c.replace('(','').replace(')','').split(',')){
                                                                tempInt.add(Integer.valueOf(s.trim()));
                                                            } 
                                                        }
                                                        
                                                        gen.writeObjectField('angledShot', tempInt);
                                                    }
                                                    else{
                                                        List<Integer> tempInt=new List<Integer>();
                                                        gen.writeObjectField('angledShot', tempInt);
                                                    }
                                                    if(!String.isBlank(tr.Contact_Shot__c)){
                                                        gen.writeStringField('contactShot', tr.Contact_Shot__c);
                                                    }
                                                    else{
                                                        gen.writeStringField('contactShot', '');
                                                    }
                                                    if(tr.BFD_Needed__c<>null){
                                                      gen.writeNumberField('bfd', tr.BFD_Needed__c);
                                                    }
                                                    else{
                                                        gen.writeNumberField('bfd', 0);
                                                    }
                                                    if(!String.isBlank(tr.Comments__c)){
                                                        gen.writeStringField('comment', tr.Comments__c);
                                                    }
                                                    else{
                                                        gen.writeStringField('comment', '');
                                                    }
                                                gen.writeEndObject();
                                    }
                                }
                                        if(flagBullet==1){
                                            gen.writeEndArray();//bullet array ends
                                        }
                            gen.writeEndObject();
                            
                        }
                        if(threatTypeSet.contains('fragment')){
                            
                            gen.writeFieldName('fragments');
                            gen.writeStartObject();
                                for(Testing_Req_for_Threat__c tr : testingList){
                                    if(tr.Threat_Type__c.equalsIgnoreCase('Fragment')){
                                        if(flagFrag==0){
                                            flagFrag=1;
                                            gen.writeBooleanField('icw', tr.ICW__c);
                                            gen.writeStringField('threatType', tr.Threat_Type__c);
                                            if(!String.isBlank(tr.Clay__c)){
                                              gen.writeStringField('clay', tr.Clay__c);
                                            }
                                            else{
                                                gen.writeStringField('clay', '');
                                            }
                                            if(!String.isBlank(tr.Indoor_Outdoor__c)){
                                                gen.writeStringField('indoorOutdoor', tr.Indoor_Outdoor__c);
                                            }
                                            else{
                                                gen.writeStringField('indoorOutdoor', '');
                                            }
                                            gen.writeBooleanField('wetTesting', tr.Wet_Testing__c);
                                            gen.writeBooleanField('environmentalTesting', tr.Environmental_Testing__c);
                                            if(!String.isBlank(tr.Test_Standard__c)){
                                                List<String> tempInt=new List<String>();
                                                if(tr.Test_Standard__c.contains(';')){
                                                    for(String s : tr.Test_Standard__c.replace('[','').replace(']','').split(';')){
                                                        tempInt.add(s.trim());
                                                    }
                                                }
                                                else{
                                                    for(String s : tr.Test_Standard__c.replace('(','').replace(')','').split(',')){
                                                        tempInt.add(s.trim());
                                                    } 
                                                }
                                                
                                                gen.writeObjectField('testStandard', tempInt);
                                            }
                                            else{
                                                List<String> tempInt=new List<String>();
                                                gen.writeObjectField('testStandard', tempInt);
                                            }
                                            if(!String.isBlank(tr.CommonTestingReqComment__c)){
                                                gen.writeStringField('comments', tr.CommonTestingReqComment__c);
                                            }
                                            else{
                                                gen.writeStringField('comments', '');
                                            }
                                            if(!String.isBlank(tr.Common_Comment__c)){
                                                gen.writeStringField('commonComment', tr.Common_Comment__c);
                                            }
                                            else{
                                                gen.writeStringField('commonComment', '');
                                            }
                                            gen.writeFieldName('records');
                                            gen.writeStartArray();//fragment array starts                                        
                                        }
                                                gen.writeStartObject();
                                                    gen.writeStringField('name', tr.Name);
                                                    gen.writeStringField('fragmentId', tr.Threat_Selection__c);//send testing need id
                                                    gen.writeStringField('fragmentType', tr.Name);
                                                    
                                                    if(tr.Velocity__c<>null){
                                                      gen.writeNumberField('velocity', tr.Velocity__c);
                                                    }
                                                    else{
                                                        gen.writeNumberField('velocity', 0);
                                                    }
                                                    if(tr.Velocity_Tolerance_m_s__c<>null){
                                                      gen.writeNumberField('velocityRange', tr.Velocity_Tolerance_m_s__c);
                                                    }
                                                    else{
                                                        gen.writeNumberField('velocityRange', 0);
                                                    }
                                                    if(tr.V50__c <> null){
                                                        gen.writeNumberField('v50', tr.V50__c); // v50 is now a number field
                                                    } 
                                                    else{
                                                        gen.writeNumberField('v50', 0);
                                                    }
                                                    if(!String.isBlank(tr.Shooting_Mechnism__c)){
                                                        gen.writeStringField('weapon', tr.Shooting_Mechnism__c);
                                                    }
                                                    else{
                                                        gen.writeStringField('weapon', '');
                                                    }
                                                    if(!String.isBlank(tr.Comments__c)){
                                                        gen.writeStringField('comment', tr.Comments__c);
                                                    }
                                                    else{
                                                        gen.writeStringField('comment', '');
                                                    }
                                                gen.writeEndObject();
                                    }
                                }
                                        if(flagFrag==1){
                                            gen.writeEndArray();//fragment array ends
                                        }
                            gen.writeEndObject();
                            
                        }
                        if(threatTypeSet.contains('nbt')){
                            
                            gen.writeFieldName('nonBallistic');
                            gen.writeStartObject();
                                    for(Testing_Req_for_Threat__c tr : testingList){
                                        if(tr.Threat_Type__c.equalsIgnoreCase('NBT')){
                                            if(flagNBT==0){
                                                flagNBT=1;
                                                gen.writeBooleanField('icw', tr.ICW__c);
                                                gen.writeStringField('threatType', tr.Threat_Type__c);
                                                if(!String.isBlank(tr.Clay__c)){
                                                    gen.writeStringField('clay', tr.Clay__c);
                                                }
                                                else{
                                                    gen.writeStringField('clay', '');
                                                }
                                                if(!String.isBlank(tr.Indoor_Outdoor__c)){
                                                    gen.writeStringField('indoorOutdoor', tr.Indoor_Outdoor__c);
                                                }
                                                else{
                                                    gen.writeStringField('indoorOutdoor', '');
                                                }
                                                gen.writeBooleanField('wetTesting', tr.Wet_Testing__c);
                                                gen.writeBooleanField('environmentalTesting', tr.Environmental_Testing__c);
                                                gen.writeBooleanField('manualTesting',tr.Manual_Testing__c);
                                                if(!String.isBlank(tr.Test_Standard__c)){
                                                    List<String> tempInt=new List<String>();
                                                    if(tr.Test_Standard__c.contains(';')){
                                                        for(String s : tr.Test_Standard__c.replace('[','').replace(']','').split(';')){
                                                            tempInt.add(s.trim());
                                                        }
                                                    }
                                                    else{
                                                        for(String s : tr.Test_Standard__c.replace('(','').replace(')','').split(',')){
                                                            tempInt.add(s.trim());
                                                        } 
                                                    }
                                                    
                                                    gen.writeObjectField('testStandard', tempInt);
                                                }
                                                else{
                                                    List<String> tempInt=new List<String>();
                                                    gen.writeObjectField('testStandard', tempInt);
                                                }
                                                if(!String.isBlank(tr.CommonTestingReqComment__c)){
                                                    gen.writeStringField('comments', tr.CommonTestingReqComment__c);
                                                }
                                                else{
                                                    gen.writeStringField('comments', '');
                                                }
                                                    if(!String.isBlank(tr.Common_Comment__c)){
                                                    gen.writeStringField('commonComment', tr.Common_Comment__c);
                                                }
                                                else{
                                                    gen.writeStringField('commonComment', '');
                                                }
                                                gen.writeFieldName('records');
                                                gen.writeStartArray();//nbt array starts 
                                            }
                                                   gen.writeStartObject();
                                                      gen.writeStringField('name', tr.Name);
                                                      gen.writeStringField('nbtId', tr.Threat_Selection__c);//send testing need id
                                                        if(!String.isBlank(tr.Type__c)){
                                                            gen.writeStringField('nonBallisticType', tr.Type__c);
                                                        }
                                                        else{
                                                            gen.writeStringField('nonBallisticType', '');
                                                        }
                                                      if(!String.isBlank(tr.Threat_Level__c)){
                                                            gen.writeStringField('threatLevel', tr.Threat_Level__c);
                                                        }
                                                        else{
                                                            gen.writeStringField('threatLevel', '');
                                                        } 
                                                        if(!String.isBlank(tr.Energy_Level_NBT__c)){
                                                            gen.writeStringField('energyLevel', tr.Energy_Level_NBT__c);
                                                        }
                                                        else{
                                                            gen.writeStringField('energyLevel', '');
                                                        }
                                                        if(!String.isBlank(tr.Energy_Level_Joule_NBT__c)){
                                                            gen.writeStringField('joules', tr.Energy_Level_Joule_NBT__c);
                                                        }
                                                        else{
                                                            gen.writeStringField('joules', '');
                                                        }
                                                        if(!String.isBlank(tr.Penetration_Allowed__c)){
                                                            gen.writeStringField('permissiblePenetration', tr.Penetration_Allowed__c);
                                                        }
                                                        else{
                                                            gen.writeStringField('permissiblePenetration', '');
                                                        }
                                                      if(!String.isBlank(tr.Angled_Shot__c)){
                                                            List<Integer> tempInt=new List<Integer>();
                                                            if(tr.Angled_Shot__c.contains(';')){
                                                                for(String s : tr.Angled_Shot__c.replace('[','').replace(']','').split(';')){
                                                                    tempInt.add(Integer.valueOf(s.trim()));
                                                                }
                                                            }
                                                            else{
                                                               for(String s : tr.Angled_Shot__c.replace('(','').replace(')','').split(',')){
                                                                    tempInt.add(Integer.valueOf(s.trim()));
                                                                } 
                                                            }
                                                            
                                                            gen.writeObjectField('angledShot', tempInt);
                                                       }
                                                       else{
                                                            List<Integer> tempInt=new List<Integer>();
                                                            gen.writeObjectField('angledShot', tempInt);
                                                       }
                                                        if(!String.isBlank(tr.Stab_Location__c)){
                                                            gen.writeStringField('stabLocations', tr.Stab_Location__c);
                                                        }
                                                        else{
                                                            gen.writeStringField('stabLocations', '');
                                                        } 
                                                        if(!String.isBlank(tr.No_Of_Stabs__c)){
                                                            gen.writeStringField('numberOfStabs', tr.No_Of_Stabs__c);
                                                        }
                                                        else{
                                                            gen.writeStringField('numberOfStabs', '');
                                                        } 
                                                        
                                                        if(tr.Mass__c<> null){
                                                            gen.writeNumberField('mass', tr.Mass__c);
                                                        }
                                                        else{
                                                            gen.writeNumberField('mass', 0);
                                                        }   
                                                        if(!String.isBlank(tr.Comments__c)){
                                                            gen.writeStringField('comment', tr.Comments__c);
                                                        }
                                                        else{
                                                            gen.writeStringField('comment', '');
                                                        }            
                                                    gen.writeEndObject();
                                        }
                                    }
                                    if(flagNBT==1){
                                        gen.writeEndArray();//nonBallistic array ends
                                    }
                            gen.writeEndObject();
                            
                        }
                gen.writeEndObject();//json ends  
                
                String prettyJSON=gen.getAsString();
                system.debug('prettyJSON : ' + prettyJSON);
               
                return new CtrlKevlarSvcHelper.ReturnClass(h.dataSent, h.getMessage('200'),h.getResponseMessage('525'),'525', prettyJSON, null, '200','null');
            }
            else{
               return new CtrlKevlarSvcHelper.ReturnClass(h.dataNotSent, h.getMessage('201'),null,null, null, null, '201');
            }  
        
     }
     catch(Exception e){
        System.debug('Error----------'+e.getMessage());
        return new CtrlKevlarSvcHelper.ReturnClass(h.dataNotSent, h.getMessage('203'),'Update failed!',null, null, null, '203');
     }       
}

      global class TRWrapper{  
          public String bacConfigurationID;
          public cls_bullets bullets;
          public cls_fragments fragments;
          public cls_nonBallistic nonBallistic;
          public DateTime lastSync;
          
          public TRWrapper(cls_bullets bullets,cls_fragments fragments,cls_nonBallistic nonBallistic){
            this.bullets=bullets;
            this.fragments=fragments;
            this.nonBallistic=nonBallistic;
          }
        }
        global class cls_bullets {
          public boolean icw;
          public String threatType;
          public String clay;  
          public String indoorOutdoor;  
          public boolean wetTesting;
          public String clayType;  
          public boolean environmentalTesting;
          public List<String> testStandard;  
          public String comments; 
          public String commonComment;
          public List<cls_records> records;
          
          public cls_bullets(List<cls_records> records){
            this.records=records;
          }
        }
        global class cls_records {
          public String comment;  
          public String name;
          public List<Integer> angledShot;  
          //NBT
          public String nonBallisticType;  
          public String threatLevel;  
          public String energyLevel;  
          public String joules;  
          public String BluntComment;  
          public String NeedleComment;
          public String SpikeComment;    
          public String permissiblePenetration;  
          public String PenetrationComment;
          public String stabLocations;  
          public String numberOfStabs;  
          public Decimal mass;
          public String nbtId;
          public String angle;
            
          
          //Bullet
          public String bulletType;
          public Decimal shootingDistance;
          public Decimal velocity;
          public Decimal velocityRange;
   //       public Decimal velocity50;
          
          public String weapon;
          public String shotLocation;
          public String numberOfShots;
          public String bulletId;
          public String contactShot;
          public Decimal bfd;
          
          //Fragment
          public String fragmentType;
          public String fragmentId;
          public Decimal v50; // datatype will change in backlog sprint 2
        }
        
        global class cls_fragments {
          public String threatType;
          public boolean icw;
          public String clay;  
          public String indoorOutdoor;  
          public boolean wetTesting;
          public String clayType;  
          public boolean environmentalTesting;
          public List<String> testStandard;  
          public String comments;
          public String commonComment;  
          public List<cls_records> records;
          
          public cls_fragments(List<cls_records> records){
            this.records=records;
          }
        }
        global class cls_nonBallistic {
          public String threatType;
          public boolean icw;
          public String clay;  
          public String indoorOutdoor;  
          public boolean wetTesting;
          public String clayType;  
          public boolean environmentalTesting;
          public List<String> testStandard;  
          public String comments;
          public String commonComment; 
          public boolean manualTesting;
         
          public List<cls_records> records;
         
          public cls_nonBallistic(List<cls_records> records){
            this.records=records;
          }
        }


}