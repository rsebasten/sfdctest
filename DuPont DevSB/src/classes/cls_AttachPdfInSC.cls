/*******************************************************************************
Copyright © 2016 DuPont. All rights reserved.
Author: Santosh Kumar.
Email: kumar.santosh32@tcs.com
Description:  Asynchronous class for inserting attachment in Recent Search records.
Created Date: 9/28/2016.
Version: 1.0
********************************************************************************/

public class cls_AttachPdfInSC{

    @future(callout=true)
    public static void attachPdf(String idStr){

        PageReference pdf = Page.Design_Alternatives;      
        pdf.getParameters().put('Id', idStr);

        System.debug('Id------------' + pdf);

        Attachment attach = new Attachment();
        Blob body;
        try{            
            try 
            {
                body = pdf.getContent();
            }
            catch (VisualforceException e) 
            {
                body = blob.valueof('TEST');
            } 
            attach.Body = body;     
            attach.Name = 'Search_Criteria_' + Datetime.now().format('yyyy-MM-dd_HH:mm:ss.SSS_z') + '.pdf';      
            attach.ParentId = idStr;

            insert attach;
        }
        catch (Exception e) 
        {
            System.debug('Error in Pdf generation' + e.getMessage() + ' Line:' + e.getLineNumber() + ' Cause:' + e.getCause() + ' StackTrace:' + e.getStackTraceString());
        }    

    } 

}