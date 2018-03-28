public Class sendOrder{
    public String endpoint_x = 'http://testfulfillment.cgx.com/PmOmsws/order.asmx';
    public Map<String,String> inputHttpHeaders_x;
    public String clientCertName_x;
    public Integer timeout_x;
    public sendOrder.DebugHeader DebugHeader;
    public sendOrder.AuthenticationHeader AuthenticationHeader;
    private String DebugHeader_hns = 'DebugHeader=http://sma-promail/';
    private String AuthenticationHeader_hns = 'AuthenticationHeader=http://sma-promail/';
    private String[] ns_map_type_info = new String[]{'http://sma-promail/', 'RequestFulfillment'};
    
    public sendOrder.AddOrderResponse_elementFuture beginAddOrder(System.Continuation continuation,sendOrder.Order order) {
            sendOrder.AddOrder_element request_x = new sendOrder.AddOrder_element();
            request_x.order = order;
            return (sendOrder.AddOrderResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              sendOrder.AddOrderResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://sma-promail/AddOrder',
              'http://sma-promail/',
              'AddOrder',
              'http://sma-promail/',
              'AddOrderResponse',
              'sendOrder.AddOrderResponse_element'}
            );
    }
    public class DebugHeader {
        public Boolean Debug;
        public String Request;
        private String[] Debug_type_info = new String[]{'Debug','http://sma-promail/',null,'1','1','false'};
        private String[] Request_type_info = new String[]{'Request','http://sma-promail/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://sma-promail/','true','false'};
        private String[] field_order_type_info = new String[]{'Debug','Request'};
    }
    public class AuthenticationHeader {
        public String Username;
        public String Password;
        private String[] Username_type_info = new String[]{'Username','http://sma-promail/',null,'0','1','false'};
        private String[] Password_type_info = new String[]{'Password','http://sma-promail/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://sma-promail/','true','false'};
        private String[] field_order_type_info = new String[]{'Username','Password'};
    }
    public class Order {
        public sendOrder.Header Header;
        public sendOrder.OrderedBy OrderedBy;
        public sendOrder.ShipTo ShipTo;
        public sendOrder.BillTo BillTo;
        public sendOrder.Offers Offers;
        private String[] Header_type_info = new String[]{'Header','http://sma-promail/',null,'0','1','false'};
        private String[] OrderedBy_type_info = new String[]{'OrderedBy','http://sma-promail/',null,'0','1','false'};
        private String[] ShipTo_type_info = new String[]{'ShipTo','http://sma-promail/',null,'0','1','false'};
        private String[] BillTo_type_info = new String[]{'BillTo','http://sma-promail/',null,'0','1','false'};
        private String[] Offers_type_info = new String[]{'Offers','http://sma-promail/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://sma-promail/','true','false'};
        private String[] field_order_type_info = new String[]{'Header','OrderedBy','ShipTo','BillTo','Offers'};
    }
    public class Header {
        public String Id;
        public Date EntryDate;
        public string ReferenceNumber;
        public integer PONumber;
        Public String Comments;
        Public Date InsertDate;
        Public DateTime UTCEntryDateTime;
        private String[] Id_type_info = new String[]{'Id','http://sma-promail/',null,'0','1','false'};
        private String[] EntryDate_type_info = new String[]{'EntryDate','http://sma-promail/',null,'0','1','false'};
        private String[] ReferenceNumber_type_info = new String[]{'ReferenceNumber','http://sma-promail/',null,'0','1','false'};
        private String[] PONumber_type_info = new String[]{'PONumber','http://sma-promail/',null,'0','1','false'};
        private String[] Comments_type_info = new String[]{'Comments','http://sma-promail/',null,'0','1','false'};
        private String[] InsertDate_type_info = new String[]{'InsertDate','http://sma-promail/',null,'0','1','false'};
        private String[] UTCEntryDateTime_type_info = new String[]{'UTCEntryDateTime','http://sma-promail/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://sma-promail/','true','false'};
        private String[] field_order_type_info = new String[]{'Id','EntryDate','ReferenceNumber','PONumber','Comments','InsertDate','UTCEntryDateTime'};
    }
    public class OrderedBy{
        public String Prefix;
        public string FirstName;
        public String MiddleInitial;
        public String LastName;
        public string Suffix;
        public string CompanyName;
        public string Title;
        public string Address1;
        public string Address2;
        public string Address3;
        public string City;
        public string State;
        public string PostalCode;
        public string Country;
        public string Phone;
        public integer Fax;
        public string Email;
        public string UID;
        public boolean TaxExempt;
        public boolean TaxExemptApproved;
        public boolean Commercial;
        private String[] Prefix_type_info = new String[]{'Prefix','http://sma-promail/',null,'0','1','false'};
        private String[] FirstName_type_info = new String[]{'FirstName','http://sma-promail/',null,'0','1','false'};
        private String[] MiddleInitial_type_info = new String[]{'MiddleInitial','http://sma-promail/',null,'0','1','false'};
        private String[] LastName_type_info = new String[]{'LastName','http://sma-promail/',null,'0','1','false'};
        private String[] Suffix_type_info = new String[]{'Suffix','http://sma-promail/',null,'0','1','false'};
        private String[] CompanyName_type_info = new String[]{'CompanyName','http://sma-promail/',null,'0','1','false'};
        private String[] Title_type_info = new String[]{'Title','http://sma-promail/',null,'0','1','false'};
        private String[] Address1_type_info = new String[]{'Address1','http://sma-promail/',null,'0','1','false'};
        private String[] Address2_type_info = new String[]{'Address2','http://sma-promail/',null,'0','1','false'};
        private String[] Address3_type_info = new String[]{'Address3','http://sma-promail/',null,'0','1','false'};
        private String[] City_type_info = new String[]{'City','http://sma-promail/',null,'0','1','false'};
        private String[] State_type_info = new String[]{'State','http://sma-promail/',null,'0','1','false'};
        private String[] PostalCode_type_info = new String[]{'PostalCode','http://sma-promail/',null,'0','1','false'};
        private String[] Country_type_info = new String[]{'Country','http://sma-promail/',null,'0','1','false'};
        private String[] Phone_type_info = new String[]{'Phone','http://sma-promail/',null,'0','1','false'};
        private String[] Fax_type_info = new String[]{'Fax','http://sma-promail/',null,'0','1','false'};
        private String[] Email_type_info = new String[]{'Email','http://sma-promail/',null,'0','1','false'};
        private String[] UID_type_info = new String[]{'UID','http://sma-promail/',null,'0','1','false'};
        private String[] TaxExempt_type_info = new String[]{'TaxExempt','http://sma-promail/',null,'0','1','false'};
        private String[] TaxExemptApproved_type_info = new String[]{'TaxExemptApproved','http://sma-promail/',null,'0','1','false'};
        private String[] Commercial_type_info = new String[]{'Commercial','http://sma-promail/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://sma-promail/','true','false'};
        private String[] field_order_type_info = new String[]{'Prefix','FirstName','MiddleInitial','LastName','Suffix','CompanyName','Title','Address1','Address2','Address3','City','State','PostalCode',
                                                              'Country','Phone','Fax','Email','UID','TaxExempt','TaxExemptApproved','Commercial'};
    }
    public class ShipTo{
        public sendOrder.OrderShipTo OrderShipTo;
        private String[] OrderShipTo_type_info = new String[]{'OrderShipTo','http://sma-promail/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://sma-promail/','true','false'};
        private String[] field_order_type_info = new String[]{'OrderShipTo'};
    }
    public class OrderShipTo{
        public boolean TaxExempt;
        public boolean TaxExemptApproved;
        public boolean Commercial;
        public String Flag;
        public integer Key;
        public boolean Rush;
        public String Comments;
        public sendOrder.FreightCarrier FreightCarrier;
        public sendOrder.FreightService FreightService;
        public String FreightCode;
        private String[] TaxExempt_type_info = new String[]{'TaxExempt','http://sma-promail/',null,'0','1','false'};
        private String[] Rush_type_info = new String[]{'Rush','http://sma-promail/',null,'0','1','false'};
        private String[] TaxExemptApproved_type_info = new String[]{'TaxExemptApproved','http://sma-promail/',null,'0','1','false'};
        private String[] Commercial_type_info = new String[]{'Commercial','http://sma-promail/',null,'0','1','false'};
        private String[] Flag_type_info = new String[]{'Flag','http://sma-promail/',null,'0','1','false'};
        private String[] Key_type_info = new String[]{'Key','http://sma-promail/',null,'0','1','false'};
        private String[] Comments_type_info = new String[]{'Comments','http://sma-promail/',null,'0','1','false'};
        private String[] FreightCarrier_type_info = new String[]{'FreightCarrier','http://sma-promail/',null,'0','1','false'};
        private String[] FreightService_type_info = new String[]{'FreightService','http://sma-promail/',null,'0','1','false'};
        private String[] FreightCode_type_info = new String[]{'FreightCode','http://sma-promail/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://sma-promail/','true','false'};
        private String[] field_order_type_info = new String[]{'TaxExempt','Rush','TaxExemptApproved','Commercial','Flag','Key','Comments','FreightCarrier','FreightService','FreightCode'};
    }
    public class FreightCarrier{
        public string Name;
        private String[] Name_type_info = new String[]{'Name','http://sma-promail/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://sma-promail/','true','false'};
        private String[] field_order_type_info = new String[]{'Name'};
    }
    public class FreightService{
        public string Description;
        private String[] Description_type_info = new String[]{'Description','http://sma-promail/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://sma-promail/','true','false'};
        private String[] field_order_type_info = new String[]{'Description'};
    }
    public class BillTo{
        public String Prefix;
        public String FirstName;
        public String MiddleInitial;
        public String LastName;
        public String CompanyName;
        public String Title;
        public String Address1;
        public String Address2;
        public String Address3;
        public String City;
        public String State;
        public string PostalCode;
        public String Country;
        public string Phone;
        public integer Fax;
        public String Email;
        public String UID;
        public boolean TaxExempt;
        public boolean TaxExemptApproved;
        public boolean Commercial;
        public string Flag;
        private String[] Prefix_type_info = new String[]{'Prefix','http://sma-promail/',null,'0','1','false'};
        private String[] FirstName_type_info = new String[]{'FirstName','http://sma-promail/',null,'0','1','false'};
        private String[] MiddleInitial_type_info = new String[]{'MiddleInitial','http://sma-promail/',null,'0','1','false'};
        private String[] LastName_type_info = new String[]{'LastName','http://sma-promail/',null,'0','1','false'};
        private String[] CompanyName_type_info = new String[]{'CompanyName','http://sma-promail/',null,'0','1','false'};
        private String[] Title_type_info = new String[]{'Title','http://sma-promail/',null,'0','1','false'};
        private String[] Address1_type_info = new String[]{'Address1','http://sma-promail/',null,'0','1','false'};
        private String[] Address2_type_info = new String[]{'Address2','http://sma-promail/',null,'0','1','false'};
        private String[] Address3_type_info = new String[]{'Address3','http://sma-promail/',null,'0','1','false'};
        private String[] City_type_info = new String[]{'City','http://sma-promail/',null,'0','1','false'};
        private String[] State_type_info = new String[]{'State','http://sma-promail/',null,'0','1','false'};
        private String[] PostalCode_type_info = new String[]{'PostalCode','http://sma-promail/',null,'0','1','false'};
        private String[] Country_type_info = new String[]{'Country','http://sma-promail/',null,'0','1','false'};
        private String[] Phone_type_info = new String[]{'Phone','http://sma-promail/',null,'0','1','false'};
        private String[] Fax_type_info = new String[]{'Fax','http://sma-promail/',null,'0','1','false'};
        private String[] Email_type_info = new String[]{'Email','http://sma-promail/',null,'0','1','false'};
        private String[] UID_type_info = new String[]{'UID','http://sma-promail/',null,'0','1','false'};
        private String[] TaxExempt_type_info = new String[]{'TaxExempt','http://sma-promail/',null,'0','1','false'};
        private String[] TaxExemptApproved_type_info = new String[]{'TaxExemptApproved','http://sma-promail/',null,'0','1','false'};
        private String[] Commercial_type_info = new String[]{'Commercial','http://sma-promail/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://sma-promail/','true','false'};
        private String[] field_order_type_info = new String[]{'Prefix','FirstName','MiddleInitial','LastName','CompanyName','Title','Address1','Address2','Address3',
                                                               'City','State','PostalCode','Country','Phone','Fax','Email','UID','TaxExempt','TaxExemptApproved','Commercial'};
    }
    public class Offers{
        public sendOrder.OfferOrdered OfferOrdered;
        private String[] OfferOrdered_type_info = new String[]{'OfferOrdered','http://sma-promail/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://sma-promail/','true','false'};
        private String[] field_order_type_info = new String[]{'OfferOrdered'};
    }
    public class OfferOrdered{
        public sendOrder.Offer Offer;
        public decimal Quantity;
        public sendOrder.OrderShipToKey OrderShipToKey;
        private String[] Offer_type_info = new String[]{'Offer','http://sma-promail/',null,'0','1','false'};
        private String[] Quantity_type_info = new String[]{'Quantity','http://sma-promail/',null,'0','1','false'};
        private String[] OrderShipToKey_type_info = new String[]{'OrderShipToKey','http://sma-promail/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://sma-promail/','true','false'};
        private String[] field_order_type_info = new String[]{'Offer','Quantity','OrderShipToKey'};
    }
    public class Offer{
        public sendOrder.OfferHeader Header;
        private String[] UTCEntryDateTime_type_info = new String[]{'Header','http://sma-promail/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://sma-promail/','true','false'};
        private String[] Header_order_type_info = new String[]{'Header'};
    }
    public class OfferHeader{
        Public String Id;
        private String[] Id_type_info = new String[]{'Id','http://sma-promail/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://sma-promail/','true','false'};
        private String[] field_order_type_info = new String[]{'Id'};
    }
    public class OrderShipToKey{
        public integer Key;
        private String[] Key_type_info = new String[]{'Key','http://sma-promail/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://sma-promail/','true','false'};
        private String[] field_order_type_info = new String[]{'Key'};
    }
    
    public class AddOrderResponse_elementFuture extends System.WebServiceCalloutFuture {
        public sendOrder.AddOrderResult getValue() {
            sendOrder.AddOrderResponse_element response = (sendOrder.AddOrderResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.AddOrderResult;
        }
    }
    public class AddOrderResult {
        public Integer OrderSeqID;
        public String OrderID;
        private String[] OrderSeqID_type_info = new String[]{'OrderSeqID','http://sma-promail/',null,'1','1','false'};
        private String[] OrderID_type_info = new String[]{'OrderID','http://sma-promail/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://sma-promail/','true','false'};
        private String[] field_order_type_info = new String[]{'OrderSeqID','OrderID'};
    }
    public class AddOrder_element {
        public sendOrder.Order order;
        private String[] order_type_info = new String[]{'order','http://sma-promail/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://sma-promail/','true','false'};
        private String[] field_order_type_info = new String[]{'order'};
    }
    public class AddOrderResponse_element {
        public sendOrder.AddOrderResult AddOrderResult;
        private String[] AddOrderResult_type_info = new String[]{'AddOrderResult','http://sma-promail/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://sma-promail/','true','false'};
        private String[] field_order_type_info = new String[]{'AddOrderResult'};
    }
}