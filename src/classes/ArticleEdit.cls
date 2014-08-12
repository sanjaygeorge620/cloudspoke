public class ArticleEdit {
    public case c;

    public ArticleEdit(ApexPages.StandardController controller) {
        ids=ApexPages.CurrentPage().getParameters().get('ArtId');
        caseid=ApexPages.CurrentPage().getParameters().get('Id');
        system.debug('CaseId-->'+caseid);
        if(caseid!=null && caseid!='')
        {
            c=new case();
            c=[select id,Description,Subject from case where Id=:caseid limit 1];

        }

    }

    public Article_Submission__c art;
    public string ids;
    public string caseid;

    public Article_Submission__c getart()
    {
        if(ids!=null && ids!='')
        {
            art = [select Id,Article__c,Case_Source__c,Internal_Note__c,Product_Family__c,Resolution__c,Status__c,Title__c from Article_Submission__c where id=:ids];
        }
        else
        {
            art = new Article_Submission__c();
            if(c!=null)
            {
                art.Case_Source__c=c.Id;
                art.Resolution__c=c.Description;
                art.Title__c=c.Subject;

            }
            art.Status__c='Pending Submission';
        }

        return art;
    }

    public PageReference Save()
    {
        Database.upsert(art);
        PageReference p=new PageReference('/apex/KnowledgeWorkflowSubmit');
        return p;
    }
    public PageReference SaveNew()
    {
        Database.upsert(art);
        Article_Submission__c art = new Article_Submission__c();
        return null;
    }
    public PageReference Cancel()
    {
        PageReference p=new PageReference('/apex/KnowledgeWorkflowSubmit');
        return p;
    }
}