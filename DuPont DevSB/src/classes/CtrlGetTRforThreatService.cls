/*******************************************************************************
(C)2016
Author: krishnaveni duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  This class Populate Testing Needs.
 ********************************************************************************/

@RestResource(urlMapping = '/GetTR/*')
global class CtrlGetTRforThreatService{

@HttpPost
global static CtrlKevlarSvcHelper.ReturnClass doPost(){
    CtrlKevlarSvcHelper h = new CtrlKevlarSvcHelper();
    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
  
      try{
        system.debug('req.requestBody : ' + req.requestBody.toString());  
        TRWrapper tWrap = (TRWrapper) JSON.deserialize(req.requestBody.toString(), TRWrapper.class);  
        Set<String> threatTypeSet = new Set<String>();
        threatTypeSet.add(tWrap.threatType1);
        threatTypeSet.add(tWrap.threatType2);
        threatTypeSet.add(tWrap.threatType3);
      
        List<Testing_Req_for_Threat__c> testingList =[SELECT Id,CommonTestingReqComment__c,Common_Comment__c,Name,Threat_Type__c,Mass__c,BA_Configuration__c,V50__c,Velocity_V50__c,Stab_Location__c,No_Of_Stabs__c,Energy_Level_NBT__c,
                                                       Active__c,Angled_Shot__c,Number_of_shots__c,Manual_Testing__c,Contact_Shot__c,BFD_Needed__c,Energy_Level_Joule_NBT__c,
                                                       Penetration_Allowed__c,Clay__c,Environmental_Testing__c,ICW__c,Velocity__c,Wet_Testing__c,Weapon__c,Shooting_Mechnism__c,
                                                       Shooting_Mechanism_Weapon__c, Testing_ID_iOS__c,Test_Standard__c,Test_Standard_Other_Details__c,Type__c,Threat_Level__c,Threat_Selection__c,Shot_Location__c,
                                                       Shooting_Distance__c,Indoor_Outdoor__c,Comments__c,Velocity_Tolerance_m_s__c,Weight__c 
                                                       FROM Testing_Req_for_Threat__c WHERE BA_Configuration__c=:tWrap.bacConfigurationID and Active__c =:true limit 1000];
      
      
        if(!testingList.isEmpty()){ 
           
            JSONGenerator gen = JSON.createGenerator(true);
            Integer flagBullet=0,flagFrag=0,flagNBT=0;
            gen.writeStartObject();//json starts
              gen.writeStringField('bacConfigurationID',testingList[0].BA_Configuration__c);
               if(!String.isBlank(tWrap.threatType1)){
                    if(tWrap.threatType1.equalsIgnoreCase('Bullet')){
              //      system.debug('entered bullet');
                        gen.writeFieldName('bullets');
                        gen.writeStartObject();
                            for(Testing_Req_for_Threat__c tr : testingList){
                                if(tr.Threat_Type__c.equalsIgnoreCase('Bullet')){
                                    if(flagBullet==0){
                                        flagBullet=1;
                                        gen.writeBooleanField('icw', tr.ICW__c);
                                        if(!String.isBlank(tr.Threat_Type__c)){
                                            gen.writeStringField('threatType', tr.Threat_Type__c);
                                        }
                                        else{
                                            gen.writeStringField('threatType', '');
                                        }
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
                                                gen.writeStringField('bulletId', tr.Threat_Selection__c);//send threat master id
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
                                                  List<String> tempInt=new List<String>();
                                                    if(tr.Angled_Shot__c.contains(';')){
                                                        for(String s : tr.Angled_Shot__c.replace('[','').replace(']','').split(';')){
                                                            tempInt.add(s.trim());
                                                        }
                                                    }
                                                    else{
                                                       for(String s : tr.Angled_Shot__c.replace('(','').replace(')','').split(',')){
                                                            tempInt.add(s.trim());
                                                        } 
                                                    }
                                      
                                                    gen.writeObjectField('angledShot', tempInt);
                                                }
                                                else{
                                                    List<String> tempInt=new List<String>();
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
                 //       system.debug('exit bullet');
                    }
                    }
                    if(!String.isBlank(tWrap.threatType2)){
                    if(tWrap.threatType2.equalsIgnoreCase('Fragment')){
                 //       system.debug('entered fragment');
                        gen.writeFieldName('fragments');
                        gen.writeStartObject();
                            for(Testing_Req_for_Threat__c tr : testingList){
                                if(tr.Threat_Type__c.equalsIgnoreCase('Fragment')){
                                    if(flagFrag==0){
                                        flagFrag=1;
                                        gen.writeBooleanField('icw', tr.ICW__c);
                                        if(!String.isBlank(tr.Threat_Type__c)){
                                            gen.writeStringField('threatType', tr.Threat_Type__c);
                                        }
                                        else{
                                            gen.writeStringField('threatType', '');
                                        }
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
                                                gen.writeStringField('fragmentId', tr.Threat_Selection__c);//send threat master id
                                                if(!String.isBlank(tr.Type__c)){
                                                    gen.writeStringField('fragmentType', tr.Type__c);
                                                }
                                                else{
                                                    gen.writeStringField('fragmentType', '');
                                                }
                                             
                                             // velocity 50 changed to number field now
                                                   if(tr.V50__c <> null){
                                                        gen.writeNumberField('v50', tr.V50__c);
                                                    }
                                                    else{
                                                        gen.writeNumberField('v50', 0);
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
                    }
                    if(!String.isBlank(tWrap.threatType3)){
                        if(tWrap.threatType3.equalsIgnoreCase('NBT')){
                  
                        gen.writeFieldName('nonBallistic');
                        gen.writeStartObject();
                                for(Testing_Req_for_Threat__c tr : testingList){
                                    if(tr.Threat_Type__c.equalsIgnoreCase('NBT')){
                                        if(flagNBT==0){
                                            flagNBT=1;
                                            gen.writeBooleanField('icw', tr.ICW__c);
                                            if(!String.isBlank(tr.Threat_Type__c)){
                                                gen.writeStringField('threatType', tr.Threat_Type__c);
                                            }
                                            else{
                                                gen.writeStringField('threatType', '');
                                            }
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
                                                    gen.writeStringField('nbtId', tr.Threat_Selection__c);//send threat master id
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
                                                      List<String> tempInt=new List<String>();
                                                        if(tr.Angled_Shot__c.contains(';')){
                                                            for(String s : tr.Angled_Shot__c.replace('[','').replace(']','').split(';')){
                                                                tempInt.add(s.trim());
                                                            }
                                                        }
                                                        else{
                                                           for(String s : tr.Angled_Shot__c.replace('(','').replace(')','').split(',')){
                                                                tempInt.add(s.trim());
                                                            } 
                                                        }
                                              
                                                        gen.writeObjectField('angledShot', tempInt);
                                                    }
                                                    else{
                                                        List<String> tempInt=new List<String>();
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
                                                    if(tr.Mass__c <> null){
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
                                       gen.writeEndArray();//nbt array ends 
                                    }
                        gen.writeEndObject();
                    
                    }
                  }
            gen.writeEndObject();//json ends  
            
            String prettyJSON=gen.getAsString();
            system.debug('@@@@@prettyJSON : ' + prettyJSON);
            return new CtrlKevlarSvcHelper.ReturnClass(h.dataSent, h.getMessage('200'),h.getResponseMessage('519'),'519', prettyJSON, null, '200','null');
        }
        else{ 
           return new CtrlKevlarSvcHelper.ReturnClass(h.dataSent, h.getMessage('201'),null,null, null, null, '201');
        }  
     }   
     catch(Exception e){
        System.debug('Error----------'+e.getMessage());
        //return e.getMessage();
        return new CtrlKevlarSvcHelper.ReturnClass(h.dataNotSent, h.getMessage('203'),'Data loading failed!',null, null, null, '203');
     } 

}

global class TRWrapper{
     public String bacConfigurationID;
     public String threatType1;
     public String threatType2;
     public String threatType3;
   }
}