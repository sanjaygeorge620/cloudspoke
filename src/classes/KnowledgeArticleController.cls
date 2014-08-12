public class KnowledgeArticleController{
  /*http://www.salesforce.com/us/developer/docs/apexcode/Content/apex_pages_knowledgearticleversionstandardcontroller.htm*/
    
    // The constructor must take a ApexPages.KnowledgeArticleVersionStandardController as an argument
    public KnowledgeArticleController (ApexPages.KnowledgeArticleVersionStandardController ctl) {
        SObject article = ctl.getRecord();
        //Support_Articles__kav article = (Support_Articles__kav) ctl.getRecord();

        string sourceId = ctl.getSourceId(); //this returns the id of the case that was closed.
        Case c = [select subject, description, Owner.name, casenumber, Final_Outcome__c from Case where id=:sourceId];
            article.put('title', 'From Case: '+c.subject);  
            article.put('Article__c','<b>'+c.Subject+'</b></b><br />'+c.description); 
            article.put('Resolution__c',c.Final_Outcome__c); 
            article.put('Internal_Note__c',c.CaseNumber + ' '+ c.Owner.name);  
         }   
 
    /** Test for this custom extension controller
    */  
    
    public static testMethod void testKnowledgeArticleController() { 
         Account acc = Data_Account.createAccount();
         List<Contact> contacts = Data_Contact.createContacts(acc.Id,1); 
         List<Case> cases = Data_Case.createCase(acc, contacts[0], 'Product Support', 1);    
               
         String caseSubject = 'my test';
         String caseDesc = 'my test description';
            
         //Case c = new Case();
         Case c = cases[0];
          c.subject= caseSubject;
          c.description = caseDesc;
         upsert c;
         
         
         String caseId = c.id;
         System.debug('Created Case: ' + caseId);
         
         ApexPages.currentPage().getParameters().put('sourceId', caseId);
         ApexPages.currentPage().getParameters().put('sfdc.override', '1');
         
         ApexPages.KnowledgeArticleVersionStandardController ctl = new ApexPages.KnowledgeArticleVersionStandardController(new Support_Articles__kav());
         new KnowledgeArticleController(ctl);

         System.assertEquals(caseId, ctl.getSourceId());
         System.assertEquals('From Case: '+caseSubject, ctl.getRecord().get('title'));
   }
   
   
}