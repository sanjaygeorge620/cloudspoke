global class attachment_Order implements Messaging.InboundEmailHandler 
{
 
  global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,
    Messaging.InboundEnvelope envelope) 
    {
 
    Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
     
    if(email.Subject != null || email.Subject!= '')
    {
    system.debug('---------------------------' +email.plainTextBody);
    

    string str = email.Subject;
    str = str.Trim();
    system.debug('ZZZZZZZZZZZZZZZZZZZZZZ'+str);   
    system.debug('ZZZZZZZZZZZZZZZZZZZZZZ'+email.references);
    string ordid = str.substring(str.lastIndexOf('[REF:__')+7,str.lastIndexOf('[REF:__')+22);
    string refid = str.substring(str.lastIndexOf('[REF:__'),str.lastIndexOf('__]'));    
    ID orderid = ID.valueof(ordid);
    system.debug('ZZZZZZZZZZZZZZZZZZZZZZ'+orderid);    
    system.debug('ZZZZZZZZZZZZZZZZZZZZZZ'+refid);   
    String newSearchText = '%'+refid+'%';
    List<Task> tsklist = [select id,subject from task where whatid =: orderid and subject like: newSearchText order by createddate desc];
    
    if(!tsklist.isEmpty())
    { 
    if (email.binaryAttachments != null && email.binaryAttachments.size() > 0) 
    {
      for (integer i = 0 ; i < email.binaryAttachments.size() ; i++) 
      {
        Attachment attachment = new Attachment();
        // attach to the newly created contact record
        attachment.ParentId = tsklist[0].id;
        attachment.Name = email.binaryAttachments[i].filename;
        attachment.Body = email.binaryAttachments[i].body;
        insert attachment;
      }
    }
       if (email.textAttachments!= null && email.textAttachments.size() > 0) 
    {
      for (integer i = 0 ; i < email.textAttachments.size() ; i++) 
      {
        Attachment attachment = new Attachment();
        // attach to the newly created contact record
        attachment.ParentId = tsklist[0].id;
        attachment.Name = email.textAttachments[i].filename;
        string body = email.textAttachments[i].body;
        attachment.Body = Blob.valueof(body);
        insert attachment;
      }
    }
    }
    }
 
    return result; 
  }
  
  
}