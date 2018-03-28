/*******************************************************************************
Copyright © 2015 DuPont. All rights reserved. 
Author: Pranitha S
Email: Pranitha_S@infosys.com
Description: Handler class for Trigger trigSample
Modifications:  <TJ20151123> Added code to populate the Case Detail in the 
                sample record based on the case related to the sample record.
                <PMA20151215> Corrected lookup field set from type string to NULL to ensure type match
                <Ankit 20160513 5:29 PM IST> added break condition for populating Trademark abuse case details on Sample/Trap purchase object<Issue IS ID-00069049> <IS ID-00071007>
                <Ankit 20160829 3:26 PM IST> added condition for populating Sample Name when active Ingredient is used for the first time as per Issue IS ID-00073074> code coverage 96% <AK 20160829 03:35 PM IST>
 *****************************************************************************/
public without sharing class SampleHandler extends TriggerHandlerBase{

public static final Id CropSample=Rtype.getIdByDevName('Trademark_Abuse_Sample__c', 'Crop_Sample');
public static final Id BPDCase=Rtype.getIdByDevName('Case', 'Brand_Protection_Legal_Case');
public String twoLetterCode;
public Integer length = 5;
public Integer counterVar = 0;
List <Trademark_Abuse_Sample__c> SampleName = new List<Trademark_Abuse_Sample__c>();
public String SampleName1;
public String SampleName2;
public Integer SeqNumber;


    public override void bulkBefore(){
        if(Trigger.IsBefore && Trigger.IsInsert){
            createSampleName();
            }
        //<TJ20151123> Calling the addCase method in case of an update or insert operation.
        if(Trigger.IsBefore && (Trigger.IsInsert || Trigger.IsUpdate)){
            addCase();
      }
    }
    
      /*  Method used to create the sample name for BPD cases  */ 
    public  void createSampleName(){

      for(Sobject record : Trigger.new){
      Trademark_Abuse_Sample__c sample =(Trademark_Abuse_Sample__c )record ;
           if(sample.RecordTypeId==CropSample){
            try{
                        
                String  activeIngredients = BPD_Sample_Settings__c.getInstance(sample.Active_Ingredients__c).Abbreviation__c; 
                 String  country = BPD_Sample_Settings__c.getInstance(sample.Country__c).Abbreviation__c;
                twoLetterCode = 'CP'; 
                string month;
                if(sample.Identification_Date__c.month()>=1 && sample.Identification_Date__c.month()<=9){
                month='0'+String.valueof(sample.Identification_Date__c.month());
                }
                else{
                month=string.valueof(sample.Identification_Date__c.month());
                }
                
                
                
                //Integer SeqNumber = [SELECT COUNT() FROM Trademark_Abuse_Sample__c WHERE RecordTypeId =: CropSample and 
              //  Active_Ingredients__c =: sample.Active_Ingredients__c]+1;
                SampleName=[SELECT Sample_Name__c FROM Trademark_Abuse_Sample__c WHERE RecordTypeId =: CropSample and 
                Active_Ingredients__c =: sample.Active_Ingredients__c order by CreatedDate desc Limit:1];
                
                 // <Ankit 20160829 3:26 PM IST> added condition for populating Sample Name when active Ingredient is used for the first time as per Issue IS ID-00073074> code coverage 96% <AK 20160829 03:35 PM IST>
                if(SampleName.size()==Null || SampleName.size() ==0)
                { 
                    sample.Sample_Name__c = twoLetterCode + '-'+ country + '-' + activeIngredients +
                    '-' + String.valueOf(sample.Identification_Date__c.year()).substring(2) + '-' + month + '-'  + '00001';
                } 
                
                else{
                
               // Trademark_Abuse_Sample__c SampleNm=new Trademark_Abuse_Sample__c();               
                For(Trademark_Abuse_Sample__c s:SampleName)
                {               
                    SampleNAme1=s.Sample_Name__c;
                    SampleNAme2 = SampleNAme1.substring(SampleNAme1.length() - 5);
                    SeqNumber=Integer.valueOf(SampleNAme2);
                    Integer Num= SeqNumber+1;
                    String formattedSeqNumber=  String.valueOf(Num).leftPad(length).replace(' ','0');    
                    sample.Sample_Name__c = twoLetterCode + '-'+ country + '-' + activeIngredients +
                    '-' + String.valueOf(sample.Identification_Date__c.year()).substring(2) + '-' + month + '-'  + formattedSeqNumber;              //update sample;
                }
                   }
                   //<Ankit 20160829 3:26 PM IST> Active ingredient change end
          }
          catch (Exception e){
          system.debug('There was a problem updating the sample name'+e.getMessage()+ counterVar );
     }
        } 
         
       } 
      
    }
    //<TJ20151123> Added code to populate the Case Detail in the sample record based on the case related to the sample record.
    public void addCase(){
        List<Trademark_Abuse_Sample__c> trdAbuseSmpls = new List<Trademark_Abuse_Sample__c>();                
        List<Case_Details__c> trdAbuseList = new List<Case_Details__c>();
        List<Id> CaseList = new List<Id>();
        for(SObject record : Trigger.new) {
            Trademark_Abuse_Sample__c td =(Trademark_Abuse_Sample__c )record ;
            trdAbuseSmpls.add(td);
            if(td.Case__c!=null)
                CaseList.add(td.Case__c);
        }
        //system.debug('case Id:  ' + CaseList.SIZE());
        //system.debug('case Id:  ' + CaseList);
        if(CaseList.size()!=0){
            //system.debug('case Id:  ' + CaseList);
            trdAbuseList=[Select Id,Related_Case__c from Case_Details__c where Related_Case__c IN:CaseList];            
            for(Trademark_Abuse_Sample__c tdrCase : trdAbuseSmpls){
                for(Case_Details__c cd : trdAbuseList){  
                    if(cd.Related_Case__c == tdrCase.Case__c){ 
                        //system.debug('trade Abuse Id ' + cd.Id); 
                        tdrCase.Trademark_Abuse_Case_Details__c =cd.Id;
                        break; // <Ankit 20160513 5:29 PM IST> added break condition for populating Trademark abuse case details on Sample/Trap purchase object<Issue IS ID-00069049> <IS ID-00071007> code coverage: 96% <AK 20160617 5:29 PM IST>   
                    }
                    else{
                        //system.debug('trade Abuse Id ' + cd.Id); 
                        tdrCase.Trademark_Abuse_Case_Details__c =NULL; //<PMA20151215>
                    }                    
                }
            }             
        }
        else{
            //system.debug('case Id23 ');
            for(Trademark_Abuse_Sample__c tdrCase : trdAbuseSmpls){
                tdrCase.Trademark_Abuse_Case_Details__c =NULL;                
            }            
        }
    }
    //<TJ20151123> END
 }