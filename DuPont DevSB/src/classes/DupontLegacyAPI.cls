/*------------------------------------------------------------
Name:           DupontLegacyAPI
Author:         S Rambabu (Perficient)
Company:        Dupont
Description:    DupontLegacyAPI class contains send method which performs web service callout and returns HttpResponse
History:
02/02/2017      S Rambabu (Perficient)  Initial version.
------------------------------------------------------------*/
@RestResource(urlMapping='/LegacyAPI/*')
global with sharing class DupontLegacyAPI {
    @HttpGet
    global static List<HistoryInterface> getHistory() {
        String tableName = RestContext.request.params.get('tableName');
        String parentId = RestContext.request.params.get('parentId');
        String uri ='https://dps-prod-history.herokuapp.com/legacyapi/'+tableName+'/'+parentId;
        HttpResponse response =send(uri,'GET');
        if(tableName=='OpportunityHistory'){
            return LegacyOpportunityHistory.parse(response.getBody());
        }else{
            return LegacyHistory.parse(response.getBody());
        }
    }
    
    private static HttpResponse send(String uri, String httpMethod) {
        
        Http        h       = new Http();
        HttpRequest hRqst   = new HttpRequest();
        hRqst.setEndpoint(uri);                     // caller provides, this will be a REST resource
        hRqst.setMethod(httpMethod);                // caller provides
        hRqst.setTimeout(6000); 
        String accessToken=null;
        if (accessToken != null)   {            // REST requires using the token, once obtained for each request
            hRqst.setHeader('Authorization','Bearer ' + accessToken);
            hRqst.setHeader('Content-Type', 'application/json');
        }
        return h.send(hRqst);                   // make the callout
    }
}