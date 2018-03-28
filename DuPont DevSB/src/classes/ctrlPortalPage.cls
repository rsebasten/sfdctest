public with sharing class ctrlPortalPage{

public virtual class HTMLContent{
    public String content {
        get {return content;}
        set {content = value;}
    }
}

public HTMLContent homepage;
public HTMLContent page;
public String portalname;

private HTMLContent retrieveHTML(String pagename){
    HTMLContent hc = new HTMLContent();
    hc.content='';
    String pagetoken;
    String hometoken;
    pagetoken='"' + getPortalName() + '_PortalPage?p=';
    hometoken='"' + getPortalName() + '_PortalHome';
    List<PortalHTML__c>pc=[SELECT HTML__c FROM PortalHTML__c WHERE PortalHTML__c.Name= :pagename AND Portal__c=:getPortalName()];
    if (!pc.isEmpty()){
        hc.content=pc[0].HTML__c;
    }
    else{
        List<PortalHTML__c>nf=[SELECT HTML__c FROM PortalHTML__c WHERE PortalHTML__c.Name='notfound.html' AND Portal__c=:getPortalName()];
        if (!nf.isEmpty()){
            hc.content=nf[0].HTML__c;
        }
    }
    hc.content=hc.content.replaceAll('&lt;','<');
    hc.content=hc.content.replaceAll('&gt;','>');
    hc.content=hc.content.replaceAll('&quot;','"');
    hc.content=hc.content.replaceAll('&amp;','&');
    hc.content=hc.content.replaceAll('"/pages/home.html',hometoken);
    hc.content=hc.content.replaceAll('"/pages/',pagetoken);
    hc.content=replaceHTMLReferences(hc.content,'"/images/','/sfc/servlet.shepherd/document/download/');
    hc.content=replaceHTMLReferences(hc.content,'"/files/','/sfc/servlet.shepherd/document/download/');
    return hc;
}

public HTMLContent getPage(){
    HTMLContent hc = new HTMLContent();
    hc=retrieveHTML(ApexPages.currentPage().getParameters().get('p'));
    return hc;
}

private String replaceHTMLReferences(String htmltext,String token,String prefix)
{
    String front='';
    String back='';
    integer pointer;
    String originalreference='';
    while (htmltext.indexof(token)>0)
    {
        originalreference='';
        pointer=htmltext.indexof(token);
        front=htmltext.substring(0,pointer+1);
        pointer=pointer+token.length();
        while (htmltext.substring(pointer,pointer+1)!='"'){
            originalreference=originalreference+htmltext.substring(pointer,pointer+1);
            pointer=pointer+1;
        }
        originalreference=originalreference.replace(token.replace('"',''),'');
        back=htmltext.substring(pointer,htmltext.length());
        htmltext=front+prefix+lookupContentID(originalreference)+back;
    }
    return htmltext;
}

private String lookupContentID(String title)
{
    String id;
    ContentVersion[] cv=[SELECT contentdocumentid FROM ContentVersion WHERE title= :title];
    if (!cv.isEmpty()){
        id=cv[0].contentdocumentid;
    }
    else{
        id='404';
    }
       
    return id;
}

public HTMLContent getHomePage(){
    HTMLContent hc = new HTMLContent();
    hc=retrieveHTML('home.html');
    return hc;
}

private String getPortalName(){
    String url='';
    String portalname='';
    url=ApexPages.currentPage().getURL();
    if (url!=null)
    {
        url=url.substring(url.indexOf('apex/')+5);
        if(url.contains('_PortalPage')) { portalname=url.substring(0,url.indexOf('_PortalPage')); }
        if(url.contains('_PortalHome')) { portalname=url.substring(0,url.indexOf('_PortalHome')); }
    }
    return portalname;
}

public static testMethod void testPortalPageController(){
    ctrlPortalPage ppc = new ctrlPortalPage();
    
    HTMLContent html = new HTMLContent();
    html.content='test';
    System.assertEquals(html.content,'test');
    
    String pn=ppc.getPortalName();
    System.assertEquals(pn,'');
    
    String test_html='<a href="/files/test.pdf">test</a>';
    String test_token='"/files/';
    String test_prefix='/test/';
    String test_modifiedhtml;
    test_modifiedhtml=ppc.replaceHTMLReferences(test_html,test_token,test_prefix);
    System.assertEquals(test_modifiedhtml,'<a href="/test/404">test</a>');
    
    ppc.getHomePage();
    ppc.getPage();
}

}