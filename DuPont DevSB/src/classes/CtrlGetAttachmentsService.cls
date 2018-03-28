/*******************************************************************************
(C)2016
Author: pallavi sharma
Email: pallavi.sharma3@tcs.com
Description:  This class for populate the Attachments.
 ********************************************************************************/

@RestResource(urlMapping='/GetAttachment/*')
global class CtrlGetAttachmentsService{

    @HttpPost
    global static CtrlKevlarSvcHelper.ReturnAttachmentClass doPost(){
        CtrlKevlarSvcHelper h = new CtrlKevlarSvcHelper();
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        String prettyJSON = '';
        JSONGenerator gen = JSON.createGenerator(true);
        try{
            system.debug('req.requestBody : ' + req.requestBody.toString());
            FileAttachmentWrapper aWrap= (FileAttachmentWrapper) JSON.deserialize(req.requestBody.toString(), FileAttachmentWrapper.class);
            String query='SELECT Id,Name from Attachment where parentId='+ '\'' + aWrap.bacConfigurationID + '\'';
            query=query+' AND Description LIKE ' + '\'' +'%'+aWrap.description+'%' + '\'';
            if(!aWrap.description.equalsIgnoreCase('supportingdocs')){
               query=query + ' Order By CreatedDate DESC Limit 1'; 
            }
            system.debug('query : ' + query);
            List<Attachment> attachList = database.query(query);
            if(!attachList.isEmpty()){  
                gen.writeStartObject();//json starts
                    gen.writeStringField('bacConfigurationID', aWrap.bacConfigurationID);
                    gen.writeFieldName('attachments');
                        gen.writeStartArray();//attachment array starts
                            for(Attachment a:attachList){ 
                                    gen.writeStartObject(); 
                                        gen.writeStringField('fileName', a.name);
                                        gen.writeStringField('fileId', a.Id);
                                    gen.writeEndObject();  
                            }
                    gen.writeEndArray();//attachment array ends
                gen.writeEndObject();//json ends  
                prettyJSON=gen.getAsString();
                 system.debug('@@@@@prettyJSON : ' + prettyJSON);
                return new CtrlKevlarSvcHelper.ReturnAttachmentClass(h.dataSent, h.getMessage('200'),h.getResponseMessage('527'),'527', prettyJSON, null, 'No Error');
            }  
            else{
                return new CtrlKevlarSvcHelper.ReturnAttachmentClass(h.dataNotSent, h.getMessage('201'),null,null, null, null, '201');
            }   
        }
        catch(Exception e){
            System.debug('Error----------'+e.getMessage());
            return new CtrlKevlarSvcHelper.ReturnAttachmentClass(h.dataNotSent, h.getMessage('203'),'Data loading failed!',null, null, null, '203');
        }   
    }  
      
    public class FileAttachmentWrapper{
        public String bacConfigurationID; 
        Public String description;
    }
}