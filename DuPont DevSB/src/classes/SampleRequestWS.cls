public class SampleRequestWS {
    @InvocableMethod(label='Call WS' description='Call Donelly Web Service')
    public static void callWS(List<Id> reqIds) {
        for (Id reqId : reqIds) {
            System.debug('Call with ' + reqId);
            wsCallout(reqId);
        }
    }
    
    @future(callout=true)
    public static void wsCallout(string recordId){
        Organization org = [SELECT InstanceName, IsSandbox FROM Organization];
        String instanceName;
        if(org.IsSandbox){
            instanceName = 'Test';
        }else{
            instanceName = 'Prod';
        }
        SampleRequestWSInfo__mdt wsInfo = [SELECT URL__c, UserName__c, Password__c, Debug__c
                       FROM SampleRequestWSInfo__mdt 
                       WHERE Label = :instanceName];

        Request__c request = [select Name,Comments__c,CreatedBy.FirstName,CreatedBy.LastName,CreatedBy.Street,CreatedBy.City,
                              CreatedBy.State,CreatedBy.PostalCode,CreatedBy.Country,CreatedBy.Phone,CreatedBy.Email,
                              Priority__c,Instructions__c,Send_to_Contact__c,Send_to_Company__c,Request_Shipping_Street__c,
                              Request_Shipping_City__c,Request_Shipping_State__c,Request_Shipping_Postal_Code__c,
                              Request_Shipping_Country__c,Phone__c,Status__c,Stage_Reason__c,
                              (select Catalog_Item__r.Name,Quantity__c from Items__r)  
                              from Request__c where id=:recordId ];
        String body;
        body  = '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns="http://sma-promail/">';
        body += '   <soap:Header>';
        body += '       <AuthenticationHeader>';
        body += '           <Username>' + wsInfo.UserName__c + '</Username>';
        body += '           <Password>' + wsInfo.Password__c + '</Password>';
        /*body += '         <Username>DDFNOW</Username>';
        body += '           <Password>WonfdD</Password>';*/
        body += '       </AuthenticationHeader>';
        body += '       <DebugHeader>';
        if (wsInfo.debug__c)
            body += '           <Debug>true</Debug>';
        else
            body += '           <Debug>false</Debug>';
        body += '       </DebugHeader>';
        body += '   </soap:Header>';
        body += '   <soap:Body>';
        body += '       <AddOrder>';
        body += '           <order>';
        body += '               <Header>';
        body += '                   <ID>' + Request.Name + '</ID>';
        body += '                   <EntryDate>' + system.now().format('yyyy-MM-dd\'T\'HH:mm:ss') + '</EntryDate>';
        body += '                   <Comments>' + Request.Comments__c + '</Comments>';
        body += '                   <ReferenceNumber>' + Request.Name + '</ReferenceNumber>';
        body += '               </Header>';
        body += '               <Classification/>';
        body += '                   <OrderedBy>';
        body += '                       <CompanyName>DuPont</CompanyName>';
        body += '                       <FirstName>' + Request.CreatedBy.FirstName +'</FirstName>';
        body += '                       <LastName>' + Request.CreatedBy.LastName + '</LastName>';
        body += '                       <Address1>' + Request.CreatedBy.Street + '</Address1>';
        body += '                       <Address2/>';
        body += '                       <City>' + Request.CreatedBy.City + '</City>';
        body += '                       <State>' + Request.CreatedBy.State + '</State>';
        body += '                       <PostalCode>' + Request.CreatedBy.PostalCode + '</PostalCode>';
        body += '                       <Country>' + Request.CreatedBy.Country + '</Country>';
        body += '                       <Phone>' + Request.CreatedBy.Phone + '</Phone>';
        body += '                       <Email>' + Request.CreatedBy.Email + '</Email>';
        body += '                   </OrderedBy>';
        body += '                   <ShipTo>';
        body += '                       <OrderShipTo>';
        body += '                           <CompanyName>' + Request.Send_to_Company__c + '</CompanyName>';
        string[] splitted = Request.Send_to_Contact__c.split(' ');
        if(splitted.size()==2){
        body += '                           <FirstName>' + splitted[0] + '</FirstName>';
        body += '                           <LastName>' + splitted[1] + '</LastName>';
        } else {
        body += '                           <FirstName></FirstName>';
        body += '                           <LastName>' + splitted[0] + '</LastName>';
        }
        body += '                           <Address1>' + Request.Request_Shipping_Street__c + '</Address1>';
        body += '                           <Address2/>';
        body += '                           <City>' + Request.Request_Shipping_City__c + '</City>';
        body += '                           <State>' + Request.Request_Shipping_State__c + '</State>';
        body += '                           <PostalCode>' + Request.Request_Shipping_Postal_Code__c + '</PostalCode>';
        body += '                           <Country>' + Request.Request_Shipping_Country__c + '</Country>';
        body += '                           <Phone>' + Request.Phone__c + '</Phone>';
        body += '                           <TaxExempt>false</TaxExempt>';
        body += '                           <TaxExemptApproved>false</TaxExemptApproved>';
        body += '                           <Commercial>false</Commercial>';
        body += '                           <Flag>Other</Flag>';
        if (Request.Priority__c == 'Rush') {
        body += '                           <Rush>true</Rush>';
        }
        body += '                           <Comments>' + Request.Instructions__c + '</Comments>';
        body += '                           <Key>0</Key>';
        body += '                           <FreightCode/>';
        body += '                       </OrderShipTo>';
        body += '                   </ShipTo>';
        body += '                   <BillTo>';
        body += '                       <TaxExempt>false</TaxExempt>';
        body += '                       <TaxExemptApproved>false</TaxExemptApproved>';
        body += '                       <Commercial>false</Commercial>';
        body += '                       <Flag>OrderedBy</Flag>';
        body += '                   </BillTo>';
        body += '                   <Offers>';
        for(Request_Item__c ri: request.Items__r){
        body += '                       <OfferOrdered>';
        body += '                           <Offer>';
        body += '                               <Header>';
        body += '                                   <ID>' + ri.Catalog_Item__r.Name + '</ID>';
        body += '                               </Header>';
        body += '                           </Offer>';
        body += '                           <Quantity>' + ri.Quantity__c + '</Quantity>';
        body += '                           <OrderShipToKey>';
        body += '                               <Key>0</Key>';
        body += '                           </OrderShipToKey>';
        body += '                       </OfferOrdered>';
        }
        body += '                   </Offers>';
        body += '           </order>';
        body += '       </AddOrder>';
        body += '   </soap:Body>';
        body += '</soap:Envelope>';
        HttpRequest req = new HttpRequest();
        req.setEndpoint(wsInfo.URL__c);
        System.debug('Endpoint ' + req.getEndpoint());
        req.setMethod('GET');
        req.setBody(body);
        req.setHeader('Content-Type', 'text/xml');
        Http http = new Http();
        HttpResponse res = http.send(req);
        if (res.getStatusCode() != 200) {
            request.Status__c = 'Error: Rejected by Supplier';
            request.Stage_Reason__c = res.getBody();
        }
        else {
            request.Status__c = 'Accepted by Supplier';
        }
        update request;
        System.debug('Request response code:'+res.getStatusCode());        
        System.debug('Request response body:'+res.getBody());        
    }
}