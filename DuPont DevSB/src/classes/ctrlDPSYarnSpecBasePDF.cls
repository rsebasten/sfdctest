/*******************************************************************************
Copyright © 2016 DuPont. All rights reserved.
Author: Tabrez Ansari
Email: tabrez.ansari@tcs.com
Description:  This controller is used to show the Search Criteria page in pdf format.
Created Date: 10/3/2016
Version: 1.0
********************************************************************************/

public with sharing class ctrlDPSYarnSpecBasePDF
{
    //Initialize variables
    public Search_Criteria__c objSearchCritPDF { get; set; }
    public Boolean showResult { get; private set; }
    public id recId { get; set; }
    public List<wrapYarnSpec> lswrap { get; set; }
    public decimal appLoopStrength { get; set; }
    public boolean showPage { get; set; }
    
    private DPSKevlarCustomSetting__c dps;
    @TestVisible private Decimal INCHSTITCHVALUE;
    @TestVisible private Decimal INCHOPERATINGPRESSURE;
    @TestVisible private static final String STRMM = 'mm';
    @TestVisible private static final String STRBAR = 'BAR';
    
    /* Function Description
    Name : ctrlDPSYarnSpecBase
    Return Type: void
    Description: It is the constructor method     
    */
    public ctrlDPSYarnSpecBasePDF(ApexPages.StandardController controller)
    {
        try {
            showResult = false;
            dps = DPSKevlarCustomSetting__c.getinstance();
            recId = ApexPages.currentPage().getParameters().get('id');
            if(recId == null ){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,Label.DPS_Pdf_Error_Message));
                    showPage = false;
            }
            else{
                showPage = true;
                // This method is used to display the saved search in pdf format.
                displayResultPDF();
            }
        }
        catch(exception e) {
        }
    }
    
    /* Function Description
    Name : displayResultPDF
    Return Type: void
    Description: This method is used to get the information from the search criteria records & calculate the burst pressure in BAR & PSI & display the result on the page.
    */
    
    public void displayResultPDF()
    {
        objSearchCritPDF = new Search_Criteria__c();
        objSearchCritPDF = [select name, KV_Comments__c, KV_Customer__r.Name, KV_OEM__c, KV_OEM_Country__c, KV_OEM_Platform__c, KV_Operating_Temperature__c , KV_Operating_Pressure_Unit__c, KV_Operating_Pressure_Value__c, KV_Internal_Diameter_mm__c, KV_Inner_Wall_Thickness_mm__c, KV_Stitch_Length_Unit__c, KV_Stitch_Length_Value__c, KV_Knitting_Angle__c, KV_Appropriate_Loop_Strength__c from Search_Criteria__c where id =: recId limit 1];
        system.debug('*** ');
        appLoopStrength = objSearchCritPDF.KV_Appropriate_Loop_Strength__c; 
        Decimal PSITOBAR = Decimal.valueOf(dps.KV_PSI_to_Bar__c);
        Decimal burstPrBAR = 0;
        Decimal burstPrPSI = 0;
        
        //Converting stitch length from inch to mm and Op. pressure from PSI to BAR to be used in further calculations
        convertUnits();
        
        List<Yarn_Specification__c> YarnSpecList = new List<Yarn_Specification__c>();
        YarnSpecList = getYarnSpecRecords();
        lswrap = new list<wrapYarnSpec>();
        
        for(Yarn_Specification__c yarnspec :  YarnSpecList)
        {
           if(yarnspec.KV_100_Cycles__c >= appLoopStrength)
           {
                burstPrBAR = (10 * yarnspec.KV_0_Cycles__c * math.sin(objSearchCritPDF.KV_Knitting_Angle__c * 3.14/180))/(2 * INCHSTITCHVALUE * (objSearchCritPDF.KV_Internal_Diameter_mm__c + (2 * objSearchCritPDF.KV_Inner_Wall_Thickness_mm__c)));
                burstPrPSI = burstPrBAR / PSITOBAR;
                wrapYarnSpec wrapObj = new wrapYarnSpec();
                wrapobj.yrsp = yarnspec;
                wrapobj.burstPrPSI = burstPrPSI.setScale(2);
                wrapobj.burstPrBAR = burstPrBAR.setScale(2);
                lswrap.add(wrapobj);
            }
        }
        this.showResult = true;
    }
    
    /* Function Description
    Name : convertUnits
    Return Type: void
    Description: This method is used to convert inch to mm and PSI to BAR.      
    */
    private void convertUnits()
    {
        Decimal PSITOBAR = Decimal.valueOf(dps.KV_PSI_to_Bar__c);
        Decimal INCHTOMM = Decimal.valueOf(dps.KV_inch_to_mm__c);
        
        if(objSearchCritPDF.KV_Stitch_Length_Unit__c != STRMM){
            INCHSTITCHVALUE =  INCHTOMM / objSearchCritPDF.KV_Stitch_Length_Value__c;    
        }
        else{
            INCHSTITCHVALUE = objSearchCritPDF.KV_Stitch_Length_Value__c;
        }  
        
        if(objSearchCritPDF.KV_Operating_Pressure_Unit__c != STRBAR){
            INCHOPERATINGPRESSURE = objSearchCritPDF.KV_Operating_Pressure_Value__c * PSITOBAR ;    
        }
        else{
            INCHOPERATINGPRESSURE = objSearchCritPDF.KV_Operating_Pressure_Value__c ;
        }
    }
    
    /* Function Description
    Name : getFields
    Return Type: List
    Description: This method returns the fields in the Yarn Specification fieldset.      
    */ 
    public List<Schema.FieldSetMember> getFields()
    {
        return SObjectType.Yarn_Specification__c.FieldSets.showResult.getFields();
    }

    /* Function Description
    Name : getFields
    Return Type: List
    Description: This method returns the search result records.      
    */
    private List<Yarn_Specification__c> getYarnSpecRecords()
    {
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : this.getFields()) {
            query += f.getFieldPath() + ', ';
        }
        query += 'Id, KV_Product_Name__c FROM Yarn_Specification__c where KV_Operating_Temperature__c=\'' + objSearchCritPDF.KV_Operating_Temperature__c + '\'' + ' order by KV_Product_Name__c ';
        return Database.query(query);
    }

    //wrapper class
    public class wrapYarnSpec
    {
        public Yarn_Specification__c yrsp { get; set; }
        public Decimal burstPrPSI { get; set; }
        public Decimal burstPrBAR { get; set; }
        
        public wrapYarnSpec()
        {
            yrsp=new Yarn_Specification__c();
            burstPrPSI = 0;
            burstPrBAR = 0;
        } 
    }   
}