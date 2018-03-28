/***********************************************************************************************************************
(C)2015
Author: krishnaveni duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  This class Insert records of Bullet,Fragment and NBT selected into Testing requirement for threats object..
 ***********************************************************************************************************************/
 
@RestResource(urlMapping='/TRforThreat/*')
global class CtrlRequirementforThreatService{
    
    static Map<Id, cls_value> clsValueMap = new Map<Id, cls_value>();
    static Map<Id, cls_nonBallistic> clsNBTMap = new Map<Id, cls_nonBallistic>();
    static Map<Id, cls_bullets> clsBulletMap = new Map<Id, cls_bullets>();
    static Map<Id, cls_fragments> clsFragMap = new Map<Id, cls_fragments>();
    static String bacConfigurationId_global;
    
  global class TRWrapper{ 
        public String bacConfigurationId;
        public List<String> deleted;
        public String dml;//this param decides whether threatIdSet contains threatMaster Id or testingNeed Id
        public List<cls_nonBallistic> nonBallistic;
        public List<cls_fragments> fragments;
        public List<cls_bullets> bullets;
        
        public TRWrapper(List<cls_nonBallistic> nonBallistic,List<cls_fragments> fragments,List<cls_bullets> bullets){
            this.nonBallistic=nonBallistic;
            this.fragments=fragments;
            this.bullets=bullets;
        }
    }      
      class cls_nonBallistic {
            public String name;     
            public List<cls_value> value;
            public String nbtId;  
            public String comments;
            public String threatType;
            public cls_nonBallistic(List<cls_value> value){
                this.value=value;
            }
        }
        class cls_value {
            public String bulletType;  
            public String bulletId;  
            public String comments;
            public String name;
            public String nbtId;
        }
        class cls_fragments {
            public String fragmentType;  
            public String fragmentId;    
            public String comments;
            public String threatType;
        }
        class cls_bullets {
            public String name;
            public String bulletId;
            public String comments;
            public String threatType;
            public List<cls_value> value;
            public cls_bullets(List<cls_value> value){
                this.value=value;
            }
        }

    
    global static list<Testing_Req_for_Threat__c> createTR(Set<id> threatIdSet){
    
      List<Testing_Req_for_Threat__c> tempTRList=new List<Testing_Req_for_Threat__c>();
            
      List<Threat_Master__c> threatList =[SELECT Id,Name,Active__c,Threat_Type__c,Angled_Shot__c,Contact_Shot__c,BFD_Needed__c,Clay__c,v50__c,velocity_V50__c,
                                        Environmental_Testing__c,Energy_Level_Joule_NBT__c,Energy_Level_NBT__c,ICW__c,
                                        Velocity__c,Wet_Testing__c,Weapon__c,Penetration_Allowed__c,Shooting_Mechnism__c,
                                        Shooting_Mechanism_Weapon__c, Threat_ID_iOS__c,Test_Standard_Other_Details__c,
                                        Type__c,Threat_Level__c,Test_Standard__c,Shot_Locations__c,Shooting_Distance__c,
                                        Number_of_shots__c,Indoor_Outdoor__c,Comments__c,Velocity_Tolerance_m_s__c,Weight__c 
                                        FROM Threat_Master__c WHERE Id in:(threatIdSet)];
        for(Threat_Master__c th : threatList){        
              Testing_Req_for_Threat__c trt = new Testing_Req_for_Threat__c();
              trt.Name=th.Name;
              trt.Active__c = th.Active__c;
              trt.Angled_Shot__c = th.Angled_Shot__c;
              trt.BA_Configuration__c = bacConfigurationId_global;  
              trt.Clay__c = th.Clay__c;
              if(th.Threat_Type__c.equalsIgnorecase('nbt')){
                  trt.BFD_Needed__c = th.BFD_Needed__c;
             /*   if(clsNBTMap.containsKey(th.id)){
                 trt.Comments__c = clsNBTMap.get(th.id).comments;
                  trt.Threat_Selection__c = th.id; 
                  
                } */
                if(clsValueMap.containsKey(th.Id)){
                  trt.Comments__c = clsValueMap.get(th.id).comments; 
                  trt.Threat_Selection__c = th.id; 
                }
                trt.Threat_Type__c = th.Threat_Type__c;
              }
              else if(th.Threat_Type__c.equalsIgnorecase('bullet')){
                  trt.BFD_Needed__c=44;
             /*   if(clsBulletMap.containsKey(th.id)){
                  trt.Comments__c = clsBulletMap.get(th.id).comments;
                  trt.Threat_Selection__c = th.id; 
                  
                } */
                if(clsValueMap.containsKey(th.Id)){
                  trt.Comments__c = clsValueMap.get(th.id).comments; 
                  trt.Threat_Selection__c = th.id; 
                  
                }
                trt.Threat_Type__c = th.Threat_Type__c;
              }
              else if(th.Threat_Type__c.equalsIgnorecase('fragment')){
                  trt.BFD_Needed__c = th.BFD_Needed__c;
                if(clsFragMap.containsKey(th.id)){
                  trt.Comments__c = clsFragMap.get(th.id).comments;
                  trt.Threat_Selection__c = th.id; 
                  
                }
                trt.Threat_Type__c = th.Threat_Type__c;
              }
              trt.Contact_Shot__c = th.Contact_Shot__c;
              trt.Energy_Level_Joule_NBT__c  = th.Energy_Level_Joule_NBT__c ;
              trt.Energy_Level_NBT__c = th.Energy_Level_NBT__c;
              trt.Environmental_Testing__c = th.Environmental_Testing__c;
              trt.ICW__c = th.ICW__c;
              trt.Indoor_Outdoor__c = th.Indoor_Outdoor__c;
              trt.Number_of_shots__c = th.Number_of_shots__c; 
              trt.Penetration_Allowed__c = th.Penetration_Allowed__c;
              trt.Shooting_Distance__c = th.Shooting_Distance__c;
              trt.Shooting_Mechanism_Weapon__c = th.Shooting_Mechanism_Weapon__c;
              trt.Shooting_Mechnism__c = th.Shooting_Mechnism__c;
              trt.Shot_Location__c = th.Shot_Locations__c;
              trt.Testing_ID_iOS__c = th.Threat_ID_iOS__c; 
              trt.Test_Standard__c = th.Test_Standard__c;
              trt.Threat_Level__c = th.Threat_Level__c; 
              trt.Type__c = th.Type__c;
              trt.V50__c = th.V50__c; 
              trt.Velocity__c = th.Velocity__c;
              trt.Velocity_Tolerance_m_s__c = th.Velocity_Tolerance_m_s__c;
              trt.Weapon__c = th.Weapon__c;
              trt.Weight__c = th.Weight__c;
              trt.Wet_Testing__c = th.Wet_Testing__c;
              trt.Test_Standard_Other_Details__c = th.Test_Standard_Other_Details__c;
              tempTRList.add(trt); 
        }
        return tempTRList;
    }
        
    @HttpPost
    global static CtrlKevlarSvcHelper.ReturnClass doPost() {
        
        CtrlKevlarSvcHelper h = new CtrlKevlarSvcHelper(); 
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String prettyJSON='';
        
        Set<Id> threatIdSet = new Set<Id>();
        Set<String> threatTypeSet = new Set<String>();
        List<Testing_Req_for_Threat__c> theart= new List<Testing_Req_for_Threat__c>();
        List<cls_fragments> customFragList=new List<cls_fragments>();
        List<cls_nonBallistic> customNBTList=new List<cls_nonBallistic>();
        
        try{
            system.debug('req.requestBody : ' + req.requestBody.toString()); 
            List<TRWrapper> tWrap = (List<TRWrapper>) JSON.deserialize(req.requestBody.toString(), List<TRWrapper>.class);        
            for(TRWrapper testingL : tWrap){
                bacConfigurationId_global=testingL.bacConfigurationId;
                for(cls_nonBallistic nbt : testingL.nonBallistic){
                    if(nbt.value.size()>0){
                        for(cls_value val : nbt.value){
                            if(!String.isBlank(val.nbtId)){
                                clsValueMap.put(val.nbtId,val);
                                threatIdSet.add(val.nbtId);
                            }
                            else{
                                //means custom nbt
                                customNBTList.add(nbt);
                            }
                        }
                    }
                    else{
                        clsNBTMap.put(nbt.nbtId,nbt);
                        threatIdSet.add(nbt.nbtId);
                    } 
                    threatTypeSet.add(nbt.threatType.toLowerCase());
                }
                for(cls_bullets bul : testingL.bullets){
                    if(bul.value.size()>0){
                        for(cls_value val : bul.value){
                            clsValueMap.put(val.bulletId,val);
                            threatIdSet.add(val.bulletId);
                        }
                    }
                    else{
                        clsBulletMap.put(bul.bulletId,bul);
                        threatIdSet.add(bul.bulletId);
                    } 
                    threatTypeSet.add(bul.threatType.toLowerCase());
                }
                for(cls_fragments frag : testingL.fragments){
                    threatTypeSet.add(frag.threatType.toLowerCase());
                    if(!String.isBlank(frag.fragmentId)){
                        clsFragMap.put(frag.fragmentId,frag);
                        threatIdSet.add(frag.fragmentId);
                    }
                    
                    else{
                        //means custom fragment
                        customFragList.add(frag);
                    }
                }
                system.debug('$$$$$$$clsValueMap :  ' + clsValueMap);
                system.debug('$$$$$$$cls_fragments :  ' + clsFragMap);
                system.debug('$$$$$$$clsNBTMap :  ' + clsNBTMap);
                system.debug('$$$$$$$clsBulletMap :  ' + clsBulletMap);
                
            }
                if(tWrap[0].dml.equalsIgnoreCase('save')){
                    system.debug('%%%% entered save %%%%');
                    //insert custom threat master
                    List<Threat_Master__c> customTMList=new List<Threat_Master__c>();
                    for(cls_fragments frag : customFragList){
                        Threat_Master__c t=new Threat_Master__c();
                        t.Name=frag.fragmentType;
                        t.Threat_Type__c='Fragment';
                        t.Active__c=true;
                        t.Shooting_Mechnism__c='Barrel';
                        customTMList.add(t);
                    }
                    for(cls_nonBallistic nbt : customNBTList){
                        for(cls_value nbtValue : nbt.value){
                            Threat_Master__c tm=new Threat_Master__c();
                            tm.Name = nbt.name;
                            tm.Threat_Type__c='NBT';
                            tm.Type__c = nbtValue.name;
                            tm.Active__c=true;
                            customTMList.add(tm);
                        }
                    }
                    if(customTMList.size()>0){
                        system.debug('customTMList : ' + customTMList);//contains both custom nbt and custom fragment
                        database.insert(customTMList);
                    }
                    // creating testing requirement for custom threat for both nbt and fragment
                    for(integer i=0;i<=customTMList.size()-1;i++)
                    {
                        if(customTMList[i].threat_type__c.equalsIgnoreCase('Fragment'))
                        {
                            Testing_Req_for_Threat__c trq=new Testing_Req_for_Threat__c();
                            trq.name= customTMList[i].name;
                            trq.Threat_Selection__c = customTMList[i].id;
                            trq.Comments__c = customFragList[i].comments;
                            trq.Threat_Type__c='Fragment';
                            trq.Shooting_Mechnism__c='Barrel';
                            trq.Active__c=true;
                            trq.BA_Configuration__c = bacConfigurationId_global; 
                            theart.add(trq);
                        }
                        else if(customTMList[i].threat_type__c.equalsIgnoreCase('NBT'))
                        {
                            for(integer j=0;j<=customNBTList.size()-1;j++){
                                Testing_Req_for_Threat__c trq=new Testing_Req_for_Threat__c();
                                trq.name = customTMList[i].name;
                                trq.Threat_Selection__c = customTMList[i].id;
                                trq.Comments__c = customNBTList[j].value[0].comments;
                                trq.Type__c = customTMList[i].type__c;
                                trq.Threat_Type__c = 'NBT';
                                trq.Active__c=true;
                                trq.BA_Configuration__c = bacConfigurationId_global; 
                                theart.add(trq);
                            }
                        }
                    }
                    theart.addAll(createTR(threatIdSet)); //contains both custom and non-custom fragment
                    database.insert(theart);
                    for(Threat_Master__c tmm : customTMList){
                        threatIdSet.add(tmm.Id);
                    }
                }
                else if(tWrap[0].dml.equalsIgnoreCase('update')){
                        system.debug('%%%% entered update %%%%');
                        Set<Id> newThreatsId=new Set<Id>();
                        Set<Id> deletedThreatIds=new Set<Id>();
                        Map<id,Testing_Req_for_Threat__c> thrtMasterToTRMap=new Map<id,Testing_Req_for_Threat__c>();
                        
                        //insert custom threat master
                        List<Threat_Master__c> customTMList=new List<Threat_Master__c>();
                        for(cls_fragments frag : customFragList){
                            Threat_Master__c t=new Threat_Master__c();
                            t.Name=frag.fragmentType;
                            t.Threat_Type__c='Fragment';
                            t.Shooting_Mechnism__c='Barrel';
                            t.Active__c=true;
                            customTMList.add(t);
                        }
                    // for custom NBT
                    for(cls_nonBallistic nbt : customNBTList){
                        for(cls_value nbtValue : nbt.value){
                            Threat_Master__c tm=new Threat_Master__c();
                            tm.Name = nbt.name;
                            tm.Threat_Type__c='NBT';
                            tm.Type__c = nbtValue.name;
                            tm.Active__c=true;
                            customTMList.add(tm);
                        }
                    }
                    if(customTMList.size()>0){
                        insert customTMList;
                    }
        
                    // creating testing requirement for custom threat for nbt and fragment            
                    for(Integer i=0;i<=customTMList.size()-1;i++){
                        if(customTMList[i].threat_type__c.equalsIgnoreCase('Fragment')){
                            system.debug('---inside Fragment---');
                            Testing_Req_for_Threat__c trq=new Testing_Req_for_Threat__c();
                            trq.name= customTMList[i].name;
                            trq.Threat_Selection__c = customTMList[i].id;
                            trq.Comments__c = customFragList[i].comments;
                            trq.Threat_Type__c='Fragment';
                            trq.Shooting_Mechnism__c='Barrel';
                            trq.Active__c=true;
                            trq.BA_Configuration__c = bacConfigurationId_global; 
                            theart.add(trq);
                        }
                        else if(customTMList[i].threat_type__c.equalsIgnoreCase('NBT')){
                            for(integer j=0;j<=customNBTList.size()-1;j++){
                                system.debug('---inside NBT---');
                                Testing_Req_for_Threat__c trq=new Testing_Req_for_Threat__c();
                                trq.name = customTMList[i].name;
                                trq.Threat_Selection__c = customTMList[i].id;
                                trq.Comments__c = customNBTList[j].value[0].comments;
                                trq.Type__c = customTMList[i].type__c;
                                trq.Threat_Type__c = 'NBT';
                                trq.Active__c=true;
                                trq.BA_Configuration__c = bacConfigurationId_global; 
                                theart.add(trq);
                            }
                        }
                    }
                        for(String key:tWrap[0].deleted){
                            deletedThreatIds.add(Id.valueOf(key));
                        }
                        threatIdSet.addAll(deletedThreatIds);
                        
                        //list of testing needs both to be updated and deleted
                        List<Testing_Req_for_Threat__c> testingNeedList =[SELECT Id,Name,Comments__c,Active__c,Manual_Testing__c,Threat_Selection__c 
                                                                            FROM Testing_Req_for_Threat__c WHERE Threat_Selection__c IN:(threatIdSet)
                                                                            AND BA_Configuration__c=:bacConfigurationId_global limit 1000];
                                                                       
                      
                        for(Testing_Req_for_Threat__c t : testingNeedList){
                            thrtMasterToTRMap.put(t.Threat_Selection__c,t);
                        }
                      
                        for(Id trId : threatIdSet){
                            if(thrtMasterToTRMap.containsKey(trId) && !deletedThreatIds.contains(trId)){//means testing needs exists which needs to be updated
                              Testing_Req_for_Threat__c trft=new Testing_Req_for_Threat__c(id=thrtMasterToTRMap.get(trId).id);
                              if(clsFragMap.containsKey(trId)){
                                trft.Comments__c=clsFragMap.get(trId).comments;
                                theart.add(trft);
                              }
                        /*      else if(clsBulletMap.containsKey(trId)){
                                trft.Comments__c=clsBulletMap.get(trId).comments;
                                theart.add(trft);
                              } 
                              else if(clsNBTMap.containsKey(trId)){
                                trft.Comments__c=clsNBTMap.get(trId).comments;
                                theart.add(trft);
                              } */
                              else if(clsValueMap.containsKey(trId)){
                                trft.Comments__c=clsValueMap.get(trId).comments;
                                theart.add(trft);
                              }
                            }
                            else if(deletedThreatIds.contains(trId)){ //means testing need has to be deleted
                                Testing_Req_for_Threat__c trft=new Testing_Req_for_Threat__c(Id=thrtMasterToTRMap.get(trId).id);
                                Delete trft;                                
                               // theart.add(trft);
                                
                            }
                            else{
                              newThreatsId.add(trId);
                            }
                        }
                        theart.addAll(createTR(newThreatsId));
                        upsert theart Id;  //upsert records using Id as external key
                    
                        for(Threat_Master__c tmm : customTMList){
                            threatIdSet.add(tmm.Id);
                        }
                }
                 List<Testing_Req_for_Threat__c> testingList =[SELECT Id,Name,Threat_Type__c,Mass__c,BA_Configuration__c,Stab_Location__c,No_Of_Stabs__c,Energy_Level_NBT__c,v50__c,velocity_V50__c,
                                                               Active__c,Angled_Shot__c,Number_of_shots__c,Manual_Testing__c,Contact_Shot__c,BFD_Needed__c,Energy_Level_Joule_NBT__c,CommonTestingReqComment__c,
                                                               Penetration_Allowed__c,Clay__c,Environmental_Testing__c,ICW__c,Velocity__c,Wet_Testing__c,Weapon__c,Shooting_Mechnism__c,
                                                               Shooting_Mechanism_Weapon__c, Testing_ID_iOS__c,Test_Standard_Other_Details__c,Type__c,Threat_Level__c,Threat_Selection__c,Test_Standard__c,Shot_Location__c,
                                                               Shooting_Distance__c,Indoor_Outdoor__c,Comments__c,Common_Comment__c,Velocity_Tolerance_m_s__c,Weight__c 
                                                               FROM Testing_Req_for_Threat__c WHERE Threat_Selection__c in:(threatIdSet) AND BA_Configuration__c=:bacConfigurationId_global AND Active__c=true limit 1000];
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
                                        system.debug('--tr.Threat_Type__c--'+tr+ '-----'+tr.Threat_Type__c);
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
                                                        system.debug('tempInt : ' + tempInt);
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
                                                        gen.writeStringField('bulletId', tr.Threat_Selection__c);//send threatMasterId
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
                                                        if(tr.V50__c <>null){
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
                                                            system.debug('tempInt : ' + tempInt);
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
                                system.debug('exit bullet');
                            }
                            if(threatTypeSet.contains('fragment')){
                                system.debug('entered fragment');
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
                                                        system.debug('tempInt : ' + tempInt);
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
                                                        if(tr.V50__c<>null){
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
                                system.debug('exit fragment');
                            }
                            if(threatTypeSet.contains('nbt')){
                                system.debug('entered nonBallistic');
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
                                                    gen.writeBooleanField('manualTesting', tr.Manual_Testing__c);
                                                    
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
                                                        system.debug('tempInt : ' + tempInt);
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
                                                                system.debug('tempInt : ' + tempInt);
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
                                                            if(tr.Mass__c <>null){
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
                                system.debug('exit nonBallistic');
                            }
                    gen.writeEndObject();//json ends  
                    
                    prettyJSON=gen.getAsString();
                    //system.debug('@@@@@prettyJSON : ' + prettyJSON);
                    //return new CtrlKevlarSvcHelper.ReturnClass(h.dataSent, h.getMessage('200'),h.getResponseMessage('520'),'520', prettyJSON, null, '200','null');
                }
                /*else{
                   return new CtrlKevlarSvcHelper.ReturnClass(h.dataNotSent, h.getMessage('201'),null,null, null, null, '201');
                }*/
            	system.debug('@@@@@ prettyJSON : ' + prettyJSON);
                return new CtrlKevlarSvcHelper.ReturnClass(h.dataSent, h.getMessage('200'),h.getResponseMessage('520'),'520', prettyJSON, null, null,'null');
         }   
         catch(Exception e){
            System.debug('Error----------'+e.getMessage());
            return new CtrlKevlarSvcHelper.ReturnClass(h.dataNotSent, h.getMessage('203'),'Insert failed!',null, null, null, '203');
         }       
    }
}