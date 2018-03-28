/*******************************************************************************
Copyright © 2015 DuPont. All rights reserved. 
Author: Rajiv Kumar Bhatter
Email: Rajiv_Bhatter@infosys.com
Description:Controller for page BPDHitExtSystem for getting the search string
and searching the domaintools API for search string
 *****************************************************************************/
public class ctrlBPDHitExtSystem{
public Case cas {get; set;}
public Case_Details__c detail{get; set; }
public Case_Details__c updateBlankDetail{get; set; }
public String whoisString {get; set;}
public String firstPart {get; set;}
public String secondPart {get; set;}
public string thirdPart {get; set;}
public string fourthPart {get; set;}
public string singlepart {get; set;}
//public Domain_Tool__c dt {get; set;}
string whoIs;
public Boolean check {get; set;}
public Boolean flag {get; set;}

Integer firstIndex = 0;
private String retURL {get;set;}

public ctrlBPDHitExtSystem(ApexPages.StandardController controller){
detail =new Case_Details__c();
updateBlankDetail=new Case_Details__c();
//dt= new Domain_Tool__c();
cas=(Case)controller.getRecord();

 retURL= System.currentPageReference().getParameters().get('id');
 whoisString = System.currentPageReference().getParameters().get('searchtxt');
 if(whoisString !=''){
 detail = [SELECT Id,WhoIs_Details__c,Registry_Registrant_Details__c,Registry_Tech_Details__c,Registry_Admin_Details__c  from Case_Details__c where Related_Case__c=:retURL limit 1];
 }

    cas=new Case();
    if(whoisString!='')
    hitTheServer();
}
public void hitTheServer() {
try{
check=true;
system.debug('hitttttttttt'+whoisString);
HttpRequest req = new HttpRequest();
Http h = new Http();
req.setEndpoint ('http://api.domaintools.com/v1/' + whoisString  + '/whois' + '?api_username=DuPDTapi&api_key=8aba9-2787e-ac902-3cbe7-60b79');
req.setMethod ('POST');
req.setBody('dfgfdgf');
 HttpResponse res = h.send(req);
System.debug('resonse is=='+res.getbody());
cas.Description=res.getbody();

    JSON2Apex parsedResponse= new JSON2Apex(System.JSON.createParser(cas.Description));
    system.debug('parsedResponse'+parsedResponse+''+parsedResponse.response.whois.record);
   
    whoIs = parsedResponse.response.whois.record;
   system.debug('whoisssssssssssss'+whois);
   singlepart= whoIs;
    system.debug('where r we'+singlepart);
    firstPart = breakResponse('Registry Registrant ID', firstIndex);
    secondPart = breakResponse('Registry Admin ID', firstIndex);
    thirdPart = breakResponse('Registry Tech ID', firstIndex);
    fourthPart = whoIs.substring(firstIndex, whoIs.length());
    
    //system.debug('//////////////////////////'+script2.getQuestion('Registry Admin ID').answer);
    if(firstPart.length()>0){
    flag=false;
    detail.WhoIs_Details__c=firstPart;
    }
    else
    {
    flag=true;
    detail.WhoIs_Details__c=singlepart;
    }
    detail.Registry_Registrant_Details__c=secondPart;
    detail.Registry_Admin_Details__c=thirdPart;
    if(detail.WhoIs_Details__c.contains(singlepart)){
    flag=true;
    detail.Registry_Tech_Details__c=null;
    }
    else{
    flag=false;
    detail.Registry_Tech_Details__c=fourthPart;
    }
    }
    catch(Exception e){
        check=false;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please ensure the domain name entered is valid and check the spelling of the text entered. Please contact Sonja Wood for further questions.'));
    }
}
    private String breakResponse(string breakText, Integer indexOne){
        if(whois.contains(breakText)){
        flag=false;
        Integer IndexTwo = whoIs.indexOf(breakText);
        firstIndex = IndexTwo;
        return whoIs.substring(indexOne, IndexTwo);
        }
        else{
        flag=true;
        return '';
        }
    }
 public Pagereference doSave(){
    if(whoisstring!='' && whoisString!=null){
    if(detail.WhoIs_Details__c.contains(singlepart)){  
    detail.WhoIs_Details__c=singlepart;
    detail.Registry_Registrant_Details__c='';
    detail.Registry_Admin_Details__c='';
    detail.Registry_Tech_Details__c=''; 
    }
    else{
    detail.WhoIs_Details__c=firstPart;
    detail.Registry_Registrant_Details__c=secondPart;
    detail.Registry_Admin_Details__c=thirdPart;
    detail.Registry_Tech_Details__c=fourthPart;
    }
    update detail;
    }
    else{
    updateBlankDetail=[SELECT Id,WhoIs_Details__c,Registry_Registrant_Details__c,Registry_Tech_Details__c,Registry_Admin_Details__c  from Case_Details__c where Related_Case__c=:retURL limit 1];
    updateBlankDetail.WhoIs_Details__c='';
    updateBlankDetail.Registry_Registrant_Details__c='';
    updateBlankDetail.Registry_Admin_Details__c='';
    updateBlankDetail.Registry_Tech_Details__c='';
    update updateBlankDetail; 
    }
    PageReference pageRef = new PageReference('/'+retURL);
    pageRef.setRedirect(true);
    return pageRef;
    
    }
}