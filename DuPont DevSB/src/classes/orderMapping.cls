public class orderMapping {
    public void orderMap(){
        SendOrder.Order order = new SendOrder.Order();
        order.Header = new SendOrder.Header();
        order.OrderedBy = new SendOrder.OrderedBy();
        order.ShipTo= new SendOrder.ShipTo();
        order.ShipTo.OrderShipTo = new SendOrder.OrderShipTo();
        order.Offers = new SendOrder.Offers();
        order.Offers.OfferOrdered = new SendOrder.OfferOrdered();
        order.Offers.OfferOrdered.Offer = new SendOrder.Offer();
        order.Offers.OfferOrdered.Offer.Header = new SendOrder.OfferHeader();
        
        order.Offers.OfferOrdered.OrderShipToKey = new SendOrder.OrderShipToKey();
        Request__c Request = new Request__c();
        Request_Item__c RequestItem = new Request_Item__c();
        
        order.Header.ID = Request.Name;
        order.Header.EntryDate = system.today();
        order.Header.ReferenceNumber = Request.Name;
        order.Header.Comments = Request.Comments__c;
        order.Header.InsertDate = system.today();
        
        
        
        order.OrderedBy.FirstName = Request.CreatedBy.FirstName;  
        
        order.OrderedBy.LastName = Request.CreatedBy.LastName; 
        
         
         
        order.OrderedBy.CompanyName = 'Dupont';
        order.OrderedBy.Address1 = Request.CreatedBy.Street;
        order.OrderedBy.Address2 = Request.CreatedBy.Street;
        order.OrderedBy.Address3 = Request.CreatedBy.Street;
        order.OrderedBy.City = Request.CreatedBy.City;
        order.OrderedBy.State = Request.CreatedBy.State;
        order.OrderedBy.PostalCode = Request.CreatedBy.PostalCode;
        order.OrderedBy.Country = Request.CreatedBy.Country;
        order.OrderedBy.Phone = Request.CreatedBy.Phone;
        order.OrderedBy.Email = Request.CreatedBy.Email;
        order.OrderedBy.UID = Request.CreatedBy.FirstName;
        order.OrderedBy.TaxExempt = false;
        order.OrderedBy.TaxExemptApproved = false;
        order.OrderedBy.TaxExemptApproved = false;
        order.OrderedBy.Commercial = false;
        
        order.ShipTo.OrderShipTo.TaxExempt = false;
        order.ShipTo.OrderShipTo.TaxExempt = false;
        order.ShipTo.OrderShipTo.TaxExemptApproved = false;
        order.ShipTo.OrderShipTo.Commercial = false;
        order.ShipTo.OrderShipTo.Flag = 'Other'; 
        order.ShipTo.OrderShipTo.Key = 0;
        if(Request.Priority__c == 'Rush'){
            order.ShipTo.OrderShipTo.Rush = True ;
        }else{
            order.ShipTo.OrderShipTo.Rush = false ;
        }
        order.ShipTo.OrderShipTo.Comments = Request.Instructions__c;
        order.ShipTo.OrderShipTo.FreightCode = null; 
        string[] splitted1 = Request.Send_to_Contact__c.split(' ');
        order.BillTo.FirstName = splitted1[0];  
        if(splitted1[1]!=null){
        	order.BillTo.LastName = splitted1[1]; 
        }
        order.BillTo.CompanyName = Request.Send_to_Company__c;
        order.BillTo.Address1 = Request.Request_Shipping_Street__c;
        order.BillTo.Address2 = Request.Request_Shipping_Street__c;
        order.BillTo.Address3 = Request.Request_Shipping_Street__c;
        order.BillTo.City = Request.Request_Shipping_City__c;
        order.BillTo.State = Request.Request_Shipping_State__c;
        order.BillTo.PostalCode = Request.Request_Shipping_Postal_Code__c;
        order.BillTo.Country = Request.Request_Shipping_Country__c;
        order.BillTo.Phone = Request.Phone__c;
        order.BillTo.TaxExempt = false;
        order.BillTo.TaxExemptApproved = false;
        order.BillTo.Commercial = false;
        
        order.Offers.OfferOrdered.Offer.Header.ID = RequestItem.Catalog_Item__r.Name;
        order.Offers.OfferOrdered.Quantity = RequestItem.Quantity__c;
        order.Offers.OfferOrdered.OrderShipToKey.Key = 0;
    }   
}