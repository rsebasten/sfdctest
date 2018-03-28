public class LegacyOpportunityHistory implements HistoryInterface {

    public Integer id;
    public String stagename;
    public Double amount;
    public Double probability;
    public Double expectedrevenue;
    public Long closedate;
    public String createdbyid;
    //public Object user;

    
    public static List<LegacyOpportunityHistory> parse(String json) {
        return (List<LegacyOpportunityHistory>) System.JSON.deserialize(json, List<LegacyOpportunityHistory>.class);
    }
}