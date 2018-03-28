/*******************************************************************************
Copyright © 2016 DuPont. All rights reserved.
Author: Neha Badala
Email: neha.badala@tcs.com
Description: Class used by Kevlar Selector Tool to display the appropriate yarns based on the search criteria
Created Date: 9/19/2016
Version: 1.0
********************************************************************************/


public with Sharing class ctrlDPSYarnSpecBase {

    //Initialize variables
    public List<wrapYarnSpec> lswrap{get;set;}
    public Decimal appLoopStrength{get;set;}
    public Search_Criteria__c sch{get;set;}    
    public Boolean showResult{get; set; }
    public String saveId{get;set;}
    public Boolean hasPermissionSet{get;set;}
    private static final String STRMM='mm';
    private static final String STRBAR='BAR';
    private DPSKevlarCustomSetting__c dps;
    String loggedInUser;
    String loggedInUserAcc;
    @TestVisible private Decimal INCHSTITCHVALUE;
    @TestVisible private Decimal INCHOPERATINGPRESSURE;

    /* Function Description
    Name : ctrlDPSYarnSpecBase
    Return Type: void
    Description: It is the constructor method     
    */ 
    public ctrlDPSYarnSpecBase() {
        showResult = false;
        appLoopStrength=0;

        loggedInUser = UserInfo.getUserId();       
        User u = [select Contact.Account.id from User where id =: loggedInUser];  
        loggedInUserAcc = u.Contact.AccountId;  
        sch = new Search_Criteria__c(KV_Customer__c =loggedInUserAcc);                 
        dps=DPSKevlarCustomSetting__c.getinstance();
        INCHSTITCHVALUE=0;
        INCHOPERATINGPRESSURE=0;
        checkPermissionSet();
    }

    /* Function Description
    Name : displayResult
    Return Type: void
    Description: This method does the manadatoy field check,
        calculates the values according to formula and 
        inserts a record in Search Criteria object.      
    */ 
    public void displayResult() {
        lswrap=new List<wrapYarnSpec>();
        try{
            String errorMsg = Label.DPS_REQUIRED_FIELD_ERRORMSG;
            String errorMsg1 = Label.DPS_KNITTING_ANGLE_OUT_OF_RANGE_ERRMSG + ' ' + dps.KV_Knitting_angle_lower_limit__c.setScale(0) + ' ' + Label.DPS_TO + ' ' + dps.KV_Knitting_angle_upper_limit__c.setScale(0);
            String errorMsg2 = Label.DPS_INTERNAL_DIAM_NEGATIVE_VALUE_ERRORMSG;
            String errorMsg3 = Label.DPS_INNERWALL_THICKNESS_NEGATIVE_VALUE_ERRORMSG;
            String errorMsg4 = Label.DPS_STITCH_LENGTH_NEGATIVE_VALUE_ERRORMSG;
            String errorMsg5 = Label.DPS_INNERWALL_THICKNESS_OUT_OF_RANGE_ERRMSG + ' ' + dps.KV_Inner_Wall_Thickness_Lower_Limit__c + ' mm ' + Label.DPS_TO + ' ' + dps.KV_Inner_Wall_Thickness_Upper_Limit__c + ' mm';

            if(sch.KV_Operating_Temperature__c == '' || sch.KV_Operating_Temperature__c == null ||
            sch.KV_Operating_Pressure_Unit__c == '' || sch.KV_Operating_Pressure_Unit__c == null ||
            sch.KV_Operating_Pressure_Value__c == 0.0 || sch.KV_Operating_Pressure_Value__c == null ||
            sch.KV_Internal_Diameter_mm__c == 0.0 || sch.KV_Internal_Diameter_mm__c == null ||
            sch.KV_Inner_Wall_Thickness_mm__c == 0.0 || sch.KV_Inner_Wall_Thickness_mm__c == null ||
            sch.KV_Stitch_Length_Unit__c == '' || sch.KV_Stitch_Length_Unit__c == null ||
            sch.KV_Stitch_Length_Value__c == 0.0 || sch.KV_Stitch_Length_Value__c == null ||
            sch.KV_Knitting_Angle__c == 0 || sch.KV_Knitting_Angle__c == null)
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMsg)); 
                this.showResult = false;            
            }  
            else if(sch.KV_Internal_Diameter_mm__c < 0 || sch.KV_Inner_Wall_Thickness_mm__c < 0 || sch.KV_Stitch_Length_Value__c < 0)
            {
                    if(sch.KV_Internal_Diameter_mm__c < 0)
                    {
                       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMsg2));
                    }
                    if(sch.KV_Inner_Wall_Thickness_mm__c < 0)
                    {
                       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMsg3));
                    }
                    if(sch.KV_Stitch_Length_Value__c < 0)
                    {
                       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMsg4));
                    }                                
                    this.showResult = false;                        
            }              
            else if(sch.KV_Knitting_Angle__c < dps.KV_Knitting_angle_lower_limit__c || sch.KV_Knitting_Angle__c > dps.KV_Knitting_angle_upper_limit__c)
            {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMsg1));
                    this.showResult = false;                        
            }   
            else if(sch.KV_Inner_Wall_Thickness_mm__c < dps.KV_Inner_Wall_Thickness_Lower_Limit__c || sch.KV_Inner_Wall_Thickness_mm__c > dps.KV_Inner_Wall_Thickness_Upper_Limit__c)
            {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMsg5));
                    this.showResult = false;                        
            }                              
            else{       
                    Decimal PSITOBAR=Decimal.valueOf(dps.KV_PSI_to_Bar__c);
                    Decimal burstPrBAR=0;
                    Decimal burstPrPSI=0;          
    
                    //Converting stitch length from inch to mm and Op. pressure from PSI to BAR to be used in further calculations
                    convertUnits();
    
                    appLoopStrength=(INCHOPERATINGPRESSURE * (sch.KV_Internal_Diameter_mm__c + (2 * sch.KV_Inner_Wall_Thickness_mm__c)) 
                                * INCHSTITCHVALUE)/(10 * math.sin(sch.KV_Knitting_Angle__c *(3.14/180))) * 2;                           
                    
                    System.debug('Appropriate Length ****'+appLoopStrength);             
    
                    this.showResult = true;
                    List<Yarn_Specification__c> YarnSpecList=new List<Yarn_Specification__c>();
                    YarnSpecList = getYarnSpecRecords();
                    lswrap=new list<wrapYarnSpec>();    
    
                    /*Considering yarns where 100 cycles value is greater than app loop strength &
                     deciding whether to display result values or just colors based on the permission set assigned to users */
                    for(Yarn_Specification__c yarnspec :  YarnSpecList){
                        if(yarnspec.KV_100_Cycles__c >= appLoopStrength && ((hasPermissionSet == true && yarnspec.KV_Product__r.KV_Kevlar_Product__c == true) || (hasPermissionSet == false) )){
                                burstPrBAR= (10 * yarnspec.KV_0_Cycles__c * math.sin(sch.KV_Knitting_Angle__c * 3.14/180))/(2 * INCHSTITCHVALUE * (sch.KV_Internal_Diameter_mm__c + (2 * sch.KV_Inner_Wall_Thickness_mm__c)));
                                burstPrPSI=burstPrBAR /PSITOBAR;
                                wrapYarnSpec  wrapObj=new wrapYarnSpec ();
                                wrapobj.yrsp = yarnspec ;
                                wrapobj.burstPrPSI=burstPrPSI.setScale(2);
                                wrapobj.burstPrBAR=burstPrBAR.setScale(2);
                                lswrap.add(wrapobj);                
                        }                          
                    }
                    if(lswrap.size() != 0)
                    {   
                            sch.KV_Appropriate_Loop_Strength__c = appLoopStrength;
                            upsert sch;
                            saveId = sch.Id;
                            cls_AttachPdfInSC.attachPdf(saveId);                                                    
                    }                 
                    sch = new Search_Criteria__c(KV_Customer__c =loggedInUserAcc); 
            }

        }
        catch(Exception ex){
            this.showResult = false;
            ApexPages.addMessages(ex);
        }
    }

    /* Function Description
    Name : convertUnits
    Return Type: void
    Description: This method is used to convert inch to mm and PSI to BAR.      
    */
    private void convertUnits(){
        Decimal PSITOBAR=Decimal.valueOf(dps.KV_PSI_to_Bar__c);
        Decimal INCHTOMM=Decimal.valueOf(dps.KV_inch_to_mm__c);          
        if(sch.KV_Stitch_Length_Unit__c != STRMM){
            INCHSTITCHVALUE=  INCHTOMM / sch.KV_Stitch_Length_Value__c;    
        }
        else{
            INCHSTITCHVALUE=sch.KV_Stitch_Length_Value__c;
        }  
        if(sch.KV_Operating_Pressure_Unit__c != STRBAR){
            INCHOPERATINGPRESSURE=  sch.KV_Operating_Pressure_Value__c * PSITOBAR ;    
        }
        else{
            INCHOPERATINGPRESSURE= sch.KV_Operating_Pressure_Value__c ;
        }
    }

    /* Function Description
    Name : getFields
    Return Type: List
    Description: This method returns the fields in the Yarn Specification fieldset.      
    */ 
    public List<Schema.FieldSetMember> getFields() {
        return SObjectType.Yarn_Specification__c.FieldSets.showResult.getFields();
    }

    /* Function Description
    Name : getYarnSpecRecords
    Return Type: List
    Description: This method returns the search result query.      
    */
    private List<Yarn_Specification__c> getYarnSpecRecords() {
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : this.getFields()) {
            query += f.getFieldPath() + ', ';
        }
        query += 'Id,KV_Product_Name__c,KV_Product__r.KV_Kevlar_Product__c FROM Yarn_Specification__c where  KV_Operating_Temperature__c=\'' + sch.KV_Operating_Temperature__c + '\'' + ' order by KV_Product_Name__c ';
        return Database.query(query);
    }

    //wrapper class
    public class wrapYarnSpec{
        public Yarn_Specification__c yrsp{get;set;}
        public Decimal burstPrPSI{get;set;}
        public Decimal burstPrBAR{get;set;}

        /* Function Description
        Name : wrapYarnSpec
        Return Type: void
        Description: It is the constructor method of the wrapper class      
        */
        public wrapYarnSpec(){
            yrsp=new Yarn_Specification__c();
            burstPrPSI=0;
            burstPrBAR=0;
        }
    }

    /* Function Description
    Name : checkPermissionSet
    Return Type: void
    Description: This method is used for checking if the user logged in 
        has a community PS assigned      
    */
    public void checkPermissionSet(){
        List<PermissionSetAssignment> lstPsa = [select Id from PermissionSetAssignment where Assignee.Id = :UserInfo.getUserId() and PermissionSet.Name = :Label.DPS_CUSTOMER_COMMUNITY_PERMISSION_SET];
        if(lstPsa.size() > 0)
            hasPermissionSet = true;
        else
            hasPermissionSet = false;     
    } 
}