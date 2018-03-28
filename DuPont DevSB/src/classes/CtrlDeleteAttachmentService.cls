/*******************************************************************************
(C)2016
Author: Pallavi Sharma
Email: pallavi.sharma3@tcs.com
Description:  This class will delete the attachments
 ********************************************************************************/

@RestResource(urlMapping='/DeleteAttachment/*')
global class CtrlDeleteAttachmentService{

    @HttpPost
    global static CtrlKevlarSvcHelper.ReturnAttachmentClass doPost(){
        CtrlKevlarSvcHelper h = new CtrlKevlarSvcHelper();
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
 
        JSONGenerator gen = JSON.createGenerator(true);
        try{
            system.debug('req.requestBody : ' + req.requestBody.toString());
            DeleteAttachmentWrapper tWrap= (DeleteAttachmentWrapper) JSON.deserialize(req.requestBody.toString(), DeleteAttachmentWrapper.class);
            List<Attachment> attachList = new List<Attachment>();
            attachList=[SELECT Id from Attachment where Id IN: tWrap.fileIds];
            if(attachList.size()>0){
                delete attachList;
            }
            return new CtrlKevlarSvcHelper.ReturnAttachmentClass(h.dataSent, h.getMessage('200'),h.getResponseMessage('543'),'543', null, null, 'No Error');  
        }
        catch(Exception e){
            System.debug('Error----------'+e.getMessage());
            return new CtrlKevlarSvcHelper.ReturnAttachmentClass(h.dataNotSent, h.getMessage('203'),'Delete operation failed!',null, null, null, '203');
        }  
    }  
  
    public class DeleteAttachmentWrapper{
        public List<String> fileIds;
    }
}