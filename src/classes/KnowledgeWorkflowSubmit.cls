public with sharing class KnowledgeWorkflowSubmit{
    private class kbException extends Exception{}
    public case c{get;set;}
    public id EditedId{get;set;}
    public KnowledgeWorkflowSubmit(ApexPages.StandardController ctl) {
        ctl.addFields(new List<String>{'id', 'Subject', 'Description','Final_Outcome__c','CaseNumber','Owner.name'});
        c = (case)ctl.getRecord();
    }
    
    
   public list<Article_Submission__c> ExistingRecords{
   get{
       if(ExistingRecords==null){
        ExistingRecords = [select id, name, title__c, Status__c, lastmodifiedbyid, lastmodifieddate from Article_Submission__c where Case_Source__c !=null AND Case_Source__c = : c.id order by lastmodifieddate DESC];
       }
       return ExistingRecords;
   }
   set;
   }
   
    public pagereference initKnowledgeWorkflowSubmit(){
        try{
            if(c.id==null){
                throw new KBException('This flow must be initiated from a Case.');
            } else if (ExistingRecords.size()==0){            
                PageReference p = new ApexPages.StandardController(createArticleSubmission()).edit();
                    p.setRedirect(true);
                return p;
            }   
            return null;
        }catch(exception e){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
             return null;
        }            
        
    }
    
    public Article_Submission__c createArticleSubmission(){
            try{
                Article_Submission__c A = new Article_Submission__c();
                   A.Case_Source__c = c.id;
                   A.title__c = c.subject;  
                   A.Article__c = c.description; 
                   A.Resolution__c = c.Final_Outcome__c; 
                   A.Internal_Note__c = c.CaseNumber + ' '+ c.Owner.name; 
                   A.Case_Source__c = c.id;
                   insert A;
                 return A;
               }catch(exception e){
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
                 return null;
            }
    }
    
    public pagereference createKBArticle(){
           try{   
                  PageReference p = new ApexPages.StandardController(createArticleSubmission()).Edit();
                  p.getParameters().put('retURL', c.id);
                  p.setRedirect(true);
                  return p;
        
            }catch(exception e){
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
                 return null;
            }
            
    }
    
    public PageReference EditArticle()
    {
        PageReference p = new ApexPages.StandardController(new Article_Submission__c(id=EditedId)).edit();
        p.getParameters().put('retURL', EditedId);
        p.setRedirect(true);
        return p;
    }
    
    

}