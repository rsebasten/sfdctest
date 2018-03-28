@isTest
private class Util_UT {

//public Account testAccount { GET { return new Account(name='TestCo: ', country__c='United States'); }}
//public Contact testContact { GET { return new Contact(lastname='TestCo: ', email='United States'); }}

/******************************************************************************************
    TEST SCRIPTS
******************************************************************************************/
    static testMethod void test_stringtoDate() {
        for (string l : testLocaleDates.keySet()) {
            string strDT = testLocaleDates.get(l);
            system.debug('trying '+l+' ['+strDT+'] ');
            date dt = Util.stringtoDate(strDT,l);
            system.assertEquals(Date.newInstance(2008,1,2),dt);
        }
    }

    static testMethod void test_Describe() {
        Account a =new Account(name='TestCo', country__c='United States');
        insert a;
        Contact c =new Contact(accountid=a.id, lastname='TestCo: ', email='tester@test.com');
        insert c;
        Util.Describe d = new Util.Describe(c);
        system.debug(d.AccessibleFieldMap);
        system.assertEquals(d.fieldExist('firstName'),true);
        system.assertEquals(d.fieldExist('first_Name'),false);
        system.debug(d.fieldInfo('lastName'));
        system.debug(d.getObject(c.id));
        system.debug(d.DSR);
        system.debug(d.getObjectStub(c.accountid));
        Util.Describe d2 = new Util.Describe('Account');
        system.debug(d2.getChildRelationship('Contacts'));
        
        system.debug(Util.describeField('Account.Country__c'));
        system.debug(Util.describeField('Account','Country__c'));
        
    }
    
    static testMethod void test_stringtoDateTime() {
        for (string l : testLocaleDates.keySet()) {
            string strDT = testLocaleDates.get(l);
            system.debug('trying '+l+' ['+strDT+'] ');
            datetime dt = Util.stringtoDateTime(strDT,l);
            system.assertEquals(dt, DateTime.newInstanceGmt(2008,1,2,16,30,0));
        }

    }
    

static testMethod void test_Utils() {
    //Settings.upsertSetting('pod','na13');
    system.debug(Util.isProduction);
    //createGuid
    for (integer i=0;i<2;i++)
        system.debug(Util.createGuid());

    //createSelectOptions
    system.debug(Util.createSelectOptions([Select Id, Name from Account LIMIT 5]));
    system.debug(Util.createSelectOptions(new LIST<string>{'A','B','C'}));
    ///////
    system.debug(Util.POD);
    /////
    system.debug(Util.splitToSet('A,B,C', ','));
    system.debug(Util.DateTimetoXml(DateTime.now()));
    system.debug(Util.DatetoXml(Date.Today())); 
    system.debug(Util.XmlToDateTime('2000-01-01T00:00:000Z'));
    system.debug(Util.XmlToDate('2000-01-01T00:00:000Z'));
    system.assertEquals(Util.TypeById('001'), 'account'); //will return campaign;

    system.assertEquals(Util.stringToBoolean('1'),true);
    system.debug(Util.stringToDouble('2.2'));
    system.debug(Util.stringToEmail('tom@somewhere.com'));
    system.assertEquals(Util.stringToInteger('5'), 5);  
    system.assertEquals(Util.invertMap(new MAP<string,string>{'A'=>'Alpha','B'=>'Beta'}),new MAP<string,string>{'Alpha'=>'A','Beta'=>'B'});
    system.assertEquals(Util.joint(new LIST<string>{'A','B'}, ';'),'A;B');
    system.assertEquals(Util.inClause(new LIST<Id>{'zzz000000000001','zzz000000000002'}),'(\'zzz000000000001AAA\',\'zzz000000000002AAA\')');
    system.assertEquals(Util.inClause(new LIST<string>{'Cat','Dog'}),'(\'Cat\',\'Dog\')');
    
    Account a =new Account(name='TestCo', country__c='United States');
    insert a;
    system.assertEquals( (string) Util.getRecord(a.id).get(Util.getNameField('Account')),a.name);
    system.assertEquals( (string) Util.getRecord('Account',a.id).get(Util.getNameField('Account')),a.name);
    system.assertEquals(Util.getGlobalPrefixMap().get('001'),'Account');
    system.assertEquals(Util.getNameField('Solution'),'SolutionName');
    system.assertEquals(Util.getNameField('Case'),'CaseNumber');
    system.assertEquals(Util.getNameField_Slow('Solution'),'SolutionName');
    system.assertEquals(Util.getNameField_Slow('Case'),'CaseNumber');
    //system.assertEquals(Util.getNameField_Slow('Account'),'FirstName');
    //system.assertEquals(Util.isId(a.id),true);
    //system.assertEquals(Util.isId('abc'),false);
    //system.assertEquals(Util.genId(2),'gen000000000002');
    //system.debug(Util.createHash('pazzw0rd'));
    
    //system.assertEquals(Util.isBlank(null), true);
    //system.assertEquals(Util.isBlank(''), true);
    //system.assertEquals(Util.isBlank('x'), false);
    
    //system.assertEquals(Util.OrgIdToPOD('0DZZ00000000001'),'CS11');
    //system.assertEquals(Util.mapUrlVars('this=foo&that=bar').get('that'),'bar');
    //system.assertEquals(Util.isID('foo'),false);
    //system.assertEquals(Util.isID('001000000000002'),true);  
}

static testMethod void testDynamic() {
    //Util.DescribeField
    system.debug(Util.DescribeField('Contact.LastName'));
    system.debug(Util.DescribeField('Contact','LastName'));
    
        
    //Util.SobjectPutMap, Util.SobjectPutMap, SobjectPutString
    Account a = new Account();
    Util.SobjectPutMap(a, testPUTAccount, new Util.Describe('Account'),'US_en');
    system.assertEquals(10000, a.AnnualRevenue); //will eval '10,000' to 10k
    Util.SobjectPutMap(a, testPUTAccount, new Util.Describe('Account'),'ca');
    system.assertEquals(10, a.AnnualRevenue);  //will eval '10,000' to 10.000
}

/**************************************************************************************
Test account 
**************************************************************************************/

private static final MAP<String,String> testPUTAccount = new MAP<String,String> {
    'name'                      => 'Test Account',
    'type'                      => 'Customer',
    'BillingCountry'            => 'US',   
    'AnnualRevenue'             => '10,000'   
};

private static final MAP<String,String> testLocaleDates = new MAP<String,String> {
    'es_HN'         => '01-02-2008 04:30 PM',
    'es_PR'         => '01-02-2008 04:30 PM',
    'es_SV'         => '01-02-2008 04:30 PM',
    'de'            => '02.01.2008 16:30',
    'de_AT'         => '02.01.2008 16:30',
    'de_AT_EURO'    => '02.01.2008 16:30',
    'de_CH'         => '02.01.2008 16:30',
    'de_DE'         => '02.01.2008 16:30',
    'de_DE_EURO'    => '02.01.2008 16:30',
    'de_LU'         => '02.01.2008 16:30',
    'de_LU_EURO'    => '02.01.2008 16:30',
    'fr_CH'         => '02.01.2008 16:30',
    'it_CH'         => '02.01.2008 16:30',
    'no'            => '02.01.2008 16:30',
    'no_NO'         => '02.01.2008 16:30',
    'ro'            => '02.01.2008 16:30',
    'ro_RO'         => '02.01.2008 16:30',
    'ru'            => '02.01.2008 16:30',
    'ru_RU'         => '02.01.2008 16:30',
    'tr'            => '02.01.2008 16:30',
    'uk'            => '02.01.2008 16:30',
    'uk_UA'         => '02.01.2008 16:30',
    'hr_HR'         => '02.01.2008. 16:30',
    'ar'            => '02/01/2008 04:30 PM',
    'ar_AE'         => '02/01/2008 04:30 PM',
    'ar_BH'         => '02/01/2008 04:30 PM',
    'ar_JO'         => '02/01/2008 04:30 PM',
    'ar_KW'         => '02/01/2008 04:30 PM',
    'ar_LB'         => '02/01/2008 04:30 PM',
    'ar_SA'         => '02/01/2008 04:30 PM',
    'es_CR'         => '02/01/2008 04:30 PM',
    'es_EC'         => '02/01/2008 04:30 PM',
    'es_PE'         => '02/01/2008 04:30 PM',
    'es_PY'         => '02/01/2008 04:30 PM',
    'es_UY'         => '02/01/2008 04:30 PM',
    'es_VE'         => '02/01/2008 04:30 PM',
    'it'            => '02/01/2008 16.30',
    'it_IT'         => '02/01/2008 16.30',
    'ca'            => '02/01/2008 16:30',
    'ca_ES'         => '02/01/2008 16:30',
    'ca_ES_EURO'    => '02/01/2008 16:30',
    'en_GB'         => '02/01/2008 16:30',
    'en_IE'         => '02/01/2008 16:30',
    'en_IE_EURO'    => '02/01/2008 16:30',
    'es_AR'         => '02/01/2008 16:30',
    'fr'            => '02/01/2008 16:30',
    'fr_FR'         => '02/01/2008 16:30',
    'fr_FR_EURO'    => '02/01/2008 16:30',
    'fr_LU'         => '02/01/2008 16:30',
    'fr_MC'         => '02/01/2008 16:30',
    'pt_BR'         => '02/01/2008 16:30',
    'en_CA'         => '02/01/2008 4:30 PM',
    'ms_MY'         => '02/01/2008 4:30 PM',
    'es_BO'         => '02-01-2008 04:30 PM',
    'es_CL'         => '02-01-2008 04:30 PM',
    'da'            => '02-01-2008 16:30',
    'da_DK'         => '02-01-2008 16:30',
    'pt'            => '02-01-2008 16:30',
    'pt_AO'         => '02-01-2008 16:30',
    'pt_PT'         => '02-01-2008 16:30',
    'en_BB'         => '1/2/2008 4:30 PM',
    'en_BM'         => '1/2/2008 4:30 PM',
    'en_GH'         => '1/2/2008 4:30 PM',
    'en_ID'         => '1/2/2008 4:30 PM',
    'en_SG'         => '1/2/2008 4:30 PM',
    'en_US'         => '1/2/2008 4:30 PM',
    'hy_AM'         => '1/2/2008 4:30 PM',
    'kk_KZ'         => '1/2/2008 4:30 PM',
    'km_KH'         => '1/2/2008 4:30 PM',
    'ur_PK'         => '1/2/2008 4:30 PM',
    'iw'            => '16:30 02/01/2008',
    'iw_IL'         => '16:30 02/01/2008',
    'vi'            => '16:30 02/01/2008',
    'vi_VN'         => '16:30 02/01/2008',
    'et_EE'         => '2.01.2008 16:30',
    'sl_SI'         => '2.1.08 16:30',
    'cs'            => '2.1.2008 16:30',
    'cs_CZ'         => '2.1.2008 16:30',
    'fi'            => '2.1.2008 16:30',
    'fi_FI'         => '2.1.2008 16:30',
    'fi_FI_EURO'    => '2.1.2008 16:30',
    'is_IS'         => '2.1.2008 16:30',
    'sk_SK'         => '2.1.2008 16:30',
    'es_CO'         => '2/01/2008 04:30 PM',
    'es_GT'         => '2/01/2008 04:30 PM',
    'es_MX'         => '2/01/2008 04:30 PM',
    'es'            => '2/01/2008 16:30',
    'es_ES'         => '2/01/2008 16:30',
    'es_ES_EURO'    => '2/01/2008 16:30',
    'fr_BE'         => '2/01/2008 16:30',
    'nl_BE'         => '2/01/2008 16:30',
    'en_AU'         => '2/01/2008 4:30 PM',
    'en_NZ'         => '2/01/2008 4:30 PM',
    'el'            => '2/1/2008 4:30 PM',
    'el_GR'         => '2/1/2008 4:30 PM',
    'th'            => '2/1/2008, 16:30 ?.',
    'th_TH'         => '2/1/2551, 16:30 ?.',
    'ko'            => '2008. 1. 2 PM 4:30',
    'ko_KR'         => '2008. 1. 2 PM 4:30',
    'hu'            => '2008.01.02. 16:30',
    'lt_LT'         => '2008.1.2 16.30',
    'lv_LV'         => '2008.2.1 16:30',
    'in'            => '2008/01/02 16:30',
    'ja'            => '2008/01/02 16:30',
    'ja_JP'         => '2008/01/02 16:30',
    'en_ZA'         => '2008/01/02 4:30 PM',
    'zh_TW'         => '2008/1/2 PM 4:30',
    'zh_HK'         => '2008?1?2? PM4:30',
    'fr_CA'         => '2008-01-02 16:30',
    'pl'            => '2008-01-02 16:30',
    'sv'            => '2008-01-02 16:30',
    'sv_SE'         => '2008-01-02 16:30',
    'bg_BG'         => '2008-1-2 16:30',
    'zh'            => '2008-1-2 PM4:30',
    'zh_CN'         => '2008-1-2 PM4:30',
    'nl'            => '2-1-2008 16:30',
    'nl_NL'         => '2-1-2008 16:30',
    'nl_SR'         => '2-1-2008 16:30'
    };    
}