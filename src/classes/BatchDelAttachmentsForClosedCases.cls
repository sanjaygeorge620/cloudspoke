/*************************************************************************
Name : BatchDeleteAttachmentsForClosedCases
Author : Reena Acharya
Date : Jan 7, 2013
Description : 
**************************************************************************/
global class BatchDelAttachmentsForClosedCases implements Database.Batchable<SObject>{
    public String query;
    global List<CaseRecordTypesToDeleteAttachments__c> recordTypeList;
    public Set<String> recordTypeOfCase = new Set<String>();
    final String TIME_PART = 'T00:00:00Z';
    global BatchDelAttachmentsForClosedCases() {        
        
        
        recordTypeList = [Select Name from CaseRecordTypesToDeleteAttachments__c];

        
        
        for(CaseRecordTypesToDeleteAttachments__c caseRecType: recordTypeList){
            recordTypeOfCase.add(caseRecType.Name);
        }
        Date tenDausOld = system.today().addDays(-10);
        //for testing 
        //Date tenDausOld = system.today().addDays(-2);
        string tendays = String.valueOf(tenDausOld) + TIME_PART;
         query = 'Select Id,RecordType.Name,(Select Id From Attachments) from Case where RecordType.Name in : recordTypeOfCase AND ClosedDate <= ' + tendays;
         if(test.isRunningTest()) {
             query += ' limit 20';
         }
        
        System.debug('**************'+query);
     
    }
    
    //DataBase.Batchable Start method
    global database.querylocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, LIST<SObject> listData){ 
        system.debug('***********'+listData ) ;            
        List<Case> cases = (List<Case>)listData;
        
        List<Attachment> attachments = new List<Attachment>();
              
        List<Task> tasks = new List<Task>([Select id , (Select id from attachments) from Task where WhatID in : cases]);
        
        
        for(Task tsk : tasks){
            if(tsk.Attachments != null){
                attachments.addAll(tsk.Attachments);
            }
        }      
        
        
        
        List<Event> events = new List<Event>([Select id , (Select id from attachments) from Event where WhatID in : cases]);
        
       
        for(Event evt : events){
            if(evt.Attachments != null){
                attachments.addAll(evt.Attachments);
            }
        }      
        
        
        
        List<Attachment> attachList = [Select  ParentId, Name, Id From Attachment where ParentId in: cases];
        
        for(Attachment atch : attachList){
            attachments.add(atch);
        }      
        
        
        List<EmailMessage> emailMsgList = [Select Id, ParentId,(Select id from attachments) From EmailMessage where ParentId in: cases];
        
        for(EmailMessage emailMsg : emailMsgList){
            if(emailMsg.Attachments != null){
                attachments.addAll(emailMsg.Attachments);
            }
        }      
        
        if(attachments.size() > 0){
            delete attachments;
        }
    }
    
    global void finish(Database.BatchableContext BC){
         
    }
   @isTest(SeeAllData=true)
   
    public static void batchTest(){
       BatchDelAttachmentsForClosedCases batch = new BatchDelAttachmentsForClosedCases ();                
       Test.startTest();
       Database.executeBatch(batch , 20);
       Test.stopTest();
   }
   }