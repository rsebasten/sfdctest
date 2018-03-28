/*******************************************************************************
(C)2015
Author: krishnaveni duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  This class returns the Threat Master details based on the Threat type.
 ********************************************************************************/

@RestResource(urlMapping='/ThreatMaster/*')
global class CtrlThreatMasterService{


   
    @HttpPost
    global static CtrlKevlarSvcHelper.ReturnThreatMasterClass doPost(){
        CtrlKevlarSvcHelper h = new CtrlKevlarSvcHelper(); 
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        String prettyJson = '';
        Integer bulletCount = 0;
        Boolean isParentBulletCountSet=false;
        Integer fragmentCount = 0;
        Integer nbtCount = 0;
        Boolean isParentNBTCountSet=false;
        Set<String> threatTypeSet=new Set<String>();
        Map<String,List<Threat_Master__c>> bulletTypeMap=new Map<String,List<Threat_Master__c>>();
        Map<String,List<Threat_Master__c>> fragmentTypeMap=new Map<String,List<Threat_Master__c>>();
        Map<String,List<Threat_Master__c>> nbtTypeMap=new Map<String,List<Threat_Master__c>>();

        try{
            system.debug('req.requestBody : ' + req.requestBody.toString()); 
            ThreatMasterWrapper tWrap = (ThreatMasterWrapper) JSON.deserialize(req.requestBody.toString(), ThreatMasterWrapper.class);          
            threatTypeSet.add(tWrap.threatType1);
            threatTypeSet.add(tWrap.threatType2);
            threatTypeSet.add(tWrap.threatType3);    
            
            List<Threat_Master__c>  allThreatMasterList =[SELECT Id,Name,Grams__c,Threat_Type__c,Grains__c,
                                                Velocity__c,v50__c,Type__c,Test_Standard__c,Threat_Level__c,Comments__c,Weight__c FROM Threat_Master__c 
                                                WHERE Threat_Type__c IN:threatTypeSet ORDER BY SortOrder__c ASC];
                                                
            for(Threat_Master__c tm : allThreatMasterList){
                if(tm.Threat_Type__c.equalsIgnoreCase('bullet')){
                    List<Threat_Master__c> tempBullet;
                    if(bulletTypeMap.containsKey(tm.Name)){
                        tempBullet=bulletTypeMap.get(tm.Name);
                    }
                    else{
                        tempBullet=new List<Threat_Master__c>();
                    }
                    tempBullet.add(tm);
                    bulletTypeMap.put(tm.Name,tempBullet);
                }
                else if(tm.Threat_Type__c.equalsIgnoreCase('fragment')){
                    List<Threat_Master__c> tempFragment;
                    if(fragmentTypeMap.containsKey(tm.Name)){
                        tempFragment=fragmentTypeMap.get(tm.Name);
                    }
                    else{
                        tempFragment=new List<Threat_Master__c>();
                    }
                    tempFragment.add(tm);
                    fragmentTypeMap.put(tm.Name,tempFragment);
                }
                else if(tm.Threat_Type__c.equalsIgnoreCase('nbt')){
                    List<Threat_Master__c> tempNBT;
                    if(nbtTypeMap.containsKey(tm.Name)){
                        tempNBT=nbtTypeMap.get(tm.Name);
                    }
                    else{
                        tempNBT=new List<Threat_Master__c>();
                    }
                    tempNBT.add(tm);
                    nbtTypeMap.put(tm.Name,tempNBT);
                }
                
            }
            
            /*List<String> ascSortKeys=new List<String>();
            ascSortKeys.addAll(bulletTypeMap.keySet());
            ascSortKeys.sort();
            
            for(Integer i=ascSortKeys.size()-1;i>=0;i--){
                String key=ascSortKeys[i];
                List<Threat_Master__c> tempBullet=bulletTypeMap.get(key);
                bulletTypeMap.remove(key);
                bulletTypeMap.put(key, tempBullet);
            }*/
            
            JSONGenerator gen = JSON.createGenerator(true);
            
            gen.writeStartObject();//json starts
                gen.writeFieldName('nonBallistic');
                    gen.writeStartArray();//nonBallistic array starts
                        for( String nbt : nbtTypeMap.Keyset())
                        {
                            Integer tempCount=0;
                            isParentNBTCountSet=false;
                            if(nbtTypeMap.containsKey(nbt) && nbtTypeMap.get(nbt).size()>1){
                                gen.writeStartObject();
                                        gen.writeStringField('name',nbt);
                                        gen.writeFieldName('value');
                                        gen.writeStartArray();
                                                    for(Threat_Master__c nbtRec : nbtTypeMap.get(nbt)){   
                                                        gen.writeStartObject();
                                                            if(!String.isBlank(nbtRec.type__c)){
                                                                    gen.writeStringField('name', nbtRec.type__c);
                                                            }
                                                            gen.writeStringField('id', nbtRec.id);
                                                            if(!String.isBlank(nbtTypeMap.get(nbt)[0].threat_level__c)){ 
                                                                gen.writeStringField('threatLevel',nbtTypeMap.get(nbt)[0].threat_level__c );
                                                            }
                                                            else{
                                                                gen.writeStringField('threatLevel','');
                                                            } 
                                                            nbtCount=nbtCount+1;
                                                            gen.writeNumberField('sequence', nbtCount); 
                                                            if(isParentNBTCountSet==false){
                                                              tempCount=nbtCount; 
                                                              isParentNBTCountSet=true;
                                                            }   
                                                        gen.writeEndObject();
                                                    }
                                        gen.writeEndArray();
                                    gen.writeNumberField('sequence', tempCount);
                                gen.writeEndObject();
                            }
                            else if( nbtTypeMap.containsKey(nbt) && nbtTypeMap.get(nbt).size()==1){
                                gen.writeStartObject();
                                    gen.writeStringField('name',nbt);
                                    gen.writeFieldName('value');
                                            gen.writeStartArray();
                                                gen.writeStartObject();
                                                    if(!String.isBlank(nbtTypeMap.get(nbt)[0].type__c))
                                                    { 
                                                        gen.writeStringField('name',nbtTypeMap.get(nbt)[0].type__c );
                                                    }
                                                    else
                                                    {
                                                        gen.writeStringField('name','');
                                                    }
                                                    gen.writeStringField('id', nbtTypeMap.get(nbt)[0].id);
                                                   if(!String.isBlank(nbtTypeMap.get(nbt)[0].threat_level__c))
                                                    { 
                                                        gen.writeStringField('threatLevel',nbtTypeMap.get(nbt)[0].threat_level__c );
                                                    }
                                                    else
                                                    {
                                                        gen.writeStringField('threatLevel','');
                                                    } 
                                                    nbtCount=nbtCount+1;
                                                    gen.writeNumberField('sequence', nbtCount); 
                                                    if(isParentNBTCountSet==false){
                                                        tempCount=nbtCount; 
                                                        isParentNBTCountSet=true;
                                                    }
                                                gen.writeEndObject();
                                            gen.writeEndArray();
                                    gen.writeNumberField('sequence', tempCount);
                                gen.writeEndObject();
                            }
                        }
                    gen.writeEndArray();//nonBallistic array ends
                    
                // for Fragment data
                gen.writeFieldName('fragments');
                    gen.writeStartArray();//fragment array starts
                        for(String fragThreat : fragmentTypeMap.keyset()){     
                            for(Threat_Master__c fragRec : fragmentTypeMap.get(fragThreat)){    
                              gen.writeStartObject();
                                    gen.writeStringField('fragmentType',fragRec.Name);
                                    if(fragRec.grams__c!=null ){
                                        gen.writeNumberField('gram',fragRec.grams__c);
                                    }
                                    else{
                                        gen.writeNumberField('gram',0);
                                    }
                                    if(fragRec.grains__c!=null){
                                        gen.writeNumberField('grains',fragRec.grains__c);
                                    }
                                    else{
                                        gen.writeNumberField('grains',0);
                                    }
                                    gen.writeStringField('id',fragRec.id);
                                    gen.writeNumberField('sequence',fragmentCount++);
                                gen.writeEndObject(); 
                            }
                        }
                    gen.writeEndArray();//fragment array ends
                
                //for bullet data
                gen.writeFieldName('bullets');
                    gen.writeStartArray();//bullet array starts
                        for(String bulletDetails : bulletTypeMap.keyset())
                        {
                            Integer tempCount=0;
                            isParentBulletCountSet=false;
                            if(bulletTypeMap.containsKey(bulletDetails) && bulletTypeMap.get(bulletDetails).size()>1){
                                gen.writeStartObject();
                                    gen.writeStringField('name',bulletDetails);
                                        gen.writeFieldName('value');
                                            gen.writeStartArray();
                                                for(Threat_Master__c singleBullet : bulletTypeMap.get(bulletDetails))
                                                {
                                                    gen.writeStartObject();
                                                        if(!String.isBlank(singleBullet.Type__c)){
                                                            gen.writeStringField('bulletType',singleBullet.type__c);
                                                        }
                                                        else{
                                                           gen.writeStringField('bulletType',''); 
                                                        }
                                                        if(singleBullet.Weight__c !=null){
                                                            gen.writeNumberField('weight',singleBullet.Weight__c);
                                                        }
                                                      else{
                                                           gen.writeNumberField('weight',0); 
                                                        }
                                                        if(singleBullet.Velocity__c != null){
                                                            gen.writeNumberField('velocity',singleBullet.Velocity__c);
                                                        }
                                                      else{
                                                           gen.writeNumberField('velocity',0); 
                                                        }
                                                        gen.writeStringField('id',singleBullet.id);
                                                        bulletCount=bulletCount+1;
                                                        gen.writeNumberField('sequence', bulletCount);  
                                                        if(isParentBulletCountSet==false){
                                                            tempCount=bulletCount; 
                                                            isParentBulletCountSet=true;
                                                        }
                                                    gen.writeEndObject();
                                                }
                                            gen.writeEndArray();
                                    gen.writeNumberField('sequence', tempCount);
                                gen.writeEndObject();
                            }
                            else if(bulletTypeMap.containsKey(bulletDetails) && bulletTypeMap.get(bulletDetails).size()==1){
                                gen.writeStartObject();
                                    gen.writeStringField('name',bulletDetails);
                                    gen.writeFieldName('value');
                                        gen.writeStartArray();
                                                for(Threat_Master__c singleBullet : bulletTypeMap.get(bulletDetails)){
                                                    gen.writeStartObject();
                                                    if(singleBullet.Weight__c !=null){
                                                            gen.writeNumberField('weight',singleBullet.Weight__c);
                                                        }
                                                      else{
                                                           gen.writeNumberField('weight',0); 
                                                        }
                                                        if(singleBullet.Velocity__c != null){
                                                            gen.writeNumberField('velocity',singleBullet.Velocity__c);
                                                        }
                                                      else{
                                                           gen.writeNumberField('velocity',0); 
                                                        }
                                                        if(!String.isBlank(singleBullet.Type__c)){
                                                            gen.writeStringField('bulletType',singleBullet.type__c);
                                                        }
                                                        else{
                                                            gen.writeStringField('bulletType',''); 
                                                        }
                                                        gen.writeStringField('id',singleBullet.id);
                                                        bulletCount=bulletCount+1;
                                                        gen.writeNumberField('sequence', bulletCount);  
                                                        if(isParentBulletCountSet==false){
                                                            tempCount=bulletCount; 
                                                            isParentBulletCountSet=true;
                                                        }
                                                    gen.writeEndObject();
                                                }
                                        gen.writeEndArray();
                                    gen.writeNumberField('sequence', tempCount);
                                gen.writeEndObject();
                            }
                        }
                    gen.writeEndArray();//bullet array ends
            gen.writeEndObject();//json ends
            
            prettyJson = gen.getAsString();
            system.debug('prettyJson ' + prettyJson);
        
            if(!allThreatMasterList.isEmpty()){        
                return new CtrlKevlarSvcHelper.ReturnThreatMasterClass(h.dataSent, h.getMessage('200'),h.getResponseMessage('511'),'511',prettyJson,null,'No error' );
            }
            else{
                return new CtrlKevlarSvcHelper.ReturnThreatMasterClass(h.dataNotSent, h.getMessage('201'),null,null,null,null, '201');
            } 
        } 
        catch(Exception e){
            System.debug('Error----------'+e.getMessage());
            return new CtrlKevlarSvcHelper.ReturnThreatMasterClass(h.dataNotSent, h.getMessage('203'),'Data loading failed!',null,null,null, '203');
        }  
    }
    global class ThreatMasterWrapper{
        public String threatType1;
        public String threatType2;
        public String threatType3;
    } 
}