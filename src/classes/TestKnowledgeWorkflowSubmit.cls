@isTest(seealldata=true)

private class TestKnowledgeWorkflowSubmit {

    static testMethod void myUnitTest() {
      ApexPages.StandardController stndCont;
      
      account acc=new account();
      acc.name='test test2';
      acc.CurrencyIsoCode='USD';
      acc.Physical_Country__c='usa';
      acc.LX_Country_Code__c='us';
      acc.LXK_Region__c='see';
      acc.LX_Geo__c='emea';
      acc.PSW_Sales_Region__c='usa';
      
      insert acc;
      contact con=new contact();
      con.AccountId=acc.Id;
      con.LastName='test test1';
      insert con;
      case c1=new case();
      //c.CaseNumber='12345';
      c1.Subject='kabdcsdbv';
      c1.status='new';
      c1.Impact__c='user';
      c1.Urgency__c='low';
      c1.Origin='email';
      c1.type='problem';
      c1.contactId=con.Id;
      c1.RecordTypeID='012c00000004ZFJ';
      c1.Description='hvyujsv';
      c1.Final_Outcome__c='fdfbgdb';
      insert c1;
      pse__Region__c psa = new pse__Region__c(); 
      psa.name='test';
      psa.CurrencyIsoCode='USD';
      insert psa;
      pse__Practice__c pc=new pse__Practice__c();
      pc.name='test';
      pc.CurrencyIsoCode='USD';
      insert pc;
      pse__Grp__c pg=new pse__Grp__c();
  //     pg.Category_Value__c='test';
      pc.CurrencyIsoCode='USD';
      pg.name='test1';
      insert pg;
     pse__Proj__c ps =new pse__Proj__c();
     ps.name='test';
     ps.CurrencyIsoCode='USD';
     ps.pse__Region__c=psa.id;  
     ps.pse__Practice__c=pc.id;
     ps.pse__Group__c=pg.id;
     insert ps;
      Article_Submission__c art=new Article_Submission__c();
      art.Case_Source__c=c1.Id;
      art.Title__c='Test';
      insert art;
      ApexPages.CurrentPage().getParameters().put('id',c1.Id);
     KnowledgeWorkflowSubmit kw=new KnowledgeWorkflowSubmit(stndCont);
     kw.ExistingRecords=new list<Article_Submission__c>();
     kw.c=c1;
     kw.initKnowledgeWorkflowSubmit();
     kw.createKBArticle();
     kw.EditArticle();
     //list<Article_Submission__c> art=kw.ExistingRecords();
   
     }
     static testMethod void myUnitTest1() 
     {
             ApexPages.StandardController stndCont;
       
          KnowledgeWorkflowSubmit kw1=new KnowledgeWorkflowSubmit(stndCont);
           kw1.ExistingRecords=new list<Article_Submission__c>();
           kw1.initKnowledgeWorkflowSubmit();
            kw1.createKBArticle();
    }
    }