/*************************************************************************************************
Copyright © 2013 DuPont. All rights reserved. 
Authors:        Vijay Laxmi
Email:          vijay.laxmi1@tcs.com
Description:    Upsert new External Initiative in SFDC to update the status of project after reading xml for CIC Project 
                For Initial Load reading the xml file from Document by creating a folder name as CIC_Expire_Project
                For Daily basis fetching the URL from custom setting "DPS_CIC_Expire_Project_End_Point__c" 
Date:           12-Dec-2017
***************************************************************************************************/
public class ctrlCICExpireProject_Parse
{  
    
    static Map<String,string> mapExtInitiative = new Map<String,string>();
    public void parseCICExpireXML(DPS_CIC_Expire_Project_End_Point__c urlPass) 
    {
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        req.setEndpoint(urlPass.CIC_Expire_Project_End_Point__c);
        req.setMethod('GET');
        transient string userName = system.label.CIC_UserName;
        transient  string password =system.label.CIC_Password;      
        transient Blob headerValue = Blob.valueOf(userName + ':' + password);
        transient String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue); 
        req.setHeader('Authorization', authorizationHeader); 
        req.setHeader('Accept','application/xml');
        try 
        {
           
        
            res = http.send(req); 
             if(res.getstatusCode()==200) 
             {
                    ctrlCICExpireProject_Parse.parseResponseDom(res.getBody());
             }
             else 
              {
               
              system.debug(LoggingLevel.error,'############## Parser Issue userName + password  '+ userName+password); 
              String URL = ''+urlPass;
              String URLstatus = res.getStatusCode()+res.getStatus();
              system.debug(LoggingLevel.error,'$$$$$$$$ Parser Issue  URLstatus  & URL'+ URLstatus +req);
             ExceptionHandlingClass_CIC_CP.autoCreatedpsException_SchJob_xml(URLstatus,'External_Initiative',URL,'CIC');
            }
           
        }
        catch(Exception e) {
                         system.debug(LoggingLevel.error,'############## Parser Issue'+ e);  
                        ExceptionHandlingClass_CIC_CP.autoCreatedpsException(e,'External_Initiative','CIC Issue');
        }  
    }
    // Method to read XML and Upsert ExternalInitiative Records
    public static void parseResponseDom(String xmltoParse)
    {
        transient  set<string> setExternalId = new set<string>(); 
        Dom.Document xmlDOC = new Dom.Document();
        xmlDOC.load(xmltoParse);
        //Retrieve the root element for ExternalInitiative
        Dom.XMLNode projects = xmlDOC.getRootElement();
        transient List<External_Initiative__c> externalInitiativeList = new List<External_Initiative__c>();
        if(projects.getChildElements()!=null)
        {
            for(Dom.XMLNode project : projects.getChildElements()) 
            {
                External_Initiative__c ei = new External_Initiative__c();  
                if(project.getChildElements()!=null)
                {
                    for(Dom.XMLNode externalInitiative_Element : project.getChildElements()) 
                    {   
                            
                        if(externalInitiative_Element.getName()=='ID') 
                        ei.External_ID__c =externalInitiative_Element.getText();          
                        else if(externalInitiative_Element.getName()=='ProjectStage')      
                        ei.Stage__c =externalInitiative_Element.getText(); 
                        else if(externalInitiative_Element.getName()=='ProjectLevel')    
                        ei.Project_Level__c=externalInitiative_Element.getText();       
                        
                        if(ei.External_ID__c!=null && (ei.Project_Level__c=='Parent' || ei.Project_Level__c=='Sub'))
                        {
                            
                            setExternalId.add(ei.External_ID__c);
                            externalInitiativeList.add(ei);
                            mapExtInitiative.put(ei.External_ID__c,ei.Stage__c);
                        }  
                    }
                }  
            } 
        }
        system.debug(LoggingLevel.error,'############## EI mapExtInitiative'+ mapExtInitiative);
        List<External_Initiative__c> lstexistEIrecords = [select id,Stage__c,External_ID__c from External_Initiative__c where External_ID__c in:setExternalId  ];
        List<External_Initiative__c> lstext = new List<External_Initiative__c>();
        try
        {
            if(lstexistEIrecords != null && lstexistEIrecords.size()>0)
            {
            
                for( External_Initiative__c extInitiative : lstexistEIrecords )
                {
                    External_Initiative__c  extInit = new External_Initiative__c(); 
                    if(mapExtInitiative.containskey(extInitiative.External_ID__c))
                    extInit.id=extInitiative.id;
                    extInit.Stage__c=mapExtInitiative.get(extInitiative.External_ID__c); 
                    lstext.add(extInit); 
                }
             }   
              system.debug(LoggingLevel.error,'############## update EI List'+ lstext);  
              if(lstext!= null && lstext.size()>0)
            {  
                update lstext;                     
            }
        }
         catch(Exception e)
        {
            ExceptionHandlingClass_CIC_CP.autoCreatedpsException(e,'External_Initiative','CIC');
        } 
    }       
}