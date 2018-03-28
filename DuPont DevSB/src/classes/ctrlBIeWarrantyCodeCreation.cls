/////////////////////////////////////////////////////////////////////////////////////////////////////////
//Name :ctrl_eWarranty_BIEMEA_WarCodeCreation
//Author :Manasa.R
//Description: this class is for generating the warranty codes and adding the corresponding List record
/////////////////////////////////////////////////////////////////////////////////////////////////////////

public with sharing class ctrlBIeWarrantyCodeCreation{
    
    public Id recType=Rtype.getIdByDevName('List__c','eWarranty');
    public ctrlBIeWarrantyCodeCreation() {
        owingOrg=System.currentPageReference().getParameters().get('owningorg');
        System.LoggingLevel level = LoggingLevel.DEBUG;
    }
    System.LoggingLevel level = LoggingLevel.DEBUG;   
    public List<String> listWarrantyCodes = new List<String>();
    public List<warrrntyPrintList> generatedCodesList = new List<warrrntyPrintList>();   
    public String startCode{get;set;}
    public String endCode{get;set;}
    public String owingOrg{get;set;}    
    List<List__c> listRecs = new List<List__c>();
    /* 
    * List of fields to be displayed on xcel 
    */
    public class warrrntyPrintList{
        public String warrantyCode{get;set;}
        public String owingOrg{get;set;}
    }    
    /*
    * This Method validates the entered values and generates warranty codes for printing
    * and adds the corressponding list object
    */
    String warrantyCode;   
   
        
    public Pagereference generateWarCodes(){
        ApexPages.Message requiredField;
        Date todayDate = date.today();        
        /* clear the list before adding */
        if(!listWarrantyCodes.isEmpty()){
            listWarrantyCodes.clear();
        }    
        if(!generatedCodesList.isEmpty()){
            generatedCodesList.clear();
        }                          
        /* validate if all the values are entered */
        try{  
            //listRecs = new List<List__c>();     
            if(startCode.length()==0 || endCode.length()==0 || owingOrg.equalsIgnoreCase('none')){
                ctrlBIeWarrantyInput.displayMessage('FATAL',Label.Null_Entry);
                return null;
            }else{            
                /* verifying whether start and end codes are numbers*/            
                Integer intStCode= Util.stringToInteger(startCode.trim());
                if(intStCode == 0 || intStCode == null){   
                    ctrlBIeWarrantyInput.displayMessage('FATAL',Label.Null_Start_Code);               
                    return null;                
                }            
                Integer intEndCode= Util.stringToInteger(endCode.trim());
                if(intEndCode == 0 || intEndCode == null){
                    ctrlBIeWarrantyInput.displayMessage('FATAL',Label.Null_End_Code);
                    return null;             
                }            
                /* validate whether start code is lesser than end code */
                if (intStCode > intEndCode){
                    ctrlBIeWarrantyInput.displayMessage('FATAL',Label.St_gt_end);
                    return null;
                }else{
                    /* difference between start and end code must not be more than 1000 */
                    Integer difference = intEndCode - intStCode;
                    if(difference  > 1000){
                        ctrlBIeWarrantyInput.displayMessage('FATAL',Label.X1000PlusRecs);
                        return null;
                    }else{                    
                        /* on successful of validation of all the criterias, generate warranty codes are generated and the new list object is created */                        
                        listRecs=   getListsRecords();               
                        /* if there is no list records then create new */
                        if(listRecs.size()==0){                    
                           genWarCodes(intStCode,intEndCode,owingOrg);
                           return null;
                        }
                        else{
                            boolean flag; //flag is not set if either end or start code matches, else flag is set.
                            for(List__c lt: listRecs){
                               if((intStCode >= Integer.valueOf(lt.Code_1__c) && intStCode <= Integer.valueOf(lt.Code_2__c))||
                                  (Integer.valueOf(lt.Code_1__c) >= intStCode && Integer.valueOf(lt.Code_1__c) <= intEndCode) )   {
                                        ctrlBIeWarrantyInput.displayMessage('FATAL',Label.presentStartCode);
                                        flag=false; 
                                        break;
                               }else if((intEndCode <= Integer.valueOf(lt.Code_2__c) && intEndCode >= Integer.valueOf(lt.Code_1__c))||
                                        (Integer.valueOf(lt.Code_2__c) <= intEndCode && Integer.valueOf(lt.Code_2__c) >= intStCode))  {
                                        ctrlBIeWarrantyInput.displayMessage('FATAL',Label.presentEndCode);
                                        flag=false; 
                                        break;
                                }else{
                                    flag=true;
                                }                
                            }
                            system.debug(logginglevel.DEBUG,'Controller::::ctrlWarrantyCodeCreation::::Method::::generateWarCodes::::Flag is::::'+flag);
                            if(flag==true){
                                system.debug(logginglevel.DEBUG,'Controller::::ctrlWarrantyCodeCreation::::Method::::generateWarCodes::::Both the codes didnt match::::'+flag);                                      
                                genWarCodes(intStCode,intEndCode,owingOrg); 
                                return null;                           
                            }
                        }
                    }
                }
            } 
        return null;           
        }
        catch (exception exp){
            System.debug(logginglevel.ERROR,'Controller::::crtleWarrantuInput::::Method::::addDetails::::A exception occured::::'+exp);
            ctrlBIeWarrantyInput.displayMessage('FATAL',Label.erroPage_CodeGeneration);
            return null;
        }
    }
    /*
    * List of Lists Records
    */
    public List<List__c> getListsRecords(){
        listRecs= [Select Is_Exception__c,l.Owning_Org__c, l.Code_2__c, l.Code_1__c,l.RecordTypeId From List__c l where (Owning_Org__c=:owingOrg AND RecordTypeId=:recType)];
        return listRecs;
    }
    /* 
    * List for xcel 
    */       
    public List<warrrntyPrintList> getCodesList(){           
        if(generatedCodesList.size() > 0 ){
            return generatedCodesList;
        }
        return generatedCodesList;
    }    
    /* 
    * This method generates the warranty codes and also adds tht List objects 
    */    
   public void genWarCodes(Integer startCode, Integer endCode, String owingOrg){    
    try{ 
        /* generation of warranty codes */ 
        for (Integer i=startCode; i<= endCode; i++){
            string s=leftPad(String.valueOf(i),7,'0');
            String chkCode = encode(s);
            warrantyCode = owingOrg+s+chkcode;
            listWarrantyCodes.add(warrantyCode); 
            warrrntyPrintList obj = new warrrntyPrintList();
            obj.warrantyCode=warrantyCode;
            obj.owingOrg=owingOrg;                      
            generatedCodesList.add(obj);                                                            
        }
        String stCode = String.valueOf(startCode);
        String enCode = String.valueOf(endCode);    
        /* adding start code and end code to List odject */
        List__c listNew = new List__c(RecordTypeId=recType,Name='eWarranty Label Generation'+startCode+'_'+endCode,Owning_Org__c=owingOrg,Code_1__c=stCode,Code_2__c=enCode);
        insert(listNew);
        ctrlBIeWarrantyInput.displayMessage('INFO',Label.Success_msg_CG);
    }catch(exception exp){
        System.debug(logginglevel.ERROR,'Controller::::crtleWarrantuInput::::Method::::addDetails::::A exception occured::::'+exp);
        ctrlBIeWarrantyInput.displayMessage('FATAL',Label.erroPage_CodeGeneration);
    }
  }
  ////////////// Below methods help us in padding the value entered and also encode them //////////////
  /* ****************************************************
    variable Passed :
    String str : String that needs to be padded.
    Integer size : size of the returning integer. 
    String padstr :  str to be padded with.
    
    returning variable :
    String
******************************************************** */ 
   public static  String leftPad(String str, Integer size, String padStr) {
        if (str.length() == 0 ) {
                //wen string is null
            return null;
        }
        Integer padLen = padStr.length();
        Integer strLen = str.length();
        Integer padCharCount = size - strLen;
        if (padCharCount <= 0) {
            //wen padCharCount is 0
            return str;
        }
        if (padCharCount == padLen) {
            //wen padCharCount == padLen/
            return padStr + str;
        } else if (padCharCount < padLen) {
            //padCharCount < padLen/
            return padStr.substring(0, padCharCount) + str;
        } else {
            ///in else
            String padding = '';
            for (Integer i = 0; i < padCharCount; i++) {
                padding += padStr.substring(Math.mod(i,padLen),Math.mod(i,padLen)+1);
            }
            return padding + str;
        }
    }
    
/* ****************************************************
    variable Passed :
    String str : String that needs to be encoded..
    
    returning variable :
    Padded String
******************************************************** */ 
    public static String encode(String str){
        string hash=EncodingUtil.base64Encode(crypto.generateDigest('MD5',Blob.valueOf(str) ));
        string chkcode=hash.toUppercase().replaceAll('[^\\w]','').replaceAll('[1,I,O,L]','').substring(0,3);
        system.debug(chkcode);
        return chkcode;
    }
    
}