public class ctrlInputDate {
    public Event e      {set; get;} 
    
    public ctrlInputDate() {
        e=new Event(ActivityDate=Date.today());
    }
    public Date dateField {
        GET {return e.ActivityDate; }
        SET { if (value!=null) e.ActivityDate = value; }
    }
    public string dateString {
        GET { 
            system.debug('ctrlInputDate:dateString:GET:value='+String.valueOf(dateField));
            return String.valueOf(dateField); 
            }
    }
    
    public string defaultString {
        GET { return dateString; }
        SET { 
            try {
                //US date
                Date dt = StringToDate(value);
                system.debug('ctrlInputDate:dateString:SET:value='+value);
                dateField=dt; 
            }
            catch(exception ex){}
    }}
    
    
    public date dtDefault {
        GET { return e.ActivityDate; }
        SET { if (value!=null) e.ActivityDate= value; }
    }
    
    public void refresh() {}

    //reference: https://na13.salesforce.com/help/doc/user_ed.jsp?section=help&target=admin_supported_locales.htm&loc=help&hash=topic-title
    public static Date stringtoDate(string s) { return stringtoDate(s, Userinfo.getLocale()); }
    public static Date stringtoDate(string s, string locale) {
        SET<string> timeFirst = new SET<string>{'iw','iw_IL','vi','vi_VN'};
        SET<string> ymd = new SET<string>{'ko','ko_KR','hu','lt_LT','in','ja','ja_JP','en_ZA','zh_TW','zh_HK','fr_CA','pl','sv','sv_SE','bg_BG','zh','zh_CN'};
        SET<string> ydm = new SET<string>{'lv_LV'};
        SET<string> mdy = new SET<string>{'en_BB','en_BM','en_GH','en_ID','en_SG','en_US','hy_AM','kk_KZ','km_KH','ur_PK','es_HN','es_PR','es_SV'};     
        
        s=s.replace('. ','.'); //ko, ko_KR
        String[] splitDateTime = s.split(' ');
        string datePart;
        if ( splitDateTime.size()==2 && timeFirst.contains(locale) )
            datePart=splitDateTime[1];
        else if (splitDateTime.size()>0) 
            datePart=splitDateTime[0];
        else 
            return null;
        
        date dt;
        String[] stringDate = datePart.split('\\D'); //split by '-','.','/'  '(/|-|\\.)'
        if (stringDate!=null && stringDate.size()>=3) {
            Integer d1 =  Integer.valueOf(stringDate[0]);
            Integer d2 = Integer.valueOf(stringDate[1]);
            Integer d3 = Integer.valueOf(stringDate[2]);
            system.debug(d1+'|'+d2+'|'+d3);
            
            //Buddhist calendar yr
            if (locale=='th_TH') d3-=543;
            
            if (mdy.contains(locale))
                dt=date.newInstance(d3,d1,d2);
            else if (ymd.contains(locale))
                dt=date.newInstance(d1,d2,d3);
            else if (ydm.contains(locale))
                dt=date.newInstance(d1,d3,d2);
            else 
                dt=date.newInstance(d3,d2,d1);  // most locales fall in this format
        }
        else
            dt=date.valueOf(datePart);
        
        //handle 2-digit years  (1970 is cutoff to be consistent with newInstance(Long i))
        if (dt.year()>0 && dt.year()<70) dt=dt.addYears(2000);
        else if (dt.year()>=70 && dt.year()<100) dt=dt.addYears(1900);
            
        return dt;
    }
    

    static testMethod void test_stringtoDate() {
        for (string l : testLocaleDates.keySet()) {
            string strDT = testLocaleDates.get(l);
            system.debug('trying '+l+' ['+strDT+'] ');
            date dt = stringtoDate(strDT,l);
            system.assertEquals(dt, Date.newInstance(2008,1,2));
        }

    }
    


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