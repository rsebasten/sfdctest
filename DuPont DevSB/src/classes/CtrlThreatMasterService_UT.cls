/*******************************************************************************
(C)2015
Author: Pallavi Sharma
Email: Pallavi.sharma3@tcs.com
Description:  This class tests the CtrlThreatMasterService.
 ********************************************************************************/
@isTest
private class CtrlThreatMasterService_UT {
   
    public static Kevlar_Response_Messages__c m1,m2,m3,m4;
    public static List<Kevlar_Response_Messages__c> InsertList = new List<Kevlar_Response_Messages__c>(); 

    static{
        m1 = testData_Kevlar_UT.getMessage1(); 
        InsertList.add(m1);       
        m4 = testData_Kevlar_UT.getMessage20();
        InsertList.add(m4);  
        m2 = testData_Kevlar_UT.getMessage2(); 
        InsertList.add(m2);  
        m3 = testData_Kevlar_UT.getMessage3();
        InsertList.add(m3);  
        insert InsertList;
    }
      static testMethod void testDoPost() {    
        // Adding Dummy Value
        
        List<Threat_Master__c> Tbac = new List<Threat_Master__c>();
        Threat_Master__c dat1=new Threat_Master__c ();
        dat1.Name='9 X 19 MM';
        dat1.Threat_Type__c='Bullet';
        dat1.Weight__c = 20;
        dat1.Velocity__c = 1.2;
        dat1.type__c = 'test';
        Tbac.add(dat1); 
         Threat_Master__c bullet2=new Threat_Master__c ();
         bullet2.name = '0.44 MAG';
         bullet2.Threat_Type__c='Bullet';
         bullet2.Weight__c = 20;
         bullet2.Velocity__c = 1.2;
         Tbac.add(bullet2);
         
         Threat_Master__c bullet3=new Threat_Master__c ();
         bullet3.name = '0.357 MAG';
         bullet3.Threat_Type__c='Bullet';
         bullet3.Weight__c = 20;
         bullet3.Velocity__c = 1.2;
         Tbac.add(bullet3);
         
    Threat_Master__c bullet5 =new Threat_Master__c ();
         bullet5.name = '0.380 ACP';
         bullet5.Threat_Type__c='Bullet';
         bullet5.Weight__c = 20;
         bullet5.Velocity__c = 1.2;
         Tbac.add(bullet5);

    Threat_Master__c bullet6 =new Threat_Master__c ();
         bullet6.name = '9 x 18';
         bullet6.Threat_Type__c='Bullet';
         Tbac.add(bullet6);

    Threat_Master__c bullet7 =new Threat_Master__c ();
         bullet7.name = '0.40 S&W';
         bullet7.Threat_Type__c='Bullet';
         Tbac.add(bullet7);

    Threat_Master__c bullet8 =new Threat_Master__c ();
         bullet8.name = '7.62 x 38R';
         bullet8.Threat_Type__c='Bullet';
         Tbac.add(bullet8);     

    Threat_Master__c bullet9 =new Threat_Master__c ();
         bullet9.name = '7.62 X 17';
         bullet9.Threat_Type__c='Bullet';
         Tbac.add(bullet9);


    Threat_Master__c bullet10 =new Threat_Master__c ();
         bullet10.name = '7.62 X 25';
         bullet10.Threat_Type__c='Bullet';
         Tbac.add(bullet10);

    Threat_Master__c bullet11 =new Threat_Master__c ();
         bullet11.name = '12 gauge (full choke)';
         bullet11.Threat_Type__c='Bullet';
         Tbac.add(bullet11);

    Threat_Master__c bullet12 =new Threat_Master__c ();
         bullet12.name = '7.62 NATO';
         bullet12.Threat_Type__c='Bullet';
         Tbac.add(bullet12);
    
    Threat_Master__c bullet13 =new Threat_Master__c ();
         bullet13.name = '7.62 x 51 NATO Ball M80 (USA)/ C21 (Can) DM41 (Ger)';
         bullet13.Threat_Type__c='Bullet';
         Tbac.add(bullet13);

    Threat_Master__c bullet26 =new Threat_Master__c ();
         bullet26.name = '7.62 x 39 AK47';
         bullet26.Threat_Type__c='Bullet';
         Tbac.add(bullet26);

    Threat_Master__c bullet14 =new Threat_Master__c ();
         bullet14.name = '7.62 x 51';
         bullet14.Threat_Type__c='Bullet';
         Tbac.add(bullet14);

    Threat_Master__c bullet15 =new Threat_Master__c ();
         bullet15.name = '0.32 Cal M2 AP';
         bullet15.Threat_Type__c='Bullet';
         Tbac.add(bullet15);

    Threat_Master__c bullet16 =new Threat_Master__c ();
         bullet16.name = '5.45 x 18';
         bullet16.Threat_Type__c='Bullet';
         Tbac.add(bullet16);

    Threat_Master__c bullet17 =new Threat_Master__c ();
         bullet17.name = '5.45 x 39';
         bullet17.Threat_Type__c='Bullet';
         Tbac.add(bullet17);

    Threat_Master__c bullet18 =new Threat_Master__c ();
         bullet18.name = '5.56 x 45';
         bullet18.Threat_Type__c='Bullet';
         Tbac.add(bullet18);

    Threat_Master__c bullet19 =new Threat_Master__c ();
         bullet19.name = '7.62 X 54';
         bullet19.Threat_Type__c='Bullet';
         Tbac.add(bullet19);

    
    Threat_Master__c bullet20 =new Threat_Master__c ();
         bullet20.name = '7.62';
         bullet20.Threat_Type__c='Bullet';
         Tbac.add(bullet20);

    Threat_Master__c bullet21 =new Threat_Master__c ();
         bullet21.name = '7.62 x 54R';
         bullet21.Threat_Type__c='Bullet';
         Tbac.add(bullet21);

    Threat_Master__c bullet22 =new Threat_Master__c ();
         bullet22.name = '7.62 x 51';
         bullet22.Threat_Type__c='Bullet';
         Tbac.add(bullet22);

    Threat_Master__c bullet23 =new Threat_Master__c ();
         bullet23.name = '12.7 x 99 -50 Browning Ruag SWISS P';
         bullet23.Threat_Type__c='Bullet';
         Tbac.add(bullet23);

    Threat_Master__c bullet24 =new Threat_Master__c ();
         bullet24.name = '14.5 x 114 API/B32';
         bullet24.Threat_Type__c='Bullet';
         Tbac.add(bullet24);

    Threat_Master__c bullet25 =new Threat_Master__c ();
         bullet25.name = '25 x 137 APDS-T Oerlikon-Contraves';
         bullet25.Threat_Type__c='Bullet';
         Tbac.add(bullet25);
    

        Threat_Master__c dat2=new Threat_Master__c ();
        dat2.Name='threat2';
        dat2.Threat_Type__c='Fragment';
        Tbac.add(dat2);
        
        Threat_Master__c nbt2=new Threat_Master__c ();
        nbt2.Name='Double Side Knife S1';
        nbt2.Threat_Type__c='NBT';
        Tbac.add(nbt2);
        
        Threat_Master__c dat3=new Threat_Master__c ();
        dat3.Name='Single Side Knife P1 B';
        dat3.Threat_Type__c='NBT';
        Tbac.add(dat3);
        
        
        Threat_Master__c dat4=new Threat_Master__c ();
        dat4.Name='Knife VAPM';
        dat4.Threat_Type__c='NBT';
        Tbac.add(dat4);
        

    Threat_Master__c dat5=new Threat_Master__c ();
        dat5.Name='Blunt';
        dat5.Threat_Type__c='NBT';
        Tbac.add(dat5);
        
           
    Threat_Master__c dat6=new Threat_Master__c ();
        dat6.Name='Needle';
        dat6.Threat_Type__c='NBT';
        Tbac.add(dat6);
        
    
    Threat_Master__c dat7=new Threat_Master__c ();
        dat7.Name='Spike';
        dat7.Threat_Type__c='NBT';
        Tbac.add(dat7);
        

    Threat_Master__c dat8=new Threat_Master__c ();
        dat8.Name='Spike';
        dat8.Threat_Type__c='NBT';
        Tbac.add(dat8);
        insert (Tbac);
        


        String JsonMsg='{'+
        '"threatType1" : "Bullet",'+
        '"threatType2" : "Fragment",'+
        '"threatType3" : "NBT"'+
        '}'+
        '';
 
        Test.startTest();

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/ThreatMaster';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;


        CtrlThreatMasterService testTHR=new CtrlThreatMasterService();   
        CtrlThreatMasterService.doPost(); 
        Test.stopTest();
    }
    
}