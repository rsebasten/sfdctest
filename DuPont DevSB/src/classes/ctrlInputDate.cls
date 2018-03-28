//<SA20180310> deleted hard-coded references and deleted the test class and written a seperate test class ctrlInputDate_UT
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
   //<SA20180310>
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
    
}