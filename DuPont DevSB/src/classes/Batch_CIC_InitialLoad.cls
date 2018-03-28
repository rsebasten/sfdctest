/*************************************************************************************************
Copyright © 2016 DuPont. All rights reserved. 
Authors:        Vijay Laxmi
Email:          vijay.laxmi1@tcs.com
Date:           10/21/2016
Description:    Class to read xml file with batch size 1 from Document to Load CIC Project Data (one time activity)

<AS20161116>
Modified By: Arjun Sharma
Modification Date: 16-Nov-2016
Modification: batch size is added for batch processing
***************************************************************************************************/
global class Batch_CIC_InitialLoad implements Database.Batchable<sObject> 
{
    public static final Integer batchJobSize = Integer.valueOf(Label.CIC_Batch_Size);//<AS20161116>
    //We are fetching the CIC End Point URL from Custom MetaData Type
    public Database.QueryLocator start(Database.BatchableContext BC)
    {
        String foldername='CIC';
        String query= 'select id,name,body from document WHERE Folder.Name=:foldername ';
        return Database.getQueryLocator(query);
    }
    // We are sending the URL with size 1 in class "cicRestClass" to parse the XML
    public void execute(Database.BatchableContext info, List<Document> docnameList)
    {
        try
		{
		ctrlCIC_Parse.cic_related_Lead=true;
        String docname= docnameList[0].body.toString();
        ctrlCIC_Parse.parseResponseDom(docname);
		}
		catch(exception e)
		{
			system.debug('>>>EXception>>>>>>>'+e);
            system.debug('>>>document name >>>>>>>'+docnameList[0].name);
			ExceptionHandlingClass_CIC_CP.autoCreatedpsException_xml(e,'Upload Via Documents',docnameList[0].name,'CIC');  
		}
    }
    // Calling another batch "batch_CIC_EIUpdate" to update ExternalInitiativeParent for Project Level "Sub" on External Initiative
    public void finish(Database.BatchableContext info) 
    {
        Database.executeBatch(new batch_CIC_EIUpdate(),batchJobSize);//<AS20161116>
    }   
}