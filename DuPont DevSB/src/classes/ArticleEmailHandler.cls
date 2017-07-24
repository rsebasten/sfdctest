global class ArticleEmailHandler implements Messaging.InboundEmailHandler {

  global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, 
                                                         Messaging.InboundEnvelope envelope) {
    Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
    String messageBody  = '';
    String articleType  = '';
    String articleId    = '';  
    String requestType  = '';
    
    result.success = true;        
    messageBody = email.plainTextBody;
    //messageBody = messageBody.trim();
    system.debug('Message Body: ' + messageBody);
    
    //Mesage body is of the format
    //<article>
    //  <RequestType>PublishInternal</RequestType> (Optional)
    //  <ArticleType>ArticleType2</ArticleType>
    //  <ArticleId>ka1d00000000N9o</ArticleId>
    //</article>
    
    articleType = readXMLelement(messageBody,'ArticleType');
    articleId  = readXMLelement(messageBody,'ArticleId');
    requestType = readXMLelement(messageBody,'RequestType');    
    
    if (requestType == 'PublishInternal' && (articleType == 'Solution' || articleType == 'FAQ' || articleType == 'Error_Message')) {
        //Call Article utility class (supports PublishInternal method)
        //ArticleUtils.publishInternal(articleType, articleId);    
    } else {
        //Call the method to verify if article is categorized, if not set it to default category
        //ArticleCategoryCheck.VerifyDataCategory(articleType, articleId);
    }
    return result;
  }
  
  public static String readXMLelement(String xml, String element)
  {
    String elementValue = 'NOT FOUND'; 
        
    try
    {
      Xmlstreamreader reader = new Xmlstreamreader(xml);
      while (reader.hasNext()) 
      {
        if (reader.getEventType() == XmlTag.START_ELEMENT && reader.getLocalName() == element)
        {
                      System.debug('Found element ' + element);
                      reader.next();
                      elementValue = reader.getText();
        }         
        reader.next();
      }
      return elementValue;
    }
    catch(exception e)
    {
      string err;
      err = e.getTypeName() + '\n' + e.getCause() + '\n' + e.getMessage() + '\n' + xml;
      return err;
    }
  }  
}