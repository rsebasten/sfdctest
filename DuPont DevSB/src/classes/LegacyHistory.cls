public class LegacyHistory implements HistoryInterface{

    public class User {
        public String sfid;
        public String firstname;
        public String lastname;
    }

    public Integer id;
    public String oldvalue;
    public String newvalue;
    public Long createddate;
    public String createdbyid;
    public String field;
    public User user;

    
    public static List<LegacyHistory> parse(String json) {
        return (List<LegacyHistory>) System.JSON.deserialize(json, List<LegacyHistory>.class);
    }
}